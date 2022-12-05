#!/usr/bin/env nextflow

//params.index_db = "mpa_vJan21_CHOCOPhlAnSGB_202103"
//params.mpa_db = "/home/ubuntu/metaphlan_databases"
//params.input_fastqs = "$baseDir/fastq/*_{1,2}.fastq.gz"
//params.out = "mpa4_output"

fastq_files = Channel.fromFilePairs(params.input_fastqs, type: 'file')
mpa_db = file(params.mpa_db)


workflow {
    mpa_fastq(fastq_files, mpa_db, params.index_db)
}


process mpa_fastq {

    //errorStrategy 'ignore'
    publishDir params.out, mode: 'copy', overwrite: true
    memory '30 GB'
    cpus 4
    input:
    tuple val(name), file(fastq) 
    file(mpa_db)
    val(index_db)

    output:
    file("*.txt")

    """
    metaphlan ${fastq[0]},${fastq[1]} --input_type fastq -o ${name}.txt --bowtie2out ${name}.bowtie2.bz2 --index ${params.index_db} --bowtie2db ${mpa_db} --nproc 4 --unclassified_estimation
    """
}


