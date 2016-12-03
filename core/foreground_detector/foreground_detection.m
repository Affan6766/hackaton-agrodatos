
function foreground = foreground_detection(current_frame, net)

    % preprocess current frame
    im_ = preprocess_image(current_frame, net.meta);

    % do semantic segmentation on current image
    pred = deep_semantic_segmentation(im_, net, [size(current_frame, 1), size(current_frame, 2)]);
    
    % background will be class 1
    foreground = pred > 1;

end