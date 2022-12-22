% Détecteur de triche:
%
% Analyse des réponses et de l'horodatage d'un test en ligne en vue d'attirer l'attention de l'enseignant
% sur des tricheurs potentiels.
%
% La méthode utilisée est décrite dans l'article suivant:
% Gilles Burel, Khawla Ben Gaied, Ramla Ben Abdelkader, Roland Gautier.
% "Aide à la détection de l’échange d’information entre étudiants dans les contrôles à distance."
% à paraître en 2023 dans J3eA (Journal sur l’enseignement des sciences et technologies de l’information et des systèmes)
%
% Le programme utilise des tableaux au format csv (séparateur=";") contenant les réponses au test, l'horodatage, et l'ordre des questions.
% Un tableau de notes peut également être lu s'il est disponible, mais n'est pas exploité dans la version actuelle.
%
% Dans tous ces tableaux, chaque ligne correspond à un étudiant.
% En notant nbetud le nombre d'étudiants qui ont réalisé le test et nbquestions le nombre de questions du test
% ces tableaux sont:
%
% notes.csv = tableau de taille nbetud x nbquestions
%           contenant aux coordonnées (etud,no) la note obtenue par
%           l'étudiant etud à la question no, où no est le numéro original de la question.
% reponses.csv = tableau de taille nbetud x nbquestions contenant les
%              réponses données par les étudiants.
% minutes.csv = matrice de taille nbetud x (nbquestions+2)
%       contenant aux coordonnées (etud,ne+1) l'instant de réponse (en minutes depuis minuit)
%		de l'étudiant etud à la ne ième question qui lui a été présentée (0 lorsque l'étudiant n'a pas répondu).
%       La pemière colonne correspond à l'instant de début du test.
%       La dernière colonne correspond à l'instant de fin du test.
% numeros.csv = tableau de taille nbetud x nbquestions
%       donnant no en fonction de (etud,ne) où no est le numéro original de la question et ne le numéro de la question vu de l'étudiant
%
% Dans le répertoire PERL on trouvera quelques utilitaires écrits en PERL qui peuvent aider à générer ces tableaux
% à partir des données fournies par Moodle.
%
% Dans le répertoire courant, le fichier RepertoireDesDonnees.txt doit contenir le chemin d'accès aux données.
% Le répertoire indiqué doit contenir un sous-répertoire "tableaux" dans lequel ont été placés les fichiers csv mentionnés plus haut.
%
%
%   Gilles Burel / Lab-STICC / Université de Brest, France
%	contact: gilles (dot) burel (at) univ-brest (dot) fr
%
%   Version du 22/12/2022
%

close all
clear

% Si on soupçonne a priori des tricheurs, on peut les indiquer pour qu'ils soient retirés du calcul
%    des statistiques de questions. Exemple: tricheurs = [16 24 25];
tricheurs = [];

% Affichage (1) ou non (0) des données des suspects
AffichageDonneesSuspects = 0;

%% Choix des seuils

% Seuil sur la fluctuation des durées de réponse
seuilFD = 0.7;

% Seuil sur les sauts moyens normalisés
seuilSM = 0.6;  % seuil à 60% du parcours totalement aléatoire

% Seuil sur le retard de réponse
SeuilRetardRelatif = 0.2;  % 20% de la duree du test


% Lecture du chemin d'accès aux données
fid = fopen('RepertoireDesDonnees.txt','rt');
if fid<=0
  disp('ERREUR: impossible d''ouvrir le fichier RepertoireDesDonnees.txt');
  return;
end
repertoire = fscanf(fid,'%s');
fclose(fid);

% Lecture des données
repertoire = sprintf('%s/tableaux',repertoire);
[notes, reponses, minutes, numeros, nbetud, nbquestions, QuestionsCalculees] = LectureDonnees(repertoire);
% sauvegarde éventuelle du tableau des réponses codées (décommenter la ligne)
% dlmwrite('_reponses.csv', reponses, ';');
fprintf('nbetud = %d   nbquestions = %d\n',nbetud,nbquestions);

% Détermination du type de test
% 1 = séquentiel / 2 = navigation libre / 3 = navigation libre sans horodatage
TypeDeTest = DetermineTypeDeTest(minutes);

%% Analyse des réponses (analyse commune à tous les types de test)

dr = distance(reponses,[],'R');  % 'G' pour tester le g2index
dr = dr - diag(diag(dr));
Visu(dr, 'similarite des reponses','etudiant','etudiant');
% Sauvegarde éventuelle de la figure (décommenter la ligne)
%print('_similarite_rep.pdf', '-dpdfcrop');

VisuHisto(dr,'histogramme des similarites entre reponses');
% Sauvegarde éventuelle de la figure (décommenter la ligne)
%print('_histo_similarite_rep.pdf', '-dpdfcrop');

seuilr = 0.38;

drs = (dr>seuilr);
Visu(1-drs, 'similarite des reponses (seuillees)','etudiant','etudiant');
% Sauvegarde éventuelle de la figure (décommenter la ligne)
%print('_similarite_rep_seuillee.pdf', '-dpdfcrop');

% Détection des groupes de tricheurs
% gr est un vecteur contenant, pour chaque étudiant, un numéro de groupe de tricheurs
% (ou 0 si la fonction estime qu'il n'a pas triché)
gr = ChercheGroupes(drs);


%% Analyse de l'horodatage (dépend du type de test)

switch(TypeDeTest)

%% Analyse de l'horodatage pour un test séquentiel
case 1,

  % Interpolation de l'horodatage
  [minutes, mnfiab] = interpole(minutes);

  % Calcul des durées de réponse et de leur fiabilité
  [durees, dfiab] = dureesfiab(minutes, mnfiab);

  % durees et fiabilité rangées en fonction de l'ordre original
  % La présence d'une majuscule dans le nom de variable indique un rangement dans l'ordre original
  Durees = ordonne(durees,numeros);
  dFiab = ordonne(dfiab,numeros);

  % Calcul des valeurs médianes et moyennes des durées de réponse
  % en n'utilisant que les valeurs fiables.
  [Moy, Med, Ectyp] = statistiques(Durees,dFiab,tricheurs);
  VisuStem(Moy, 'durees moyennes de reponse','question','duree moyenne', []);
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_durees_moyennes.pdf', '-dpdfcrop');

  % Détection de suspects sur la base du retard maximal
  [RetardMax, minutes_predites] = concavite(minutes, mnfiab, numeros, Moy);
  DureeDuTest = max(minutes(:,end)-minutes(:,1))
  SeuilRetard = SeuilRetardRelatif * DureeDuTest;

  VisuStem(RetardMax,'Retard maximal','etudiant','retard max',SeuilRetard);
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_retard_maximal.pdf', '-dpdfcrop');

  VisuStem(sort(RetardMax),'Retard maximal','etudiant (range)','retard max (range)',SeuilRetard);
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_retard_maximal_range.pdf', '-dpdfcrop');

  suspects1 = find(RetardMax>=SeuilRetard);  % retard max dépassant X % de la durée du test
  disp('Tricheurs potentiels détectés sur la base du retard maximal:');
  disp(suspects1);

  % Détection de suspects sur la base des fluctuations des durées de réponse
  Dureesn = Durees./Moy(ones(1,nbetud),:); % durées normalisées
  LogDureesn = log(Dureesn);
  L2 = abs(LogDureesn).^2;
  L2fiab = ((dFiab>=2)); % on ne prend en compte que les durées fiables
  for etud=1:nbetud
    ind = find(L2fiab(etud,:));
    L(etud) = mean(L2(etud,ind));
  end

  % Histogramme des écarts logarithmiques
  ind = find(L2fiab);
  tmp = LogDureesn(ind);
  figure, hist(tmp, 20), title('histogramme des ecarts logarithmiques')
  grid on
  grid minor on
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_histo_ecarts_log.pdf', '-dpdfcrop');

  VisuStem(L, 'variances des ecarts logarithmiques', 'etudiant', 'L_e',seuilFD);
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_variances_ecarts_log.pdf', '-dpdfcrop');

  VisuStem(sort(L),'variances des ecarts logarithmiques (rangees)','etudiant (renumerote)','L_e',seuilFD);
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_variances_ecarts_log_rangees.pdf', '-dpdfcrop');

  suspects2 = find(L>=seuilFD);
  disp('Etudiants dont les fluctuations de durées de réponses dépassent le seuil:');
  disp(suspects2);

  % Liste des suspects détectés par les deux critères (retard max et fluctuation des durées)
  suspects = intersect(suspects1,suspects2);
  disp('Etudiants suspects selon les deux critères d''horodatage:');
  disp(suspects);

  % Recoupement avec l'analyse basée sur les réponses

  % Elagage: tout groupe qui ne contient pas au moins un étudiant préalablement détecté par horodatage est éliminé
  gr = elagage(gr, suspects);
  VisuStem(gr,'tricheurs potentiels (detection par horodatage en rouge)','etudiant','groupe',[]);

  % marquage en rouge des suspects qui avaient été détectés par horodatage
  AjouteSuspects(suspects,gr);
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_groupes_tricheurs.pdf', '-dpdfcrop');

  suspects(gr(suspects)==0)=[];
  disp('Etudiants suspects selon les deux critères d''horodatage et la similarité des réponses:');
  disp(suspects);

  % Affichage de données individuelles pour les étudiants suspects
  if AffichageDonneesSuspects
    for etud = suspects
      titre = sprintf('etudiant %d: horodatage effectif (bleu) et predit (rouge)',etud);
      VisuStem(minutes(etud,2:nbquestions+1)-minutes(etud,1), titre, 'question', 'horodatage', []);
      hold on;
      plot(1:nbquestions,minutes_predites(etud,:),'-.ro');
      % Sauvegarde éventuelle de la figure (décommenter la ligne)
      %print(sprintf('_horodatage_etud%d.pdf',etud), '-dpdfcrop');

      hold off
      titre = sprintf('etudiant %d: durees effectives (bleu) et predites (rouge)',etud);
      VisuStem(Durees(etud,:), titre, 'question', 'duree', []);
      hold on;
      plot(1:nbquestions,Moy,'-.ro');
      % Sauvegarde éventuelle de la figure (décommenter la ligne)
      %print(sprintf('_durees_etud%d.pdf',etud), '-dpdfcrop');

      hold off
    end
  end

%% Analyse de l'horodatage pour un test à navigation libre
case 2,

  % Détection sur la base des sauts moyens

  [sauts, sautTh] = sautsmoyens(minutes);
  fprintf('Saut moyen théorique pour un tricheur à 100%% = %0.2f questions\n',sautTh);
  sauts = sauts / sautTh;  % normalisation des sauts moyens

  suspects1 = find(sauts>seuilSM);
  disp('Etudiants suspects détectés sur la base du saut moyen:');
  disp(suspects1);

  VisuStem(sauts,'Sauts moyens normalises','etudiant','saut moyen normalise',seuilSM);
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_SautsMoyens.pdf', '-dpdfcrop');

  VisuStem(sort(sauts),'Sauts moyens normalises (ranges)','etudiant (range)','saut moyen normalise',seuilSM);
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_SautsMoyensRanges.pdf', '-dpdfcrop');

  % Détection sur la base de la distance entre horodatages
  [dh, dhs, suspects2]  = AnalyseDistancesEntreHorodatages(minutes, numeros);

  % horodatage ordonné
  Minutes = ordonne(minutes,numeros);
  MinutesFiab = (Minutes>0);

  % Recherche des groupes de tricheurs
  groupe = ChercheGroupes(dhs);
  suspects2 = find(groupe>0);

  disp('Etudiants suspects détectés sur la base de la distance entre horodatages:');
  disp(suspects2);

  VisuStem(groupe,'groupes de tricheurs potentiels (parcours suspects en rouge)','etudiant','groupe',[]);
  % marquage en rouge des parcours suspects
  AjouteSuspects(suspects1,groupe);
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_groupes_horodatage.pdf', '-dpdfcrop');

  % rangement des suspects par groupe
  suspects = [];
  for g=1:max(groupe)
    ind = find(groupe==g);
    suspects = [suspects ind];
  end

  % Analyse des similarités dans les réponses
  drSusp = dr(suspects,suspects);
  drSuspS = drs(suspects,suspects);

  Visu(drSusp, 'similarite des reponses (suspects)','etudiant','etudiant');
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_similarite_rep_suspects.pdf', '-dpdfcrop');

  Visu(drSuspS, 'similarite des reponses seuillees (suspects)','etudiant','etudiant');
  % Sauvegarde éventuelle de la figure (décommenter la ligne)
  %print('_similarite_rep_suspects_seuillee.pdf', '-dpdfcrop');

  disp('Voir aussi la figure montrant la similarité des réponses entre suspects, pour confirmation');
  disp('Sur cette figure, l''ordre des suspects est:');
  disp(suspects);

  % Affichage de données individuelles pour les étudiants suspects
  if AffichageDonneesSuspects
    for etud = suspects
      mn = minutes(etud,:);
      [~,ordre] = sort(mn);
      titre = sprintf('etudiant %d: ordre de reponse aux questions', etud);
      VisuStem(ordre,titre,'rang de reponse','question',[]);
      % Sauvegarde éventuelle de la figure (décommenter la ligne)
      %print(sprintf('_ordre_etud%d.pdf',etud), '-dpdfcrop');
    end
  end


%% Test à navigation libre sans horodatage
case 3,
  % pour ce type de test, par principe aucune analyse basée sur l'horodatage ne peut être réalisée.

otherwise,
  disp('Type de test inconnu');

end




