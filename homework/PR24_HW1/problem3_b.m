clear
clc

% 定義數據
data = {[-5.01, -5.43, 1.08, 0.86, -2.67, 4.94, -2.51, -2.25, 5.56, 1.03], ...
        [-8.12 , -3.48 , -5.52 , -3.78 , 0.63 , 3.29 , 2.09 , -2.13 , 2.86 , -3.33], ...
        [-3.68 , -3.54 , 1.66 , -4.11 , 7.39 , 2.08 , -2.59 , -6.94 , -2.26 , 4.33], ...
        [-0.91 , 1.30 , -7.75 , -5.47 , 6.14 , 3.60 , 5.37 , 7.18 , -7.39 , -7.50], ...
        [-0.18 , -2.06 , -4.54 , 0.50 , 5.72 , 1.26 , -4.63 , 1.46 , 1.17 , -6.32], ...
        [-0.05 , -3.53 , -0.95 , 3.92 , -4.85 , 4.36 , -3.65 , -6.66 , 6.30 , -0.31], ...
        [5.35 , 5.12 , -1.34 , 4.48 , 7.11 , 7.17 , 5.75 , 0.77 , 0.90 , 3.52], ...
        [2.26 , 3.22 , -5.31 , 3.42 , 2.39 , 4.33 , 3.97 , 0.27 , -0.43 , -0.36], ...
        [8.13 , -2.66 , -9.87 , 5.19 , 9.21 , -0.98 , 6.65 , 2.41 , -8.71 , 6.43]};

w1_mu = [0 0] ;
w2_mu = [0 0] ;
w3_mu = [0 0] ;
w1_co = [0 0;0 0] ;
w2_co = [0 0;0 0] ;
w3_co = [0 0;0 0] ;

prior = [0.2 , 0.3 , 0.5] ;
wrong = [0 , 0 , 0] ;
% 計算平均值和共變異數
for i = 1:3
    m = zeros(1, 2); % 儲存平均值
    c = zeros(2, 2); % 儲存共變異數矩陣

    % 計算每組的平均值
    for j = 1:2
        m(j) = mean(data{(i - 1) * 3 + j});
    end
    
    % 計算共變異數矩陣
    for j = 1:2
        for k = 1:2
            % 使用母體變異數(除數為n，非n-1)
            ccc = cov(data{(i - 1) * 3 + j}, data{(i - 1) * 3 + k}) * 9 / 10 ;
            c(j , k) = ccc(1 , 2) ;
        end
    end

    if(i == 1)
        w1_mu = m ;
        w1_co = c ;
    end
    if(i == 2)
        w2_mu = m ;
        w2_co = c ;
    end
    if(i == 3)
        w3_mu = m ;
        w3_co = c ;
    end
end

% 計算wrong sample
for i = 1:10
    % check this is the max value of ω1、ω2、ω3
    % a = mvnpdf([data{1}(i) data{2}(i)] , w1_mu , w1_co) * prior(1) ;
    % b = mvnpdf([data{1}(i) data{2}(i)] , w2_mu , w2_co) * prior(2) ;
    % c = mvnpdf([data{1}(i) data{2}(i)] , w3_mu , w3_co) * prior(3) ;
    % disp(mvnpdf([data{1}(i) data{2}(i)] , w1_mu , w1_co))
    % if(a<b)||(a<c)
    %     wrong(1) = wrong(1) + 1;
    % end
    % 
    % a = mvnpdf([data{4}(i) data{5}(i)] , w1_mu , w1_co) * prior(1) ;
    % b = mvnpdf([data{4}(i) data{5}(i)] , w2_mu , w2_co) * prior(2) ;
    % c = mvnpdf([data{4}(i) data{5}(i)] , w3_mu , w3_co) * prior(3) ;
    % % disp([data{4}(i) data{5}(i)])
    % if(a>b)||(b<c)
    %     wrong(2) = wrong(2) + 1;
    % end
    % 
    % a = mvnpdf([data{7}(i) data{8}(i)] , w1_mu , w1_co) * prior(1) ;
    % b = mvnpdf([data{7}(i) data{8}(i)] , w2_mu , w2_co) * prior(2) ;
    % c = mvnpdf([data{7}(i) data{8}(i)] , w3_mu , w3_co) * prior(3) ;
    % % disp([data{7}(i) data{8}(i)])
    % if(a>c)||(b>c)
    %     wrong(3) = wrong(3) + 1;
    % end


    for w = 1:3
        predict = [] ;
        X = [data{(w - 1) * 3 + 1}(i) data{(w - 1) * 3 + 2}(i)] ;
        predict(end + 1) = mvnpdf(X , w1_mu , w1_co) * prior(1) ;
        predict(end + 1) = mvnpdf(X , w2_mu , w2_co) * prior(2)  ;
        predict(end + 1) = mvnpdf(X , w3_mu , w3_co) * prior(3)  ;
        M = max(predict) ;
        if(M ~= predict(w))
            wrong(w) = wrong(w) + 1 ;
        end
    end
end

fprintf('ω1錯誤率 = %d%% \n',wrong(1)*10);
fprintf('ω2錯誤率 = %d%% \n',wrong(2)*10);
fprintf('ω3錯誤率 = %d%% \n',wrong(3)*10);