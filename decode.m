function value = decode(bits, range)
%DECODE 将二进制位序列转换为指定范围的参数值
%   该函数通过二进制解码技术将输入位序列线性映射到给定区间
%
% 输入参数：
%   bits  - 二进制位序列（逻辑型/数值型数组，自动转换为逻辑型）
%   range - 目标数值范围二元向量，格式为[min_value, max_value]
%
% 输出参数：
%   value - 映射到指定范围的参数值，确保value ∈ [min_value, max_value]
%
% 使用示例：
%   val = decode([1 0 1 1], [0 10])    % 返回二进制1011对应的映射值
%   val = decode(logical([1 0]), [-5 5]) % 返回-5 + (5-(-5))*(2/3) ≈ 1.6667

bits = logical(bits);                      % 强制转换为逻辑类型
maxVal = 2^length(bits)-1;                 % 计算最大整数值
intVal = sum(bits.*2.^(length(bits)-1:-1:0)); % 二进制转十进制

value = range(1) + (range(2)-range(1))*intVal/maxVal;  % 线性映射
value = max(min(value, range(2)), range(1));           % 边界约束
end