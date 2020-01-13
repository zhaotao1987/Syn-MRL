# qsub -cwd -pe serial 57 -l h_vmem=1G run_Phylogeny_pipeline.sh

# qsub -cwd -pe serial 75 -l h_vmem=1G run_Phylogeny_pipeline.sh

# first batch
# bash Phylogeny_pipeline.sh clusters/ 19 3

# second

bash Phylogeny_pipeline.sh clusters/ 25 3

