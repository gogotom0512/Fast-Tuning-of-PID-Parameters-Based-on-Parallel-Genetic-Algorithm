function bits = flipRandomBitPGA(bits)
%FLIPRANDOMBITPGA 执行EPGA增强型位翻转变异
%   该函数以30%概率进行多位置翻转，否则单一位翻转
%
% 输入参数：
%   bits - 二进制位序列（逻辑型数组）
%
% 输出参数：
%   bits - 变异后的二进制位序列
%
% 使用示例：
%   mutated = flipRandomBitPGA([1 0 1 1 0])

if rand() < 0.3  % 30%概率触发多位置变异
    % 随机确定翻转位数(1~总位数/4)
    numFlips = randi([1, ceil(length(bits)/4)]); 
    positions = randperm(length(bits), numFlips);  % 无重复随机抽样
    bits(positions) = ~bits(positions);            % 批量翻转
else  % 70%概率单点变异
    positions = randi(length(bits));       % 随机选择单个位置
    bits(positions) = ~bits(positions);    % 执行位翻转
end
end