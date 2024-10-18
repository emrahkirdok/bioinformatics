#!/bin/bash

#SBATCH -J quality-control-and-cutadapt

#SBATCH --partition=barbun
#SBATCH --ntasks-per-node=4
#SBATCH --time=01:00:00

#SBATCH -o logs/%x-%j-%N-%u.out
#SBATCH -e logs/%x-%j-%N-%u.err

# activate conda 
eval "$(/truba/home/$USER/miniconda3/bin/conda shell.bash hook)"

# activate conda environment
conda activate quality-control

# this time let's create a parameter
# with this way we can reuse our scripts on different samples

ID=ERR3079326

mkdir -p results/fastqc-before-trimming

# run fastqc on raw reads

fastqc data/fastq/${ID}_1.fastq.gz data/fastq/${ID}_2.fastq.gz --thread 4 --nogroup --outdir results/fastqc-before-trimming

# run cutadapt

mkdir -p results/processed

cutadapt -q 20 --minimum_length  30 --trim-n -Z -j 4 -a AGATCGGAAGAG -A AGATCGGAAGAG -o results/processed/${ID}_1.fastq.gz -p results/processed/${ID}_2.fastq.gz data/fastq/${ID}_1.fastq.gz data/fastq/${ID}_2.fastq.gz

# run fastqc on processed reads

mkdir -p results/fastqc-after-trimming

fastqc results/processed/${ID}_1.fastq.gz results/processed/${ID}_2.fastq.gz --thread 4 --nogroup --outdir results/fastqc-after-trimming


