function [bestInd, bestFitness] = getGlobalBest(subPops, plant, params)
%GETGLOBALBEST 获取多子种群中的全局最优个体
%   本函数遍历所有子种群，比较各子群最优个体，返回全局最优解
%
% 输入参数：
%   subPops - 子种群单元数组（每个元素为包含Kp/Ki/Kd结构体的单元数组）
%   plant   - 被控对象传递函数模型
%   params  - 算法参数结构体（保留字段用于扩展）
%
% 输出参数：
%   bestInd      - 全局最优个体参数结构体
%   bestFitness  - 全局最优适应度值
%
% 使用示例：
%   subPops = {pop1, pop2, pop3};  % 三个子种群
%   [best, fitness] = getGlobalBest(subPops, tf(1,[1 2 1]), struct());

% 初始化全局最优记录
bestFitness = inf;                        % 初始化为极大值
bestInd = struct('Kp',0,'Ki',0,'Kd',0);  % 空参数模板

% 遍历所有子种群寻找最优解
for i = 1:length(subPops)
    % 获取当前子种群最优个体
    [currentBest, currentFitness] = getSubPopBest(subPops{i}, plant);
    
    % 更新全局最优记录
    if currentFitness < bestFitness
        bestFitness = currentFitness;  % 记录更优适应度
        bestInd = currentBest;          % 更新最优个体
    end
end
end