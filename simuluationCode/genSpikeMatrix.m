function [locations, fieldVector, fields, spikeMatrix, positions] = ...
    genSpikeMatrix(nfields,firingRateVector,fieldWidthVector,arenaSize,timeSteps)
% nfields: how many place fields you want
% firingRateVector: for every place field, the firing rate - the
    % probability of firing (vector length: nfields)
% fieldWidthVector: how big do you want the field to be? (vector length: nfields)
% arenaSize: 

% example: genSpikeMatrix(nfields,nfields,firingRateVector,fieldWidthVector,arenaSize,timeSteps)
%%
% nfields = 15;
% arenaSize = 50;

fields = gen2dfields(arenaSize,nfields,fieldWidthVector);
fieldVector = reshape(fields,[],nfields); 
% to unwrap: reshape(fieldVector, [arenaSize arenaSize nfields])
%%
[locations, arena] = behaviorGenerator('square',arenaSize,timeSteps,0,0);

%%

[spikeMatrix, positions] = simulateSpikes(locations,arena,fieldVector,firingRateVector,'homeBrew');

%%
%%
quickPlotRaster(spikeMatrix)
[maxSpikes,spikiestCell] = max(sum(spikeMatrix,1));
quickPlotSpikePosition2D(locations,spikeMatrix,[spikiestCell],arenaSize)
disp([spikiestCell maxSpikes]);

packData(positions, locations, spikeMatrix, fieldVector, arenaSize);