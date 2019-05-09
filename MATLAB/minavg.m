function [dataavg] = minavg(data)

dataavg = zeros( ceil(size(data,1)/60), size(data,2) );

for j = 1:size(data,2)
    c = 1;  % Second counter, reset at 60  or end of data set
    a = 1;  % Array counter
    m = 0;  % Minute boolean
    
    for i = 1:size(data,1);
        if i == size(data,1); m = 1; end;
        if c == 60; m = 1; end;
        
        if m == 0
            dataavg(a,j) = dataavg(a,j) + data(i,j);
            c = c+1;
        end
        
        if m == 1
            dataavg(a,j) = dataavg(a,j)/c;
            if isnan(dataavg(a,j))
                dataavg(a,j) = 0;
            end
            c = 1;
            a = a+1;
            m = 0;
        end
    end
end

end