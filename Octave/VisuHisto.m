% VisuHisto(donnees, titre);
%
% Affichage de l'histogramme de la partie triangulaire supérieure (hors diagonale)
% de la matrice donnees (on fait donc l'hypothèse que la matrice est symétrique)
%
% titre est le titre à indiquer sur la figure
%
%
%   Gilles Burel / Lab-STICC / Université de Brest, France
%


function VisuHisto(donnees, titre)

  if (size(donnees,2)>1)
    tmp = triu(donnees,1,'pack');
    sim = sort(tmp(:),'descend');
    figure, hist(sim,25), title(titre)
    grid on
    grid minor on
  end


end
