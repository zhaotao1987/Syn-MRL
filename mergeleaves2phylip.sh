# *.
echo bash mergeleaves2phylip.sh folder/ string_label
echo The script will combine all rows and convert into columns, and transpose to a phylip format file

folder=$1
name=$2

cd $folder

# over95
# don't forget to use over95 as names, to avoid overwrite

cat *.leaves_extracted > 'all_'$name'_trees_signals'
bash ~/Scripts/row2column.sh 'all_'$name'_trees_signals'
bash ~/Scripts/PhylogeneticProfiling_v125_justprofiling.sh 'all_'$name'_trees_signals-2col_info'
Rscript ~/Scripts/BinaryDataandTranspose.r 'all_'$name'_trees_signals-2col_info-3-cols-input-profiled' 1

matrix=*$name*binary_transposed
col=($(awk -F' ' '{print NF; exit}' $matrix))
row=($(wc -l $matrix))
col2=$(expr $col - 1)

#echo $col2
#echo $row

sed -i "1i$row $col2" $matrix

cd ../
