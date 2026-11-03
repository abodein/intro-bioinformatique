# Tableaux animés pour les diapos revealjs (style des diapos RStudio « Master the Tidyverse »).
# Chaque cellule porte un data-id stable « clé-colonne » : d'une diapo auto-animate à la suivante,
# reveal.js fait glisser les cellules qui gardent le même identifiant, et fait apparaître les autres.

# Une cellule
cellule <- function(texte, id, classe = "", largeur = NULL) {
  id <- gsub("[^A-Za-z0-9_-]", "_", id)   # identifiant HTML sûr (les noms de colonnes peuvent contenir < ou des espaces)
  style <- if (is.null(largeur)) "" else sprintf(' style="width:%.1fem"', largeur)
  sprintf('<span class="td %s" data-id="%s"%s>%s</span>', classe, id, style, texte)
}

# Un tableau : df à afficher, cle = colonne qui identifie les lignes (pour les data-id),
# cols_hl / lignes_hl = colonnes ou lignes surlignées, lignes_off = lignes estompées,
# lignes_na = lignes écartées à cause d'un NA, cols_new / lignes_new = colonnes ou lignes créées,
# ids = matrice de data-id à imposer (même dimension que df), cles = vecteur de clés de lignes à imposer,
# cases_hl / cases_clair = matrices (ligne, colonne) de cases surlignées en bleu foncé / clair (ligne 0 = en-tête),
# ref = tableau de référence pour les largeurs (groupes d'un même tableau alignés), titre = légende au-dessus.
tableau <- function(df, cle = names(df)[1], cols_hl = NULL, lignes_hl = NULL, lignes_off = NULL,
                    lignes_na = NULL, cols_new = NULL, lignes_new = NULL,
                    ids = NULL, cles = NULL, ref = NULL, cases_hl = NULL, cases_clair = NULL, entete = TRUE, titre = NULL, prefixe = "", classe = "") {
  df <- as.data.frame(df)
  brut <- function(x) vapply(x, \(v) if (is.na(v)) "NA" else format(v, trim = TRUE, scientific = FALSE), "")
  fmt <- function(x) ifelse(is.na(x), '<span class="na">NA</span>', htmltools::htmlEscape(brut(x)))
  # largeur fixe par colonne (texte le plus long, en-tête compris) : toutes les cases d'une colonne s'alignent
  base <- if (is.null(ref)) df else as.data.frame(ref)
  larg <- vapply(names(df), \(col) max(nchar(c(col, brut(df[[col]]), if (col %in% names(base)) brut(base[[col]])))) * 0.62 + 1, 0)
  if (is.null(cles)) cles <- if (is.null(cle)) seq_len(nrow(df)) else df[[cle]]
  surligne <- function(i, j) {
    estdans <- function(m) !is.null(m) && any(m[, 1] == i & m[, 2] == j)
    c(if (estdans(cases_hl)) "cell-hl", if (estdans(cases_clair)) "cell-clair")
  }
  lignes <- character(0)
  if (entete) {
    cells <- vapply(seq_along(df), function(j) {
      col <- names(df)[j]
      cellule(htmltools::htmlEscape(col), paste0(prefixe, "h-", col), paste(c("th", if (col %in% cols_hl) "col-hl", if (col %in% cols_new) "nouveau",
                                                                              surligne(0, j)), collapse = " "), larg[[col]])
    }, "")
    lignes <- c(lignes, sprintf('<div class="tr">%s</div>', paste(cells, collapse = "")))
  }
  for (i in seq_len(nrow(df))) {
    cl_ligne <- c(if (i %in% lignes_hl) "row-hl", if (i %in% lignes_off) "row-off",
                  if (i %in% lignes_na) "row-na", if (i %in% lignes_new) "nouveau")
    cells <- vapply(seq_along(df), function(j) {
      col <- names(df)[j]
      id <- if (!is.null(ids)) ids[i, j] else paste0(prefixe, cles[i], "-", col)
      cellule(fmt(df[[j]][i]), id, paste(c(if (col %in% cols_hl) "col-hl", if (col %in% cols_new) "nouveau",
                                               cl_ligne, surligne(i, j)), collapse = " "), larg[[col]])
    }, "")
    lignes <- c(lignes, sprintf('<div class="tr">%s</div>', paste(cells, collapse = "")))
  }
  sprintf('<div class="tt %s">%s%s</div>', classe,
          if (!is.null(titre)) sprintf('<div class="tt-titre">%s</div>', titre) else "",
          paste(lignes, collapse = ""))
}

# Assembler plusieurs blocs côte à côte, avec des flèches entre eux
rangee <- function(..., fleche = TRUE, classe = "") {
  blocs <- list(...)
  sep <- if (fleche) '<span class="fleche">&#10140;</span>' else ""
  sprintf('<div class="rangee %s">%s</div>', classe, paste(unlist(blocs), collapse = sep))
}

# Code annoté : bulles reliées aux morceaux de l'appel
# morceaux : vecteur nommé ; les noms sont le texte du code, les valeurs l'explication (NA = pas de bulle)
code_annote <- function(morceaux, couleurs = NULL) {
  n <- length(morceaux)
  if (is.null(couleurs)) couleurs <- rep(c("bleu", "vert", "gris", "jaune"), length.out = n)
  couleurs <- rep_len(couleurs, n)
  code <- vapply(seq_len(n), function(k) {
    sprintf('<span class="ca-%s">%s</span>', couleurs[k], htmltools::htmlEscape(names(morceaux)[k]))
  }, "")
  bulles <- vapply(seq_len(n), function(k) {
    if (is.na(morceaux[k])) return("")
    sprintf('<div class="bulle fragment ca-bg-%s" data-fragment-index="%d">%s</div>', couleurs[k], k, morceaux[k])
  }, "")
  sprintf('<div class="code-annote"><div class="ca-code">%s</div><div class="ca-bulles">%s</div></div>',
          paste(code, collapse = ""), paste(bulles, collapse = ""))
}

# Envelopper un bloc pour qu'il apparaisse au clic
au_clic <- function(html) sprintf('<div class="fragment">%s</div>', html)

# Contenu brut d'un fichier texte (CSV), séparateurs en rouge. Chaque champ porte le même data-id
# que la cellule correspondante de tableau(df, cles = seq_len(nrow(df)), prefixe = prefixe) :
# d'une diapo à l'autre, les valeurs du fichier glissent dans les colonnes du tableau.
fichier_brut <- function(lignes, sep = ",", prefixe = "csv-", suite = TRUE) {
  champs <- strsplit(lignes, sep, fixed = TRUE)
  entete <- champs[[1]]
  html <- vapply(seq_along(champs), function(i) {
    ids <- if (i == 1) paste0(prefixe, "h-", entete) else paste0(prefixe, i - 1, "-", entete)
    ids <- gsub("[^A-Za-z0-9_-]", "_", ids)
    spans <- sprintf('<span class="champ" data-id="%s">%s</span>', ids, htmltools::htmlEscape(champs[[i]]))
    paste(spans, collapse = sprintf('<span class="sep">%s</span>', sep))
  }, "")
  sprintf('<div class="brut">%s%s</div>', paste(html, collapse = "<br>"), if (suite) "<br>…" else "")
}
