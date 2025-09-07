function value = bitsToParameter(bits, range)
%BITSTOPARAMETER 将二进制位序列映射到指定数值区间
%   该函数将输入的二进制位序列转换为十进制整数，并线性映射到用户指定的数值区间
%
% 输入参数：
%   bits  - 二进制位序列（数值型数组，元素取0或1）
%   range - 目标区间二元向量，格式为[最小值, 最大值]
%
% 输出参数：
%   value - 映射后的参数值
%
% 调用示例：
%   val = bitsToParameter([1 0 1], [0 15])  % 二进制101(5)映射到[0,15]得5
%   val = bitsToParameter([0 1 1 0], [-1 1]) % 映射结果为-0.2

% 二进制转十进制计算
intVal = sum(bits.*2.^(length(bits)-1:-1:-0));  % 位权展开求和

% 线性映射到目标区间
value = range(1) + intVal/(2^length(bits)-1)*(range(2)-range(1));
end