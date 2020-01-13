# Usage: bash ~/Script/Infomap.sh 2-cols-edgelist

# Input: full edge infomation blocks
# Process: prepare edgelist, infomap, ID conversion, Profiling, binary and Transpose, prepare phylip matrix. 
# Output: 

# load module

	module load R 
	module load python2/x86_64/2.7.14
# Define Input

	InputNet=$1
	export PATH=/home/tazha/Programs/Infomap:$PATH

# Use R to prepare input
	
	Rscript /home/tazha/Scripts/PrepareInput.r $InputNet

# Change name, make folder

	mv $InputNet.pajek $InputNet.net
#	mkdir -p standalone_infomap_clustering_unweighted

	mkdir -p $InputNet'_infomapClustering'

# Run stand-alone infomap

#	Infomap  $InputNet.net standalone_infomap_clustering_unweighted  --clu -N 10 --map -2
#       Infomap  $InputNet.net standalone_infomap_clustering_unweighted  --clu -N 5 --map -2

Infomap  $InputNet.net $InputNet'_infomapClustering'  --clu -N 10 --map -2

# can print out all the levels

#	Infomap  $InputNet.net standalone_infomap_clustering_unweighted  --clu -N 1 --tree

# Post-process the output

	python /home/tazha/Scripts/ReplaceNames.py $InputNet.nodelist $InputNet'_infomapClustering'/$InputNet.clu $InputNet'_infomapClustering'/Fixed-$InputNet.clu

# Let's continue

# make 2-column clustering result
sed "/#/d" $InputNet'_infomapClustering'/Fixed-$InputNet.clu|cut -f1,2 > $InputNet'_infomapClustering'/Fixed-$InputNet.clu_2cols

# run PhyProfiling
bash /home/tazha/Scripts/PhylogeneticProfiling_v125_justprofiling.sh $InputNet'_infomapClustering'/Fixed-$InputNet.clu_2cols

# binary and transpose matrix, size can be changed, now is 1 

Rscript /home/tazha/Scripts/BinaryDataandTranspose.r $InputNet'_infomapClustering'/Fixed-$InputNet.clu_2cols-3-cols-input-profiled 1

# check columns and rows

matrix=$InputNet'_infomapClustering'/*binary_transposed

col=($(awk -F' ' '{print NF; exit}' $matrix))
row=($(wc -l $matrix))
col2=$(expr $col - 1)

#echo $col2
#echo $row

sed -i "1i$row $col2" $matrix


