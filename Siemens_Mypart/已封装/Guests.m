function Struct_Guest = Guests(total_time,pop) %得到一个描述乘客的结构体
% 输出： 包括乘客的信息 平均用时 最大用时等等
     Struct_Guest.GuestsInfo = Get_Guests(total_time,pop,3);
     Struct_Guest.AverageWating = 0;
     Struct_Guest.AverageStaying = 0;
     Struct_Guest.AverageAll = 0;
     Struct_Guest.LongestWating = 0;
     Struct_Guest.LongestStaying = 0;
     Struct_Guest.LongWatingRatio = 0;
     Struct_Guest.LongStayingRatio = 0;
     Struct_Guest.GoingDistance = zeros(1,6); %六部梯各走过的路程 能耗指标
     Struct_Guest.StopTime = zeros(1,6);      %六部梯各停层次数，能耗指标
end