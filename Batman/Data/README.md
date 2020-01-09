This directory contains data related to the meta-top-10 Batman graphic
novels listing. 

## What is here

We are aiming to record a "graphic novel", which could be
- a one-shot novel
- the collection of a story-line from a given series
- a collection from a cross-over series that appears under several
  brand names
- a collection of "archival" reprints of issues from the past

The main thing is that it be a "self-contained" "book" that I could in
theory buy assuming it was still in print.

Not all titles are consistent, and so some titles in InputRankings
have been altered from their original source listings to be
consistent. 

We aim to get the 1st version of a collection (sometimes they are
republished as deluxe or special or boxed versions). However, there
can be ambiguity because a storyline can be broken into different
sized chunks, e.g., volumes, or collected together. Many ranking lists
are ambiguous about the exact version they mean. Where it is
ambiguous, we usually refer back to "Volume 1" of the first collected
form, if that can be ascertained. 

For collections
- dates in comics lists are intended to be first publication dates,
  not the date of a subsequent collection
- titles are common name of the collection, not the individual issues,
  as these can vary wildly for one storyline

Printings was and attempt to get the number of printings and
re-printings of a given story line, but the data often isn't easily
available, or is unreliable, so I stopped even trying to get it.

Sources are URLs from when the data was obtained, sometimes by
following individual links to issues referenced. 

The best source, when available, seems in the long run to be

    https://dc.fandom.com/

Wikipedia is often very good, but not uniform in how it presents
information. DC's own web pages are surprisingly incomplete or
sometimes refer to the version they want to sell, not the version I
want to record (e.g., publication dates).

Creators are grouped into
   + writer
   + cover artists
   + penciller
   + inkers
   + colourists
   + letters
Each can include multiple (slash separated) creators. In some cases so
many people were involved and it was hard to determine from public
data exactly who was involved that we just say "various". We aim for
cover artists to refer to the cover artist of the collection, but if
this is not clear it will usually be the cover artist of the first
issue included in the volume.

When multiple creators are listed, the ordering is arbitrary, but
usually ordered by time (in the case of serials). 

If multiple sources disagree, we include all listed creators, but the
focus is on the creators of core content, not spin offs. 

In some cases the number of creators was very large, and instead of
listing all we have just listed them as "various".

In some cases a certain type of creator was not involved, and is then
listed as "na".

The list of "robins" is the least carefully compiled and checked data
so far. Should be used with a pinch of salt. 



## What isn't there

In hindsight, should have recorded

+ editors, where available.

+ a "type" e.g., one-shot v storyline v (un-associated) collection,
  and the issues that go into it in the latter two cases.

+ a "full" list of participating characters, and their role (good v
  bad, supporting, neutral ...)

Maybe able to scrape this from dc.fandom.com using the sources given,
but will need to go into the issues to get.


## Specific file descriptions:

+ comic_list.csv a list of basic information about the Batman graphics novels being ranked
+ batman_creators.csv = comic_list_writer_artist.csv a list of creators for each book
+ batman_meta_ranking.csv a ranking of the books with scores
+ batman_meta_ranking_X.csv a ranking of X for X=script,cover,pencils,inks,colors,letters
+ batman_meta_ranking_creators.csv top ten for each creator types compiled into one table
+ batman_meta_ranking_creators_sorted.csv all creators sorted into one ranking
+ batman_meta_ranking_creators_sorted.csv all creators grouped then sorted into one ranking
