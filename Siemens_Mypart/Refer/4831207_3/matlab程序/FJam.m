function FuzzyJam=FJam(jam)%����ӵ���ȵ�ģ������
t1=struct('type',{'low'},'MF',{exp((-1/2)*(jam/0.3)^2)});
t2=struct('type',{'middle'},'MF',{exp((-1/2)*((jam-0.5)/0.2)^2)});
t3=struct('type',{'high'},'MF',{exp((-1/2)*((jam-1)/0.3)^2)});
FuzzyJam=[t1 t2 t3];
end