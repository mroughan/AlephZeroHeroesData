#
# read in data to a DataFrame to check
#
using DataFrames
using CSV
include("utilities.jl")
include("ranking.jl")

data_dir = "../Data"
inp_data_dir = "$data_dir/InputRankings/"

file1 = "$data_dir/comic_list.csv"
println("reading $file1")
comics = CSV.read(file1; comment="#")
comics[:N] = zeros(Int,size(comics,1))
C1 = conv_dict( comics, :Title )

file2 = "$data_dir/comic_list_writer_artist.csv"
println("reading $file2")
write_artist = CSV.read(file2; comment="#")
C2 = conv_dict( write_artist, :Title )
missing_artists = setdiff( keys(C1), keys(C2) )

file3 = "$data_dir/comic_list_robin.csv"
println("reading $file3")
robins = CSV.read(file3; comment="#")
C3 = conv_dict( robins, :Title )
missing_robins = setdiff( keys(C1), keys(C3) )

missing_comics = setdiff( union(keys(C2), keys(C3)), keys(C1) )

comics = join( comics, write_artist; on = :Title )
comics = join( comics, robins; on = :Title )

# test which names are in the rankings and try adding scores
files = searchdir(inp_data_dir, r"ranking_.*.csv$")
# files = filter(x->match(r"alt",x)==nothing, files)
for (i,f1) in enumerate(files)
    println("reading $f1")
    df = CSV.read( "$inp_data_dir/$f1"; comment="#" )
    for j=1:size(df,1)
        k = findall( df[j,:Title] .== skipmissing(comics[:,:Title]))
        if isempty( k )
            @warn("Missing title $(df[j,:Title]) from $(f1)")
        elseif length(k) > 1
            @warn("Title $(df[j,:Title]) appears more than once")
        else
            comics[k[1],:N] += 1
        end
    end
end
minimum(comics[:N])



