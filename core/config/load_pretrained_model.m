
function net = load_pretrained_model(path, opts)

    % load the net
    net = dagnn.DagNN.loadobj(load(path));
    
    % setup the net in test mode
    net.mode = 'test';
    
    % if there is an opts variable
    if (exist('opts', 'var')==1)
        if ~isempty(opts.gpus)
          gpuDevice(opts.gpus(1)) ;
          net.move('gpu') ;
        end
    end
    
    % get current model filename
    [~, filename, ~] = fileparts(path);
    % if it is a pascal-fcn...
    if regexpi(filename,'pascal-fcn*')~=0
        % image size has to be multiple of 32
        net.meta.normalization.imageNeedsToBeMultiple = true;
        % output layer is upscore 
        net.meta.predVar = net.getVarIndex('upscore') ;
        % input var is data
        net.meta.inputVar = 'data' ;
    else
        net.meta.normalization.imageNeedsToBeMultiple = false;
    end
    
    
end