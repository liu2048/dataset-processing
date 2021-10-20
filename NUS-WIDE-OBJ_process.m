% The one-dimensional label information 'train_label/test_label' represented by category number is extracted from NUS-WIDE-OBJ original TXT dataset
% And extract the label name 'label_name' for each category from the original file name.
% Written by Liu
% dataset url: https://lms.comp.nus.edu.sg/wp-content/uploads/2019/research/nuswide/NUS-WIDE.html
 
labelpath='ground truth\';
feapath = 'low level features\';
%% Change the file address here to the desired folder path
labelfiles = dir(strcat(labelpath,'*.txt')); trfeafiles = dir(strcat(feapath, 'Train*.txt')); tefeafiles = dir(strcat(feapath, 'Test*.txt')); 
labelLengthFiles = length(labelfiles); fealengthFiles = 5;
trfea = cell(1, 5); tefea = cell(1, 5);

%% Extract the feature of training samples and test samples
for i = 1: fealengthFiles
    trfea{1, i} = readmatrix(strcat(feapath, trfeafiles(i).name));
    tefea{1, i} = readmatrix(strcat(feapath, tefeafiles(i).name));
end

total_label = cell(labelLengthFiles,1);
TrainLabel = cell(31, 1); TestLabel = cell(31, 1);
label_name = cell(31, 1);

%% Extract the label vector represented by 0/1 for each category
nl = 1; tl = 1;
for i = 1:labelLengthFiles
    total_label{i} = readmatrix(strcat(labelpath,labelfiles(i).name));   
    if mod(i, 2)==0
        TrainLabel{nl} = total_label{i}'; str = labelfiles(i).name;
        splitstr = regexp(str, 'Train', 'split');  % Extract category names with regular expressions
        label_name{nl} = splitstr{1};
        nl = nl + 1;
    else
        TestLabel{tl} = total_label{i}';
        tl = tl + 1;
    end
end
clear tl nl i Files str splitstr

TrainLabel = cell2mat(TrainLabel); TestLabel = cell2mat(TestLabel);
[class_num, train_sample_num] = size(TrainLabel);
train_label = zeros(train_sample_num, 5); 
[~, test_sample_num] = size(TestLabel);
test_label = zeros(test_sample_num, 5);
tr_sam_cla_num = zeros(train_sample_num, 1);
te_sam_cla_num = zeros(test_sample_num, 1);

% Some samples belong to more than one class. 
% Here, all the categories of each sample are extracted according to the category order in 'Label_name' and stored in 'train_label' and 'test_label'
for n = 1: class_num
    % train samples
    tr_sample_idx = find(TrainLabel(n, :));
    tr_sam_cla_num(tr_sample_idx) = tr_sam_cla_num(tr_sample_idx) + 1;
    tr_co_idx = tr_sam_cla_num(tr_sample_idx);
    for m = 1:size(tr_sample_idx, 2)  % Correspond the number of rows to the number of columns
        train_label(tr_sample_idx(m), tr_co_idx(m)) = n;
    end
    % test samples
    te_sample_idx = find(TestLabel(n, :));
    te_sam_cla_num(te_sample_idx) = te_sam_cla_num(te_sample_idx) + 1;
    te_co_idx = te_sam_cla_num(te_sample_idx);
    for m = 1:size(te_sample_idx, 2)
        test_label(te_sample_idx(m), te_co_idx(m)) = n;
    end
end
