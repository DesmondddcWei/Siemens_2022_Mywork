function [W0 w0 yy]=FAwtConW(W,w,h)
%Wawt,Wlwp�������е�һ�㻥��Ȩ������Ϊ1
Wawt=ones(3);
Wlwp=ones(3);
%W������ڶ��㻥��Ȩ�س�ֵ
%w����������㻥��Ȩ�س�ֵ
%hѧϰЧ��
%W0��ѧϰ�����ɵĵڶ��㻥��Ȩ��
%w0��ѧϰ�����ɵĵ����㻥��Ȩ��
[y FA]=FAwtContent(0,0,Wawt,Wlwp,W,w);
num=1;
yy(1)=y;
%wr0���
wr0=1-y;
while(abs(1-y)>1e-5)
   %ͨ��ѧϰ�����µ�w
    tw=w;
    dw=3*h*(1-y);
    w=w+dw;
    %ͨ��ѧϰ�����µ�W
    T=FAwt(0);
    J=FLwp(0);
    t(1,1)=Wawt(3,3)*Wlwp(3,3)*T(3).MF*J(3).MF;
    t(1,2)=Wawt(3,2)*Wlwp(2,3)*T(3).MF*J(2).MF;
    t(1,3)=Wawt(2,3)*Wlwp(3,2)*T(2).MF*J(3).MF;
    
    t(2,1)=Wawt(3,1)*Wlwp(1,3)*T(3).MF*J(1).MF;
    t(2,2)=Wawt(2,2)*Wlwp(2,2)*T(2).MF*J(2).MF;
    t(2,3)=Wawt(1,3)*Wlwp(3,1)*T(1).MF*J(3).MF;
    
    t(3,1)=Wawt(1,1)*Wlwp(1,1)*T(1).MF*J(1).MF;
    t(3,2)=Wawt(1,2)*Wlwp(2,1)*T(1).MF*J(2).MF;
    t(3,3)=Wawt(2,1)*Wlwp(1,2)*T(2).MF*J(1).MF;
    for i=1:3
        if(y<1)
            df1(i)=sum(t(i,:));
        else
            df1(i)=0;
        end
    end
    dW1=3*h*(1-y)*sum(tw)*df1(1)*FA(1).MF;
    dW2=3*h*(1-y)*sum(tw)*df1(2)*FA(2).MF;
    dW3=3*h*(1-y)*sum(tw)*df1(3)*FA(3).MF;
    W(1,:)=W(1,:)+dW1;
    W(2,:)=W(2,:)+dW2;
    W(3,:)=W(3,:)+dW3;
   
        
    [y FA]=FAwtContent(0,0,Wawt,Wlwp,W,w);
    %wr��ǰ
    wr=1-y;
    if(wr<wr0)
        h=1.05*h;
    elseif(wr>1.04*wr0)
        h=0.7*h;
    end
    wr0=wr;  
    num=num+1;
    yy(num)=y;
end
W0=W;
w0=w;
end