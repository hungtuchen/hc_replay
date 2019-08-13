function [locations, arena] = behaviorGenerator(type, dim_length, duration, reward_num, pause_likelihood) 
    % MIND 2019: written by matt schafer
    % to generate locations within a maze (x,y coords)
    
    warning('off');
    
    % generate the arena
    [arena, location] = arenaGenerator(type, dim_length, reward_num);
    locations = location; 
    rest_times = [];
    reward_count = 0;
    freq_tbl = zeros(dim_length + 2);
    
    % generate the movement through the space
    for t = 1 : duration 
        
        % action selection     
        speed = 1; % choose a speed             
        dir = [1 -1]; 
        dir = dir(randi(2)); % choose a direction to move
        % choose a dimension to move along
        if type == 'square'
           dim = randi(2);
        else
            dim = 1;
        end
        move = dir * speed;          
        if rand < pause_likelihood % generate pauses
             move = 0;
             rest_times = [rest_times, t]; 
        end
        location(dim) = location(dim) + move;
        
        % respect the boundaries
        if location(dim) > dim_length + 1
            location(dim) = dim_length;  
        elseif location(dim) < 2
            location(dim) = 2;
        end

        % respect the obstacles
        if arena(location(2), location(1)) == 0 % rows = y, columns = x
            location(dim) = location(dim) - move; % if bump into obstacle, turn around
        end       
        
        % find rewards
        if arena(location(2), location(1)) == 2
            reward_count = reward_count + 1;
        end
        
        % where is agent?
        freq_tbl(location(1), location(2)) = freq_tbl(location(1), location(2)) + 1;
        locations = [locations, location];
        
    end
    
    % plot
    plotLocations(type, locations, dim_length, duration, freq_tbl)    
end