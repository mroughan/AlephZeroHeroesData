# make sure all data files are the latest version

all: FORCE
	./sync_files.jl
	git commit -a -m"updated data files"
	git push

# run every time
FORCE:
