function FuzzyDis=FDis(dis)%建立距离的模糊集合
h=3;
t1=struct('type',{'short'},'MF',{exp((-1/2)*((dis)/(7*h))^2)});
t2=struct('type',{'middle'},'MF',{exp((-1/2)*((dis-12*h)/(4*h))^2)});
t3=struct('type',{'long'},'MF',{exp((-1/2)*((dis-20*h)/(4*h))^2)});
FuzzyDis=[t1 t2 t3];
end