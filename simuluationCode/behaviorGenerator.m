%% generate locations within a maze (x,y coords)

time_range = 100; % time dimension 
x_range = 50; % spatial dimensions
y_range = 10;  % spatial dimensions
x = 1; % starting point
xs = zeros(1,time_range); % to output the x-coords
forward_prob = .9; 

% now sample within this range, for a given set of time points 
for t = 1 : time_range
    if x < x_range
        if rand > (1 - forward_prob)
            x = x + 1; %  move forward
        else
            x = x - 1; % move backward
        end
    else
        x = x - 1; % move backward
    end
    xs(t) = x + 1; % put into x-coord vector
end

%%


% put the data into the POSition structure (tsd)
pos = LoadPost([]); % this reads from a .nlv file; will output the pos tsd structure
% plot the explored locations
plot(getd(pos,'y'),getd(pos,'x'),'.','Color',[0.5 0.5 0.5],'MarkerSize',1); % note getd() gets data corresponding to a specific label (x and y here)