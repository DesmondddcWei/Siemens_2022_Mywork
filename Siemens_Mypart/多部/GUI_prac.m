%创建窗口

%% 
function GUI_prac
close all
global GU
GU.f = figure( 'units','pixels',...
    'position',[500 200 600 400],...
    'menubar','none',...
    'name','handle',...
    'numbertitle','off',...
    'resize','off');
%老虎机
interpic_tiger = imread('Tiger.jpg');
fac_pic = 3.1;
axes('Parent',GU.f,'Position',[0.26,0.05,0.296 * fac_pic,0.28*fac_pic])
imshow(interpic_tiger)
%上摇杆
Starticon = imread('hand_up.jpg');
Starticon = imresize(Starticon,[140,38]);
GU.start =  uicontrol('Parent',GU.f,'Style','pushbutton','String',' ',...
    'position',[540,130,38,140],'visible','on',...
    'callback',@pull_down,'CData',Starticon);
%下摇杆
Endicon = imread('hand_down.jpg');
Endicon = imresize(Endicon,[140,38]);
GU.end =  uicontrol('Parent',GU.f,'Style','pushbutton','String',' ',...
    'position',[540,40,38,140],'visible','off',...
    'callback',@pull_up,'CData',Endicon);


% 理清楚前后每一个控件之间的关系
%定义字符串的 父级 种类 名字 位置 可见不可见

%显示随机数的框子
GU.text_random = uicontrol('parent',GU.f,'style','text','string',' ',...
    'position',[520,200,250,65],'fontsize',12,'foregroundcolor','white','fontweight','bold',...
    'horizontalalignment','center'); %字体 颜色 水平方向左居中
%按钮
GU.button = uicontrol('Parent',GU.f,'Style','pushbutton','String','button',...
    'position',[140,197,50,30],'visible','on','fontsize',12,...
    'callback',@changeEditFcn);
%文字
GU.text = uicontrol('parent',GU.f,'style','text','string','Attendance Set',...
    'position',[10,160,125,22],'fontsize',12,'foregroundcolor','red','fontweight','bold',...
    'horizontalalignment','left','ForegroundColor',[0.06 1 1]); %字体 颜色 水平方向左居中
%可输入文本框
GU.edit1 = uicontrol('parent',GU.f,'style','edit','string','10',...
    'position',[140,157,50,30],'fontsize',12,'backgroundcolor',[0.72 0.27 1],'fontweight','bold',...
    'visible','on','callback',@changeEdit2);
GU.edit1_con = get(GU.edit1,'string');

GU.edit2 = uicontrol('parent',GU.f,'style','edit','string','10',...
    'position',[140,125,50,30],'fontsize',12,'backgroundcolor',[0.72 0.27 1],'fontweight','bold',...
    'visible','on');

end

function changeEditFcn(~,~)%让edit1的内容点一次加1
global GU
    %set(GU.edit,'string','other')
    edit_string = get(GU.edit1,'string'); %累加1
    edit_string = str2double(edit_string) + 1;
    edit_string = num2str(edit_string);
    set(GU.edit1,'string',edit_string)
end

function changeEdit2(~,~) %让edit2的内容变为和edit1的内容一样
global GU
    edit_string = get(GU.edit1,'string'); %累加1    
    set(GU.edit2,'string',edit_string)
end
function pull_down(~,~) %下拉
global GU
    set(GU.start,'visible','off')
    set(GU.end,'visible','on')
end
function pull_up(~,~) %上拉

global GU
    set(GU.end,'visible','off')
    set(GU.start,'visible','on')
end






