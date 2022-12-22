% [notes, reponses, minutes, numeros, nbetud, nbquestions, QuestionsCalculees] = LectureDonnees(repertoire);
%
% Lecture des tableaux de données
%
% Notations pour la compréhension des commentaires:
%   no = numéro original de la question
%   ne = numéro de la question vue de l'étudiant
%
% Entrée:
%   repertoire = chaîne de caractères indiquant le répertoire dans lequel se
%       trouvent les tableaux de données (exemple: '../Donnees/tableaux' ou bien '.')
%
% Sorties:
%   notes = matrice de taille nbetud x nbquestions
%           contenant aux coordonnées (etud,no) la note obtenue par
%           l'étudiant à la question no
%           Si le fichier n'existe pas, une matrice vide est retournée.
%   reponses = matrice de taille nbetud x nbquestions contenant les
%              réponses données par les étudiants en utilisant ce code:
%               0 = pas de réponse
%               1 = bonne réponse
%               2 ou plus = fausse réponse (un numéro différent est affecté à chaque fausse réponse possible)
%               Ainsi, le code de la réponse fournie par l'étudiant i à la question no se trouve ligne i, colonne no
%   minutes = matrice de taille nbetud x (nbquestions+2)
%       contenant aux coordonnées (etud,ne+1) l'instant de réponse de l'étudiant etud
%       à la ne ième question qui lui a été présentée (0 lorsque l'étudiant n'a pas répondu).
%       La pemière colonne correspond à l'instant de début du test.
%       La dernière colonne correspond à l'instant de fin du test.
%   numeros = tableau de taille nbetud x nbquestions
%       donnant no en fonction de (etud,ne)
%   nbetud = nombre d'étudiants qui ont réalisé le test
%   nbquestions = nombre de questions du test
%
%   Gilles Burel, Khawla Ben Gaied, Ramla Ben Abdelkader
%
%   Lab-STICC / Université de Brest, France
%

function [notes, reponses, minutes, numeros, nbetud, nbquestions, QuestionsCalculees] = LectureDonnees(repertoire)

  %% Lecture du tableau des numéros, donnant l'ordre des questions

  nomfich = sprintf("%s/numeros.csv", repertoire);
  numeros = dlmread(nomfich, ";");
  % suppression des colonnes nulles (correction bug Matlab - inutile sous Octave)
  numeros = numeros(:,any(numeros));

  % Détermination des dimensions
  [nbetud, nbquestions] = size(numeros);

  %% Lecture du tableau d'horodatage (en minutes)
  nomfich = sprintf("%s/minutes.csv", repertoire);
  minutes = dlmread(nomfich, ";");
  % suppression des colonnes nulles (correction bug Matlab - inutile sous Octave)
  minutes = minutes(:,any(minutes));

  % Vérifications
  [nblig, nbcol] = size(minutes);
  assert(nblig==nbetud);
  assert(nbcol==(nbquestions+2));

  % syntaxe Octave simple mais non compatible Matlab
  % notes = dlmread(sprintf("%s/notes.csv",repertoire), ";","emptyvalue",0);

  %% Lecture du tableau de notes (version compatible Matlab)

  nomfich = sprintf("%s/notes.csv", repertoire);
  fid = fopen(nomfich,'rt');% Ouvrir fichier
  if fid<=0
    fprintf('ERREUR: impossible d''ouvrir le fichier %s\n',nomfich);
    notes = [];
  else
    notes = textscan(fid, repmat('%s ',1,nbquestions),'Delimiter',';');% lecture formatée
    fclose(fid);% Fermer fichier
    notes=[notes{:}]; % Conversion en matrice de strings
    notes=str2double(notes); % Conversion en numérique
    notes(isnan(notes)) = 0; % Remplacement des NaN (non-réponses) par la note 0
  end


  % Vérifications
  [nblig, nbcol] = size(notes);
  assert(nblig==nbetud);
  assert(nbcol==nbquestions);

  %% Lecture du fichier des réponses

  % Chaque ligne correspond à un étudiant
  % Sur la ligne on trouve successivement la réponse de l'étudiant suivie
  % de la réponses exacte, ceci pour chaque question.
  nomfich = sprintf("%s/reponses.csv", repertoire);
  fid = fopen(nomfich,'rt');%Ouvrir fichier
  if fid<=0
    fprintf('ERREUR: impossible d''ouvrir le fichier %s\n',nomfich);
    return;
  end
  tabrep = textscan(fid, repmat('%s ',1,2*nbquestions),'Delimiter',';');% lecture formatee en colonnes
  fclose(fid);%Fermer fichier
  tabrep=[tabrep{:}];%Convertir en matrice de strings (array)
  rep = tabrep(:,1:2:end); % réponses de l'étudiant
  repex = tabrep(:,2:2:end); % réponses exactes

  % Vérifications
  [nblig, nbcol] = size(rep);
  if (nblig~=nbetud)
    disp('ATTENTION: fichier de réponses non valide');
    reponses = [];
    return;
  end

  assert(nbcol==nbquestions);
  [nblig, nbcol] = size(repex);
  assert(nblig==nbetud);
  assert(nbcol==nbquestions);

  % numérotation des réponses
  reponses = -ones(nbetud,nbquestions);
  for q=1:nbquestions
    cpt = 0; % initialisation du compteur de fausses réponses
    for etud=1:nbetud
      if strcmp(rep(etud,q),'-')
        reponses(etud,q)=0; % code 0 en cas de non-réponse
        assert(notes(etud,q)==0);
      elseif strcmp(rep(etud,q),repex(etud,q))
        reponses(etud,q)=1; % code 1 en cas de bonne réponse
        assert(notes(etud,q)>0);
      elseif (notes(etud,q)>0)
          % cas particulier pour traiter les réponses numériques avec
          % tolérance (cas où les chaînes de caractères sont différentes, mais les
          % valeurs numériques très proches)
        reponses(etud,q)=1; % code 1 en cas de bonne réponse
      else
        % code >= 2 en cas de fausse réponse
        trouve = 0;
        % si cette fausse-réponse a déjà été numérotée on garde le même numéro
        for e=1:etud-1
          if (reponses(e,q)>=2)
            if strcmp(rep(etud,q),rep(e,q))
              reponses(etud,q)=reponses(e,q);
              trouve = 1;
            end
          end
        end
        % sinon on crée un nouveau numéro
        if (~trouve)
          cpt = cpt+1;
          reponses(etud,q)=cpt+1;
        end
      end
    end
  end

  % Vérifications
  [nblig, nbcol] = size(reponses);
  assert(nblig==nbetud);
  assert(nbcol==nbquestions);
  assert(length(find(reponses<0))==0);

  % détection des questions calculées
  % (pour une question calculée, il y a au moins 2 réponses exactes différentes)
  QuestionsCalculees = zeros(1,nbquestions);
  for q=1:nbquestions
    ref = repex(1,q);  % référence = réponse exacte étudiant 1
    for etud=2:nbetud
      if ~strcmp(repex(etud,q),ref)
          QuestionsCalculees(q) = 1;
          break;
      end
    end
  end

end
