% 3D reconstruction for all 247 images SURF Threshold 200
clc; close all; clear all;
tic % Start timer
im_dir = dir('*.jpg'); % Read all the images
P = load('Projection Matrices.mat'); % Read Projection Matrices % Initialize Point cloud variables
points3D = []; % 3D points
color = []; % 3D points colors
num_Im_dir = length(im_dir); % Number of Images
for i = 1:num_Im_dir-1 % go over the images
    disp(i); % Display the index of the current image
    im1 = imread(im_dir(i).name); % Read the Current image
    im2 = imread(im_dir(i+1).name); % Read the next image
    im1_gray = im2double(rgb2gray(im1)); % Create a gray scale version
    of the Current image
    im2_gray = im2double(rgb2gray(im2)); % Create a gray scale version
    of the next image
    % Extract Feature points for the current & the next image based on the
    % MetricThreshold or the Strongest Feature Threshold for the SURF % algorithm where the density of the point cloud increases as the % MetricThreshold decreases from 1000 to 0
    im1_points = detectSURFFeatures(im1_gray, 'MetricThreshold', 400); im2_points = detectSURFFeatures(im2_gray, 'MetricThreshold', 400);
    % Extract Feature descriptors from the feature points
    im1_features = extractFeatures(im1_gray,im1_points); im2_features = extractFeatures(im2_gray,im2_points);
    
    
    
    
    % Match Features descriptors between the current image & the next image based on the
    % MaxRatio threshold where more points are matched togeather as this
    % ratio increases from 0 to 1
    indexPairs = matchFeatures(im1_features,im2_features, 'MaxRatio', 1);
    im1_matchedpoints = im1_points(indexPairs(:,1)); im2_matchedpoints = im2_points(indexPairs(:,2));
    % Estimate 3D Points Corresponding to matched Points between the
    % current image & the next image & calculate the reprojection errors
    % using the Feature descriptors & the projection matrices for the % current image & the next image
    [curr_points3D, reprojErrors] =
    triangulate(im1_matchedpoints,im2_matchedpoints, ... P.Proj_Matrices(:,:,i)',P.Proj_Matrices(:,:,i+1)');
        % Eliminate noisy points based on reprojection errors
    errorDists = max(sqrt(sum(reprojErrors .^ 2, 2)), [], 3); validIdx = errorDists < 1;
    curr_points3D = curr_points3D(validIdx, :); im1_matchedpoints = im1_matchedpoints(validIdx, :); im2_matchedpoints = im2_matchedpoints(validIdx, :);
    % Get the color of each reconstructed point using by trakcing down the locations of the
    % matched points in the RGB current image & next image
    im1_matchedpoints = round(im1_matchedpoints.Location); numPixels = size(im1,1) * size(im1,2);
    allColors = reshape(im2double(im1), [numPixels, 3]); colorIdx = sub2ind([size(im1,1), size(im1, 2)],
    im1_matchedpoints(:,2), ...
        im1_matchedpoints(:, 1));
    curr_color = allColors(colorIdx, :);
    % Concatinate current 3D points & their colors with the previous 3D % points & the current colors with the previous colors
    points3D = [points3D;curr_points3D];
    color = [color;curr_color];
end
toc % End timer
% Once the program finishes for the Current MetricThreshold used, copy the
% contents of the color variable & the points3D variable into 2 seperate
% excel files