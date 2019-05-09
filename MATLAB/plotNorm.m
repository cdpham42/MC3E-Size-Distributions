function plotNorm(Dm, normal, name)

%{
    Plots normalized size distributions
%}

figure('visible','off');

semilogx(Dm, normal,'b-o','MarkerSize',3,'MarkerFaceColor','b');

xlim([10^-3 10^2]);
ylim([-5 4]);

hold on

% % Line for overall average of data
% 
% normalavg = zeros(1,size(normal,2));
% Dmavg = zeros(1,size(Dm,2));
% 
% for j = 1:size(normal,2)    % Loop through columns to average each column
%     c = 0;
%     d = 0;
%     sumnorm = 0;
%     sumDm = 0;
%     for i = 1:size(normal,1)    % Loop through all rows within column
%         if normal(i,j) ~= 0 && ~isnan(normal(i,j))
%             c = c+1;
%             sumnorm = sumnorm + normal(i,j);
%         end
%         if c~= 0
%             normalavg(j) = sumnorm/c;
%         end
%         
%         if Dm(i,j) ~= 0 && ~isnan(Dm(i,j))
%             d = d+1;
%             sumDm = sumDm + Dm(i,j);
%         end
%         if d~= 0
%             Dmavg(j) = sumDm/d;
%         end
%     end
% end

% disp(normalavg);
% disp(Dmavg);

% plot(Dmavg,normalavg,'k-o','LineWidth',1.5,'MarkerSize',2,'MarkerFaceColor','k');

xlabel('D/Dm','FontSize',20);
ylabel('log_{10}(N(D)/N_{0}*)','FontSize',20);
title(name,'FontSize',20);

set(gca,'fontsize',20)

saveas(gcf,name,'png');

close