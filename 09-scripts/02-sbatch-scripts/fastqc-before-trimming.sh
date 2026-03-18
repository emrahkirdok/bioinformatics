#!/bin/bash

#SBATCH -J fastqc-before-trimming

#SBATCH -p barbun
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 40
#SBATCH --time=01:00:00

#SBATCH -o logs/%x-%j-%N-%u.out
#SBATCH -e logs/%x-%j-%N-%u.err

# cikti klasorlerimizi belirleyelim

mkdir -p results/fastqc-before-trimming

# fastqc programini calistir

SINGULARITY=/arf/home/egitimg14/Projects/Lectures/00-Quality-Control/containers/fastqc\:0.12.1--hdfd78af_0

# fastqc programini calistir

singularity run ${SINGULARITY} fastqc data/SRR7029604.fastq.gz  data/SRR7405885_1.fastq.gz data/SRR7405885_2.fastq.gz --thread 4 --nogroup --outdir results/fastqc-before-trimming



