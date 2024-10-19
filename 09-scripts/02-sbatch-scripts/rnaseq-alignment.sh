#!/bin/bash

#SBATCH -J rnaseq-alignment

#SBATCH --partition=barbun
#SBATCH --ntasks-per-node=4
#SBATCH --time=01:00:00

#SBATCH -o logs/%x-%j-%N-%u.out
#SBATCH -e logs/%x-%j-%N-%u.err

# activate conda 
eval "$(/truba/home/$USER/miniconda3/bin/conda shell.bash hook)"

# activate environment

conda activate rnaseq

# create folders

mkdir -p results/alignment

# align reads, directly

bowtie2-align-s -x data/ref/GCA_000007565.2_ASM756v2_genomic.fna -p 4 -U results/processed/SRR7029605.fastq.gz |  samtools view -F4 -q30 -Sb > results/alignment/SRR7029605.bam

samtools sort results/alignment/SRR7029605.bam -o results/alignment/SRR7029605.sorted.bam

samtools index results/alignment/SRR7029605.sorted.bam