sp <- "SOSP"
filefold <- "/home/colibri/Documents/RSL/KBMN Capture Histories" #####The folder
sites <- c("7MIL","ANT1","HOME","CABN","INVA","PCT1","TOPS","JOHN","WIIM","WREF","ODES","APRI","GROV","WILL","WOOD")
dircr <- paste("/home/colibri/Documents/perfect/",sp,sep="")
dir.create(dircr)
resulfold <- dircr


vv <- read.csv(paste(filefold,"/",sp,"_CapHistCovars.csv",sep=""),head=T)
tt <- vv[which(vv[,1]%in%sites),]

bnum <-tt[,2] ##BandNumbers
chist <- which(substring(colnames(tt),1,3)=="CAP")
ninetwo <- chist[-which(as.numeric(substring(colnames(tt)[chist],5,9))<1997 |as.numeric(substring(colnames(tt)[chist],5,9))>2009 )]
caphist <- tt[,ninetwo]

ahygroup <- tt[,31]
rmvbird <- which(ahygroup==0)
caphist <- caphist[-rmvbird,]
bnum <- bnum[-rmvbird]
grp <- ahygroup[-rmvbird]

rmvbir <- which(apply(caphist,1,sum)==0)

if(length(rmvbir)>0){
    bnum <- bnum[-rmvbir]
    caphist <- caphist[-rmvbir,]
    grp <- grp[-rmvbir]
}


bands <- paste("/*",bnum,"*/")
history <- apply(caphist,1,function(x)paste(x,collapse=""))
info <- paste("/*",sp,"-",length(history),"Individuals -",ncol(caphist),"Ocasions */\r\n")

tmcutname <- NULL
cat(paste(c(info,paste(bands,history,paste(grp,";\r\n",sep=""))),collapse=""),file=paste(resulfold,"/",sp,tmcutname,"_perfect",".inp",sep=""))
