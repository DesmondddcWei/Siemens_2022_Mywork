function ret=Code(lenchrom,bound)
%�����������������Ⱦɫ�壬���������ʼ��һ����Ⱥ
% lenchrom   input : Ⱦɫ�峤�� lenchrom��һ��������
% bound      input : ������ȡֵ��Χ ����Ϊ2 ����Ϊ��Ⱥ���еĸ������
% ret        output: Ⱦɫ��ı���ֵ
%flag=0;
%while flag==0
pick=rand(1,length(lenchrom));
ret=bound(:,1)'+(bound(:,2)-bound(:,1))'.*pick; %���Բ�ֵ����������ʵ����������ret�� ��Ϊ�����ķ���ֵ
    %���������ķ�Χ�����ȡ��һ���� 
    %flag = test(lenchrom,bound,ret);     %����Ⱦɫ��Ŀ�����
    %����Ϊ��һ��û�б�Ҫ��������ǲ�ֵ��һ��û����
%end
        
