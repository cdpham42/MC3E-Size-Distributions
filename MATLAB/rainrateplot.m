function rainrateplot(databin, data1, data2, data3, data4, data5, name,logd)

%{  
    Takes in 5 datasets, 1 for each rainrate
    0-1mm/hr
    1-5mm/hr
    5-25mm/hr
    25-100mm/hr
    100+mm/hr

    Plots onto a single plot
%}

figure('visible','off');

loglog(databin,data1,'b-o','MarkerSize',2,'MarkerFaceColor','b');
if logd == 0
    axis([.05 10^2 0 10^9],'manual');
end
if logd == 1
    axis([.05 10^2 0 2*10^11],'manual');
end

hold on

loglog(databin,data2,'r-o','MarkerSize',2,'MarkerFaceColor','r');
loglog(databin,data3,'g-o','MarkerSize',2,'MarkerFaceColor','g');
loglog(databin,data4,'c-o','MarkerSize',2,'MarkerFaceColor','c');
loglog(databin,data5,'m-o','MarkerSize',2,'MarkerFaceColor','m');

legend('0-1mm/hr','1-5mm/hr','5-25mm/hr','25-100mm/hr','>100mm/hr');

xlabel('Diameter [mm]','FontSize',20);

if logd == 0
    ylabel('Raindrop Size Distribution N(D) [m^{-4}]','FontSize',20);
end
if logd == 1
    ylabel('Raindrop Size Distribution N(logD) [m^{-4}]','FontSize',20);
end

title(name,'FontSize',20);

set(gca,'fontsize',20);

saveas(gcf,name,'png');

close