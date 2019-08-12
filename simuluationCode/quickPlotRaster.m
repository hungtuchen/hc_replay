function quickPlotRaster(spk_poiss_t)

 line([spk_poiss_t spk_poiss_t],[-1 -0.5],'Color',[0 0 0]); % note, plots all spikes in one command
 axis([0 1000 0 5]); set(gca,'YTick',[]);