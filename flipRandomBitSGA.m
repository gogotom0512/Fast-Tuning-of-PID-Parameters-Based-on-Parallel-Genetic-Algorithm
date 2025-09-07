function bits = flipRandomBitSGA(bits)
%FLIPRANDOMBITSGA 执行SGA简单位翻转变异
%   该函数在二进制序列中随机选取单一位进行翻转操作
%
% 输入参数：
%   bits - 二进制位序列（逻辑型数组，元素取true/false）
%
% 输出参数：
%   bits - 变异后的二进制位序列
%
% 使用示例：
%   mutatedBits = flipRandomBitSGA([true false true])

pos = randi(length(bits));   % 生成随机变异位置
bits(pos) = ~bits(pos);      % 执行位翻转
end