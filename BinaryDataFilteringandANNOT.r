rm(list = ls())
library(dplyr)
# module load R/x86_64/3.5.1

args<-commandArgs(TRUE)

prof <- read.table(args[1],header = T,row.names=1)

	#prof <- read.table(args[1],header = T)
	# Here you've made a mistake before, should start from the first column, because cluster id (row names) have already been defined.
	# That's why you missed the genome vra, previously. 
	# df2 <- as.data.frame((prof[2:ncol(prof)] > 0) + 0)

# convert into binary data 

	df2 <- as.data.frame((prof[1:ncol(prof)] > 0) + 0)

# filtering, count how many species involved, remove only containing 1 species. 
# total species involved

	df2$range <- rowSums(df2[1:ncol(df2)] != 0)

# range >=2

        df2 <- subset(df2,range>=args[2],select=-c(ncol(df2)))

# count number of Fabaceae species:
#        df2$countFab <- rowSums(df2[,grep('vra|van|pvu|gma|cca|tpr|mtr|car|lja|Anan|Lang|adu', names(df2))]!=0)
# count number of Rosaceae species
#        df2$countRos <- rowSums(df2[,grep('pmu|ppe|pbr|Mald|Rchi|fve|roc|Dryd|Tori|Pand|Mnot|Zjuj', names(df2))]!=0)
# count number of Cucurbitaceae
#	df2$countCuc <- rowSums(df2[,grep('csa|cme|cla|Cuma|Datg|Begf', names(df2))]!=0)
# count number of Fagaceae 
#	df2$countFag <- rowSums(df2[,grep('Bpen|Cgla|Cill|Qrob', names(df2))]!=0)
# count number of magnollids

        df2$countmag <- rowSums(df2[,grep('Peam|CKAN|Lchi', names(df2))]!=0)

# count dicots
	
	df2$countdicots <- rowSums(df2[,grep('pmu|ppe|pbr|Mald|Rchi|fve|roc|Dryd|Tori|Pand|Mnot|Zjuj|csa|cme|cla|Cuma|Datg|Begf|vra|van|pvu|gma|cca|tpr|mtr|car|lja|Anan|Lang|adu|Bpen|Cgla|Cill|Qrob|cru|Csat|Alyr|ath|Bost|Lmey|bol|bnp|bra|spa|thh|tsa|Alp|aar|cgy|tha|cpa|Goba|Ghir|gra|Dzib|tca|Cmax|csi|Xsor|mes|rco|ptr|lus|egr|Pgra|spe|sly|stu|Caba|Cach|can|pax|Inil|Cuca|coc|sin|mgu|Oeur|Lsat|HanX|dca|ach|Aeri|Cqui|bvu|Ahyp|Mole|Kalf|vvi|nnu|Psom|Mcor|Aqco', names(df2))]!=0)

# count monocots
	
	df2$countmonoc <- rowSums(df2[,grep('sbi|Sacc|Zmay|sit|Sevi|Ecru|oth|ogl|osa|oru|Opun|lpe|Trdc|HORV|bdi|aco|mac|egu|Pdac|peq|Ashe|Aoff|Xvis|spo|zom', names(df2))]!=0)

# count root, basal

        df2$countroot <- rowSums(df2[,grep('atr|Nymp', names(df2))]!=0)

# Write a function here to better define all the patterns；
# because this is based on the fact that magnollids must present.
# So a lot of 'Others'
ELSE <- TRUE
df2 <- df2 %>% mutate(., annot = with(., case_when(
  (countmag > 0 & countdicots >0 & countmonoc > 0 & countroot >0) ~ "mDMR",
  (countmag > 0 & countdicots >0 & countmonoc > 0 & countroot ==0) ~ "mDM",
  (countmag > 0 & countdicots ==0 & countmonoc == 0 & countroot >0) ~ "mR",
  (countmag > 0 & countdicots ==0 & countmonoc > 0 & countroot >0) ~ "mMR",
  (countmag > 0 & countdicots >0 & countmonoc == 0 & countroot >0) ~ "mDR",
  (countmag > 0 & countdicots ==0 & countmonoc > 0 & countroot ==0) ~ "mM",
  (countmag > 0 & countdicots >0 & countmonoc == 0 & countroot ==0) ~ "Dm",
  (countmag > 0 & countdicots ==0 & countmonoc == 0 & countroot ==0) ~ "m",

#(spe1 < 15 | (spe2 > 50 & spe3 > 30)) ~ "case2",
#(spe1 < 15 | (spe2 > 50 & spe3 > 30)) ~ "case2",
#(spe1 < 15 | (spe2 > 50 & spe3 > 30)) ~ "case2",
#(spe1 < 15 | (spe2 > 50 & spe3 > 30)) ~ "case2",
#(spe1 > 30 & spe2 > 20) ~ "case3",
  ELSE ~ "Others"
)))







# condition: contain all 4 clade species, remove the last 4 columns
# This is strict, the cluster has to contain all of them
#	df2 <- subset(df2,countFab*countRos*countCuc*countFag!=0,select=-c((ncol(df2)-3):ncol(df2)))
# Loose condition: contain at least two of them, so any two of ABCD, 6 combinations.
# df2 <- subset(df2,countFab*countRos!=0|countFab*countCuc!=0|countFab*countFag!=0|countRos*countCuc!=0|countRos*countFag!=0|countCuc*countFag!=0,select=-c((ncol(df2)-3):ncol(df2)))
# contains magnolliids
# contain magnoliids
#df2 <- subset(df2,countmag!=0,select=-c(ncol(df2)))

	#	df2 <- subset(df2,countmag!=0)

# contain magonollids and dicots
# nested ifelse, first contain all three categories -- 'conserved', either two -- 'close2dicot' or 'close2monoc'
	
	#	df2$Annot <- ifelse((df2$countmag)*(df2$countdicots)*(df2$countmonoc)!=0,"conserved",ifelse((df2$countmag)*(df2$countdicots)!=0,"close2dicot","close2monocot"))

	#	df2 <- subset(df2,select=c(ncol(df2)))


# df2 <- t(df2)
print(nrow(df2))
print(ncol(df2))
cols <- ncol(df2)


#out <- paste0(args[1],"_size_",args[2],"_",cols,"_clusters","_binary_transposed")
out <- paste0(args[1],"_size_",args[2],"_","_clusterannot_v2")

# output transposed
# write.table(df2, out,quote=F,row.names=T,col.names=F)

write.table(df2, out,quote=F,row.names=T,col.names=T)
