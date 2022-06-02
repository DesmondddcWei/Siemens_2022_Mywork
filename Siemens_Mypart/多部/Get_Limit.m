function Get_Limit(~,~)
%输入： 每部电梯分配到的所有内外呼
%输出： 每部电梯所有的极限楼层          为啥find函数的用法变了？？
global Elevator
for k = 1:6 %六部都判断一遍
    %k = 1; % 让k = 1
      %------------------------------------------  
      if size(find(Elevator{1,k}.up,1,'last'),2) == 0 %最高上呼
          Elevator{1,k}.high_up = 0;
      else
          Elevator{1,k}.high_up = find(Elevator{1,k}.up,1,'last'); %最高上呼
      end
      %-----------
      if size(find(Elevator{1,k}.down,1,'last'),2) == 0 %最高下呼
          Elevator{1,k}.high_down = 0;
      else
          Elevator{1,k}.high_down = find(Elevator{1,k}.down,1,'last'); %最高下呼
      end
      %---------------
      if size(find(Elevator{1,k}.up,1,'first'),2) == 0 %最低上呼
          Elevator{1,k}.low_up = 0;
      else
          Elevator{1,k}.low_up = find(Elevator{1,k}.up,1,'first'); 
      end
      %----------------
      if size(find(Elevator{1,k}.down,1,'first'),2) == 0 %最低下呼
          Elevator{1,k}.low_down = 0;
      else
          Elevator{1,k}.low_down = find(Elevator{1,k}.down,1,'first'); 
      end
      %-----------------高内呼
     
      %-------------------低内呼    
         Elevator{1,k}.high_inner= find(Elevator{1,k}.inner,1,'last'); %最高内呼
         Elevator{1,k}.low_inner = find(Elevator{1,k}.inner,1,'first'); %最高内呼
             
end
end