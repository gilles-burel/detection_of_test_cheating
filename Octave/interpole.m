% [mni, mnfiab] = interpole(minutes);
%
% Interpolation du tableau des instants de réponse aux questions.
%
% L'unité de temps est la minute.
%
% Entrée:
%   minutes = matrice de taille nbetud x (nbquestions+2)
%     contenant aux coordonnées (etud,ne+1) l'instant de réponse de l'étudiant etud
%     à la ne ième question qui lui a été présentée (0 lorsque l'étudiant n'a pas répondu).
%     La pemière colonne correspond à l'instant de début du test.
%     La dernière colonne correspond à l'instant de fin du test.
%
% Sorties:
%   mni = matrice de taille nbetud x (nbquestions+2)
%     similaire à minutes mais avec des valeurs estimées (au lieu de 0)
%     là où l'étudiant n'avait pas répondu.
%   mnfiab = matrice de taille nbetud x (nbquestions+2). Cette matrice contient:
%     1 quand l'instant indiqué dans mni est fiable
%     0 quand l'instant indiqué dans mni a été estimé
%
%
% Gilles Burel / Lab-STICC / Université de Brest
%



function [mni, mnfiab] = interpole(minutes)

% calcul des paramètres
[nbetud, nbcol] = size(minutes);
nbquestions = nbcol-2;

% tableau de fiabilité
mnfiab = (minutes>0);

% Les instants non disponibles sont estimés
% On estime à un tiers de minute le temps passé sur une question à laquelle
% l'étudiant n'a pas répondu. Cependant, si cette estimation s'avère
% excessive, on fait une interpolation linéaire.
mni = minutes;
for etud=1:nbetud
  qref = 1;
  ref = minutes(etud,1);
  for q=2:nbquestions+2
    mn = minutes(etud,q);
    if (mn>0)
      if ((q-qref)>=2)
        pas = min(1/3,(mn-ref)/(q-qref));
        mni(etud,qref+1:q-1) = ref+pas*[1:q-qref-1];
      end
      ref = mn;
      qref = q;
    end
  end
end

