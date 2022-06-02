function element=Felement(state,signal)
%signal(1) 发出signal的楼层号
%signal(2) signal的方向:0代表向下,1代表向上
%state(1,1）elevator当前所在楼层
%state(1,2）elevator的运行方向，定义同signal
%state(1,3）elevator的拥挤度
%state(2，：）elevator所响应的信号集合
%state(3，：）elevator所响应的停站集合
%state(4，：）elevator所响应的信号所对应的信号候梯时间的集合
%state(5，：）elevator所响应的信号所对应的方向的集合
%若楼层数为N则 state是5行N列的矩阵
N=100;
%求距离dis
%电梯是上行方向
if(state(1,2)==1)
    if(signal(2)==1)
        if(state(1,1)<=signal(1))
            dis=signal(1)-state(1,1);
        else
            if(max(state(3,:))==0)
                dis=state(1,1)-signal(1);
            else
            dis=2*max(state(3,:))-state(1,1)-signal(1,1);
            end
        end
    else
        if(max(state(3,:))==0)
            dis=abs(state(1,1)-signal(1));
        else
            if(signal(1)>=max(state(3,:)))
                dis=signal(1)-state(1,1);
            else
                dis=2*max(state(3,:))-state(1,1)-signal(1,1);
            end
        end
    end
end
%电梯是下行方向
for i=1:length(state(3,:))
    if(state(3,i)~=0)
        temp(i)=state(3,i);
    else
        temp(i)=N;
    end
end
if(state(1,2)==0)
    if(signal(2)==0)
        if(state(1,1)>=signal(1))
            dis=state(1,1)-signal(1);
        else
            if(max(state(3,:))==N)
                dis=signal(1)-state(1,1);
            else
            dis=abs(2*min(state(3,:))-state(1,1)-signal(1,1));
            end
        end
    else
        if(max(state(3,:))==N)
            dis=abs(state(1,1)-signal(1));
        else
            if(signal(1)<=min(state(3,:)))
                dis=abs(signal(1)-state(1,1));
            else
                dis=abs(2*min(state(3,:))-state(1,1)-signal(1,1));
            end
        end
    end
end
%计算起停次数
sst=0;
for i=1:length(state(3,:))
    if(state(3,i)~=0)
       sst=sst+1;
    end
end
%计算电梯从接受signal响应到为其提供服务预停站次数stopTime
temp(1,:)=state(2,:);
temp(2,:)=state(5,:);
num=1;
% 除0
for i=1:length(temp)
    if(temp(2,i)~=0)
        temp0(:,num)=temp(:,i);
        num=num+1;
    end
end
temp=[];
temp=temp0;temp0=[];
%电梯是上行方向
if(state(1,2)==1)
    for i=1:length(temp(1,:))-1
        for j=i+1:length(temp(1,:))
            if(temp(2,j)>temp(2,i))
                temp1=temp(:,j);
                temp(:,j)=temp(:,i);
                temp(:,i)=temp1;
            elseif(temp(1,j)<temp(1,i)&&temp(2,j)==temp(2,i))
                temp1=temp(:,j);
                temp(:,j)=temp(:,i);
                temp(:,i)=temp1;
            end
        end
    end
    stopTime=0;
    if(signal(2)==1)
        for i=1:length(temp(1,:))
            if(signal(1)>temp(1,i)&&temp(2,i)==1)
                stopTime=stopTime+1;
            end
        end
    end
    if(signal(2)==0)
        for i=1:length(temp(1,:))
            if(temp(2,i)==1)
                stopTime=stopTime+1;
            elseif(signal(1)<temp(1,i))
                stopTime=stopTime+1;
            end
        end
    end
end
%电梯是下行方向
    
if(state(1,2)==0)
    for i=1:length(temp(1,:))-1
        for j=i+1:length(temp(1,:))
            if(temp(2,j)<temp(2,i))
                temp1=temp(:,j);
                temp(:,j)=temp(:,i);
                temp(:,i)=temp1;
            elseif(temp(1,j)>temp(1,i)&&temp(2,j)==temp(2,i))
                temp1=temp(:,j);
                temp(:,j)=temp(:,i);
                temp(:,i)=temp1;
            end
        end
    end
    stopTime=0;
    if(signal(2)==0)
        for i=1:length(temp(1,:))
            if(signal(1)<temp(1,i)&&temp(2,i)==0)
                stopTime=stopTime+1;
            end
        end
    end
    if(signal(2)==1)
        for i=1:length(temp(1,:))
            if(temp(2,i)==0)
                stopTime=stopTime+1;
            elseif(signal(1)>temp(1,i))
                stopTime=stopTime+1;
            end
        end
    end
end


%计算平均候梯时间awt
%t电梯走一层所用的时间stopT电梯停站所用的时间
%state(2，：）elevator所响应的信号集合
%state(3，：）elevator所响应的停站集合
%state(4，：）elevator所响应的信号所对应的信号候梯时间的集合
%state(5，：）elevator所响应的信号所对应的方向的集合
temp=[];stopT=15;t=10;
temp(1,:)=state(2,:);
temp(2,:)=state(5,:);
temp(3,:)=state(4,:);
num=1;
for i=1:length(temp)
    if(temp(2,i)~=0)
        temp0(:,num)=temp(:,i);
        num=num+1;
    end
end
temp=[];
temp=temp0;temp0=[];
wt=dis*t+stopT*stopTime;
if(state(1,2)==1)%电梯是上行方向
    for i=1:length(temp(1,:))-1
        for j=i+1:length(temp(1,:))
            if(temp(2,j)>temp(2,i))
                temp1=temp(:,j);
                temp(:,j)=temp(:,i);
                temp(:,i)=temp1;
            elseif(temp(1,j)<temp(1,i)&&temp(2,j)==temp(2,i))
                temp1=temp(:,j);
                temp(:,j)=temp(:,i);
                temp(:,i)=temp1;
            end
        end
    end
    if(signal(2)==1)
        for i=1:length(temp(1,:))
            if(temp(2,i)==1&&signal(1)<temp(1,i))
                temp(3,i)=temp(3,i)+stopT;
            end
            if(temp(2,i)==0)
                temp(3,i)=temp(3,i)+stopT;
            end
        end
    end
    if(signal(2)==0)
         for i=1:length(temp(1,:))            
            if(temp(2,i)==0&&signal(1)>temp(1,i))
                temp(3,i)=temp(3,i)+stopT;
            end
        end
    end
end
if(state(1,2)==0)%电梯是下行方向
    for i=1:length(temp(1,:))-1
        for j=i+1:length(temp(1,:))
            if(temp(2,j)<temp(2,i))
                temp1=temp(:,j);
                temp(:,j)=temp(:,i);
                temp(:,i)=temp1;
            elseif(temp(1,j)>temp(1,i)&&temp(2,j)==temp(2,i))
                temp1=temp(:,j);
                temp(:,j)=temp(:,i);
                temp(:,i)=temp1;
            end
        end
    end
    if(signal(2)==1)
        for i=1:length(temp(1,:))
            if(temp(2,i)==1&&signal(1)<temp(1,i))
                temp(3,i)=temp(3,i)+stopT;
            end
        end
    end
    if(signal(2)==0)
         for i=1:length(temp(1,:))            
            if(temp(2,i)==0&&signal(1)>temp(1,i))
                temp(3,i)=temp(3,i)+stopT;
            end
            if(temp(2,i)==1)
                temp(3,i)=temp(3,i)+stopT;
            end
        end
    end
end
awt=(wt+sum(temp(3,:)))/(length(temp(3,:))+1);
%计算长候梯率

tempLwp=[temp(3,:),wt];
lwpNum=0;
for i=1:length(tempLwp)
    if(tempLwp(i)>60)
        lwpNum=lwpNum+1;
    end
end
lwp=lwpNum/length(tempLwp);
tempTrip=temp(3,:);
%计算平均乘梯时间tripTime;
%t电梯走一层所用的时间stopT电梯停站所用的时间
%state(2，：）elevator所响应的信号集合
%state(3，：）elevator所响应的停站集合                             
%state(4，：）elevator所响应的信号所对应的信号候梯时间的集合
%state(5，：）elevator所响应的信号所对应的方向的集合
for i=2:length(tempTrip)
    tripTime(i-1)=tempTrip(i)-tempTrip(i-1);
end
 AtripTime=sum(tripTime)/length(tripTime);
%计算拥挤度
jam=state(1,3);

element=[awt lwp AtripTime jam dis sst];

end











