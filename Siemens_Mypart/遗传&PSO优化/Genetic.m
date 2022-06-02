
%% 该代码为遗传算法的蒙特卡洛算法系数优化
% 清空环境变量
clc
clear
% 
%% 电梯和客流初始化 需要运行一次
clc
clear
global Elevator
global guest_matrix 
Elevator = {}; %电梯的所有信息
guest_matrix = {}; %乘客和乘客组的所有信息
Elevator = Get_Initial();
%电梯初始化结束aa
total_time = 300; %设定参数 总仿真时间
pop = 100;        %设定参数 需求个数
test_time = 10;    %产生的客流模型的个数
%测试的次数，由此产生若干种随机模型，但是要把产生的数据保留住
%保留住才可以去测试参数调整之后的电梯
%load default_matrix_fair.mat 

%load guest_5.5.mat
%load 5.10_posi.mat
% 遗传算法参数初始化
load 5.10_exp.mat
%% 

maxgen = 10;                         %进化代数，即迭代次数
sizepop = 10;                        %种群规模
pcross = [0.1];                       %交叉概率选择，0和1之间
pmutation = [0.2];                    %变异概率选择，0和1之间

%节点总数
%numsum=inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum;

lenchrom=ones(1,5); %令其变成 1行 5列  一共有5个参数 
%               分别为 para1 para2  （para3）  para4  Q1   Q2 
%               默认值为 20    60    （20）   0.008  1    1
%               把para1 和 2 的值确定之后，可以直接确定para3的值
%                                    
bound=[ 20   30 ; ... % para1
        40   70; ...  % para2
        0.003  0.016;... % para4
        0.5    5;...     % Q1
        0.5    5];      %  Q2
    %数据范围

%------------------------------------------------------种群初始化--------------------------------------------------------
individuals=struct('fitness',zeros(1,sizepop), 'chrom',[]);  %将种群信息定义为一个结构体
avgfitness=[];                      %每一代种群的平均适应度
bestfitness=[];                     %每一代种群的最佳适应度
bestchrom=[];                       %适应度最好的染色体
%初始化种群
% 
%% 这里只能运行一次！！！！！

for indi_num = 1:sizepop       %第i行
    %i = 3;
    %随机产生一个种群
    individuals.chrom(indi_num,:)=Code(lenchrom,bound);    %编码（binary和grey的编码结果为一个实数，float的编码结果为一个实数向量）
    x=individuals.chrom(indi_num,:);
    para1 = x(1);
    para2 = x(2);
    para3 = 100 - para1 - para2;
    para4 = x(3);
    Q1 = x(4);
    Q2 = x(5);
    %计算适应度
    individuals.fitness(1,indi_num) = MenterCalo(total_time,pop,para1,para2,para3,para4,Q1,Q2);
%    Elevator = {};
%    Get_Initial(); % 电梯信息复位
    %这个适应度是越大越好的                            
    %individuals.fitness(i)=fun(x,inputnum,hiddennum,outputnum,net,inputn,outputn);   %染色体的适应度
end

% 
% 

FitRecord=[];
%找最好的染色体
[bestfitness bestindex]=max(individuals.fitness);
% 

bestchrom=individuals.chrom(bestindex,:);  %最好的染色体
avgfitness=sum(individuals.fitness)/sizepop; %染色体的平均适应度
% 记录每一代进化中最好的适应度和平均适应度
traceone=[avgfitness bestfitness]; 
% 
 
% 迭代求解最佳初始阀值和权值
% 进化开始
for indi_num=1:maxgen
    indi_num
    sizepop = size(individuals.chrom,1);
    % 选择
    individuals=Select(individuals,sizepop); 
    avgfitness=sum(individuals.fitness)/sizepop;
    %交叉
    individuals.chrom=Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
    % 变异
    individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,indi_num,maxgen,bound);
    
    % 计算适应度 
    for j=1:size(individuals.chrom,1)
        
        %---------
        x=individuals.chrom(j,:); %解码
        para1 = x(1);
        para2 = x(2);
        para3 = 100 - para1 - para2;
        para4 = x(3);
        Q1 = x(4);
        Q2 = x(5);
        %计算适应度
       % individuals.fitness(j) = MenterCalo(total_time,pop,para1,para2,para3,para4,Q1,Q2);
        %---------
    end
    
  %找到最小和最大适应度的染色体及它们在种群中的位置
    [newbestfitness,newbestindex]= max(individuals.fitness);
    [worestfitness,worestindex]= min(individuals.fitness);
    % 代替上一次进化中最好的染色体
    
    if bestfitness < newbestfitness
        bestfitness = newbestfitness;
        bestchrom = individuals.chrom(newbestindex,:); %这里是得出最好的一个种群
    end
    individuals.chrom(worestindex,:)=bestchrom; %用最好的去替代最坏的
    individuals.fitness(worestindex)=bestfitness;
    
    avgfitness=sum(individuals.fitness)/sizepop;
    
    traceone=[traceone;avgfitness bestfitness]; %记录每一代进化中最好的适应度和平均适应度
    FitRecord=[FitRecord;individuals.fitness];%记录每一次迭代中，每一个个体的适应度值
end

%% 遗传算法结果分析 
figure(1)
[r c]=size(traceone); % trace 中包含每一次进化中的平均适应度和最佳适应度
hold on 
plot([1:r]',traceone(:,1),'r--',"LineWidth",1.5); %平均适应度
plot([1:r]',traceone(:,2),'b--',"LineWidth",1.5); %最佳适应度
hold off
title(['适应度曲线  ' '终止迭代次数＝' num2str(16)]);
xlabel('进化代数');ylabel('适应度');
legend('平均适应度','最佳适应度');
%disp('适应度                   变量');
grid on 

