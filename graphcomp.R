#####################################################################
####load data
tt <- read.csv(paste(filefold,"/",sp,"_CapHistCovars.csv",sep=""),head=T)
load(database)
bnum <-tt[,2] ##BandNumbers
chist <- which(substring(colnames(tt),1,3)=="CAP")
liu <- read.csv("/home/colibri/Documents/RSL/DayDec/DayDec.csv")
cuts <- liu[,4]
time.cut <- cuts[i]
####first graph - No changes
caphist <- tt[,chist]
data1 <- apply(caphist,1,sum)

####second graph - 
ninetwo <- chist[-which(as.numeric(substring(colnames(tt)[chist],5,9))<1992)]
caphist <- tt[,ninetwo]
data2 <- apply(caphist,1,sum)
if(0 %in% data2){
    data2 <- data2[-which(data2==0)]
}


###Thrid graph
jday <- julian.extract(DATA$JulianDay[which(DATA$BandNumber%in%bnum)])
vv <- as.matrix(cbind(as.numeric(as.character(DATA$BandNumber[which(DATA$BandNumber%in%bnum)])),as.numeric(jday$JulianDay)))
if(length(jday$is.NA)>0){vv
    vv <- vv[-which(is.na(vv[,2])),]
    
}
vv <- as.data.frame(vv)
colnames(vv) <- c("bands","jday")
ll <- aggregate(vv[c("jday")],by=vv[c("bands")],FUN=min)   
cut <- which(as.numeric(ll[,2])>time.cut)
bcut <- ll[cut,1]
rmvag <- which(bnum%in%bcut)
caphist <- as.matrix(tt[-rmvag,chist])
data3 <- apply(caphist,1,sum)
rr <- table(data1)-table(data3)
