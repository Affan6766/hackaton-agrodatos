
function pred = deep_semantic_segmentation(input_image, net, opts, filter_labels)

    % get input image size
    original_size = [size(input_image, 1), size(input_image, 2)];

    % preprocess current frame
    im_ = preprocess_image(input_image, net.meta);

    % if there is a gpu, turn it to a gpu array
    if ~isempty(opts.gpus)
        im_ = gpuArray(im_) ;
    end
    
    % eval the fcnn on im_
    net.eval({'data', im_}) ;
    % get scores in the output
    scores_ = gather(net.vars(net.meta.predVar).value) ;
    % if you want to filter labels
    if exist('important_labels', 'var')~=0
        scores_ = scores_(:,:,filter_labels);
    end
    % get max scores only on filter_labels
    [~,pred_] = max(scores_,[],3) ;
    
    % if image need to be a multiple of 32...
    if net.meta.normalization.imageNeedsToBeMultiple
        pred = imresize(pred_, original_size, 'method', 'nearest') ;
    else
        pred = pred_ ;
    end
    
end