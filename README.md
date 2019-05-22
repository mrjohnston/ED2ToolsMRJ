# ED2ToolsMRJ
ED2 post-processing tools

Contains basic functions for dealing with ED2 output.

#########################################################################################

Note: There is no longer an ExtractVar function in this package, since it is much better to do this directly on Odyssey!

To extract a variable into an R-friendly RDS file:

nano ~/git/general/VarExtractED2/runscript.sh
[EDIT AS NECESSARY]
./runscript.sh
--> Outputs will be in an "R" folder in the model run folder
--> Typically, you do not have to edit batchscript.txt or ExtractVar_array.R

#########################################################################################

To look at h5 output directly on Odyssey, two main options:

(1) hdfview.sh h5file.h5
(2) h5dump h5file.h5 | less
--> 'gg' will take you back to the top; 'n' is next, 'N' is previous
