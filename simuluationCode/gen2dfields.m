function fields = gen2dfields(inEnv,nfields)
%%
%
%
nfields = 31;
%%
switch length(inEnv)
    case 1
        disp(['++ Making square open field size: ' num2str(inEnv)])
        inEnv = ones(inEnv);

        coords = ...
            [randi(size(inEnv,1),[nfields 1]) ...
            randi(size(inEnv,2),[nfields 1])]; 

        fields = zeros(size(inEnv));
        
        for i = 1:length(coords)
            fields(coords(i,1),coords(i,2)) = 1;
        end
case 2
    
    coords = find(inEnv == 1);
    coords = randsample(coords,nfields);
    fields = zeros(size(inEnv));
    for i = 1:length(coords)
        fields(coords(i)) = 1;
    end
end
%%

fields = imgaussfilt(fields,2*sqrt(length(inEnv))); % scaling by the size of the field %
fields = fields./max(max(fields));