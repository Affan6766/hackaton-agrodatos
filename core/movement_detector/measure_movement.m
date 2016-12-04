function [ movement, heat_map ] = measure_movement( frames, masks )
%MEASURE_MOVEMENT Summary of this function goes here

%     % get the intersection between the two masks
%     mask_result = masks(:,:,1) .* masks(:,:,2);
%     % get the difference between frames
%     frames_diff = (frames(:,:,1) - frames(:,:,2)).^2;
%     
%     % isolate the foreground area
%     frames_diff = frames_diff .* mask_result;
% 
%     % normalize frames diff between 0 and 1
%     normalized_frames_diff = frames_diff / max(frames_diff(:));
%     % Now make an RGB image that matches display from IMAGESC:
%     C = jet(64); 
%     L = size(C,1);
%     % Scale the matrix to the range of the map.
%     Gs = round(interp1(linspace(min(normalized_frames_diff(:)),max(normalized_frames_diff(:)),L),1:L,normalized_frames_diff));
%     heat_map = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.
%     
%     % sum up the movement
%     %movement = sum(frames_diff(:));
%     %movement = entropy(frames_diff);
%     movement = sum(sum(frames_diff>0.01)) / sum(sum(mask_result));

    % get the intersection between the two masks
    mask_result = masks(:,:,1) .* masks(:,:,2);
    frames(:,:,1) = frames(:,:,1) .* mask_result;
    frames(:,:,2) = frames(:,:,2) .* mask_result;
    % get the difference between frames
    pi = imhist(frames(:,:,1), 256);
    pi_next = imhist(frames(:,:,2), 256);
    
    re = sum(pi .* log(pi ./ pi_next));
    movement = sqrt(re);

    % get the difference between frames
    frames_diff = (frames(:,:,1) - frames(:,:,2)).^2;
    
    % isolate the foreground area
    frames_diff = frames_diff .* mask_result;

    % normalize frames diff between 0 and 1
    normalized_frames_diff = frames_diff / max(frames_diff(:));
    % Now make an RGB image that matches display from IMAGESC:
    C = jet(64); 
    L = size(C,1);
    % Scale the matrix to the range of the map.
    Gs = round(interp1(linspace(min(normalized_frames_diff(:)),max(normalized_frames_diff(:)),L),1:L,normalized_frames_diff));
    heat_map = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.
    

end

