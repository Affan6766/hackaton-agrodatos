
function foreground = foreground_detection(current_frame, net, opts)

    % do semantic segmentation on current image
    pred = deep_semantic_segmentation(current_frame, net, opts);
    
    % background will be class 1
    foreground = pred > 1;

end