
function save_video_sequence(video_filename, frames)

    % initialize a video writer object
    video_writer = VideoWriter(video_filename,'Motion JPEG AVI');
    
    % write each frame in the video object
    open(video_writer);
    for i = 1 : size(frames, 4)
        writeVideo(video_writer, frames(:,:,:,i))
    end
    close(video_writer);

end