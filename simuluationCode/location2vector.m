function locVector = location2vector(coordinates,fieldSize);
%%
field = zeros(fieldSize);
field(coordinates(1),coordinates(2)) = 1;
locVector = field(:);