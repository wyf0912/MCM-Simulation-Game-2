function simulate()
global car_list;
pos=[10,20,30,40,35];
speed=[60,63,65,55,60];
type=[0,0,0,0,0];
syms t
t=@(t)1-(3-1)*log(1-t);
u=rand(1,length(pos))*(1-exp(-2));
headway=t(u);
%N=100000*length(pos);
%[n,xout]=hist(y,80);    %分区间统计随机数出现概率
%nn=n/N/mean(diff(xout));
%bar(xout,nn,1);  %画图验证随机数是否符合概率密度函数

car_list=[];
add_cars(pos,speed,type,headway);
step()
car_list;
end

function cal_distance()
global car_list;
car_list(:,2)=[car_list(2:end,1);-1]-car_list(:,1);
end

function add_cars(pos,speed,type,headway)
global car_list;
for i=1:length(pos)
    car_list=[car_list;[pos(i),0,speed(i),type(i),headway(i)]];
end
car_list=sortrows(car_list,1)
cal_distance()
end

function run()
global car_list;
car_list(:,1)=car_list(:,3)+car_list(:,1)/3600;
end

function step()
run()
end