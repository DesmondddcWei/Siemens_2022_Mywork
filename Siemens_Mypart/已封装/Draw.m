%% 能耗 隶属度
figure(1)
x = linspace(0,150,2000);
y1 = exp(-sqrt(x));
y2 = exp(-sqrt(abs(x - 40)));
y3 = exp(-sqrt(80 - x));
for i  = 1 : length(y3)
    if isreal(y3(i)) == 0
       y3(i) = 1; 
    end
end
hold on 
plot(x(1:266),y1(1:266),"LineWidth",2);
plot(x(266:800),y2(266:800),"LineWidth",2);
plot(x(800:2000),y3(800:2000),"LineWidth",2);
hold off
legend(["乘梯时间短隶属度","乘梯时间中等隶属度","乘梯时间长隶属度"])
ylim([0 1.5])
xlim([0 100])
%%  时间 隶属度
figure(2)
x = 0 : 0.01 : 120;
y1 = zeros(1,length(x));
y2 = zeros(1,length(x));
y3 = zeros(1,length(x));
n = 1;
for r = 0 : 0.01 : 120
    if (r <= 20)
       y1(n) = 1;
       y2(n) = 0;
       y3(n) = 0;
    elseif (r <= 60)
        y1(n) = (60 - r) / 40;
        y2(n) =  (r - 20) / 40;
        y3(n) = 0;
    elseif (r <= 100)
        y1(n) = 0;
        y2(n) =  (100 - r) / 40;
        y3(n) =  (r - 60) / 40;
    else
        y1(n) = 0;
        y2(n) = 0;
        y3(n) = 1;
    end    
    n = n + 1; %序号
end

hold on 
plot(x,y1,"LineWidth",2,"color",'k');
plot(x,y2,"LineWidth",2,"color",'k');
plot(x,y3,"LineWidth",2,"color",'k');
hold off
legend(["候梯时间短隶属度","候梯时间中等隶属度","候梯时间长隶属度"])
ylim([0 1.25])
xlim([0 120])
%% 双响应 隶属度

% x = linspace(0,150,2000);
% for i = x
%     r = i;
% end

