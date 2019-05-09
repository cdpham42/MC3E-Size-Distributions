function array = convert(data,n);

for i = 1:size(data,1)
    for j = 1:size(data,2)
        array(i,j,n) = data(i,j);
    end
end
end