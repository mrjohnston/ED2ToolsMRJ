#' Plot Output Variables on the Same Axis
#' 
#' Given dates & 1-demensional variables with the same units, plot these on the same axis
#' 
#' @param dates 'chron' dates, e.g. as extracted by ExtractChronDates function
#' @param vars list of (1 dimensional) variables that match dates - likely NOT raw output from an extraction (list of character strings)
#' @param names vector of names that will go on the legend (vector of character strings)
#' @param units Of the variables (string, optional)
#' @return line plot with multiple data series
#' @examples
#' 
#' #Dates from daily files
#' PlotVars_SameAxis(chrondates,vars=list("L1","L2","L3"),names=c("leaftemp1","leaftemp2","leafttemp3"),units="K")

#' @export

PlotVars_SameAxis<-function(dates,vars,names,units){
  #Makes one plots with multiple lines
  #dates: chron dates from "ExtractDates" function
  #vars: list of (1 dimensional) variables that match dates - likely NOT raw output from ExtractVar
    #ex: vars=list(x, y, z)
  #names is a vector of names that will go on the legend
    #ex: names<-c("test1","test2")
  #units: of each plot, optional
    #ex: units<-"kg/m2 ground"
  
  library(grDevices)
  palette<-rainbow(n=length(vars))
  par(mfrow=c(1,1))
 
  #Get max/min y values for plotting limits:
  maxs<-NULL
  mins<-NULL
  for(t in 1:length(vars)){
    maxs[t]<-max(vars[[t]])
    mins[t]<-min(vars[[t]])
  }
  
  for(i in 1:length(vars)){
    if(!is.null(ncol(vars[[i]]))){
      stop(paste("Variable ", i, 
                 " is not one-dimensional, make sure you've extracted only the relevant row/col from the HDF5",sep=''))
    }
    if(i==1){
      if(!missing(units)){
      plot(dates,vars[[i]],type="l",col=palette[i],ylim=c(min(mins)-((max(maxs)-min(mins))/8),max(maxs)),ylab=units)
      }
      else{plot(dates,vars[[i]],type="l",col=palette[i],ylim=c(min(mins),max(maxs)))
      }
    }
        
    if(i>1){
      lines(dates, vars[[i]],col=palette[i])
    }
  }
  legend("bottomleft",legend=names,lty=1,col=palette,x.intersp=.7,y.intersp=.6,bty="n")
}
