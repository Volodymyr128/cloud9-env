params.input_path = 's3://nextflow-data-bucket/input/test.doc'
params.output_dir = 's3://nextflow-data-bucket/output/'


log.info """
    My first Next Flow pipeline
    ===========================
    input_path : ${params.input_path}
    output_dir : ${params.output_dir}
""".stripIndent()

process sayHello {
    container 'volodymyr128/mypython:1.8'
    cpus 1
    disk '10 GB'
    echo true
    memory '1 GB'


    output:
    stdout receiver

    """
        echo 128
    """
}

receiver.view { "Received: $it" }

process convertFile {
    container 'volodymyr128/doc-converter:1.32'
    cpus 2
    disk '20 GB'
    echo true
    memory '2 GB'
    publishDir params.output_dir

    input:
    path file from params.input_path

    output:
    file 'test.pdf'

    """
        java -jar /usr/local/converter.jar -i "test.doc" -o "test.pdf" -t "DOC"
    """
}

workflow.onComplete {
	println ( workflow.success ? "Done" : "Oops .. something went wrong" )
}
