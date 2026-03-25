#!/bin/bash

#SBATCH -J alignment

#SBATCH -p barbun
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 40
#SBATCH --time=01:00:00

#SBATCH -o logs/%x-%j-%N-%u.out
#SBATCH -e logs/%x-%j-%N-%u.err


mkdir -p results/alignment

# containers
SINGULARITY_BWA=/arf/home/egitimg14/Lectures/01-Alignment/containers/bwa_latest.sif
SINGULARITY_SAMTOOLS=/arf/home/egitimg14/Lectures/01-Alignment/containers/samtools_1.21.sif

# index reference genome

singularity run ${SINGULARITY_BWA} bwa index data/ref/GCF_000014205.1_ASM1420v1_genomic.fna

# align reads, first create index files

singularity run ${SINGULARITY_BWA} bwa aln -t 4 data/ref/GCF_000014205.1_ASM1420v1_genomic.fna results/processed/ERR3079326_1.fastq.gz > results/alignment/ERR3079326_1.sai
singularity run ${SINGULARITY_BWA} bwa aln -t 4 data/ref/GCF_000014205.1_ASM1420v1_genomic.fna results/processed/ERR3079326_2.fastq.gz > results/alignment/ERR3079326_2.sai

# now create sam file

singularity run ${SINGULARITY_BWA} bwa sampe data/ref/GCF_000014205.1_ASM1420v1_genomic.fna results/alignment/ERR3079326_1.sai results/alignment/ERR3079326_2.sai results/processed/ERR3079326_1.fastq.gz results/processed/ERR3079326_2.fastq.gz > results/alignment/ERR3079326.sam

# remove unaligned reads and create bam file

singularity run ${SINGULARITY_SAMTOOLS} samtools view -Sb -F4 results/alignment/ERR3079326.sam > results/alignment/ERR3079326.bam

# sort bam file and index it for fast process

singularity run ${SINGULARITY_SAMTOOLS} samtools sort results/alignment/ERR3079326.bam -o results/alignment/ERR3079326.sorted.bam
singularity run ${SINGULARITY_SAMTOOLS}samtools index results/alignment/ERR3079326.sorted.bam

# remove optical pcr duplicates and index

singularity run ${SINGULARITY_SAMTOOLS} samtools rmdup results/alignment/ERR3079326.sorted.bam results/alignment/ERR3079326.sorted.rmdup.bam
singularity run ${SINGULARITY_SAMTOOLS} samtools index results/alignment/ERR3079326.sorted.rmdup.bam
