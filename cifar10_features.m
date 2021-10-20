%% Written by Liu Mingyang
%% cifar10 dataset url: https://www.cs.toronto.edu/~kriz/cifar.html 

load('data_batch_1.mat') % after downloading 'CIFAR-10 Matlab version', load raw data from the local

%% extract features CH(color Histogram)\Gist\HOG(histogram of oriented gradients)\LBP(local binary pattern)\SURF
CH = cell(60000,1);
for n = 1:60000
     im = data(n,:); nbins = 65;
     h = histogram(im, nbins);
     CHfeature = h.Values;
     CH{n} = CHfeature; 
end
CH = cell2mat(CH);

param.imageSize = [32 32];
param.orientationsPerScale = [8 8 8 8]; % number of orientations per scale (from HF to LF)
param.numberBlocks = 4;
param.fc_prefilt = 4;
Gist = cell(60000,1); % 使用LabelMe工具箱提取Gist特征
for n = 1:60000
    R = reshape(data(n,1:1024),32,32); G = reshape(data(n,1025:2048),32,32); B = reshape(data(n,2049:3072),32,32);
    im = cat(3,R,G,B); im = imrotate(im, 270); 
    [Gistfeature, ~] = LMgist(im, '', param);
    Gist{n} = Gistfeature;
end
Gist = cell2mat(Gist); Gist = double(Gist);

HOG = cell(60000,1);
for n = 1:60000
    R = reshape(data(n,1:1024),32,32); G = reshape(data(n,1025:2048),32,32); B = reshape(data(n,2049:3072),32,32);
    im = cat(3,R,G,B); im = imrotate(im, 270);
    [HOGfeature,~] = extractHOGFeatures(im);
    HOG{n} = HOGfeature; 
end 
HOG = cell2mat(HOG); HOG = double(HOG);

LBP = cell(60000,1);  % Normalize each LBP cell histogram using L1 norm. numNeighbors = 8;
for n = 1:60000
    R = reshape(data(n,1:1024),32,32); G = reshape(data(n,1025:2048),32,32); B = reshape(data(n,2049:3072),32,32);
    im = cat(3,R,G,B); im = imrotate(im, 270); im = rgb2gray(im);
    lbpFeatures = extractLBPFeatures(im,'CellSize',[32 32],'Normalization','None');
    numNeighbors = 8;
    numBins = numNeighbors*(numNeighbors-1)+3;
    lbpCellHists = reshape(lbpFeatures,numBins,[]); lbpCellHists = bsxfun(@rdivide,lbpCellHists,sum(lbpCellHists));
    lbpFeatures = reshape(lbpCellHists,1,[]);
    LBP{n} = lbpFeatures;
end  
LBP = cell2mat(LBP); LBP = double(LBP);

save('Cifar10-features','CH', 'Gist', 'HOG', 'LBP')
