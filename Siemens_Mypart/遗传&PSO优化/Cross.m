function ret=Cross(pcross,lenchrom,chrom,sizepop,bound)
%本函数完成交叉操作
% pcorss                input  : 交叉概率
% lenchrom              input  : 染色体的长度
% chrom     input  : 染色体群
% sizepop               input  : 种群规模
% ret                   output : 交叉后的染色体
 for i=1:sizepop  %每一轮for循环中，可能会进行一次交叉操作，染色体是随机选择的，交叉位置也是随机选择的，%但该轮for循环中是否进行交叉操作则由交叉概率决定（continue控制）
     % 随机选择两个染色体进行交叉
     pick=rand(1,2);
     while prod(pick)==0
         pick=rand(1,2);
     end
     index=ceil(pick.*sizepop);% ceil取大于pick 找出两个 1-10的值，对这两个
     % 交叉概率决定是否进行交叉
     pick=rand;
     while pick==0
         pick=rand;
     end
     if pick>pcross
         continue;
     end
     flag=0;
     while flag==0
         % 随机选择交叉位
         pick=rand;
         while pick==0
             pick=rand;
         end
         pos=ceil(pick.*sum(lenchrom)); %随机选择进行交叉的位置，即选择第几个变量进行交叉，
         %注意：两个染色体交叉的位置相同 所以只需要rand一个值就可以
         pick=rand; %交叉开始 这个rand作为交叉的比例，也就是程度
         v1=chrom(index(1),pos); % 第index（1）行这个个体的第pos个染色体位置
         v2=chrom(index(2),pos);
         chrom(index(1),pos)=pick*v2+(1-pick)*v1;
         chrom(index(2),pos)=pick*v1+(1-pick)*v2; %交叉结束
         flag1=test(lenchrom,bound,chrom(index(1),:));  %检验染色体1的可行性
         flag2=test(lenchrom,bound,chrom(index(2),:));  %检验染色体2的可行性 这里是必须的！！
         if   flag1*flag2==0
             flag=0; %flag为0，就进入while继续交叉，否则flag = 1，这一次交叉结束
         else  flag=1;
         end    %如果两个染色体不是都可行，则重新交叉
     end
 end
ret=chrom; % 返回的是和原种群形式一样的种群