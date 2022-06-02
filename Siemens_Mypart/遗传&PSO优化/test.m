function flag=test(lenchrom,bound,code) %在交叉和变异过程中，判断是否符合标准
% lenchrom   input : 染色体长度
% bound      input : 变量的取值范围
% code       output: 染色体的编码值
x = code; %先解码
flag=1; % 
len_x = length(x);
for i = 1 : len_x
    if (x(i) < bound(i,1) || x(i) > bound(i,2)) == 1
        flag = 0;
    end
end
% if (x(1)<0)&&(x(2)<0)&&(x(3)<0)&&(x(1)>bound(1,2))&&(x(2)>bound(2,2))&&(x(3)>bound(3,2))
%     flag=0;
% end     