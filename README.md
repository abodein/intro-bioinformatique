# Introduction à la bioinformatique (BIF-7900)

Matériel du cours **Bioinformatique I (BIF-7900)** de l'Université Laval, édition automne 2026.
Site : <https://abodein.github.io/intro-bioinformatique/>

| Module | Contenu |
|---|---|
| `modules/02_linux` | Linux en pratique : diapositives, 6 exercices, correction |
| `modules/05_R_intro` | Introduction à R |
| `modules/06_tidyverse` | Manipuler des données avec le *tidyverse* |
| `modules/07_visualisation` | Visualisation de données avec R (`ggplot2`) |
| `modules/09_stat` | Introduction aux statistiques avec R |

Chaque module R contient des diapositives (revealjs), trois TP et leurs solutionnaires, un guide d'étude
et un exercice formatif avec son corrigé. Les fichiers HTML et PDF rendus sont versionnés :
le site est servi directement depuis la branche `main` par GitHub Pages.

## Régénérer un module

Prérequis : R, [Quarto](https://quarto.org) et Google Chrome (export PDF).

```bash
cd modules/06_tidyverse
Rscript data/get_babynames.R   # tidyverse et visualisation seulement : données volumineuses non versionnées
./render.sh
```

Les packages R nécessaires sont indiqués en tête de chaque `render.sh`.
La page d'accueil se régénère avec `quarto render index.qmd`.

Les diapositives « avec TP intégrés » (projection en classe, correction au clic) ne sont pas publiées.
`render.sh` saute cette étape quand leurs sources sont absentes.

## Licence

- Contenu (diapositives, TP, guides) : [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.fr).
- Code R : MIT.
- Restent soumis à leur propre licence : le logo et la charte de l'Université Laval, les logos hexagonaux
  des packages, les extraits des *cheatsheets* Posit et de *R for Data Science*, et les figures reprises
  d'autres sources (dossiers `figure/`).
- Le module *tidyverse* s'inspire du cours *Master the Tidyverse* (RStudio / Posit).

© 2026 Antoine Bodein
