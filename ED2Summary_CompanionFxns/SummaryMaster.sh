#!/bin/bash
ED2INdir='/mnt/odyssey/moorcroftfs5/mjohnston/ED2_Ashehad/Case7.6/run048/'; analydir='/mnt/odyssey/moorcroftfs5/mjohnston/ED2_Ashehad/Case7.6/run048/analy/'; srcdir='/mnt/odyssey/moorcroftfs5/mjohnston/ED2_Ashehad/Case7.6/ED/src/'

export ED2INdir
export analydir 
export srcdir

sh /home/miriam/Dropbox/Harvard/Rpackages/ED2ToolsMRJ/ED2Summary_CompanionFxns/ED2Summary_openRMD.sh
sh /home/miriam/Dropbox/Harvard/Rpackages/ED2ToolsMRJ/ED2Summary_CompanionFxns/ED2Summary_knitRMD.sh
