function MF = MembershipFunction(V,Center,Para)
k = Para.k;
L = Para.L;
dv = Para.dv;
%% rising edge
SP1 = (Center-(L+dv));
f1 = k*(V-SP1);
MF1 = max(0,f1);
MF1 = min(1,MF1);
%% falling edge
k2 = -1/dv;
SP2 = Center + L;
f2 = 1+k2*(V-SP2);
MF2 = min(1,f2);
MF2 = max(0,MF2);
MF = min(MF1,MF2);
end