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

data = zeros(3 , 10 , 3) ;
data(:,:,1) = data_w1 ;
data(:,:,2) = data_w2 ;
data(:,:,3) = data_w3 ;

% (a)
% x , mean , w
mean_vec = zeros(3 , 1 , 3) ;
for x = 1:3
    for w = 1:3
        mean_vec(x,:,w) = mean(data(x,:,w)) ;
    end
end

% disp(mean_vec)

% x , mean , w
S = zeros(3 , 3 , 3) ;
Sw = zeros(3 , 3 , 3) ;
for w = 1:3
    for j = 1:10
        dif = data(:,j,w) - mean_vec(:,1,w) ;
        S(:,:,w) = S(:,:,w) + dif * dif' ;
    end
end
% Sw = S1 + S2 + S3
Sw = S(:,:,1) + S(:,:,2) + S(:,:,3) ;
% SB = (ci - overall_mean)(ci - overall_meean)'
overall_mean = zeros(3 , 1) ;
for x = 1:3
    overall_mean(x,1) = mean(data(x,:)) ;
end
SB = zeros(3 , 3) ;
for w = 1:3
    dif = mean_vec(:,1,w) - overall_mean ;
    SB = SB + 10 * dif * dif' ;
end

disp('(a)')
disp('within-class scatter matrix SW:')
disp(Sw)
disp('between-class scatter matrix SB:') ;
disp(SB) ;

% (b)
% Sw^(-1) * SB
[eigenvectors, eigenvalues] = eig(Sw^(-1) * SB);
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
a = zeros(2 , 10 , 3) ;
for e = 1:2
    eigenvector = principal_eigenvectors(:,e) ;
    for i = 1:10
        for w = 1:3
            a(e,i,w) = eigenvector' * (data(:,i,w) - overall_mean);
        end
    end
end

% Plot projected data
figure;
scatter(a(1,:,1), a(2,:,1), 'r', 'filled'); 
hold on ;
scatter(a(1,:,2), a(2,:,2), 'g', 'filled');
hold on ;
scatter(a(1,:,3), a(2,:,3), 'b', 'filled');
hold on ;
title('Projected Data onto 2D Subspace');
legend({'ω1', 'ω2', 'ω3'});

% (d)
disp("")
disp('(d)')
predict(a)