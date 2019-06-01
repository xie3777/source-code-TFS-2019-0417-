function dx = switchedSubSys1(t,x)

% global variables
global gPi1;
global gY;
global gHatX1;
global gHatM;
global gTheta;
global gTheta1;

global gOdeTime;

dx = zeros(size(x));

% parameters of the controller
rp = 0.1;
barRp = 0.08;
c1 = 5;
c2 = 6;
a1 = 5;
a2 = 1;
rTheta = 1;
barRTheta = 0.8;

% parameters of switchd state observer
ell1=1.5;
ell2=2;

% the determined nonlinear function
y=x(1);
v1 = 6;
dEta = 27*2*y^2+1;
eta = 27*y^2+y^2;
psi11 = 5*y^2;
psi21 = 1.1*y^2;

barPsi11 = psi11/y;       
barPsi21 = psi21/y;

%%%%%%%%%%%%%%%%%%%%%%%%%%% fuzzy logic system %%%%%%%%%%%%%%%%%%%%%%%%%%%
bigZ11 = [x(1)]';                                 
bigZ12 = [x(1), x(5), x(7), x(8)]';     
L = 5;
width = 4;
S1 = zeros(L,1);
S2 = zeros(L,1);
psi21 = zeros(L,1);
psi22 = zeros(L,1);
for idL = 1:L
    S1(idL) = fuzzyBasic(bigZ11, idL, L, width*ones(1, length(bigZ11)) );
end
for idL = 1:L
    S2(idL) = fuzzyBasic(bigZ12, idL, L, width*ones(1, length(bigZ12)) );
end

%%%%%%%%%%%%%%%%%%%% implementation of the controller %%%%%%%%%%%%%%%%%%
phi11 = 1/2+1/(2*dEta)+barPsi11^2/(2*dEta);
phi21 = 1/2+barPsi11^2/(4*dEta);

xi1 = y*dEta;                                                     
pi1 = -0.5*xi1-1/(2*a1^2)*x(7)*xi1*S1'*S1-x(8)*phi11*y*dEta-y*v1;

xi2 = x(6)-pi1;                                                  
pPi1_pY = pApB(pi1, y);
u = -(c2+0.5)*xi2-1/(2*a2^2)*x(7)*xi2*S2'*S2-x(8)*(pPi1_pY)^2*xi2*phi21;

varSigma1 = rp*(y*dEta)^2*phi11;
varSigma2 = varSigma1+rp*(pPi1_pY)^2*phi21*xi2^2;

% adaptive functions
dx(7) = rTheta/(2*a1^2)*xi1^2*S1'*S2 ...
    +rTheta/(2*a2^2)*xi2^2*S2'*S2 - barRTheta*x(7);
dx(8) = varSigma2-barRp*x(8);                                            

%%%%%%%%%%%%%%%%%%%%%%%%% system %%%%%%%%%%%%%%%%%%%%%%%%%
f1 = 0;
f2 = 98*x(1)-1/9*x(2)^2*sin(x(1))+0.8;
delta1 = 0;
delta2 = -0.2*x(1)+0.2*x(3);
q1 = x(4);
q2 = -x(3)-6*x(4)+0.2*y;

dx(1) = x(2)+f1+delta1;     % \dot{x}_1
dx(2) = u+f2+delta2;        % \dot{x}_2
dx(3) = q1;                  % \dot{z}
dx(4) = q2;                  % \dot{z}

%%%%%%%%%%%%%%%%%%% switched state observer %%%%%%%%%%%%%%%%%%%
dx(5) = x(6)-ell1*(x(5)-y);
dx(6) = u-ell2*(x(5)-y);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gPi1 = [gPi1, pi1];
gY = [gY, x(1)];
gHatX1 = [gHatX1, x(5)];
gTheta = [gTheta, x(7)];
gTheta1 = [gTheta1, x(8)];
gOdeTime = gOdeTime+1;