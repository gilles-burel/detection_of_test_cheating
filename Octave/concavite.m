% [RetardMax, minutes_predites] = concavite(minutes, mnfiab, numeros, Moy);
%
% Notations pour la compréhension des commentaires:
%   no = numéro original de la question
%   ne = numéro de la question vue de l'étudiant
%
% Entrées:
%   minutes = matrice de taille nbetud x (nbquestions+2)
%     contenant aux coordonnées (etud,ne+1) l'instant de réponse de l'étudiant etud
%     à la ne ième question qui lui a été présentée (valeur estimée lorsque l'étudiant n'a pas répondu).
%     La pemière colonne correspond à l'instant de début du test.
%     La dernière colonne correspond à l'instant de fin du test.
%   mnfiab =  matrice de taille nbetud x (nbquestions+2). Cette matrice contient:
%     1 quand l'instant indiqué dans minutes est fiable
%     0 quand l'instant indiqué dans minutes a été estimé
%   numeros = tableau de taille nbetud x nbquestions
%         donnant no en fonction de (etud,ne)
%   Moy = vecteur contenant les durées moyennes de réponses aux questions (en minutes)
%
% Sorties:
%   RetardMax = retard maximal pris par l'étudiant par rapport à un étudiant moyen
%   minutes_predites = instants de réponses aux questions pour un étudiant moyen
%
%   Gilles Burel / Lab-STICC / Université de Brest, France
%


function [RetardMax, minutes_predites] = concavite(minutes, mnfiab, numeros, Moy)

  % Calcul des dimensions
  [nbetud, nbcol] = size(minutes);
  nbquestions = nbcol-2;

  % instants de réponse aux questions
  instants = minutes(:,2:nbquestions+1);

  for etud = 1:nbetud
    % horodatage effectif
    h = minutes(etud,2:nbquestions+1) - minutes(etud,1);
    % horodatage prédit
    hp = cumsum(Moy(numeros(etud,:)));
    % ajustement de la prédiction par rapport à la dernière question
    % à laquelle l'étudiant a répondu
    derniere = max(find(mnfiab(etud,2:nbquestions+1)>0));
    hp = hp * (h(derniere)/hp(derniere));
    % retard par rapport à la prédiction
    % On pondère en fonction de la dernière question
    retard = (h(1:derniere) - hp(1:derniere));
    [maxi, pos] = max(retard);
    RetardMax(etud) = maxi;
    minutes_predites(etud,:)=hp;
  end

end

