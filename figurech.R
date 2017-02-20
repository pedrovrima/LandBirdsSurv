require(ggplot2)
source("functions.R")
load("/home/colibri/Documents/RSL/RData/KBMNdata.RData")
sp <- "SWTH"
tt <- read.csv(paste("/home/colibri/Documents/RSL/KBMN Capture Histories/",sp,"_CapHistCovars.csv",sep=""),head=T)
bnum <-tt[,2] ##BandNumbers
chist <- which(substring(colnames(tt),1,3)=="CAP")
liu <- read.csv("/home/colibri/Documents/RSL/DayDec/DayDec.csv")
cuts <- liu[,4]
time.cut <- cuts[which(liu[,2]==sp)]
####first graph - No changes
caphist <- tt[,chist]


####Second graph: Breed
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
b.caphist <- as.matrix(tt[-rmvag,chist])


####Making the graph
uu <- apply(caphist,1,function(x)paste(x,collapse=""))
b.uu <- as.vector(apply(b.caphist,1,function(x)paste(x,collapse="")))
lst <- sort(unique(uu))
b.lst <- sort(unique(b.uu))
if(length(lst)!=length(b.lst)){
    rt <- which(!lst%in%b.lst)
    b.lst <- lst
    b.lst[rt] <- paste(rep(0,nchar(b.lst[1])),collapse="")
    b.uu <- c(b.uu,paste(rep(0,nchar(b.lst[1])),collapse=""))
    b.caphist <- rbind(b.caphist,rep(0,nchar(b.lst[1])))
}
counthist <- NULL
b.counthist <- NULL
exmp <- NULL
b.exmp <- NULL

for(i in 1:length(lst)){
    counthist <-c(counthist, length(which(uu==lst[i])))
    exmp <- c(exmp,which(uu==lst[i])[1])
}

for(i in 1:length(b.lst)){
    b.counthist <-c(b.counthist, length(which(b.uu==b.lst[i])))
    b.exmp <- c(b.exmp,which(b.uu==b.lst[i])[1])
}


tab <- caphist[exmp,]*counthist
b.tab <- b.caphist[b.exmp,]*b.counthist

int <- seq(2,max(as.vector(t(tab)))+10,by=10)
b.int <- seq(2,max(as.vector(t(b.tab)))+10,by=10)

vv <- sort(unique(as.vector(t(tab))))
b.vv <- sort(unique(as.vector(t(b.tab))))

fint <- findInterval(vv,int)
b.fint <- findInterval(b.vv,b.int)
ff <- colorRampPalette(c("blue","green","yellow","orange","red"))
rr <- ff(max(fint))
fintf <- fint+2
b.fintf <- b.fint+2
fintf[1] <- 1
b.fintf[1] <- 1
cols <- c("white","dark blue",rr)



png("SWTHfigurech.png",width=5400,height=4800,pointsize=60)
plot.new()
layout(t(1:2), widths=c(.2,2))
image(1, int, t(seq_along(int)), col=cols, axes=FALSE)
axis(4)

par(mar=rep(.5, 4), oma=rep(3, 4), las=1)
plot.window(xlim=c(0, ncol(tab)), ylim=c(0, nrow(tab)), asp=1)
text(x=-15,y=nrow(tab)+6,"SWTH - None")
text(x=-15,y=nrow(tab)+3,"c-hat=7.732")

o <- cbind(c(row(tab)), c(col(tab))) - matrix(c(1,30),length(c(col(tab))),2,byrow=T)
for(i in 1:nrow(o)){
    rect(o[i, 2], o[i, 1], o[i, 2] + 1, o[i, 1] + 1, col=cols[fintf[which(vv==tab[o[i,1]+1,o[i,2]+30])]])
}

text(x=15,y=nrow(tab)+6,"SWTH - breed")
text(x=15,y=nrow(tab)+3,"c-hat= 5.139")
o2 <- cbind(c(row(b.tab)), c(col(b.tab))) - 1
for(i in 1:nrow(o2)){
    rect(o2[i, 2], o2[i, 1], o2[i, 2] + 1, o2[i, 1] + 1, col=cols[b.fintf[which(b.vv==b.tab[o2[i,1]+1,o2[i,2]+1])]])
}


dev.off()
