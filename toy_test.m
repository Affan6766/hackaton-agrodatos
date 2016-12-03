
opts.gpus = [] ;

%% load and configure the FCNN

% load the pre-trained CNN
net = dagnn.DagNN.loadobj(load(fullfile(pwd, 'data', 'models', 'pascal-fcn32s-dag.mat')));

% setup the net in test mode
net.mode = 'test';
% for name = {'objective', 'accuracy'}
%   net.removeLayer(name) ;
% end

% get average image
%net.meta.normalization.averageImage = reshape(net.meta.normalization.rgbMean,1,1,3) ;

% TODO: GUATAFAC
predVar = net.getVarIndex('prediction') ;
inputVar = 'input' ;
imageNeedsToBeMultiple = true ;

% setup the gpu
if ~isempty(opts.gpus)
  gpuDevice(opts.gpus(1)) ;
  net.move('gpu') ;
end

%% load and preprocess an image

% load image
im = imread(fullfile(pwd, 'data', 'images', 'test_cow.png'));

% turn it to single, resize it and subtract the mean image
im_ = single(im);
im_ = imresize(im_, net.meta.normalization.imageSize(1:2));
im_ = bsxfun(@minus, im_, net.meta.normalization.averageImage);

% run the CNN
net.eval({'data', im_});

%% run the fcnn

% Some networks requires the image to be a multiple of 32 pixels
if imageNeedsToBeMultiple
    sz = [size(im,1), size(im,2)] ;
    sz_ = round(sz / 32)*32 ;
    im_ = imresize(im, sz_) ;
else
    im_ = im ;
end

% if there is a gpu, turn it to a gpu array
if ~isempty(opts.gpus)
    im_ = gpuArray(im_) ;
end

% eval the fcnn on the toy image
net.eval({inputVar, im_}) ;
scores_ = gather(net.vars(predVar).value) ;
[~,pred_] = max(scores_,[],3) ;

% predict the segmentation
if imageNeedsToBeMultiple
    pred = imresize(pred_, sz, 'method', 'nearest') ;
else
    pred = pred_ ;
end

%% display results

figure, imagesc(pred);
