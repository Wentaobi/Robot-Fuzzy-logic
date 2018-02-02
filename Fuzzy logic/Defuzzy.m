% This function controls the robot based on the Fuzzy logic.
% Input: IR Left: Far, Close, Very Close
%        IR Front: Far, Close, Very Close
%        IR Right: Far, Close, Very Close
% Output: Go Forward: Fast/slow
%         Turn Left: Fast/Slow
%         Turn Right: Fast/Slow
%         Reverse
function Behavior = Defuzzy(IRLeft,IRFront,IRRight)
% case #1
if (strcmp(IRLeft,'Far')&&strcmp(IRFront,'Far')&&strcmp(IRRight,'Far'))
    Behavior = 'ForwardFast';
    % case #2
elseif(strcmp(IRLeft,'Far')&&strcmp(IRFront,'Far')&&strcmp(IRRight,'Close'))
    Behavior = 'ForwardSlow';
    % case #3
elseif(strcmp(IRLeft,'Far')&&strcmp(IRFront,'Far')&&strcmp(IRRight,'VeryClose'))
    Behavior = 'TurnLeftFast';
    % case #4
elseif(strcmp(IRLeft,'Far')&&strcmp(IRFront,'Close')&&strcmp(IRRight,'Far'))
    Behavior = 'ForwardSlow';
    % case #5
elseif(strcmp(IRLeft,'Far')&&strcmp(IRFront,'VeryClose')&&strcmp(IRRight,'Far'))
    Behavior = 'TurnRightFast';
    % case #6
elseif(strcmp(IRLeft,'Far')&&strcmp(IRFront,'Close')&&strcmp(IRRight,'Close'))
    Behavior = 'ForwardSlow';
    % case #7
elseif(strcmp(IRLeft,'Far')&&strcmp(IRFront,'Close')&&strcmp(IRRight,'Very Close'))
    Behavior = 'TurnLeftFast';
    % case #8
elseif(strcmp(IRLeft,'Far')&&strcmp(IRFront,'VeryClose')&&strcmp(IRRight,'Close'))
    Behavior = 'TurnRightFast';
    % case #9
elseif(strcmp(IRLeft,'Far')&&strcmp(IRFront,'VeryClose')&&strcmp(IRRight,'VeryClose'))
    Behavior = 'TurnLeftFast';
    % case #10
elseif(strcmp(IRLeft,'Close')&&strcmp(IRFront,'Far')&&strcmp(IRRight,'Far'))
    Behavior = 'ForwardSlow';
    % case #11
elseif(strcmp(IRLeft,'VeryClose')&&strcmp(IRFront,'Far')&&strcmp(IRRight,'Far'))
    Behavior = 'TurnRightFast';
    % case #12
elseif(strcmp(IRLeft,'Close')&&strcmp(IRFront,'Far')&&strcmp(IRRight,'Close'))
    Behavior = 'Reverse';
    % case #13
elseif(strcmp(IRLeft,'Close')&&strcmp(IRFront,'Far')&&strcmp(IRRight,'VeryClose'))
    Behavior = 'ForwardSlow';
    % case #14
elseif(strcmp(IRLeft,'Close')&&strcmp(IRFront,'Close')&&strcmp(IRRight,'Close'))
    Behavior = 'Reverse';
    % case #15
elseif(strcmp(IRLeft,'Close')&&strcmp(IRFront,'Close')&&strcmp(IRRight,'VeryClose'))
    Behavior = 'TurnLeftFast';
    % case #16
elseif(strcmp(IRLeft,'Close')&&strcmp(IRFront,'Close')&&strcmp(IRRight,'Far'))
    Behavior = 'TurnRightSlow';
    % case #17
elseif(strcmp(IRLeft,'Very Close')&&strcmp(IRFront,'Far')&&strcmp(IRRight ,'Close'))
    Behavior = 'TurnRightFast';
    % case #18
elseif(strcmp(IRLeft,'Very Close')&&strcmp(IRFront,'Far')&&strcmp(IRRight,'VeryClose'))
    Behavior = 'Reverse';
    % case #19
elseif(strcmp(IRLeft,'Very Close')&&strcmp(IRFront,'Close')&&strcmp(IRRight,'Close'))
    Behavior = 'TurnRightFast';
    % case #20
elseif(strcmp(IRLeft,'VeryClose')&&strcmp(IRFront,'Close')&&strcmp(IRRight,'VeryClose'))
    Behavior = 'Reverse';
    % case #21
elseif(strcmp(IRLeft,'VeryClose')&&strcmp(IRFront,'Close')&&strcmp(IRRight,'Far'))
    Behavior = 'TurnRightFast';
    % case #22
elseif(strcmp(IRLeft,'Close')&&strcmp(IRFront,'VeryClose')&&strcmp(IRRight,'Far'))
    Behavior = 'Reverse';
    % case #23
elseif(strcmp(IRLeft,'Close')&&strcmp(IRFront,'VeryClose')&&strcmp(IRRight,'Close'))
    Behavior = 'Reverse';
    % case #24
elseif(strcmp(IRLeft,'Close')&&strcmp(IRFront,'VeryClose')&&strcmp(IRRight,'VeryClose'))
    Behavior = 'Reverse';
    % case #25
elseif(strcmp(IRLeft,'VeryClose')&&strcmp(IRFront,'VeryClose')&&strcmp(IRRight,'Far'))
    Behavior = 'TurnRightFast';
    % case #26
elseif(strcmp(IRLeft,'VeryClose')&&strcmp(IRFront,'VeryClose')&&strcmp(IRRight,'Close'))
    Behavior = 'Reverse';
    % case #27
elseif(strcmp(IRLeft,'VeryClose')&&strcmp(IRFront,'VeryClose')&&strcmp(IRRight,'VeryClose'))
    Behavior = 'Reverse';
end
end