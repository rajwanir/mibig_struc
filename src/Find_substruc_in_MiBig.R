library(purrr)
library(tidyverse)
library(jsonlite)
library(rjson)
library(ChemmineR)
library(ggplot2)
require(data.table)
library(rvest)

#Load tabulated version of MiBigdb
source("/data/rajwanir2/MiBiG/mibig_tabluatedb.R")



##Read pch search results
Substruc_of <- fread("/data/rajwanir2/MiBiG/PubChem_compound_structure_by_cid_substructure_CID643588 structure.csv",
                      header = TRUE, sep = ',')
Substruc_aminopropane <- fread("/data/rajwanir2/MiBiG/PubChem_compound_structure_by_cid_substructure_CID428 structure.csv",
                     header = TRUE, sep = ',')
Hits  <- MiBigDB[MiBigDB$pchids %in% Substruc_of$cid,]

# scrapping cds products from mibig web
Hits_details <- lapply(Hits$mibig_accession, function(x){
                                          as.data.frame(paste("https://mibig.secondarymetabolites.org/repository/",x,"/index.html", sep = "") %>% read_html() %>% html_nodes("table") %>% 
                                          .[2] %>% html_table(fill = TRUE)) %>% mutate(cluster = x)
                                    }
       )

Hits_details <- do.call(rbind,Hits_details)
Hits_details <- Hits_details[Hits_details$Identifiers != 'Identifiers',]
Hits_details <- separate(Hits_details, col = "Identifiers", into = paste("geneid",seq(1:9), sep = ""), sep = "\n")
Hits_details$geneid1 <- trimws(Hits_details$geneid1, which = "both")
Hits_details$geneid5 <- trimws(Hits_details$geneid5, which = "both")

# Find domains
#Hits_details$geneid1 <- lapply(Hits_details$geneid1, function(x) (strsplit(x, "\n")[[1]][1]))
##find domains using geneid1
domains <- lapply(Hits_details$geneid1, function(x){
  read_html(paste("https://www.ncbi.nlm.nih.gov/Structure/cdd/wrpsb.cgi?INPUT_TYPE=precalc&SEQUENCE=",x, sep = "")) %>% html_nodes("tr#rep_0_0") %>% html_text() %>% strsplit(.,"\n")
})


##Try finding with geneid5 if geneid1 returned empty list
domains <- lapply(seq_along(domains), function(i) {
  if( length(domains[[i]]) == 0 ) { read_html(paste("https://www.ncbi.nlm.nih.gov/Structure/cdd/wrpsb.cgi?INPUT_TYPE=precalc&SEQUENCE=",Hits_details$geneid5[i], sep = "")) %>% html_nodes("tr#rep_0_0") %>% html_text() %>% strsplit(.,"\n") }  
  else { domains[[i]] } } )



##Add NA if still not found
domains<-lapply(domains, function(x) if(length(x) == 0){x = list(rep("NA",each=5))} else x=x )


domains<-t(as.data.frame(domains, col.names = NULL))
colnames(domains) <- c("Domain_name","Domain_acc", "Domain_Desc", "Domain_intv", "Domain_eval")
rownames(domains) <- NULL
Hits_details <- cbind(Hits_details,domains)
Hits_details <- merge(Hits_details, Hits[,c("mibig_accession","biosyn_class" )], by.x = "cluster", by.y = "mibig_accession", all.x = TRUE)
Hits_details %>% filter(Domain_name != "NA")%>% filter(biosyn_class == "Terpene") %>% group_by(Domain_name) %>% add_tally() %>% filter(n>0) %>% ggplot(aes(cluster,Domain_name)) + geom_tile() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + coord_equal()


#entrez_search(db = "protein", term = "")$ids[1]

##check if present in GenBank
#any(grepl("This entry is originally from NCBI GenBank",readLines("https://mibig.secondarymetabolites.org/repository/BGC0001317/index.html", n =70)))

#plot structures
Hits_na_filt <- Hits %>% select(compounds.chem_struct,compounds.compound) %>% drop_na(compounds.chem_struct)
write.table(Hits_na_filt, file = "/data/rajwanir2/tmp.smi", quote = FALSE, row.names = FALSE, col.names = FALSE, sep = '\t')
smiset <- read.SMIset("/data/rajwanir2/tmp.smi")
#sytem("babel -ismi /data/rajwanir2/tmp.smi -osdf -O /data/rajwanir2/tmp.sdf --gen2D")
sdfset <- read.SDFset("/data/rajwanir2/tmp.sdf")
par(mar=c(1,1,1,1))
plot(sdfset[1:18], griddim=c(6,3), print_cid=sdfid(sdfset), print=FALSE, noHbonds=FALSE)

#Metadata plot
ggplot(Hits, aes(x=biosyn_class),stat="count", position="fill") + geom_bar() + theme_classic()



# MiBigDB[grepl(pchid_to_search,MiBigDB$compounds.database_id, fixed = TRUE),]


# ##Loading MiBigDB
# MiBigDB     <- read.table("/data/rajwanir2/mibig_pchids.txt", header = FALSE, col.names = "pchid")
# MiBigDB[MiBigDB$pchid %in% Substruc_of$cid,]

#example pubchem:6610243