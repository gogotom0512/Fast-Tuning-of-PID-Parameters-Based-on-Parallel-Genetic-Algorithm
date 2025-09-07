function compareAdvancedResults(plant, epgaParams, sgaParams, znParams, fitnessEPGA, fitnessSGA, timeEPGA, timeSGA)
%COMPAREADVANCEDRESULTS 对比不同PID控制算法的性能指标
%   该函数对比分析EPGA、SGA和Ziegler-Nichols方法的控制参数及系统响应特性
%
% 输入参数：
%   plant       - 被控对象传递函数模型
%   epgaParams  - EPGA优化参数结构体，包含Kp/Ki/Kd字段
%   sgaParams   - SGA优化参数结构体，包含Kp/Ki/Kd字段
%   znParams    - Z-N法参数结构体，包含Kp/Ki/Kd字段
%   fitnessEPGA - EPGA算法适应度值序列
%   fitnessSGA  - SGA算法适应度值序列
%   timeEPGA    - EPGA优化耗时(秒)
%   timeSGA     - SGA优化耗时(秒)

% 显示各算法优化参数
fprintf('\n====增强型并行遗传算法优化参数(EPGA)====\n');  
fprintf('Kp=%.4f\nKi=%.4f\nKd=%.4f\n\n', epgaParams.Kp, epgaParams.Ki, epgaParams.Kd);
fprintf('====简单遗传算法优化参数(SGA)====\n');
fprintf('Kp=%.4f\nKi=%.4f\nKd=%.4f\n\n', sgaParams.Kp, sgaParams.Ki, sgaParams.Kd);
fprintf('==== Ziegler-Nichols法参数(Z-N)====\n');
fprintf('Kp=%.4f\nKi=%.4f\nKd=%.4f\n\n', znParams.Kp, znParams.Ki, znParams.Kd);

% 初始化仿真参数
t = 0:0.01:30;
metrics = repmat(struct('Overshoot',0,'SettlingTime',0,'RiseTime',0,'ISE',0,'IAE',0,'ITAE',0,'Method',''), 1, 3); 
params = {epgaParams, sgaParams, znParams};
methods = {'EPGA','SGA','Z-N'};

% 计算各方法性能指标
for i = 1:3
    [~, ~, responseData] = getStepResponse(plant, params{i}, t);    
    tempMetrics = calculateMetrics(responseData, t);    
    metrics(i).Overshoot = tempMetrics.Overshoot(1);  
    metrics(i).SettlingTime = tempMetrics.SettlingTime(1);
    metrics(i).RiseTime = tempMetrics.RiseTime(1);
    metrics(i).ISE = tempMetrics.ISE;
    metrics(i).IAE = tempMetrics.IAE;
    metrics(i).ITAE = tempMetrics.ITAE;
    metrics(i).Method = methods{i};
end

% 生成综合对比图形
figure('Position',[100 100 1400 700]);
subplot(2,2,[1 2]);
hold on; plotStepResponses(plant, params, methods, t);
title('Step Response Comparison'); legend('show','Location','best'); grid on

subplot(2,2,3);
hold on;
plot(fitnessEPGA,'LineWidth',2,'DisplayName','EPGA');  
plot(fitnessSGA,'LineWidth',2,'DisplayName','SGA');
xlabel('Generation'); ylabel('Best Fitness'); title('Algorithm Convergence');
legend('show'); grid on; set(gca,'YScale','log');

text(0.5,0.05, sprintf('优化耗时:\nEPGA: %.2fs\nSGA: %.2fs',timeEPGA,timeSGA),...
    'Units','normalized','HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',10,'BackgroundColor','w');

subplot(2,2,4);
plotCombinedMetrics(metrics);
title('Performance Metrics Comparison');
end

% ========================================================================
function [y, t, responseData] = getStepResponse(plant, params, t)
% 获取PID控制系统的阶跃响应数据
controller = pid(params.Kp, params.Ki, params.Kd);
sys = feedback(controller*plant, 1);
[y, t] = step(sys, t);
responseData.y = y;
responseData.t = t;
end

% ========================================================================
function metrics = calculateMetrics(responseData, t)
% 计算阶跃响应性能指标
y = responseData.y;
e = 1 - y;
info = stepinfo(y, t);

metrics = struct(...
    'Overshoot', max([0, info.Overshoot]),...
    'SettlingTime', info.SettlingTime,...
    'RiseTime', info.RiseTime,...
    'ISE', trapz(t, e.^2),...
    'IAE', trapz(t, abs(e)),...
    'ITAE', trapz(t, t.*abs(e)));
end

% ========================================================================
function plotStepResponses(plant, params, methods, t)
% 绘制多算法阶跃响应曲线
colors = {'b','r','g'}; lineStyles = {'-','--','-.'};
hold on;
for i = 1:3
    [y, ~] = getStepResponse(plant, params{i}, t);
    plot(t, y, 'Color', colors{i}, 'LineStyle', lineStyles{i},...
        'LineWidth', 1.8, 'DisplayName', methods{i});
end
plot(t, ones(size(t)), 'k', 'DisplayName','Target','LineWidth',1.2);
xlabel('Time(s)'); ylabel('Amplitude'); axis([0 30 0 1.4]);
end

% ========================================================================
function plotCombinedMetrics(metrics)
% 绘制性能指标对比柱状图
fields = {'Overshoot','SettlingTime','RiseTime','ISE','IAE','ITAE'};
data = zeros(length(metrics), length(fields));
for i = 1:length(metrics)
    for j = 1:length(fields)
        val = metrics(i).(fields{j});
        if ~isscalar(val), val = val(1); end
        data(i,j) = val;
    end
end
h = bar(data, 'grouped');
set(gca,'XTickLabel',{metrics.Method});
legend(fields,'Location','northeastoutside');
ylabel('Metric Value'); title('Performance Metrics Comparison');

for i = 1:numel(h)
    xData = h(i).XEndPoints;
    yData = h(i).YEndPoints;
    text(xData, yData, string(round(yData,2)),...
        'VerticalAlignment','bottom','HorizontalAlignment','center','FontSize',8);
end
grid on; set(gca,'YScale','log');
end