# pfts<-paste("PFTs: ",ed2in[grepl("^[[:blank:]]*[^[:blank:]!]",ed2in)&grepl("NL%INCLUDE_THESE_PFT",ed2in)])
# pfts_num<-as.numeric(Numextract(pfts))
# setwd(paste0(srcdir,"init"))
# ed_params<-readLines("ed_params.f90")
# 
# #Find PFTs in ed_params
# pftnames<-vector(mode="character",length=length(pfts_num))
# for(i in 1:length(pfts_num)){
#   if(nchar(pfts_num[i])==1){
#     pftnames[i]<-ed_params[grepl(paste0("pft_name16\\( ",pfts_num[i],")"),ed_params)] #single digit, space
#   } else {
#     pftnames[i]<-ed_params[grepl(paste0("pft_name16\\(",pfts_num[i],")"),ed_params)] #double digits, no space
#   }
# }
# for(k in 1:length(pftnames)){
#   cat(pftnames[k],"\n") #Use 'cat' to remove the [1]
# }