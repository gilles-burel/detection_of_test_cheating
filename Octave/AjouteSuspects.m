% AjouteSuspects(suspects,groupes);
%
% Entrées:
%   suspects = vecteur de taille nombre de suspects contenant les numéros des étudiants suspectés de triche
%   groupes = vecteur de taille nombre d'étudiants contenant les numéros de groupes de tricheurs affectés aux étudiants
%
% Sortie:
%   Pour chaque étudiant suspect, si on note a son numéro,
%   la fonction ajoute une étoile rouge aux coordonnées (a,groupes(a))
%   sur une figure qui doit avoir été ouverte préalablement à l'appel à la fonction.
%
%
% Gilles Burel / Lab-STICC / Université de Brest
%


function AjouteSuspects(suspects,groupes)

  hold on
  for a=1:length(suspects)
    etud = suspects(a);
    plot(etud,groupes(etud),'*r')
  end
  hold off

end

