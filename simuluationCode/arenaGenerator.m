function [arena, location] = arenaGenerator(type, dim_length, reward_num)
   
    % generate the arena & starting location
    explorable = [0 ones(1,dim_length) 0]; 
    unexplorable = zeros(1,dim_length+2);
    
    % for obstacle creation
    rand_num = randi(dim_length);
    rand_num2 = randi(dim_length);
    
    switch type 
        case 'linear' 
            location = [2, 2];
            
            % create an arena
            arena = [unexplorable; explorable; unexplorable];
     
        case 'square'
            location = [randi(dim_length); randi(dim_length)]; %random starting location
            
            % create an arena
            arena = zeros(1,dim_length+2);
            for i = 1:dim_length
                arena = [arena; explorable];
            end
            arena = [arena; unexplorable];
            
            % create obstacles in arena
            for o = 1:randi(2)
                arena((rand_num + 1 - randi(rand_num)):rand_num, (rand_num2 + 1 - randi(rand_num2)):rand_num2) = zeros;
            end 
            
            % create rewards in the environment - dont overlap w 0s
            for r=1:reward_num
                arena(randi([2, dim_length]), randi([2,dim_length])) = 2;
            end
    end
end
