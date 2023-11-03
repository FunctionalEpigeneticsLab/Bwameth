nextflow.enable.dsl=2
params.reads="${params.workingDir}/*${params.pattern}{1, 2}.fastq.gz"
reads=Channel.fromFilePairs(params.reads)
params.all_reads="${params.workingDir}/*.fastq.gz"
all_reads = Channel.fromPath(params.all_reads)

include { DEDUPLICATE   } from './Processes/Deduplicate.nf'
include { FASTQC } from './Processes/FastQC.nf'
include { MULTIFASTQC } from './Processes/MultifastQC.nf'
include { TRIM } from './Processes/Trim_galore.nf'
include { ALIGN } from './Processes/Align.nf'
include { EXTRACT_CPGS } from './Processes/Extract_methylation.nf'
include { EXTRACT_REGIONS } from './Processes/Extract_methylation.nf'


log.info """\
    B W A - M E T H    A L I G N  P I P E L I N E
    =============================================
    reference	 : ${params.index}
    reads        : ${params.reads}
    """
    .stripIndent()

workflow {
	FASTQC(all_reads)
        html_ch=FASTQC.out.htmls
        zip_ch=FASTQC.out.zips
        MULTIFASTQC(html_ch.mix(zip_ch).collect())	

	trim_ch = TRIM(reads)
	align_ch=ALIGN(params.index, trim_ch)
	deduplicate_ch=DEDUPLICATE(align_ch)

	EXTRACT_REGIONS(params.index, deduplicate_ch, params.regions)
	EXTRACT_CPGS(params.index, deduplicate_ch, params.cpgs)


}

workflow.onComplete {
	log.info (workflow.success? "Done!" : "Oops... something went wrong")
}
