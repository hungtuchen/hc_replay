function spikeVec = genSpikeVec(position,probabilityVector,rateVector);
%%
% 
%
if nargin < 2
    disp('++ no rate vector, rate = constant')
    rateVector = 1;
end

spikeVec = rand(size(probabilityVector));
spikeVec = spikeVec > probabilityVector*rateVector;
