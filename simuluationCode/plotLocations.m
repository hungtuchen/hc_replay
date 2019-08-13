function plotLocations(type, locations, dim_length, duration, freq_tbl)

if type == 'square'
        plot(locations(1, :), locations(2, :)); 
        xlim([1 dim_length]);
        ylim([1 dim_length]);
        heatmap(freq_tbl);
    else
        plot(locations(1,:), locations(2, :));
        xlim([1 duration]);
        ylim([1 dim_length]);
        heatmap(freq_tbl);
    end
end