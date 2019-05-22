library(kableExtra)
library(xtable)
#Find the entries in ED2IN
inveg1<-unlist(strsplit(ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%SFILIN",ed2in)],"="))[1]
inveg2<-unlist(strsplit(ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%SFILIN",ed2in)],"="))[2]
inveg2<-gsub("'","",inveg2)
inveg2<-gsub("/"," / ",inveg2)
inmet1<-unlist(strsplit(ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%ED_MET_DRIVER_DB",ed2in)],"="))[1]
inmet2<-unlist(strsplit(ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%ED_MET_DRIVER_DB",ed2in)],"="))[2]
inmet2<-gsub("'","",inmet2)
inmet2<-gsub("/"," / ",inmet2)

phentype<-ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%IPHEN_SCHEME",ed2in)]
if(as.numeric(gsub("\\D", "", phentype)) ==1) { #If phenology is prescribed aka phentype=4
  phenology1<-unlist(strsplit(ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%PHENPATH",ed2in)],"="))[1]
  phenology2<-unlist(strsplit(ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%PHENPATH",ed2in)],"="))[2]
  phenology2<-gsub("'","",phenology2)
  phenology2<-gsub("/"," / ",phenology2)
  
}else{
  phenology1<-"NA"
  phenology2<-"Not prescribed"
}
xml1<-unlist(strsplit(ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%IEDCNFGF",ed2in)],"="))[1]
xml2<-unlist(strsplit(ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%IEDCNFGF",ed2in)],"="))[2]
if(is.na(xml2)){
  xml2<-"No XML file"
} else {
  xml2<-paste0(ED2INdiro,xml2)
  xml2<-gsub("'","",xml2)
  xml2<-gsub(" ","",xml2)
  xml2<-gsub("/"," / ",xml2)
  
}

df<-data.frame(c("Input Vegetation","Input Meteorology","Prescribed Phenology","XML"),
               c(inveg1,inmet1,phenology1,xml1),
               c(inveg2,inmet2,phenology2,xml2))
names(df)<-c("","ED2IN Designation","Path")

datea<-c(
  ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%IMONTHA",ed2in)],
  ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%IDATEA",ed2in)], 
  ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%IYEARA",ed2in)],
  ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%ITIMEA",ed2in)])

datez<-c(
  ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%IMONTHZ",ed2in)],
  ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%IDATEZ",ed2in)], 
  ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%IYEARZ",ed2in)],
  ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%ITIMEZ",ed2in)])
df2<-data.frame(datea,datez)
names(df2)<-c("Start Request","End Request")

pfts<-paste("PFTs: ",ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%INCLUDE_THESE_PFT",ed2in)])
pfts_num<-as.numeric(Numextract(pfts))