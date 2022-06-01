close all; clear;
%% ������ʼ����ֹ������
StartPoint = [1, 497]; %��ʼ�� ���
EndPoint   = [533,523];%��ֹ�� ����
%% main

%��ʾԭͼ��
I = imread('maze.png'); %��ȡͼƬ����
figure;%����һ������
imshow(I) %��ʾ�Ҷ�ͼ��
title('Maze problem');
hold on;
plot(StartPoint(1), StartPoint(2), 'r.');%�ú�ɫ�ĵ������ʼ��
plot(EndPoint(1), EndPoint(2), 'b.');%�ú�ɫ�ĵ������ֹ��
legend('Start point', 'End Point');%����ͼƬ1

walls = imdilate(I<128,ones(9));%I<128��ʹI��С��128��ֵ��Ϊ1������128��ֵ��Ϊ0�������ɺ�ɫΪ1��ɫΪ0���ڰ׶Ե����Ķ�ֵͼ��Ȼ����ÿ����Ϊ��������9��9���󣬽��õ��ֵ��ͬ�ھ����������ֵ�������Ϳ���ʹ����֮��ĺ�ɫ·�����ֱ�ѹ�����Ӷ�ʹ·�������ü�
figure;
imshow(walls) %��ʾ����һ����ֵͼ�񣬺�ɫ����Ϊ·�� 
title('Thickened walls')%����ͼƬ2

[M, N] = size(I);
%%
% sub2ind:���±�ת��Ϊ��������
% ��Դ�СΪ [M N]�ľ��󷵻��� StartPoint(2) �� StartPoint(1) ָ���������±�Ķ�Ӧ�������� ind��
% �˴���[M N] �ǰ�������Ԫ�ص����������� [M N](1) ָ��������[M N](2) ָ��������

StartNode = sub2ind([M N], StartPoint(2), StartPoint(1)); %��[M,N]���ҵ���Ӧ��ʼ���������
EndNode   = sub2ind([M N], EndPoint(2),   EndPoint(1)); %��[M,N]���ҵ���Ӧ��ֹ���������

CMatrix = double(walls)*M*N+1;
% CMatrix�Ľ��Ϊ533*533��double�;���
%% ����������
D = im2graph(CMatrix);%D�洢�������
%% Ѱ�����·�� :ȷ����Դ�ڵ�S��ͼ�����������ڵ�����·��G��dist������Դ�ڵ㵽���������ڵ�ľ��롣path������ÿ���ڵ�����·����pred�������·����ǰ���ڵ㡣
[dist, path, pred] = graphshortestpath(D, StartNode, EndNode);
%Ĭ��ʹ�õϽ�˹�����㷨��distΪ��С·�����ȣ�pathΪ�����ĵ㣬pred�����ӽڵ�1��Դ�ڵ㣩�����������ڵ㣨����������ָ����Ŀ��ڵ㣩�����·����ǰ�ýڵ㣬D�Ǿ������StartNode��ʾ���,EndNode��ʾ�յ�
% ind2sub:����������ת��Ϊ�±�
% ind2sub([M N], path) �������� x �� y�����а������СΪ [M N] �ľ������������path��Ӧ�ĵ�Ч�к����±ꡣ�˴���[M N]�ǰ�������Ԫ�ص����������� M ָ��������Nָ��������
[y, x] = ind2sub([M N], path);%��[M N]����������path��ֵ������¼��[y,x]������
figure; 
% imshow(255-I); % �ڰ׻���
imshow(I)
colormap gray;
axis image;
hold on; % ����ԭͼ
plot(x, y, '-r', 'Linewidth', 3)%����·�� ��ԭͼ�����ϻ���
title('Solution to Maze by Dijkstra')%����ͼƬ3





