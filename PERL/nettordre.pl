# nettordre.pl:   nettoyage du fichier OrdreOriginal.txt
#
# Entrées:
#	RepertoireDesDonnees.txt: fichier contenant le chemin du répertoire de données
#		(ce répertoire doit contenir les sous-répertoires "originaux" et "nettoye")
#	OrdreOriginal.txt: fichier non nettoyé contenant l'ordre original des questions
#		(ce fichier doit se trouver dans le sous répertoire "originaux"
# Sortie:
#	_OrdreOriginal.txt: fichier nettoyé contenant l'ordre original des questions
#		(ce fichier est créé dans le sous répertoire "nettoye"
#
# Gilles Burel / Lab-STICC / Université de Brest
#

use strict;
use warnings;

my $IN;
my $OUT;
my $repertoire;
my $type;

my @typedequestion = ("Vrai/Faux","Choix multiple","Numérique","Calculée","Glisser-déposer sur une image");

print "Nettoyage du fichier contenant l'ordre original des questions\n";

# Récupération du chemin des données
open($IN, '<', "RepertoireDesDonnees.txt") or die "RepertoireDesDonnees.txt inexistant";
$repertoire = <$IN>;
chomp($repertoire);
close $IN;

# Ouverture des fichiers d'entrée et de sortie
open($IN, '<', $repertoire."/originaux/OrdreOriginal.txt") or die "Fichier d'entrée inexistant";
open($OUT, '>', $repertoire."/nettoye/_OrdreOriginal.txt") or die "Fichier de sortie impossible à ouvrir";

# Lecture ligne par ligne du fichier d'entrée 
# Si la ligne est une question, elle est écrite dans le fichier de sortie,
#   débarrassée de l'indication du type de question.
while (my $ligne = <$IN>)
{
	foreach (@typedequestion)
	{	$type = $_;
		if ($ligne =~ /    ($type)/)
		{	
			$ligne =~ /    ($type)(.+?)((\.\.\.)|\n)/;
			print $OUT $2."\n";
		}
	}
}

close $IN;
close $OUT;

print "Appuyez sur ENTER pour terminer";
<>
