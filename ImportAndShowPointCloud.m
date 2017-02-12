clc; close all; clear all;
points3D = xlsread('3DPoints_im1_to_im133_SURF200.xlsx'); % Load 3D points
color = xlsread('Color_im1_to_im133_SURF200.xlsx'); % Load Colors of 3D points
% Manual filtering of noise, this manual filteration is based on trial and
% error after generating the point cloud for different MetricThresholds,
% this filteration removes
the
% point cloud & do not add
appearance of
% the point cloud produced
a = points3D(:,1);
b = points3D(:,2);
c = points3D(:,3);
xx = size(points3D);
for i = 1:xx(1)
    the random points generated on the edges of
    density or accuracy to the shape &
    if((a(i)<-15)||(a(i)>30))
        points3D(i,:) = [0 0 0];
        color(i,:) = [0 0 0];
    elseif((b(i)<-20)||(b(i)>8))
        points3D(i,:) = [0 0 0];
        color(i,:) = [0 0 0];
    elseif((c(i)>18))
        points3D(i,:) = [0 0 0];
        color(i,:) = [0 0 0];
    end
end
points3D(end,:) = 0;
points3D(all(points3D == 0,2),:) = [];
color(all(color==0,2),:) = [];
% plot the 3D point cloud
color = uint8(255 * color); % convert the color values from 0-1 range to 0-255 range
ptcloud = pointCloud(points3D,'color',color); % Create point cloud struct
figure; grid on % create figure with grid lines showPointCloud(ptcloud); % Plot the point cloud using the point cloud struct
axis tight
xlabel('x-axis (mm)');
ylabel('y-axis (mm)');
zlabel('z-axis (mm)');
title('Reconstructed Point Cloud');