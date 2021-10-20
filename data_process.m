% 从NUS-WIDE-OBJ原始txt数据集中提取出用类别序号表示的一维标签信息train_label/test_label
% 并从原始文件名称中提取出每一类的标签名称label_name
% Written by Liu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

labelpath='E:\3-Datesets\4-NUS-WIDE-OBJECT\ground truth\';
feapath = 'E:\3-Datesets\4-NUS-WIDE-OBJECT\low level features\';
%此处文件地址改为需要的文件夹路径
labelfiles = dir(strcat(labelpath,'*.txt')); trfeafiles = dir(strcat(feapath, 'Train*.txt')); tefeafiles = dir(strcat(feapath, 'Test*.txt')); 
labelLengthFiles = length(labelfiles); fealengthFiles = 5;
trfea = cell(1, 5); tefea = cell(1, 5);
%提取训练样本和测试样本的特征
for i = 1: fealengthFiles
    trfea{1, i} = readmatrix(strcat(feapath, trfeafiles(i).name));
    tefea{1, i} = readmatrix(strcat(feapath, tefeafiles(i).name));
end

total_label = cell(labelLengthFiles,1);
TrainLabel = cell(31, 1); TestLabel = cell(31, 1);
label_name = cell(31, 1);

%提取出每一类的0/1表示的标签向量
nl = 1; tl = 1;
for i = 1:labelLengthFiles
    total_label{i} = readmatrix(strcat(labelpath,labelfiles(i).name));   
    if mod(i, 2)==0
        TrainLabel{nl} = total_label{i}'; str = labelfiles(i).name;
        splitstr = regexp(str, 'Train', 'split');  % 用正则表达提取类别名称
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

% 有些样本属于多个类，这里按照label_name中的类别顺序提取出每个样本所属的所有类别，存储于train_label和test_label中
for n = 1: class_num
    % train samples
    tr_sample_idx = find(TrainLabel(n, :));
    tr_sam_cla_num(tr_sample_idx) = tr_sam_cla_num(tr_sample_idx) + 1;
    tr_co_idx = tr_sam_cla_num(tr_sample_idx);
    for m = 1:size(tr_sample_idx, 2)  % 将行数和列数的位置对应
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




