function FuzzyAwt=FAwt(awt)%建立候梯时间的模糊集合
t1=struct('type',{'short'},'MF',{exp((-1/2)*(awt/20)^2)});
t2=struct('type',{'middle'},'MF',{exp((-1/2)*((awt-30)/10)^2)});
t3=struct('type',{'long'},'MF',{exp((-1/2)*((awt-60)/20)^2)});
FuzzyAwt=[t1 t2 t3];
end