clear
clc

% 定義參數
mu1 = 1; sigma1 = 1;    % 第一個正態分布的均值和標準差
mu2 = -1; sigma2 = sqrt(1);  % 第二個正態分布的均值和標準差
w1 = 0.5; w2 = 0.5;  % 第一個和第二個分布的權重

% 定義x範圍
x = linspace(-3, 3, 1000);

% 手動計算正態分布的PDF
y1 = w1 * (1 / (sqrt(2 * pi * sigma1^2))) * exp(-((x - mu1).^2) / (2 * sigma1^2));
y2 = w2 * (1 / (sqrt(2 * pi * sigma2^2))) * exp(-((x - mu2).^2) / (2 * sigma2^2));
y3 = y1 + y2;

% 計算 alpha1, alpha2 和 alpha3
alpha1 = y2 ./ y3;
alpha2 = y1 ./ y3;
alpha3 = 0.25 * (y1 ./ y3) + 0.25 * (y2 ./ y3);

% 決策區域計算: 確定每個x值在哪個alpha中最小
[~, decision_region] = min([alpha1; alpha2; alpha3], [], 1);

% 繪製決策區域背景顏色
figure;
hold on;

% 繪製 R(a1|x), R(a2|x), R(a3|x)
plot(x, alpha1, 'DisplayName', 'R(α1|x)', 'LineWidth', 1.5 , Color = "b");
plot(x, alpha2, 'DisplayName', 'R(α2|x)', 'LineWidth', 1.5 , Color = "g");
plot(x, alpha3, 'DisplayName', 'R(α3|x)', 'LineWidth', 1.5 , Color = "r");
% 使用 plot 造出一個0區域，只是要用於填充legend表示區域意思
plot(x, alpha1, 'DisplayName', 'R1', 'LineWidth', 0.00000001 , Color = "b");
plot(x, alpha2, 'DisplayName', 'R2', 'LineWidth', 0.00000001 , Color = "g");
plot(x, alpha3, 'DisplayName', 'R3', 'LineWidth', 0.00000001 , Color = "r");
legend()

% 塗色決策區域
for i = 1:length(x)-1
    if decision_region(i) == 1
        fill([x(i), x(i+1), x(i+1), x(i)], [0, 0, 0.01, 0.01], 'b' , 'EdgeColor' , 'none', 'LineWidth', 0.00000001 , 'HandleVisibility', 'off');
    elseif decision_region(i) == 2
        fill([x(i), x(i+1), x(i+1), x(i)], [0, 0, 0.01, 0.01], 'g' , 'EdgeColor' , 'none', 'LineWidth', 0.00000001 , 'HandleVisibility', 'off');
    elseif decision_region(i) == 3
        fill([x(i), x(i+1), x(i+1), x(i)], [0, 0, 0.01, 0.01], 'r' , 'EdgeColor' , 'none', 'LineWidth', 0.00000001 , 'HandleVisibility', 'off');
    end
end

% 加標籤
xlabel('x');
ylabel('risk')

% 顯示網格
grid on;

% 顯示圖形
title('Conditional Risks and Decision Region');
hold off;