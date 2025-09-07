function mutated = mutateSGA(population, params)
%MUTATESGA 执行SGA标准变异操作
%   本函数对种群中的PID参数进行二进制位翻转变异，各参数独立处理
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
%   newPop = mutateSGA(oldPop, params);

mutationProb = 0.1;  % 固定变异概率

% 遍历种群执行变异操作
for i = 1:length(population)
    % Kp参数变异流程
    bits = logical(dec2bin(population{i}.Kp, params.bitLength) - '0');
    if rand < mutationProb
        bits = flipRandomBitSGA(bits);
        population{i}.Kp = decode(bits, params.paramRange.Kp);
    end
    
    % Ki参数变异流程
    bits = logical(dec2bin(population{i}.Ki, params.bitLength) - '0');
    if rand < mutationProb
        bits = flipRandomBitSGA(bits);
        population{i}.Ki = decode(bits, params.paramRange.Ki);
    end
    
    % Kd参数变异流程
    bits = logical(dec2bin(population{i}.Kd, params.bitLength) - '0');
    if rand < mutationProb
        bits = flipRandomBitSGA(bits);
        population{i}.Kd = decode(bits, params.paramRange.Kd);
    end
end

mutated = population;  % 返回变异后种群
end