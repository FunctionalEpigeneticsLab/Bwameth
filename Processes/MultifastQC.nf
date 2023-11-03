process MULTIFASTQC {
        tag "Performing MultiFastQC..."
        publishDir "${baseDir}/Results/Reports/${params.batch}", mode: 'copy'
        input:
        path "*"

        output:
        path "*.html"

        script:
        """
        ${params.multiqc} .
        """
}