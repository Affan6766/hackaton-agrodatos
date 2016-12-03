
opts.gpus = [] ;

class_names = {...
  'background', 'aeroplane', 'bicycle', 'bird', 'boat', 'bottle', 'bus', 'car', ...
  'cat', 'chair', 'cow', 'diningtable', 'dog', 'horse', 'motorbike', ...
  'person', 'pottedplant', 'sheep', 'sofa', 'train', 'tvmonitor'} ;
class_number = 1:length(class_names);

important_labels = [1, 16];

%% load and configure the FCNN

% load the pre-trained CNN
if (exist('net', 'var')==0)
    net = load_pretrained_model(fullfile(pwd, 'core', 'models', 'pascal-fcn8s-dag.mat'), opts);
end

%% load and preprocess an image

% load image
im = imread(fullfile(pwd, 'demos', 'images', 'data', 'images', 'empy.jpg'));

% turn it to single, resize it and subtract the mean image
original_size = [size(im,1), size(im,2)] ;
im_ = preprocess_image(im, net.meta);

%% run the fcnn

% if there is a gpu, turn it to a gpu array
if ~isempty(opts.gpus)
    im_ = gpuArray(im_) ;
end

% segment only persons and background
pred = deep_semantic_segmentation(im_, net, original_size, important_labels);

%% display results

figure, imagesc(pred);
current_labels_ids = unique(pred);
current_labels = class_names(current_labels_ids);
for i = 1 : length(current_labels)
    current_labels{i} = strcat(current_labels{i}, '-', num2str(current_labels_ids(i)));
end
xlabel(current_labels);
