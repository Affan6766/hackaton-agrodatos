
% get working directory
root = pwd;

% add libraries to path
addpath(genpath(fullfile(root, 'matconvnet-fcn')));
addpath(genpath(fullfile(root, 'matconvnet')));
addpath(genpath(fullfile(root, 'core')));
addpath(genpath(fullfile(root, 'demos')));
addpath(genpath(fullfile(root, 'lib')));
addpath(genpath(fullfile(root, 'experiments')));

% compile matconvnet if necessary
if numel(dir(fullfile(root, 'matconvnet', 'matlab', 'mex', 'vl_nnconv.mex*'))) == 0
    % compile MEX files
    vl_compilenn;
end
% setup matconvnet
vl_setupnn;

clear
clc