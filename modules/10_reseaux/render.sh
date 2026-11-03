#!/bin/bash
# Régénère tout le matériel du module « Introduction aux réseaux en biologie » (BIF-7900).
# Usage : ./render.sh   (depuis n'importe où)
# Packages requis : tidyverse, igraph ; pour data/_prepare.R : DESeq2, org.Hs.eg.db, networkdata
# Données : data/got_edges.csv, got_sex.csv, starwars_ep4.csv, airway_coexpr.tsv, produits par data/_prepare.R
set -e
cd "$(dirname "$0")"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# Export PDF d'une page HTML via Chrome sans interface
pdf() {
  "$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
    --run-all-compositor-stages-before-draw --virtual-time-budget=60000 \
    --print-to-pdf="$PWD/$2" "file://$PWD/$1" 2>/dev/null
}

# Diapos : revealjs (projection, pointeur OK) + PDF (dépôt Brio)
quarto render Reseaux_2026.qmd
pdf "Reseaux_2026.html?print-pdf" Reseaux_2026.pdf

# Version des diapos avec TP intégrés : fichier généré, ne pas modifier à la main.
# Source : Reseaux_2026.qmd + _tp1_diapos.qmd, _tp2_diapos.qmd
# Sources privées (correction au clic), absentes du dépôt public : étape ignorée si elles manquent.
if [ -f _tp1_diapos.qmd ]; then
awk '{ print } /^# TP[12]( |$)/ { n = substr($2, 3, 1); printf "\n{{< include _tp%s_diapos.qmd >}}\n", n }' \
  Reseaux_2026.qmd > Reseaux_2026_TP.qmd
quarto render Reseaux_2026_TP.qmd
pdf "Reseaux_2026_TP.html?print-pdf" Reseaux_2026_TP.pdf
fi

# TP, solutionnaires, guide d'étude et banque de questions (enseignant) : HTML autonome + PDF
for f in TP1 TP2 Solutionnaire_TP1 Solutionnaire_TP2 Guide_etude_reseaux Banque_questions_reseaux; do
  [ -f "$f.qmd" ] || continue   # banques de questions : privées, absentes du dépôt public
  quarto render "$f.qmd"
  pdf "$f.html" "$f.pdf"
done

# Exercice formatif : le corrigé d'abord, car Quarto efface l'autre PDF issu de la même source
quarto render Exercice_formatif_reseaux.qmd -M corrige:true -o Exercice_formatif_reseaux_corrige.pdf
quarto render Exercice_formatif_reseaux.qmd -o Exercice_formatif_reseaux.pdf

# Notes de cours : livre Quarto (une page HTML par chapitre + PDF LaTeX) dans notes_de_cours/_book/
# Les notes sont publiées à part : https://github.com/abodein/BIF-BOOK-7900
if [ -d notes_de_cours ]; then quarto render notes_de_cours; fi

rm -rf *_files
echo "OK : $(ls *.pdf | tr '\n' ' ')"
