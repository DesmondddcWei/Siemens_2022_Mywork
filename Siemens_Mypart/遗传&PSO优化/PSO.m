%% 该代码为基于PSO和BP网络的预测

%% 清空环境
clc
clear
global Elevator
global guest_matrix 
Elevator = {}; %电梯的所有信息
guest_matrix = {}; %乘客和乘客组的所有信息
Elevator = Get_Initial();

total_time = 300; %设定参数 总仿真时间
Pop = 100;        %设定参数 需求个数
test_time = 10;    %产生的客流模型的个数
%测试的次数，由此产生若干种随机模型，但是要把产生的数据保留住
%保留住才可以去测试参数调整之后的电梯
%load default_matrix_fair.mat 
%load guest_5.5.mat
load 5.10_posi.mat
%% 

% 参数初始化
%     para1 = 20;
%     para2 = 60;
%     para3 = 20;
%     para4 = 0.008;
%     Q1 = 1;
%     Q2 = 1;
    % %输入：暂定的优化参数
    % para1 para2 para3 para4 对于非静止状态的打分 1 2 3 的和必须是100
    % Score(1,k) = 20 * temp + 60 * exp(-0.008 * sqrt(c)) + 20 * e;
    % Score(1,k) = para1 * temp + para2 * exp(-para4 * sqrt(c)) + para3 * e; 对于
    % Q1，Q2 对于静止状态的打分
    % Score(1,k) = 100 - 1* a +  * total; %暂时没有给系数，应该要给
    % Score(1,k) = 100 - Q1* a - 1 +  Q2* total; %暂时没有给系数，应该要给
    % 用MainCircle替代掉了
%     bound=[ 20   30 ; ... % para1  参数的限制条件
%         50   70; ...  % para2
%         0.003  0.017;... % para4
%         0.2    5;...     % Q1
%         0.2    5];      %  Q2
%粒子群算法中的两个参数
para1_bound = [-5 5];  %中位： 25
para2_bound = [-10 10]; %中位： 60
para4_bound = [-0.007 0.007]; %中位： 0.010
Q1_bound = [-2.4 2.4]; %中位： 2.6
Q2_bound = [-2.4 2.4]; %中位： 2.6
bounds = [para1_bound;para2_bound;para4_bound;Q1_bound;Q2_bound];
%---------------------
c1 = 0.149445;
c2 = 0.149445;

maxgen = 6;   % 进化次数  
sizepop = 5;   %种群规模

pop = zeros(sizepop,5);  % pa1 pa2 pa4 Q1 Q2
V = zeros(sizepop,5);
fitness = zeros(sizepop,1);%适应度值

Vmax=0.5;
Vmin=-0.5; %速度和种群范围的限定
%% 

for i = 1:sizepop
    for j = 1 : 5 %共5个参数
        pop(i,j) = bounds(j,1) + (bounds(j,2) - bounds(j,1)) * rand;
        
    end
    %pop(i,:)=5*rands(1,21);
    V(i,:)=rands(1,5);
    
    para1 = 25 + pop(i,1);
    para2 = 60 + pop(i,2);
    para3 = 100 - para1 - para2;
    para4 = 0.01 + pop(i,3);
    Q1 = 2.6 + pop(i,4);
    Q2 = 2.6 + pop(i,5);  
    fitness(i) = MenterCalo(total_time,Pop,para1,para2,para3,para4,...
                                Q1,Q2);
    %fitness(i)=fun(pop(i,:),inputnum,hiddennum,outputnum,net,inputn,outputn);
   
end

%% 

% 个体极值和群体极值
[bestfitness bestindex]=max(fitness);
%% 

zbest = pop(bestindex,:);   %初始化 全局最佳个体
gbest = pop;    %初始化     个体历史最佳
fitnessgbest = fitness;   %个体最佳适应度值
fitnesszbest = bestfitness;   %全局最佳适应度值

%% 迭代寻优
for i=1:maxgen
    i;
    
    for j=1:sizepop
        
        %速度更新
        V(j,:) = V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,find(V(j,:)>Vmax))=Vmax;
        V(j,find(V(j,:)<Vmin))=Vmin;
        
        %种群更新
        pop(j,:)=pop(j,:)+0.2*V(j,:);
        for num = 1 : 5
            pop(j,find(pop(j,:)>bounds(num,2)))=bounds(num,2);
            pop(j,find(pop(j,:)<bounds(num,1)))=bounds(num,1);
        end
        
        %自适应变异
        pos=unidrnd(5);
        if rand>0.56    %阈值
            pop(j,pos) = bounds(pos,1) + (bounds(pos,2) - bounds(pos,1)) * rand; %自适应变异
        end
      
        %适应度值
        para1 = 25 + pop(j,1);
        para2 = 60 + pop(j,2);
        para3 = 100 - para1 - para2;
        para4 = 0.01 + pop(j,3);
        Q1 = 2.6 + pop(j,4);
        Q2 = 2.6 + pop(j,5);  
        fitness(j) = MenterCalo(total_time,Pop,para1,para2,para3,para4,...
                                    Q1,Q2);
    end
    
    for j=1:sizepop
    %个体最优更新
    if fitness(j) > fitnessgbest(j)
        gbest(j,:) = pop(j,:);
        fitnessgbest(j) = fitness(j);
    end
    
    %群体最优更新 
    if fitness(j) > fitnesszbest
        zbest = pop(j,:);
        fitnesszbest = fitness(j);
    end
    
    end
    
    yy(i)=fitnesszbest;    
        
end

%% 结果分析
plot(yy)
title(['适应度曲线  ' '终止代数＝' num2str(maxgen)]);
xlabel('进化代数');ylabel('适应度');

x=zbest;
%% 
figure(2)
%fitness = sort(fitness)
% 
fitness = fitness - 30.8;
plot(fitness)
%% 
i = 1;
 para1 = 25 + pop(i,1);
    para2 = 60 + pop(i,2);
    para3 = 100 - para1 - para2;
    para4 = 0.01 + pop(i,3);
    Q1 = 2.6 + pop(i,4);
    Q2 = 2.6 + pop(i,5);  

