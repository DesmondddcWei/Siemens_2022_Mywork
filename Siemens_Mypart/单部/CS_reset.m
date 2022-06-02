function CS_reset()
global Elevator
    if   Elevator{1,k}.StopFloor(1,now) == 1   %如果当前楼层的是停层楼层
        
          %--------------------------  内外呼消除 要用状态来判断
          if Elevator{1,k}.inner(1,now) == 1 %内呼
             Elevator{1,k}.inner(1,now) =0; 
          end
          %-------------------------------上呼
          if Elevator{1,k}.up(1,now) == 1 && Elevator{1,k}.state(1,2)%上呼 且上行状态
             Elevator{1,k}.up(1,now) = 0; 
          end
          if Elevator{1,k}.up(1,now) == 1 && Elevator{1,k}.state(1,3) && Elevator{1,k}.low_up == now%上呼 且下行状态 且最低上呼层
             Elevator{1,k}.up(1,now) = 0; 
          end
          %---------------------------------下呼
          if Elevator{1,k}.down(1,now) == 1 && Elevator{1,k}.state(1,3)%下呼 且下行状态
             Elevator{1,k}.down(1,now) = 0; 
          end
          if Elevator{1,k}.down(1,now) == 1 && Elevator{1,k}.state(1,2) && Elevator{1,k}.high_down == now%下呼 且上行状态 且最高下呼层
             Elevator{1,k}.down(1,now) = 0; 
          end
     else %如果当前的楼层不是停止楼层
          pause(0.6);
     end
end