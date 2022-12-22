% Visu(A, titre, xlegende, ylegende);
%
% Affichage de la matrice A sous forme d'image
%
% Entrées:
%   A = matrice à afficher
%   titre = titre de la figure
%   xlegende = label à indiquer sur l'axe horizontal
%   ylegende = latel à indiquer sur l'axe vertical
%
%   Gilles Burel / Lab-STICC / Université de Brest, France
%



function Visu(A, titre, xlegende, ylegende)

  figure, imagesc(A)
  colormap(gray)
  colorbar

  if ~isempty(titre)
    title(titre, 'fontsize', 12)
  end

  if ~isempty(xlegende)
      xlabel(xlegende, 'fontsize', 12);
    end

  if ~isempty(ylegende)
    ylabel(ylegende, 'fontsize', 12);
  end

end


