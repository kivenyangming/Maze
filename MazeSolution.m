close all; clear;
%% 输入起始和终止点坐标
StartPoint = [1, 497]; %起始点 入口
EndPoint   = [533,523];%终止点 出口
%% main

%显示原图像
I = imread('maze.png'); %读取图片数据
figure;%创建一个窗口
imshow(I) %显示灰度图像
title('Maze problem');
hold on;
plot(StartPoint(1), StartPoint(2), 'r.');%用红色的点代表起始点
plot(EndPoint(1), EndPoint(2), 'b.');%用黑色的点代表终止点
legend('Start point', 'End Point');%命名图片1

walls = imdilate(I<128,ones(9));%I<128会使I中小于128的值变为1，大于128的值变为0，即生成黑色为1白色为0（黑白对调）的二值图。然后以每个点为中心生成9成9矩阵，将该点的值等同于矩阵内最大点的值，这样就可以使处理之后的黑色路径部分被压缩，从而使路径计算变得简单
figure;
imshow(walls) %显示出来一个二值图像，黑色部分为路径 
title('Thickened walls')%命名图片2

[M, N] = size(I);
%%
% sub2ind:将下标转换为线性索引
% 针对大小为 [M N]的矩阵返回由 StartPoint(2) 和 StartPoint(1) 指定的行列下标的对应线性索引 ind。
% 此处，[M N] 是包含两个元素的向量，其中 [M N](1) 指定行数，[M N](2) 指定列数。

StartNode = sub2ind([M N], StartPoint(2), StartPoint(1)); %在[M,N]中找到对应起始点的索引号
EndNode   = sub2ind([M N], EndPoint(2),   EndPoint(1)); %在[M,N]中找到对应终止点的索引号

CMatrix = double(walls)*M*N+1;
% CMatrix的结果为533*533的double型矩阵
%% 计算距离矩阵
D = im2graph(CMatrix);%D存储距离矩阵
%% 寻找最短路径 :确定从源节点S到图中所有其他节点的最短路径G。dist包含从源节点到所有其他节点的距离。path包含到每个节点的最短路径。pred包含最短路径的前驱节点。
[dist, path, pred] = graphshortestpath(D, StartNode, EndNode);
%默认使用迪杰斯特拉算法，dist为最小路径长度，path为经过的点，pred包含从节点1（源节点）到所有其他节点（而不仅仅是指定的目标节点）的最短路径的前置节点，D是距离矩阵，StartNode表示起点,EndNode表示终点
% ind2sub:将线性索引转换为下标
% ind2sub([M N], path) 返回数组 x 和 y，其中包含与大小为 [M N] 的矩阵的线性索引path对应的等效行和列下标。此处，[M N]是包含两个元素的向量，其中 M 指定行数，N指定列数。
[y, x] = ind2sub([M N], path);%对[M N]矩阵索引出path的值，并记录在[y,x]矩阵中
figure; 
% imshow(255-I); % 黑白互换
imshow(I)
colormap gray;
axis image;
hold on; % 保留原图
plot(x, y, '-r', 'Linewidth', 3)%画出路径 在原图基础上绘制
title('Solution to Maze by Dijkstra')%命名图片3





