
function net = load_pretrained_model(path)

    % load the net
    net = dagnn.DagNN.loadobj(load(path));
    
    % setup the net in test mode
    net.mode = 'test';

end