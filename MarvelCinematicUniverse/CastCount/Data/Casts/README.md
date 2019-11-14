There are several main groups of files here:

In many cases there are two files. The CSV file is the raw data, which
is what we use. The TXT file is in a more convenient, human readable
format for validation. 

1. IMDB derived cast lists (for each movie):
       imdb_<movie name>.<suffix>

   Fields:
   + Actor: actor name as given in IMDB.
   + Character: character name as given in IMDB [1].
   + Named: is the character name a proper name [2].
   + Uncredited: is the role listed as uncredited in IMDB.
   + Voice: is the actor listed as a voice actor in IMDB.

2. Movie summary statistics 

   numbers.<suffix> -- basic statistics for each movie
      
   Fields:
   + Title
   + ReleaseYear
   + Total: total number of characters listed in IMDB.
   + Named: number of named characters [2]. 
   + Credited: number of credited characters as listed in IMDB.
   + Voice : number of voice actor roles.

[1] See aliases file to map these to canonical names.

[2] See paper for more information.
