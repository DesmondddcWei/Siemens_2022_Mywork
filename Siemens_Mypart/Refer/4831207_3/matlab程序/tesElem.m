clc
%signal(1) ����signal��¥���
%signal(2) signal�ķ���0��������һ��1��������
%state(1,1��elevator��ǰ����¥��
%state(1,2��elevator�����з��򣬶���ͬsignal
%state(1,3��elevator��ӵ����
%state(2������elevator����Ӧ���źż���
%state(3������elevator����Ӧ��ͣվ����
%state(4������elevator����Ӧ���ź�����Ӧ���źź���ʱ��ļ���
%state(5������elevator����Ӧ���ź�����Ӧ�ķ���ļ���
%��¥����ΪN�� state��5��N�еľ���
signal=[3 0];
state=[1 1 0.5 0 0 0
       1 4 5 0 0 0
       2 4 0 0 0 0
       100 30 40 0 0 0
       0 1 1 0 0 0];
elem=Felement(state,signal)