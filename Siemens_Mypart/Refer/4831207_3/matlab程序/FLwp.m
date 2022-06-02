function FuzzyLwp=FLwp(lwp)%建立长候梯率的模糊集合
t1=struct('type',{'low'},'MF',{exp((-1/2)*(lwp/0.05)^2)});
t2=struct('type',{'middle'},'MF',{exp((-1/2)*((lwp-0.065)/0.015)^2)});
t3=struct('type',{'high'},'MF',{exp((-1/2)*((lwp-0.08)/0.01)^2)});
FuzzyLwp=[t1 t2 t3];
end