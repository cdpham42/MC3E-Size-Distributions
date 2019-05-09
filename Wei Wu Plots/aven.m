function m=aven(n,nave)

[a,b] = size(n);

for i=1:nave:b
    m(:,floor((i-1)/nave)+1)=nanmean(n(:,i:min((i+nave-1),b)),2);
end

end