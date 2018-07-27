listfiles<-dir(analydir)
temp<-strsplit(listfiles,"-")
tscales<-unlist(unique(lapply(temp,"[[",2)))

#First & last files of each tscale
first=vector(mode="character",length=length(tscales))
last=vector(mode="character",length=length(tscales))
numfiles=vector(mode="character",length=length(tscales))
for(j in 1:length(tscales)){
  sub<-which(lapply(temp,"[[",2)==tscales[j])
  sub2<-listfiles[sub]
  first[j]<-sub2[1]
  last[j]<-sub2[length(sub)]
  numfiles[j]<-length(sub2)
}

filesummary<-data.frame(tscales,numfiles,first,last)
