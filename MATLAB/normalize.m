function [Norm, NormDiam] = normalize(data, bin, dbin)

Dm = mean_diameter(data,bin,dbin);
No = scale_No(data,bin,dbin);

Norm = zeros(size(data));

for k = 1:size(Norm,3)
    for i = 1:size(Norm,1)
        for j = 1:size(Norm,2)
            Norm(i,j,k) = data(i,j,k)/No(i,1,k);    % N(D)/No* for that particular row
            
            if isnan(Norm(i,j,k))
                Norm(i,j,k) = 0;
            end
            
            if isinf(Norm(i,j,k))
                Norm(i,j,k) = 0;
            end
            
        end
        
    end
end

NormDiam = zeros(size(data));

bin = bin.*10^(-3); % mm to m

for k = 1:size(Norm,3)
    for i = 1:size(NormDiam,1)
        for j = 1:size(NormDiam,2)
            NormDiam(i,j,k) = bin(j)/Dm(i,1,k); % D/Dm for that particular row for each bin
            
            if isnan(NormDiam(i,j,k))
                NormDiam(i,j,k) = 0;
            end
            
            if isinf(NormDiam(i,j,k))
                NormDiam(i,j,k) = 0;
            end
            
        end
        
    end
end
        