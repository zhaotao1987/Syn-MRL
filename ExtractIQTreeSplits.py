import pandas as pd
import sys
import re

print ("Usage:\tpython ExtractIQTreeSplits.py Cluster1042_nodelist.pep_align_trimmed.phylip.splits.nex bootstrap\n\n\tIt will output highly-supported branches into a file named '*.leaves_extracted'")

args=sys.argv

# input_file = open(args[1],'r')# Input file *.splits.nex (IQTREE)



# with	open(f1,	'r')	as	input_file:

#f2= open(args[2],'r')# orginal blast
#f3= open(args[3],'w')# fixed blast

'''
Module: Read leaves
'''
def read_leaves(input_file):
	start = 'TAXLABELS'
	#end = 'END; [Taxa]'
	end = ';'
	started = False
	wanted = []
	with open(args[1], "r") as input_file:
		for line in input_file:
			if end in line:
				started = False       
			if started:
			# clean the line, remove brackets, remove quotes
				cleanline =line.replace("'","").replace("[","").replace("]","")
			# split the clean line, and save it. 
				wanted.append(cleanline.split())
			if start in line:
				started = True
		#input_file.close()

		# convert the list into dictionary, and change colnames in order to change it into dict.
		mapdf = pd.DataFrame(wanted)
		mapdf.columns = ['id', 'gene']

		# Now gene names and corresponding number idex were saved as hash table.
		convertdict= dict(zip(mapdf.id,mapdf.gene))
		# print convertdict
		return convertdict

'''
Module: Read branches information
'''

def read_branches(input_file):
	start = 'MATRIX'
	end = ';'
	started = False
	wanted = []
	with open(args[1], "r") as input_file:
		for line in input_file:
			if end in line:
				started = False       
			if started:
				wanted.append(line.replace(",","").strip())
			if start in line:
				started = True
		#input_file.close()
		df_branches = pd.DataFrame([sub.split("\t") for sub in wanted])
		df_branches.columns = ['bootstrap', 'genes']
		# Set column1 numeric
		df_branches['bootstrap']=pd.to_numeric(df_branches.bootstrap)
		df_branches['number'] =df_branches['genes'].str.count("\s")
		return df_branches

def filter_branches(df_branches,bootstrapcutoff):
	# df_branches = read_branches(input_file)
	# print df_branches

	# df_branches['number'] =df_branches['genes'].str.count("\s")
	# print df_branches

	#df_filter = df_branches[(df_branches['bootstrap'] > 90) & (df_branches['number'] >= 2 )]
	df_filter = df_branches[(df_branches['bootstrap'] > int(bootstrapcutoff)) & (df_branches['number'] >= 2 )]
	return df_filter
	

input_file = args[1]
bootstrapcutoff =args[2]
output_file = open(args[1]+"_bootstrap_over"+args[2]+".leaves_extracted",'w')

convertdict = read_leaves(input_file)
df_branches = read_branches(input_file)
df_filter = filter_branches(df_branches,bootstrapcutoff)

# print convertdict
# print df_filter

'''
Now we extract leaves and map back to gene names
'''

def mapping_leaves(df_filter):

	genes= df_filter[['genes']]				# genes is now a dataframe

	# print genes

	for index,row in genes.iterrows():		# For each row in the dataframe
		line= row["genes"] 					# Take the column (genes), now string
		# print type(line)
		genes= line.split()					# Now split the string into elements| each gene
		# print genes # list
		# print type(genes)
		# for i in genes:
			# # print i
			# print convertdict[i]
		for n,i in enumerate(genes):		# Wonderful, replace the list according to the hash table 
			genes[n]=convertdict[i] 		# Wonderful, replace the list(genes) according to the hash table
		# print genes
		output_file.write('\t'.join(genes)	+	'\n')
	output_file.close()
	

mapping_leaves(df_filter)



