% This function is implemented to read the IR analog signal
% If the obstacle is far the input voltage is 5V
function [Obstacles MF] = IRReading(V,Vmax,Vmin)
%% Parameters
Para.L = 0.5;
Para.dv=1;
Para.k=1/Para.dv;
MF.Far = 0;
MF.Close = 0;
MF.VeryClose = 0;
%% Far
Center = 0.5;
Temp = MembershipFunction(V,Center,Para);
MF.Far = Temp;
%% Close
Center = (Vmin+Vmax)/2;
Temp = MembershipFunction(V,Center,Para);
MF.Close = Temp;
%% Very close
Center  = 4.5;
Temp = MembershipFunction(V,Center,Para);
MF.VeryClose = MembershipFunction(V,Center,Para);
%%
[Val Idx] = max([MF.Far MF.Close MF.VeryClose]);
% Generate the fuzzy value of the IR reading
if Idx==1 % Obstacle is far
    Obstacles = 'Far';
elseif Idx==2 % Obstacle is close
    Obstacles = 'Close';
else % Very close
    Obstacles = 'VeryClose';
end
end