clear all;
close all;
clc;
%% Initialize parameters
Vmax = 4; % voltage
Vmin = 1; % voltage
%% Plot the fuzzy input membership function
figure;
MembershipPlot(Vmin,Vmax);
%% Main loop starts from here
while (1)
    % Input IRs' voltage from keyboard
    VLeftStr = input('Please Input Left IR Voltage for simulation:   ','s');
    VLeft = str2double(VLeftStr);
    VFrontStr = input('Please Input Front IR Voltage for simulation:   ','s');
    VFront = str2double(VFrontStr);
    VRightStr = input('Please Input Right IR Voltage for simulation:   ','s');
    VRight = str2double(VRightStr);
    % Read the IR sensor using Fuzzy membership function
    [IRLeft MFLeft] = IRReading(VLeft,Vmax,Vmin);
    [IRFront MFFront] = IRReading(VFront,Vmax,Vmin);
    [IRRight MFRight] = IRReading(VRight,Vmax,Vmin);
    % Generate the behavior of the robot using Fuzzy logic
    Behavior = Defuzzy(IRLeft,IRFront,IRRight);
    % Set the speed of two wheels
    [SpeedLeft SpeedRight] = DriveRobot(Behavior);
    % Wait for the robot executes
    t = rand; % 0~1 second
    str = [Behavior, '  Left Wheel Speed: ',num2str(SpeedLeft),' Right Wheel Speed: ',num2str(SpeedRight),' Traveling Time: ',num2str(t)];
    disp(str)
    pause(t);
end
%% End of main loop