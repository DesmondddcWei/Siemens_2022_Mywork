%% 基于Matlab的电梯群控仿真模型
clear
clc
%% %% 初始化模块 要放在函数以外
global Elevator
global guest_matrix 
Elevator = {}; %电梯的所有信息
guest_matrix = {}; %乘客和乘客组的所有信息
Elevator = Get_Initial();
%电梯初始化结束aa
total_time = 300; %设定参数 总仿真时间
pop = 100;        %设定参数 需求个数
test_time = 10;    %产生的客流模型的个数
%测试的次数，由此产生若干种随机模型，但是要把产生的数据保留住
%保留住才可以去测试参数调整之后的电梯
%load default_matrix_fair.mat 
%加载之前的客流信息 让这个只加载一次，之后只是去消guest_info里面的内容

for test_num = 1 : test_time
    guest_matrix{1,test_num} = Guests(total_time,pop); %这里是直接产生test_time个模型
end
%load guest_5.5.mat
%load 5.10_posi.mat
%% 客流模型复位 和 电梯信息复位
%Guests_HoldNeed(test_time,pop); %客流模型复位
% Elevator = {};
% Elevator = Get_Initial(); % 电梯信息复位
load 5.10_exp.mat
%% 主循环 用 MenterCalo替换掉了 每次改这里的参数就可以了！！ 这里是可以使用的，
para1 = 26.55;
%for para1 = [20,21]
para2 = 58.25;
para3 = 100 - para1 - para2;
para4 = 0.0035;
Q1 = 2.02;
Q2 = 4.67;
score = MenterCalo(total_time,pop,para1,para2,para3,para4,Q1,Q2); 
% 对于非静止状态
% para1 para2 para3 para4 对于非静止状态的打分 1 2 3 的和必须是100
% Score(1,k) = 20 * temp + 60 * exp(-0.008 * sqrt(c)) + 20 * e;
% Score(1,k) = para1 * temp + para2 * exp(-para4 * sqrt(c)) + para3 * e; 对于
% Q1，Q2 对于静止状态的打分
% Score(1,k) = 100 - 1* a +  * total; %暂时没有给系数，应该要给
% Score(1,k) = 100 - Q1* a - 1 +  Q2* total; %暂时没有给系数，应该要给
% ------------------------------------------
%  %电梯信息复位和上下外呼复位
% Elevator = {};
% Elevator = Get_Initial(); % 电梯信息复位
%load default_matrix_fair.mat 
%end
%% 

%  %电梯信息复位和上下外呼复位
Elevator = {};
Elevator = Get_Initial(); % 电梯信息复位
load default_matrix_fair.mat 


%% 要看具体参数的时候再用下面这个模块，不然就只需要得出打分的分数（在上面）

%Elevator = Get_Initial();    % 把电梯复位，为下一个客流模型准备
%
% 优劣参数提取,每一个模型得出自己的参数
for model = 1 : test_time
    guest_matrix{1,model}.AverageWating = mean(guest_matrix{1,model}.GuestsInfo(:,6)) ; %平均候梯时间
    guest_matrix{1,model}.AverageStaying = mean(guest_matrix{1,model}.GuestsInfo(:,7)) ; %平均乘梯时间
    guest_matrix{1,model}.AverageAll = mean(guest_matrix{1,model}.GuestsInfo(:,6) + guest_matrix{1,model}.GuestsInfo(:,7)); %平均总乘坐时间
    guest_matrix{1,model}.LongestWating = max(guest_matrix{1,model}.GuestsInfo(:,6)) ; %最大候梯时间
    guest_matrix{1,model}.LongestStaying = max(guest_matrix{1,model}.GuestsInfo(:,7)) ; %最大乘梯时间
    %长候梯率
    guest_matrix{1,model}.LongWatingRatio = length(find(guest_matrix{1,model}.GuestsInfo(:,6) > guest_matrix{1,model}.LongestWating * 0.5 )) / pop;  
    %大于最大候梯时间的0.5就算长候梯
    %长乘梯率
    guest_matrix{1,model}.LongStayingRatio = length(find(guest_matrix{1,model}.GuestsInfo(:,7) > guest_matrix{1,model}.LongestWating * 0.5 )) / pop;
    % 0.5 就算是长候梯了
end

%
% 根据每一个模型的结论，得出一个参数集下，测试运行结束之后的结果
%
% 参数提取，每一个模型的参数都参与
AverageWating = 0;
AverageStaying = 0;
AverageAll = 0;
LongestWating = 0;
LongestStaying = 0;
LongWatingRatio = 0;
LongStayingRatio = 0;
GoingDistance = zeros(1,6); %六部电梯的运行距离
StopTimes = zeros(1,6);     %六部电梯的停层次数
for model = 1 : test_time
    AverageWating = AverageWating + guest_matrix{1,model}.AverageWating;
    AverageStaying = AverageStaying + guest_matrix{1,model}.AverageStaying;
    AverageAll =  AverageAll + guest_matrix{1,model}.AverageAll;
    LongestWating = LongestWating + guest_matrix{1,model}.LongestWating;
    LongestStaying = LongestStaying + guest_matrix{1,model}.LongestStaying;
    LongWatingRatio = LongWatingRatio + guest_matrix{1,model}.LongWatingRatio;
    LongStayingRatio = LongStayingRatio + guest_matrix{1,model}.LongStayingRatio;    
end
%运行距离和停层次数
for model = 1:test_time
    for num = 1:6
        GoingDistance(1,num) = GoingDistance(1,num) + guest_matrix{1,model}.GoingDistance(1,num);
        StopTimes(1,num) = StopTimes(1,num) + guest_matrix{1,model}.StopTime(1,num);
    end
end
%平均
GoingDistance = GoingDistance ./ test_time;
StopTimes = StopTimes ./ test_time;
AverageWating = AverageWating / test_time;
AverageStaying = AverageStaying / test_time;
AverageAll = AverageAll / test_time;
LongestWating = LongestWating / test_time;
LongestStaying = LongestStaying / test_time;
LongWatingRatio = LongWatingRatio / test_time;
LongStayingRatio = LongStayingRatio / test_time;
%% 暂定一个打分分数
Performance_Score = 30 * exp(-AverageWating) + 30 * exp(-AverageStaying) ...
    + 20 * exp(-sum(StopTimes) / 6) + 10 * exp(-sum(StopTimes) / 6 )...
    + 5 * exp(-LongStayingRatio) + 5 * exp(-LongStayingRatio);
%% 客流模型复位 和 电梯信息复位
% Guests_HoldNeed(test_time,pop); %客流模型复位
% Elevator = Get_Initial(); % 电梯信息复位







