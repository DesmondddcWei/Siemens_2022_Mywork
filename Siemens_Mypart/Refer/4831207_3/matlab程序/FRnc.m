function [y FuzzyRnc]=FRnc(sst,dis,Wsst,Wdis,W,w)%求解能耗函数
%sst 起停次数精确值
%dis  运行距离精确值  
%Wsst 起停次数对应权重矩阵
%Wdis  运行距离对应权重矩阵
%W    确定满意度隶属函数集合权重矩阵
%w    反模糊化权重矩阵
T=FSst(sst);%生成对应于输入sst的起停次数模糊集合
J=FDis(dis);%生成对应于输入dis距离模糊集合
Wtrip=Wsst;
Wjam=Wdis;
x1=W(1,1)*(Wtrip(3,3)*Wjam(3,3)*T(3).MF*J(3).MF)...
    +W(1,2)*(Wtrip(3,2)*Wjam(2,3)*T(3).MF*J(2).MF)...
    +W(1,3)*(Wtrip(2,3)*Wjam(3,2)*T(2).MF*J(3).MF);
x2=W(2,1)*(Wtrip(3,1)*Wjam(1,3)*T(3).MF*J(1).MF)...
    +W(2,2)*(Wtrip(2,2)*Wjam(2,2)*T(2).MF*J(2).MF)...
    +W(2,3)*(Wtrip(1,3)*Wjam(3,1)*T(1).MF*J(3).MF);
x3=W(1,1)*(Wtrip(1,1)*Wjam(1,1)*T(1).MF*J(1).MF)...
    +W(1,2)*(Wtrip(1,2)*Wjam(2,1)*T(1).MF*J(2).MF)...
    +W(1,3)*(Wtrip(2,1)*Wjam(1,2)*T(2).MF*J(1).MF);
t1=struct('type',{'no'},'MF',{x1});
t2=struct('type',{'middle'},'MF',{x2});
t3=struct('type',{'very'},'MF',{x3});
FuzzyRnc=[t1 t2 t3];
t=[t1 t2 t3];
y=(w(1)*t(1).MF+w(2)*t(2).MF+w(3)*t(3).MF)/(0.25*t(1).MF+0.15*t(2).MF+0.1*t(3).MF);
end