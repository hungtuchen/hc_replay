function spikeVec = genSpikeVec(position,probabilityVector,rateVector);
%%
% 
%
if nargin < 2
    disp('++ no rate vector, rate = constant')
    rateVector = 1;
end
    spikeVec = rand(size(probabilityVector,2),1)';
    for i = 1:size(probabilityVector,2)
        spikeVec(i) = spikeVec(i) < probabilityVector(position,i)*rateVector(i);
    end

