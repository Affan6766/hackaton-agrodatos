function [ movement ] = measure_movement( frames, masks )
%MEASURE_MOVEMENT Summary of this function goes here

    mask_result = masks(:,:,1) .* masks(:,:,2);
    frames_diff = (frames(:,:,1) - frames(:,:,2)).^2;
    
    masked_diff = frames_diff .* mask_result;
    
    movement = sum(masked_diff(:));

end

