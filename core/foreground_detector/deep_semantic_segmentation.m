
function pred = deep_semantic_segmentation(im_, net, original_size, filter_labels)

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