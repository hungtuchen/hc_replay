for i = 1:length(position)

    spikeMatrix(i,:) = genSpikeVec(position(i),fields,ones(size(fields,2),1));
    
end
%%