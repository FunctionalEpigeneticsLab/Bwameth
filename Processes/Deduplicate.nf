process DEDUPLICATE {
	tag "Deduplicating..."
	publishDir "${baseDir}/Results/Cache/Alignment/Deduplicated"

	input:
	path(bam_file)
	output:
	tuple path("dedup*.bam"), path("dedup*.bai")


	script:
	"""
	java -Xmx150g -jar ${params.picard} MarkDuplicates TMP_DIR=`pwd`/tmp REMOVE_DUPLICATES=true I=${bam_file} O=dedup_${bam_file} M=metrics_${bam_file} 2> /dev/null
	samtools index dedup*.bam
	"""
}