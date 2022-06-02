function SGet_dir(~,~)
global Elevator
 % 选向模块(上、下行状态打开模块) *** 输入：.StopFloor floor、当前楼层 输出： state
%for k = 1:6 %六部都判断一遍
k = 1;
      %------------------------------------------  
      if sum(Elevator{1,k}.StopFloor) ~= 0     %如果stopfloor里都是0，不对上下行状态进行处理 
      
         a = find(Elevator{1,k}.StopFloor,1,'last');
         if a > Elevator{1,k}.floor &&  Elevator{1,k}.state(1,3) == 0 %下行状态为0时，才把上行状态置1
            Elevator{1,k}.state(1,2) = 1; %上行状态置1
            Elevator{1,k}.state(1,1) = 0; %静止状态置0
         end
         b = find(Elevator{1,k}.StopFloor,1,'first');
         if b < Elevator{1,k}.floor  && Elevator{1,k}.state(1,2) == 0
            Elevator{1,k}.state(1,3) = 1;
            Elevator{1,k}.state(1,1) = 0; %静止状态置0
         end  
      end
%end
end