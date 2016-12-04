%% config params
video_filename = 'demos/video/data/camara15-11-16';
start_time = 26;
end_time = 35;

movement_threshold = 55;

recording_label_filename = 'core/video_writer/images/rec.png';
recording_label = imread(recording_label_filename);
label_position = [40,40];

output_filename = 'demos/video/output/camara15-11-16';
output_filename = strcat(output_filename, '_', num2str(start_time), '-', num2str(end_time));
[path, ~, ~] = fileparts(output_filename);
mkdir(path);

opts.gpus = [] ;

%%  parse only a part of a video

% read video (this might take a while because Matlab sucks)
fprintf('Reading the video (this might take a while...)\n');
frames = parse_video( video_filename, start_time, end_time );

%% read a convnet

% load the pre-trained CNN
if (exist('net', 'var')==0)
    net = load_pretrained_model(fullfile(pwd, 'core', 'models', 'pascal-fcn32s-dag.mat'), opts);
end

%% get all foreground labellings

% segment out the foreground
fprintf('Getting foreground from each frame...(%d frames)\n', size(frames,4));
foregrounds_filename = strcat(video_filename,'_',num2str(start_time),'-',num2str(end_time),'_foreground.mat');
if exist(foregrounds_filename,'file') == 0
    foregrounds_batch = get_foregrounds_from_frames_sequences(frames, net, opts);
    save(foregrounds_filename, 'foregrounds_batch');
else
    load(foregrounds_filename);
end

%% preprocess frames for movement detection

fprintf('Preprocessing frames for movement detection\n');
preprocessed_frames = preprocess_frames_for_movement_detection(frames);

%% identify movement threshold

fprintf('Quantifying movement... ');

% initialize an array of movements
movements = zeros(size(frames,4), 1);
% for each of the frames
for i = 1:size(frames,4)-1
    % compute movement score between this frame and the next one
    [movements(i), ~] = measure_movement(preprocessed_frames(:,:,i:i+1), foregrounds_batch(:,:,i:i+1));
end
significant_movements = find(movements > movement_threshold);
main_change = significant_movements(1);
fprintf('main change found in frame %d', main_change);

%% print recording label in frames after movement detection

fprintf('Printing video...\n');
for i = main_change:size(frames,4)-1
    frames(:,:,:,i) = burn_image_into_frame(frames(:,:,:,i), recording_label, label_position(1), label_position(2));
end

fprintf('Saving...\n');
save_video_sequence(output_filename, frames);