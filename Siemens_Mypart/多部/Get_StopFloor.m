function Get_StopFloor(~,~) %要在得出极限层的前提下
global Elevator
% 每部梯停止楼层登记 根据当前状态和 内呼、分配的外呼 ***这个判断应该在出现新的内呼、外呼响应的时候进行
%输入： .state  .up .down  .inner
%输出   .stopfloor
for k = 1:6 %六部都判断一遍
    %k = 1; %先让k = 1   
    now = Elevator{1,k}.floor;
    %-------------
    if (Elevator{1,k}.FullFlag == 0) %如果满载了，Stopfloor就不变化
        
    StopFloor = zeros(1,10); %为1时有效 初始化置为0 这里先删掉 在其他地方有复位
      %------------------------------------------
          if Elevator{1,k}.state(1,1) == 1 %静止状态
                 for i = 1:10
                     if Elevator{1,k}.inner(i) == 1 || ...
                        Elevator{1,k}.up(i) == 1 ||...
                        Elevator{1,k}.down(i) == 1
                        StopFloor(1,i) = 1; 
                     else
                        StopFloor(1,i) = 0; 
                     end
                 end
          end
          %-------------------------------------
          if Elevator{1,k}.state(1,2) == 1 %上行状态
              for i = 1:10
                     if ((Elevator{1,k}.inner(i) == 1 || Elevator{1,k}.up(i) == 1)...
                             && now <= i ) %上行状态下的内呼停层、上外呼
                         StopFloor(1,i) = 1; 
                     end

                     if Elevator{1,k}.down(i) == 1 && now <= i && Elevator{1,k}.high_down == i
                         %上行状态下的下外呼
                         StopFloor(1,i) = 1; 
                     end                
              end         
          end
          %---------------------------------------------
          if Elevator{1,k}.state(1,3) == 1 %下行状态
             for i = 1:10
                     if ((Elevator{1,k}.inner(i) == 1 || Elevator{1,k}.down(i) == 1)...
                             && now >= i )%下行状态下的内呼停层、下外呼
                         StopFloor(1,i) = 1; 
                     end

                     if Elevator{1,k}.up(i) == 1 && now >= i && Elevator{1,k}.low_up == i
                         %下行状态下的上外呼
                         StopFloor(1,i) = 1; 
                     end                
              end          
          end  
      %-------------------------------------------     
      Elevator{1,k}.StopFloor = StopFloor;
      end
end
end
%end