function FuzzySst=FSst(sst)%建立起停次数的模糊集合
t1=struct('type',{'little'},'MF',{exp((-1/2)*((sst)/7)^2)});
t2=struct('type',{'middle'},'MF',{exp((-1/2)*((sst-12)/4)^2)});
t3=struct('type',{'many'},'MF',{exp((-1/2)*((sst-20)/4)^2)});
FuzzySst=[t1 t2 t3];
end