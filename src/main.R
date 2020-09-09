library(tidyverse)

# input
cid = 1049

# load database
mibig = read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1VaajnqDA0UM-mh7Z9lBwUJ2qRvP3q_61"))


# get substructures
substructures = read.table(paste0("https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/fastsubstructure/cid/",
                                  cid,"/cids/TXT?StripHydrogen=true&fullsearch=true"),
                            header = F)


# overlap substructures in mibig
mibig [mibig$pchids %in% substructures$V1,]

