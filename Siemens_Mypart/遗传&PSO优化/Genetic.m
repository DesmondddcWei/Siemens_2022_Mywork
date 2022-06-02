
%% �ô���Ϊ�Ŵ��㷨�����ؿ����㷨ϵ���Ż�
% ��ջ�������
clc
clear
% 
%% ���ݺͿ�����ʼ�� ��Ҫ����һ��
clc
clear
global Elevator
global guest_matrix 
Elevator = {}; %���ݵ�������Ϣ
guest_matrix = {}; %�˿ͺͳ˿����������Ϣ
Elevator = Get_Initial();
%���ݳ�ʼ������aa
total_time = 300; %�趨���� �ܷ���ʱ��
pop = 100;        %�趨���� �������
test_time = 10;    %�����Ŀ���ģ�͵ĸ���
%���ԵĴ������ɴ˲������������ģ�ͣ�����Ҫ�Ѳ��������ݱ���ס
%����ס�ſ���ȥ���Բ�������֮��ĵ���
%load default_matrix_fair.mat 

%load guest_5.5.mat
%load 5.10_posi.mat
% �Ŵ��㷨������ʼ��
load 5.10_exp.mat
%% 

maxgen = 10;                         %��������������������
sizepop = 10;                        %��Ⱥ��ģ
pcross = [0.1];                       %�������ѡ��0��1֮��
pmutation = [0.2];                    %�������ѡ��0��1֮��

%�ڵ�����
%numsum=inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum;

lenchrom=ones(1,5); %������ 1�� 5��  һ����5������ 
%               �ֱ�Ϊ para1 para2  ��para3��  para4  Q1   Q2 
%               Ĭ��ֵΪ 20    60    ��20��   0.008  1    1
%               ��para1 �� 2 ��ֵȷ��֮�󣬿���ֱ��ȷ��para3��ֵ
%                                    
bound=[ 20   30 ; ... % para1
        40   70; ...  % para2
        0.003  0.016;... % para4
        0.5    5;...     % Q1
        0.5    5];      %  Q2
    %���ݷ�Χ

%------------------------------------------------------��Ⱥ��ʼ��--------------------------------------------------------
individuals=struct('fitness',zeros(1,sizepop), 'chrom',[]);  %����Ⱥ��Ϣ����Ϊһ���ṹ��
avgfitness=[];                      %ÿһ����Ⱥ��ƽ����Ӧ��
bestfitness=[];                     %ÿһ����Ⱥ�������Ӧ��
bestchrom=[];                       %��Ӧ����õ�Ⱦɫ��
%��ʼ����Ⱥ
% 
%% ����ֻ������һ�Σ���������

for indi_num = 1:sizepop       %��i��
    %i = 3;
    %�������һ����Ⱥ
    individuals.chrom(indi_num,:)=Code(lenchrom,bound);    %���루binary��grey�ı�����Ϊһ��ʵ����float�ı�����Ϊһ��ʵ��������
    x=individuals.chrom(indi_num,:);
    para1 = x(1);
    para2 = x(2);
    para3 = 100 - para1 - para2;
    para4 = x(3);
    Q1 = x(4);
    Q2 = x(5);
    %������Ӧ��
    individuals.fitness(1,indi_num) = MenterCalo(total_time,pop,para1,para2,para3,para4,Q1,Q2);
%    Elevator = {};
%    Get_Initial(); % ������Ϣ��λ
    %�����Ӧ����Խ��Խ�õ�                            
    %individuals.fitness(i)=fun(x,inputnum,hiddennum,outputnum,net,inputn,outputn);   %Ⱦɫ�����Ӧ��
end

% 
% 

FitRecord=[];
%����õ�Ⱦɫ��
[bestfitness bestindex]=max(individuals.fitness);
% 

bestchrom=individuals.chrom(bestindex,:);  %��õ�Ⱦɫ��
avgfitness=sum(individuals.fitness)/sizepop; %Ⱦɫ���ƽ����Ӧ��
% ��¼ÿһ����������õ���Ӧ�Ⱥ�ƽ����Ӧ��
traceone=[avgfitness bestfitness]; 
% 
 
% ���������ѳ�ʼ��ֵ��Ȩֵ
% ������ʼ
for indi_num=1:maxgen
    indi_num
    sizepop = size(individuals.chrom,1);
    % ѡ��
    individuals=Select(individuals,sizepop); 
    avgfitness=sum(individuals.fitness)/sizepop;
    %����
    individuals.chrom=Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
    % ����
    individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,indi_num,maxgen,bound);
    
    % ������Ӧ�� 
    for j=1:size(individuals.chrom,1)
        
        %---------
        x=individuals.chrom(j,:); %����
        para1 = x(1);
        para2 = x(2);
        para3 = 100 - para1 - para2;
        para4 = x(3);
        Q1 = x(4);
        Q2 = x(5);
        %������Ӧ��
       % individuals.fitness(j) = MenterCalo(total_time,pop,para1,para2,para3,para4,Q1,Q2);
        %---------
    end
    
  %�ҵ���С�������Ӧ�ȵ�Ⱦɫ�弰��������Ⱥ�е�λ��
    [newbestfitness,newbestindex]= max(individuals.fitness);
    [worestfitness,worestindex]= min(individuals.fitness);
    % ������һ�ν�������õ�Ⱦɫ��
    
    if bestfitness < newbestfitness
        bestfitness = newbestfitness;
        bestchrom = individuals.chrom(newbestindex,:); %�����ǵó���õ�һ����Ⱥ
    end
    individuals.chrom(worestindex,:)=bestchrom; %����õ�ȥ������
    individuals.fitness(worestindex)=bestfitness;
    
    avgfitness=sum(individuals.fitness)/sizepop;
    
    traceone=[traceone;avgfitness bestfitness]; %��¼ÿһ����������õ���Ӧ�Ⱥ�ƽ����Ӧ��
    FitRecord=[FitRecord;individuals.fitness];%��¼ÿһ�ε����У�ÿһ���������Ӧ��ֵ
end

%% �Ŵ��㷨������� 
figure(1)
[r c]=size(traceone); % trace �а���ÿһ�ν����е�ƽ����Ӧ�Ⱥ������Ӧ��
hold on 
plot([1:r]',traceone(:,1),'r--',"LineWidth",1.5); %ƽ����Ӧ��
plot([1:r]',traceone(:,2),'b--',"LineWidth",1.5); %�����Ӧ��
hold off
title(['��Ӧ������  ' '��ֹ����������' num2str(16)]);
xlabel('��������');ylabel('��Ӧ��');
legend('ƽ����Ӧ��','�����Ӧ��');
%disp('��Ӧ��                   ����');
grid on 

