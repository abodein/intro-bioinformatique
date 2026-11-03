# Prépare les données du module « Réseaux en biologie ».
# Usage (depuis 10_reseaux/) : Rscript data/_prepare.R
# Sorties, à copier dans /home/public/reseaux/ sur le serveur :
#   data/got_edges.csv        interactions entre personnages de Game of Thrones, saison 1 (ancien got1.Rda)
#   data/got_sex.csv          sexe des personnages (copié tel quel de 2025/10_network/)
#   data/starwars_ep4.csv     co-occurrences de scènes, Star Wars épisode IV (package networkdata)
#   data/airway_coexpr.tsv    expression (vst) des 150 gènes les plus variables d'airway, annotés
suppressPackageStartupMessages({library(tidyverse); library(igraph); library(DESeq2); library(org.Hs.eg.db)})

# Game of Thrones : un graphe igraph sauvegardé par une ancienne version → liste d'arêtes en CSV
load("../../2025/10_network/got1.Rda")
got1 <- upgrade_graph(got1)
as_data_frame(got1, what = "edges") |> write_csv("data/got_edges.csv")

# Star Wars IV (Schoch, networkdata) : les diapos l'utilisent pour les chemins et les communautés
data("starwars", package = "networkdata")
as_data_frame(upgrade_graph(starwars[[4]]), what = "edges") |>
  transmute(from, to, weight) |> write_csv("data/starwars_ep4.csv")

# airway : même analyse DESeq2 que 11_enrichissement/data/_prepare.R, puis vst
comptes <- read_tsv("../09_stat/data/airway_counts.tsv", show_col_types = FALSE) |>
  column_to_rownames("gene") |> as.matrix()
infos <- read_tsv("../09_stat/data/airway_sample_info.tsv", show_col_types = FALSE) |>
  dplyr::select(Run, cell, dex) |>
  mutate(dex = factor(dex, levels = c("untrt", "trt")), cell = factor(cell)) |>
  column_to_rownames("Run")
stopifnot(identical(colnames(comptes), rownames(infos)))
dds <- DESeqDataSetFromMatrix(comptes, infos, design = ~ cell + dex)
dds <- DESeq(dds[rowSums(counts(dds)) >= 10, ])
res <- results(dds)
stopifnot(grepl("dex trt vs untrt", mcols(res)$description[2]))
expr <- assay(vst(dds, blind = FALSE))

# les 150 gènes les plus variables (vst) : un échantillon nommé « donneur_traitement »
var_gene <- sort(apply(expr, 1, var), decreasing = TRUE)
ids <- names(var_gene)[1:150]
annot <- as.data.frame(res)[ids, ] |>
  rownames_to_column("gene") |>
  transmute(gene,
            symbole = coalesce(mapIds(org.Hs.eg.db, gene, "SYMBOL", "ENSEMBL"), gene),  # sans symbole : l'identifiant Ensembl
            chromosome = mapIds(org.Hs.eg.db, gene, "CHR", "ENSEMBL"),
            statut = case_when(padj < 0.05 & log2FoldChange > 1 ~ "induit",
                               padj < 0.05 & log2FoldChange < -1 ~ "réprimé",
                               .default = "non DE"))
stopifnot(!anyDuplicated(annot$symbole))
colnames(expr) <- paste(infos[colnames(expr), "cell"], infos[colnames(expr), "dex"], sep = "_")
expr[ids, ] |>
  round(3) |>
  as.data.frame() |>
  rownames_to_column("gene") |>
  left_join(annot, by = "gene") |>
  relocate(symbole, chromosome, statut, .after = gene) |>
  write_tsv("data/airway_coexpr.tsv", na = "NA")
