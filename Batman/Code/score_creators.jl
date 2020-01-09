#
# use input ranks to construct final scores for graphc novels
#
using DataFrames
using CSV
using Statistics
include("utilities.jl")
include("ranking.jl")

data_dir = "../Data"
inp_data_dir = "$data_dir/InputRankings/"

file1 = "$data_dir/comic_list.csv"
comics = CSV.read(file1; comment="#")

# UNCOMMENT THE LINE TO SCORE DIFFERENT TYPES OF CREATORS
creator = "Script"
creator = "Pencils"
creator = "Cover"
creator = "Inks"
creator = "Colors" 
creator = "Letters"
creator_type = Symbol(creator)


file2 = "$data_dir/comic_list_writer_artist.csv"
write_artist = CSV.read(file2; comment="#")
k = findall(ismissing.(write_artist[creator_type]))
if ~isempty(k)
    println(k)
    println( write_artist[k,:] )
    error("missing entries for $creator")
end

write_artist[creator_type] = String.(write_artist[creator_type])
write_artist[:N] = length.(split.( write_artist[:,creator_type], '/' ))
comics = join( comics, write_artist; on = :Title )

scores = DataFrame( Title=comics[:,:Title], Score=zeros(size(comics[:,:Title])) )
scores_d = DataFrame( Title=comics[:,:Title], Score=zeros(size(comics[:,:Title])) )
scores_a = DataFrame( Title=comics[:,:Title], Score=zeros(size(comics[:,:Title])) )

preference_list = DataFrame( Title=comics[:,:Title] )
# preference_list = DataFrame( Title = [ "Batman: Year One"                        
#         "Batman: The Dark Knight Returns"         
#         "Batman: The Long Halloween"              
#         "Batman: The Killing Joke"                
#         "Batman: Arkham Asylum"                   
#         "Batman: Hush"                            
#         "Batman: A Death in the Family"           
#         "Batman: Knightfall, Part One: Broken Bat"
#         "Batman Volume 1: The Court of Owls"      
#         "Batman: The Black Mirror"                
#         "Batman: The Cult"    ])
n = size(preference_list,1)
preferences = zeros(Int,n,n)
    
# test which names are in the rankings and try adding scores
files = searchdir(inp_data_dir, r"ranking_.*.csv$")
# files = filter(x->match(r"alt",x)==nothing, files)
for (i,f1) in enumerate(files)
    println("reading $f1")
    df = CSV.read( "$inp_data_dir/$f1"; comment="#" )
    for j=1:size(df,1)
        if isempty( findall( df[j,:Title] .== skipmissing(comics[:,:Title])) )
            @warn("Missing title $(df[j,:Title]) from $(f1)")
        end
    end

    borda_update!( scores, df )
    dowdall_update!( scores_d, df )
    power_update!( scores_a, df; alpha=0.5 )
    preference_matrix_update!( preferences, preference_list, df )
end

s = join( scores, scores_d, on=:Title, makeunique=true)
s = join( s, scores_a, on=:Title, makeunique=true)

Power=Symbol("Power (alpha=0.5)")
rename!(s, :Score=>:Borda)
rename!(s, :Score_1=>:Dowdall)
rename!(s, :Score_2=>Power)
s[:, :Dowdall] = round.( s[:, :Dowdall]; digits=3 )
s[:, Power] = round.( s[:, Power]; digits=3 )

# put the artists and title together with the scores
s = join( s, write_artist[ [:Title, creator_type, :N] ]; on = :Title )
deletecols!(s, :Title )

# remove cases with more than X artists, or "na" because there was no artist of this type
max_team_size = 3
filter!(row -> row[:N] <= max_team_size, s)
filter!(row -> row[creator_type] != "various", s)
filter!(row -> row[creator_type] != "na", s)
deletecols!(s, :N )
s[:N] = ones(Int,size(s,1))

# check
if creator_type == :Script
    FM = filter(row -> row[creator_type] == "Frank Miller", s)
    JL = filter(row -> row[creator_type] == "Jeph Loeb", s)
    GM = filter(row -> row[creator_type] == "Grant Morrison", s)
end

# add up scores for each writer
A = aggregate(s, creator_type, sum)
rename!( A, Symbol("Power (alpha=0.5)_sum") => Power)
rename!( A, Symbol("Borda_sum") => :Borda)
rename!( A, Symbol("Dowdall_sum") => :Dowdall)
rename!( A, Symbol("N_sum") => :N)
sort!( A, Power; rev=true )

A[Symbol("Average (power)")] = A[Power] ./ A[:N]
# sort!( A, :Average; rev=true )

file = "$data_dir/batman_meta_ranking_$(lowercase(creator)).csv"
CSV.write(file, A)

A[1:20, :]
