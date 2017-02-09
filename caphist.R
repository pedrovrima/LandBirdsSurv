markch.creator <- function(spp,init.cut="none",age="AHY"){
###Function###



###########Load the Data################
    ##Recap History##
    tt <- read.csv(paste(filefold,"/",spp,"_CapHistCovars.csv",sep=""),head=T)
    ##Database##
    
    
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
        caphist <- tt[,ninetwo]}

    ##Specific cut##
    if(init.cut=="firstcap"){
        cols <- apply(tt[,chist],2,sum)
        vv <- min(which(cols!=0))
        firstcap <- chist[vv:length(chist)]
        caphist <- tt[,firstcap]}


#####August####
    ##Do nothing##
    
    ##Remove the augustine individuals##
########


###AGE####
    ##Only AHY
    if(age=="AHY"){
        ahygroup <- tt[,31]
        rmvbird <- which(ahygroup==0)
        caphist <- caphist[-rmvbird,]
        bnum <- bnum[-rmvbird]
        grp <- ahygroup[-rmvbird]
    }
    ##Only HY    
    if(age=="AHY"){
        hygroup <- tt[,30]
        rmvbird <- which(hygroup==0)
        caphist <- caphist[-rmvbird,]
        bnum <- bnum[-rmvbird]
        grp <- ahygroup[-rmvbird]
    }
    ##All Ages and individuals
    if(age=="all"){
        grp <- tt[,c(30,31)]
    }
    
###########################################################################################
#####Create Table#####
    bands <- paste("/*",bnum,"*/")
    history <- apply(caphist,1,function(x)paste(x,collapse=""))
    info <- paste("/*",spp,"-",length(history),"Individuals -",ncol(caphist),"Ocasions */\r\n")


    cat(paste(c(info,paste(bands,history,paste(grp,";\r\n",sep=""))),collapse=""),file=paste(resulfold,"/",spp,init.cut,".inp",sep=""))
}
