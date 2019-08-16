
"""
    borda_update!()

 Updates a set of Borda counts, given a new set of ranking data.
 Designed to be used iteratively over a set of rankings.

## Arguments
* `scores::DataFrame`: the current Borda counts for a list of candidates
* `ranking::DataFrame`: a set of rankings of candidates (which should overlap but isn't necessarily a subset of scores)

## Examples
```jldoctest
julia> scores = DataFrame( Title=["A", "B", "C"], Score=zeros(3) )
julia> ranking = DataFrame( Title=["A", "B", "D"], Ranking=[1, 2, 3] )
julia> borda_update!( scores, ranking )
julia> scores
3×2 DataFrame
│ Row │ Title  │ Score   │
│     │ String │ Float64 │
├─────┼────────┼─────────┤
│ 1   │ A      │ 3.0     │
│ 2   │ B      │ 2.0     │
│ 3   │ C      │ 0.0     │
```
"""
function borda_update!( scores::DataFrame, ranking::DataFrame )
    # https://en.wikipedia.org/wiki/Borda_count
    n = size(scores,1)
    
    for i=1:size(ranking,1)
        t = ranking[i,:Title]
        if !ismissing( ranking[i,:Ranking] )
            r = ranking[i,:Ranking]
        else
            r = size(ranking,1)
        end
        s = n - r + 1
        k = findfirst( scores[:,:Title] .== t )
        if k != nothing
            scores[k,:Score] += s
        end
    end

end

function dowdall_update!( scores::DataFrame, ranking::DataFrame; alpha::Float64=1.0 )
    # https://en.wikipedia.org/wiki/Borda_count
    n = size(scores,1)
    
    for i=1:size(ranking,1)
        t = ranking[i,:Title]
        if !ismissing( ranking[i,:Ranking] )
            r = ranking[i,:Ranking]
        else
            r = size(ranking,1)
        end
        s = 1/ (r^alpha)
        k = findfirst( scores[:,:Title] .== t )
        if k != nothing
            scores[k,:Score] += s
        end
    end

end

function preference_matrix_update!( preferences::Array{Int,2}, preference_list::DataFrame, ranking::DataFrame )
    # calculate the preference matrix for the input ranking
    m = size(preference_list,1)
    pref1 = zeros(eltype(preferences), n, n)
    for I=1:n
        i = findfirst( ranking[:,:Title] .== preference_list[I,:Title] )
        # println(" I = $I, i=$i ")
        for J=I+1:n
            j = findfirst( ranking[:,:Title] .== preference_list[J,:Title] )
            if i==nothing && j==nothing
                # nothing to do
            elseif j==nothing 
                # println(" >I = $I ($(preference_list[I,:Title])), J = $J ($(preference_list[J,:Title])), i=$i j=nothing")
                pref1[I,J] += 1
            elseif i==nothing 
                # println(" <I = $I ($(preference_list[I,:Title])), J = $J ($(preference_list[J,:Title])), j=$j i=nothing")
                pref1[J,I] += 1
            elseif ismissing(ranking[i,:Ranking]) && ismissing(ranking[j,:Ranking])
                # nothing to do
            elseif ismissing(ranking[j,:Ranking]) || (ranking[i,:Ranking] < ranking[j,:Ranking])
                # println(" >I = $I ($(preference_list[I,:Title])), J = $J ($(preference_list[J,:Title])), i=$i j=$j")
                pref1[I,J] += 1
            elseif ismissing(ranking[i,:Ranking]) || (ranking[i,:Ranking] > ranking[j,:Ranking])
                # println(" <I = $I ($(preference_list[I,:Title])), J = $J ($(preference_list[J,:Title])), i=$i j=$j")
                pref1[J,I] += 1
            end
        end
    end

    # update the old preference matrix
    preferences .+= pref1
end

function copeland_score(preferences::Array{Int,2})
    P = preferences .- preferences' # pairwise victories - pairwise defeats between each (i,j)
    return vec( sum( sign.(P); dims=2 ) )
end

function copeland2_score(preferences::Array{Int,2})
    P = preferences .- preferences' # pairwise victories - pairwise defeats between each (i,j)
    return vec( sum( P; dims=2 ) )
end

function condorcet_rank(preferences::Array{Int,2} ; method::String="Copeland")
    # https://en.wikipedia.org/wiki/Condorcet_method#Condorcet_ranking_methods
    if lowercase(method)=="copeland"
        # https://en.wikipedia.org/wiki/Copeland%27s_method
        r = copeland_score(preferences)
        ranking = sortperm(r; rev=true)
    elseif lowercase(method)=="second-order copeland"
        # https://en.wikipedia.org/wiki/Copeland%27s_method
        r = copeland2_score(preferences)
        ranking = sortperm(r; rev=true)
    elseif lowercase(method)==""
        # https://en.wikipedia.org/wiki/Kemeny%E2%80%93Young_method
        
    elseif lowercase(method)==""
        # https://en.wikipedia.org/wiki/Ranked_pairs
        
    elseif lowercase(method)==""
        # https://en.wikipedia.org/wiki/Schulze_method
        
    else
        error("method $method isn't implemented")
    end
end

# Report the Top-N elements of a DataFrame
function topN(scores::DataFrame, N::Int; col=:Score, rev=true)
    k = sortperm(scores, col; rev=rev)[1:N]
end

# put the scores on a rage from 0-1
function normalise( scores::Array{T,1}; rev=false ) where {T <: Number }
    r = ( scores .- minimum(scores) ) ./ ( maximum(scores) - minimum(scores) )
    if rev
        return 1 .- r
    else
        return r
    end
end
