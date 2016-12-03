
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

%% run the fcnn

% run semantic segmentation
foreground = foreground_detection(im, net, opts);

%% display results

image_to_show = im;
for i = 1 : size(im, 3)
    image_to_show(:,:,i) = double(foreground) .* double(im(:,:,i));
end
image_to_show = uint8(image_to_show);
figure, imshow(image_to_show);
