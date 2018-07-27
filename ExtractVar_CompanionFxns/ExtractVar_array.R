### BEGIN FUNCTIONS ########################################################################

ExtractVar_all<-function(dir,tscale,varname){
  #dir = full directory without "/" at the end, in quotes
  #t scale to extract, in quotes
  #variable name, in quotes

  listfiles<-dir(dir)[grep(paste("-",tscale,"-",sep=""),dir(dir))]
  listfiles<-paste(dir,listfiles,sep="/")

  library(rhdf5)
  extract<-lapply(listfiles, h5read, name=varname)
  return(extract)
}

ExtractVar_single<-function(dir,tscale,varname,singlefile){
  #dir = full directory without "/" at the end, in quotes
  #t scale to extract, in quotes
  #variable name, in quotes
  #singlefile = file name (no directory) from which to extract

  listfiles<-dir(dir)[grep(paste("-",tscale,"-",sep=""),dir(dir))]
  choose<-which(listfiles==singlefile)
  listfiles<-listfiles[choose]
  listfiles<-paste(dir,listfiles,sep="/")

  library(rhdf5)
  extract<-lapply(listfiles, h5read, name=varname)
  return(extract)
}

ExtractVar_range<-function(dir,tscale,varname,first,last){
  #dir = full directory without "/" at the end, in quotes
  #t scale to extract, in quotes
  #variable name, in quotes
  #first, last are filenames (w/o directory). Extract between these (inclusive)
  
  listfiles<-dir(dir)[grep(paste("-",tscale,"-",sep=""),dir(dir))]
  begin<-which(listfiles==first)
  end<-which(listfiles==last)
  listfiles<-listfiles[c(begin:end)]
  listfiles<-paste(dir,listfiles,sep="/")

  library(rhdf5)
  extract<-lapply(listfiles, h5read, name=varname)
  return(extract) 
}

### END FUNCTIONS #####################################################################

dir<-Sys.getenv("direc")
i<-Sys.getenv("i")
tscale<-Sys.getenv("tscale")
extract_option<-Sys.getenv("extract_option")
first<-Sys.getenv("first")
last<-Sys.getenv("last")
singlefile<-Sys.getenv("singlefile")

print(dir)
print(i)
print(tscale)
print(extract_option)


if(extract_option == "ALL"){
  var<-ExtractVar_all(dir=dir,tscale=tscale,varname=i)}

if(extract_option == "SINGLE"){
  print(paste("Extracting from single file: ", singlefile,sep=""))
  var<-ExtractVar_single(dir=dir,tscale=tscale,varname=i,singlefile=singlefile)}

if(extract_option == "RANGE"){
  print(paste("First file: ",first,sep=""))
  print(paste("Last file: " ,last,sep=""))
  var<-ExtractVar_range(dir=dir,tscale=tscale,varname=i,first=first,last=last)}


savedir<-paste(substr(dir,start=1,stop=nchar(dir)-6),"/R/",sep="")
dir.create(savedir)
setwd(savedir)

saveRDS(var,paste("var_",extract_option,".",tscale,".",i,".rds",sep=""))
