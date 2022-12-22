% gr = elagage(gh, suspects);
%
% Elagage des groupes de tricheurs:
%    tout groupe qui ne contient pas au moins un étudiant préalablement détecté par horodatage est éliminé.
%
% Entrées:
%   gh = vecteur contenant la numérotation des groupes de tricheurs détectés par
%        similarité des réponses (avant élagage)
%        groupe(a) = 0 si l'étudiant a n'a pas triché
%                  = 1 ou plus s'il a triché (numéro du groupe de tricheurs)
%   suspects = vecteur contenant les numéros des étudiants suspects selon l'analyse par horodatage.
%
% Sorties:
%   gr = vecteur contenant la numérotation des groupes de tricheurs (après élagage)
%     par rapport à gh, certains étudiants qui avait un numéro de tricheur (1, 2, ...)
%     ont à présent le numéro 0 (non tricheur) si leur groupe n'a pas été confirmé par horodatage.
%     La numérotation des groupes est également refaite par rapport à gh, pour ne pas
%     laisser de numéro de groupe inutilisé.
%
%
% Gilles Burel / Lab-STICC / Université de Brest
%


function gr = elagage(gh, suspects)

  gr = gh;
  nbg = max(gr);
  g = 1;
  while (g<=nbg)
    if length(intersect(suspects,find(gr==g)))==0
      % Si le groupe ne contient aucun étudiant suspects
      gr(gr==g) = 0;  % on met à 0 (non-tricheur) le numéro de groupe des étudiants concernés
      gr(gr>g) = gr(gr>g)-1; % on décrémente tous les numéros de groupes supérieurs
      nbg = nbg-1; % on décremente le nombre de groupes
    else
      % Sinon on incrémente le numéro de groupe à analyser
      g = g+1;
    end
  end

end

