function fields = gen2dfields(inEnv,nfields,fieldWidth)
%%
%
%
%%
switch length(inEnv)
    case 1
        disp(['++ Making square open field size: ' num2str(inEnv)])
        inEnv = ones(inEnv);

        coords = ...
            [randi(size(inEnv,1),[nfields 1]) ...
            randi(size(inEnv,2),[nfields 1])]; 

        
        fields = zeros(size(inEnv,1),size(inEnv,2),nfields);
        
        for i = 1:length(coords)
            fields(coords(i,1),coords(i,2),i) = 1;
        end
case 2
    
    coords = find(inEnv == 1);
    coords = randsample(coords,nfields);
    fields = zeros(size(inEnv,1),size(inEnv,2),nfields);
    for i = 1:length(coords)
        temp = fields(:,:,i);
        temp(coords(i)) = 1;
        fields(:,:,i) = temp;
    end
end
%%
for i = 1:nfields
    fields(:,:,i) = smoothdata(fields(:,:,i),1,'gaussian',...
        sqrt(nfields)*sqrt(length(fields))*fieldWidth(i)); % scaling by the size of the field %

    fields(:,:,i) = smoothdata(fields(:,:,i),2,'gaussian',...
        sqrt(nfields)*sqrt(length(fields))*fieldWidth(i)); % scaling by the size of the field %
    fields(:,:,i) = fields(:,:,i)./max(max(max(fields(:,:,i))));
end
    
    imagesc(sum(fields,3));
%%
