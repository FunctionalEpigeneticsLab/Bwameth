process ALIGN {
	tag "Aligning using Bwameth..."
	publishDir "${baseDir}/Results/Cache/Alignment/Raw"

	input:
	path bwameth_index
	tuple val(sample), path(file1), path(file2)

	output:

	path("*.bam")

	script:
	"""
	${params.bwameth} --threads ${task.cpus} --reference ${bwameth_index}/*.fasta $file1 $file2 | samtools view -S -b | samtools sort -o ${sample}.bam
	"""
}