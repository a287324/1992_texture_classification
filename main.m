clearvars; clc; close all;
format compact;

% parameter
grayLevel = [4,8,16,32,80];
grayL = length(grayLevel);

% load image
im = imread('D3.gif');
if size(im, 3) == 3
	im = rgb2gray(im);
    im = double(im);
else
    im = double(im);
end
im = im(1:160, 1:160);
[im_row, im_col] = size(im);

% 依序對不同的量化階層計算
Fv = zeros(grayL, 1);    % feature vector
for n = 1:grayL
    % 整張影像灰階量化
    imReg = floor(im/(256/grayLevel(n)));
    
    % 計算切塊個數和切塊影像的長寬
    part_row = floor(im_row / grayLevel(n));
    part_col = floor(im_col / grayLevel(n));
    
    % 逐塊計算階層差
    imPart = zeros(part_row, part_col);
    for x = 1:part_row:im_row
        for y = 1:part_col:im_col
            imPart = imReg(x:(x+part_row-1), y:(y+part_col-1));
            partMax = max(imPart(:));
            partMin = min(imPart(:));
            Fv(n) = Fv(n) + (partMax - partMin + 1);
        end
    end
end
% 顯示特徵向量
Fv