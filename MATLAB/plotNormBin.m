function plotNormBin(bin, normal, name)

%{
    Plots normalized size distributions
%}

figure('visible','off');

semilogx(bin, normal,'b-o','MarkerSize',3,'MarkerFaceColor','b');

xlim([.05 50]);
ylim([-5 4]);

hold on

% Line for overall average of data

normalavg = zeros(1,size(normal,2));
for j = 1:size(normal,2)
    c = 0;
    sum = 0;
    for i = 1:size(normal,1)
        if normal(i,j) ~= 0 && ~isnan(normal(i,j))
            c = c+1;
            sum = sum + normal(i,j);
        end
        normalavg(j) = sum/c;
    end
end
semilogx(bin,normalavg,'k-o','LineWidth',2,'MarkerSize',4,'MarkerFaceColor','k');


xlabel('Diameter [mm]','FontSize',20);
ylabel('log_{10}(N(D)/N_{0}*)','FontSize',20);
title(name,'FontSize',20);

set(gca,'fontsize',20)

saveas(gcf,name,'png');

close