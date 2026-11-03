# Prépare les résultats DESeq2 d'airway (même analyse que le TP3 du module stats) pour le module.
# Usage (depuis 11_enrichissement/) : Rscript data/_prepare.R
# Sortie : data/airway_deseq2.tsv, à copier dans /home/public/enrichissement/ sur le serveur
suppressPackageStartupMessages({library(tidyverse); library(DESeq2)})
comptes <- read_tsv("../09_stat/data/airway_counts.tsv", show_col_types = FALSE) |>
  column_to_rownames("gene") |> as.matrix()
infos <- read_tsv("../09_stat/data/airway_sample_info.tsv", show_col_types = FALSE) |>
  select(Run, cell, dex) |>
  mutate(dex = factor(dex, levels = c("untrt", "trt")), cell = factor(cell)) |>
  column_to_rownames("Run")
stopifnot(identical(colnames(comptes), rownames(infos)))
dds <- DESeqDataSetFromMatrix(comptes, infos, design = ~ cell + dex)
dds <- DESeq(dds[rowSums(counts(dds)) >= 10, ])
res <- results(dds)
stopifnot(grepl("dex trt vs untrt", mcols(res)$description[2]))
as.data.frame(res) |>
  rownames_to_column("gene") |>
  select(gene, baseMean, log2FoldChange, stat, pvalue, padj) |>
  mutate(across(c(baseMean, log2FoldChange, stat), \(x) signif(x, 5)),
         across(c(pvalue, padj), \(x) signif(x, 4))) |>
  write_tsv("data/airway_deseq2.tsv", na = "NA")

# Ensembles Hallmarks de MSigDB (Liberzon et al. 2015) au format GMT, identifiants Ensembl.
# msigdbr télécharge les ensembles au premier usage : on en garde une copie pour rendre hors ligne.
# Sortie : data/h.all.Hs.ensembl.gmt, à copier aussi dans /home/public/enrichissement/
h <- msigdbr::msigdbr(species = "Homo sapiens", collection = "H") |>
  filter(ensembl_gene != "") |>
  distinct(gs_name, ensembl_gene, db_version)
message("MSigDB ", unique(h$db_version))
h |>
  summarise(genes = paste(ensembl_gene, collapse = "\t"), .by = gs_name) |>
  mutate(ligne = paste(gs_name, paste0("MSigDB ", unique(h$db_version)), genes, sep = "\t")) |>
  pull(ligne) |>
  writeLines("data/h.all.Hs.ensembl.gmt")
