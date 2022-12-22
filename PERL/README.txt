Les informations ci-dessous peuvent aider à générer les tableaux de données (au format csv)
qui sont utilisés par le programme Octave DetecteurDeTriche.m

Quelques utilitaires écrits pour PERL sont également fournis. 
Ils peuvent nécessiter des adaptations selon la version de Moodle ou le type de questions posées dans le test.

Le fichier RepertoireDesDonnees.txt doit contenir le chemin d'accès au répertoire des données,
ce répertoire contenant les sous-répertoires originaux, originaux/txt, nettoye, nettoye/txt, tableaux

Dans l'idéal, des fonctions d'exportation pour Moodle devraient être développées.
Les indications et utilitaires PERL fournis ici ne doivent être considérés que comme une solution temporaire (laborieuse...)
à défaut de mieux.

***********
Sur Moodle:

Cliquer sur le lien de démarrage du contrôle
Dans le menu fourni par l'icône en forme d'engrenage, sélectionner "Notes".
Vérifier que l'ordre des étudiants est l'ordre souhaité, sinon corriger l'ordre.
Sélectionner le format xlsx dans le menu déroulant, puis cliquer sur "Exporter".
Renommer le fichier téléchargé en reponses.xlsx et le placer dans le répertoire "originaux"

Editer reponses.xslx sous Excel
	Vérifier que les étudiants sont dans le bon ordre
	Ne garder que les colonnes réponse de l'étudiant et réponse correcte
	Supprimer la première ligne
	l'enregistrer au format csv ( séparateur ; )
	Attention: pour les réponses numériques certains étudiants utilisent E au lieu de e
	ou bien . au lieu de , ou bien écrivent par exemple 12.3e-5 au lieu de 1.23e-4
	Tout cela va être compté comme mauvaise réponse: si possible corriger les réponses qui peuvent être mal interprétées.


Cliquer sur le lien de démarrage du contrôle
Dans le menu fourni par l'icône en forme d'engrenage, sélectionner "Réponses des participants".
Vérifier que l'ordre des étudiants est l'ordre souhaité, sinon corriger l'ordre.
Dans la liste qui s'affiche, pour chaque étudiant:
  cliquer sur "Relecture de cette tentative".
  puis click droit, enregistrer sous, 
	et enregistrer au format texte dans le tépertoire "originaux/txt".
Nommer les fichiers enregistrés 01.txt 02.txt etc.



Cliquer sur le lien de démarrage du contrôle
Dans le menu fourni par l'icône en forme d'engrenage, sélectionner "Modifier le test".
Sélectionner la liste de questions et faire un copié-collé 
	dans un fichier texte "OrdreOriginal.txt" dans le répertoire "originaux".



Facultatif: 
	Cliquer sur le lien de démarrage du contrôle
	Dans le menu fourni par l'icône en forme d'engrenage, sélectionner "Notes".
	Vérifier que l'ordre des étudiants est l'ordre souhaité, sinon corriger l'ordre.
	Sélectionner le format xlsx dans le menu déroulant, puis cliquer sur "Exporter".
	Renommer le fichier téléchargé en notes.xlsx et le placer dans le répertoire "originaux"
	Editer notes.xslx sous Excel
		Vérifier que les étudiants sont dans le bon ordre
		Supprimer les premières colonnes jusqu'à la moyenne (incluse)
		Supprimer la première ligne
		Supprimer la dernière ligne (notes moyennes par question)
		l'enregistrer au format csv ( séparateur ; )
	Editer notes.csv sous éditeur de texte
		remplacer , par .


********

Sous interpréteur PERL:

Les programmes ont été testés pour la version 5.32.1.1 de StrawberryPERL (https://strawberryperl.com/)

Le fichier RepertoireDesDonnees.txt doit contenir le chemin d'accès au répertoire des données,
ce répertoire contenant les sous-répertoires originaux, originaux/txt, nettoye, nettoye/txt, tableaux

Exécuter nettordre.pl
	cela crée "nettoye/_OrdreOriginal.txt"
Renommer "_OrdreOriginal.txt" en "OrdreOriginal.txt"
Editer "OrdreOriginal.txt" pour éliminer, le cas échant, les labels superflus au début de chaque question.

Exécuter nettoyer.pl
	cela crée "nettoye/txt/_*.txt"
	Chaque fichier comprend dans l'ordre:
	- heure de début du test
    - heure de fin du test
	- Pour chaque question:
		- numéro de la question pour l'étudiant (ne)
		- début du texte de la question
		- heure à laquelle l'étudiant a répondu


Exécuter genecsv.pl
	cela crée "_horodatage.csv" et "_numeros.csv" dans le répertoire "tableaux"
	Le fichier "_horodatage.csv" contient heure = g(etudiant,ne)
		heure = 00:00 si l'étudiant n'a pas répondu
	Le fichier "_numeros.csv" contient no = h(étudiant, ne)
	(no = numéro original de la question, ne = numéro de la question vu de l'étudiant)

Exécuter heures2mn.pl
	cela crée "_minutes.csv" dans le répertoire "tableaux"
	Le fichier "_minutes.csv" contient mn = g(etudiant,ne)

Renommer _horodatage.csv en horodatage.csv
Renommer _minutes.csv en minutes.csv
Renommer _numeros.csv en numeros.csv

*********


