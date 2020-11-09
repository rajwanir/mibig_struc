# Substructure Search in MIBiG database

Discovery of biosynthesis pathway of natural products is increasingly guided by genome mining. BLAST searches against database of previously characterized BGCs (such as Minimum Information about a Biosynthetic Gene Cluster (MiBIG) database) could yield significant hits and become an important starting point for the experimental characterization of BGC. However, this approach is effective only when the biosynthetic gene cluster (BGC) encoding the new compound shares sequence similarity to that of characterized compound. The sequence similarity search is available through the ‘clusterBLAST’ module in the commonly used genome mining tool antiSMASH.

Often a sequence comparison to MiBIG database do not yield significant hits. For instance, when producing organism and the BGC is evolutionary unrelated to those available in MiBIG. In such case, structure comparison could hint on the enzymatic machinery needed for biosynthesis.  For the structure comparison, the compound of interest could be inspected for a distinguishing structural feature (for example, a specific chemical modification or ring structure in the compound) that is reported in a known compound with characterized biosynthetic gene cluster (BGC).  

The Substructure Search in MIBiG (SSMIBIG) obtains all compounds containing the queried structural element via PubChem, searches MiBIG database and returns the information about the matched entry. 

Live version of app deployed at : https://rajwanir2.shinyapps.io/mibig_struc/

Users can cite the MIBiG database:

Kautsar, S.A., et al., MIBiG 2.0: a repository for biosynthetic gene clusters of known function. Nucleic Acids Research, 2019. 48(D1): p. D454-D458.


