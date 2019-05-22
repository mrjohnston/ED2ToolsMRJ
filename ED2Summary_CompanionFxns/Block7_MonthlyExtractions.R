library(rhdf5)
library(zoo,quietly=TRUE)

listfiles<-dir(analydir)
temp<-strsplit(listfiles,"-")

if("E"%in%tscales){
  sub<-which(lapply(temp,"[[",2)=="E")
  monthfiles<-listfiles[sub]
  
  #If there are too many months (>100), just randomly subset to 100
  if(length(monthfiles)>100) {
    cat(paste("There are ",length(monthfiles)," monthly files! \n Full extractions for diagnostic plots will take too long.",sep=""))
    cat("\n Subsetting Monthly Data to a random 100 months.")
    choose<-sample(monthfiles,100)
    monthfiles<-choose[order(choose)]
  }
  
  if(length(monthfiles)<100){
    cat("There are <100 monthly files; extracting data from all of them.")
  }
  
  #Get the dates
  temp2<-strsplit(monthfiles,"-")
  timeslist<-unlist(lapply(lapply(temp2,function(x) x[3:4]),paste0,collapse="-" ))
  timeslist<-as.Date(as.yearmon(timeslist))
  
  #VARIABLE EXTRACTIONS
  #These don't need scaling
  ncohg<-unlist(lapply(paste(analydir,monthfiles,sep=""), h5read, name="NCOHORTS_GLOBAL"))
  npatg<-unlist(lapply(paste(analydir,monthfiles,sep=""), h5read, name="NPATCHES_GLOBAL"))
  pft_co<-lapply(paste(analydir,monthfiles,sep=""), h5read, name="PFT")

  #These need to be scaled
  agb_co<-lapply(paste(analydir,monthfiles,sep=""), h5read, name="AGB_CO")
  lai_co<-lapply(paste(analydir,monthfiles,sep=""), h5read, name="LAI_CO")  
  
  #Scaling factors
  nplant_co<-lapply(paste(analydir,monthfiles,sep=""), h5read, name="NPLANT")
  area<-lapply(paste(analydir,monthfiles,sep=""), h5read, name="AREA") #This is per patch
  paco_n<-lapply(paste(analydir,monthfiles,sep=""), h5read, name="PACO_N")
  area_co<-list()
  for(y in 1:length(area)){
    area_co[[y]]<-rep(area[[y]],paco_n[[y]])
  }
  nplant_area<-mapply("*",nplant_co,area_co,SIMPLIFY=FALSE) # = area_co *nplant_co
  
  #Scale the variables
  agb_scale<-mapply("*", agb_co,nplant_area, SIMPLIFY = FALSE)
  lai_scale<-mapply("*", lai_co,area_co,SIMPLIFY=FALSE)
  
  agb=matrix(ncol=length(pfts_num),nrow=length(monthfiles))
  lai=matrix(ncol=length(pfts_num),nrow=length(monthfiles))
  nplant=matrix(ncol=length(pfts_num),nrow=length(monthfiles))
  
  for(r in 1:length(monthfiles)){
    for(k in 1:length(pfts_num)){
      sub<-pft_co[[r]]==pfts_num[k] #selection of the pft
      agb[r,k]<-sum(agb_scale[[r]][sub])
      lai[r,k]<-sum(lai_scale[[r]][sub])
      nplant[r,k]<-sum(nplant_area[[r]][sub])
    }
  }

#Get basal area in just 4 months, since I want to plot the profile
  sub<-which(lapply(temp,"[[",2)=="E")
  monthfilesfull<-listfiles[sub]
  
  if(length(monthfilesfull)>5){
#first, last, 1/3, 2/3
  monthsub<-c(1,floor(length(monthfilesfull)/3),floor(length(monthfilesfull)/3)*2,length(monthfilesfull)) 
  monthfilessub<-monthfilesfull[monthsub]
  subtemp<-strsplit(monthfilessub,"-")
  subtimeslist<- unlist(lapply(lapply(subtemp,function(x) x[3:4]) ,paste0,collapse="-"))
  subtimeslist<-as.Date(as.yearmon(subtimeslist))
  
  basal_area<-lapply(paste(analydir,monthfilessub,sep=""), h5read, name="BASAL_AREA_PY")
  } else {
    subtemp<-strsplit(monthfilesfull,"-")
    subtimeslist<- unlist(lapply(lapply(subtemp,function(x) x[3:4]) ,paste0,collapse="-"))
    subtimeslist<-as.Date(as.yearmon(subtimeslist))
    basal_area<-lapply(paste(analydir,monthfilesfull,sep=""), h5read, name="BASAL_AREA_PY")

  }
  sizeclasses<-seq(1,11,1)
  
  #FLUXES
  #Plot the first & last complete years
  temp<-strsplit(monthfilesfull,"-")
  tab<-table(unlist(lapply(temp,"[[",3)))
  minfullyear<-min(which(tab==12))
  maxfullyear<-max(which(tab==12))
  sub_firstlast<-unique(c(which(lapply(temp,"[[",3)==names(tab[minfullyear])),which(lapply(temp,"[[",3)==names(tab[maxfullyear]))))
  
  if(length(sub_firstlast)==0){
  #  cat("No complete years of monthly files available; plotting all months available")
    monthfilesyrs<-monthfilesfull
    subtemp<-strsplit(monthfilesyrs,"-")
    subtimeslistyrs<- unlist(lapply(lapply(subtemp,function(x) x[4]) ,paste0,collapse="-"))
    mmean_nep_ac<-unlist(lapply(paste(analydir,monthfilesyrs,sep=""), h5read, name="MMEAN_NEP_AC_PY"))
    mmean_vapor_ac<-unlist(lapply(paste(analydir,monthfilesyrs,sep=""), h5read, name="MMEAN_VAPOR_AC_PY"))
    mmean_sensible_ac<-unlist(lapply(paste(analydir,monthfilesyrs,sep=""), h5read, name="MMEAN_SENSIBLE_AC_PY"))
  } else if (length(sub_firstlast)==12){
   # cat("First full year of monthly files = last full year of monthly files; plotting only 1 year")
    monthfilesyrs<-monthfilesfull[sub_firstlast]
    subtemp<-strsplit(monthfilesyrs,"-")
    subtimeslistyrs<- unlist(lapply(lapply(subtemp,function(x) x[4]) ,paste0,collapse="-"))
    # subtimeslistyrs<-as.Date(as.yearmon(subtimeslistyrs))
    
    #For first full year and the last full year plot the monthly fluxes over the year
    mmean_nep_ac<-unlist(lapply(paste(analydir,monthfilesyrs,sep=""), h5read, name="MMEAN_NEP_AC_PY"))
    mmean_vapor_ac<-unlist(lapply(paste(analydir,monthfilesyrs,sep=""), h5read, name="MMEAN_VAPOR_AC_PY"))
    mmean_sensible_ac<-unlist(lapply(paste(analydir,monthfilesyrs,sep=""), h5read, name="MMEAN_SENSIBLE_AC_PY"))
  } else {
    #cat("Below: showing monthly mean fluxes of the first and last full years of simulation")
    monthfilesyrs<-monthfilesfull[sub_firstlast]
    subtemp<-strsplit(monthfilesyrs,"-")
    subtimeslistyrs<- unlist(lapply(lapply(subtemp,function(x) x[4]) ,paste0,collapse="-"))
   # subtimeslistyrs<-as.Date(as.yearmon(subtimeslistyrs))
  
    #For first full year and the last full year plot the monthly fluxes over the year
    mmean_nep_ac<-unlist(lapply(paste(analydir,monthfilesyrs,sep=""), h5read, name="MMEAN_NEP_AC_PY"))
    mmean_vapor_ac<-unlist(lapply(paste(analydir,monthfilesyrs,sep=""), h5read, name="MMEAN_VAPOR_AC_PY"))
    mmean_sensible_ac<-unlist(lapply(paste(analydir,monthfilesyrs,sep=""), h5read, name="MMEAN_SENSIBLE_AC_PY"))
  }
  
  y<-names(tab[minfullyear]) #for if there's only one full year
  if(is.na(y)){ #For if there is not even a full year
    y<-unique(unlist(lapply(lapply(subtemp,function(x) x[3]) ,paste0,collapse="-")))
  }
  
  library(RColorBrewer)
  colors<-brewer.pal(n=max(5,length(pfts_num)),name="Set1") #Either 4 colors (for the basal_area plots) or however many PFTs there are.
  
}

if(!"E"%in%tscales){
  cat("No monthly files. Therefore skipping the following diagnostic plots:  
 (1) month x ncohorts_global
 (2) month x npatches_global
 (3) month x AGB of each PFT
 (4) month x NPLANT of each PFT
 (5) month x LAI of each PFT
 (6) basal areas of PFTs over time
 (7) fluxes during first and last months")
}
