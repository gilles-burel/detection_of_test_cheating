% TypeDeTest = DetermineTypeDeTest(minutes);
%
% Estimation du type de test en fonction de l'horodatage
%
% Entrée:
%   minutes = matrice de taille nbetud x (nbquestions+2)
%       contenant aux coordonnées (etud,ne+1) l'instant de réponse de l'étudiant etud
%       à la ne ième question qui lui a été présentée (0 lorsque l'étudiant n'a pas répondu).
%       La pemière colonne correspond à l'instant de début du test.
%       La dernière colonne correspond à l'instant de fin du test.
%
% Sortie:
%   TypeDeTest =
%     1 = test séquentiel
%     2 = test à navigation libre
%     3 = test à navigation libre sans horodatage
%
% Gilles Burel
%
% Lab-STICC / Université de Brest, France
%

function TypeDeTest = DetermineTypeDeTest(minutes)

  [nbetud, nbcol] = size(minutes);
  nbquestions = nbcol-2;

  TypeDeTest = 1;
  HorodatageValide = zeros(1,nbetud);

  % Si on trouve au moins un étudiant qui est revenu en arrière, c'est un test à navigation libre
  for etud=1:nbetud
    mn = minutes(etud,:);
    mn = mn(mn>0);
    dif = mn(2:end)-mn(1:end-1);
    if length(find(dif<0))>0
      TypeDeTest = 2;
      disp('Test de type 2: navigation libre');
      return;
    end
    HorodatageValide(etud) = any(dif(2:end-1));
  end

  if ~any(HorodatageValide)
    TypeDeTest = 3;
    disp('Test de type 3: navigation libre sans horodatage');
  else
    disp('Test de type 1: séquentiel');
  end

end
