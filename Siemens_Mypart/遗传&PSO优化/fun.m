function fitness = fun(x,inputnum,hiddennum,outputnum,net,inputn,outputn)
%该函数用来计算适应度值   当前系数下，电梯的表现能力 


fitness=sum(abs(an-outputn));