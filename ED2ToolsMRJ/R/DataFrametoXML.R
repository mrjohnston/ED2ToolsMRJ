#' Create an ED2 XML file with PFT parameters from an R dataframe 
#' 
#' @param df Full path to the dataframe file (character string) OR an R dataframe object
#' @param outpath Where the output should be saved (full path, character string)
#' 
#' @return ED2-compatible XML file with PFT parameters, saved in outpath
#' 
#' @examples
#' 
#' df<-XMLtoDataFrame(xml="/mnt/odyssey/moorcroftfs5/mjohnston/gitruns/run005/Tonzi.xml")
#' outpath="/home/miriam/Desktop/DFtoXMLtest.xml"
#' DataFrametoXML(df,outpath)
#' 
#' @export

DataFrametoXML<-function(df,outpath){
  
  #Create the xml from this data file
  xml<-xmlTree()
  suppressWarnings(xml$addTag("config",close=FALSE))
  
  for(i in 1:ncol(df)){
    xml$addTag("pft",close=FALSE)
    for (j in row.names(df)) {
      xml$addTag(j, df[j, i])
    }
    xml$closeTag()
  }
  xml$closeTag()
  
  #If there are lines with NA values, remove them
  top<-xmlRoot(xml)
  
  for(i in 1:ncol(df)){ #each column is a node
    nas<-grep("NA",(xmlSApply(top[[i]],xmlValue)))
      if(length(nas)!=0){ #there are NAs within children
        removeChildren(top[[i]],kids=xmlChildren(top[[i]])[nas])
      }
    }

  #Write out the xml
  cat(saveXML(xml,prefix="<?xml version=\"1.0\"?>\n<!DOCTYPE config SYSTEM \"ed.dtd\">"),
      file=outpath)
  
}