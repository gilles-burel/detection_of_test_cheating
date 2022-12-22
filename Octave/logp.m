% lp = logp(rep,a,b);
%
% Entrées:
%   rep = matrice de taille nbetud x nbquestions contenant les
%              réponses données par les étudiants en utilisant ce code:
%               0 = pas de réponse
%               1 = bonne réponse
%               2 ou plus = fausse réponse (un numéro différent est affecté à chaque fausse réponse possible)
%               Ainsi, le code de la réponse fournie par l'étudiant i à la question no se trouve ligne i, colonne no
%    a,b = numéros des étudiants dont on compare les réponses
%
% Sortie:
%   lp = distance logarithmique entre les réponses des étudiants a et b
%         (voir détails dans l'article, équation 7).
%
%   Gilles Burel / Lab-STICC / Université de Brest, France
%



function lp = logp(rep,a,b)

  [nbetud,nbquestions] = size(rep);
  ra = rep(a,:);  % réponses de l'étudiant a
  rb = rep(b,:);  % réponses de l'étudiant b
  lp = 0;
  for q = 1:nbquestions
    if (ra(q)==rb(q))  % si les étudiants ont répondu de manière identique à la question q
      ind = find( rep(:,q) == ra(q) );
      p = length(ind)/nbetud;  % probabilité de cette réponse
      lp = lp + log(p);
    end
  end
  lp = lp/nbquestions;

end

