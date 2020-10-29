using DataFrames
import Base: +, round, append!

searchdir(path,key) = filter(x->match(key,x) != nothing, readdir(path))

function find_roman(s::String)
    # find Roman numerals, so we can remove these cases from the list
    # https://www.oreilly.com/library/view/regular-expressions-cookbook/9780596802837/ch06s09.html
    # r = r"\s(?=[MDCLXVI])M*D?C{0,4}L?X{0,4}V?I{0,4}$"
    #   gives roman numerals, but we are in the very low end, and also there are characters like
    #     Stacy X, Weapon XI,
    # also has the potential to remove "X Y the 2nd" in the wrong form
    r = r"\sI{0,4}V?I{0,3}$"
    m = match(r, s)
    return m != nothing
end

function increment!( d::Dict{S, T}, k::S, i::T) where {T<:Real, S<:Any}
    if haskey(d, k)
        d[k] += i
    else
        d[k] = i
    end
end
increment!(d::Dict{S, T}, k::S ) where {T<:Real, S<:Any} = increment!( d, k, one(T))

function decrement!( d::Dict{S, T}, k::S, i::T) where {T<:Real, S<:Any}
    if haskey(d, k)
        d[k] -= i
    else
        d[k] = -i
    end
end
decrement!(d::Dict{S, T}, k::S ) where {T<:Real, S<:Any} = increment!( d, k, one(T))

function append!( d::Dict{S, Array{T,1}}, k::S, x::Array{T,1}) where {T<:Any, S<:Any}
    if haskey(d, k)
        append!(d[k], x)
    else
        d[k] = x
    end
end

function increment!( d::Dict{S, Dict{S, T}}, k1::S, k2::S, i::T) where {T<:Real, S<:Any}
    if !haskey(d, k1)
        d[k1] = Dict{AbstractString, Real}()
    end
    if !haskey(d[k1], k2)
        d[k1][k2] = i
    else
        d[k1][k2] += i
    end
end
increment!(d::Dict{S, Dict{S, T}}, k1::S, k2::S ) where {T<:Real, S<:Any} = increment!( d, k1, k2, one(T))

# can replace this with "merge(+, D1, D2)" 
function +( D1::Dict{S, T},  D2::Dict{S, T} ) where {T<:Real, S<:Any}
    D = copy(D1)
    for k in keys(D2)
        increment!(D, k, D2[k])
    end
    return D
end

# indicator function
function I( D::Dict{String, T} ) where {T<:Real}
    D1 = copy(D)
    for k in keys(D1)
        D1[k] = 1
    end
    return D1
end
   
function sort_dict( D::Dict{String, T}) where {T<:Real}
    return sort(collect(D), by = tuple -> last(tuple), rev=true)
end

function conv_dict( df::DataFrame, key_col::Symbol; val_col::Symbol=:null)
    keytype = typeof(df[1,key_col])
    if val_col == :null
        valtype = Int
    else
        valtype = typeof(df[1,val_col])
    end
    D = Dict{keytype, valtype}()
    for i=1:size(df,1)
        if !ismissing(df[i,key_col])
            if val_col == :null
                increment!( D, df[i,key_col] )
            elseif valtype <: Real
                increment!( D, df[i,key_col], df[i,val_col] )
            else
                if haskey(D, df[i,key_col])
                    @warn("non-unique entry: $(df[i,key_col])")
                else
                    D[df[i,key_col]] = df[i,val_col]
                end
            end
        end
    end
    return D
end

function extract_js( file::String; width=100, height=100, div="body" )

    s = read(file, String)
    m = match(r"<body>(.*)</body>"s, s)
    s2 = m[1]

    s2 = replace( s2, r"WIDTH_IN_PERCENT_OF_PARENT\s+=\s+\d+" => "WIDTH_IN_PERCENT_OF_PARENT = $width" )
    s2 = replace( s2, r"HEIGHT_IN_PERCENT_OF_PARENT\s+=\s+\d+" => "HEIGHT_IN_PERCENT_OF_PARENT = $height" )
    s2 = replace( s2, r"Plotly.d3.select\('body'\)" => "Plotly.d3.select('$div')" )
    
    new_file = replace(file, ".html" => ".js" )
    write(new_file, s2)
end
