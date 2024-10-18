#!/bin/bash

#SBATCH -J cutadapt-trimming-pe

#SBATCH --partition=barbun
#SBATCH --ntasks-per-node=4
#SBATCH --time=00:30:00

#SBATCH -o logs/%x-%j-%N-%u.out
#SBATCH -e logs/%x-%j-%N-%u.err

# activate conda 
eval "$(/truba/home/$USER/miniconda3/bin/conda shell.bash hook)"

# activate conda environment
conda activate quality-control

mkdir -p results/processed

cutadapt -q 20 --minimum_length  30 --trim-n -Z -j 4 -a AGATCGGAAGAG -A AGATCGGAAGAG -o results/processed/SRR7405885_1.fastq.gz -p results/processed/SRR7405885_2.fastq.gz data/SRR7405885_1.fastq.gz data/SRR7405885_2.fastq.gz

mkdir -p results/fastqc-after-trimming

fastqc results/processed/SRR7405885_1.fastq.gz results/processed/SRR7405885_2.fastq.gz --thread 4 --nogroup --outdir results/fastqc-after-trimming


