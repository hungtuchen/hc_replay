function spikeVec = genSpikeVec(position,probabilityVector,rateVector);
%%
% 
%
if nargin < 2
    disp('++ no rate vector, rate = constant')
    rateVector = 1;
end
if size(position,2) == 1
    spikeVec = rand(size(probabilityVector,2),1)';
    for i = 1:nfields
        spikeVec(i) = spikeVec(i) < probabilityVector(position,i)*rateVector(i);
    end
end
