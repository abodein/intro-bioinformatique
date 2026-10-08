# Régénère data/babynames.csv (≈ 48 Mo, non versionné) à partir du package babynames.
# Usage, depuis le dossier du module : Rscript data/get_babynames.R
if (!requireNamespace("babynames", quietly = TRUE)) install.packages("babynames")
readr::write_csv(babynames::babynames, "data/babynames.csv")
