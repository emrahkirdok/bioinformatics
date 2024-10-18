#!/bin/bash

#SBATCH -J cutadapt-trimming-se

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

cutadapt -q 20 -a AGATCGGAAGAG --minimum-length 30 -j 4 -o results/processed/SRR7029604.fastq.gz data/SRR7029604.fastq.gz

mkdir -p results/fastqc-after-trimming

fastqc results/processed/SRR7029604.fastq.gz --thread 4 --nogroup --outdir results/fastqc-after-trimming


