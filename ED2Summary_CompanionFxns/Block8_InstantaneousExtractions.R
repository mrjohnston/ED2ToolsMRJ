library(rhdf5)

listfiles<-dir(analydir)
temp<-strsplit(listfiles,"-")

if("I"%in%tscales){
  sub<-which(lapply(temp,"[[",2)=="I")
  instfiles<-listfiles[sub]
  
  #The point here is to make sure that diurnal cycles are okay.
  #If there is more than one year in the simulation: the middle of the simulation, extract data from the first day of each month of that year.
  #Or, if there is only one year, extract from all first days of the months we do have.
  
  instsplit<-strsplit(instfiles,"-")
  
  yrs<-unique(unlist(lapply(instsplit,function(x) x[3])))
  
  instyr<-unlist(lapply(instsplit,function(x) x[3]))
  instdate<-unlist(lapply(lapply(instsplit,function(x) x[3:5]),paste0,collapse="-" ))

  
  if(length(yrs)>1){
  pickyr<-unique(instyr)[floor(length(unique(instyr))/2)] #Middle year of simulation
  } else {
  pickyr<-yrs
  }
  
  choose<-paste(pickyr,c("01-01","02-01","03-01","04-01","05-01","06-01","07-01",
                         "08-01","09-01","10-01","11-01","12-01"),sep="-")
  fileselec<-which(instdate%in%choose)
  
  if(length(fileselec)>0){
    instmidyear<-instfiles[fileselec]
    instmidyear<-instmidyear[order(instmidyear)]
    filedaysA<-strsplit(instmidyear,"-")
    filedaysB<-unlist(lapply(lapply(filedaysA,function(x) x[3:5]),paste0,collapse="-" ))
  
    filesperday<-unique(table(filedaysB))
    timesperfile<-length(h5read(paste(analydir,instmidyear[1],sep=""),"FMEAN_NEP_AC_PY"))
    
    dataperday<-filesperday*timesperfile
  
  #Extract fluxes 
    avg_nep_ac<-unlist(lapply(paste(analydir,instmidyear,sep=""), h5read, name="FMEAN_NEP_AC_PY"))
    avg_vapor_ac<-unlist(lapply(paste(analydir,instmidyear,sep=""), h5read, name="FMEAN_VAPOR_AC_PY"))
    avg_sensible_ac<-unlist(lapply(paste(analydir,instmidyear,sep=""), h5read, name="FMEAN_SENSIBLE_AC_PY"))
    
  #Reformat - each day is a column
    cmat<-matrix(avg_nep_ac,nrow=dataperday)
    vmat<-matrix(avg_vapor_ac,nrow=dataperday)
    smat<-matrix(avg_sensible_ac,nrow=dataperday)
  } else {
    cat("No instantaneous files on the first of a month! Maybe these 'I' files are observation output?")
  }

  #For plotting, colors & lty per day. There should only ever be a max of 12 days.
     colors<-c("#9E0142","#D53E4F","#F46D43", "#FDAE61", "#FEE08B", "#FFFFBF" ,"#E6F598", "#ABDDA4", 
              "#66C2A5", "#3288BD" ,"#5E4FA2", "#000000") #This is "spectral" from RcolorBrewer, plus black at the end.
     lty=c(1,1,1,1,1,1,1,1,1,1,1,1)
} 

if(!"I"%in%tscales){
  cat("No instantaneous files. Therefore skipping the following diagnostic plots:
 (1) diurnal carbon flux in first day of every month mid-simulation
 (2) diurnal water flux in first day of every month mid-simulation
 (3) diurnal sensible heat flux in first day of every month mid-simulation")
}