clc
%signal(1) ����signal��¥���
%signal(2) signal�ķ���0��������   һ��1��������
%state(1,1��elevator��ǰ����¥��
%state(1,2��elevator�����з��򣬶���ͬsignal
%state(1,3��elevator��ӵ����
%state(2������elevator����Ӧ���źż���
%state(3������elevator����Ӧ��ͣվ����
%state(4������elevator����Ӧ���ź�����Ӧ���źź���ʱ��ļ���
%state(5������elevator����Ӧ���ź�����Ӧ�ķ���ļ���
%��¥����ΪN�� state��5��N�еľ���
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