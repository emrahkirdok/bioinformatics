#!/bin/bash

#SBATCH -J quality-control-and-cutadapt

#SBATCH -p barbun
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 40
#SBATCH --time=01:00:00

#SBATCH -o logs/%x-%j-%N-%u.out
#SBATCH -e logs/%x-%j-%N-%u.err


SINGULARITY_CUTADAPT=/arf/home/egitimg14/Projects/Lectures/00-Quality-Control/containers/cutadapt\:5.0--py39hbcbf7aa_0
SINGULARITY_FASTQC=/arf/home/egitimg14/Projects/Lectures/00-Quality-Control/containers/fastqc\:0.12.1--hdfd78af_0

ID=ERR3079326

mkdir -p results/fastqc-before-trimming

# run fastqc on raw reads

singularity run ${SINGULARITY_FASTQC} fastqc data/fastq/${ID}_1.fastq.gz data/fastq/${ID}_2.fastq.gz --thread 4 --nogroup --outdir results/fastqc-before-trimming

# run cutadapt

mkdir -p results/processed

singularity run ${SINGULARITY_CUTADAPT} cutadapt -q 20 -m 30 --trim-n -Z -j 4 -a AGATCGGAAGAG -A AGATCGGAAGAG -o results/processed/${ID}_1.fastq.gz -p results/processed/${ID}_2.fastq.gz data/fastq/${ID}_1.fastq.gz data/fastq/${ID}_2.fastq.gz

# run fastqc on processed reads

mkdir -p results/fastqc-after-trimming

singularity run ${SINGULARITY_FASTQC} fastqc results/processed/${ID}_1.fastq.gz results/processed/${ID}_2.fastq.gz --thread 4 --nogroup --outdir results/fastqc-after-trimming


