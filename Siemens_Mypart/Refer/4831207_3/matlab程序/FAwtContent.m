function [y FuzzyAwtContent]=FAwtContent(awt,lwp,Wawt,Wlwp,W,w)%求解候梯满意度函数
%awt 候梯时间精确值
%lwp  长候梯率精确值  
%Wawt 候梯时间对应权重矩阵
%Wlwp  长候梯率对应权重矩阵
%W    确定满意度隶属函数集合权重矩阵
%w    反模糊化权重矩阵
T=FAwt(awt);%生成对应于输入awt的候梯时间模糊集合
J=FLwp(lwp);%生成对应于输入sst的长候梯率模糊集合
%display('awt')
%T(1),T(2),T(3)
%display('lwp')
%J(1),J(2),J(3)
Wtrip=Wawt;
Wjam=Wlwp;
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
FuzzyAwtContent=[t1 t2 t3];
t=[t1 t2 t3];
y=(w(1)*t(1).MF+w(2)*t(2).MF+w(3)*t(3).MF)/(0.25*t(1).MF+0.15*t(2).MF+0.1*t(3).MF);
end