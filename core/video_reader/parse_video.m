function [ frames ] = parse_video( filename, start_time, end_time )
%PARSE_VIDEO Reads a video and returns an array of frames

    % Check if the video was alread preprocessed
    % e.g.: camera15-11-16_26-35.mat
    potential_filename = strcat(filename,'_',num2str(start_time),'-',num2str(end_time),'.mat');
    if exist(potential_filename, 'file') ~= 0
        load(potential_filename);
    else
        % if the video was not preprocessed, try to find .wmv or .mov files
        formats = { 'wmv', 'mov' };
        file_loaded = false;
        
        for i = 1:length(formats)
            potential_filename = strcat(filename,formats(i));
            if exist(potential_filename, 'file')
                video = VideoReader(potential_filename);
                file_loaded = true;
            end
        end
        
        if ~file_loaded
            error('Video file could not be found.');
        end

        % initialize a 4D matrix (height, width, RGB, time)
        frames_count = ceil((end_time - start_time) * video.FrameRate);
        frames = uint8(zeros(video.Height, video.Width, 3, frames_count));

        % start in the given second
        video.CurrentTime = start_time;

        % read frames until reaching frames_count
        for frame_i = 1:frames_count
            if hasFrame(video)
                frames(:,:,:,frame_i) = uint8(readFrame(video));
            else
                break;
            end
        end
    end

end

