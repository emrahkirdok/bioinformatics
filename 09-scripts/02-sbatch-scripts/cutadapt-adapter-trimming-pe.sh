#!/bin/bash

#SBATCH -J cutadapt-trimming-pe

#SBATCH -p barbun
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 20
#SBATCH --time=01:00:00

#SBATCH -o logs/%x-%j-%N-%u.out
#SBATCH -e logs/%x-%j-%N-%u.err

mkdir -p results/processed

# containers
SINGULARITY_CUTADAPT=/arf/home/egitimg14/Projects/Lectures/00-Quality-Control/containers/cutadapt\:5.0--py39hbcbf7aa_0
SINGULARITY_FASTQC=/arf/home/egitimg14/Projects/Lectures/00-Quality-Control/containers/fastqc\:0.12.1--hdfd78af_0

# tool parameters
THREADS=10
QUALITY=20
MIN_LENGTH=10
ADAPTER=AGATCGGAAGAG

singularity run ${SINGULARITY_CUTADAPT} cutadapt -q ${QUALITY} --minimum-length ${MIN_LENGTH} --trim-n -Z -j ${THREADS} -a ${ADAPTER} -A ${ADAPTER} -o results/processed/SRR7405885_1.fastq.gz -p results/processed/SRR7405885_2.fastq.gz data/SRR7405885_1.fastq.gz data/SRR7405885_2.fastq.gz

mkdir -p results/fastqc-after-trimming

singularity run ${SINGULARITY_FASTQC} fastqc results/processed/SRR7405885_1.fastq.gz results/processed/SRR7405885_2.fastq.gz --thread 4 --nogroup --outdir results/fastqc-after-trimming

