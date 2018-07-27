#!/bin/bash

#INPUTS ####################################################################

#---------------------------------------------------------------------------
#    Vars to Extract
#    No commas separating vars
#    (ex) arr=("var1" "var2" "var3")
#    (ex) arr=("var1")
#---------------------------------------------------------------------------

declare -a arr=("LEAF_TEMP" "LAI")

#---------------------------------------------------------------------------
#    Directory with HDF5 files
#    No slash at the end
#    (ex) direc = "/n/moorcroftfs5/mjohnston/ED2_timeoutput/Case2/run002/analy"
#---------------------------------------------------------------------------

direc=/n/moorcroftfs5/mjohnston/ED2_timeoutput/Case2/run004/analy

#---------------------------------------------------------------------------
#    tscale of vars to extract
#    Only one possible at a time 
#    (ex) tscale = "D"
#---------------------------------------------------------------------------

tscale=D

#---------------------------------------------------------------------------
#    Specification of files from which to extract data. Options:
#    RANGE. Extract between from file "first" to file "last" (inclusive).
#	 (ex) extract_option = "RANGE"; first = "tonzi-D-2001-07-01-000000-g01.h5"; last = "tonzi-D-2001-07-09-000000-g01.h5"
#	      (doesn't matter what "singlefile" is)
#    SINGLE. Extract from a single file
#	 (ex) extract_option = "SINGLE"; singlefile = "tonzi-D-2001-07-01-000000-g01.h5"
#	      (doesn't matter what "first" and "last" are)
#    ALL. Extract from all files in the directory with the specified tscale
#	 (ex) extract_option = "ALL"
#	      (doesn't matter what "first", "last", and "singlefile" are)
#---------------------------------------------------------------------------

extract_option=ALL
first=
last=
singlefile=

############################################################################

### Setting the output directory for the extracted vars & output files
outdir=${direc:0:${#direc}-6}
outdir+="/R/"
mkdir -p $outdir
chmod 777 $outdir
cd $outdir

### Exporting vars
export direc
export tscale
export extract_option
export first
export last
export singlefile

### Notifying user of choices
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Extracting from: $direc
echo Extracting to: $PWD
echo tscale: $tscale
echo Extract option: $extract_option
echo First file: $first , Last file: $last , Single file: $singlefile
echo [Note: extract option overrides specification of first, last, singlefile where relevant]
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

###Loop through variables to extract, submit job for each
for i in "${arr[@]}"; do
echo "$i"
export i
sbatch -o out_$extract_option.$tscale.$i.out -e out_$extract_option.$tscale.$i.err ~/code/VarExtractED2/batchscript.txt 
sleep 2
done
