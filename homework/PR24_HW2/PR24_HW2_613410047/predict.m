function predict(data)
    % 計算平均值和共變異數
    mu = zeros(2 , 1 , 3) ;
    for w = 1:3
        mu(1,1,w) = mean(data(1,(w - 1) * 10 + 1:w * 10)) ;
        mu(2,1,w) = mean(data(2,(w - 1) * 10 + 1:w * 10)) ;
    end

    sigma = zeros(2 , 2 , 3) ;
    for w = 1:3
        for j = 1:10
            tmp = data(:,(w - 1) * 10 + j) - mu(:,1,w) ;
            sigma(:,:,w) = sigma(:,:,w) + tmp * tmp' ;
        end
        sigma(:,:,w) = sigma(:,:,w) / 10 ;
    end

    wrong = [0 , 0 , 0] ;
    % 計算wrong sample
    for i = 1:10
        for w = 1:3
            p = [] ;
            X = data(:,(w - 1) * 10 + i)' ;
            p(end + 1) = mvnpdf(X , mu(:,:,1)' , sigma(:,:,1)) ;
            p(end + 1) = mvnpdf(X , mu(:,:,2)' , sigma(:,:,2)) ;
            p(end + 1) = mvnpdf(X , mu(:,:,3)' , sigma(:,:,3)) ;
            M = max(p) ;
            if(M ~= p(w))
                wrong(w) = wrong(w) + 1 ;
            end
        end
    end
    
    fprintf('ω1錯誤率 = %d%% \n',wrong(1)*10);
    fprintf('ω2錯誤率 = %d%% \n',wrong(2)*10);
    fprintf('ω3錯誤率 = %d%% \n',wrong(3)*10);
end