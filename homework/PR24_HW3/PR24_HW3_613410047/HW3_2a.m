clear;
clc;

% X-OR problem 
x = [1 1; -1 -1; 1 -1; -1 1]';
t = [1 1 0 0];

% Train a 2-2-1 network
eta = 0.1;
d = 2;
n_H = 2;
c = 1;
W1 = 0.5 * ones(n_H , d + 1);
W2 = 0.5 * ones(c , n_H + 1);

% batch backpropagation
[z, W1, W2] = forward_backward(W1 , W2 , eta);
z = z';
disp("z:")
disp(z)
disp("W1:")
disp(W1)
disp("W2:")
disp(W2)