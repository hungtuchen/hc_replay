nfields = 31;
fieldSize = 500;
%%
fields = gen2dfields(fieldSize,nfields);
fieldVector = reshape(fields,[],nfields);
%%
locations = behaviorGenerator('square',fieldSize,10000,0.5);
%%
for i = 1:length(locations)
    
    locVector = location2vector(locations(:,i),[500 500]);
    
    spikeMatrix(i,:) = genSpikeVec(locVector(i,:),fieldVector,ones(size(fields)));
    
    
end
%%