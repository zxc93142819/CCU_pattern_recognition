function [z, W1, W2] = forward_backward(W1, W2, eta)
    % 定義 XOR 輸入和目標
    X = [1 1; -1 -1; 1 -1; -1 1];
    T = [1; 1; 0; 0];

    % 前向傳播
    nSamples = size(X, 1);
    H = sigmoid([X ones(nSamples, 1)] * W1'); % 隱藏層激活值
    z = sigmoid([H ones(nSamples, 1)] * W2'); % 輸出層激活值

    % disp(H)
    % disp(z)
    % disp("-------------------------")

    % 計算誤差
    delta_out = (T - z) .* z .* (1 - z);  % 輸出層誤差
    delta_hidden = (delta_out * W2(:, 1:end-1)) .* H .* (1 - H); % 隱藏層誤差

    % 更新權重
    W2 = W2 + eta * delta_out' * [H ones(nSamples, 1)];
    W1 = W1 + eta * delta_hidden' * [X ones(nSamples, 1)];
end

function y = sigmoid(x)
    y = 1 ./ (1 + exp(-x));
end