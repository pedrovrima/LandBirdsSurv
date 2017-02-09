load("/home/colibri/Documents/RSL/RData/KBMNdata.RData")
load("/home/colibri/Documents/RSL/RData/KBMNbandtable.RData")
load("/home/colibri/Documents/RSL/RData/spplist.RData")
source("/home/colibri/Documents/RSL/Codes/functions.R")
uu <- matrix(NA,1,4)



for(i in 1:length(spp)){

    sp <- spp[i]

    bandnum <- band.table$Band.Number[which(band.table$Species.Code==sp & band.table$Rep.Status=="B")]
    jday <- julian.extract(DATA$JulianDay[which(DATA$BandNumber%in%bandnum)])
    vv <- cbind(DATA$BandNumber[which(DATA$BandNumber%in%bandnum)],jday$JulianDay)
    if(length(jday$is.NA)>0){
        vv <- vv[-which(is.na(vv[,2])),]

    }
    vv <- as.data.frame(vv)
    colnames(vv) <- c("bands","jday")
    tt <- aggregate(vv[c("jday")],by=vv[c("bands")],FUN=min)
    qnt <- quantile(tt[,2],c(.95,.975,.99))
    ii <- min(tt[,2]):max(tt[,2])
    cnk <- length(split(ii,ceiling(seq_along(ii)/5)))
    png(paste("/home/colibri/Documents/RSL/DayDec/",sp,".png",sep=""))
    hist(tt[,2],breaks=cnk,xaxs="i",main=sp,xlab="Julian Day")
    abline(v=qnt,lwd=2,col=c("black","green","red"))
    legend("topright",legend=c(paste("95% -",qnt[1]),paste("97.5% -",qnt[2]),paste("99% -",qnt[3])),col=c("black","green","red"),lwd=2,bg="white")
    dev.off()

  uu <- rbind(uu,c(sp,as.vector(qnt)))

    if(i==length(spp)){
        uu <- uu[-1, ]
        colnames(uu) <- c("Species","95%","97.5%","99%")
        write.csv(uu,"/home/colibri/Documents/RSL/DayDec/DayDec.csv")
        }
    
}

