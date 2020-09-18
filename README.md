<p><span style="font-family:helvetica;font-size:15px;"><strong>Pipeline for whole-genome microsynteny-based phylogenetic inference</strong></span></p>
<p><span style="font-family:helvetica;font-size:15px;">Our synteny-based phylogenetic reconstruction approach includes four main steps,</span><span style="font-family:helvetica;font-size:14px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">in turn namely phylogenomic synteny network construction, network clustering,</span><span style="font-family:helvetica;font-size:14px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">matrix representation, and maximum-likelihood estimation. Together we call our</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">approach &lsquo;Syn-MRL&rsquo; for short.</span></p>
<p><span style="font-family:helvetica;font-size:15px;">The synteny network construction consists of two main steps: first, all-vs-all&nbsp;</span><span style="font-family:helvetica;font-size:15px;">reciprocal annotated-protein comparisons of the whole genome using DIAMOND</span><span style="font-family:helvetica;font-size:14px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">was performed, followed by MCScanX, which was used for pairwise synteny&nbsp;</span><span style="font-family:helvetica;font-size:14px;">489&nbsp;</span><span style="font-family:helvetica;font-size:15px;">block detection. Parameter settings for MCScanX have been tested and compared</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">before</span><span style="font-family:helvetica;font-size:15px;">; here we adopt &lsquo;b5s5m25&rsquo; (b: number of top homologous pairs, s: number of</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">minimum matched syntenic anchors, m: number of max gene gaps), which has</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">proven to be appropriate by various studies for the evolutionary distances among</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">angiosperm genomes. To avoid large numbers of local collinear gene pairs due to</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">tandem arrays, if consecutive homologs (up to five genes apart) share a common</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">gene, homologs are collapsed to one representative pair (with the smallest E-value).</span><span style="font-family:helvetica;font-size:14px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">Further details regarding phylogenomic synteny network construction can be found</span><span style="font-family:helvetica;font-size:14px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">in a tutorial available in the associated GitHub repository</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;color:rgb(0,0,0);">(</span><a href="https://github.com/zhaotao1987/SynNet-Pipeline"><span style="font-family:helvetica;font-size:15px;">https://github.com/zhaotao1987/SynNet-Pipeline</span></a><span style="font-family:helvetica;color:rgb(0,0,0);">). Each pairwise synteny block</span><span style="font-family:helvetica;color:rgb(0,0,0);">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">represents pairs of connected nodes (syntenic genes), all pairwise identified synteny</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">blocks together form a comprehensive synteny network with millions of nodes and</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">edges. In this synteny network, nodes are genes (from the synteny blocks), while</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">edges connect syntenic genes. For our work, the entire synteny network summarizes</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">information from 7,435,502 pairwise syntenic blocks, and contains&nbsp;</span><span style="font-family:helvetica;font-size:14px;">503&nbsp;</span><span style="font-family:helvetica;font-size:15px;">3,098,333 nodes</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">(genes) and 94,980,088 edges (syntenic connections).</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">The entire synteny network (database) is clustered for further analysis. We used the</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">Infomap algorithm for detecting synteny clusters within the map equation</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">framework</span><span style="font-family:helvetica;font-size:15px;">(</span><span style="font-family:helvetica;color:rgb(5,99,194);font-size:15px;">https://github.com/mapequation/infomap</span><span style="font-family:helvetica;font-size:15px;">). We have discussed before</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">why Infomap is more appropriate for clustering phylogenomic synteny networks.&nbsp;</span><span style="font-family:helvetica;font-size:15px;">We used the two-level partitioning mode with ten trials (--clu -N 10 --map -2). The&nbsp;</span><span style="font-family:helvetica;font-size:15px;">network was treated as undirected and unweighted. Resulting synteny clusters vary</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">in size and composition, which is associated with synteny either being well&nbsp;</span><span style="font-family:helvetica;font-size:15px;">conserved or rather lineage-/species-specific. A typical synteny cluster comprises of</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">syntenic genes shared by groups of species, which precisely represent phylogenetic</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">relatedness of genomic architecture among species. Here, we classified the</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">entire synteny network into 137,833 synteny clusters.</span></p>
<p style="margin-top:0.0000pt;margin-right:0.0000pt;margin-bottom:0.0000pt;margin-left:0.0000pt;text-align:left;"><span style="font-family:helvetica;font-size:15px;">A cluster phylogenomic profile shows its composition by the number of nodes in</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">each species. We summarize the total information residing in all synteny clusters as</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">a data matrix for tree inference. Phylogenomic profiles of all clusters construct a</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">large data matrix, where rows represent species, and columns as clusters.</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">The matrix was then reduced to a binary presence-absence matrix to obtain the final</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">synteny matrix. Tree estimation was based on maximum-likelihood as implemented in IQ-TREE</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">(version 1.7-beta7) (Nguyen et al., 2014), using the MK+R+FO model. (where &ldquo;M&rdquo;</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">stands for &ldquo;Markov&rdquo; and &ldquo;k&rdquo; refers to the number of states observed, in our case, k =2). The +R (FreeRate) model was used to account for site-heterogeneity, and</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">typically fits data better than the Gamma model for large datasets. State</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">frequencies were optimized by maximum-likelihood (by using &lsquo;+FO&rsquo;). We generated</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">1000 bootstrap replicates for the SH-like approximate likelihood ratio test (SH-aLRT),</span><span style="font-family:helvetica;font-size:15px;">&nbsp;</span><span style="font-family:helvetica;font-size:15px;">and 1000 ultrafast bootstrap (UFBoot) replicates (-alrt 1000 -bb 1000).</span></p>
<p><span style="font-family:Calibri;font-size:14px;">&nbsp;</span></p>

<p><strong>microsynteny-based vs sequence-alignment based phylogenetic reconstruction</strong></p>
<p style="text-align: right;"><img src="https://github.com/zhaotao1987/Syn-MRL/blob/master/Figure_1.jpg?raw=true" alt="methods" width="2946" height="3283" /></p>
