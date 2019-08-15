function [spikeMatrix,positions] = simulateSpikes(locations,arena,fieldVector,firingRateVector,TYPE);

nfields = size(fieldVector,2);
spikeMatrix = zeros(length(locations),nfields);
positions = zeros(length(locations),1);

switch TYPE
    case 'homeBrew'
        for i = 1:length(locations)

            %if mod(i,100) == 0
                disp(['iteration: ' num2str(i)])
            %end

            locVector = location2vector(locations(:,i),[size(arena)]-[2 2]);
            position = find(locVector);
            spikeMatrix(i,:) = genSpikeVec(position,fieldVector,firingRateVector);
            positions(i) = position;
            

        end
    case 'expData' % needs to be tested with experimental data...
        for i = 1:length(locations)

            %if mod(i,100) == 0
                disp(['iteration: ' num2str(i)])
            %end
            locVector = location2vector(locations(:,i),[size(arena)]);
            position = find(locVector);
            spikeMatrix(i,:) = genSpikeVec(position,fieldVector,firingRateVector);


        end
end
