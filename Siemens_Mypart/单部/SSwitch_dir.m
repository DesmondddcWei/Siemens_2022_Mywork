function SSwitch_dir(~,~) %必须要在极限层时，先把stopfloor制成0，然后才能switch
%上下行状态切换模块 在最高或最低层  要先于上下行状态打开模块） 已迁移
%输入： 当前楼层是不是最高、低的停止楼层（stopfloor）该楼层为10或者该楼层以上没有stopfloor为1时
%输出： 改变状态，复位。静止状态为1 
global Elevator 
%for k = 1:6 %六部都判断一遍
    k = 1;
      %------------------------------------------  
      sum1 = 0;
      if Elevator{1,k}.state(1,2) == 1 %上行状态为1时
          if Elevator{1,k}.floor == 10
              Elevator{1,k}.state(1,2) = 0;
              Elevator{1,k}.state(1,1) = 1; %静止状态置1 
          else
              for c = (Elevator{1,k}.floor + 1) :1: 10 %计算该楼层以上的停层数
                 sum1 = sum1 + Elevator{1,k}.StopFloor(1,c);  %计算当前楼层以上的Stopfloor
              end 
              if sum1 == 0
                  Elevator{1,k}.state(1,2) = 0;
                  Elevator{1,k}.state(1,1) = 1; %静止状态置1  
              end
          end
      end
%           for c = Elevator{1,k}.floor :1: 10
%               sum1 = sum1 + Elevator{1,k}.StopFloor(1,c);  %计算当前楼层以上的Stopfloor
%           end
%           if (sum1 == 0 || Elevator{1,k}.floor == 10) %为10楼的时候，强制换状态
%               Elevator{1,k}.state(1,2) = 0;
%               Elevator{1,k}.state(1,1) = 1; %静止状态置1 
%           end
      
      %-------------------
      sum2 = 0;
      if Elevator{1,k}.state(1,3) == 1 %上行状态为1时
          if Elevator{1,k}.floor == 1
              Elevator{1,k}.state(1,3) = 0;
              Elevator{1,k}.state(1,1) = 1; %静止状态置1 
          else
              for c = (Elevator{1,k}.floor - 1) :-1: 1 %计算该楼层以下的停层数
                 sum2 = sum2 + Elevator{1,k}.StopFloor(1,c);  %计算当前楼层以上的Stopfloor
              end 
              if sum2 == 0
                  Elevator{1,k}.state(1,3) = 0;
                  Elevator{1,k}.state(1,1) = 1; %静止状态置1  
              end
          end
      end
      %---------------------
%       sum2 = 0;
%       if Elevator{1,k}.state(1,3) == 1 %下行状态为1时
%           for c = Elevator{1,k}.floor :-1: 1
%               sum2 = sum2 + Elevator{1,k}.StopFloor(1,c);  %计算当前楼层以上的Stopfloor
%           end
%           if (sum2 == 0 || Elevator{1,k}.floor == 1)
%               Elevator{1,k}.state(1,3) = 0; %下行状态置0
%               Elevator{1,k}.state(1,1) = 1; %静止状态置1 
%           end
%       end
      %----------------------    
end
%end