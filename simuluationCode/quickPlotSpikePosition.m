function quickPlotSpikePosition(position,spikeMatrix,cellNumber)

figure
hold on
plot(position,'-.k')
spikeIndex = find(spikeMatrix(:,cellNumber));
plot(spikeIndex,position(spikeIndex),'o','markerfacecolor','r')