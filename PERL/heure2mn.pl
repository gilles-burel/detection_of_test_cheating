# heures2mn.pl:   création des fichiers _horodatage.csv et _numeros.csv dans le répertoire tableaux
#
# Entrées:
#	RepertoireDesDonnees.txt: fichier contenant le chemin du répertoire de données
#		(ce répertoire doit contenir les sous-répertoires "originaux", "nettoye" et "tableaux")
#   OrdreOriginal.txt (dans le répertoire "nettoye")
#		Fichier contenant les questions dans l'ordre original.
#	Fichiers _01.txt, _02.txt, ..., présents dans nettoye/txt
#
# Sortie:
#	Le fichier "_minutes.csv" est créé dans le répertoire "tableaux"
#		Le fichier "_minutes.csv" contient mn = g(etudiant,ne) 
#			où ne est le numéro de la question vue de l'étudiant et mn l'horodatage en minutes
#
# Gilles Burel / Lab-STICC / Université de Brest
#



use strict; # rend perl moins permissif
use warnings; # affichage des warnings

my $IN;
my $OUT;
my $repertoire;
my $ligne;
my @champs;
my $hmn;
my $mn;

# Récupération du chemin des données
open($IN, '<', "RepertoireDesDonnees.txt") or die "RepertoireDesDonnees.txt inexistant";
$repertoire = <$IN>;
chomp($repertoire);
close $IN;

# Ouverture du fichier d'entrée _horodatage.csv
open($IN, '<', $repertoire."/tableaux/_horodatage.csv") or die "Fichier d'entrée inexistant";
# Ouverture du fichier de sortie _minutes.csv
open($OUT, '>', $repertoire."/tableaux/_minutes.csv") or die "Impossible d'ouvrir le fichier de sortie";

while ($ligne = <$IN>)
{
	chomp($ligne);
	@champs = split(/;/,$ligne);
	foreach (@champs)
	{
		$hmn = $_;    # variable courante (ici le champ)
		$hmn =~ /((\d)+):((\d)+)/;
		# $hmn = $&;    # sous-chaîne matchée (par exemple 15:42). Inutile ici.
		# conversion de l'heure en minutes
		$mn = 60 * $1 + $3;  # par exemple pour 15:42 on aura $1=15 $2=: et $3=42
		# écriture des minutes dans le fichier de sortie
		print $OUT $mn.";";
	}
	print $OUT "\n";
}

close $IN;
close $OUT;

print "ENTER pour terminer";
<>;
