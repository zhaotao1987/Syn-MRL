	# Rscript ../ProcessPhyPro.r input profiled profiled-clustered

args<-commandArgs(TRUE)
	#data <- read.table(args[1],sep='\t',header=T) # By default
	# Warning messages:
	# 1: In scan(file = file, what = what, sep = sep, quote = quote, dec = dec,  :
	# EOF within quoted string
	# 2: In scan(file = file, what = what, sep = sep, quote = quote, dec = dec,  :
	# number of items read is not a multiple of the number of columns
  
data <- read.table(args[1],header=T)  # Sometimes You have to use this one! For problems above ! I dont  know why

	# Input
	# Gene	Species	Cluster
	# AlyrAL1G19310	Aly	13296
	# AlyrAL1G19350	Aly	75

out <- table(data$Cluster,data$Species) # This function is like countifs in excel, super.
	# Make you result by species order
	# Plants
	# 150 Genomes (Actually 148)
	# Two species do not have a node

myorder <- c(
'pmu',
'ppe',
'pbr',
'Mald',
'Rchi',
'fve',
'roc',
'Dryd',
'Tori',
'Pand',
'Mnot',
'Zjuj',
'csa',
'cme',
'cla',
'Cuma',
'Datg',
'Begf',
'vra',
'van',
'pvu',
'gma',
'cca',
'tpr',
'mtr',
'car',
'lja',
'Anan',
'Lang',
'adu',
'Bpen',
'Cgla',
'Cill',
'Qrob',
'cru',
'Csat',
'Alyr',
'ath',
'Bost',
'Lmey',
'bol',
'bnp',
'bra',
'spa',
'thh',
'tsa',
'Alp',
'aar',
'cgy',
'tha',
'cpa',
'Goba',
'Ghir',
'gra',
'Dzib',
'tca',
'Cmax',
'csi',
'Xsor',
'mes',
'rco',
'ptr',
'lus',
'egr',
'Pgra',
'spe',
'sly',
'stu',
'Caba',
'Cach',
'can',
'pax',
'Inil',
'Cuca',
'coc',
'sin',
'mgu',
'Oeur',
'Lsat',
'HanX',
'dca',
'ach',
'Aeri',
'Cqui',
'bvu',
'Ahyp',
'Mole',
'Kalf',
'vvi',
'nnu',
'Psom',
'Mcor',
'Aqco',
'sbi',
'Sacc',
'Zmay',
'sit',
'Sevi',
'Ecru',
'oth',
'ogl',
'osa',
'oru',
'Opun',
'lpe',
'Trdc',
'HORV',
'bdi',
'aco',
'mac',
'egu',
'Pdac',
'peq',
'Ashe',
'Aoff',
'Xvis',
'spo',
'zom',
'Peam',
'CKAN',
'Lchi',
'atr',
'Nymp')


	# In case, you miss species

order <- match(colnames(out),myorder)
new <- rbind(order, out)
new2 <- new[,order(new[1,])]
new3 <-new2[-1,]

	#out <- out[,myorder]
	# Let's control Cluster Sizes

new3 <- as.data.frame(new3)

new3$Size <- rowSums(new3)

	# MergedBlocks-150Genomes_del_Ebre_Csin_Aran_Tksa_2cols.sim-Info has 144 genomes
	# new3 <- subset(new3,Size > 500, select=c(-145))  # NOTE here!!  Your actual number of species +1 

	#new3 <- subset(new3,Size > 100 & Size < 120, select=c(-145))  # NOTE here!!  Your actual number of species +1
	#new3 <- subset(new3,Size > 2, select=c(-142))  # NOTE here!!  Your actual number of species +1
	#size > 1 :all clusters

	# Let's try different sizes
	# cluster all sizes
	# new3 <- subset(new3,Size >1, select=c(-145))
	# cluster size over 3
	# new3 <- subset(new3,Size >3, select=c(-145))
	# cluster size over 9

new3 <- subset(new3,Size >0, select=-c(ncol(new3)))

	# MergedBlocks-150Genomes_del_Ebre_Csin_Aran_Tksa_2cols.sim-Info has 144 genomes

write.table(new3,args[2],col.names =NA,quote=F) # export output

	# Clusters are profiled now, you could stop here, because to cluster them is a different story.

	# Output sample
	# Aly ath atr can csi dca Ebr hel Lsa osa oth sly Tar TKS vvi
	# 1 28 28 0 65 53 43 0 59 67 25 17 59 112 9 84
	# 2 7 3 11 175 17 9 0 5 19 44 1 28 100 6 13
	# 3 36 62 15 16 18 12 0 39 22 36 5 14 48 3 32
