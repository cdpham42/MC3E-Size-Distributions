function [rate_0_10,rate_10_30,rate_30_100] = organizeTestud(rate,data)

rate_0_10 = zeros(size(rate,1),size(data,2));
rate_10_30 = zeros(size(rate,1),size(data,2));
rate_30_100 = zeros(size(rate,1),size(data,2));

a = 1;  % 0-10mm/hr counter
b = 1;  % 10-30mm/hr counter
c = 1;  % 30-100mm/hr counter


for i = 1:size(rate,1)
    
    if rate(i) > 0 && rate(i) <= 10
        for j = 1:size(data,2)
            rate_0_10(a,j) = data(i,j);
        end
        a = a+1;
    end

    if rate(i) > 10 && rate(i) <= 30
        for j = 1:size(data,2)
            rate_10_30(b,j) = data(i,j);
        end
        b = b+1;
    end

    if rate(i) > 30 && rate(i) <= 100
        for j = 1:size(data,2)
            rate_30_100(c,j) = data(i,j);
        end
        c = c+1;
    end

end

end