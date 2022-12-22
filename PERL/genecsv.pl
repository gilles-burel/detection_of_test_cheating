# genecsv.pl:   création des fichiers _horodatage.csv et _numeros.csv dans le répertoire tableaux
#
# Entrées:
#	RepertoireDesDonnees.txt: fichier contenant le chemin du répertoire de données
#		(ce répertoire doit contenir les sous-répertoires "originaux", "nettoye" et "tableaux")
#   OrdreOriginal.txt (dans le répertoire "nettoye")
#		Fichier contenant les questions dans l'ordre original.
#	Fichiers _01.txt, _02.txt, ..., présents dans nettoye/txt
#
# Sortie:
#	Les fichiers _horodatage.csv et _numeros.csv sont crées dans le répertoire tableaux
#		Le fichier "_horodatage.csv" contient heure = g(etudiant,ne)
#			heure = 00:00 si l'étudiant n'a pas répondu
#		Le fichier "_numeros.csv" contient no = h(étudiant, ne)
#			(no = numéro original de la question, ne = numéro de la question vu de l'étudiant)
#
# Gilles Burel / Lab-STICC / Université de Brest
#


use strict; # rend perl moins permissif
use warnings; # affichage des warnings

my $nom;
my $IN;
my $FH;
my $FN;
my $ligne;
my $i;
my $no;
my $ne;
my $nne;
my $heure;
my $heuredefin;
my $question;
my $qref;
my $trouve;
my $ind1;
my $ind2;
my @fichiers;
my @questions;

# Récupération du chemin des données
open($IN, '<', "RepertoireDesDonnees.txt") or die "RepertoireDesDonnees.txt inexistant";
my $repertoire = <$IN>;
chomp($repertoire);
close $IN;

print "Création de tableaux/_horodatage.csv et tableaux/_ordre.csv\n";

# lecture des questions dans l'ordre original
open($IN, '<', $repertoire."/nettoye/OrdreOriginal.txt") or die "Fichier d'entrée inexistant";
$i = 0;
while ($ligne = <$IN>)
{
	chomp($ligne);
	@questions[$i++] = $ligne;
}
close $IN;


# Récupération de la liste des fichiers .txt présents dans nettoye/txt
$nom = $repertoire."/nettoye/txt/*.txt";
@fichiers = glob($nom);

# ouverture des fichiers de sortie
open($FH, '>', $repertoire."/tableaux/_horodatage.csv") or die "Fichier de sortie inexistant";
open($FN, '>', $repertoire."/tableaux/_numeros.csv") or die "Fichier de sortie inexistant";

foreach (@fichiers) 
{
	$nom = $_;
	if ($nom =~ /_/)
	{ 
		
		printf("Traitement de %s \n", $nom);
		
		# traitement des réponses de l'étudiant
		
		open($IN, '<', $nom) or die "Fichier d'entrée inexistant";
		
		# heure de début du test
		$heure = <$IN>;
		chomp($heure);
		print $FH $heure.";";

		# heure de fin du test
		$heuredefin = <$IN>;
		chomp($heuredefin);

		
		$nne = 0;
		while ($ligne = <$IN>)
		{
			$ne = int($ligne);  # numéro de la question vue de l'étudiant
			$question = <$IN>;  # texte de la question
			$heure = <$IN>;		# horodatage de la question
			chomp($question);
			chomp($heure);
			
			($ne==(++$nne)) or die "Erreur de numérotation des questions";
		
			print $FH $heure.";";
			
			# recherche de la question dans la liste originale des questions
			# si elle est trouvée, no désignera le numéro original de la question.
			$no = 0;
			for ($i=0;$i<=$#questions;$i++)
			{
				$qref = $questions[$i];  # texte (début) de la question numéro i dans l'ordre original
				$ind1 = index($qref,$question);
				$ind2 = index($question,$qref);
				$trouve = int(($ind1>=0)||($ind2>=0));

				if ($trouve)
				{
					if ($no==0)
					{
						$no = $i+1;
					}
					else
					{
						printf("ERREUR: question déjà trouvée %d\n",$i+1);
					}
					
				}
			}
			if ($no==0)
			{
				printf $question;
				printf "ERREUR: question non trouvée\n";
			}
			print $FN $no.";";
			
		}
		print $FH $heuredefin.";";
		print $FH "\n";
		print $FN "\n";
		
		close $IN;
	}

}

close $FH;
close $FN;

print "Appuyer sur une touche pour terminer";
<>; # pause en attente de l'appui sur une touche

