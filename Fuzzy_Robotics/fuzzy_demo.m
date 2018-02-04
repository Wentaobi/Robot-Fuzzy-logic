%% Connect to ROS master
% in this section, what I do is connect Matlab and ROS-Gazebo by configure
% their ip_address. notes: if you wanna close, plsease use "rosshutdown"
% first.
clear all;
setenv('ROS_MASTER_URI','http://192.168.12.42:11311')
setenv('ROS_IP','192.168.12.42')
rosinit('192.168.12.42','NodeHost','192.168.12.42','NodeName','/fuzzy_control');
disp('Ros initial Succeed!');
rostopic list
%% Fuzzy Control
% Define global veriables for value passing between script and function,
% I have fuzzy.m and lidar.m srcipt, these value can be used wherever.
global target_ob;           % target_object position [*,*]
global k2;                  % Neural controller two parameters
global k3;
global vel_pub;             % parameter to get velocity from ROS-Gazebo
global oa;
global fbs;
% Setup initial value for Neural controller
vd=2;
wd=2;
k2=2;
k3=4;
% Initial fuzzy lab
target_ob=[-7,7];
% Initialize fuzzy files
oa=readfis('oa');
fbs=readfis('fbs');
% ROS Publisher define
vel_pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist');
% ROS Subscriber define
command_sub = rossubscriber('/command',@fuzzy_control);
scan_sub = rossubscriber('/base_scan',@scan_plot);
