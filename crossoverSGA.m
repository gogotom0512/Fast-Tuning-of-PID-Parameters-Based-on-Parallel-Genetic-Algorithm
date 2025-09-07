function newPop = crossoverSGA(population, params)
%CROSSOVERSGA SGA专用单点交叉操作
%   本函数对SGA算法的PID参数进行二进制基因单点交叉
%
% 输入参数：
%   population - 种群单元数组，每个单元包含Kp/Ki/Kd参数结构体
%   params     - 算法参数结构体，需包含：
%                bitLength: 各参数编码位数
%                paramRange: 各参数取值范围结构体(Kp/Ki/Kd字段)
%
% 输出参数：
%   newPop - 新生成种群单元数组，保持与原种群相同尺寸
%
% 使用示例：
%   newPop = crossoverSGA(pop, struct('bitLength',16,'paramRange',paramRange))

newPop = cell(size(population));
for i = 1:2:length(population)-1
    % 获取配对父代个体
    parent1 = population{i};
    parent2 = population{i+1};
    
    % Kp参数编码及交叉
    [p1Kp, p2Kp] = singlePointCrossover(...
        logical(dec2bin(parent1.Kp, params.bitLength)-'0'),...
        logical(dec2bin(parent2.Kp, params.bitLength)-'0'));
    
    % Ki参数编码及交叉
    [p1Ki, p2Ki] = singlePointCrossover(...
        logical(dec2bin(parent1.Ki, params.bitLength)-'0'),...
        logical(dec2bin(parent2.Ki, params.bitLength)-'0'));
    
    % Kd参数编码及交叉
    [p1Kd, p2Kd] = singlePointCrossover(...
        logical(dec2bin(parent1.Kd, params.bitLength)-'0'),...
        logical(dec2bin(parent2.Kd, params.bitLength)-'0'));
    
    % 二进制解码生成新个体
    newPop{i} = struct(...
        'Kp', decode(p1Kp, params.paramRange.Kp),...
        'Ki', decode(p1Ki, params.paramRange.Ki),...
        'Kd', decode(p1Kd, params.paramRange.Kd));
    
    newPop{i+1} = struct(...
        'Kp', decode(p2Kp, params.paramRange.Kp),...
        'Ki', decode(p2Ki, params.paramRange.Ki),...
        'Kd', decode(p2Kd, params.paramRange.Kd));
end
end

function [child1, child2] = singlePointCrossover(parent1, parent2)
%SINGLEPOINTCROSSOVER 单点交叉算子
%   在随机位置交换父代基因序列
%
% 输入参数：
%   parent1 - 父代1的二进制基因序列
%   parent2 - 父代2的二进制基因序列
%
% 输出参数：
%   child1/child2 - 生成的两个子代基因序列

pt = randi(length(parent1)-1);         % 随机生成交叉点
child1 = [parent1(1:pt) parent2(pt+1:end)];  % 子代1前半段继承父代1
child2 = [parent2(1:pt) parent1(pt+1:end)];  % 子代2前半段继承父代2
end