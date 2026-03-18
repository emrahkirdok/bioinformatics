#!/bin/bash

#SBATCH -J cutadapt-trimming-se

#SBATCH -p barbun
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 20
#SBATCH --time=02:00:00

#SBATCH -o logs/%x-%j-%N-%u.out
#SBATCH -e logs/%x-%j-%N-%u.err

# containers
SINGULARITY_CUTADAPT=/arf/home/egitimg14/Projects/Lectures/00-Quality-Control/containers/cutadapt\:5.0--py39hbcbf7aa_0
SINGULARITY_FASTQC=/arf/home/egitimg14/Projects/Lectures/00-Quality-Control/containers/fastqc\:0.12.1--hdfd78af_0

# tool parameters
THREADS=10
QUALITY=20
MIN_LENGTH=10
ADAPTER=AGATCGGAAGAG

# create output folders
mkdir -p results/processed

singularity run ${SINGULARITY_CUTADAPT} cutadapt -q ${QUALITY} -a ${ADAPTER} --minimum-length ${MIN_LEN} -j ${THREADS} -o results/processed/SRR7029604.fastq.gz data/SRR7029604.fastq.gz

mkdir -p results/fastqc-after-trimming

singularity run ${SINGULARITY_FASTQC} fastqc results/processed/SRR7029604.fastq.gz --thread ${THREADS} --nogroup --outdir results/fastqc-after-trimming
