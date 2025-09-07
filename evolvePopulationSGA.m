function population = evolvePopulationSGA(population, plant, params)
%EVOLVEPOPULATIONSGA SGA种群进化核心函数
%   本函数完成SGA标准进化流程：适应度评估->锦标赛选择->交叉->变异->精英保留
%
% 输入参数：
%   population - 当前种群单元数组（每个元素为包含Kp/Ki/Kd的结构体）
%   plant      - 被控对象传递函数模型
%   params     - 算法参数结构体（需包含锦标赛规模等参数）
%
% 输出参数：
%   population - 进化后的新种群单元数组

% 串行计算种群适应度
fitness = zeros(length(population), 1);
for i = 1:length(population)
    fitness(i) = fitnessFunction(population{i}, plant);
end

% 执行锦标赛选择（固定规模3）
selected = tournamentSelection(population, fitness, 3);

% 执行SGA专用单点交叉
crossed = crossoverSGA(selected, params);

% 执行变异操作
mutated = mutateSGA(crossed, params);

% 精英保留策略（替换最优个体）
[~, idx] = min(fitness);           % 获取原种群最优索引
mutated{1} = population{idx};       % 保留原种群最优个体
population = mutated;               % 生成最终进化种群
end