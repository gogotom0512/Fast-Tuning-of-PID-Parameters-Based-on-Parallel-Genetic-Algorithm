function [bestParams, fitnessHistory] = enhancedParallelGA(plant, params)
%ENHANCEDPARALLELGA 增强型并行遗传算法主程序
%   本算法采用多子群并行进化与定期迁移机制优化PID控制器参数
%
% 输入参数：
%   plant  - 被控对象传递函数模型
%   params - 算法参数结构体，需包含：
%            popSize: 总种群规模
%            numSubPops: 子种群数量
%            maxGen: 最大进化代数
%            migrationInterval: 迁移间隔代数
%
% 输出参数：
%   bestParams     - 最优PID参数结构体（Kp/Ki/Kd字段）
%   fitnessHistory - 全局最优适应度进化历史

% 初始化并行计算环境
if isempty(gcp('nocreate'))
    parpool;
end

% 创建初始子种群
subPopSize = params.popSize / params.numSubPops;
subPops = arrayfun(@(~) initializePopulation(subPopSize, params),...
    1:params.numSubPops, 'UniformOutput', false);

% 进化过程监控
fitnessHistory = zeros(params.maxGen, 1);
bestGlobalFitness = inf;
bestParams = struct('Kp',0,'Ki',0,'Kd',0);

% 主进化循环
for gen = 1:params.maxGen
    % 各子种群并行进化
    parfor i = 1:params.numSubPops
        subPops{i} = evolvePopulationEPGA(subPops{i}, plant, params, gen, params.maxGen);
    end
    
    % 定期执行迁移操作
    if mod(gen, params.migrationInterval) == 0
        subPops = migrateEPGA(subPops, params, plant);
    end
    
    % 更新全局最优解
    [currentBest, currentFitness] = getGlobalBest(subPops, plant, params);
    if currentFitness < bestGlobalFitness
        bestGlobalFitness = currentFitness;
        bestParams = currentBest;
    end
    fitnessHistory(gen) = bestGlobalFitness;
    
    % 显示进化进度
    fprintf('Generation %d: Best Fitness = %.16f\n', gen, bestGlobalFitness);
end
end