function [ output_frame ] = burn_image_into_frame( frame, image_, left, top )
%BURN_IMAGE_INTO_FRAME Copies the contents of image_ into frame

    output_frame = frame;
    
    output_frame(top:top+size(image_,1)-1,left:left+size(image_,2)-1,:) = image_;

end

