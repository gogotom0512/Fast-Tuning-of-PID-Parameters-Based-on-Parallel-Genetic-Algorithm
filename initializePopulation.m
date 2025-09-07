function population = initializePopulation(size, params)
%INITIALIZEPOPULATION 生成初始PID参数种群
%   本函数通过二进制随机编码创建指定规模的初始种群
%
% 输入参数：
%   size   - 种群规模（个体数量）
%   params - 算法参数结构体，需包含：
%            bitLength:  各参数编码位数
%            paramRange: 参数取值范围结构体（Kp/Ki/Kd字段）
%
% 输出参数：
%   population - 种群单元数组，每个元素为结构体(Kp/Ki/Kd)
%
% 使用示例：
%   params = struct('bitLength',16, 'paramRange',struct('Kp',[0 10],...));
%   pop = initializePopulation(100, params);

population = cell(size, 1);  % 预分配种群存储空间
for i = 1:size
    % 随机生成二进制编码并解码为参数值
    population{i} = struct(...
        'Kp', decode(randi([0, 1], 1, params.bitLength), params.paramRange.Kp),...
        'Ki', decode(randi([0, 1], 1, params.bitLength), params.paramRange.Ki),...
        'Kd', decode(randi([0, 1], 1, params.bitLength), params.paramRange.Kd));
end
end