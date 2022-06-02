function Performance_Score = MenterCalo(total_time,pop,para1,para2,para3,para4,...
                                Q1,Q2)
                            %输入： 群控参数
                            %输出： 评分
       global Elevator
       global guest_matrix
       test_time = size(guest_matrix,2);
        % 主循环函数 输入：群控参数
        % 输出：仿真结果
        %----------------------
%     para1 = 20;
%     para2 = 60;
%     para3 = 20;
%     para4 = 0.008;
%     Q1 = 1;
%     Q2 = 1;
    % %输入：暂定的优化参数
    % para1 para2 para3 para4 对于非静止状态的打分 1 2 3 的和必须是100
    % Score(1,k) = 20 * temp + 60 * exp(-0.008 * sqrt(c)) + 20 * e;
    % Score(1,k) = para1 * temp + para2 * exp(-para4 * sqrt(c)) + para3 * e; 对于
    % Q1，Q2 对于静止状态的打分
    % Score(1,k) = 100 - 1* a +  * total; %暂时没有给系数，应该要给
    % Score(1,k) = 100 - Q1* a - 1 +  Q2* total; %暂时没有给系数，应该要给
    % 用MainCircle替代掉了
    
    for test = 1 : test_time
        
        MainCircle(total_time,pop,test,para1,para2,para3,para4,Q1,Q2);
                                          
        Elevator = {};   
        Elevator = Get_Initial();    % 把电梯复           
    end
    %---------------------------------------评价参数计算
    
    
    
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
%LongestWating = 0;
%LongestStaying = 0;
LongWatingRatio = 0;
LongStayingRatio = 0;
GoingDistance = zeros(1,6); %六部电梯的运行距离
StopTimes = zeros(1,6);     %六部电梯的停层次数
for model = 1 : test_time
    AverageWating = AverageWating + guest_matrix{1,model}.AverageWating;
    AverageStaying = AverageStaying + guest_matrix{1,model}.AverageStaying;
    AverageAll =  AverageAll + guest_matrix{1,model}.AverageAll;
    %LongestWating = LongestWating + guest_matrix{1,model}.LongestWating;
    %LongestStaying = LongestStaying + guest_matrix{1,model}.LongestStaying;
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
%AverageAll = AverageAll / test_time;
%LongestWating = LongestWating / test_time;
%LongestStaying = LongestStaying / test_time;
LongWatingRatio = LongWatingRatio / test_time;
LongStayingRatio = LongStayingRatio / test_time;
% 暂定一个打分分数  这里修改了已经
Performance_Score = 30 * exp(-0.02 * AverageWating) + 30 * exp(-0.025 * AverageStaying) ...
    + 20 * exp(-0.1 * sum(StopTimes) / 6) + 10 * exp(-0.1 * sum(GoingDistance) / 6 )...
    + 5 * exp(-10 * LongStayingRatio) + 5 * exp(- 50 * LongWatingRatio) ;
%客流模型复位 
%这里改了
Guests_HoldNeed(test_time,pop); %客流模型复位 

%Elevator = Get_Initial(); % 电梯信息复位

end