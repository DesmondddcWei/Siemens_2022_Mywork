function out_floor = rand_floor(weight_c)
%输入为一个行向量，长度为楼层总数，值为该楼层的概率 处理之后的weight_c
%输出为一个数值，在区间 1 到length（weight_a）之间
    ran = rand; %产生一个随机数，落在哪个区间里就是哪个楼层
        for i = (length(weight_c)-1):-1:1
            if ran >= weight_c(i)
               out_floor = i + 1;
               break;
            else
                if i == 1
                   out_floor = 1; 
                   break;
                end
                continue;    
            end    
        end
end

