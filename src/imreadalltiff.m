%-------------------------------------%

function [ImgSeq, nFrames] = imreadalltiff(filename, nFrames)
% IMREADALLTIFF Utility method to read all frames from a TIFF file.
 

    % read the first frame
    tf = imformats('tif');
    I = feval(tf.read, filename, 1);

    % estimate number of frames from file size
    if nargin < 2
        info = imfinfo(filename);
        nFrames = numel(info);
    end

    % preallocate output
    ImgSeq = zeros(size(I,1), size(I,2), nFrames, class(I));

    % copy in first image
    ImgSeq(:,:,1) = I;

    % wait_bar = waitbar(0,'Matlab is loading the image stack...');
    % try to read all frames
    frame = 1;
    try
    while frame < nFrames
        frame = frame + 1;
        ImgSeq(:,:,frame) = feval(tf.read, filename, frame);
        % waitbar(frame/nFrames, wait_bar);
    end
    % close(wait_bar);
    catch
        frame = frame - 1;
        disp(strcat('Frames read: ', int2str(frame)));
        % optional line to trim off any extra frames read
        % comment out if not needed
        ImgSeq = ImgSeq(:,:,1:frame);
        % close(wait_bar);
    end
    
end


%-------------------------------------%