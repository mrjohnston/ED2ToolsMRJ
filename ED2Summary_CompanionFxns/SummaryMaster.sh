#!/bin/bash
ED2INdir='/mnt/odyssey/moorcroftfs5/mjohnston/gitruns/run008/'; analydir='/mnt/odyssey/moorcroftfs5/mjohnston/gitruns/run008/analy/'

export ED2INdir
export analydir 

sh /home/miriam/git/ED2ToolsMRJ/ED2Summary_CompanionFxns/ED2Summary_openRMD.sh
sh /home/miriam/git/ED2ToolsMRJ/ED2Summary_CompanionFxns/ED2Summary_knitRMD.sh

mv /home/miriam/git/ED2ToolsMRJ/ED2Summary_CompanionFxns/ED2SummaryRMD.pdf /mnt/odyssey/moorcroftfs5/mjohnston/gitruns/run008/ED2SummaryRMD.pdf
