
function foregrounds_batch = get_foregrounds_from_frames_sequences(frames, net, opts)

    % initialize a 3D matrix of foregrounds from frames
    foregrounds_batch = zeros(size(frames, 1), size(frames, 2), size(frames, 4));
    % for each of the frames
    for i = 1 : size(frames, 4)
        % get the foreground
        foregrounds_batch(:,:,i) = foreground_detection(frames(:,:,:,i), net, opts);
        fprintf('.');
    end
    fprintf('\n');

end