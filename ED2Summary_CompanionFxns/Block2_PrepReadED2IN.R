#Prepping - no output here
invisible(Sys.setlocale('LC_ALL','C')) #avoid locale errors
library(stringr)
Numextract <- function(string){
  unlist(regmatches(string,gregexpr("[[:digit:]]+\\.*[[:digit:]]*",string)))
}
#Read the ED2IN. Note: if not called "ED2IN", this will fail
ed2in<-readLines(paste0(ED2INdir,"ED2IN"))
