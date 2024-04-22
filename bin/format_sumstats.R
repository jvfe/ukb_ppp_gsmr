#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)

# Load libraries (vroom to open/write large files,
# dplyr and tidyr to format data)
library(vroom)
library(dplyr)
# library(MungeSumstats)

prefix <- args[1]
exposure_path <- args[2]
sumstats_path <- args[3]
# prefix <- "phylum_Actinobacteria"
# exposure_path <- "data/GWAS_k__Bacteria.p__Actinobacteria.tsv.gz"
# sumstats_path <- "test_data/pgc_depression_sumstats_mtag.txt"

exposure <- vroom(exposure_path) |>
  select(
    SNP = id,
    A1 = alt,
    A2 = ref,
    freq = AF_Allele2,
    b = beta,
    se = SE,
    p = pval,
    n = num
  )

exposure |>
  vroom_write(output_path)
