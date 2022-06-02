clc;
Wx1=ones(3);
Wx2=ones(3);
W=[];
for i=1:3
    for j=1:3
        W(i,j)=abs(rand(1)-0.5);
    end
end
w=[];
for i=1:3
    w(i)=abs(rand(1)-0.5);
end
Wt=W.*1000;
wt=W.*1000;
%W=W./3000;
w=w./3000;
W=ones(3);
%w=ones(1,3);

%[y FuzzyTripContent]=FTripContent(trip,jam,Wtrip,Wjam,W,w)
[W0 w0 yy0]=FAwtConW(W,w,0.05)
[W1 w1 yy1]=FTripConW(W,w,0.05)
[W2 w2 yy2]=FRncW(W,w,0.05)

%y1=FAwtContent(0,0,Wx1,Wx2,W0,w0)
%y2=FTripContent(0,0,Wx1,Wx2,W1,w1)
%y3=FRnc(0,0,Wx1,Wx2,W2,w2)

