function weight_c = weight_A2C(weight_a)
    weight_a_all = sum(weight_a); % weight_a 求和
    weight_b = zeros(1,10); %weight_b（n）是起始楼层为n层的概率
    weight_c = zeros(1,10); %weight_c(n)是b中 n到1的求和
    for i = 1 : length(weight_a)
        weight_b(i) = weight_a(i) / weight_a_all; 
    end
    for i = 1 : length(weight_a)
         r = 0;
        for j = 1:i     
            r = r + weight_b(j);
        end
        weight_c(i) = r;
    end
end