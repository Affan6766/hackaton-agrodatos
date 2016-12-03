
function frames = get_only_foreground_from_frames(frames, foregrounds)

    % all to double
    frames = double(frames);
    foregrounds = double(foregrounds);
    
    % for each frame
    for i = 1 : size(frames, 4)
        % multiply the RGB frame by the foreground
        frames(:,:,:,i) = frames(:,:,:,i) .* cat(3,foregrounds(:,:,i),foregrounds(:,:,i),foregrounds(:,:,i));
    end

    % get back to uint8
    frames = uint8(frames);
    
end