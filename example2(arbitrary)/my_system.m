%=========================================================================%
%  x_1=x(1), x_2=x(2), z(3), \hat{x}_1=x(4), \hat{x}_2=x(5),
%  \theta=x(6), p=(7)
%=========================================================================%
function dx = my_system(t,x)

global curIndex;

%%%%%%%%%%%%%%%% generate the switching signal %%%%%%%%%%%%%%%%
if t<=3.5
    k = switchLaw(t, 2.2,1.9);
elseif 3.5<t & t<=10
    k = switchLaw(t, 1.5,0.46);
elseif 10<t & t<=19.0
    k = switchLaw(t, 0.75,0.25);
elseif t>19.0
    k = 1;    
end
if mod(curIndex,1000) == 0
    disp(['t = ', num2str(t), ' s; k = ', num2str(k)]);
end

%%%%%%%%%%%%%%%%%%%% activate the kth mode %%%%%%%%%%%%%%%%%%%%
if k == 1
    dx = switchedSubSys1(t,x);
elseif k == 2
    dx = switchedSubSys2(t,x);
end

curIndex = curIndex+1;