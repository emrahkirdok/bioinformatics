#!/bin/bash

#SBATCH -J variant-calling

#SBATCH -p barbun
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 40
#SBATCH -C weka
#SBATCH --time=01:00:00

#SBATCH -o logs/%x-%j-%N-%u.out
#SBATCH -e logs/%x-%j-%N-%u.err

# activate conda 
eval "$(/truba/home/$USER/miniconda3/bin/conda shell.bash hook)"

# activate environment

conda activate alignment

# create folders

mkdir -p results/variants

# create pileup file

bcftools mpileup -Ov -f data/ref/GCF_000014205.1_ASM1420v1_genomic.fna results/alignment/ERR3079326.sorted.rmdup.bam > results/variants/ERR3079326.sorted.rmdup.likelihoods.vcf

# call variants

bcftools call -mv -Ov -o results/variants/ERR3079326.sorted.rmdup.calls.vcf results/variants/ERR3079326.sorted.rmdup.likelihoods.vcf

# this can be done easily with a oneliner, bcf is a compressed file

bcftools mpileup -Ou --threads 4 -f data/ref/GCF_000014205.1_ASM1420v1_genomic.fna results/alignment/ERR3079326.sorted.rmdup.bam | bcftools call -mv -Ob --threads 4 -o results/variants/ERR3079326.sorted.rmdup.calls.bcf