function [ output_args ] = plot_decoding( input_args )

path_decoding = fullfile(pwd, 'decoding');
mat_files = dir(fullfile(path_decoding, '*z_hat.mat'));
decoding_results = load(fullfile(path_decoding, mat_files(1).name));

% rows: theta cycles
% columns: first half (1), second half (2)

for i_half = 1:size(decoding_results.Giant_z_hat,2)
    subplot(1,2,i_half)
    hist(decoding_results.Giant_z_hat(:,i_half))
end


end

