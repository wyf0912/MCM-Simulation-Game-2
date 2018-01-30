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
%[n,xout]=hist(y,80);    %������ͳ����������ָ�\
%bar(xout,nn,1);  %��ͼ��֤������Ƿ���ϸ����ܶȺ���

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
delta_v(end)=(rand()-0.5); %��ǰ���ĳ��ٶ���һ�㲻�ȶ������
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
        draw_hotmap();
        drawnow;
    end
end
end

function draw_hotmap()
global total_km car_list;
hotmap=zeros(1,150);
for i=1:length(car_list)
    idx=fix((car_list(i,1)-car_list(1,1))/total_km*149)+1;
    hotmap(idx)=hotmap(idx)+1;
end
image(hotmap)
colormap jet
end