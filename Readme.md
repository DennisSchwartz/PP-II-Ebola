Readme:

* Get Sequence from File
* Run PredictProtein
* Get SNAP raw data
* Run extract-subst.pl, pipe to File
* Run perl analysis.pl <SNAP-Output> <Extract-Subst-Output>, pipe to file
* Run awk '$2 == "Non-neutral" { print $1 " " $2 " " $3 " " $4 }' <previousOutput> > <EndResult>