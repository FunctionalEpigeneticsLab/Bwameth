process EXTRACT_CPGS {
	tag "Extracting methylation...."
	publishDir "${baseDir}/Results/MethExtracts/CpGs", mode: 'copy'
	input:
	path bwameth_index
	tuple path(bam_file), path(bai_file)
	path cpgs
	output:
	path "*.bedGraph", emit: methylkits
	script:
	"""
	${params.methyldackel} extract -@ ${task.cpus} -l $cpgs --mergeContext ${bwameth_index}/*.fasta $bam_file
	"""	

}

process EXTRACT_REGIONS {
	tag "Extracting methylation...."
	publishDir "${baseDir}/Results/MethExtracts/Regions", mode: 'copy'
	input:
	path bwameth_index
	tuple path(bam_file), path(bai_file)
	path regions
	output:
	path "*.bedGraph", emit: methylkits
	script:
	"""
	${params.methyldackel} extract -@ ${task.cpus} -l $regions --mergeContext ${bwameth_index}/*.fasta $bam_file
	"""	

}