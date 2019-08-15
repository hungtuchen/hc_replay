function quickPlotRaster(spikeMatrix)
figure; 
hold on
for i = 1:size(spikeMatrix,2)
    temp = find(spikeMatrix(:,i));
    if ~isempty(temp)
        line([temp temp],[i-0.5 i+0.5],'Color',[0 0 0]); % note, plots all spikes in one command
        %axis([0 1000 0 5]); set(gca,'YTick',[]);
    end
end
xlim([1 length(spikeMatrix)])
set(gca,...
    'ytick',1:size(spikeMatrix,2),...
    'fontsize',12);