function [y FuzzyTripContent]=FTripContent(trip,jam,Wtrip,Wjam,W,w)%����������Ⱥ���
%trip ����ʱ�侫ȷֵ
%jam  ӵ���Ⱦ�ȷֵ  
%Wtrip ����ʱ���ӦȨ�ؾ���
%Wjam  ӵ���ȶ�ӦȨ�ؾ���
%W    ȷ�������������������Ȩ�ؾ���
%w    ��ģ����Ȩ�ؾ���
T=FtripTime(trip);%���ɶ�Ӧ������trip�ĳ���ʱ��ģ������
%display('trip')
%T(1),T(2),T(3)
J=FJam(jam);%���ɶ�Ӧ������jam��ӵ����ģ������
%display('jam')
%J(1),J(2),J(3)
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
%t1.type,t1.MF,t2.type,t2.MF,t3.type,t3.MF
FuzzyTripContent=[t1 t2 t3];
t=[t1 t2 t3];

y=(w(1)*t(1).MF+w(2)*t(2).MF+w(3)*t(3).MF)/(0.25*t(1).MF+0.15*t(2).MF+0.1*t(3).MF);
end