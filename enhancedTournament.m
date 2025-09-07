function selected = enhancedTournament(population, fitness, gen, maxGen, params)
%ENHANCEDTOURNAMENT 增强型锦标赛选择算子
%   本函数在传统锦标赛选择基础上引入动态规模调整和多样性维护机制
%
% 输入参数：
%   population - 种群单元数组，每个元素为参数结构体(Kp/Ki/Kd)
%   fitness    - 适应度值向量，与population对应
%   gen        - 当前进化代数
%   maxGen     - 最大进化代数
%   params     - 算法参数结构体（保留字段用于扩展）
%
% 输出参数：
%   selected   - 选择后的新种群单元数组

% 初始化动态锦标赛规模
tournamentSize = dynamicTournamentSize(gen, maxGen);

% 确定精英个体索引
[~, eliteIdx] = min(fitness);

% 计算种群多样性指标
diversityReward = calculateDiversity(population);

% 调整适应度值（引入多样性奖励）
adjustedFitness = fitness - 0.2 * diversityReward; % 多样性奖励系数

% 执行锦标赛选择
selected = cell(size(population));
for i = 1:length(population)
    % 候选池（强制包含精英+随机选择）
    candidates = [eliteIdx, randperm(length(population), tournamentSize-1)];
    
    % 基于调整适应度选择最优个体
    [~, bestIdx] = min(adjustedFitness(candidates));
    selected{i} = population{candidates(bestIdx)};
end
end

% ========================================================================
function tournamentSize = dynamicTournamentSize(gen, maxGen)
%DYNAMICTOURNAMENTSIZE 计算动态锦标赛规模
%   规模随进化代数非线性增长，初期保持小规模，后期增大选择压力

baseSize = 2; 
maxSize = 6;
tournamentSize = baseSize + floor((gen/maxGen)^1.5 * (maxSize - baseSize));
end

% ========================================================================
function diversity = calculateDiversity(population)
%CALCULATEDIVERSITY 计算种群参数多样性指标
%   通过参数标准差评估多维参数空间分布情况

% 提取参数矩阵[Kp, Ki, Kd]
paramMatrix = cell2mat(...
    cellfun(@(x) [x.Kp, x.Ki, x.Kd], population, 'UniformOutput', false));

% 计算各参数维度标准差
sigma = std(paramMatrix);

% 综合多样性指标（三参数平均标准差）
diversity = sum(sigma) / 3; 
end