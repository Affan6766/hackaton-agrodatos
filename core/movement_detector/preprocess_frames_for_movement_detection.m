function [ frames_output ] = preprocess_frames_for_movement_detection( frames_input )
%PREPROCESS_FRAME_FOR_MOVEMENT_DETECTION Summary of this function goes here

    frames_output = zeros([size(frames_input,1), size(frames_input,2), size(frames_input,4)]);
    
    for i = 1:size(frames_input,4)
        frames_output(:,:,i) = im2double(rgb2gray(frames_input(:,:,:,i)));
    end
    
end

