// Gabarit Université Laval pour les documents typst (exercices formatifs)
#let rouge-ul = rgb("#E30513")
#let jaune-ul = rgb("#FFC103")
#let gris-ul = rgb("#515151")

// Bandeau rouge | jaune
#let bandeau(split: 50%) = grid(
  columns: (split, 1fr),
  rect(width: 100%, height: 4pt, fill: rouge-ul, stroke: none),
  rect(width: 100%, height: 4pt, fill: jaune-ul, stroke: none),
)

// Cartouche jaune du titre (comme les diapos)
#let cartouche(titre, soustitre: none) = block(
  width: 100%, fill: jaune-ul, radius: 8pt, inset: (x: 14pt, y: 12pt),
)[#align(center)[#text(size: 17pt)[#titre] #if soustitre != none [\ #v(2pt) #text(size: 10pt)[#soustitre]]]]

#set page(
  header: [
    #grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      text(size: 8pt, fill: gris-ul)[BIF-7900 · Bioinformatique I · Statistiques avec R],
      image("figure/logo_UL.png", height: 0.9cm),
    )
    #v(-2pt)
    #bandeau()
  ],
  footer: [#bandeau(split: 66%) #v(-4pt) #align(center)[#text(size: 8pt, fill: gris-ul)[#context counter(page).display()]]],
)

// Questions : filet rouge à gauche
#show heading: it => block(
  stroke: (left: 3pt + rouge-ul), inset: (left: 7pt, y: 2pt), above: 1.3em, below: 0.8em,
  text(size: 12pt, weight: "bold", it.body),
)
