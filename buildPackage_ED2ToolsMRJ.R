### Update R Package contents & documentation file, then load package into R session
  #Re. updating the functions: make sure that they're in Rpackage/CoreFunctions folder

### For building a package the very first time:
# install.packages("devtools")
# library("devtools")
# #devtools::install_github("klutometis/roxygen")
# library(roxygen2)
# setwd("/home/miriam/Documents/Harvard/Moorcroft/Rpackages/ED2ToolsMRJ")
# create("ED2ToolsMRJ")
# setwd("./ED2ToolsMRJ")
# document()
# setwd("..")

setwd("/home/miriam/Dropbox/Harvard/Rpackages/ED2ToolsMRJ")
#CREATE PACKAGE - OVERWRITING PREVIOUS VERSION 
{ 
try(unlink("ED2ToolsMRJ", recursive = T), T) 
try(file.remove("./ED2ToolsMRJ.pdf"), T)  
  
aut1 = person(given = "Miriam",family="Johnston", email = "mjohnston@g.harvard.edu", role  = c("aut","cre"))
authors_at_r <- paste0("'", aut1, "'")
options(devtools.desc.author=authors_at_r)
  
my_description <- list( 
  "Title" = "Tools for working with the Ecosystem Demography model", 
  "Authors@R" = authors_at_r,
  "Version" = "1.0",
  "Maintainer" = "'Miriam Johnston' <mjohnston@g.harvard.edu>",
  "Description" = "Tools for working with the Ecosystem Demography model",
  "License" = "Creative Commons Attribution-Noncommercial-No Derivative Works 4.0, for academic use only."
)

devtools::create("./ED2ToolsMRJ", my_description)

#after loading in correct files to ./Readme2/R/ folder 
core_files <- list.files("./CoreFunctions/")
core_files <- sprintf('./CoreFunctions/%s',core_files)
file.copy(from=core_files, to="./ED2ToolsMRJ/R/", overwrite = TRUE, recursive = FALSE, copy.mode = TRUE)
roxygen2::roxygenise("./ED2ToolsMRJ/")
devtools::document("./ED2ToolsMRJ/")

system("R CMD Rd2pdf ED2ToolsMRJ")
#system(" tar -zcvf ED2ToolsMRJ.tar.gz ED2ToolsMRJ")
}

#LOAD PACKAGE INTO R SESSION 
devtools::load_all("/home/miriam/Dropbox/Harvard/Rpackages/ED2ToolsMRJ/ED2ToolsMRJ") 
#?function
