module load blic-modules nextflow
source ~/.bash_profile # to reset tower credentials

#-------------------------
#- UCL-AWS, manual set up
#-------------------------

#- hello_2 pipeline
#------------------

nextflow run lconde-ucl/hello_2 -r main --outdir results_hello -with-tower -profile local
nextflow run lconde-ucl/hello_2 -r main --outdir results_hello -with-tower -profile myriad
nextflow run lconde-ucl/hello_2 -r main --outdir results_hello -with-tower -profile aws
nextflow run lconde-ucl/hello_2 -r main --outdir s3://lconde-nf-bucket/results -with-tower -profile aws


#- nf-core/demo pipeline (does not need a genome)
#------------------------------------------------

nextflow run nf-core/demo --input ./param_files/samplesheet_demo.csv --outdir results_demo -with-tower -profile local
nextflow run nf-core/demo --input ./param_files/samplesheet_demo.csv --outdir results_demo -with-tower -profile myriad
nextflow run nf-core/demo --input ./param_files/samplesheet_demo.csv --outdir results_demo -with-tower -profile aws


#--------------------------------
#- UCL-AWS, seqera set up via CLI
#- https://docs.seqera.io/platform/23.2.0/compute-envs/aws-batch#batch-forge
#--------------------------------

module load blic-modules tw

workspace_id=245195564471471
access_token="eyJ0aWQiOiA4MjQ2fS41MDkxMDlhNTQyYTZiZTRhMjM1NjY1MThjOWUxMDMzMmQ3YjIyYTRk"
compute_environment="ucl-aws"


#- nf-core/demo pipeline (does not need a genome)
#------------------------------------------------

tw -t $access_token launch -w $workspace_id -c $compute_environment demo --params-file=param_files/params_demo.txt


#- nf-core/rnaseq pipeline (uses the test dataset: some
#-	pombe data with fasta file, gtf, etc, so it does
#-	not need -genome, these files are loaded by default)
#--------------------------------------------------------

tw -t $access_token launch -w $workspace_id -c $compute_environment rnaseq_test --params-file=param_files/params_rnaseq_test.txt


#- nf-core/rnaseq pipeline, with attached dataset.
#-	This pipeline runs with these defaults if submitted via platform:
#-	  outdir: 's3://lconde-tower-bucket/rnaseq/results'
#-	  igenomes_base: 's3://lconde-igenomes/igenomes'
#-	  genome: 'GRCh38'
#-	but here i need to add these params as these are not used by default
#-
#- It runs if I add data from github, or if it's in a 
#-	bucket, but it does not run if I try to add
#-	files from local
#-----------------------------------------------------------

#– run it with a dataset that I have in github
tw -t $access_token launch -w $workspace_id -c $compute_environment rnaseq --params-file=param_files/params_rnaseq.txt







