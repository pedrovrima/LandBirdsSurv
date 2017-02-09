julian.extract<-function(juldays){
  julian <- as.numeric(substring(juldays,nchar(as.character(juldays))-2,nchar(as.character(juldays))))
  jul.na <- which(is.na(julian))
  jul<-list()
  jul$JulianDays<-julian
  jul$is.NA<-jul.na
  return(jul)
  
}



bandrows<-function(database,bands){
  rw<-which(database$BandNum%in%bands)
  return(rw)
}
