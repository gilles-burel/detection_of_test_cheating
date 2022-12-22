# nettoyer.pl:   nettoyage des fichiers de réponses et d'horodatage des étudiants
#
# Entrées:
#	RepertoireDesDonnees.txt: fichier contenant le chemin du répertoire de données
#		(ce répertoire doit contenir les sous-répertoires "originaux" et "nettoye")
#	Fichiers 01.txt, 02.txt, ..., présents dans originaux/txt
#
# Sortie:
#	Les fichiers _01.txt, _02.txt, ..., sont créés dans nettoye/txt
#	Chaque fichier comprend dans l'ordre:
#	- heure de début du test
#   - heure de fin du test
#	- Pour chaque question:
#		- numéro de la question pour l'étudiant (ne)
#		- début du texte de la question
#		- heure à laquelle l'étudiant a répondu
#
# Gilles Burel / Lab-STICC / Université de Brest
#

use strict; # rend perl moins permissif
use warnings; # affichage des warnings

my $nom_in;
my $nom;
my $repertoire;
my $IN;
my $OUT;
my $ligne;
my $question;
my $hfound;
my @fichiers;
my $heuredefin;

# Récupération du chemin des données
open($IN, '<', "RepertoireDesDonnees.txt") or die "RepertoireDesDonnees.txt inexistant";
$repertoire = <$IN>;
chomp($repertoire);
close $IN;


# Récupération de la liste des fichiers .txt présents dans originaux/txt
$nom = $repertoire."/originaux/txt/*.txt";
@fichiers = glob($nom);

foreach (@fichiers) 
{
	$nom = $_;
	printf("Traitement de %s \n", $nom);

	# traitement des réponses de l'étudiant

	open($IN, '<', $nom) or die "Fichier d'entrée inexistant";
	
	$nom_in = $nom;
	
	# création du nom du fichier de sortie
	$nom =~ s/originaux/nettoye/;
	$nom =~ s/\/txt\//\/txt\/_/;

	open($OUT, '>', $nom) or die "Fichier de sortie impossible à ouvrir";
	
	# Lecture du fichier d'entrée pour récupération des heures de début et fin de test.
	while ($ligne = <$IN>)
	{
		if ($ligne =~ /Pas encore répondu/)  # récupération de l'heure de début du test
		{
			$ligne =~ /(\d)+:(\d)+/;
			my $heure = $&;
			print $OUT $heure."\n";
		}
		elsif ($ligne =~ /Tentative terminée/)  # récupération de l'heure de fin du test
		{
			$ligne =~ /(\d)+:(\d)+/;
			$heuredefin = $&;
			print $OUT $heuredefin."\n";
			last;  # sortie de boucle
		}
	}

	close $IN;
	
	# Nouvelle lecture du fichier d'entrée pour récupération des données liés aux questions
	open($IN, '<', $nom_in) or die "Fichier d'entrée inexistant";

	$hfound = 1;  # indique si l'horodatage a été trouvé
	
	while ($ligne = <$IN>)
	{
		if ($ligne =~ /  Question ((\d)+)/)  # récupération du numéro de la question vue de l'étudiant
		{
			unless ($hfound)
			{
				print $OUT "00:00\n";
			}
			my $ne = $1;  # numéro de la question vu de l'étudiant
			print $OUT $ne."\n";
			$hfound = 0;  
		}
		elsif ($ligne =~ /        Texte de la question/) # récupération du début du texte de la question
		{
			$ligne = <$IN>;
			$ligne = <$IN>;
			$question = "";
			while (length($ligne)>1)
			{
				chomp($ligne);
				$question = $question.$ligne." ";
				$ligne = <$IN>;
			}
			chop($question);
			print $OUT $question."\n";
		}
		elsif ($ligne =~ /Enregistré/) # récupération de l'horodatage
		{
			unless ($hfound)
			{
				$ligne =~ /(\d)+:(\d)+/;
				my $heure = $&;
				print $OUT $heure."\n";
				$hfound = 1;
			}
		}

		
	}

	unless ($hfound)
	{
		print $OUT "00:00\n";
	}
	

		
	close $IN;
	close $OUT;

}

print "Appuyez sur ENTER pour terminer";
<>; # pause en attente de l'appui sur une touche

