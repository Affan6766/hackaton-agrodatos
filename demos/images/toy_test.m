
opts.gpus = [] ;

class_names = {...
  'background', 'aeroplane', 'bicycle', 'bird', 'boat', 'bottle', 'bus', 'car', ...
  'cat', 'chair', 'cow', 'diningtable', 'dog', 'horse', 'motorbike', ...
  'person', 'pottedplant', 'sheep', 'sofa', 'train', 'tvmonitor'} ;
class_number = 1:length(class_names);

%% load and configure the FCNN

% load the pre-trained CNN
if (exist('net', 'var')==0)
    net = load_pretrained_model(fullfile(pwd, 'core', 'models', 'pascal-fcn32s-dag.mat'));
end

% TODO: GUATAFAC
predVar = net.getVarIndex('upscore') ;
inputVar = 'data' ;
imageNeedsToBeMultiple = true ;

% setup the gpu
if ~isempty(opts.gpus)
  gpuDevice(opts.gpus(1)) ;
  net.move('gpu') ;
end

%% load and preprocess an image

% load image
im = imread(fullfile(pwd, 'demos', 'images', 'data', 'images', 'cubierta1.png'));

% turn it to single, resize it and subtract the mean image
original_size = [size(im,1), size(im,2)] ;
im_ = preprocess_image(im, net.meta, imageNeedsToBeMultiple);

%% run the fcnn

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
    pred = imresize(pred_, original_size, 'method', 'nearest') ;
else
    pred = pred_ ;
end

%% display results

figure
subplot(1,2,1); imshow(uint8(im));
subplot(1,2,2); imshow(pred,[]);
axis equal;
current_labels_ids = unique(pred);
current_labels = class_names(current_labels_ids);
for i = 1 : length(current_labels)
    current_labels{i} = strcat(current_labels{i}, '-', num2str(current_labels_ids(i)));
end
xlabel(current_labels);
