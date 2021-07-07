# Convert network into pajek format
# Also write a nodelist table, in order to map back the GeneNames

require(igraph)
require(dplyr)

args<-commandArgs(TRUE)
	#f2 <- paste(basename(args[1]), '.sim',sep="")

f3 <- paste(basename(args[1]), '.pajek',sep="")
f4 <- paste(basename(args[1]), '.nodelist',sep="")

data <-read.table(args[1],header=F) # Note '\t' or ' '

# options! 
# for full edge table

 colnames(data) <-c('blockid','source','target','evalue','blockscore','blockevalue','anchors','pair')

# only 2 columns, for testing
# colnames(data) <-c('source','target')

# Select anchors as edge weights

df <- select(data,source,target)

network <- graph.data.frame(df,directed=F)

        # net_simple <- simplify(network) # You don't need this anymore, because the new DB is non-redundant.

nodes <- data.frame(name = V(network)$name)

        ###
        # Write outputs: simplified_network, pajek network (.net), and Nodelist
        ###

        #write_graph(net_simple,f2,format=c("ncol"))

write_graph(network,f3, format = "pajek")

write.table(nodes, f4, quote=F, sep='\t', col.name=F)

