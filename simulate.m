function simulate()
global car_list startKm endKm totalcar LanesIN LanesDE auto_ratio;
load('data.mat');
endKm=endMilepost*1.609;
startKm=startMilepost*1.609;
lanecar=totalcar./(LanesIN+LanesDE).*(endKm-startKm)*0.08/3600/60*3600;                                   
pos=cal_pos(lanecar,startKm,endKm,5);
auto_ratio=0.5;
%lanecar_add=[0;totalcar(2:end)-totalcar(1:end-1)]./(LanesIN+LanesDE)*0.08/3600
%pos_add=cal_pos(lanecar,startKm,endKm,5);
speed=ones(1,length(pos))*50;
type=ones(1,length(pos)).*(rand(1,length(pos))<auto_ratio); 
headway=cal_headway(length(pos));

%N=100000*length(pos);
%[n,xout]=hist(y,80);    %???????????????
%bar(xout,nn,1);  %??ͼ?֤????????ϸ??ܶȺ??
car_list=[];
add_cars(pos,speed,type,headway);
cal_distance();
step(7200)
car_list;
end

function headway=cal_headway(len)
syms t;
t=@(t)4-(6-4)*log(1-t);
u=rand(1,len)*(1-exp(-2));
headway=t(u)/(1-exp(-2));
end

function pos=cal_pos(lanecar,startKm,endKm,type)
global road_start_km road_end_km total_km route ;
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
road_start_km=startKm(route(1));
road_end_km=endKm(route(end));
total_km=road_end_km-road_start_km;
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
%car_list=sortrows(car_list,1);
%cal_distance();
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
delta_v(end)=(rand()-0.5); %?ǰ???ĳ???????㲻??????
v=car_list(:,3)+delta_v;
v(v>60)=60;
v(v<0)=0;
car_list(:,3)=v;
end

function num_change()
global car_list road_start_km road_end_km totalcar route LanesIN LanesDE;
global auto_ratio;
idx=find(car_list(:,1)>road_end_km);
car_list(idx,:)=[];
if rand()<totalcar(route(1))/(LanesIN(route(1))+LanesDE(route(1)))/24/3600
    pos=ones(1,1)*road_start_km-(1:1)*0.05;
    speed=ones(1,1)*50;
    type=zeros(1,1).*(rand(1,1)<auto_ratio);
    add_cars(pos,speed,type,cal_headway(1));
end
if rand()<0.01 %???·?߼?복???ĸ??    pos=rand(1,1)*(road_end_km-road_start_km)+road_start_km;
    speed=ones(1,1)*30;
    type=zeros(1,1);
    add_cars(pos,speed,type,cal_headway(1));
end
end

function step(time)
global car_list;
for i=1:time
    change_speed()
    run()
    num_change()
    car_list=sortrows(car_list,1);
    cal_distance()
    if mod(i,60)==0
        %plot(car_list(:,1))
        %axis([0 6000 160 410])
        draw_hotmap();
        drawnow;
    end
end
end


function draw_hotmap()
global total_km car_list;
hotmap=zeros(1,fix(total_km/1.2)); %150
set(gcf,'unit','centimeters','position',[8 15 30 2]);
for i=1:length(car_list)
    idx=fix((car_list(i,1)-car_list(1,1))/total_km*(fix(total_km/1.2)-1))+1;
    if idx>=0
        hotmap(idx)=hotmap(idx)+1;
    end
end
hotmap=interp1([1:fix(total_km/1.2)],hotmap,[1:0.1:fix(total_km/1.2)]);
image(hotmap)
colormap jet
end