function createfigure(YMatrix1, YMatrix2)
%CREATEFIGURE(YMATRIX1, YMATRIX2)
%  YMATRIX1:  y 数据的矩阵
%  YMATRIX2:  y 数据的矩阵

%  由 MATLAB 于 01-Feb-2018 01:25:20 自动生成

% 创建 figure
figure1 = figure;

% 创建 axes
axes1 = axes('Parent',figure1,...
    'Position',[0.0605736301369863 0.174812030075188 0.400606494086616 0.663008482745325]);
hold(axes1,'on');

% 使用 plot 的矩阵输入创建多行
plot1 = plot(YMatrix1,'Parent',axes1);
set(plot1(1),'DisplayName','0%');
set(plot1(2),'DisplayName','10%');
set(plot1(3),'DisplayName','50%');
set(plot1(4),'DisplayName','90%');

% 创建 xlabel
xlabel({'time(min)'},'FontSize',11);

% 创建 title
title({'Average vehicle velocity'},'FontSize',11);

% 创建 ylabel
ylabel({'speed(km/h)'},'FontSize',11);

% 取消以下行的注释以保留坐标轴的 X 范围
% xlim(axes1,[0.796460175936193 60.7964601759362]);
% 取消以下行的注释以保留坐标轴的 Y 范围
% ylim(axes1,[22.03125 62.03125]);
box(axes1,'on');
% 创建 legend
legend1 = legend(axes1,'show');
set(legend1,'Location','best');

% 创建 axes
axes2 = axes('Parent',figure1,'Position',[0 1 1 1],'Tag','suptitle');
axis off

% 创建 text
text('Parent',axes2,'HorizontalAlignment','center','FontSize',14,...
    'String','The effect of different proportions of autopilot vehicles',...
    'Position',[0.490239574090506 -0.05 0],...
    'Visible','on');

% 创建 xlabel
xlabel({''},'FontSize',11,'Visible','off');

% 创建 axes
axes3 = axes('Parent',figure1,...
    'Position',[0.523554500118513 0.169799498746867 0.440731214167202 0.670585116637748]);
hold(axes3,'on');

% 使用 plot 的矩阵输入创建多行
plot2 = plot(YMatrix2,'Parent',axes3);
set(plot2(1),'DisplayName','50%');
set(plot2(2),'DisplayName','10%');
set(plot2(3),'DisplayName','0%');
set(plot2(4),'DisplayName','90%');

% 创建 xlabel
xlabel({'time(min)'},'FontSize',11);

% 创建 title
title({'The variance of velocity'},'FontSize',11);

% 创建 ylabel
ylabel({'speed(km/h)'},'FontSize',11);

box(axes3,'on');
% 创建 legend
legend2 = legend(axes3,'show');
set(legend2,'Location','best');

