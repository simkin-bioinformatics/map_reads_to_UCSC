'''
Currently, this program takes bam files from a folder and creates a bam hub and
a bigwig hub. Eventually, the program will start further back (with fastq files)
'''
configfile: 'bam_and_bigwig_hubs.yaml'

rule all:
	input:
		bigwig_hub=config['output_folder']+'/bigwig_hub.txt',
		bam_hub=config['output_folder']+'/bam_hub.txt',
		snakemake=config['output_folder']+'/snakemake_params/bam_and_bigwig_hubs.smk'
	
rule copy_files:
	input:
		envs='envs',
		scripts='scripts',
		yaml='bam_and_bigwig_hubs.yaml',
		snakemake='bam_and_bigwig_hubs.smk'
	output:
		envs=directory(config['output_folder']+'/snakemake_params/envs'),
		scripts=directory(config['output_folder']+'/snakemake_params/scripts'),
		yaml=config['output_folder']+'/snakemake_params/bam_and_bigwig_hubs.yaml',
		snakemake=config['output_folder']+'/snakemake_params/bam_and_bigwig_hubs.smk'
	shell:
		'''
		cp -R {input.envs} {output.envs}
		cp -R {input.scripts} {output.scripts}
		cp {input.yaml} {output.yaml}
		cp {input.snakemake} {output.snakemake}
		'''

rule run_bamcoverage:
	input:
		bam=config['output_folder']+'/'+config['bam_subfolder']+'/{sample}_sorted.bam'
	params:
		bin_size=5
	threads: 4
	conda:
		'envs/deeptools.yaml'
	output:
		bigwig=config['output_folder']+'/bigwigs/{sample}.bw'
	shell:
		'bamCoverage --binSize {params.bin_size} -p {threads} -b {input.bam} -o {output.bigwig}'

rule make_bam_hub:
	input:
		bigwig=expand(config['output_folder']+'/bigwigs/{sample}.bw', sample=config['samples']),
		bam=expand(config['output_folder']+'/'+config['bam_subfolder']+'/{sample}_sorted.bam', sample=config['samples'])
	params:
		email=config['email'],
		bam_hub_name=config['bam_hub_name'],
		genome=config['genome'],
		sample_list=expand(config['bam_subfolder']+'/{sample}_sorted.bam', sample=config['samples']),
		url_prefix=config['url_prefix']
	output:
		hub_name=config['output_folder']+'/bam_hub.txt'
	script:
		'scripts/make_bam_hub.py'

rule make_bigwig_hub:
	input:
		bigwig=expand(config['output_folder']+'/bigwigs/{sample}.bw', sample=config['samples'])
	params:
		email=config['email'],
		bigwig_hub_name=config['bigwig_hub_name'],
		genome=config['genome'],
		sample_list=expand('bigwigs/{sample}.bw', sample=config['samples']),
		url_prefix=config['url_prefix']
	output:
		hub_name=config['output_folder']+'/bigwig_hub.txt'
	script:
		'scripts/make_bigwig_hub.py'
