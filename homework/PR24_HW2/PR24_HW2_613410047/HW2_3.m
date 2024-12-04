clear ;
clc ;

data_w1 = [
    0.42 -0.2 1.3 0.39 -1.6 -0.029 -0.23 0.27 -1.9 0.87;
    -0.087 -3.3 -0.32 0.71 -5.3 0.89 1.9 -0.3 0.76 -1;
    0.58 -3.4 1.7 0.23 -0.15 -4.7 2.2 -0.87 -2.1 -2.6];
data_w2 = [
    -0.4 -0.31 0.38 -0.15 -0.35 0.17 -0.011 -0.27 -0.065 -0.12;
    0.58 0.27 0.055 0.53 0.47 0.69 0.55 0.61 0.49 0.054;
    0.089 -0.04 -0.035 0.011 0.034 0.1 -0.18 0.12 0.0012 -0.063];
data_w3 = [
    0.83 1.1 -0.44 0.047 0.28 -0.39 0.34 -0.3 1.1 0.18;
    1.6 1.6 -0.41 -0.45 0.35 -0.48 -0.079 -0.22 1.2 -0.11;
    -0.014 0.48 0.32 1.4 3.1 0.11 0.14 2.2 -0.46 -0.49];

data = [data_w1 data_w2 data_w3] ;

% (a)
mean_vec = zeros(3 , 1) ;
for i = 1:3
    mean_vec(i) = mean(data(i,:)) ;
end

% disp(mean_vec)

S = zeros(3 , 3) ;
for j = 1:30
    dif = data(:,j) - mean_vec(:) ;
    S = S + dif * dif' ;
end

disp('(a)')
disp('Scatter Matrix:') ;
disp(S) ;

% (b)
[eigenvectors, eigenvalues] = eig(S);
[eigenvalues_sorted, idx] = sort(diag(eigenvalues), 'descend');
principal_eigenvectors = eigenvectors(:, idx(1:2)); % Top 2 eigenvectors

disp("")
disp('(b)')
disp('Eigenvalues:');
disp(eigenvalues_sorted(1:2));
disp('Corresponding Eigenvectors:');
disp(principal_eigenvectors);

% (c)
% ak = e'(xk - m)
a = zeros(2 , 30) ;
for e = 1:2
    eigenvector = principal_eigenvectors(:,e) ;
    for i = 1:30
        a(e,i) = eigenvector' * (data(:,i) - mean_vec);
    end
end

% Plot projected data
figure;
scatter(a(1,1:10), a(2,1:10), 'r', 'filled'); 
hold on ;
scatter(a(1,11:20), a(2,11:20), 'g', 'filled');
hold on ;
scatter(a(1,21:30), a(2,21:30), 'b', 'filled');
hold on ;
title('Projected Data onto 2D Subspace');
legend({'ω1', 'ω2', 'ω3'});

% (d)
disp("")
disp('(d)')
predict(a)