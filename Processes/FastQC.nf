process FASTQC {
        tag "Performing FastQC..."
        publishDir "${baseDir}/Results/Cache/FastQC/${params.batch}"
        input:
        path(reads)

        output:
        path "*.html", emit: htmls
        path "*.zip", emit: zips

        script:
        """
        ${params.fastqc} -t ${task.cpus} $reads
        """
}