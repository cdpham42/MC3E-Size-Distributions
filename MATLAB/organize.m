function [rate_0_1,rate_1_5,rate_5_25,rate_25_100,rate_100] = organize(rate,data)

rate_0_1 = zeros(size(rate,1),size(data,2));
rate_1_5 = zeros(size(rate,1),size(data,2));
rate_5_25 = zeros(size(rate,1),size(data,2));
rate_25_100 = zeros(size(rate,1),size(data,2));
rate_100 = zeros(size(rate,1),size(data,2));

a = 1;  % 0-1mm/hr counter
b = 1;  % 1-5mm/hr counter
c = 1;  % 5-25mm/hr counter
d = 1;  % 25-100mm/hr counter
e = 1;  % >100mm/hr counter

for i = 1:size(rate,1)
    
    if rate(i) >= 0 && rate(i) < 1
        for j = 1:size(data,2)
            rate_0_1(a,j) = data(i,j);
        end
        a = a+1;
    end

    if rate(i) >= 1 && rate(i) < 5
        for j = 1:size(data,2)
            rate_1_5(b,j) = data(i,j);
        end
        b = b+1;
    end

    if rate(i) >= 5 && rate(i) < 25
        for j = 1:size(data,2)
            rate_5_25(c,j) = data(i,j);
        end
        c = c+1;
    end

    if rate(i) >= 25 && rate(i) < 100
        for j = 1:size(data,2)
            rate_25_100(d,j) = data(i,j);
        end
        d = d+1;
    end

    if rate(i) >= 100
        for j = 1:size(data,2)
            rate_100(e,j) = data(i,j);
        end
        e = e+1;
    end

end

end