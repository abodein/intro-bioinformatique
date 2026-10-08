#!/bin/bash
# Régénère tout le matériel du module « Manipuler des données avec le tidyverse » (BIF-7900).
# Usage : ./render.sh   (depuis n'importe où)
# Packages requis : tidyverse, nycflights13
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
quarto render Tidyverse_2026.qmd
pdf "Tidyverse_2026.html?print-pdf" Tidyverse_2026.pdf

# Version des diapos avec TP intégrés : fichier généré, ne pas modifier à la main.
# Source : Tidyverse_2026.qmd + _tp1_diapos.qmd, _tp2_diapos.qmd, _tp3_diapos.qmd
# Sources privées (correction au clic), absentes du dépôt public : étape ignorée si elles manquent.
if [ -f _tp1_diapos.qmd ]; then
awk '{ print } /^# TP[123]( |$)/ { n = substr($2, 3, 1); printf "\n{{< include _tp%s_diapos.qmd >}}\n", n }' \
  Tidyverse_2026.qmd > Tidyverse_2026_TP.qmd
quarto render Tidyverse_2026_TP.qmd
pdf "Tidyverse_2026_TP.html?print-pdf" Tidyverse_2026_TP.pdf
fi

# TP, solutionnaires, guide d'étude et banque de questions (enseignant) : HTML autonome + PDF
for f in TP1 TP2 TP3 Solutionnaire_TP1 Solutionnaire_TP2 Solutionnaire_TP3 Guide_etude_tidyverse Guide_etude_tidyverse_court Banque_questions_tidyverse; do
  [ -f "$f.qmd" ] || continue   # banques de questions : privées, absentes du dépôt public
  quarto render "$f.qmd"
  pdf "$f.html" "$f.pdf"
done

# Exercice formatif : le corrigé d'abord, car Quarto efface l'autre PDF issu de la même source
quarto render Exercice_formatif_tidyverse.qmd -M corrige:true -o Exercice_formatif_tidyverse_corrige.pdf
quarto render Exercice_formatif_tidyverse.qmd -o Exercice_formatif_tidyverse.pdf

rm -rf *_files echantillons.tsv mesures.tsv poids.csv
echo "OK : $(ls *.pdf | tr '\n' ' ')"
