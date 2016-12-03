video_filename = 'demos/video/data/camara15-11-16.wmv';
begin_parse = 26;
end_parse = 35;

frames = parse_video(video_filename, begin_parse, end_parse);

frames_grayscale = preprocess_frames_for_movement_detection(frames);

foregrounds = get_foregrounds_from_frames_sequences(frames);

movements = size(frames,4);

for i = 1:size(frames,4)-1
    movements(i) = measure_movement(frames_grayscale(:,:,i:i+1), foregrounds(:,:,i:i+1));
end

plot(movements);