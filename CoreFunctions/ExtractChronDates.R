#' Extract Chron Dates
#' 
#' Used to extract 'chron' dates from filenames in a directory
#' 
#' @param dir Directory in which to search for ED2 output files (character string)
#' @param tscale Time scale for relevant files (single character; common options: "D","I")
#' @param perfile Number of times desired per file (optional, numeric, use only sometimes for I tscale, default =1)
#' @param first First file from which to extract (optional, character string, use with 'last' to extract between a set of files)
#' @param last Last file from which to extract (optional, character string, use with 'first' to extract between a set of files)
#' 
#' @return 'chron' format dates
#' 
#' @examples
#' 
#' dir="/mnt/odyssey/moorcroftfs5/mjohnston/ED2_timeoutput/Case2/run004/analy/"
#' first="tonzi-D-2003-07-01-000000-g01.h5"
#' last="tonzi-D-2003-08-01-000000-g01.h5"
#' 
#' #Dates from daily files
#' dates <- ExtractChronDates(dir,tscale="D")
#' 
#' #Dates from hourly files where each file has 24 hours in it
#' dates <- ExtractChronDates(dir,tscale="I", perfile=24)
#' 
#' #Dates from daily files between 07/01/2003 and 08/01/2003 (inclusive)
#' dates <- ExtractChronDates(dir,tscale="D", first=first, last=last)
#'
#' @export

ExtractChronDates<-function(dir,tscale,perfile,first,last){
  #Used to extract 'chron' dates from filenames in a directory
  #I'm assuming that all data in file YYYY-MM-DD 00:00:00 are for the day YYYY-MM-DD.
  #perfile: optional, the number of data points per file. Default = 1 
    #Currently only works if tscale="I"
  #first, last: optional, and are full filenames (w/o directory). 
    #Use these if you don't want to extract all data, just between some set of filenames (inclusive)

  listfiles<-dir(dir)[grep(paste("-",tscale,"-",sep=""),dir(dir))]
  
  if(!missing(first)&(!missing(last))){
    begin<-which(listfiles==first)
    end<-which(listfiles==last)
    listfiles<-listfiles[c(begin:end)]
  }
  
  library(chron)
  
  #Extract date information from file name:
  temp<-strsplit(listfiles,"-")
  timeslist<-lapply(temp,function(x) x[3:6]) #3:6 are the date elements of the filename
  
  if(timeslist[[1]][3]=="00"){ #this is for monthly files, when day ="00", which chron doesn't recognize
    for(f in 1:length(timeslist)){
      timeslist[[f]][3]<-"01"
    }
  }
  
  if(timeslist[[1]][2]=="00"){ #this is for yearly files, when month ="00", which chron doesn't recognize
    for(f in 1:length(timeslist)){
      timeslist[[f]][2]<-"01"
    }
  }
  
  #Get date info in a format easily transformed to chron objects: YYY-MM-DD HH:MM:SS
  dt<-list() 
  for(j in 1:length(timeslist)){
    dt[[j]]<-paste(timeslist[[j]][1],"-",timeslist[[j]][2],"-",timeslist[[j]][3]," ",
                   substr(timeslist[[j]][4],1,2),":",substr(timeslist[[j]][4],3,4),":",
                   substr(timeslist[[j]][4],5,6),sep="")
  }
  
  #Create chron objects:
  datt<-as.chron(unlist(dt))
  
  if(tscale=="I" & !missing(perfile)) {
    datt[length(datt)+1]<-datt[length(datt)]+1
    datt<-seq.dates(datt[1],datt[length(datt)],by=1/perfile)
    datt<-datt[-length(datt)]
  }
  if(tscale!="I" & !missing(perfile)){
    print("Warning: 'perfile' is only an option when tscale=='I'. Using default perfile = 1")
  }
  return(datt)
}
