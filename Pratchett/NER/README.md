This folder contains the results of Named Entity extraction from Terry
Pratchett's Discworld novels.

The files are in the form

 + BookNN.csv         -- contains an abbreviated set of data
 + Book NN - NAME.csv -- contains the full data
 + network_BookNN.csv  - contains the derived networks

The fields are
 + Name: the entities name
 + Frequency: the number of times the name (or its aliases) appeared in the text
 + NAliases: the number of aliases for a name
 + NSentences: the number of sentences in which a name appears (as a double check for Frequency)
 + Aliases: a CSV list of the aliases for that name (that appeared in this book)
 + Sentences: a CSV list of the sentence number in which a name appears (it can appear more than once per sentence)
 + Types: the classification of the entity
 + Subtypes: the sub-classification of the entity
 + Subsubtypes: the sub-sub-classification of the entity
 + R: the rimwise coordinate of a place (only where relevant)
 + T: the turnwise coordinate of a place (only where relevant)

Note that these are (more than some of my other files) a work in
progress.


