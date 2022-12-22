% tabrange = ordonne(tab, numeros);
%
% Remise en ordre des lignes du tableau tab en fonction de l'ordre dans lequel
% les questions ont été présentées à l'étudiant.
%
% Notations pour la compréhension des commentaires:
%   no = numéro original de la question
%   ne = numéro de la question vue de l'étudiant
%
% Entrées:
%   tab = tableau de taille nbetud x nbquestions ou
%         indexé en (etud,ne) et contenant no en fonciton de (etud,ne)
%         OU BIEN
%         tableau de taille nbetud x (nbquestions+2) contenant les
%          instants de réponse aux questions (dans ce cas, la première
%          et la dernière colonne correspondent aux instants de début et fin de test)
%   numeros = tableau de taille nbetud x nbquestions
%         donnant no en fonction de (etud,ne)
%
% Sortie:
%   tabrange = tableau de taille nbetud x nbquestions
%         contenant les valeurs de tab indexées en (etud,no)
%
% Gilles Burel / Lab-STICC / Université de Brest
%


function tabrange = ordonne(tab, numeros)

  % Calcul des dimensions et vérifications
  [nbetud, nbquestions] = size(numeros);
  [nblig, nbcol] = size(tab);
  assert(nblig==nbetud);

  if (nbcol==(nbquestions+2))
    % s'il s'agit d'un tableau d'horodatage on supprime la première et la dernière colonne
    % (instants de début et fin de test, non pertinents ici)
    debut = tab(:,1);
    fin = tab(:,end);
    tab = tab(:,2:nbquestions+1);
  else
    debut = [];
    fin = [];
    assert(nbcol==nbquestions);
  end

  % Remise en ordre des lignes du tableau tab
  tabrange = -ones(nbetud,nbquestions);
  for etud=1:nbetud
    p = numeros(etud,:);  % ordre des questions pour l'étudiant
    tabrange(etud,p) = tab(etud,:);
  end

  % Vérification
  assert(length(find(tabrange==(-1)))==0);

  % restauration éventuelle de la première et de la dernière colonne
  if (length(debut)>0)
    tabrange = [debut tabrange fin];
  end

end
