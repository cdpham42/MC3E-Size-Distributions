function m=aven(n,nave)

%{

    Averaging
    n = array
    nave = number of samples to average across (ie 60 = 1-minute averages)

%}

b = size(n,2);

for i=1:nave:b
    m(:, floor((i-1)/nave)+1 ) = nanmean(n(:, i:min((i+nave-1),b)),2 );
end

end