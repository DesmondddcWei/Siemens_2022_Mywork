function FuzzyTripTime=FtripTime(tripTime)%��������ʱ���ģ������
t1=struct('type',{'short'},'MF',{exp((-1/2)*(tripTime/15)^2)});
t2=struct('type',{'middle'},'MF',{exp((-1/2)*((tripTime-20)/5)^2)});
t3=struct('type',{'long'},'MF',{exp((-1/2)*((tripTime-30)/5)^2)});
FuzzyTripTime=[t1 t2 t3];
end