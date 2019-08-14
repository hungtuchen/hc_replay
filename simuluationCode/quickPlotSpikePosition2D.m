function quickPlotSpikePosition2D(position,spikeMatrix,cellNumber)

    figure
    hold on
    plot(position(1,:),position(2,:),'-.k')
    
    if ~isempty(cellNumber)
        spikeIndex = find(spikeMatrix(:,cellNumber));
        plot(position(1,spikeIndex),position(2,spikeIndex),'o','markerfacecolor','r')
    else
        clrs = jet(size(cellNumber,2));
        
        for CELL = 1:size(cellNumber,2)
            spikeIndex = find(spikeMatrix(:,cellNumber));
            plot(position(1,spikeIndex),position(2,spikeIndex),...
                'o','markerfacecolor',clrs(CELL,:))
        end
    end
    
    