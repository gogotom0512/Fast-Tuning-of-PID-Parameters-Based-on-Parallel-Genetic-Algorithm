function selected = tournamentSelection(population, fitness, tournamentSize)
%TOURNAMENTSELECTION 执行锦标赛选择操作
%   本函数通过随机竞争机制从种群中筛选优质个体
%
% 输入参数：
%   population     - 种群单元数组，每个元素为个体结构体
%   fitness        - 适应度值向量，与population一一对应
%   tournamentSize - 锦标赛规模（每个竞赛选取的候选个体数）
%
% 输出参数：
%   selected       - 选择后的新种群单元数组
%
% 使用示例：
%   pop = {struct('Kp',1), struct('Kp',2)}; % 测试种群
%   fit = [0.5, 0.3];                       % 适应度值
%   newPop = tournamentSelection(pop, fit, 2);

selected = cell(size(population));  % 预分配结果存储空间

% 遍历种群执行锦标赛选择
for i = 1:length(population)
    % 随机选取候选个体索引
    candidates = randperm(length(population), tournamentSize);
    
    % 比较候选个体适应度并选择最优
    [~, bestIdx] = min(fitness(candidates));
    
    % 记录胜出个体
    selected{i} = population{candidates(bestIdx)};
end
end
