%=========================================================================%
%  Manuscript ID: TFS-2019-0417
%  This is the source code of Example 3
%  Last Modified by Kcoey Lee in 14-May-2019
%=========================================================================%
clc;close all;

%%%%%%%%%%%%%%%%%%%%%%%%%% Global variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gPi1;
global gY;
global gHatX1;
global gHatM;
global gOdeTime;    
global gTheta;
global gTheta1;
global curIndex;

%%%%%%%%%%%%%%%%%%%%%% Initialize the global variables %%%%%%%%%%%%%%%%%%%%%%
gPi1 = [0];
gY = [0];
gHatX1 = [0];
gHatM = [0];
gTheta = [0];
gTheta1 = [0];
gOdeTime = 1;
curIndex = 0;

Flag.t_0 = 0;           % Start time
Flag.t_n = 20;          % End time

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Solve the OED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
[t,x] = ode45('my_system', [Flag.t_0 Flag.t_n], [0.4 0.2 4 5 -0.3 0.4 0.1 0.2]);
toc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Draw figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---- All the closed-loop signals
figure(1)
plot(t,x);
hl=legend('$x_1$', '$x_2$', '$z_1$', '$z_2$',... 
    '$\hat{x}_1$', '$\hat{x}_2$', '$\theta$', '$\hat{p}$');
set(hl,'Interpreter','latex');

%---- Fig. 5(a): State variables of the unmodeled dynamics
figure(2)
plot(t,x(:,3:4), 'linewidth',1.5);
hl=legend('$z_1$','$z_2$');
xlabel('Time(sec)');
set(gca,'linewidth', 1.5,'fontsize',15);
set(hl,'Interpreter','latex','fontsize',20);
set(hl,'Orientation','horizon');

%---- Fig. 5(b): State variables of the x-system
figure(3)
plot(t,x(:,1:2), 'linewidth',1.5);
hl=legend('$x_1$','$x_2$');
xlabel('Time(sec)');
set(gca,'linewidth', 1.5,'fontsize',15);
set(hl,'Interpreter','latex','fontsize',20);
set(hl,'Orientation','horizon');