
opts.gpus = [] ;

class_names = {...
  'background', 'aeroplane', 'bicycle', 'bird', 'boat', 'bottle', 'bus', 'car', ...
  'cat', 'chair', 'cow', 'diningtable', 'dog', 'horse', 'motorbike', ...
  'person', 'pottedplant', 'sheep', 'sofa', 'train', 'tvmonitor'} ;
class_number = 1:length(class_names);

%% load and configure the FCNN

% load the pre-trained CNN
if (exist('net', 'var')==0)
    net = dagnn.DagNN.loadobj(load(fullfile(pwd, 'data', 'models', 'pascal-fcn32s-dag.mat')));
end

% setup the net in test mode
net.mode = 'test';
% for name = {'objective', 'accuracy'}
%   net.removeLayer(name) ;
% end

% get average image
%net.meta.normalization.averageImage = reshape(net.meta.normalization.rgbMean,1,1,3) ;

% TODO: GUATAFAC
predVar = net.getVarIndex('upscore') ;
%inputVar = 'input' ;
inputVar = 'data' ;
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

%% run the fcnn

% Some networks requires the image to be a multiple of 32 pixels
if imageNeedsToBeMultiple
    sz = [size(im_,1), size(im_,2)] ;
    sz_ = round(sz / 32)*32 ;
    im_ = imresize(im_, sz_) ;
else
    im_ = im_ ;
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
current_labels_ids = unique(pred);
current_labels = class_names(current_labels_ids);
for i = 1 : length(current_labels)
    current_labels{i} = strcat(current_labels{i}, '-', num2str(current_labels_ids(i)));
end
xlabel(current_labels);
