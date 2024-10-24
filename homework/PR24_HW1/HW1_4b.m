clear
clc

S = load("roc_data.mat") ;
[x,y] = deal(S.x , S.y) ;

% 對 x 向量進行排序，並獲得排序的索引
[x_sorted, idx] = sort(x);

% 使用排序索引對 y 進行相同的重排
y_sorted = y(idx);

% 計算總的正例和負例數量
total_positives = sum(y_sorted);
total_negatives = length(y_sorted) - total_positives;

% 初始化計數器
TP = total_positives; % 真陽性
TN = 0; % 真陰性
FP = total_negatives; % 假陽性
FN = 0; %假陰性

% 初始化 TPR 和 FPR 的歷史記錄
FPR_history = [];
TPR_history = [];

FPR_history(end+1) = 1;
TPR_history(end+1) = 1;

% 使用 for 迴圈遍歷 y_sorted
for i = 1:length(y_sorted)
    if y_sorted(i) == 1
        TP = TP - 1;
        FN = FN + 1;
    else
        TN = TN + 1;
        FP = FP - 1;
    end
    
    % 計算 TPR 和 FPR
    TPR = TP / (TP + FN);
    FPR = FP / (FP + TN);
    
    % 記錄當前的 FPR 和 TPR
    FPR_history(end+1) = FPR;
    TPR_history(end+1) = TPR;
end

AUC = 0 ;
n = length(FPR_history) ;
% 計算 AUC
for i = 1:n - 1
    % x 的差值為 FPR 的差值，y 的和為對應的 TPR 值
    AUC = AUC + abs(FPR_history(i+1) - FPR_history(i)) * (TPR_history(i+1) + TPR_history(i)) / 2;
end

% 顯示 AUC 值
fprintf('AUC: %.2f\n', AUC);