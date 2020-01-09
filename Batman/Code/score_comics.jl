#
# use input ranks to construct final scores for graphc novels
#
using DataFrames
using CSV
include("utilities.jl")
include("ranking.jl")

data_dir = "../Data"
inp_data_dir = "$data_dir/InputRankings/"

file1 = "$data_dir/comic_list.csv"
comics = CSV.read(file1; comment="#")

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

c1 = condorcet_rank(preferences; method="copeland")
preference_list[c1,:]
s[:, :Copeland] = copeland_score(preferences)
# s[:, :Copeland_Rank] = sortperm(c1)

# c2 = condorcet_rank(preferences; method="second-order copeland")
# preference_list[c2,:]
# s[:, :Copeland_Rank2] = sortperm(c2)

Power=Symbol("Power (alpha=0.5)")
rename!(s, :Score=>:Borda)
rename!(s, :Score_1=>:Dowdall)
rename!(s, :Score_2=>Power)
s[:, :Dowdall] = round.( s[:, :Dowdall]; digits=3 )
s[:, Power] = round.( s[:, Power]; digits=3 )

sort!( s, Power; rev=true )
s[1:20, :]

CSV.write("$data_dir/batman_meta_ranking.csv", s)

N = 10
k1 = topN(s, N; col=:Borda)
k2 = topN(s, N; col=:Dowdall)
k3 = topN(s, N; col=Power)
k4 = topN(s, N; col=:Copeland)
# k5 = topN(s, N; col=:Copeland_Rank2, rev=false)
k = union(k1,k2,k3,k4)
s[sort(k),:]


