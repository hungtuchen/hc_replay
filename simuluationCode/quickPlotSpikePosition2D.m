function quickPlotSpikePosition2D(position,spikeMatrix,cellNumber)

figure
hold on
plot(position(1,:),position(2,:),'-.k')
spikeIndex = find(spikeMatrix(:,cellNumber));
plot(spikeIndex,position(spikeIndex),'o','markerfacecolor','r')