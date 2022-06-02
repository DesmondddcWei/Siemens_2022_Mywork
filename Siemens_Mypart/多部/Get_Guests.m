function guest_matrix = Get_Guests(total_time,pop,mode)
%客流量发生器
% mode: 1 均匀  2 泊松  3 指数
% mode：
%输入： total_time 仿真总时间，以s为单位，pop产生需求的总数，整数 
%
% 人流量平均分布的模型，不存在人流量最大的lambda时间点
%泊松分布的lambda是单位时间内随机时间的平均发生次数 lambda越大，说明人流量越大，
%tic

%total_time = 300; %总仿真时间为300s
% require_inter = 3; %统计时间间隔为3s 也就是时钟周期为3，3s产生一次需求
% require_amount = total_time / require_inter; %总需求量，也就是总人数 300 / 3 为100个需求
%pop = 100;
require_amount = pop ;  %需求数量就是人数，每个需求就是一个人，无非是时间点不同
require_time = zeros(1,require_amount);
%guest_matrix = zeros(pop,8);

%max_time_radio = 0.5; %在表示认为在总时间*0.5的时间点为需求最大的平均点
%----------
if mode == 1  %均匀分布
    for i = 1:require_amount
        require_time(i) = rand * total_time; %得到需求产生的时间点（在0和total_time之间）（均匀分布）
        %require_time(i) = max_time_radio *(1 + randn)* total_time;    %(在0.5*total_time的时间点出现最大的需求量)
        %require_time(i) = max_time_radio *(1 + normrnd(0,0.2)) * total_time;    %(在0.5*total_time的时间点出现最大的需求量)
    end
end
%-------------
if mode == 2  %泊松分布
    for i = 1:require_amount
        require_time(i) = normrnd(150,20);
    end
end
%--------------
if mode == 3  %指数分布
    for i = 1:require_amount
    require_time(i) = exprnd(130);
        while 1
            if require_time(i) > 300
                require_time(i) = require_time(i) - 300;
            end
            if require_time(i) < 300
                break;
            end
        end
    end
end

require_time = sort(require_time);
% 起始楼层随机分配
%确定每一个楼层，需求出现的比例 共10个楼层 每个楼层分配的比例自己设定
% scatter(1:require_amount,require_time)
%-----------------------------------------------------从weight_a得到weight_c
weight_a = ones(1,10); %默认每一个楼层的出现比例时一样的
weight_c = weight_A2C(weight_a);
%-------------------------------------------------------
start_floor = zeros(pop,1);
for k = 1:pop
    start_floor(k,1) = rand_floor(weight_c);
end
% 目标楼层随机分配 在确定了起始楼层的基础上确定目标楼层
%默认 起始楼层若不为1楼，去1楼的概率为0.4 其实是4\13 为离开概率（去1楼）
end_floor = zeros(pop,1);
i = 1;
for floor = start_floor'   
    if  floor ~= 1
        c = floor;
        a1 = [4,ones(1,9)];
        c1 = weight_A2C(a1);
        while(c == floor)                          
           c = rand_floor(c1);
        end
        end_floor(i,1) = c;
        i = i + 1;
    else
        c = 1;
        a1 = ones(1,9);
        c1 = weight_A2C(a1);
        while(c == floor)                        
            c = rand_floor(c1) + 1;
        end
        end_floor(i,1) = c;
        i = i + 1;
    end
end
% ---------------乘客体重模型 50 70 90  比例是 1 ： 8 ： 1
weight_people = zeros(pop,1);
for num = 1:pop
    c = rand;
    if (c < 0.1)
        weight_people(num,1) = 50;
    elseif (c <= 0.9)
        weight_people(num,1) = 70;
    else
        weight_people(num,1) = 90;        
    end
end

% 随机需求矩阵 创建
guest_matrix = zeros(pop,9); %要8列，需求的序号 发起时间点 起始楼层 目标楼层 状态 等待时间 乘梯时间 分配号数 乘客体重
guest_matrix(:,1) = 1:pop;
guest_matrix(:,2) = require_time';
guest_matrix(:,3) = start_floor;
guest_matrix(:,4) = end_floor;
guest_matrix(:,5) = zeros(pop,1); %表示是否进入电梯内了 
% 0表示需求没出现，1表示出现了没进入 2表示进入电梯，没有到达指定楼层 3表示到达了指定楼层并且离开
guest_matrix(:,6) = zeros(pop,1); %表示等待时间 从5列变为1到进入电梯（变为2）
guest_matrix(:,7) = zeros(pop,1); %表示乘梯时间 从5列变为2到离开电梯（变为3）
guest_matrix(:,8) = zeros(pop,1); %表示该乘客外呼分配给的电梯号数
guest_matrix(:,9) = weight_people; %表示 乘客的体重
%toc
end