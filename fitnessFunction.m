function cost = fitnessFunction(params, plant)
%FITNESSFUNCTION 计算PID控制器参数的综合性能指标
%   本函数通过阶跃响应分析评估PID参数性能，综合超调量、调节时间等指标
%
% 输入参数：
%   params - PID参数结构体，需包含Kp/Ki/Kd字段
%   plant  - 被控对象传递函数模型
%
% 输出参数：
%   cost   - 综合性能指标（值越小表示性能越优）
%
% 使用示例：
%   pidParams = struct('Kp',1.2, 'Ki',0.8, 'Kd',0.1);
%   sys = tf(1,[1 2 1]);
%   performance = fitnessFunction(pidParams, sys)

try
    % 构建闭环控制系统
    controller = pid(params.Kp, params.Ki, params.Kd);
    sys = feedback(controller * plant, 1);
    
    % 获取阶跃响应数据
    [y, t] = step(sys, 0:0.1:20);
    e = 1 - y;  % 计算误差信号
    
    % 提取时域性能指标
    info = stepinfo(y, t);
    overshoot = max(0, info.Overshoot);  % 抑制负超调
    settlingTime = info.SettlingTime;
    riseTime = info.RiseTime;
    
    % 计算积分型性能指标
    ISE = sum(e.^2) * 0.1;   % 积分平方误差
    IAE = sum(abs(e)) * 0.1; % 积分绝对误差
    ITAE = sum(t .* abs(e)) * 0.1;
    
    % 加权综合评估
    % 定义权重参数（可调节）
    w1 = 1;   % ITAE权重
    w2 = 5;   % 超调量权重
    w3 = 5;   % 调节时间权重
    w4 = 2;   % 上升时间权重
    w5 = 1;   % ISE权重
    w6 = 1;   % IAE权重

    cost = w1 * ITAE + w2 * overshoot + w3 * settlingTime +...
       w4 * riseTime + w5 * ISE + w6 * IAE;
    
catch
    cost = 1e6;  % 系统不稳定时返回极大惩罚值
end
end