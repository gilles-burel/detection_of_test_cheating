% [moy, med, ectyp] = statistiques(tab,fiabilite,tricheurs);
%
% Calcul de statistiques (actuellement moyenne, médiane et écart type) de chaque colonne du tableau tab
% en ne tenant compte que des valeurs fiables. Si des tricheurs ont été identifiés, on peut les indiquer
% pour qu'ils ne soient pas pris en compte dans le calcul.
%
% Entrées:
%   tab = tableau de taille nbetud x nbquestions
%         sur lequel on souhaite calculer les statistiques par colonne
%   fiabilite = tableau de taille nbetud x nbquestions
%         contenant 2 pour les valeurs fiables et 0 ou 1 sinon
%   tricheurs = vecteur ligne contenant les numéros des tricheurs identifiés
%          (fournir un vecteur vide [] si aucun tricheur identifié)
%
% Sorties:
%   moy = vecteur ligne de taille nbquestions contenant les valeurs moyennes
%   med = vecteur ligne de taille nbquestions contenant les valeurs médianes
%   ectyp = vecteur ligne de taille nbquestions contenant les écarts types
%
% Gilles Burel / Lab-STICC / Université de Brest
%

function [moy, med, ectyp] = statistiques(tab,fiabilite,tricheurs)
  
   % Calcul des dimensions et vérifications
  [nbetud, nbquestions] = size(tab);
  [nblig, nbcol] = size(fiabilite);
  assert(nblig==nbetud);
  assert(nbcol==nbquestions);
  clear nblig nbcol
  
  % Elimination des tricheurs
  tab(tricheurs,:)=[];
  fiabilite(tricheurs,:)=[];
  nbetud = nbetud - length(tricheurs);
  
  % Calcul des valeurs moyennes et médianes
  % pour chaque colonne de tab
  % en n'utilisant que les valeurs fiables
  med = -ones(1,nbquestions);
  moy = -ones(1,nbquestions);
  ectyp = -ones(1,nbquestions);
  for q = 1:nbquestions
    tabq = tab(:,q); % colonne q du tableau tab
    fiabq = fiabilite(:,q);  % fiabilité des éléments de tabq
    tabq = tabq(fiabq==2);  % on ne garde que les valeurs fiables
    if (length(tabq)>0)
      med(q) = median(tabq);
      moy(q) = mean(tabq);
      ectyp(q) = std(tabq);
    else
      disp(sprintf('ATTENTION: aucune valeur fiable pour la question %d\n',q));
      disp('médiane et moyenne -1 vont être retournées');
    end 
  end
  
end
