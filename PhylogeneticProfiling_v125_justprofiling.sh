#

module load R/x86_64/3.4.0


FileInfoclu=$1

	# awk "{print \$1\"\t\"substr(\$1,1,4)\"\t\"\$2}" $FileInfoclu > $FileInfoclu-3-cols
	# Use first 4 letters, but relace "_" and Change Alp[0-9] to Alp

# In the new version of 125 genomes, I forgot to change gene index of Xsor genome, so here also to change it. 

awk "{print \$1\"\t\"substr(\$1,1,4)\"\t\"\$2}" $FileInfoclu|awk '{gsub("_","",$2)}1'|awk '{gsub("Alp[0-9]","Alp",$2)}1'| awk '{gsub("XS[0-9][0-9]","Xsor",$2)}1'|awk '{gsub("XSUN","Xsor",$2)}1'  > $FileInfoclu-3-cols 

sed "/^name.*/d" $FileInfoclu-3-cols|sed "1iGene\tSpecies\tCluster" > $FileInfoclu-3-cols-input

	#[for mcl input] sed "1iGene\tSpecies\tCluster" > $FileInfoclu-3-cols-input

	#Rscript /home/tazha/Scripts/ProcessPhyPro_v150.r $FileInfoclu-3-cols-input $FileInfoclu-3-cols-input-profiled $FileInfoclu-3-cols-input-profiled-clustered

Rscript /home/tazha/Scripts/ProcessPhyPro_v125_justprofiling.r $FileInfoclu-3-cols-input $FileInfoclu-3-cols-input-profiled

rm $FileInfoclu-3-cols

	#mv args\[3\].pdf $1.pdf

