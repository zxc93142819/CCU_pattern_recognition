clc;
clear;

% (Three samples, Features data, Three categories)
w = zeros(3,10,3);
w(:,:,1) = [
    0.42 -0.2 1.3 0.39 -1.6 -0.029 -0.23 0.27 -1.9 0.87;
    -0.087 -3.3 -0.32 0.71 -5.3 0.89 1.9 -0.3 0.76 -1;
    0.58 -3.4 1.7 0.23 -0.15 -4.7 2.2 -0.87 -2.1 -2.6];

w(:,:,2) = [
    -0.4 -0.31 0.38 -0.15 -0.35 0.17 -0.011 -0.27 -0.065 -0.12;
    0.58 0.27 0.055 0.53 0.47 0.69 0.55 0.61 0.49 0.054;
    0.089 -0.04 -0.035 0.011 0.034 0.1 -0.18 0.12 0.0012 -0.063];
    
w(:,:,3) = [
    0.83 1.1 -0.44 0.047 0.28 -0.39 0.34 -0.3 1.1 0.18;
    1.6 1.6 -0.41 -0.45 0.35 -0.48 -0.079 -0.22 1.2 -0.11;
    -0.014 0.48 0.32 1.4 3.1 0.11 0.14 2.2 -0.46 -0.49];

% means
m = zeros(3,1,3);
for j = 1:3
    for i = 1:10
        m(:,1,j) = m(:,1,j) + w(:,i,j);
    end
end
m = m/10;
m_total = zeros(3,1);
for i = 1:3
    m_total = m_total+10*m(:,1,i);
end
m_total = m_total/30;

S = zeros(3,3,3);
for j = 1:3
    for i = 1:10
    tmp = w(:,i,j) - m(:,1,j);
    S(:,:,j) = S(:,:,j) + tmp*tmp';
    end
end
SW = S(:,:,1) + S(:,:,2) + S(:,:,3);

SB = zeros(3,3);
for i = 1:3
    tmp = m(:,1,i) - m_total;
    SB = SB + 10*(tmp*tmp');
end
disp("(a) within-class scatter matrix SW = ");disp(SW);
disp("    between-class scatter matrix SB = ");disp(SB);

ori_C = eig((SW^(-1))*SB);
sort_C = sort(eig((SW^(-1))*SB),1,'descend');
index_1 = 0; % 最大eignevalue的索引
index_2 = 0; % 次大eignevalue的索引
for i = 1:3
    if (ori_C(i) == sort_C(1))
        index_1 = i;
    end
    if (ori_C(i) == sort_C(2))
        index_2 = i;
    end
end

[A, B] = eig(SW^(-1)*SB);% eigenvector eigenvalue
eigenvector = zeros(3,1,2);
eigenvector(:,:,1) = [A(1,index_1);A(2,index_1);A(3,index_1)];% 最大eignevalue 對應的eigenvector
eigenvector(:,:,2) = [A(1,index_2);A(2,index_2);A(3,index_2)];% 次大eignevalue 對應的eigenvector
fprintf("(b) Two largest eigenvalues = %.4f and %.4f\n", sort_C(1), sort_C(2));
fprintf("    Two largest eigenvectors = [%.4f; %.4f; %.4f] and [%.4f; %.4f; %.4f]\n",eigenvector(:,:,1),eigenvector(:,:,2));

% ak=et(xk-m)
a = zeros(2,10,3);
for k = 1:3
    for j = 1:10
        for i = 1:2
            a(i,j,k) = eigenvector(:,:,i)'*(w(:,j,k)-m_total);
        end
    end
end

figure('Name','(c)');
scatter(a(1,:,1),a(2,:,1),'r*')
hold on
scatter(a(1,:,2),a(2,:,2),'gx')
hold on
scatter(a(1,:,3),a(2,:,3),'bo')
hold on;
legend('w1','w2','w3','location','southeast');

% mu
mu = zeros(2,1,3);
for j = 1:3
    for i = 1:10
        mu(:,1,j) = mu(:,1,j) + a(:,i,j);
    end
end
mu = mu/10;

% sigma
sigma = zeros(2, 2, 3);
for j = 1:3
    for i = 1:10
        tmp = a(:,i,j) - mu(:,1,j);
        sigma(:,:,j) = sigma(:,:,j) + tmp*tmp';
    end
end
sigma = sigma/10;

w1_mis = 0;
w2_mis = 0;
w3_mis = 0;
g = zeros(3,10,3);
for j = 1:3
    for i = 1:10
        x = a(:,i,j);
        d = 2;
        g1 = -1/2*(x-mu(:,:,1))'*sigma(:,:,1)^-1*(x-mu(:,:,1))-d/2*log(2*pi)-1/2*log(det(sigma(:,:,1)))+log(1/3);
        g2 = -1/2*(x-mu(:,:,2))'*sigma(:,:,2)^-1*(x-mu(:,:,2))-d/2*log(2*pi)-1/2*log(det(sigma(:,:,2)))+log(1/3);
        g3 = -1/2*(x-mu(:,:,3))'*sigma(:,:,3)^-1*(x-mu(:,:,3))-d/2*log(2*pi)-1/2*log(det(sigma(:,:,3)))+log(1/3);
        if (j==1)
            if (g1<g2)||(g1<g3)
                w1_mis = w1_mis+1;
            end
        end
        if (j==2)
            if (g2<g1)||(g2<g3)
                w2_mis = w2_mis+1;
            end
        end
        if (j==3)
            if (g3<g1)||(g3<g2)
                w3_mis = w3_mis+1;
            end
        end 
    end
end

total_mis = (w1_mis+w2_mis+w3_mis)/30*100;
fprintf('(d) Percentage of misclassied samples: \n');
fprintf('    w1錯誤率 = %g%%\n',w1_mis*10);
fprintf('    w2錯誤率 = %g%%\n',w2_mis*10);
fprintf('    w3錯誤率 = %g%%\n',w3_mis*10);
fprintf('    總錯誤率 = %g%%\n',total_mis);