# Substructure Search in MIBiG database

Discovery of biosynthesis pathway of natural products is increasingly guided by genome mining. If the new compound of interest is structurally similar to a previously characterized compound AND the biosynthetic gene cluster (BGC) encoding the new compound shares sequence similarity to that of characterized compound, BLAST searches against database of previously characterized BGCs (such as Minimum Information about a Biosynthetic Gene Cluster (MiBIG) database) could yield significant hits and become an important starting point for the experimental characterization of BGC. The sequence similarity search is available through the ‘clusterBLAST’ module in the commonly used genome mining tool antiSMASH. Nevertheless, often a sequence comparison to MiBIG database do not yield significant hits, possibly because the producing organism and the BGC is evolutionary unrelated to those available in MiBIG. In such case, structure comparison could hint on the enzymatic machinery needed for biosynthesis.  


For the structure comparison, the compound of interest could be inspected for a distinguishing structural feature (for example, a specific chemical modification or ring structure in the compound) that is reported in a known compound with characterized biosynthetic gene cluster (BGC).  

Live version of app deployed at : https://rajwanir2.shinyapps.io/mibig_struc/

Users can cite the orignal MIBiG databse:

Kautsar, S.A., et al., MIBiG 2.0: a repository for biosynthetic gene clusters of known function. Nucleic Acids Research, 2019. 48(D1): p. D454-D458.


