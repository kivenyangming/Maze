function graph = im2graph(im, varargin)
%% 参数检查
% 防止输入的参数不符合系统要求
if ( nargin == 2 ) %判断输入变量的个数
    conn = varargin{1};%如果输入两个变量，则
elseif ( nargin == 1 )
    conn = 4; %如果输入一个变量
end

if ( conn ~= 4 && conn ~= 8 )
    error('2nd argument is the type of neighborhood connection. Must be either 4 or 8');
end
%%

%% 维度
[M, N] = size(im);%用M,N分别储存im的行数、列数
MxN = M*N;%计算矩阵元素的数量

%% 计算距离矩阵
% reshape:重构数组,使用大小向量 MxN 重构 im 
CostVec = reshape(im, MxN, 1);%将矩阵转换为MxN行的列矩阵（将每一列接到上一列的末尾），即每个元素单起一行
if ( conn == 4 )
    %%%%%%%%%%%%
    % *  -1  * %
    %-M   *  M %
    % *   1  * %
    %%%%%%%%%%%%
    
    % repmat:重复数组副本;返回一个数组，该数组在其行维度和列维度包含 CostVec 的(1,4)个副本。
    % spdiags:提取非零对角线并创建稀疏带状对角矩阵, 通过获取repmat(CostVec,1,4) 的列并沿[-M -1 1 M]指定的对角线放置它们，来创建一个MxN, MxN 稀疏矩阵 S。
    graph = spdiags(repmat(CostVec,1,4), [-M -1 1 M], MxN, MxN);%用repmat函数生成1×4的块矩阵(将列矩阵扩充3列),用spdiags函数创建稀疏矩阵
elseif( conn == 8 )
    %%%%%%%%%%%%%%%
    %-M-1 -1  M-1 %
    %-M    *  M   %
    %-M+1  1  M+1 %
    %%%%%%%%%%%%%%%
     
    graph = spdiags(repmat(CostVec,1,8), [-M-1, -M, -M+1, -1, 1, M-1, M, M+1], MxN, MxN);%将列矩阵扩充7列
    % sub2ind:将下标转换为线性索引; 
    %         针对大小为[MxN, MxN]的多维数组返回由2个数组(2:N-1)*M+1  (2:N-1)*M - M)指定的多维下标的对应线性索引 inf。
    graph(sub2ind([MxN, MxN], (2:N-1)*M+1,(2:N-1)*M - M))   = inf;%top->bottom westwards(-M-1)
    graph(sub2ind([MxN, MxN], (1:N)*M,    (1:N)*M - M + 1)) = inf;%bottom->top westwards(-M+1)
    
    graph(sub2ind([MxN, MxN], (0:N-1)*M+1,(0:N-1)*M + M))     = inf;%top->bottom eastwards(M-1)
    graph(sub2ind([MxN, MxN], (1:N-2)*M,  (1:N-2)*M + M + 1)) = inf;%bottom->top eastwards(M+1)
end

graph(sub2ind([MxN, MxN], (1:N-1)*M+1, (1:N-1)*M))     = inf;%top->bottom
graph(sub2ind([MxN, MxN], (1:N-1)*M,   (1:N-1)*M + 1)) = inf;%bottom->top
