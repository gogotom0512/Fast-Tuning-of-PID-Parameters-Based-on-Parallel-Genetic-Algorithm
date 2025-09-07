function v = constrainValue(v, range)
%CONSTRAINVALUE 将数值限制在指定区间
%   对输入值进行上下限截断处理
%
% 输入参数：
%   v      - 待约束的数值（标量/矩阵）
%   range  - 约束区间二元向量 [min_value, max_value]
%
% 输出参数：
%   v      - 约束后的数值，满足 v ∈ [range(1), range(2)]
%
% 使用示例：
%   constrained = constrainValue(5, [0 10])  % 返回5
%   constrained = constrainValue(-3, [0 5])  % 返回0

v = max(min(v, range(2)), range(1));
end