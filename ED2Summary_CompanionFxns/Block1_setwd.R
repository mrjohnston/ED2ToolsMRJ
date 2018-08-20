library(knitr)
library(kableExtra)
ED2INdiro<-gsub("/mnt/odyssey","/n",ED2INdir)
analydiro<-gsub("/mnt/odyssey","/n",analydir)
#srcdiro<-gsub("/mnt/odyssey","/n",srcdir)
#df<-data.frame(c("Namelist","Results","ED2 src"),
#               c(ED2INdiro,analydiro,srcdiro))
df<-data.frame(c("Namelist","Results"),c(ED2INdiro,analydiro))
names(df)<-NULL
