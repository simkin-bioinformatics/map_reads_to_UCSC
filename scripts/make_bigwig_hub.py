'''
a script to add tracks to the hub.txt file
'''

sample_list=snakemake.params.sample_list
email=snakemake.params.email
hub_name=snakemake.params.bigwig_hub_name
genome=snakemake.params.genome
output_file=open(snakemake.output.hub_name, 'w')
url_prefix=snakemake.params.url_prefix
private_prefix=url_prefix.replace('http://', 'http://username:password@')

color='0,0,180'
alt_color='180,0,0'

def make_header(hub_name, email, genome):
	output_file.write(f'hub {hub_name} bigwigs\n')
	output_file.write(f'shortLabel {hub_name} bigwigs\n')
	output_file.write(f'longLabel {hub_name} bigwigs\n')
	output_file.write(f'useOneFile on\n')
	output_file.write(f'email {email}\n')
	output_file.write(f'\ngenome {genome}\n\n')

make_header(hub_name, email, genome)

for sample in sample_list:
	name='.'.join(sample.split('/')[-1].split('.')[:-1]) #should work as long as sample follows snakemake format
	output_file.write(f'track {name}_bigwig\n')
	output_file.write(f'shortLabel {name}_bigwig\n')
	output_file.write(f'longLabel {hub_name}_{name}_bigwig\n')
	output_file.write(f'visibility hide\n')
	output_file.write(f'type bigWig\n')
	output_file.write(f'bigDataUrl {sample.strip()}\n')
	output_file.write(f'color {color}\n')
	output_file.write(f'altColor {alt_color}\n')
	output_file.write(f'autoScale on\n\n')

print(f'bigwig hub complete. If your track is on a public browser, navigate to the'
	f'track hubs portion of the website and paste in this URL: {url_prefix}/'
	'bigwig_hub.txt')
print('Alternatively, if your track is on a private browser, you will need to'
	f' paste a URL formatted like this: {private_prefix}/bigwig_hub.txt - filling'
	' in the username and password fields with appropriate values')
