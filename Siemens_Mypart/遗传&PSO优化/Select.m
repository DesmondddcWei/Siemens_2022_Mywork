function ret=select(individuals,sizepop)
% ��������ÿһ����Ⱥ�е�Ⱦɫ�����ѡ���Խ��к���Ľ���ͱ���
% individuals input  : ��Ⱥ��Ϣ
% sizepop     input  : ��Ⱥ��ģ
% ret         output : ����ѡ������Ⱥ

%���ݸ�����Ӧ��ֵ�������� ���� k = 10
fitness1=individuals.fitness ./ 10; % ������ ��Ӧ��Խ��Խ��

sumfitness=sum(fitness1);
sumf=fitness1./sumfitness;
index=[]; 
for i=1:sizepop   %תsizepop������ ����ѡ��ʮ��������Ϊ�µ���Ⱥ����Ȼ�п��ܻ��и�����ظ�
    pick=rand;
    while pick==0    
        pick=rand;        
    end
    for j=1:sizepop 
        
        pick=pick-sumf(i);      %��˼���ܻ�С��0�������п��ܻ���Ϊһ���Ƚϴ������ֱ��С��0
        if j == sizepop   %����Ѿ��������һ�������Ǵ��ڵ���0����ֱ�����һ����index
            if pick >= 0
                cc = ceil(100 * rand);
                index=[index cc];
                break;                 %�������֮��ֱ���˳�
            end
        end
        if pick<0               %����Ƚϴ���������Ǹ��Ƚ�����ĸ���
            index=[index j];  % ѡ����һ��֮�󣬾�ȥѡ��һ������            
            break;  %Ѱ����������䣬�˴�ת����ѡ����Ⱦɫ��i��ע�⣺��תsizepop�����̵Ĺ����У��п��ܻ��ظ�ѡ��ĳЩȾɫ��
        end
    end
end
individuals.chrom=individuals.chrom(index,:);
individuals.fitness=individuals.fitness(index);
ret=individuals;
 