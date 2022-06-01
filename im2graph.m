function graph = im2graph(im, varargin)
%% �������
% ��ֹ����Ĳ���������ϵͳҪ��
if ( nargin == 2 ) %�ж���������ĸ���
    conn = varargin{1};%�������������������
elseif ( nargin == 1 )
    conn = 4; %�������һ������
end

if ( conn ~= 4 && conn ~= 8 )
    error('2nd argument is the type of neighborhood connection. Must be either 4 or 8');
end
%%

%% ά��
[M, N] = size(im);%��M,N�ֱ𴢴�im������������
MxN = M*N;%�������Ԫ�ص�����

%% ����������
% reshape:�ع�����,ʹ�ô�С���� MxN �ع� im 
CostVec = reshape(im, MxN, 1);%������ת��ΪMxN�е��о��󣨽�ÿһ�нӵ���һ�е�ĩβ������ÿ��Ԫ�ص���һ��
if ( conn == 4 )
    %%%%%%%%%%%%
    % *  -1  * %
    %-M   *  M %
    % *   1  * %
    %%%%%%%%%%%%
    
    % repmat:�ظ����鸱��;����һ�����飬������������ά�Ⱥ���ά�Ȱ��� CostVec ��(1,4)��������
    % spdiags:��ȡ����Խ��߲�����ϡ���״�ԽǾ���, ͨ����ȡrepmat(CostVec,1,4) ���в���[-M -1 1 M]ָ���ĶԽ��߷������ǣ�������һ��MxN, MxN ϡ����� S��
    graph = spdiags(repmat(CostVec,1,4), [-M -1 1 M], MxN, MxN);%��repmat��������1��4�Ŀ����(���о�������3��),��spdiags��������ϡ�����
elseif( conn == 8 )
    %%%%%%%%%%%%%%%
    %-M-1 -1  M-1 %
    %-M    *  M   %
    %-M+1  1  M+1 %
    %%%%%%%%%%%%%%%
     
    graph = spdiags(repmat(CostVec,1,8), [-M-1, -M, -M+1, -1, 1, M-1, M, M+1], MxN, MxN);%���о�������7��
    % sub2ind:���±�ת��Ϊ��������; 
    %         ��Դ�СΪ[MxN, MxN]�Ķ�ά���鷵����2������(2:N-1)*M+1  (2:N-1)*M - M)ָ���Ķ�ά�±�Ķ�Ӧ�������� inf��
    graph(sub2ind([MxN, MxN], (2:N-1)*M+1,(2:N-1)*M - M))   = inf;%top->bottom westwards(-M-1)
    graph(sub2ind([MxN, MxN], (1:N)*M,    (1:N)*M - M + 1)) = inf;%bottom->top westwards(-M+1)
    
    graph(sub2ind([MxN, MxN], (0:N-1)*M+1,(0:N-1)*M + M))     = inf;%top->bottom eastwards(M-1)
    graph(sub2ind([MxN, MxN], (1:N-2)*M,  (1:N-2)*M + M + 1)) = inf;%bottom->top eastwards(M+1)
end

graph(sub2ind([MxN, MxN], (1:N-1)*M+1, (1:N-1)*M))     = inf;%top->bottom
graph(sub2ind([MxN, MxN], (1:N-1)*M,   (1:N-1)*M + 1)) = inf;%bottom->top
