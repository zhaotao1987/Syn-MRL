# library(dplyr)
# library(tidyverse)

args<-commandArgs(TRUE)

data <- read.table(args[1],header=T)

data$range <- rowSums(data[1:(ncol(data)-1)] != 0)

data$ratio <- data$range/ncol(data)

data$median <- apply(data[,1:(ncol(data)-2)],1, median, na.rm = TRUE)

	# data_f <- filter(data,ratio>0.95 & median<3) # dplyr

# Let's set more filters, for different clades

# Legume： vra van pvu gma cca tpr mtr car lja Anan Lang adu
# totoalnumber	data$CladeF <- rowSums(data[,grep('vra|van|pvu|gma|cca|tpr|mtr|car|lja|Anan|Lang|adu', names(data))]) 
# occurence

	data$CladeF <- rowSums(data[,grep('vra|van|pvu|gma|cca|tpr|mtr|car|lja|Anan|Lang|adu', names(data))]!=0)
	data$PCladeF <- data$CladeF/12

# Brassicaceae: cru Csat Alyr ath Bost Lmey bol bnp bra spa thh tsa Alp aar cgy tha
# conflict: cru Ecru

	data$CladeB <- rowSums(data[,grep('^cru|Csat|Alyr|ath|Bost|Lmey|bol|bnp|bra|spa|thh|tsa|Alp|aar|cgy|tha', names(data))]!=0)
	data$PCladeB <- data$CladeB/16

# Rosales: pmu ppe pbr Mald Rchi fve roc Dryd Tori Pand Mnot Zjuj
	data$CladeR <- rowSums(data[,grep('pmu|ppe|pbr|Mald|Rchi|fve|roc|Dryd|Tori|Pand|Mnot|Zjuj', names(data))]!=0)
	data$PCladeR <- data$CladeR/12

# Asterids (without asteraceae) spe sly stu Caba Cach can pax Inil Cuca coc sin mgu Oeur
	data$CladeA <- rowSums(data[,grep('spe|sly|stu|Caba|Cach|can|pax|Inil|Cuca|coc|sin|mgu|Oeur', names(data))]!=0)
	data$PCladeA <- data$CladeA/13

# Poaceae: sbi Sacc Zmay sit Sevi Ecru oth ogl osa oru Opun lpe Trdc HORV bdi
	data$CladeP <- rowSums(data[,grep('sbi|Sacc|Zmay|sit|Sevi|Ecru|oth|ogl|osa|oru|Opun|lpe|Trdc|HORV|bdi', names(data))]!=0)
	data$PCladeP <- data$CladeP/15

# Monocot： aco mac egu Pdac peq Ashe Aoff Xvis spo zom
	data$CladeM <- rowSums(data[,grep('aco|mac|egu|Pdac|peq|Ashe|Aoff|Xvis|spo|zom', names(data))]!=0)
	data$PCladeM <- data$CladeM/10

data_f <- subset(data,ratio>0.90 & PCladeM >0.5 & PCladeP >0.5& PCladeA >0.5& PCladeR >0.5 & PCladeB >0.5& PCladeF >0.5 & median<2)

nrow(data)

nrow(data_f)

output <- paste0(args[1],"_ratioover0.9medianless4")

write.table(data_f, output,quote=F,row.names=T,col.names=T)
