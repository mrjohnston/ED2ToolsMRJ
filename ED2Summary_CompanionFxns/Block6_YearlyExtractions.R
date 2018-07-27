library(rhdf5)

listfiles<-dir(analydir)
temp<-strsplit(listfiles,"-")

#IF THERE ARE YEARLY FILES: 
if("Y"%in%tscales){
  sub<-which(lapply(temp,"[[",2)=="Y")
  yearfiles<-listfiles[sub]
  
  #If there are too many years >100, just randomly subset to 100
  if(length(yearfiles)>100) {
    cat(paste("There are ",length(yearfiles)," yearly files! \n Full extractions for diagnostic plots will take too long.",sep=""))
    cat("\nSubsetting results to a random 100 years.")
    choose<-sample(yearfiles,100)
    yearfiles<-choose[order(choose)]
  }
  
  if(length(yearfiles)<100) {
    cat("There are <100 yearly files; extracting data from all of them.")
  }
  
  temp2<-strsplit(yearfiles,"-")
  timeslist<-as.numeric(unlist(lapply(temp2,function(x) x[3]) ))

  #Variables that don't need to be scaled
  ncohg<-unlist(lapply(paste(analydir,yearfiles,sep=""), h5read, name="NCOHORTS_GLOBAL"))
  npatg<-unlist(lapply(paste(analydir,yearfiles,sep=""), h5read, name="NPATCHES_GLOBAL"))
  pft_co<-lapply(paste(analydir,yearfiles,sep=""), h5read, name="PFT")
  
  #Scaling factors
  nplant_co<-lapply(paste(analydir,yearfiles,sep=""), h5read, name="NPLANT")
  area<-lapply(paste(analydir,yearfiles,sep=""), h5read, name="AREA") #This is per patch
  paco_n<-lapply(paste(analydir,yearfiles,sep=""), h5read, name="PACO_N")
  area_co<-list()
  for(y in 1:length(area)){
    area_co[[y]]<-rep(area[[y]],paco_n[[y]])
  }
  nplant_area<-mapply("*",nplant_co,area_co,SIMPLIFY=FALSE) # = area_co *nplant_co
  
  #Variables that need to be scaled
  agb_co<-lapply(paste(analydir,yearfiles,sep=""), h5read, name="AGB_CO")
  lai_co<-lapply(paste(analydir,yearfiles,sep=""), h5read, name="LAI_CO")  
  
  #Scale the variables
  agb_scale<-mapply("*", agb_co,nplant_area, SIMPLIFY = FALSE)
  lai_scale<-mapply("*", lai_co,area_co,SIMPLIFY=FALSE)

  agb=matrix(ncol=length(pfts_num),nrow=length(yearfiles))
  lai=matrix(ncol=length(pfts_num),nrow=length(yearfiles))
  nplant=matrix(ncol=length(pfts_num),nrow=length(yearfiles))
  
  for(r in 1:length(yearfiles)){
    for(k in 1:length(pfts_num)){
      sub<-pft_co[[r]]==pfts_num[k] #selection of the pft
      agb[r,k]<-sum(agb_scale[[r]][sub])
      lai[r,k]<-sum(lai_scale[[r]][sub])
      nplant[r,k]<-sum(nplant_co[[r]][sub])
    }
  }
  
#Get basal area - subset years if too many (>5)
  sub<-which(lapply(temp,"[[",2)=="Y")
  yearfilesfull<-listfiles[sub]
  
  if(length(yearfilesfull)>5){
#first, last, 1/3, 2/3
  yearsub<-c(1,floor(length(yearfilesfull)/3),floor(length(yearfilesfull)/3)*2,length(yearfilesfull))
  yearfilessub<-yearfilesfull[yearsub]
  subtemp<-strsplit(yearfilessub,"-")
  subtimeslist<-as.numeric(unlist(lapply(subtemp,function(x) x[3]) ))
  
  basal_area<-lapply(paste(analydir,yearfilessub,sep=""), h5read, name="BASAL_AREA")
  } else {
    subtemp<-strsplit(yearfilesfull,"-")
    subtimeslist<-as.numeric(unlist(lapply(subtemp,function(x) x[3]) ))
  basal_area<-lapply(paste(analydir,yearfilesfull,sep=""), h5read, name="BASAL_AREA")
  }
  sizeclasses<-seq(1,11,1)
  
  library(RColorBrewer)
  colors<-brewer.pal(n=max(5,length(pfts_num)),name="Set1") #Either 5 colors (for the basal_area plots) or however many PFTs there are.

  }
  
if(!"Y"%in%tscales){
  cat ("No yearly files. Therefore skipping the following diagnostic plots:
 (1) year x ncohorts_global
 (2) year x npatches_global
 (3) year x AGB by PFT
 (4) year x NPLANT by PFT
 (5) year x LAI by PFT
 (6) basal area by PFT, year 1, 1/3 of simulation, 2/3 of simulation, last year")
}

  
  