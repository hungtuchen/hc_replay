function SWR_iv = LoadSWRs(hc_replay_path)
% Load SWRs
% Input:
% hc_replay_path -> Should be the path of our hc_replay github folder

%Output:
% iv file with SWR time events 

    current_path = pwd;
    if ispc
        filesep = '\';
    elseif ismac
        filesep = '/';
    else
        filesep = '/';
    end
    SWR_path = cat(2, hc_replay_path, filesep, 'SWRs');
    cd(SWR_path)
    SWR_iv = load('R064-2015-04-22_SWRiv.mat'); %insert the iv struct here
    cd(current_path)
end