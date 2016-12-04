
opts.gpus = [] ;
start_time = 38;
end_time = 45;
video_filename = 'demos/video/data/camara15-11-16';
output_filename = 'demos/video/data/camara15-11-16_foreground.avi';

%%  parse only a part of a video

% read video (this might take a while because Matlab sucks)
video_filename = 'demos/video/data/camara15-11-16';
fprintf('Reading the video (this might take a while...)\n');
[ frames ] = parse_video( video_filename, start_time, end_time );

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

%% generate 

% crop the foreground from video frames
cropped_frames = get_only_foreground_from_frames(frames, foregrounds_batch);

% save it as a video
output_filename = strcat(output_filename,'_',num2str(start_time),'-',num2str(end_time),'_foreground');
save_video_sequence(output_filename, cropped_frames);