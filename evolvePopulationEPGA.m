function population = evolvePopulationEPGA(population, plant, params, gen, maxGen)
%EVOLVEPOPULATIONEPGA EPGA种群进化核心函数
%   本函数完成种群进化全流程：适应度评估->选择->交叉->变异->精英保留
%
% 输入参数：
%   population - 当前种群单元数组（每个元素为包含Kp/Ki/Kd的结构体）
%   plant      - 被控对象传递函数模型
%   params     - 算法参数结构体（需包含选择/交叉/变异相关参数）
%   gen        - 当前进化代数
%   maxGen     - 最大进化代数
%
% 输出参数：
%   population - 进化后的新种群单元数组

% 并行计算种群适应度
fitness = zeros(length(population), 1);
parfor i = 1:length(population)
    fitness(i) = fitnessFunction(population{i}, plant);
end

% 执行增强型锦标赛选择
selected = enhancedTournament(population, fitness, gen, maxGen, params);

% 执行EPGA专用交叉操作
crossed = crossoverEPGA(selected, params);  

% 执行变异操作
mutated = mutateEPGA(crossed, params);  

% 精英保留策略（保留当前最优个体）
[~, idx] = min(fitness);
mutated{1} = population{idx};  % 用原种群最优替换新种群首个体

population = mutated;  % 返回进化后的种群
end