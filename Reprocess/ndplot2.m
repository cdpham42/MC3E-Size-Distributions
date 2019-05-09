function ndplot2(bin1,data1,name1,bin2,data2,name2,name,logd)

%{
    Plots Raindrop size distribution N(D) or N(logD)
%}
figure('visible','off');

loglog(bin1,data1,'b-o','MarkerSize',3,'MarkerFaceColor','b');

if logd == 0
    axis([.05 10^2 0 10^9],'manual');
end
if logd == 1
    axis([.05 10^2 0 5*10^11],'manual');
end

hold on

loglog(bin2,data2,'r-o','MarkerSize',3,'MarkerFaceColor','r');

legend(name1,name2);

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
