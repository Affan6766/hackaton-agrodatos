
opts.gpus = [] ;

%% setup variables
video_filename = 'demos/video/data/camara15-11-16';
begin_parse = 26;
end_parse = 35;

%% load the cnn

% load the pre-trained CNN
if (exist('net', 'var')==0)
    net = load_pretrained_model(fullfile(pwd, 'core', 'models', 'pascal-fcn32s-dag.mat'), opts);
end

%% parse video, convert it to grayscale and get foregrounds

% parse video from begin to end
fprintf('Parse video...\n');
frames = parse_video(video_filename, begin_parse, end_parse);
% convert each frame to grayscale and normalize gray intensities
fprintf('Converting each frame to grayscale and normalizing...\n');
frames_grayscale = preprocess_frames_for_movement_detection(frames);
% get foreground from each frame sequence
fprintf('Getting foregrounds from each frame...\n');
foregrounds_batch = get_foregrounds_from_frames_sequences(frames, net, opts);

%% compute movement score

% initialize an array of movements
movements = zeros(size(frames,4), 1);
% and an array of heat map frames to save a nice video
heat_maps = zeros(size(frames,1), size(frames,2), 3, size(frames,4)-1);

% for each of the frames
for i = 1:size(frames,4)-1
    % compute movement score between this frame and the next one
    [movements(i), heat_maps(:,:,:,i)] = measure_movement(frames_grayscale(:,:,i:i+1), foregrounds_batch(:,:,i:i+1));
end

%% plot
plot(movements);

%% save video

save_video_sequence(fullfile('experiments', 'data', strcat('camara15-11-16_', num2str(begin_parse), '-', num2str(end_parse), '.avi')), heat_maps);