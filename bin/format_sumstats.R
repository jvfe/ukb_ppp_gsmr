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
# exposure_path <- "data/phylum.Actinobacteria.id.400.summary.txt.gz"
# sumstats_path <- "data/variants.tsv.bgz"

ref_sumstats <- vroom(sumstats_path)

exposure <- vroom(exposure_path)

output_path <- paste0(prefix, "_merged.txt")

out <- exposure |>
  inner_join(ref_sumstats |>
               select(rsID = rsid, eaf = minor_AF, eff.allele = alt),
             by = c("rsID", "eff.allele"))

out |>
  select(
    SNP = rsID,
    A1 = eff.allele,
    A2 = ref.allele,
    freq = eaf,
    b = beta,
    se = SE,
    p = P.weightedSumZ,
    n = N
  ) |>
  vroom_write(output_path)
