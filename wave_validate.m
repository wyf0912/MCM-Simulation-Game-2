function simulate()

global car_list;

load('data.mat');



endKm=endMilepost*1.609;

startKm=startMilepost*1.609;

lanecar=totalcar./(LanesIN+LanesDE).*(endKm-startKm)*0.08/3600/60*3600;                                   

pos=cal_pos(lanecar,startKm,endKm,5);

speed=ones(1,length(pos))*50;

type=zeros(1,length(pos));

syms t

t=@(t)4-(3-4)*log(1-t);

u=rand(1,length(pos))*(1-exp(-2));

headway=t(u);

%N=100000*length(pos);

%[n,xout]=hist(y,80);    %分区间统计随机数出现概\

%bar(xout,nn,1);  %画图验证随机数是否符合概率密度函数



car_list=[];

add_cars(pos,speed,type,headway);

cal_distance();

step(7200)

car_list;

end



function pos=cal_pos(lanecar,startKm,endKm,type)

switch type

    case 5

        route=1:135;

    case 90

        route=136:162;

    case 405

        route=163:209;

    case 520

        route=210:224;

end

pos=[];

for i=route

    temp=linspace(startKm(i),endKm(i),fix(lanecar(i))+1);

    pos=[pos,temp(1:end-1)];

end

end



function cal_distance()

global car_list;

car_list(:,2)=[car_list(2:end,1);-1]-car_list(:,1);

car_list(end,2)=0;

end



function add_cars(pos,speed,type,headway)

global car_list;

for i=1:length(pos)

    car_list=[car_list;[pos(i),0,speed(i),type(i),headway(i)]];

end

car_list=sortrows(car_list,1);

cal_distance();

end







function run()

global car_list;

car_list(:,1)=car_list(:,3)/3600+car_list(:,1);

end



function change_speed()

global car_list;

dv=car_list(:,3)-[car_list(2:end,3);0];

dv(dv<0)=0;

time=-tanh((car_list(:,5)-car_list(:,2)./car_list(:,3)*3600)/2);

delta_v=time.* (1.1+rand(length(car_list),1))*3.6-dv*0.15;

delta_v(end)=(rand()-0.5); %最前方的车速度有一点不稳定的情况

v=car_list(:,3)+delta_v;

v(v>60)=60;

v(v<0)=0;

car_list(:,3)=v;

end





function step(time)

global car_list total_km;;

for i=1:time

    change_speed()

    run()

    car_list=sortrows(car_list,1);

    cal_distance()

    if mod(i,60)==0

        %plot(car_list(:,1))

        %axis([0 6000 160 410])

        total_km=car_list(end,1)-car_list(1,1)

        draw_hotmap(i);

        drawnow;

    end

end

end



function draw_hotmap(t)
global total_km car_list;
set(gcf,'unit','centimeters','position',[8 15 30 4.6]);


hotmap_q=zeros(1,150);
hotmap=zeros(1,150);
for i=1:length(car_list)
    idx=fix((car_list(i,1)-car_list(1,1))/total_km*149)+1;
    hotmap_q(idx)=hotmap_q(idx)+car_list(i,3);
    hotmap(idx)=hotmap(idx)+1;
end
hotmap=interp1([1:150],hotmap,[1:0.1:150]);
hotmap_q=interp1(1:150,hotmap_q-min(hotmap_q),1:0.1:150);

hotmap_q=hotmap_q+0.6*hotmap_q.*(hotmap-min(hotmap))./(max(hotmap)-min(hotmap));

%高斯滤波下
G= fspecial('gaussian', [1 30], 2);
hotmap_q = imfilter(hotmap_q,G,'same');

subplot(211);
image(hotmap)
title(sprintf('Time(min):%d',t/60));
subplot(212);
image(hotmap_q/40)
title(sprintf('Time(min):%d',t/60));
colormap jet
end