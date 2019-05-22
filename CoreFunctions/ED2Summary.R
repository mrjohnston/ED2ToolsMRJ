#' ED2 Model Result Diagnosis
#' 
#' ED2 sanity check 
#' 
#' @param ED2INdir Directory containing ED2IN (character string, with terminal "/")
#' @param analydir Directory containing the result h5 files (character string, usually ending in "analy", with terminal "/")
#' @param srcdir Directory contaning the ED src files for this model (character string, ending in "src", with terminal "/")
#'  
#' @return Summary PDF document - an ED2 "sanity check" summarizing the plants and carbon/water/energy fluxes.
#' 
#' @section Important notes on this function: \itemize{
#' \item ***This function will close & re-open your RStudio, deleting environment variables***
#' \item This function always saves the PDF as: \cr
#' ED2INdir/ED2Summary.pdf
#' \item This function has quite a few companion scripts, all in: \cr
#' ED2ToolsMRJ/ED2Summary_CompanionFxns
#' } 
#' 
#' @examples 
#' ED2INdir<-"/mnt/odyssey/moorcroftfs5/mjohnston/ED2_Ashehad/Case7.6/run048/"
#' analydir<-"/mnt/odyssey/moorcroftfs5/mjohnston/ED2_Ashehad/Case7.6/run048/analy/"
#' srcdir<-"/mnt/odyssey/moorcroftfs5/mjohnston/ED2_Ashehad/Case7.6/ED/src/"
#' 
#' ED2Summary(ED2INdir,analydir,srcdir)
#' 
#' @export
#' 

ED2Summary<-function(ED2INdir,analydir,srcdir){
  
  #Put the given directories & the move file command into the SummaryMaster.sh file
  dirs<-paste0('ED2INdir=',"'",ED2INdir,"'","; ",
              'analydir=',"'",analydir,"'")  
  toed=readLines("/home/miriam/git/ED2ToolsMRJ/ED2Summary_CompanionFxns/SummaryMaster.sh")
  toed[2]<-dirs
  
  # Set up command for putting result in the ED2IN directory
  movecommand=paste0("mv /home/miriam/git/ED2ToolsMRJ/ED2Summary_CompanionFxns/ED2SummaryRMD.pdf ",ED2INdir,"ED2SummaryRMD.pdf")
  toed[10]<-movecommand
  
  writeLines(toed,"/home/miriam/git/ED2ToolsMRJ/ED2Summary_CompanionFxns/SummaryMaster.sh")
  
  
  #Run the SummaryMaster.sh file --> calls ED2Summary_openRMD & ED2Summary_knitRMD
  system("sh /home/miriam/git/ED2ToolsMRJ/ED2Summary_CompanionFxns/SummaryMaster.sh")

}


