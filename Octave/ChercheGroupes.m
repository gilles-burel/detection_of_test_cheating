% groupe = ChercheGroupes(ds);
%
% En utilisant les similarités détectée dans les réponses, cette fonction essaie
% de regrouper les étudiants par groupes de tricheurs (les similarités étant fortes au sein d'un groupe)
%
% Entrée:
%   ds = tableau de distances seuillées
%          ds(a,b) = 1 s'il y a une forte similarité entre les réponses des étudiants a et b
%                  = 0 sinon
%
% Sortie:
%   groupe = vecteur contenant la numérotation des groupes de tricheurs
%       groupe(a) = 0 si l'étudiant a n'a pas triché
%                 = 1 ou plus s'il a triché (numéro du groupe de tricheurs)
%
%
%   Gilles Burel / Lab-STICC / Université de Brest, France
%


function groupe = ChercheGroupes(ds)

  [nblig,nbcol]=size(ds);
  nbetud = nblig;
  assert(nbcol==nbetud);

  nbgroupes = 0;
  g = 0;
  groupe(1,1:nbetud)=g;
  for a = 1:nbetud-1
    for b = a+1:nbetud
      if ds(a,b)  % s'il y a similarité entre a et b
        if (groupe(b)==0)  % si l'étudiant b n'a pas été affecté à un groupe
          if (groupe(a)==0) % si l'étudiant a n'a pas été affecté à un groupe
            % création d'un nouveau groupe et affectation de a et b à ce groupe
            g = g+1;
            groupe(a) = g;
            groupe(b) = g;
          else
            % sinon l'étudiant b est affecté au groupe de l'étudiant a
            groupe(b) = groupe(a);
          end
        else   % si l'étudiant b a été affecté à un groupe
          if (groupe(a)==0)  % si l'étudiant a n'a pas été affecté à un groupe
            groupe(a)=groupe(b);  % l'étudiant a est affecté au groupe de l'étudiant b
          else   % si l'étudiant a a également été affecté à un groupe
            if groupe(a)~=groupe(b)  % si les groupes sont différents
              % on fusionne les groupes en leur donnant le plus petit des deux numéris de groupes
              mini = min([groupe(a),groupe(b)]);
              maxi = max([groupe(a),groupe(b)]);
              groupe(find(groupe==maxi))=mini;
            end
          end
        end
      end
    end
  end
end

