#' Plot Variables on Separate Plots, align by date
#' 
#' Given dates & 1-demensional variables with the same units, plot these on the separate axes
#' 
#' @param dates 'chron' dates, e.g. as extracted by ExtractChronDates function 
#' @param vars list of (1 dimensional) variables that match dates - likely NOT raw output from an extraction (list of character strings)
#' @param names vector of names that will go on the legend (vector of character strings)
#' 
#' @return stacked line plots
#' 
#' @examples
#' 
#' #Dates from daily files
#' PlotVars_Stacked(chrondates,vars=list("AGB","LEAF_TEMP","LAI"),names=c("biomass","leaftemp","lai"))

#' @export


PlotVars_Stacked<-function(dates,vars,names) {
  #Plots multiple vars in different plots, vertically aligned
  #dates are chron dates
  #vars is a list of (1 dimensional) variables that match the dates - likely NOT raw output from ExtractVar
    #ex: vars=list(x, y, z)
  #names is a vector of names that will go on the y-axes
    #ex: names<-c("test1","test2")
  
  op <- par(mfrow = c(length(vars),1),
            oma = c(1,1,1,1) + 0.1, #bottom,left,top,right
            mar = c(1,4,1,1) + 0.1)
  
  for(i in 1:length(vars)){
    if(!is.null(ncol(vars[[i]]))){
      stop("Variable must be 1 dimensional, make sure you've extracted only the relevant row/col from the HDF5")
    }
    plot(dates,vars[[i]],ylab=names[i],type="l")
  }
}

