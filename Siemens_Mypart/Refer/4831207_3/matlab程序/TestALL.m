clc
%signal(1) 发出signal的楼层号
%signal(2) signal的方向0代表向下   一步1代表向上
%state(1,1）elevator当前所在楼层
%state(1,2）elevator的运行方向，定义同signal
%state(1,3）elevator的拥挤度
%state(2，：）elevator所响应的信号集合
%state(3，：）elevator所响应的停站集合
%state(4，：）elevator所响应的信号所对应的信号候梯时间的集合
%state(5，：）elevator所响应的信号所对应的方向的集合
%若楼层数为N则 state是5行N列的矩阵
%element=[awt lwp AtripTime jam sst dis];
signal=[3 0];
state=[20 1 0.6 0 0 0
       22 23 0  0 0 0               
       21  24 0 0 0 0 
       10  20  0 0 0 0
       0  1 0 0 0 0];
elem=Felement(state,signal);
awtCon=FAwtContent(elem(1),elem(2),Wx1,Wx2,W0,w0);
tripCon=FTripContent(elem(3),elem(4),Wx1,Wx2,W1,w1);
rncCon=FRnc(elem(5),elem(6),Wx1,Wx2,W2,w2);
s=0.6*awtCon+0.3*tripCon+0.1*rncCon
ss=0.6*awtCon+0.2*tripCon+0.2*rncCon
sss=0.4*awtCon+0.4*tripCon+0.2*rncCon