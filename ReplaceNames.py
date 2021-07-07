'''
Stand-alone infomap software output clustering results as numbered IDs.
This helps to convert ID back to Gene Names
'''

import pandas as pd
import sys
print ("Usage: python ReplaceID.py SequenceID_replace_table New-infomap.clu Fixed-New-infomap.clu")

args=sys.argv

f1= open(args[1],'r')# map table
f2= open(args[2],'r')# orginal blast
f3= open(args[3],'w')# fixed blast

'''
Read Input
1	aar_AA10G00376
2	aar_AA30G00303
3	aar_AA30G00169
4	aar_AA39G00657
5	aar_AA40G00520
6	aar_AA46G00142
7	aar_AA57G00167
8	aar_AA21G00299
'''

df= pd.read_csv(f1,sep='\t',names=["number","genename"],engine='python')

print(str(len(df)) +" nodes have imported to dictionary")

#convertdict = dict(zip(df.genename,df.number))
convertdict = dict(zip(df.number,df.genename))
#print convertdict
# print convertdict.get(1,None)
# print convertdict.get(4871,None)
# print convertdict[4871]

'''
Read Input File
'''

for line in f2:
	if len(line) == 0:
		continue
	if line[0] == "#":
		f3.write(line)
	else:
		'''
		This part is great,  I figured it out. 
		int() is crucial, because your hash table looks like this:
		{1: 'aar_AA10G00376', 2: 'aar_AA30G00303', 3: 'aar_AA30G00169', ...}
		not 
		{'1': 'aar_AA10G00376', '2': 'aar_AA30G00303', '3': 'aar_AA30G00169', ...}
		'''
		geneid = int(line.split()[0])
		#print type(geneid)
		rest = line.split()[1:3]
		#print geneid, convertdict[geneid], rest
		newline = str(convertdict[geneid])+'\t'+'\t'.join(rest)
		f3.write(newline+ '\n')
f3.close()
print("Numeric IDs have been converted into Gene Names")
		

