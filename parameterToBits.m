function bits = parameterToBits(value, range, bitLength)
%PARAMETERTOBITS 将参数值编码为二进制位序列
%   本函数将浮点参数值映射到指定二进制位数的离散编码
%
% 输入参数：
%   value     - 待编码的浮点参数值
%   range     - 参数取值范围二元向量 [最小值, 最大值]
%   bitLength - 二进制编码位数
%
% 输出参数：
%   bits      - 二进制位序列（逻辑型数组，true代表1，false代表0）
%
% 使用示例：
%   bits = parameterToBits(5.3, [0 10], 8)  % 将5.3映射到8位二进制

% 参数归一化处理
normValue = (value - range(1)) / (range(2) - range(1));  % 映射到[0,1]区间

% 离散化处理
intVal = round(normValue * (2^bitLength - 1));  % 转换为整数

% 生成二进制位序列
bits = logical(dec2bin(intVal, bitLength) - '0');  % 字符转数值再转逻辑型
end