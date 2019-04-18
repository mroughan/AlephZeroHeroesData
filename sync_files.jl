#!/usr/bin/julia1.0
using TOML

"""
    simple little script to keep files sync'd with latest updates

    see https://discourse.julialang.org/t/how-to-solve-problem-with-toml-jl/9319
      to install a working version of TOML

"""

web_repo = "/home/mroughan/Dropbox/www/aleph-zero-heroes/static/csv/"
config = TOML.parsefile("../source_list.toml")

for k in keys(config["Sources"])
    println("Source $k")
    src = config["Sources"][k]["SRC_DIR"]
    dst = config["Sources"][k]["DST_DIR"]
    if typeof(config["Sources"][k]["FILES"]) <: Array
        files = config["Sources"][k]["FILES"]
    elseif typeof(config["Sources"][k]["FILES"]) <: String
        files = strip.(split(config["Sources"][k]["FILES"], ","))
    else
        error("improper config type: typeof(FILES) = $(typeof(config["Sources"][k]["FILES"])), ")
    end
    for f in files
        cmd = `rsync -a $src/$f $dst/$f`
        println("    $cmd")
        run(cmd)

        # and also copy files to the web repository, but this is fraught because all old pages could break
        # cmd = `rsync -a $src/$f $web_repo/$f`
        # println("    $cmd")
        # run(cmd)
    end
end
