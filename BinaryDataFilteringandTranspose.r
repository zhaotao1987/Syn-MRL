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
        df2$countFab <- rowSums(df2[,grep('vra|van|pvu|gma|cca|tpr|mtr|car|lja|Anan|Lang|adu', names(df2))]!=0)
# count number of Rosaceae species
        df2$countRos <- rowSums(df2[,grep('pmu|ppe|pbr|Mald|Rchi|fve|roc|Dryd|Tori|Pand|Mnot|Zjuj', names(df2))]!=0)
# count number of Cucurbitaceae
	df2$countCuc <- rowSums(df2[,grep('csa|cme|cla|Cuma|Datg|Begf', names(df2))]!=0)
# count number of Fagaceae 
	df2$countFag <- rowSums(df2[,grep('Bpen|Cgla|Cill|Qrob', names(df2))]!=0)

# condition: contain all 4 clade species, remove the last 4 columns
# This is strict

#	df2 <- subset(df2,countFab*countRos*countCuc*countFag!=0,select=-c((ncol(df2)-3):ncol(df2)))

# Loose condition: contain at least two of them, so any two of ABCD, 6 combinations.

df2 <- subset(df2,countFab*countRos!=0|countFab*countCuc!=0|countFab*countFag!=0|countRos*countCuc!=0|countRos*countFag!=0|countCuc*countFag!=0,select=-c((ncol(df2)-3):ncol(df2)))


df2 <- t(df2)
print(nrow(df2))
print(ncol(df2))
cols <- ncol(df2)

out <- paste0(args[1],"_size_",args[2],"_",cols,"_clusters","_binary_transposed")

write.table(df2, out,quote=F,row.names=T,col.names=F)
