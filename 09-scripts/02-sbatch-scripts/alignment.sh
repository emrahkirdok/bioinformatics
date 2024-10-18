#!/bin/bash

#SBATCH -J alignment

#SBATCH --partition=barbun
#SBATCH --ntasks-per-node=4
#SBATCH --time=01:00:00

#SBATCH -o logs/%x-%j-%N-%u.out
#SBATCH -e logs/%x-%j-%N-%u.err

# activate conda 
eval "$(/truba/home/$USER/miniconda3/bin/conda shell.bash hook)"

# activate environment

conda activate alignment

# create folders

mkdir -p results/alignment

# align reads, first create index files

bwa aln -t 4 data/ref/GCF_000014205.1_ASM1420v1_genomic.fna data/fastq/ERR3079326_1.fastq.gz > results/alignment/ERR3079326_1.sai
bwa aln -t 4 data/ref/GCF_000014205.1_ASM1420v1_genomic.fna data/fastq/ERR3079326_2.fastq.gz > results/alignment/ERR3079326_2.sai

# now create sam file

bwa sampe data/ref/GCF_000014205.1_ASM1420v1_genomic.fna results/alignment/ERR3079326_1.sai results/alignment/ERR3079326_2.sai data/fastq/ERR3079326_1.fastq.gz data/fastq/ERR3079326_2.fastq.gz > results/alignment/ERR3079326.sam

# remove unaligned reads and create bam file

samtools view -Sb -F4 results/alignment/ERR3079326.sam > results/alignment/ERR3079326.bam

# sort bam file and index it for fast process

samtools sort results/alignment/ERR3079326.bam -o results/alignment/ERR3079326.sorted.bam
samtools index results/alignment/ERR3079326.sorted.bam

# remove optical pcr duplicates and index

samtools rmdup results/alignment/ERR3079326.sorted.bam results/alignment/ERR3079326.sorted.rmdup.bam
samtools index results/alignment/ERR3079326.sorted.rmdup.bam