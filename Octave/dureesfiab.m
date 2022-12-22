% [durees, dfiab] = dureesfiab(minutes, mnfiab);
%
% Calcul des durées de réponse aux questions
% et de la fiabilité de ces durées.
%
% L'unité de temps est la minute.
%
% Entrée:
%   minutes = matrice de taille nbetud x (nbquestions+2)
%     contenant aux coordonnées (etud,ne+1) l'instant de réponse de l'étudiant etud
%     à la ne ième question qui lui a été présentée (valeur estimée lorsque l'étudiant n'a pas répondu).
%     La pemière colonne correspond à l'instant de début du test.
%     La dernière colonne correspond à l'instant de fin du test.
%  mnfiab =  matrice de taille nbetud x (nbquestions+2). Cette matrice contient:
%     1 quand l'instant indiqué dans minutes est fiable
%     0 quand l'instant indiqué dans minutes a été estimé
%
% Sorties:
%   durees = matrice de taille nbetud x nbquestions
%     contenant en (etud,ne) la durée de réponse de l'étudiant etud
%     à la ne ième question qui lui a été présentée.
%   dfiab = matrice de taille nbetud x nbquestions. Cette matrice contient:
%     2 quand le durée est fiable (l'étudiant a répondu à la question et à la précédente)
%     1 quand la durée est moyennement fiable (l'étudiant a répondu à la question, mais pas à la précédente)
%     0 quand la durée est peu fiable (l'étudiant n'a pas répondu à la question).
%
% Remarques:
%
%   Les durées fiables et nulles sont mises à un tiers de minute pour tenir
%   compte de la durée de lecture de la question et d'un bref temps de réflexion.
%   Cela se justifie par le fait que Moodle donne l'horodatage avec une faible
%   précion (pas = 1 minute) et donc lorsque le calcul donne une durée nulle
%   il semble judicieux de considérer qu'en réalité cette durée est faible, mais non nulle.
%
%   Les durées non fiables sont mises à 0.
%
%
% Gilles Burel / Lab-STICC / Université de Brest
%

function [durees, dfiab] = dureesfiab(minutes, mnfiab)

   % Calcul des dimensions
  [nbetud, nbcol] = size(minutes);
  nbquestions = nbcol-2;

  % instants de réponse aux questions
  instants = minutes(:,2:nbquestions+1);

  % instants précédents
  instantspr = minutes(:,1:nbquestions);

  % durées de réponses
  durees = instants - instantspr; % durées de réponse

  % fiabilité des durées
  % La durée est fiable si l'étudiant a répondu à la question ET à la question précédente
  dfiab = round(mnfiab(:,2:nbquestions+1)); % round pour convertir en entier
  tmp = mnfiab(:,2:nbquestions+1) & mnfiab(:,1:nbquestions);
  dfiab(tmp) = 2;


  % Les durées nulles et fiables sont forcées à 1/3 minute
  % pour tenir compte du temps de lecture de la question
  % et d'un bref instant de réflection
  durees( (abs(durees)<1e-6)&(dfiab==2) ) = 1/3;

  % Les durées nulles et non-fiables sont forcées à 1/6 minute (10 secondes)
  % Ce sont les questions pour lesquelles la validation a été déclenchée
  % automatiquement car la durée du test était écoulée.
  durees( (abs(durees)<1e-6)&(dfiab<2) ) = 1/6;

end
