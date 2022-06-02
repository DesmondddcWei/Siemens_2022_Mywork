function MainCircle(total_time,pop,test, ...
                                para1,para2,para3,para4,...
                                Q1,Q2)
%主循环函数 
%输入： 乘客矩阵里的信息 1、乘客数量 2、仿真总时间 3、测试矩阵序号，是在guest_matrix里的序号
global guest_matrix 
global Elevator 
%------------------------
%-----------------------
need_num = 1; %初始化第一个乘客的序号
guest_matrix{1,test}.GuestsInfo(:,2) = guest_matrix{1,test}.GuestsInfo(:,2).*100; %时间去乘100，为了方便，之后会除回来
%total_time = 300; %仿真的时间长度
%pop = 100; %总需求数
%上下行楼层变化的标志初始化
flag1 = zeros(1,6);
flag2 = zeros(1,6);
oritime1 = zeros(1,6);
oritime2 = zeros(1,6);

for time = 1:total_time*100 %把1s 分成100份，时钟统一
    
    % ---------------------￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥
    %1、 if式  如果i到了下一个需求出现的时间（next_need_time）  需求出现， guest 0->1开始等待电梯
%               给群控函数，分配给电梯 
%               nnt给下一个
%              （如果已经是最后一个，就让flag为1，不再产生需求了）
%              get_stopfloor
%              get_dir
%              get_limit          出现了新的外呼，就去判断一次
    if abs(time - guest_matrix{1,test}.GuestsInfo(need_num,2)) < 1   %出现了新的需求
        
        
       %群控部分开始#########
       %
       start_floor = guest_matrix{1,test}.GuestsInfo(need_num,3);
       target_floor = guest_matrix{1,test}.GuestsInfo(need_num,4);
       
       if target_floor > start_floor %上呼或者是下呼判断
           need_dir = 0; %上呼
       else
           need_dir = 1; 
       end
       Best_num = Cluster_Group(start_floor,need_dir,para1,para2,para3,para4,Q1,Q2); %调用群控模块
       guest_matrix{1,test}.GuestsInfo(need_num,8) = Best_num;
       if need_dir == 0
           Elevator{1,Best_num}.up(1,start_floor) = 1;
       else
           Elevator{1,Best_num}.down(1,start_floor) = 1;
       end
         
       %---------------原来的部分
%        start_floor = guest_matrix(need_num,3);
%        target_floor = guest_matrix(need_num,4);
%        %-----群控部分
%        %暂时替代：
%        if target_floor > start_floor
%            Elevator{1,k}.up(1,start_floor) = 1; %先直接给1号电梯
%        else
%            Elevator{1,k}.down(1,start_floor) = 1; 
%        end
%        guest_matrix(need_num,8) = 1; %先分配给1号电梯
       %-----群控部分结束
       guest_matrix{1,test}.GuestsInfo(need_num,5) = 1; %变为等待状态
       need_num = need_num + 1;   %需求给下一个
       %群控部分结束#########
       %-------------------------------调试
       
%        if ( test == 3 && time > 20000 && Best_num == 3) %出现新需求处的断点
%            br = 1;
%        end
%-----------------------------------------    


       if need_num > pop %需求到了一个不存在的地方
          break; %结束主循环 
       end
       Get_Limit();
       Get_StopFloor();
       Get_dir();     
    end
%end
%

%end             %%%%%%%%%%%%%%%%%%%%%%%%%%%调试用的end 只分配
% 应该和上面连起来
    
    %加一个判断StopFloor
     %得到停止楼层 改了之后，小于等于的时候也可以登记上，反正停层之后可以消内外呼
         %得到方向
       
%    ----------------------------------  ￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥
    %我把for循环的起始点放在了这里
    for k = 1:6  %每部电梯都需要循环一次
%     3、电机运转   相当于其实已经在走了，但是让楼层过个1.5s再变化
%        if 模块进入条件： 上下行状态里面有一个为1  并且不是停层状态 
%            装载一个i到oritime表示现在的时间 存着  当新的i与oritime大于100*2 （让楼层不要变化太快，也不要太慢，否则会影响群控的）（1.25s走一层）楼层+1  不然楼层增加的太快了，我的时间都是给够的
%            ***然后让每一个为1 等待的guest的等待时间+4s （从一楼到另一楼的运行时间）
         %k = 1;
%          if (Elevator{1,k}.state(1,3) == 1 && Elevator{1,k}.floor == 2)
%              fprintf("到了1")
%          end
         %----------------
         
         now = Elevator{1,k}.floor;    
        if (Elevator{1,k}.state(1,2) == 1 && flag1(1,k) == 0)%如果上行状态为1 并且第一次出现了上行状态，装载时间
           oritime1(1,k) = time; 
           flag1(1,k) = 1;
        end
        if (Elevator{1,k}.state(1,2) == 1 && flag1(1,k) == 1 && (time - oritime1(1,k) > 50*4))%如果上行状态为1 并且第一次出现了上行状态，装载时间
           now = now + 1; 
           %-------------
           if k == 3
               bb = 1;
           end
           %------------
           guest_matrix{1,test}.GoingDistance(1,k) = guest_matrix{1,test}.GoingDistance(1,k) + 1; %test中，第k部梯走过的距离数加1
           flag1(1,k) = 0; %需要重新装载时间
           Elevator{1,k}.floor = now;
           %------------
           for y = 1:(need_num-1) %让正在等待这一个电梯的每一个乘客等待时间+4 
               %因为need_num始终指向下一个need的序号，所以-1可以提高效率，对执行没有影响
               if (guest_matrix{1,test}.GuestsInfo(y,5) == 1 && guest_matrix{1,test}.GuestsInfo(y,8) == k) 
                 guest_matrix{1,test}.GuestsInfo(y,6) = guest_matrix{1,test}.GuestsInfo(y,6) + 4;                 
              end
              %乘坐这个电梯的人乘坐电梯时间+4
              if (guest_matrix{1,test}.GuestsInfo(y,5) == 2 && guest_matrix{1,test}.GuestsInfo(y,8) == k) 
                 guest_matrix{1,test}.GuestsInfo(y,7) = guest_matrix{1,test}.GuestsInfo(y,7) + 4;                 
              end
           end
           %------------
        end
        if Elevator{1,k}.state(1,2) == 0 
           flag1(1,k) = 0; 
        end
        
        %--------------------------下行状态
        if (Elevator{1,k}.state(1,3) == 1 && flag2(1,k) == 0)%如果下行状态为1 并且第一次出现了上行状态，装载时间
           oritime2(1,k) = time; 
           flag2(1,k) = 1;
        end
        if (Elevator{1,k}.state(1,3) == 1 && flag2(1,k) == 1 && (time - oritime2(1,k) > 50*4))%如果上行状态为1 并且第一次出现了上行状态，装载时间
           now = now - 1;
           %---------
           if k == 3
               bb = 1;
           end
           %-----------
           guest_matrix{1,test}.GoingDistance(1,k) = guest_matrix{1,test}.GoingDistance(1,k) + 1;
           flag2(1,k) = 0; %需要重新装载时间          ____________________________________++原来是100感觉需求来的太快，电梯走的太慢了
           Elevator{1,k}.floor = now;
           % ------------时间变化
           for y = 1:(need_num-1) %让正在等待这一个电梯的每一个乘客等待时间+4 
               %因为need_num始终指向下一个need的序号，所以-1可以提高效率，对执行没有影响
               if (guest_matrix{1,test}.GuestsInfo(y,5) == 1 && guest_matrix{1,test}.GuestsInfo(y,8) == k) 
                 guest_matrix{1,test}.GuestsInfo(y,6) = guest_matrix{1,test}.GuestsInfo(y,6) + 4;                 
              end
              %乘坐这个电梯的人乘坐电梯时间+4
              if (guest_matrix{1,test}.GuestsInfo(y,5) == 2 && guest_matrix{1,test}.GuestsInfo(y,8) == k) 
                 guest_matrix{1,test}.GuestsInfo(y,7) = guest_matrix{1,test}.GuestsInfo(y,7) + 4;                 
              end
           end
           % ---------------
        end
        if Elevator{1,k}.state(1,3) == 0
           flag2(1,k) = 0; 
        end
        %到了一个新的楼层 接下来 应该才是停层判断 楼层变化模块结束
        %     2、停层判断 
%        模块进入条件： 如果当前的楼层是stopfloor中的一个 
%        让停层状态为1        
%        {如果当前层有等待的guest为1,并且分配给了当前的电梯（用号数判断），1变成2， 
%        把这个层的外呼消除（上下都消除是可行的，因为只有一个），，
%        再把这个进入电梯的guest带来的inner置1
%        再把现在的i - 需求产生时间 给这个guest作为等待时间}
%        {如果有guest是2，并且分配给的是当前的电梯，并且
%        目标层是当前层，置为3  把现在的i-需求产生的时间-等待时间 = 乘梯时间}
%        上下行状态转化 switch_dir() ，把这个stopfloor消除 （stopfloor必须最后再删除）
%        ***然后让每一个为1 等待的guest的等待时间+5 （停层的时间）
       %k = 1; %强调现在只是1号梯
       now_floor = Elevator{1,k}.floor;
       
       %-------------------
%        if ( Elevator{1,k}.state(1,3) == 1 && k == 5 && test == 5 && time > 16000)
%            br = 1;
%        end
        if ( now_floor == 0 || now_floor == 11)
           br = 1;
       end
       %-------------------------
       
       if Elevator{1,k}.StopFloor(1,now_floor) == 1 %到了该停止的楼层
          guest_matrix{1,test}.StopTime(1,k) = guest_matrix{1,test}.StopTime(1,k) + 1;
          Elevator{1,k}.state(1,4) = 1; %让开门状态为1
          %--
%           if (now_floor == 1 && Elevator{1,k}.state(1,3) == 1)
%               rr = 1;
%           end
          %--
          for y = 1:need_num         %让外呼进入的部分
              if (guest_matrix{1,test}.GuestsInfo(y,5) == 1 && guest_matrix{1,test}.GuestsInfo(y,8) == k && guest_matrix{1,test}.GuestsInfo(y,3) == now_floor)% 有外呼在等待并且分配给了这个电梯 并且要在当前楼层！
                  guest_matrix{1,test}.GuestsInfo(y,5) = 2; %进入
                  %载重调整
                  Elevator{1,k}.Weight = Elevator{1,k}.Weight + guest_matrix{1,test}.GuestsInfo(y,9); %电梯载客重量的变化
                  %-------------满载调整
                  if Elevator{1,k}.Weight >= 1050
                     Elevator{1,k}.FullFlag = 1;
                  end
                  %-------------
                  Elevator{1,k}.up(1,now_floor) = 0; %消除外呼
                  Elevator{1,k}.down(1,now_floor) = 0; %消除外呼
                  Elevator{1,k}.inner(1,guest_matrix{1,test}.GuestsInfo(y,4)) = 1; %分配内呼
                  %guest_matrix(y,6) = (i/100) - guest_matrix(y,2); %赋予等待时间
              end
          end
          
          for y = 1:need_num         %让乘客可以出去的部分
              if (guest_matrix{1,test}.GuestsInfo(y,5) == 2 && guest_matrix{1,test}.GuestsInfo(y,8) == k && guest_matrix{1,test}.GuestsInfo(y,4) == now_floor)
                  % 有内呼在该电梯内，且目标楼层是当前楼层
                  guest_matrix{1,test}.GuestsInfo(y,5) = 3; %离开
                  %载重调整
                  Elevator{1,k}.Weight = Elevator{1,k}.Weight - guest_matrix{1,test}.GuestsInfo(y,9); %电梯载客重量的变化
                  %-------------满载调整
                  if Elevator{1,k}.Weight < 1050
                     Elevator{1,k}.FullFlag = 0;
                  end
                  %-------------
                  Elevator{1,k}.inner(1,guest_matrix{1,test}.GuestsInfo(y,4)) = 0; %消除内呼
                  %guest_matrix(y,7) = (i/100) - guest_matrix(y,2) - guest_matrix(y,6); %赋予乘梯时间
              end
          end
          %--------------------
          Elevator{1,k}.state(1,4) = 0; %让开门状态变为0
          %***************到了一个该停的层，已经把内呼、外呼、stopfloor消除掉了
          Switch_dir();%如果到了极限层，要变成静止状态
          Get_Limit();
          Get_StopFloor();%如果是静止状态，得到几个stopfloor，先让电梯进入状态动起来
          Get_dir();
          %**************
          
          %下面时间变化 
          for y = 1:need_num %让正在等待这一个电梯的每一个乘客等待时间+11 
              if (guest_matrix{1,test}.GuestsInfo(y,5) == 1 && guest_matrix{1,test}.GuestsInfo(y,8) == k) 
                 guest_matrix{1,test}.GuestsInfo(y,6) = guest_matrix{1,test}.GuestsInfo(y,6) + 11;                 
              end
              %乘坐这个电梯的人乘坐电梯时间+11
              if (guest_matrix{1,test}.GuestsInfo(y,5) == 2 && guest_matrix{1,test}.GuestsInfo(y,8) == k)
                 guest_matrix{1,test}.GuestsInfo(y,7) = guest_matrix{1,test}.GuestsInfo(y,7) + 11;                 
              end
          end
          
       end
        %调试
%         if Elevator{1,k}.floor == 10
%            fprintf("到了")
%         end
        %调试结束
%     4、 get dir  getstopfloor getlimit 只要内外呼发生了置位和复位，这里就需要判断
%        Switch_dir(); 
%        Get_Limit();
%        Get_StopFloor();%新的外呼进入之后，要让Stopfloor变化，才可以让Get_dir()可以正确判断
%        Get_dir();
    end
       %Get_StopFloor();
       
       %Get_StopFloor();
    
    %反思： Get_stopFloor如果每一层都判断，到第十层的时候，而且是上行
    %因为没有需求在十楼以上，原来10楼的外呼会被消除
    %所以，只有在产生新的内呼 新的外呼 状态切换的时候，会去重新得到stopfloor
        
    %/<主体>******************************************
end
%--------------------
%时间循环结束之后，把guest矩阵第二列的时间除以100，还原
guest_matrix{1,test}.GuestsInfo(:,2) = guest_matrix{1,test}.GuestsInfo(:,2)./100;
end