#!/usr/bin/env nextflow

/**
 * Specifying input files from command line
 */
params.r1 = null
params.r2 = null

/**
 * Trimming fastq files
 */

process trim_reads {

    //Setting input
    input: 
    file r1
    file r2

    //Setting output
    output: 
    file "r1_trimmed.fastq.gz"
    file "r2_trimmed.fastq.gz"   

    //Trimmomatic command for trimming
    script: 
    """ 
    trimmomatic PE -phred33 $r1 $r2 r1_trimmed.fastq.gz r1_unpaired.fastq.gz r2_trimmed.fastq.gz r2_unpaired.fastq.gz SLIDINGWINDOW:5:30 AVGQUAL:30
    """ 
}

/**
 * Assembly
 */

process assemble_reads {

    //Setting input
    input:
    file "r1_trimmed.fastq.gz"
    file "r2_trimmed.fastq.gz"

    //Setting output
    output: 
    file "skesa_assembly.fna"

    //Assembly
    script: 
    """ 
    skesa --reads r1_trimmed.fastq.gz r2_trimmed.fastq.gz --contigs_out skesa_assembly.fna
    """ 
}

/**
 * Quality assessment of the assembly by QUAST
 */

process quality_assessment {

    //Setting input
    input:
    file "skesa_assembly.fna"

    //Setting output
    output: 
    file "quast_report"

    //Quality assessment
    script: 
    """ 
    quast skesa_assembly.fna -o quast_report
    """ 
}

/**
 * Genotyping by MLST
 */

process genotyping {

    //Setting input
    input:
    file "skesa_assembly.fna"

    //Setting output
    output: 
    file "mlst_results"

    //Genotyping
    script: 
    """ 
    mlst skesa_assembly.fna > mlst_results
    """ 
}

/**
 * Workflow
 */

workflow {
    // Workflow to instruct on process sequence and setting channels for input
    def file1_ch = Channel.fromPath(params.r1)
    def file2_ch = Channel.fromPath(params.r2)

    // Initiating trim_reads process
    trim_reads(file1_ch, file2_ch) | assemble_reads
    assemble_reads.out | quality_assessment
    assemble_reads.out | genotyping
}
