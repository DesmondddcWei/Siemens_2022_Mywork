%把电梯的数据清除
%把乘客的数据清除，只保留乘客的需求，保证公平性
function Guests_HoldNeed(test_time,pop) %%把乘客的数据清除，只保留乘客的需求，保证公平性
    %输入： test_time 模型的个数，整数
    global guest_matrix 
    for k = 1: test_time
% 输出： 包括乘客的信息 平均用时 最大用时等等
        for j = 5:8 %5 - 8列置0 体重不变化
            guest_matrix{1,k}.GuestsInfo(:,j) = zeros(pop,1);
        end
     %--------------------
         guest_matrix{1,k}.AverageWating = 0;
         guest_matrix{1,k}.AverageStaying = 0;
         guest_matrix{1,k}.AverageAll = 0;
         guest_matrix{1,k}.LongestWating = 0;
         guest_matrix{1,k}.LongestStaying = 0;
         guest_matrix{1,k}.LongWatingRatio = 0;
         guest_matrix{1,k}.LongStayingRatio = 0;
         guest_matrix{1,k}.GoingDistance = zeros(1,6); %六部梯各走过的路程 能耗指标
         guest_matrix{1,k}.StopTime = zeros(1,6);      %六部梯各停层次数，能耗指标
    end
end