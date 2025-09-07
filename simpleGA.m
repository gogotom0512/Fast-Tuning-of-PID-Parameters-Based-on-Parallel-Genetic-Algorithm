function [bestParams, fitnessHistory] = simpleGA(plant, params)
%SIMPLEGA 简单遗传算法主程序
%   本算法通过选择、交叉、变异操作迭代优化PID控制器参数
%
% 输入参数：
%   plant  - 被控对象传递函数模型
%   params - 算法参数结构体，需包含：
%            popSize:  种群规模
%            maxGen:   最大进化代数
%
% 输出参数：
%   bestParams     - 最优PID参数结构体（Kp/Ki/Kd字段）
%   fitnessHistory - 全局最优适应度进化历史
%
% 使用示例：
%   sys = tf(1, [1 3 2]);  % 被控对象
%   params = struct('popSize',50, 'maxGen',100, ...);
%   [best, history] = simpleGA(sys, params);

% 确保串行执行环境
if ~isempty(gcp('nocreate'))
    delete(gcp);  % 关闭现有并行池
end

% 初始化种群
population = initializePopulation(params.popSize, params);

% 进化过程监控
fitnessHistory = zeros(params.maxGen, 1);
bestFitness = inf;
bestParams = struct('Kp',0,'Ki',0,'Kd',0);

% 主进化循环
for gen = 1:params.maxGen
    % 执行种群进化操作
    population = evolvePopulationSGA(population, plant, params);
    
    % 更新全局最优记录
    [currentBest, currentFitness] = getSubPopBest(population, plant);
    if currentFitness < bestFitness
        bestFitness = currentFitness;
        bestParams = currentBest;
    end
    fitnessHistory(gen) = bestFitness;
    
    % 显示进化进度
    fprintf('SGA Generation %d: Best Fitness = %.16f\n', gen, bestFitness);
end
end