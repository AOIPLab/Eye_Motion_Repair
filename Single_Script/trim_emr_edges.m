function [out_path] = trim_emr_edges(in_path, img_fnames)
%trim_emr_edges Crops out the warped edges on the left and right sides of
%emr'd images and returns a single layer tif which should be compatible
%with the automontagers

%% Create yet another folder
out_path = fullfile(in_path, 'trim');
if exist(out_path, 'dir') == 0
    mkdir(out_path)
end

%% Get image(s)
if exist('img_fnames', 'var') == 0
    tif_dir = dir(fullfile(in_path, '*.tif'));
else
    tif_dir(numel(img_fnames)).name = '';
    for ii=1:numel(img_fnames)
        tif_dir(ii).name = img_fnames{ii};
    end
end

%% Determine cropping window, 
for ii=1:numel(tif_dir)
    img = imread(fullfile(in_path, tif_dir(ii).name));
    alpha_layer = boolean(img(:,:,2)./255);
    
    % I think it's safe to only do horizontal cropping
    % If there are a lot of 0's on the top or bottom rows, this gets much 
    % more complicated
    crop_done = false;
    lb = 1;
    rb = size(img, 2);
    while ~crop_done
        if ~all(alpha_layer(:, lb))
            lb = lb+1;
        end
        if ~all(alpha_layer(:, rb))
            rb = rb - 1;
        end
        
        % Check to see if you're dumb
        if lb > size(img, 2) / 2 || rb < size(img, 2) / 2
            error('Revise cropping method');
        end
        
        % Success
        if all(alpha_layer(:, lb)) && all(alpha_layer(:, rb))
            out_img = img(:, lb:rb, 1);
            crop_done = true;
        end
    end
    
    %% Write output
    out_fname = strrep(tif_dir(ii).name, '.tif', '_trim.tif');
    imwrite(out_img, fullfile(out_path, out_fname), 'compression', 'none');
end

end

