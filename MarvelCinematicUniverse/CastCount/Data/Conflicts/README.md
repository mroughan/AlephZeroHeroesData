There are several main groups of files here:

In many cases there are two files. The CSV file is the raw data, which
is what we use. The TXT file is in a more convenient, human readable
format for validation. 

1. The main file is a large Excel spreadsheet
        marvel_cinematic_universe_conflict.xlsx
   which contain lists of conflicts for each movie. The file consists
   of a set of sheets, one for each movie, and a small set of
   supplementary information sheets at the start.

   The format for a single sheet is:
       + a header (first 4 lines) giving the title, and run through
       + a list of conflicts
         The list if divided into sequences with mostly blank lines indicating a new sequence

       	 Fields
		Context: location (free form text) only at the start of a sequence, with lines of dashes to separate sequences
		Timestamp: time of conflict in mm.ss format.
		Type of conflict: [2]
		Party A:
		A Enhancement: a number indicated how the character is positive or negatively enhanced in the conflict
		Party B:
		B Enhancement: a number indicated how the character is positive or negatively enhanced in the conflict
		Outcome: the victor (by name) or "inconclusive"
		Factors ...: the reasons for the enhancements listed above
       		Notes: additional information (free form text)

         All party names should be canonicalised version of the
         superhero name (where there is one). 		

       + The list of conflicts is ended by "EOL" in the timestamp
         column. After this some supplementary information is
         included. It included for validation only. The structure of
         this information varies. Please use other datasets for more
         precise lists of characters etc.
       
2. Lists (for each movie) of characters with their frequency of interaction
      
   Fields:
   + Character: canonical character names
   + Frequency: frequency with which they appear (in conflicts [2]) in the movie

3. Movie summary statistics 

   shannon_numbers.<suffix> -- summary statistics for effective cast
                               size based on number of conflicts

   Fields:
   + Title
   + TypeOfMovie: origin story | sequel # | team up [2]
   + RunThrough: some movies were analysed more than once. By default use highest run through.
   + NoOfConflicts: total number of observed conflicts
   + Shannon: shannon entropy based effective cast size metric
   + CI_m: lower 95th percentile confidence interval for Shannon
   + CI_p: upper 95th percentile confidence interval for Shannon


[1] See aliases file to map these to canonical names.

[2] See paper for more information.
