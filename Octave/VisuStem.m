% VisuStem(A, titre, xlegende, ylegende,seuil);
%
% Affichage des valeurs contenues dans le vecteur A
% avec possibilité de faire apparaître une ligne horizontale correspondant à un seuil.
%
% Entrées:
%   A = vecteur à afficher
%   titre = titre de la figure
%   xlegende = label à indiquer sur l'axe horizontal
%   ylegende = latel à indiquer sur l'axe vertical
%   seuil = valeur du seuil à afficher
%
% Remarque: pour les variables d'entrée (sauf A) que l'on ne souhaite pas
%           voir apparaître, fournir des matrices vides [].
%
%   Gilles Burel / Lab-STICC / Université de Brest, France
%



function VisuStem(A, titre, xlegende, ylegende,seuil)

  figure
  % defaut: linewidth=0.5 markersize=6
  stem(A, 'linewidth', 1, 'markersize', 6);
  grid on;
  grid minor on;
  if ~isempty(seuil)
    hold on
    plot([0 length(A)],[seuil seuil],'-.r');
    hold off
  end
  if ~isempty(titre)
    title(titre, 'fontsize', 12);
  end
  if ~isempty(xlegende)
    xlabel(xlegende, 'fontsize', 12);
  end
  if ~isempty(ylegende)
    ylabel(ylegende, 'fontsize', 12);
  end

end


