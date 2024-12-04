function p = my_mvnpdf(X, mu, Sigma)
    % X: 要計算的點 (n x d matrix，n個d維數據點)
    % mu: 平均值向量 (1 x d)
    % Sigma: 協方差矩陣 (d x d)
    
    % 獲取維度
    [n, d] = size(X);
    
    % 確保mu是行向量
    mu = mu(:)';
    
    % 計算(X-mu)
    X_mu = X - repmat(mu, n, 1);
    
    % 計算常數項
    const = 1 / ((2*pi)^(d/2) * sqrt(det(Sigma)));
    
    % 計算指數項
    % 注意：這裡使用 \ 運算符來解線性方程，比直接求逆更有效率
    exponent = zeros(n,1);
    for i = 1:n
        exponent(i) = -0.5 * (X_mu(i,:) * (Sigma \ X_mu(i,:)'));
    end
    
    % 計算最終的PDF值
    p = const * exp(exponent);
end