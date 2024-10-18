#!/bin/bash

#SBATCH -J fastqc-before-trimming

#SBATCH --partition=barbun
#SBATCH --ntasks-per-node=4
#SBATCH --time=00:30:00

#SBATCH -o logs/%x-%j-%N-%u.out
#SBATCH -e logs/%x-%j-%N-%u.err

# conda programini aktive edelim
eval "$(/truba/home/$USER/miniconda3/bin/conda shell.bash hook)"

# conda cevresini aktive edelim
conda activate quality-control

# cikti klasorlerimizi belirleyelim

mkdir -p results/fastqc-before-trimming

# fastqc programini calistir

fastqc data/SRR7029604.fastq.gz  data/SRR7405885_1.fastq.gz data/SRR7405885_2.fastq.gz --thread 4 --nogroup --outdir results/fastqc-before-trimming



