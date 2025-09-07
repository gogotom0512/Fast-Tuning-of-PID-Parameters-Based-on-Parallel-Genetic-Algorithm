function mutated = mutateEPGA(population, params)
%MUTATEEPGA 执行EPGA增强型PID参数变异
%   本函数采用自适应概率策略，对种群中的每个个体进行Kp/Ki/Kd三位同步变异
%
% 输入参数：
%   population - 种群单元数组（元素为含Kp/Ki/Kd字段的结构体）
%   params     - 算法参数结构体，需包含：
%                bitLength:  参数编码位数
%                paramRange: 参数范围结构体（Kp/Ki/Kd字段为二元向量）
%
% 输出参数：
%   mutated    - 变异后的种群单元数组
%
% 使用示例：
%   params = struct('bitLength',16, 'paramRange',struct('Kp',[0 15],...));
%   newPop = mutateEPGA(oldPop, params);

% 初始化变异控制参数（保留原始算法默认值）
mutationProb = 0.1;     % 基础变异概率
sigmaRatio = 0.05;      % 高斯变异标准差系数
adaptiveFactor = 0.02; % 参数范围自适应因子

% 遍历种群执行变异操作
for i = 1:length(population)
    % 计算当前参数的动态变异概率
    paramRanges = [diff(params.paramRange.Kp),...
                   diff(params.paramRange.Ki),...
                   diff(params.paramRange.Kd)];
    adaptiveProb = mutationProb + adaptiveFactor*mean(paramRanges)/100;

    % 并行执行Kp/Ki/Kd参数变异
    population{i}.Kp = mutateParameterPGA(population{i}.Kp,...
        params.paramRange.Kp, params.bitLength, adaptiveProb, sigmaRatio);
    
    population{i}.Ki = mutateParameterPGA(population{i}.Ki,...
        params.paramRange.Ki, params.bitLength, adaptiveProb, sigmaRatio);
    
    population{i}.Kd = mutateParameterPGA(population{i}.Kd,...
        params.paramRange.Kd, params.bitLength, adaptiveProb, sigmaRatio);
end
mutated = population;
end

function [newValue, mutatedFlag] = mutateParameterPGA(value, range, bitLength, adaptiveProb, sigmaRatio)
%MUTATEPARAMETERPGA 单参数变异执行函数
%   提供位翻转/高斯/均匀三种变异模式，根据概率自动选择
%
% 输入参数：
%   value         - 当前参数值
%   range         - 参数允许范围[最小值,最大值]
%   bitLength     - 二进制编码长度
%   adaptiveProb  - 自适应变异概率
%   sigmaRatio    - 高斯变异标准差系数
%
% 输出参数：
%   newValue     - 变异后的参数值
%   mutatedFlag  - 是否发生变异的标志

mutatedFlag = false;
if rand() < adaptiveProb
    % 随机选择变异类型
    mutationType = randi(3);
    switch mutationType
        case 1  % 位翻转变异
            bits = parameterToBits(value, range, bitLength);
            bits = flipRandomBitPGA(bits);
            newValue = bitsToParameter(bits, range);
            
        case 2  % 高斯变异
            sigma = (range(2)-range(1)) * sigmaRatio;
            newValue = value + sigma*randn();
            
        case 3  % 均匀突变
            newValue = range(1) + rand()*(range(2)-range(1));
    end
    newValue = constrainValue(newValue, range);  % 参数范围约束
    mutatedFlag = true;
else
    newValue = value;  % 未发生变异保持原值
end
end