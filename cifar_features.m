%% Written by Liu Mingyang
load('E:\3-Datesets\2-cifar-10-batches-mat\data_batch_1.mat')

%% get Anchors
viewNum = 3;
Anchor = cell(1,3);
for it = 1:viewNum
    [idx, C] = kmeans(X{it}, 1000);  % get Anchors
    Anchor{it} = C; clear C
end

%% ��ʾRGBͼ��
 hs = tight_subplot(8,8,[.01 .01],[.1 .01],[.01 .01]); % �ı�ͼ��֮��ļ��
for n = 1:64
%     subplot(8,8,n);
    axes(hs(n));
    in = n;
    R = reshape(data(in,1:1024),32,32); G = reshape(data(in,1025:2048),32,32); B = reshape(data(in,2049:3072),32,32);
    im = cat(3,R,G,B); im = imrotate(im, 270); imshow(im);
end

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
Gist = cell(60000,1); % ʹ��LabelMe��������ȡGist����
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
