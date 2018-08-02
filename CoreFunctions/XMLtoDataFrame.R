#' Extract PFT parameters from an ED2 XML 
#' 
#' @param xml Full path to the XML file (character string)
#' 
#' @return R Dataframe where column = PFT, row.names = parameter names and values are parameter values.
#' 
#' @examples
#' 
#' xml<-"/mnt/odyssey/moorcroftfs5/mjohnston/gitruns/run006/Tonzi.xml"
#' df<-XMLtoDataFrame(xml)
#' #Note: warning "incomplete final line found on 'xmlfile.xml'" seems not to affect results.
#' 
#' @export
#' 

XMLtoDataFrame<-function(xml){
  
  Sys.setlocale('LC_ALL','C')
  library(XML)
  
  #Read in the xml, select only the PFT lines
  data<-readLines(xml)
  pftstart<-grep("<pft>",data)[1] #first line with 'pft'
  pftend<-grep("</pft>",data)[length(grep("</pft>",data))] #last </pft> 
  data2<-data[pftstart:pftend]
  
  #must have a root around the pft info, else can't read as xml
  root<-c("<config>","</config>") 
  data3<-c(root[1],data2,root[2])
  
  #Write a clean XML that will be able to be parsed
  writeLines(data3,con=paste0(getwd(),"/","delete.xml"),sep="\n")
  
  #Read the clean, pft-only XML
  x<-xmlTreeParse(paste0(getwd(),"/","delete.xml")) #Parse clean xml file
  
  #Remove the saved file
  file.remove(paste0(getwd(),"/","delete.xml")) #Remove the original file 
  
  #Parse the xml to get all the data
  xmltop = xmlRoot(x) 
  values <- xmlSApply(xmltop, function(x) xmlSApply(x, xmlValue)) #extract values
  
  #Just in case -- some versions seem to produce duplicates?!
  #dup<-which(duplicated(names(values))) 
  #if(length(dup)>0){
  #  values<-values[-dup,] 
  #}
  
  #If values is a list, it's because there are some different entries b/t PFTs.
  if(is.list(values)){
  #Get common names (just in case some PFTs have more information than others, or they have different info)
  common<-Reduce(intersect, lapply(values,row.names))
  com<-list(length=length(values))
            for(e in 1:length(values)){
              com[[e]]<-values[[e]][which(names(values[[e]])%in%common)]
            }
  val_df <- data.frame(com) 
  row.names(val_df)<-gsub(".text","",row.names(val_df)) #dataframe of common attributes
  colnames(val_df)<-rep("pft",ncol(val_df))
  
  #Add the names which are not common to all PFTs, with values where they exist and NA otherwise
  all<-unique(unlist(lapply(values,names)))
  uncommon<-all[!(all%in%common)]
  
  add<-data.frame(matrix(NA,ncol=length(values),nrow=length(uncommon))) 
  row.names(add)=uncommon
  colnames(add)=rep("pft",ncol(add))
  for(u in 1:length(uncommon)){
    for(v in 1:length(values)){
      if(length(values[[v]][names(values[[v]])%in%uncommon[u]])!=0){ #there's a value
        add[u,v]<-values[[v]][names(values[[v]])%in%uncommon[u]]
      }
    }
  }
  #Put the common & add dataframes together
  values<-rbind(val_df,add)
  } #end if values is a list 
  
  #Make numeric
  vals<-data.frame(matrix(nrow=nrow(values),ncol=ncol(values)))
  row.names(vals)=row.names(values)
  for (i in 1:ncol(values)){
    vals[,i]<-as.numeric(as.character(values[,i]))
  }

  #Return the dataframe
  return(vals)
  
}
