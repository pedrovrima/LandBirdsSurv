load("regiongroups.RData")

regtab <- matrix(NA,length(unlist(groups)),2)
for(i in 1:length(groups)){
    plcs <- names(groups[[i]])
    regtabname <- paste("region",i,sep="")
    fr <- min(which(is.na(regtab[,1])))
    regtab[fr:(fr+length(plcs)-1),1] <- plcs
    regtab[fr:(fr+length(plcs)-1),2] <- regtabname
}

save(regtab,file="grouptab.RData")

