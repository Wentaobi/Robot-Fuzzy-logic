function [SpeedLeft SpeedRight] = DriveRobot(Behavior)
switch Behavior
    case 'ForwardFast'
        SpeedLeft = 10;
        SpeedRight = 10;
    case 'ForwardSlow'
        SpeedLeft = 5;
        SpeedRight = 5;
    case 'TurnRightFast'
        SpeedLeft = 10;
        SpeedRight = 0;
    case 'TurnRightSlow'
        SpeedLeft = 5;
        SpeedRight = 0;
    case 'TurnLeftFast'
        SpeedLeft = 0;
        SpeedRight = 10;
    case 'TurnLeftSlow'
        SpeedLeft = 0;
        SpeedRight = 5;
    case 'Reverse'
        SpeedLeft = -5;
        SpeedRight = -5;
end
end