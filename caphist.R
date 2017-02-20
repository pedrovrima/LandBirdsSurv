markch.creator <- function(sp,time.cut=0,init.cut="none",age="AHY",regions=F){
###Function###



###########Load the Data################
    ##Recap History##
    tt <- read.csv(paste(filefold,"/",sp,"_CapHistCovars.csv",sep=""),head=T)
    ##Database##
    if(time.cut>0){
    load(database)
    }
###Select the important part of the table
    bnum <-tt[,2] ##BandNumbers
    chist <- which(substring(colnames(tt),1,3)=="CAP")



    
###########Cuts#########################
#####Beggining#######
    
    ##Do nothing##
    if(init.cut=="none"){
        caphist <- tt[,chist]}

    ##1992 cut###
    if(init.cut=="1992"){
        ninetwo <- chist[-which(as.numeric(substring(colnames(tt)[chist],5,9))<1992)]
        caphist <- tt[,ninetwo]
    }

    ##Specific cut##
    if(init.cut=="firstcap"){
        cols <- apply(tt[,chist],2,sum)
        vv <- min(which(cols!=0))
        firstcap <- chist[vv:length(chist)]
        caphist <- tt[,firstcap]
    }


#####August####
    ##Remove the augustine individuals##
    if(time.cut>0){
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

    }

    
########


###AGE####
    ##Only AHY
    if(age=="AHY"){
        grp <- tt[,31]
        rmvbird <- which(grp==0)
        
    }
    ##Only HY    
    if(age=="HY"){
        grp <- tt[,30]
        rmvbird <- which(hygroup==0)
         }
    ##All Ages and individuals
    if(age=="all"){
        grp <- tt[,c(30,31)]
    }


##############Regions##########
    if(regions==T){
        load(regfile)
        regs <- regtab[match(tt$STATION,regtab[,1]),2]
        regg <- aggregate(model.matrix(~ regs -1),list(1:nrow(tt)),max)[,-1]
        grp <- cbind(grp,regg)

    }

    
###########################################################################################
#####Create Table#####
    frmv <- which(apply(caphist,1,sum)==0)
    if(!"rmvag"%in%ls()) rmvag <- NULL
    if(! "rmvbird"%in%ls()) rmvbird <- NULL
    rmvbir <- unique(c(frmv,rmvag,rmvbird))
    
    
    if(length(rmvbir)>0){
        bnum <- bnum[-rmvbir]
        caphist <- caphist[-rmvbir,]
        grp <- grp[-rmvbir,]
    }
    bands <- paste("/*",bnum,"*/")
    history <- apply(caphist,1,function(x)paste(x,collapse=""))
    info <- paste("/*",sp,"-",length(history),"Individuals -",ncol(caphist),"Ocasions */\r\n")

    grpt <- apply(grp,1,function(x)paste(x,collapse=" "))
    tmcutname <- NULL
    if(time.cut>0)
        tmcutname <- paste("_",ceiling(time.cut),sep="")
    regionn <- "_noreg"
    if(regions==T)
        regionn <- "_withreg"
    cat(paste(c(info,paste(bands,history,paste(grpt,";\r\n",sep=""))),collapse=""),file=paste(resulfold,"/",sp,tmcutname,"_",init.cut,regionn,".inp",sep=""))
}
