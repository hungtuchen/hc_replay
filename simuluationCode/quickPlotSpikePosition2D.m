function quickPlotSpikePosition2D(position,spikeMatrix,cellNumber,arenaSize)

    figure
    hold on
    plot(position(1,:),position(2,:),'-.k')
    
    if ~isempty(cellNumber)
        spikeIndex = find(spikeMatrix(:,cellNumber));
        plot(position(2,spikeIndex),position(1,spikeIndex),'o','markerfacecolor','r')
    else
        clrs = jet(size(cellNumber,2));
        
        for CELL = 1:size(cellNumber,2)
            spikeIndex = find(spikeMatrix(:,cellNumber));
            plot(position(2,spikeIndex),position(1,spikeIndex),...
                'o','markerfacecolor',clrs(CELL,:))
        end
    end
    
    xlim([0 arenaSize]); ylim([0 arenaSize]);
    set(gca,'ydir','reverse')
    