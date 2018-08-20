#!/bin/bash

echo "This bash script programmatically clicks the 'Knit' button in RStudio to render ED2SummaryReport.Rmd. Sadly, it's necessary to render this way because scripting the knit (in R) results in a poorly-formatted document (maybe because of an incorrect Tex version? but updating didn't help)."
echo "Script dependencies: wmctrl and xdotool"
echo "Troubleshooting:"
echo "[1] check to make sure there is only one open window with the word 'RStudio' in its title. Use: 'wmctrl -l'"
echo "[2] increase sleep time (in ED2Summary.sh). It's possible that the .Rmd hasn't fully opened before the rendering is requested."

#Open the R Markdown file 
#echo "opening RMD"
#xdg-open /home/miriam/Dropbox/Harvard/Rpackages/ED2ToolsMRJ/ED2SummaryRMD.Rmd

#Allow some time for opening to complete
echo "sleeping for 5 seconds"
sleep 5

#Identify the RStudio window
echo "identifying the RStudio window"
winID=$(wmctrl -l | awk '/RStudio/ {print $1}')

#Move to the last tab of the R Studio, aka the RMD file
#echo "moving to last tab of RStudio = RMD file"
#xdotool key --window $winID Ctrl+Shift+F12

echo "sleeping for 2 seconds"
sleep 2

#Use xdotool to do Crtl+Shift+K to knit the file
echo "Ctrl+Shift+K to knit the RMD"
xdotool key --window $winID Ctrl+Shift+K

#Move the result file to the appropriate folder
movecommand

