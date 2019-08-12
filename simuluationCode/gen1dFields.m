function fields = gen1dFields(trackLength,nfields,TYPE)
%%
% trackLength = 50;
% nfields = 10;
% type = 'random';
%%
fields = zeros(trackLength,nfields);
switch TYPE
    case 'uniform'
        
        cellCenters = floor(linspace(1,trackLength,nfields+2));
        
    for i = 2:nfields+1
        fields(cellCenters(i),i) = 1;
    end
        
        
    case 'random'
        cellCenters = randi([1 trackLength],1,nfields);
        
    for i = 1:nfields
        fields(cellCenters(i),i) = 1;
    end
end
%%
    fields = smoothdata(fields,1,'gaussian',6);
