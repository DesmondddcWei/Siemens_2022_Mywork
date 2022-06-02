function ret=select(individuals,sizepop)
% 本函数对每一代种群中的染色体进行选择，以进行后面的交叉和变异
% individuals input  : 种群信息
% sizepop     input  : 种群规模
% ret         output : 经过选择后的种群

%根据个体适应度值进行排序 这里 k = 10
fitness1=individuals.fitness ./ 10; % 不求倒数 适应度越大越好

sumfitness=sum(fitness1);
sumf=fitness1./sumfitness;
index=[]; 
for i=1:sizepop   %转sizepop次轮盘 就是选出十个个体作为新的种群，当然有可能会有个体的重复
    pick=rand;
    while pick==0    
        pick=rand;        
    end
    for j=1:sizepop 
        
        pick=pick-sumf(i);      %意思是总会小于0，但是有可能会因为一个比较大的数而直接小于0
        if j == sizepop   %如果已经到了最后一个，还是大于等于0，就直接随机一个给index
            if pick >= 0
                cc = ceil(100 * rand);
                index=[index cc];
                break;                 %随机完了之后，直接退出
            end
        end
        if pick<0               %这个比较大的数就是那个比较优秀的个体
            index=[index j];  % 选出了一个之后，就去选下一个个体            
            break;  %寻找落入的区间，此次转轮盘选中了染色体i，注意：在转sizepop次轮盘的过程中，有可能会重复选择某些染色体
        end
    end
end
individuals.chrom=individuals.chrom(index,:);
individuals.fitness=individuals.fitness(index);
ret=individuals;
 