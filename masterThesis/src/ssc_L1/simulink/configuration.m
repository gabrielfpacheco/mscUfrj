% System configuration
s = tf('s');

% Charge system parameters
ref = 3;
stepTimeRef = 1;
sigma = 2;
stepTimeSigma = 10;

% L1-AC
Gamma = 10;
tau_l1ac = 0.075;

% SSC
knom = 2;
tau_ssc = 0.001;

% Reference Model
M = 1/(0.5*s+1);
[Am,Bm,Cm,Dm] = tf2ss(M.num{1},M.den{1});
xm0 = zeros(size(Am,2),1);

% Plant Model
K=1; 
tau=1;
Gp = K/(tau*s+1); %(s+1)/((s+2)*(s+3));
[A,B,C,D] = tf2ss(Gp.num{1},Gp.den{1});
x0 = zeros(size(A,2),1);
kg = 1/(-C/A*B); % DC gain 
