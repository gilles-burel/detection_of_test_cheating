% [sauts, sautTh] = sautsmoyens(minutes);
%
% Les questions étant numérotées dans l'ordre dans lequel elles
% ont été présentées à l'étudiant un étudiant qui parcourt les questions
% linéairement fait un saut d'une unité d'une question à la suivante.
% Un étudiant qui parcourt les questions de manière erratique fait des sauts plus importants.
% Cette fonction calcule la valeur moyenne des sauts.
%
% Entrée:
%  minutes = matrice de taille nbetud x (nbquestions+2)
%     contenant aux coordonnées (etud,ne+1) l'instant de réponse de l'étudiant etud
%     à la ne ième question qui lui a été présentée (valeur estimée lorsque l'étudiant n'a pas répondu).
%     La pemière colonne correspond à l'instant de début du test.
%     La dernière colonne correspond à l'instant de fin du test.
%
% Sorties:
%   sauts = vecteur contenant le saut moyen de chaque étudiant.
%   sautTh = saut moyen théorique pour un parcours totalement aléatoire.
%
%
% Gilles Burel / Lab-STICC / Université de Brest, France
%

function [sauts, sautTh] = sautsmoyens(minutes)

  [nbetud, nbcol] = size(minutes);
  nbquestions = nbcol - 2;

  for etud = 1:nbetud

    mn = minutes(etud,:);
    [Mn, ordre] = sort(mn(2:nbquestions+1));

    % On ne garde que les questions pour lesquelles on a un horodatage
    ind = find(Mn>0);
    Mn = Mn(ind);
    ordre = ordre(ind);
    ordre = [0 ordre]; % question 0 = démarrage du test

    % Calcul des sauts
    dif = ordre(2:end) - ordre(1:end-1);
    sauts(etud) = mean(abs(dif));
  end

  % saut moyen théorique pour un parcours totalement aléatoire
  sautTh = (nbquestions+1)/3;

end

