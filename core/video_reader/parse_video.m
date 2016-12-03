function [ frames ] = parse_video( filename, start_time, end_time )
%PARSE_VIDEO Reads a video and returns an array of frames

    % read video
    video = VideoReader(filename);
    
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

