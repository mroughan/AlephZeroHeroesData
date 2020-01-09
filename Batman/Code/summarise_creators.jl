# summarise the top-10 creators into one big table
using DataFrames
using CSV
using Printf
include("utilities.jl")
include("ranking.jl")

function compute(name::AbstractString, n::Integer, score::AbstractFloat)
    return "$name ($n, $(round(score; digits=2)))"
end

function compute2(name::AbstractString, n::Integer, score::AbstractFloat)
    return "$name ($(round(score; digits=2)))"
end

function tooltip(n::Integer, score::AbstractFloat, comics::AbstractString )
    return "Total score=$(round(score; digits=2))<br>\n$comics"
end

data_dir = "../Data"
inp_data_dir = "$data_dir/InputRankings/"

file1 = "$data_dir/comic_list.csv"
comics = CSV.read(file1; comment="#")

file2 = "$data_dir/comic_list_writer_artist.csv"
write_artist = CSV.read(file2; comment="#")

maxN = 10

creator_types = ["Script", "Pencils", "Cover", "Inks", "Colors", "Letters"]
Creator_types = Symbol.(creator_types)
Power=Symbol("Power (alpha=0.5)")

top10_name  = DataFrame(repeat( [String],  length(Creator_types)),  Creator_types, maxN)    
top10_N     = DataFrame(repeat( [Int64],   length(Creator_types)),  Creator_types, maxN)    
top10_score = DataFrame(repeat( [Float64], length(Creator_types)),  Creator_types, maxN)
top10_tooltip = DataFrame(repeat( [String], length(Creator_types)),  Creator_types, maxN)
top10       = DataFrame(repeat( [String],  length(Creator_types)),  Creator_types, maxN)
for (i,c) in enumerate(creator_types)
    file = "$data_dir/batman_meta_ranking_$(lowercase(c)).csv"
    top_list = CSV.read(file; comment="#")
    names = top_list[ 1:maxN, Creator_types[i] ]
    n     = top_list[ 1:maxN, :N]
    score = top_list[ 1:maxN, Power]
    
    top10_name[ Creator_types[i] ]  = names
    top10_N[ Creator_types[i] ]     = n
    top10_score[ Creator_types[i] ] = score

    comics = Array{String, 1}(undef, maxN)
    for j=1:maxN
        k = findall( write_artist[:,Creator_types[i]] .==  names[j] )
        comics[j] = "<ul> <li>" * join(  write_artist[k,:Title], "</li><li>" ) * "</li></ul>"
    end
    
    top10_tooltip[ Creator_types[i] ] = comics
    top10[ Creator_types[i] ] = compute2.( names, n, score )
end

file10 = "$data_dir/batman_meta_ranking_creators.csv"
CSV.write(file10, top10)
top10

#
# write a HTML version of the table
#   with tooltips (which is why I can't do this automatically) 
file_html = "$data_dir/batman_meta_ranking_creators.html"
fid = open( file_html, "w" )
println(fid, "<div class=\"ui\" id=\"table1\"><table>")
println(fid, "  <caption>Table 1: Meta-Top-10 creator lists.</caption>")
println(fid, "  <tr>")
for (j,c) in enumerate(creator_types)
    print(fid, "     <th>")
    print(fid, " $c ")
    println(fid, " </th>")
end
println(fid, "  </tr>")
for i=1:maxN
    println(fid, "  <tr>")
    for (j,c) in enumerate(creator_types)
        print(fid, "     <td style=\"min-width: 8em;\">")
        print(fid, " <div class=\"tooltip\"> <span class=\"tooltiptext\" style=\"min-width: 8em;\">$(top10_tooltip[i,Creator_types[j]])</span> $(top10[i,Creator_types[j]]) </div>")
        println(fid, " </td>")
    end
    println(fid, "  </tr>")
end
println(fid, "</table></div>")
close(fid)



###
### now put together a list of all creators in order
###
df1 = stack(top10_score, Creator_types;  variable_name=:CreatorType, value_name=:Score)
df2 = stack(top10_name, Creator_types;  variable_name=:CreatorType, value_name=:Name)
df3 = stack(top10_N, Creator_types;  variable_name=:CreatorType, value_name=:Number)
# df = join( df1, df2 ; on=:Row, makeunique=true )
df = df2
df[ :Score ] = df1[ :Score ]
df[ :Number ] = df3[ :Number ]
sort!(df, [:Score]; rev = true)

df_out = copy(df)
df_out[:Score] = map( (x) -> @sprintf("%.2f", round(x; digits=2)), df[:Score] ) 
permutecols!(df_out, [:Name, :CreatorType, :Score, :Number])

file_biglist = "$data_dir/batman_meta_ranking_creators_sorted.csv"
CSV.write(file_biglist, df_out)


###
### now put together a list of all creators in order, but grouping contributions
###

function agg_fn(x)
    if eltype(x) <: Number
        sum(x)
    elseif eltype(x) <: AbstractString
        join(x, ",")
    elseif eltype(x) <: Symbol
        join( String.(x), ",")
    end
end

A = aggregate( groupby(df, :Name), agg_fn)
rename!( A, Symbol("CreatorType_agg_fn") => :CreatorTypes)
rename!( A, Symbol("Score_agg_fn") => :Score)
rename!( A, Symbol("Number_agg_fn") => :Number)
sort!(A, [:Score]; rev = true)
A_out = copy(A)
A_out[:Score] = map( (x) -> @sprintf("%.2f", round(x; digits=2)), A[:Score] ) 

file_biglist2 = "$data_dir/batman_meta_ranking_creators_sorted2.csv"
CSV.write(file_biglist2, A_out)
