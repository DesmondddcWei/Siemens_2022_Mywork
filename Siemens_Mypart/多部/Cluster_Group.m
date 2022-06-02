function Best_num = Cluster_Group(need_floor,need_dir,...
                                para1,para2,para3,para4,...
                                Q1,Q2)
%群控算法模块
%----------------------------
%输入：暂定的优化参数
%输出：最佳电梯序号
% para1 para2 para3 para4 对于非静止状态的打分 1 2 3 的和必须是100
% Score(1,k) = 20 * temp + 60 * exp(-0.008 * sqrt(c)) + 20 * e;
% Score(1,k) = para1 * temp + para2 * exp(-para4 * sqrt(c)) + para3 * e; 对于
% Q1，Q2 对于静止状态的打分
% Score(1,k) = 100 - 1* a +  * total; %暂时没有给系数，应该要给
% Score(1,k) = 100 - Q1* a - 1 +  Q2* total; %暂时没有给系数，应该要给
% 群控算法模块 
global Elevator
% 输入： 1、每一部电梯的 状态，楼层、状态、内外呼分配
%  2、新增的外呼 方向、楼层
% 输出： 一个数字，表示分配给的电梯的标号
% 中间输出： 每一个电梯的打分
Score = zeros(1,6);
 
%need_floor = 2;
%need_dir = 0; %需求的方向，0为上呼，1为下呼
for k = 1:6 %六部都判断一遍 
%k = 1; %先让k = 1    先用1号梯，之后一定要循环
        F1 = Elevator{1,k}.floor; %当前楼层在F1中
        %------------------------------------------------------
        if Elevator{1,k}.state(1,2) == 1  %如果是上行状态
        % **************************************************************
           if need_dir == 0 %如果是上外呼
               %------------------------
               if need_floor >= F1   %如果上外呼大于当前层
                   %①得到最高的上呼或者内呼层 a1
                   a1 = F1;
                   for i = F1 : 10  %如果有内呼或者上呼，就置为1
                       if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.up(1,i) == 1)
                           a1 = i;
                       end
                   end
                   %②得到 a 呼叫层到当前层的绝对距离
                   a = abs(need_floor - F1);
                   %③得到 从当前层到呼叫楼层之间，需要停层的层数
                   b = 0;
                   for i = F1:need_floor
                       if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.up(1,i) == 1)
                           b = b + 1;
                       end
                   end
                   %④ 计算c 现有需求需要牺牲的时间
                   if a1 <= need_floor %如果新需求层高于 现有最高层 不用牺牲原有乘客的时间
                       c = 0;
                   else                  %如果新需求低于现有层
                       c1 = 0;
                       for i = (need_floor + 1) : a1  %在新的需求以上的需求楼层
                           if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.up(1,i) == 1)
                               c1 = c1 + 1;
                           end
                       end
                       c = abs(a1 - F1)*11 + (b + c1)*11 + c1 * 11 ;%这里和原来的不太一样，我觉得c1不用-1
                   % 现在的总时间 = 运行时间（不变） + 原有等待时间 + 额外等待时间
                     % 这是有道理的  原来等20s 的人可以再等 20s   可原来等了 60s 的人再等 20 s就不太行
                   end
                   %⑤ 计算e 是不是可以 双响应 还是只能单响应 还是满载了
                   if  Elevator{1,k}.inner(1,need_floor) == 1
                       e = 1; %可以双响应
                   else 
                       e = 0.3; %只能单响应  %暂时不考虑满载
                   end
               end
               if need_floor <= F1 %如果上外呼小于当前层
                   %①得到最高的上呼或者内呼层或者下呼层 a1
                   a1 = F1;
                   for i = F1 : 10  %如果有内呼或者上呼，就置为1
                       if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.up(1,i) == 1 || Elevator{1,k}.down(1,i) == 1)
                           a1 = i;
                       end
                   end 
                   %②得到最低的上呼下呼层 a2 因为内呼会被消掉的
                   a2 = F1;
                   for i = a1 : -1 : 1
                       if (Elevator{1,k}.down(1,i) == 1 || Elevator{1,k}.up(1,i) == 1 )
                           a2 = i;
                       end                      
                   end
                   %③得到 到需求层的绝对距离 a
                   a = abs(a1 - F1) + abs(a2 - a1) + abs(a2 - need_floor);
                   %    向上              向下           再向上或者向下
                   %④ 得到b 要响应需求总的停层次数 b
                   b = 0;
                   for i = F1 : a1 %向上时， 内呼和上呼 inc
                       if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.up(1,i) == 1)
                           b = b + 1;
                       end
                   end
                   for i = a1 : -1 : a2 %向上时， 只能是下呼 inc
                       if (Elevator{1,k}.down(1,i) == 1 )
                           b = b + 1;
                       end
                   end
                   if need_floor > a2 %如果需求楼层大于a2 b还需要加上 a2 到Z的停层数 只能是上呼
                       for i = a2 : need_floor
                           if (Elevator{1,k}.up(1,i) == 1 )
                               b = b + 1;
                           end
                       end
                   end
                   % ⑦ 结束处理
                   c = 0; %默认是不影响原来的需求 也有可能是太难判断了 没意义
                   e = 0.3; %默认是满载？ 我改成了单响应
               end
           end
           
           if need_dir == 1 %如果是下外呼
              %①得到最高的上呼或者内呼层或者下呼层 a1
               a1 = F1;
               for i = F1 : 10  %如果有内呼或者上呼或者下呼，就置为1
                   if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.up(1,i) == 1 || Elevator{1,k}.down(1,i) == 1)
                       a1 = i;
                   end
               end
               %②得到a 绝对距离
               a = abs(a1 - F1) + abs(a1 - need_floor);
               %③ 得到b 停层次数
               b = 0;
               for i = F1 : a1
                   if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.up(1,i) == 1 )
                       b = b + 1;
                   end                      
               end
               if need_floor < a1 %如果need_floor 小于a1 向下的时候还要考虑已分配的下呼
                   for i = a1 : -1 : need_floor
                       if (Elevator{1,k}.down(1,i) == 1)
                           b = b + 1; 
                       end
                   end
               end
               %④ 收尾操作
               c = 0; %默认不影响其他需求
               e = 0.3; %默认是单响应            
           end
           w = 4*a + 11 * b; %得出主时间 这是关键
           % 模糊映射    可以改参数
           if w < 20 
               temp = 1;
           elseif w < 60
               temp = (60 - w) / 40 ; 
           else
               temp = 0;
           end
           %打分 k是电梯的序号 其实打分和w可以放到上下状态以外
           Score(1,k) = para1 * temp + para2 * exp(-para4 * sqrt(c)) + para3 * e;
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        %*******************************************************
        if Elevator{1,k}.state(1,3) == 1  %如果是下行状态 改了
        % *****************
           if need_dir == 1 %如果是下外呼
               %------------------------
               if need_floor <= F1   %如果下外呼小于当前层
                   %①得到最高的上呼或者内呼层 a1
                   a2 = F1;
                   for i = F1 : -1 : 1  %如果有内呼或者上呼，就置为1
                       if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.down(1,i) == 1)
                           a2 = i;
                       end
                   end
                   %②得到 a 呼叫层到当前层的绝对距离
                   a = abs(need_floor - F1);
                   %③得到 从当前层到呼叫楼层之间，需要停层的层数
                   b = 0;
                   for i = F1:-1 : need_floor
                       if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.down(1,i) == 1)
                           b = b + 1;
                       end
                   end
                   %④ 计算c 现有需求需要牺牲的时间
                   if a2 >= need_floor %如果新需求层高于 现有最高层 不用牺牲原有乘客的时间
                       c = 0;
                   else                  %如果新需求低于现有层
                       c1 = 0;
                       for i = (need_floor -1) : -1 : a2  %在新的需求以上的需求楼层
                           if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.down(1,i) == 1)
                               c1 = c1 + 1;
                           end
                       end
                       c = abs(a2 - F1)*11 + (b + c1)*11 + c1 * 11 ;%这里和原来的不太一样，我觉得c1不用-1
                   % 现在的总时间 = 运行时间（不变） + 原有等待时间 + 额外等待时间
                     % 这是有道理的  原来等20s 的人可以再等 20s   可原来等了 60s 的人再等 20 s就不太行
                   end
                   %⑤ 计算e 是不是可以 双响应 还是只能单响应 还是满载了
                   if  Elevator{1,k}.inner(1,need_floor) == 1
                       e = 1; %可以双响应
                   else 
                       e = 0.3; %只能单响应  %暂时不考虑满载
                   end
               end
               if need_floor > F1 %如果下外呼大于当前层
                   %①得到最高的上呼或者内呼层或者下呼层 a2
                   a2 = F1;
                   for i = F1 : -1 : 1  %如果有内呼或者上呼，就置为1
                       if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.down(1,i) == 1)
                           a2 = i;
                       end
                   end
                   %②得到最低的上呼下呼层 a2 因为内呼会被消掉的
                   a1 = F1;
                   for i = a1 : 10
                       if (Elevator{1,k}.down(1,i) == 1 || Elevator{1,k}.up(1,i) == 1 )
                           a1 = i;
                       end                      
                   end
                   %③得到 到需求层的绝对距离 a
                   a = abs(a2 - F1) + abs(a2 - a1) + abs(a1 - need_floor);
                   %    向上              向下           再向上或者向下
                   %④ 得到b 要响应需求总的停层次数 b
                   b = 0;
                   for i = F1 : -1 :a2 %向上时， 内呼和上呼 inc
                       if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.down(1,i) == 1)
                           b = b + 1;
                       end
                   end
                   for i = a2 : a1 %向上时， 只能是下呼 inc
                       if (Elevator{1,k}.up(1,i) == 1 )
                           b = b + 1;
                       end
                   end
                   if need_floor < a1 %如果需求楼层大于a2 b还需要加上 a2 到Z的停层数 只能是上呼
                       for i = a1 : -1 :need_floor
                           if (Elevator{1,k}.down(1,i) == 1 )   %??????????????????????????????????????????????
                               b = b + 1;
                           end
                       end
                   end
                   % ⑦ 结束处理
                   c = 0; %默认是不影响原来的需求 也有可能是太难判断了 没意义
                   e = 0.3; %默认是满载？ 我改成了单响应 和原来的不一样
               end
           end
           if need_dir == 0 %如果是上外呼
              %①得到最高的上呼或者内呼层或者下呼层 a1
               a2 = F1;
               for i = F1 :-1: 1  %如果有内呼或者上呼或者下呼，就置为1
                   if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.up(1,i) == 1 || Elevator{1,k}.down(1,i) == 1)
                       a2 = i;
                   end
               end
               %②得到a 绝对距离
               a = abs(a2 - F1) + abs(a2 - need_floor);
               %③ 得到b 停层次数
               b = 0;
               for i = F1 : -1 :a2
                   if (Elevator{1,k}.inner(1,i) == 1 || Elevator{1,k}.down(1,i) == 1 )
                       b = b + 1;
                   end                      
               end
               if need_floor > a2 %如果need_floor 小于a1 向下的时候还要考虑已分配的下呼
                   for i = a2 : need_floor
                       if (Elevator{1,k}.up(1,i) == 1)
                           b = b + 1; 
                       end
                   end
               end
               %④ 收尾操作
               c = 0; %默认不影响其他需求
               e = 0.3; %默认是单响应            
           end
           w = 4 * a + 11 * b; %得出主时间 这是关键
           % 模糊映射    可以改参数
           if w < 20 
               temp = 1;
           elseif w < 60
               temp = (60 - w) / 40 ; 
           else
               temp = 0;
           end
           %打分 k是电梯的序号
           Score(1,k) = para1 * temp + para2 * exp(-para4 * sqrt(c)) + para3 * e;
        end
        %***********************************************
        %静止状态
        if  Elevator{1,k}.state(1,1) == 1 %如果是静止状态
            total = 0;
            a = abs(F1 - need_floor); %总距离
            %总停层数量 total 没有优化过，没有考虑方向
            total = total + sum(Elevator{1,k}.up);
            total = total + sum(Elevator{1,k}.down);
            total = total + sum(Elevator{1,k}.inner);
            Score(1,k) = 100 - Q1 * a - Q2 * total; %暂时没有给系数，应该要给
            
        end
        %################
        %打分判断 在k电梯号循环之外
        Max_score = max(Score);
        A =  find(Score == Max_score);
        Best_num = A(1); %给找到的第一个 位置序号
end

end
        
        

