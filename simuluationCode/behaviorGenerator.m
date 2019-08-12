function xy_coords = behaviorGenerator(x_range, duration, forward_prob) 
    % MIND 2019: written by matt schafer
    % to generate locations within a maze (x,y coords)
    
    x = 1; %y = round(y_range/2); % starting point
    xy_coords = zeros(1,duration); % to output the location coords    
    if nargin == 2 
        forward_prob = .8; % pr(move forward in maze)
    end
    
    for t = 1 : duration
        
        speed = randi(5); % want to make into a distribution
                     
        if rand > (1 - forward_prob)
            x = x + 1 * speed; % move forward
        else
            x = x - 1 * speed; % move backward
        end            
   
        if x <= 1
            x = 1;
        end
        
        if x >= x_range
            x = x_range;
            x = x - 1 * speed; % move backward
        end
        
        xy_coords(1,t) = x; % log coordinates
        
    end
    
    plot(xy_coords(1,:)); % plot
    
end