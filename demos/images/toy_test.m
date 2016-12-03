
opts.gpus = [] ;

class_names = {...
  'background', 'aeroplane', 'bicycle', 'bird', 'boat', 'bottle', 'bus', 'car', ...
  'cat', 'chair', 'cow', 'diningtable', 'dog', 'horse', 'motorbike', ...
  'person', 'pottedplant', 'sheep', 'sofa', 'train', 'tvmonitor'} ;
class_number = 1:length(class_names);

%% load and configure the FCNN

% load the pre-trained CNN
if (exist('net', 'var')==0)
    net = load_pretrained_model(fullfile(pwd, 'core', 'models', 'pascal-fcn32s-dag.mat'), opts);
end

%% load and preprocess an image

% load image
im = imread(fullfile(pwd, 'demos', 'images', 'data', 'images', 'cubierta1.png'));

% turn it to single, resize it and subtract the mean image
original_size = [size(im,1), size(im,2)] ;
im_ = preprocess_image(im, net.meta);

%% run the fcnn

% if there is a gpu, turn it to a gpu array
if ~isempty(opts.gpus)
    im_ = gpuArray(im_) ;
end

% run semantic segmentation
pred = deep_semantic_segmentation(im_, net, original_size);

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
title(current_labels);
