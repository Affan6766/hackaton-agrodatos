
% get working directory
root = pwd;

% add libraries to path
addpath(genpath(fullfile(root, 'matconvnet-fcn')));
addpath(genpath(fullfile(root, 'matconvnet')));

% configure matconvnet
vl_setupnn;

clear
clc