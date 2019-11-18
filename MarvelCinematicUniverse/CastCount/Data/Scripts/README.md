There are several main groups of files here:

1. script_text.json

   is a JSON file with the full collected transcripts. The source meta-atribute indicats how the script was collected. Online scripts were collected from https://transcripts.fandom.com/wiki/<name_of_film> on the 17th of November. The transcript format reflects the style of text written on the website and differs between the films. PDF transcripts we extracted from the available PDFs in the ScriptPDFs folder.  

2. Lists (for each movie) of characters with their frequency of interaction
      
   Fields:
   + Character: character names (note these are not all canonical)
   + Frequency: frequency with which they appear (in dialogue [2]) in the movie

3. summary statistics 

   shannon_numbers.<suffix> -- summary statistics for effective cast
                               size based on number of conflicts

   Fields:
   + Title
   + NoOfLines: number of lines of dialogue in the data (some are incomplete -- see below)
   + NoOfSpeakers: number of speaking characters (in the file)
   + Tobin: Tobin's alternative metric calculation (without bias correction)
   + Shannon: shannon entropy based effective cast size metric
   + CI_m: lower 95th percentile confidence interval for Shannon
   + CI_p: upper 95th percentile confidence interval for Shannon
   + Complete: a number indicating completeness: 1.0=complete, 0.5=almost complete, 0.0=partial


[1] See aliases file to map these to canonical names.

