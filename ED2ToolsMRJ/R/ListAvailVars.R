#' List the ED2 variables that are available for extraction
#' 
#' @param direc Directory where there are ED2 .h5 output files (character string)
#' @param tscale Time scale for relevant files (character vector, may have multiple entries)
#' @param varsnippets Text which the variable name should match (optional, character vector; without varsnippets all var names in tscale will print)
#' @return Names of variables available by tscale
#' @examples
#' 
#' direc<-"/n/moorcroftfs5/mjohnston/ED2_timeoutput/Case2/run004/analy/"
#' 
#' #Outputs all variable names in "D" or "I" files with the text "TEM" or "NEP"
#' ListAvailVars(direc=direc,tscale=c("D","I"),varsnippets=c("TEM","NEP"))
#' 
#' #Outputs all variable names in "D" files
#' #' ListAvailVars(direc=direc,tscale="D"))
#' 
#' @export


ListAvailVars<-function(direc,tscale,varsnippets){
  #direc is directory in which to look (full directory, in quotes)
  #tscale may have one or multiple entries, i.e. c("I","D") or just "I"
  #varsnippets is optional; use if looking for particular variables. May have one or multiple entries.
  #ex: ListAvailVars("/home/dir",c("I","D"),c("LEAF","FSW"))
  #Output: Extractable variables in the directory & tscale, matching the snippet is provided 

  library(rhdf5)
  
  listfiles<-dir(direc)

  vars<-vector("list", length(tscale)) #empty list

#Get all the names of variables in the t scales specified

  for (i in 1:length(tscale)){
    file<-subset(listfiles,grepl(paste("-",tscale[i],"-",sep=""),listfiles))[1]#Pick the first hourly file, as an example
    if(!is.na(file)){
      vars[[i]]<-h5ls(paste(direc,"/",file,sep=""))$name
      names(vars)<-tscale
    }
  }

#Print the names

  if(missing(varsnippets)){
    print(vars)
  } else {

#Or, if 'snippets' are included, print a subset of the names

    to_extract<-vector("list", length(tscale)) #Empty list
    for (k in 1:length(tscale)){
      for (m in 1:length(varsnippets)){
        to_extract[[k]]<-c(to_extract[[k]],(subset(vars[[k]],grepl(varsnippets[m],vars[[k]]))))
      }  
    } 

    names(to_extract)<-tscale  

    print(to_extract)
  }
}
