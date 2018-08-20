#!/bin/bash

echo "kiling"
killall -9 rstudio

echo "opening"
xdg-open /home/miriam/git/ED2ToolsMRJ/ED2Summary_CompanionFxns/ED2SummaryRMD.Rmd
