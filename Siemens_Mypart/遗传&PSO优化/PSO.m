%% �ô���Ϊ����PSO��BP�����Ԥ��

%% ��ջ���
clc
clear
global Elevator
global guest_matrix 
Elevator = {}; %���ݵ�������Ϣ
guest_matrix = {}; %�˿ͺͳ˿����������Ϣ
Elevator = Get_Initial();

total_time = 300; %�趨���� �ܷ���ʱ��
Pop = 100;        %�趨���� �������
test_time = 10;    %�����Ŀ���ģ�͵ĸ���
%���ԵĴ������ɴ˲������������ģ�ͣ�����Ҫ�Ѳ��������ݱ���ס
%����ס�ſ���ȥ���Բ�������֮��ĵ���
%load default_matrix_fair.mat 
%load guest_5.5.mat
load 5.10_posi.mat
%% 

% ������ʼ��
%     para1 = 20;
%     para2 = 60;
%     para3 = 20;
%     para4 = 0.008;
%     Q1 = 1;
%     Q2 = 1;
    % %���룺�ݶ����Ż�����
    % para1 para2 para3 para4 ���ڷǾ�ֹ״̬�Ĵ�� 1 2 3 �ĺͱ�����100
    % Score(1,k) = 20 * temp + 60 * exp(-0.008 * sqrt(c)) + 20 * e;
    % Score(1,k) = para1 * temp + para2 * exp(-para4 * sqrt(c)) + para3 * e; ����
    % Q1��Q2 ���ھ�ֹ״̬�Ĵ��
    % Score(1,k) = 100 - 1* a +  * total; %��ʱû�и�ϵ����Ӧ��Ҫ��
    % Score(1,k) = 100 - Q1* a - 1 +  Q2* total; %��ʱû�и�ϵ����Ӧ��Ҫ��
    % ��MainCircle�������
%     bound=[ 20   30 ; ... % para1  ��������������
%         50   70; ...  % para2
%         0.003  0.017;... % para4
%         0.2    5;...     % Q1
%         0.2    5];      %  Q2
%����Ⱥ�㷨�е���������
para1_bound = [-5 5];  %��λ�� 25
para2_bound = [-10 10]; %��λ�� 60
para4_bound = [-0.007 0.007]; %��λ�� 0.010
Q1_bound = [-2.4 2.4]; %��λ�� 2.6
Q2_bound = [-2.4 2.4]; %��λ�� 2.6
bounds = [para1_bound;para2_bound;para4_bound;Q1_bound;Q2_bound];
%---------------------
c1 = 0.149445;
c2 = 0.149445;

maxgen = 6;   % ��������  
sizepop = 5;   %��Ⱥ��ģ

pop = zeros(sizepop,5);  % pa1 pa2 pa4 Q1 Q2
V = zeros(sizepop,5);
fitness = zeros(sizepop,1);%��Ӧ��ֵ

Vmax=0.5;
Vmin=-0.5; %�ٶȺ���Ⱥ��Χ���޶�
%% 

for i = 1:sizepop
    for j = 1 : 5 %��5������
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

% ���弫ֵ��Ⱥ�弫ֵ
[bestfitness bestindex]=max(fitness);
%% 

zbest = pop(bestindex,:);   %��ʼ�� ȫ����Ѹ���
gbest = pop;    %��ʼ��     ������ʷ���
fitnessgbest = fitness;   %���������Ӧ��ֵ
fitnesszbest = bestfitness;   %ȫ�������Ӧ��ֵ

%% ����Ѱ��
for i=1:maxgen
    i;
    
    for j=1:sizepop
        
        %�ٶȸ���
        V(j,:) = V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,find(V(j,:)>Vmax))=Vmax;
        V(j,find(V(j,:)<Vmin))=Vmin;
        
        %��Ⱥ����
        pop(j,:)=pop(j,:)+0.2*V(j,:);
        for num = 1 : 5
            pop(j,find(pop(j,:)>bounds(num,2)))=bounds(num,2);
            pop(j,find(pop(j,:)<bounds(num,1)))=bounds(num,1);
        end
        
        %����Ӧ����
        pos=unidrnd(5);
        if rand>0.56    %��ֵ
            pop(j,pos) = bounds(pos,1) + (bounds(pos,2) - bounds(pos,1)) * rand; %����Ӧ����
        end
      
        %��Ӧ��ֵ
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
    %�������Ÿ���
    if fitness(j) > fitnessgbest(j)
        gbest(j,:) = pop(j,:);
        fitnessgbest(j) = fitness(j);
    end
    
    %Ⱥ�����Ÿ��� 
    if fitness(j) > fitnesszbest
        zbest = pop(j,:);
        fitnesszbest = fitness(j);
    end
    
    end
    
    yy(i)=fitnesszbest;    
        
end

%% �������
plot(yy)
title(['��Ӧ������  ' '��ֹ������' num2str(maxgen)]);
xlabel('��������');ylabel('��Ӧ��');

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

