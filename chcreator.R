######Function to create Capture Histories to use in the Software MARK######
######This functions allows to make "strategic" cuts on the beggining ######
######of the capture histories and on the individuals.#####


##################V1. Designed by PVM 02/08/2017###################
#####The only option now available is to make cuts on the beggining of######
#####the capture histories. This cuts can be based on a visual evidence#####
#####-1992 on the actual version, or on the species data - the capture #####
#####histories start at with the first individual captured#####

##################  Usage  #########################
##########function name "markch.creator"##############
####Arguments:
####spp - 4 letter code of the species - use the same as the files
####init.cut - 3 options
##1-"none" - no initial cuts
##2-"1992" - starts the CH on 1992
##3-"firstcap" - starts at the first capture for the species####
####age - 3 options####
##1- "AHY" - only birds first captured as AHY
##2- "HY" - only birds first captured as HY
##3- "all" - all individuals on the raw CH

setwd("/home/colibri/Documents/RSL") #####Use the folder where the base capture files (csv) are####
##The final files will show up here##
source("/home/colibri/Documents/RSL/Codes/caphist.R")#######Path to function code

markch.creator(spp="SOSP",init.cut="1992")
