
opts.gpus = [] ;

%%  parse only a part of a video

% read video (this might take a while because Matlab sucks)
video_filename = '/Users/ignaciorlando/Documents/HackatonAgroDatos/demos/video/data/camara15-11-16.mov';
fprintf('Reading the video (this might take a while...)\n');
[ frames ] = parse_video( video_filename, 26, 35 );

%% read a convnet

% load the pre-trained CNN
if (exist('net', 'var')==0)
    net = load_pretrained_model(fullfile(pwd, 'core', 'models', 'pascal-fcn32s-dag.mat'), opts);
end

%% get all foreground labellings

% segment out the foreground
fprintf('Getting foreground from each frame...\n');
foregrounds_batch = get_foregrounds_from_frames_sequences(frames, net, opts);

%% generate 

% crop the foreground from video frames
cropped_frames = get_only_foreground_from_frames(frames, foregrounds_batch);

% save it as a video
new_video_filename = '/Users/ignaciorlando/Documents/HackatonAgroDatos/demos/video/data/camara15-11-16_foreground.avi';
save_video_sequence(new_video_filename, cropped_frames);