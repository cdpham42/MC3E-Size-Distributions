function ndplot(bin,data,name,logd)

%{
    Plots Raindrop size distribution N(D) or N(logD)
%}
figure('visible','off');

loglog(bin,data,'b-o','MarkerSize',3,'MarkerFaceColor','b');
if logd == 0
    axis([.05 10^2 0 10^9],'manual');
end
if logd == 1
    axis([.05 10^2 0 5*10^11],'manual');
end

hold on

% Line for overall average of data
dataavg = zeros(1,size(data,2));
for j = 1:size(data,2)
    c = 0;
    sum = 0;
    for i = 1:size(data,1)
        if data(i,j) ~= 0 && ~isnan(data(i,j))
            c = c+1;
            sum = sum + data(i,j);
        end
        dataavg(j) = sum/c;
    end
end
loglog(bin,dataavg,'k-o','LineWidth',2,'MarkerSize',4,'MarkerFaceColor','k');

xlabel('Diameter [mm]','FontSize',12);

if logd == 0
    ylabel('Raindrop Size Distribution N(D) [m^{-4}]','FontSize',12);
end
if logd == 1
    ylabel('Raindrop Size Distribution N(logD) [m^{-4}]','FontSize',12);
end

title(name,'FontSize',16);

set(gca,'fontsize',16)

saveas(gcf,name,'png');

close
