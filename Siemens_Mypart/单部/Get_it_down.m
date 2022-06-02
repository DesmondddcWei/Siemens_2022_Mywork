function Get_it_down()

%输出：让电梯的楼层数+1或者减1 如果上下行状态都为0，不变
% 电机运转，楼层变化模块
global Elevator    
    k = 1;
    now = Elevator{1,k}.floor;
    if Elevator{1,k}.state(1,2) %如果上行状态为1
       now = now + 1; 
    end

    if Elevator{1,k}.state(1,3) %如果下行状态为1
       now = now - 1; 
    end
    Elevator{1,k}.floor = now;

    Switch_dir()
end