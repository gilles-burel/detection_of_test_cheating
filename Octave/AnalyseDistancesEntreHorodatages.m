% [dh, dhs, suspects] = AnalyseDistancesEntreHorodatages(minutes, numeros);
%
% Notations pour la compréhension des commentaires:
%   no = numéro original de la question
%   ne = numéro de la question vue de l'étudiant
%
% Entrées:
%   minutes = matrice de taille nbetud x (nbquestions+2)
%       contenant aux coordonnées (etud,ne+1) l'instant de réponse de l'étudiant etud
%       à la ne ième question qui lui a été présentée (valeur estimée lorsque l'étudiant n'a pas répondu).
%       La pemière colonne correspond à l'instant de début du test.
%       La dernière colonne correspond à l'instant de fin du test.
%   numeros = tableau de taille nbetud x nbquestions
%         donnant no en fonction de (etud,ne)
%
% Sorties:
%   dh = matrice de taille nbetud x nbetud contenant les distances normalisées entre horodatages
%   dhs = dh seuillée (1 pour les distances inférieures à un seuil, 0 pour les autres)
%   suspects = vecteur contenant les numéros des étudiants suspects selon l'horodatage
%
%
%   Gilles Burel / Lab-STICC / Université de Brest, France
%



function [dh, dhs, suspects] = AnalyseDistancesEntreHorodatages(minutes, numeros)

  % horodatage ordonné
  Minutes = ordonne(minutes,numeros);
  MinutesFiab = (Minutes>0);

  % distances entre horodatages (sur la base des valeurs médianes)
  [dh, dhTh] = distance(Minutes,MinutesFiab,'M');
  fprintf('Distance théorique entre horodatages de 2 non tricheurs = %0.1f mn\n',dhTh);
  dh = dh / dhTh;  % distances normalisées
  seuil = 1/4;
  fprintf('  seuil fixé à %d%% de cette distance théorique, soit %0.1f mn\n',round(100*seuil), seuil*dhTh);
  dhs = (dh<seuil);

  Visu(dh,'distances normalisees entre horodatages','etudiant','etudiant');
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_distances_horodatage.pdf', '-dpdfcrop');

  Visu(1-dhs,'distances seuillees entre horodatages','etudiant','etudiant');
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_distances_horodatage_seuillees.pdf', '-dpdfcrop');

  % histogramme des distances normalisées
  tmp = triu(dh,1,'pack');
  figure, hist(tmp,25), title('histogramme des distances normalisées entre horodatages')
  grid on
  grid minor on

  % Calcul de la liste des suspects
  tmp = dhs - diag(diag(dhs));
  tmp = sum(tmp');
  suspects = find(tmp);

end

