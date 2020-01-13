echo	Usage: bash Phylogeny_pipeline.sh folder Parallel each

INPUT_f=$1
Prot_DB='/ngsprojects/synnet/data_archive/Selection125/Selection125PEP'
CPU=$2
each=$3

## LOAD MODULES ##

module load mafft
module load fasttree/x86_64/2.1.7
module load python2/x86_64/2.7.2 
module load trimal/x86_64/1.4.1 
module load iqtree/x86_64/1.7.0b7 
module load raxml/x86_64/8.2.9
module load seqtk/x86_64/20150105


function scale {
    while [ $(jobs -p | wc -l) -ge "$CPU" ]; do
        sleep 1
    done
}


cd $INPUT_f

for f in *_nodelist; do

scale; (
	seqtk subseq $Prot_DB $f |sed '/^[^>]/s/\.//g' > "$f".pep
	mafft --retree 1 --reorder "$f".pep >  "$f".pep_align_1
	awk '/^>/{f=!d[$1];d[$1]=1}f' "$f".pep_align_1 > "$f".pep_align	
	trimal -in "$f".pep_align -out "$f".pep_align_trim1 -automated1
	trimal -in "$f".pep_align_trim1 -out "$f".pep_align_trimmed  -seqoverlap 50 -resoverlap 0.5
	perl /home/tazha/Scripts/Fasta2Phylip.pl "$f".pep_align_trimmed "$f".pep_align_trimmed.phylip
	iqtree -s "$f".pep_align_trimmed.phylip -m JTT+R -alrt 1000 -bb 1000 -nt $each -redo
)&

done

wait

