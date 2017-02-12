x = dir('*.txt'); % load the text files information from the directory Projection_Matrices = zeros(3,4,length(x)); % Projection matrices variable (3x4x247)
for i = 1:length(x) % go over the text files
    Projection_Matrices = csvread(x(i).name); % read each txt file as csv file into the Projection_Matrices Variable
end
save('Projection Matrices','Projection_Matrices'); % Save the the Projection_Matrices variable as (Projection Matrices.mat)