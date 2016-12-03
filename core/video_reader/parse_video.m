function [ frames ] = parse_video( filename, start_time, end_time )
%PARSE_VIDEO Reads a video and returns an array of frames

    video = VideoReader(filename);
    
    frames_count = ceil((end_time - start_time) * video.FrameRate);
    frames = uint8(zeros(video.Height, video.Width, 3, frames_count));
    
    video.CurrentTime = start_time;
    
    for frame_i = 1:frames_count
        if hasFrame(video)
            frames(:,:,:,frame_i) = uint8(readFrame(video));
        else
            break;
        end
    end

end

