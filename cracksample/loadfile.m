%% Open Ncorr
handles_ncorr = ncorr;

%% Set Parameters
% Load Ref
ref = imread('ref.TIF');
ref = imresize(ref,0.5,'bicubic','Antialiasing',true);

% Load Cur
cur = imread('cur.TIF');
cur = imresize(cur,0.5,'bicubic','Antialiasing',true);

% Load ROI
roi = rgb2gray(imread('roi_half.TIF'));
roi = roi > 5;

% Set Data
handles_ncorr.set_ref(ref);
handles_ncorr.set_cur(cur);
handles_ncorr.set_roi_cur(roi);