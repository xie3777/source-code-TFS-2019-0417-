function dx = switchedSubSys2(t,x)

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
ell1=2;
ell2=2;

% the determined nonlinear function
y=x(1);
v1 = y^2+18;
dEta = 52*y^6+1;
eta = 13*y^8+y^2;
psi11 = 5*y^2;
psi21 = 1.1*y^2;

barPsi11 = psi11/y;       
barPsi21 = psi21/y;

%%%%%%%%%%%%%%%%%%%%%%%%%%% fuzzy logic system %%%%%%%%%%%%%%%%%%%%%%%%%%%
bigZ11 = [x(1)]';                                   
bigZ12 = [x(1), x(4), x(6), x(7)]';     
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
pi1 = -0.5*xi1-1/(2*a1^2)*x(6)*xi1*S1'*S1-x(7)*phi11*y*dEta-y*v1;

xi2 = x(5)-pi1;                                                   
pPi1_pY = pApB(pi1, y);
u = -(c2+0.5)*xi2-1/(2*a2^2)*x(6)*xi2*S2'*S2-x(7)*(pPi1_pY)^2*xi2*phi21;

varSigma1 = rp*(y*dEta)^2*phi11;
varSigma2 = varSigma1+rp*(pPi1_pY)^2*phi21*xi2^2;

% adaptive functions
dx(6) = rTheta/(2*a1^2)*xi1^2*S1'*S2 ...
    +rTheta/(2*a2^2)*xi2^2*S2'*S2 - barRTheta*x(6);
dx(7) = varSigma2-barRp*x(7);                                            

%%%%%%%%%%%%%%%%%%% switched state observer %%%%%%%%%%%%%%%%%%%
f1 = 2*x(1)*sin(x(1)^2);
f2 = 2*x(1)*x(2)^2*sin(x(2));
delta1 = x(1)*x(3)*sin(x(1));
delta2 = x(1)*x(3)*sin(x(1)^2);
q = -2*x(3)+0.05*x(1)^2*sin(x(2))^2;

dx(1) = x(2)+f1+delta1;     % \dot{x}_1
dx(2) = u+f2+delta2;        % \dot{x}_2
dx(3) = q;                  % \dot{z}

%%%%%%%%%%%%%%%%%%% switched state observer %%%%%%%%%%%%%%%%%%%
dx(4) = x(5)-ell1*(x(4)-y);
dx(5) = u-ell2*(x(4)-y);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gPi1 = [gPi1, pi1];
gY = [gY, x(1)];
gHatX1 = [gHatX1, x(4)];
gTheta = [gTheta, x(6)];
gTheta1 = [gTheta1, x(7)];
gOdeTime = gOdeTime+1;