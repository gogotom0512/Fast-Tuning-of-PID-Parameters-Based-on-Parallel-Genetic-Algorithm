function newPop = crossoverEPGA(population, params)
%CROSSOVEREPGA EPGA算法专用均匀交叉操作
%   本函数对EPGA算法的PID参数进行二进制基因均匀交叉
%
% 输入参数：
%   population - 种群单元数组，每个单元包含Kp/Ki/Kd参数结构体
%   params     - 算法参数结构体，需包含：
%                bitLength: 各参数编码位数
%                paramRange: 各参数取值范围结构体(Kp/Ki/Kd字段)
%
% 输出参数：
%   newPop - 新生成种群单元数组，保持与原种群相同尺寸

newPop = cell(size(population));
for i = 1:2:length(population)-1
    % 获取配对父代
    parent1 = population{i};
    parent2 = population{i+1};
    
    % Kp参数交叉
    [p1Kp, p2Kp] = uniformCrossover(...
        parameterToBits(parent1.Kp, params.paramRange.Kp, params.bitLength),...
        parameterToBits(parent2.Kp, params.paramRange.Kp, params.bitLength));
    
    % Ki参数交叉
    [p1Ki, p2Ki] = uniformCrossover(...
        parameterToBits(parent1.Ki, params.paramRange.Ki, params.bitLength),...
        parameterToBits(parent2.Ki, params.paramRange.Ki, params.bitLength));
    
    % Kd参数交叉
    [p1Kd, p2Kd] = uniformCrossover(...
        parameterToBits(parent1.Kd, params.paramRange.Kd, params.bitLength),...
        parameterToBits(parent2.Kd, params.paramRange.Kd, params.bitLength));
    
    % 二进制解码生成新个体
    newPop{i} = struct(...
        'Kp', bitsToParameter(p1Kp, params.paramRange.Kp),...
        'Ki', bitsToParameter(p1Ki, params.paramRange.Ki),...
        'Kd', bitsToParameter(p1Kd, params.paramRange.Kd));
    
    newPop{i+1} = struct(...
        'Kp', bitsToParameter(p2Kp, params.paramRange.Kp),...
        'Ki', bitsToParameter(p2Ki, params.paramRange.Ki),...
        'Kd', bitsToParameter(p2Kd, params.paramRange.Kd));
end
end

function [child1, child2] = uniformCrossover(parent1, parent2)
%UNIFORMCROSSOVER 均匀交叉算子
%   通过随机掩码交换父代基因位

mask = rand(size(parent1)) < 0.5;  % 生成随机交叉掩码
child1 = parent1; 
child1(mask) = parent2(mask);     % 子代1继承父代2的掩码位

child2 = parent2; 
child2(mask) = parent1(mask);     % 子代2继承父代1的掩码位
end
