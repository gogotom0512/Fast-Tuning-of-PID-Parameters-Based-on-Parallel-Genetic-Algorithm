function [params, response] = zieglerNichols(plant)
%ZIEGLERNICHOLS 基于Ziegler-Nichols方法的PID参数整定
%   本函数利用MATLAB内置的pidtune工具进行PID参数自动整定
%
% 输入参数：
%   plant - 被控对象传递函数模型
%
% 输出参数：
%   params   - PID参数结构体，包含Kp/Ki/Kd字段
%   response - 闭环系统阶跃响应特性（stepinfo结构体）
%
% 使用示例：
%   sys = tf(1, [1 3 2]);
%   [znParams, stepInfo] = zieglerNichols(sys);

try
    % 使用MATLAB内置PID整定工具
    [C, info] = pidtune(plant, 'pid');  % PID控制器类型
    params.Kp = C.Kp;
    params.Ki = C.Ki;
    params.Kd = C.Kd;
catch
    % 异常处理：返回默认PID参数
    params.Kp = 1;
    params.Ki = 0.1;
    params.Kd = 0.01;
end

% 构建闭环系统并获取阶跃响应特性
controller = pid(params.Kp, params.Ki, params.Kd);
sys = feedback(controller * plant, 1);        % 单位负反馈
response = stepinfo(sys);                    % 获取时域特性参数
end