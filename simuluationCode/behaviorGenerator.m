function locations = behaviorGenerator2D(type, length, duration, forward_prob) 
    % MIND 2019: written by matt schafer
    % to generate locations within a maze (x,y coords)
    
    switch type 
        case 'linear' 
            location = 1;
        case 'square'
            location = [1; length/2];
    end
    
    locations = location; 
    
    if nargin == 3 
        forward_prob = .5; % pr(move forward in maze);
    end
    
    for t = 1 : duration 
        
        speed = randi(3); 
        move = 1 * speed; 
        
        if type == 'square'
           dim = randi(2);
        else
            dim = 1;
        end
        
        if rand > (1 - forward_prob)
            location(dim) = location(dim) + move;
        else
            location(dim) = location(dim) - move;
        end
        
        % respect the bounardies
        if location(dim) <= 0
            location(dim) = 0;
        end
        
        if location(dim) >= length
            location(dim) = length - move; % move backward
        end

        locations = [locations, location];
        
    end
    
    % plot
    if type == 'square'
        plot(locations(1,:), locations(2,:)); 
    else
        plot(locations(1,:));
    end
    
end