function ret=Code(lenchrom,bound)
%本函数将变量编码成染色体，用于随机初始化一个种群
% lenchrom   input : 染色体长度 lenchrom是一个行向量
% bound      input : 变量的取值范围 列数为2 行数为种群的中的个体个数
% ret        output: 染色体的编码值
%flag=0;
%while flag==0
pick=rand(1,length(lenchrom));
ret=bound(:,1)'+(bound(:,2)-bound(:,1))'.*pick; %线性插值，编码结果以实数向量存入ret中 作为函数的返回值
    %就是在数的范围中随机取出一个数 
    %flag = test(lenchrom,bound,ret);     %检验染色体的可行性
    %我认为这一步没有必要，本身就是插值，一般没问题
%end
        
