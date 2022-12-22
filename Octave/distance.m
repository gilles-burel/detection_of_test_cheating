% [tabdist, distTh] = distance(tab,fiab, type);
%
% Calcul des distances entre les lignes d'un tableau
%
% Entrées:
%   tab: tableau dont on souhaite calculer les distances entre lignes.
%   fiab: tableau de même taille que tab, contenant 1 aux positions des éléments fiables et 0 ailleurs.
%   type = type de distance calculée
%        'E' = écart type
%        'M' = médiane
%        'R' = distances entre réponses
%        'G' = g2 index
%
% Sorties:
%   tabdist: matrice des distances
%       tabdist(a,b) = distance entre tab(a,:) et tab(b,:)
%       seuls les éléments fiables sont pris en compte dans le calcul.
%   distTh: matrice des ditances théoriques dans le cas sans triche
%       Le calcul théorique n'a été implémenté que pour les types 'E' et 'M'
%       pour les autres types, la valeur est mise à 1.
%
% Gilles Burel
%
% Lab-STICC / Université de Brest, France
%

function [tabdist, distTh] = distance(tab, fiab, type)

  if isempty(fiab)
    fiab = ones(size(tab));
  end

  [nblig,nbcol] = size(tab);
  [nblig2,nbcol2] = size(fiab);
  assert(nblig2==nblig);
  assert(nbcol2==nbcol);

  tabdist = zeros(nblig,nblig);

  for a = 1:nblig
    for b = a:nblig
      ind = find( fiab(a,:)&fiab(b,:) );
      switch(type)
      case 'E',
        tabdist(a,b) = std(tab(a,ind)-tab(b,ind),1);
        %tabdist(a,b) = sqrt(sum((tab(ind,a)-tab(ind,b)).^2));
      case 'M',
        tabdist(a,b) = median(abs(tab(a,ind)-tab(b,ind)));
      case 'R',  % comparaison de réponses
        tabdist(a,b) = -logp(tab,a,b);
      case 'G',   % g2 index
        tabdist(a,b) = g2index(tab,a,b);
      otherwise,
        disp('ERREUR: type de distance non défini');
        disp(type);
        return;
      end

      if (b>a)
        if (type=='G')
          tabdist(b,a) = g2index(tab,b,a);
        else
          tabdist(b,a) = tabdist(a,b);
        end
      end

    end
  end


  % Distance théorique (dans le cas sans triche)
  val = tab(find(fiab));
  mini = min(val);
  maxi = max(val);
  amplitude = maxi - mini;
  switch(type)
    case 'E',
      distTh = amplitude/sqrt(12);
    case 'M',
      distTh = (1-1/sqrt(2))*amplitude;
    case 'R',
      disp('distance théorique entre notes à implémenter');
      distTh = 1;
    case 'G',
      disp('distance théorique du g2index à implémenter');
      distTh = 1;
    otherwise,
      disp('ERREUR: type de distance non défini');
      return;
  end

end
