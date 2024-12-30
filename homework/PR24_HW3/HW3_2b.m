clear;
clc;

% X-OR problem 
x = [1 1; -1 -1; 1 -1; -1 1]';
t = [1 1 0 0];

% Train a 2-2-1 network
eta = 0.1;
epochs = 100;
d = 2;
n_H = 2;
c = 1;
W1 = randn(n_H , d + 1);
W2 = randn(c , n_H + 1);
J = zeros(1 , epochs);
errors = zeros(1 , epochs);

% batch backpropagation
for r = 1:epochs
    [z, W1, W2] = forward_backward(W1 , W2 , eta);
    z = z';
    J(r) = sum(-1 * t.*log(z) - (1 - t).*log(1 - z)) ;

    % calculate the number of misclassification errors
    errors(r) = size(find(z(1, 1:2) <.5) , 2);
    errors(r) = errors(r) + size(find(z(1, 3:4) >.5) , 2);
end

% plot
figure;
plot(1:epochs , J);
title('Learning curve for Batch backpropagation');
xlabel('epochs');
ylabel('J(w)');