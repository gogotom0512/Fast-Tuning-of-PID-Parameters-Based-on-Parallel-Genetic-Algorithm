function [bestInd, bestFitness] = getSubPopBest(subPop, plant)
%GETSUBPOPBEST 获取子种群中最优个体及其适应度
%   本函数通过并行计算评估子种群所有个体，返回适应度最优的个体
%
% 输入参数：
%   subPop - 子种群单元数组，每个元素为包含Kp/Ki/Kd参数的结构体
%   plant  - 被控对象传递函数模型
%
% 输出参数：
%   bestInd     - 最优个体参数结构体
%   bestFitness - 最优个体的适应度值

% 并行计算种群适应度
fitness = zeros(length(subPop), 1);
parfor i = 1:length(subPop)
    fitness(i) = fitnessFunction(subPop{i}, plant);
end

% 定位最优个体
[bestFitness, idx] = min(fitness);  % 获取最小适应度索引
bestInd = subPop{idx};              % 提取最优个体参数
end