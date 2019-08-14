function genSpikeMatrix(nfields,inField)
%%
%%
% nfields = 15;
% fieldSize = 50;
if length(inField) == 1
    
end

fields = gen2dfields(fieldSize,nfields);
fieldVector = reshape(fields,[],nfields);
%%
[locations, arena] = behaviorGenerator('square',fieldSize,2500,0,0);

%%
spikeMatrix = zeros(length(locations),nfields);

for i = 1:length(locations)
    
    %if mod(i,100) == 0
        disp(['iteration: ' num2str(i)])
    %end
    
    locVector = location2vector(locations(:,i),[size(arena)]-[2 2]);
    position = find(locVector);
    spikeMatrix(i,:) = genSpikeVec(position,fieldVector,ones(size(fields)));
    
    
end
%%
quickPlotSpikePosition2D(locations,spikeMatrix,[])