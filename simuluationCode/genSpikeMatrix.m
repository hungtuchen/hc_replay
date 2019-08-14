function [locations, fieldVector, fields, spikeMatrix] = ...
    genSpikeMatrix(nfields,firingRateVector,fieldWidthVector,arenaSize,timeSteps)
%%
%%
% nfields = 15;
% arenaSize = 50;

fields = gen2dfields(arenaSize,nfields,fieldWidthVector);
fieldVector = reshape(fields,[],nfields);
%%
[locations, arena] = behaviorGenerator('square',arenaSize,timeSteps,0,0);

%%

spikeMatrix = simulateSpikes(locations,arena,fieldVector,firingRateVector,'homeBrew');

%%
%%
quickPlotRaster(spikeMatrix)
quickPlotSpikePosition2D(locations,spikeMatrix,[])