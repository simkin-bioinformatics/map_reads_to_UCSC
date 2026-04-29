# map_reads_to_UCSC

A Snakemake pipeline that takes sorted BAM files and generates UCSC Genome Browser track hubs for both BAM and bigWig tracks.

## What it does

1. Converts BAM files to bigWig format using `bamCoverage` (deepTools)
2. Generates a BAM track hub file (`bam_hub.txt`)
3. Generates a bigWig track hub file (`bigwig_hub.txt`)
4. Copies pipeline files to the output directory for reproducibility

Once complete, the hub files can be loaded directly into the UCSC Genome Browser via their hosted URL.

## Requirements

- [Snakemake](https://snakemake.readthedocs.io/)
- Conda (for the deepTools environment)

## Setup

Edit `bam_and_bigwig_hubs.yaml` to match your project:

```yaml
output_folder: path/to/output       # where results will be written (no trailing slash)
url_prefix: http://your-server/path  # public URL where the output folder is served (no trailing slash)

bam_subfolder: mapped_bams           # subfolder inside output_folder containing sorted BAMs
email: you@example.com
bam_hub_name: my_experiment
bigwig_hub_name: my_experiment
genome: hg38                         # UCSC genome assembly name

samples:
  - sample1
  - sample2
```

BAM files must be pre-sorted and follow this naming convention:
```
{output_folder}/{bam_subfolder}/{sample}_sorted.bam
```

## Running

```bash
snakemake -s bam_and_bigwig_hubs.smk --use-conda --cores 4
```

## Output

| File | Description |
|------|-------------|
| `{output_folder}/bigwigs/{sample}.bw` | bigWig signal tracks |
| `{output_folder}/bam_hub.txt` | UCSC hub file for BAM tracks |
| `{output_folder}/bigwig_hub.txt` | UCSC hub file for bigWig tracks |
| `{output_folder}/snakemake_params/` | Copy of pipeline files for reproducibility |

## Loading hubs into UCSC

After running, the pipeline prints the URL to paste into the UCSC Genome Browser track hub loader.

- **Public browser:** paste `{url_prefix}/bam_hub.txt` or `{url_prefix}/bigwig_hub.txt`
- **Password-protected browser:** use `http://username:password@{url_prefix_host}/...`
