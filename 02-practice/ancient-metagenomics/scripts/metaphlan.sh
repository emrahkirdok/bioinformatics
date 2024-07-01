#!/usr/bin/env bash

ml bioinfo-tools MetaPhlAn3 samtools

# Database location
DB=/sw/bioinfo/MetaPhlAn3/3.0.8/rackham/lib/python3.8/site-packages/metaphlan/metaphlan_databases
# Database name
DBNAME=mpa_v30_CHOCOPhlAn_201901

ID=ble004
FILES=sequences.txt
THREADS=10

# Run metaphlan for every fastq file of a specific sample
for FASTQ in $(grep ${ID} ${FILES})
do
	BASE=$(basename $FASTQ _unmapped.fastq.gz)
	metaphlan --input_type fastq ${FASTQ} -s results/metaphlan/${BASE}.sam --nproc ${THREADS} --bowtie2out results/metaphlan/${BASE}.bowtie2out --bowtie2db ${DB} -x ${DBNAME} > results/metaphlan/${BASE}_metaphlan.txt

	# Convert sam files to a bam file, and sort
	# This makes the process fast	
	samtools view -Sb results/metaphlan/${BASE}.sam > results/metaphlan/${BASE}.bam
	samtools sort results/metaphlan/${BASE}.bam > results/metaphlan/${BASE}.sorted.bam
done

# Collect all bam files for a specific sample	
BAMS=""

for FASTQ in $(grep ${ID} ${FILES})
do
	BASE=$(basename $FASTQ _unmapped.fastq.gz)
	BAMS="${BAMS} results/metaphlan/${BASE}.sorted.bam"
done

# Merge all bam files that belongs to the specific sample
samtools merge -o results/metaphlan/${ID}.bam ${BAMS}
samtools sort results/metaphlan/${ID}.bam > results/metaphlan/${ID}.sorted.bam

# Mark duplicates
samtools markdup -r results/metaphlan/${ID}.sorted.bam  results/metaphlan/${ID}.sorted.rmdup.bam

# Metaphlan3 can read sam files. But it has to be a sam file, so convert it to a sam file
samtools view -h results/metaphlan/${ID}.sorted.rmdup.bam > results/metaphlan/${ID}.sorted.rmdup.sam

# Run metaphlan3 for the sam file
metaphlan --input_type sam results/metaphlan/${ID}.sorted.rmdup.sam \
	-s ${ID}.sam --nproc ${THREADS} \
	--bowtie2out results/metaphlan/${ID}.bowtie2out \
	--bowtie2db ${DB} -x ${DBNAME} >  results/metaphlan/${ID}_metaphlan.txt
