function flag=test(lenchrom,bound,code) %�ڽ���ͱ�������У��ж��Ƿ���ϱ�׼
% lenchrom   input : Ⱦɫ�峤��
% bound      input : ������ȡֵ��Χ
% code       output: Ⱦɫ��ı���ֵ
x = code; %�Ƚ���
flag=1; % 
len_x = length(x);
for i = 1 : len_x
    if (x(i) < bound(i,1) || x(i) > bound(i,2)) == 1
        flag = 0;
    end
end
% if (x(1)<0)&&(x(2)<0)&&(x(3)<0)&&(x(1)>bound(1,2))&&(x(2)>bound(2,2))&&(x(3)>bound(3,2))
%     flag=0;
% end     