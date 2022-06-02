function Elevator = SGet_Initial(~,~)
    global Elevator 
%创建6部的结构体
%for i = 1:6
i = 1;
    eval(['AEleva',num2str(i),'.state = [1,zeros(1,3)];']) %状态，1表示非 2为上行状态 3 为下行状态  4为停层开门状态
    eval(['AEleva',num2str(i),'.floor = 1;']) %楼层，开始时为1
    eval(['AEleva',num2str(i),'.inner = zeros(1,10);']) % 内呼需求，1表示有，0表示无 表示已经
    eval(['AEleva',num2str(i),'.up = zeros(1,10);']) % 上外呼需求  群控之后的结果
    eval(['AEleva',num2str(i),'.down = zeros(1,10);']) %下外呼需求 群控之后
    eval(['AEleva',num2str(i),'.touch = 3;'])  %1为上行接触器打开 2 为下行接触器打开 3为都不打开 
    
    eval(['AEleva',num2str(i),'.high_up = 1;'])  %最高上呼层
    eval(['AEleva',num2str(i),'.high_down = 1;'])  %最高下呼层
    eval(['AEleva',num2str(i),'.low_up = 10;'])  %最低上呼层
    eval(['AEleva',num2str(i),'.low_down = 10;'])  %最低下呼层
    
    eval(['AEleva',num2str(i),'.high_inner = 1;'])  %最高上呼层
    eval(['AEleva',num2str(i),'.low_inner = 10;'])  %最低下呼层
    
    eval(['AEleva',num2str(i),'.StopFloor = zeros(1,10);'])  %停靠楼层
    
    eval(['Elevator{',num2str(i),'} = AEleva',num2str(i),';']);
%end
end