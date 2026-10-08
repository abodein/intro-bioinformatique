---
title: "Linux Pratique"
subtitle: "Correction des Exercices"

author: "Antoine Bodein"
output: pdf_document
number_section: true
toc: true
---

# Exercice 1 : Déplacement sur l'arborescence

A partir de **VOTRE** home :

0. Vérifier que vous êtes dans votre home avec `pwd`
```bash
pwd
```
1. Créer un fichier vide `fichier.txt`
```bash
touch fichier.txt
```
2. Faites une copie de ce fichier au même endroit `cp_fichier.txt`
```bash
cp fichier.txt cp_fichier.txt
```
3. Renommer `cp_fichier.txt` en `mv_fichier.txt`
```bash
mv cp_fichier.txt mv_fichier.txt
```
4. Créer un répertoire dans votre home `Dossier`
```bash
mkdir Dossier
```
5. Déplacez-vous dans `Dossier` et avec `pwd` vérifier que vous êtes au bon endroit
```bash
cd Dossier
pwd
```
6. A partir de `Dossier`, copier `mv_fichier.txt` dans `Dossier` en nommant la copie `fichier_dossier.txt`
```bash
cp ../mv_fichier.txt ./fichier_dossier.txt
```
7. Retournez dans votre home
```bash
cd
```
8. Copier le répertoire `Dossier` en `cp_Dossier` au même endroit
```bash
cp -r Dossier cp_Dossier
```
9. Renommer le répertoire `cp_Dossier` en `mv_Dossier`
```bash
mv cp_Dossier mv_Dossier
```
10. Créer un nouveau répertoire `Dossier_3`
```bash
mkdir Dossier_3
```
11. Déplacez-vous dans `Dossier`
```bash
cd Dossier
```
12. Déplacer le répertoire `mv_Dossier` dans `Dossier_3`
```bash
mv ../mv_Dossier ../Dossier_3
```
13. Retourner dans votre home en utilisant un **chemin absolu**
```bash
cd  /home/bodant01 #mon home!
```
14. En utilisant des chemins absolus copier `fichier.txt` dans le dossier `Dossier_3` et renommez-le en `fichier_3.txt`
```bash
cp /home/bodant01/fichier.txt /home/bodant01/Dossier_3/fichier_3.txt
```
15. Avec la commande rmdir supprimer le répertoire `mv_Dossier`. Que se passe-t-il? Que proposez-vous pour y remédier?
```bash
rmdir Dossier_3/mv_Dossier  #le dossier n'est pas vide, il faut utiliser rm -r Dossier_3/mv_Dossier
```
16. Supprimer le répertoire `Dossier_3`
```bash
rm -r Dossier_3
```
17. Supprimer le fichier `fichier.txt`
```bash
rm fichier.txt
```
18. Quels sont les fichiers (et répertoires) restant dans votre home ?
```bash
ls
```

# Exercice 2 : Métacaractères

Dans le terminal, tapez la ligne: `/home/public/linux/exo2.sh`

Le répertoire `~/exo2/` contient des fichiers. 
En utilisant les métacaractères, listez les fichiers dont le nom:

1. Commence par la lettre `A`
```bash
cd ~/exo2/
ls A*
```
2. Se termine par l'extension `.txt`
```bash
ls *.txt
```
3. Contient exactement 3 caractères
```bash
ls ???
```
4. Contient au moins 3 caractères
```bash
ls ???*
```
5. Commence par un `A` et contient au moins 3 caractères
```bash
ls A??*
```
6. Commence par un `T`, se termine par `.txt` et contient au moins 5 caractères
```bash
ls T*.txt
```
7. Commence par la lettre `A` ou `B`
```bash
ls [AB]*
```

# Exercice 3 : Manipulation de fichier

Dans le terminal, tapez la ligne: `/home/public/linux/exo3.sh`

| FRUIT      | COULEUR | QUANTITE |
| ---------- | ------- | -------- |
| Fraise     | Rouge   |       10 |
| Banane     | Jaune   |        5 |
| Abricot    | Orange  |        4 |
| ananas     | Jaune   |        5 |
| pomme      | Rouge   |        7 |
| Melon      | Orange  |        1 |
| Kiwi       | Vert    |        2 |
| Cerise     | Rouge   |        3 |
| Citron     | Jaune   |        9 |
| Citron     | Vert    |        8 |
| Framboise  | Rouge   |        2 |
| Raisin     | Rouge   |        1 |
| Prune      | Rouge   |        1 |
| Poire      | Vert    |        8 |
| Pasteque   | Rouge   |        7 |
| Orange     | Orange  |        3 |


Le fichier ~/exo3/fruit.tsv est une liste de fruits contenant leur désignation, leur couleur et une quantité associée. Quels sont les commandes qui vous permettent d’afficher le résultats des requêtes suivantes:

1. Afficher le contenu du fichier
```bash
cd ~/exo3/
cat fruit.tsv
```
2. Afficher les 9 premières lignes du fichiers
```bash
head -n9 fruit.tsv
```
3. Afficher toutes les lignes, sauf l’entête
```bash
tail -n+2 fruit.tsv
```
4. Afficher la liste des fruits seulement
```bash
cut -f1 fruit.tsv
```
5. Combien de lignes contient le fichier?
```bash
wc -l fruit.tsv
```
6. Afficher les lignes dont la **couleur** du fruit est **Rouge**
```bash
grep "Rouge" fruit.tsv
```
7. Afficher les lignes dont le **nom** du fruit commence par la lettre A
```bash
grep  "^A" fruit.tsv
```
8. Afficher les lignes dont le **nom** du fruit commence par la lettre O
```bash
grep  "^O" fruit.tsv
```

# Exercice 4 : Gestion des flux

Dans le terminal, tapez la ligne: `/home/public/linux/exo4.sh`
**Partie 1.** En utilisant les opérateurs de redirections:

1. Ecrivez *helloworld* dans le fichier `~/exo4/HT.txt`
```bash
echo "helloworld" > ~/exo4/HT.txt
```
2. Ajoutez *bonjour le monde* dans le même fichier et vérifier avec less que les 2 lignes sont présentes.
```bash
echo "bonjour le monde" >> ~/exo4/HT.txt
```
3. Essayer de créer le répertoire `/HelloWorld`, rediriger l’erreur standard dans le fichier `~/exo4/HT.err`
```bash
mkdir /HelloWorld 2> ~/exo4/HT.err
```
4. Essayer d’écrire *Allo* dans le fichier `/bin/allo.txt` , ajouter l’erreur au fichier `~/exo4/HT.err`
```bash
(echo "Allo" > /bin/allo.txt) 2>> ~/exo4/HT.err 
```

**Partie 2.** Les séquences biologiques sont stockées dans dans des fichiers FASTA dont la structure est
représentée ci-dessus. En utilisant le fichier `~/exo4/sample_swissprot.fa`, répondez aux questions suivantes.

1. Combien de séquences contient ce fichier ?
```bash
grep -c "^>" ~/exo4/sample_swissprot.fa
```
2. Combien de séquences sont des séquences appartenant à l’homme (*OS=Homo sapiens*) ?
```bash
grep -c "OS=Homo sapiens" ~/exo4/sample_swissprot.fa
```
3. Dans un fichier `header.txt` , inscrivez la liste des entêtes des séquences.
```bash
grep "^>" ~/exo4/sample_swissprot.fa > header.txt

```
4. Dans le fichier `gene.fa`, stockez la séquence fasta (header + séquence) du gène *CDIA_ENTCC*
```bash
grep -A1 "CDIA_ENTCC" ~/exo4/sample_swissprot.fa > gene.fa

```
5. Cherchez les séquences qui ont le motif protéique *TATA*, inscrivez leurs headers dans le fichier `tata_header.txt`
```bash
grep -B1 "TATA" ~/exo4/sample_swissprot.fa | grep "^>" > tata_header.txt
```

# Exercice 5 : Manipulation de fichier et flux

**Partie 1**

1. A partir de `fruit.tsv`, afficher toutes les lignes, sauf l’entête et sauvegarder dans `fruit_no_header.tsv`
```bash
cd ~/exo3/
tail -n+2 fruit.tsv > fruit_no_header.tsv
```
2. A partir de `fruit_no_header.tsv`, afficher la colonne contenant les fruits.
```bash
cut -f1 fruit_no_header.tsv
```
3. A partir de `fruit_no_header.tsv`, afficher la liste des fruits triés par ordre alphabétique et sauvegarder dans `fruit_sort_alpha.tsv`
```bash
sort -k1 fruit_no_header.tsv > fruit_sort_alpha.tsv
```
4. A partir de `fruit_no_header.tsv`, liste des fruits triés par ordre decroissant de quantité et sauvegarder dans  `fruit_sort_quant.tsv`
```bash
sort -k3 -n -r fruit_no_header.tsv > fruit_sort_quant.tsv
```
5. A partir de `fruit.tsv`, remplacer Jaune par Vert et sauvegarder dans `fruit_pas_murs.tsv`
```bash
sed 's/Jaune/Vert/' fruit.tsv > fruit_pas_murs.tsv
```

**Partie 2**
Répondez aux requêtes suivantes en 1 seule commande (avec pipe `|`)

1. Afficher la liste de fruits qui commence par la lettre F
```bash
tail -n+2 fruit.tsv | cut -f1 | grep "^F"
```
2. Affichez uniquement les fruits Rouge
```bash
tail -n+2 fruit.tsv | grep "Rouge" | cut -f1
```
3. Comptez le nombre de fruits Orange
```bash
tail -n+2 fruit.tsv | cut -f2 | grep "Orange" | wc -l
```
4. Affichez le fruit le plus abondant
```bash
tail -n+2 fruit.tsv | sort -k3 -n -r | head -n1 | cut -f1

```
5. Affichez la liste des fruits classez en ordre alphabétique
```bash
tail -n+2 fruit.tsv | sort -k1 | cut -f1

```
6. Affichez le fruit le plus abondant et sa quantité
```bash
tail -n+2 fruit.tsv | sort -k3 -n -r | head -n1 | cut -f1,3
```
7. `*` Affichez les fruits dont la couleur ne se termine pas par un E
```bash
tail -n+2 fruit.tsv | cut -f1,2 | grep -v -i "e$" | cut -f1
```
8. `*` Affichez le nombre de couleurs différentes (`uniq`)
```bash
tail -n+2 fruit.tsv | cut -f2 | sort | uniq | wc -l
```

# Exercice 6 : Script

Dans le cadre d’une analyse bioinformatique, la structure du dossier d’analyse est la suivante :

```
.
|-- Data/
|-- Ref/
|-- Result/
|-- Script/
```

On vous demande de créer un script qui crée l’arborescence à partir d’un répertoire passé en argument.
(`$1`). Vous devez changer les droits pour le rendre exécutable par n’importe qui.

Dans un fichier texte (ouvert avec `nano` ou autre éditeur) (`nano ~/exo6/script.sh`)
```bash
#!/bin/bash

mkdir -p $1
mkdir -p $1/Data
mkdir -p $1/Ref
mkdir -p $1/Result
mkdir -p $1/Script
```

On change les droits d'execution du script pour le rendre executable par n'importe qui.

```bash
chmod a+x ~/exo6/script.sh
```

On execute le script avec:
```bash
~/exo6/script.sh ~/test_dir
```

*Remarque:* La combinaison de touche Ctrl + C permet d'arrêter une commande en cours d'exécution.
