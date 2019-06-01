%=========================================================================%
%  x_1=x(1), x_2=x(2), z(3), \hat{x}_1=x(4), \hat{x}_2=x(5),
%  \theta=x(6), p=(7)
%=========================================================================%
function dx = my_system(t,x)

global curIndex;

%%%%%%%%%%%%%%%% generate the switching signal %%%%%%%%%%%%%%%%
k = switchLaw(t, 2.2,1.8);
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