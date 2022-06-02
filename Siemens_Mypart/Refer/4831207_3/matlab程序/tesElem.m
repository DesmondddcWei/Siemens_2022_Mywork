clc
%signal(1) 发出signal的楼层号
%signal(2) signal的方向0代表向下一步1代表向上
%state(1,1）elevator当前所在楼层
%state(1,2）elevator的运行方向，定义同signal
%state(1,3）elevator的拥挤度
%state(2，：）elevator所响应的信号集合
%state(3，：）elevator所响应的停站集合
%state(4，：）elevator所响应的信号所对应的信号候梯时间的集合
%state(5，：）elevator所响应的信号所对应的方向的集合
%若楼层数为N则 state是5行N列的矩阵
signal=[3 0];
state=[1 1 0.5 0 0 0
       1 4 5 0 0 0
       2 4 0 0 0 0
       100 30 40 0 0 0
       0 1 1 0 0 0];
elem=Felement(state,signal)