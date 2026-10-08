#!/bin/bash
# Régénère tout le matériel du module « Introduction à R » (BIF-7900).
# Usage : ./render.sh   (depuis n'importe où)
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
quarto render Intro_R_2026.qmd
pdf "Intro_R_2026.html?print-pdf" Intro_R_2026.pdf

# Version des diapos avec TP intégrés : fichier généré, ne pas modifier à la main.
# Source : Intro_R_2026.qmd + _tp1_diapos.qmd, _tp2_diapos.qmd, _tp3_diapos.qmd
# Sources privées (correction au clic), absentes du dépôt public : étape ignorée si elles manquent.
if [ -f _tp1_diapos.qmd ]; then
awk '{ print } /^# TP[123]( |$)/ { n = substr($2, 3, 1); printf "\n{{< include _tp%s_diapos.qmd >}}\n", n }' \
  Intro_R_2026.qmd > Intro_R_2026_TP.qmd
quarto render Intro_R_2026_TP.qmd
pdf "Intro_R_2026_TP.html?print-pdf" Intro_R_2026_TP.pdf
fi

# TP, solutionnaires, guide d'étude et banque de questions (enseignant) : HTML autonome + PDF
for f in TP1 TP2 TP3 Solutionnaire_TP1 Solutionnaire_TP2 Solutionnaire_TP3 Guide_etude_R Banque_questions_R; do
  [ -f "$f.qmd" ] || continue   # banques de questions : privées, absentes du dépôt public
  quarto render "$f.qmd"
  pdf "$f.html" "$f.pdf"
done

# Activité d'audit : corrigé d'abord (même raison que ci-dessous), HTML + PDF
quarto render Audit_script_IA.qmd -M corrige:true -o Audit_script_IA_corrige.html
quarto render Audit_script_IA.qmd -o Audit_script_IA.html
pdf Audit_script_IA_corrige.html Audit_script_IA_corrige.pdf
pdf Audit_script_IA.html Audit_script_IA.pdf

# Exercice formatif : le corrigé d'abord, car Quarto efface l'autre PDF issu de la même source
quarto render Exercice_formatif_R.qmd -M corrige:true -o Exercice_formatif_R_corrige.pdf
quarto render Exercice_formatif_R.qmd -o Exercice_formatif_R.pdf

rm -rf *_files df.tsv
echo "OK : $(ls *.pdf | tr '\n' ' ')"
