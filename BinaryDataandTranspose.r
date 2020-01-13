args<-commandArgs(TRUE)

prof <- read.table(args[1],header = T,row.names=1)
	#prof <- read.table(args[1],header = T)

# Here you've made a mistake before, should start from the first column, because cluster id (row names) have already been defined.
# That's why you missed the genome vra, previously. 

# df2 <- as.data.frame((prof[2:ncol(prof)] > 0) + 0)

# convert into binary data 
	df2 <- as.data.frame((prof[1:ncol(prof)] > 0) + 0)

# filtering, count how many species involved, remove only containing 1 species. 
	df2$range <- rowSums(df2[1:ncol(df2)] != 0)

# range >=2 
	df2 <- subset(df2,range>=args[2],select=-c(ncol(df2)))


df2 <- t(df2)
print(nrow(df2))
print(ncol(df2))

cols <- ncol(df2)

out <- paste0(args[1],"_size_",args[2],"_",cols,"_clusters","_binary_transposed")

write.table(df2, out,quote=F,row.names=T,col.names=F)
