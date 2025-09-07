%%主程序 main.m

clear; clc; close all;

%创建被控对象（传递函数）
s = tf('s');

%带有时滞的一阶惯性系统
plant = (2*exp(-2*s))/(5*s + 1); 

%算法参数设置
gaParams = struct(...
    'popSize', 400,...
    'numSubPops', 8,...
    'maxGen', 100,...
    'migrationInterval', 5,...
    'paramRange', struct(...
        'Kp', [0 10],...
        'Ki', [0 1],...
        'Kd', [0 1]),...
    'bitLength', 20);

%增强型并行遗传算法优化
tic;
[bestParams_EPGA,fitnessHistory_EPGA]= enhancedParallelGA(plant,gaParams); 
timeEPGA=toc;  

%简单遗传算法优化
tic;
[bestParams_SGA, fitnessHistory_SGA] = simpleGA(plant, gaParams);
timeSGA = toc;

%Ziegler-Nichols
[znParams, znResponse] = zieglerNichols(plant);

%综合性能对比
compareAdvancedResults(plant, bestParams_EPGA, bestParams_SGA, znParams,... 
fitnessHistory_EPGA,fitnessHistory_SGA,timeEPGA,timeSGA);  