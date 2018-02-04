function fuzzy_control(~,msgs)
    % Define global veriables for value passing between script and function
    global target_ob;
    global k2;
    global k3;
    global vel_pub;
    global oa;
    global fbs;
    % test callback function
%     disp('Callback received!');
    %%% ROS communication
    % ROS subscriber data receive process
    command_array=msgs.Data;
    d2=command_array(1);
    d3=command_array(2);
    d4=command_array(3);
    odom_x=command_array(4);
    odom_y=command_array(5);
    odom_a=command_array(6);

    %%% Fuzzy Control Part
    %setup scan array
    scan=[d2 d3 d4];
    %setup maximum boundry for input of OA
    if(d2>=5)
        d2=4.9;
    end
    if(d3>=5)
        d3=4.9;
    end
    if(d4>=5)
        d4=4.9;
    end
    %set input array for OA
    in_fuzzy=[d2 d3 d4];
    %OA fuzzy processing
    oa_out=evalfis(in_fuzzy,oa);
    %%calculate angel between goal and robot
    doa=atan2(target_ob(2)-odom_y,target_ob(1)-odom_x)-odom_a;
    %make angle in range (-pi, pi)
    while (doa>pi)||(doa<-pi)
        if(doa>pi)
            doa=doa-2*pi;
        end
        if(doa<-pi)
            doa=doa+2*pi;
        end
    end
    %Neural tracking control
    %calculate desired angle for neural control
    prd_a=atan2(target_ob(2)-odom_y,target_ob(1)-odom_x);
    %calculate intpu error
    error_l=-(target_ob(1)-odom_x)*sin(odom_a)+(target_ob(2)-odom_y)*cos(odom_a);
    error_a=prd_a-odom_a;
    %velocity calculate
    vc=oa_out(1)*cos(error_a);
    wc=oa_out(2)+k2*oa_out(1)*error_l+k3*oa_out(1)*sin(error_a);
    %calculate input of the 
    dmin=min(in_fuzzy);
    dot=ceil((doa+1.5*pi/2)/(1.5*pi/5));
    %weight caluclate input setting
    fbs_in=[dmin,scan(dot-1)];
    %weight calculate fuzzy processing
    fbs_out=evalfis(fbs_in,fbs);
    %calculate distance towards goal
    dt=((odom_x-target_ob(1))^2+(odom_y-target_ob(2))^2)^0.5;
    %if achieve goal
    if(dt>1)
        if(fbs_out<0.5) 
            w=oa_out(2);
            v=oa_out(1);
        else
            w=-wc;
            v=vc;
        end
    else
        v=0;
        w=0;
        disp('Target achieved!');
        rosshutdown;
        pause(2);
        close all;
        pause(0.5);
        return;
    end

    %%% ROS communication
    % ROS publish
    vel_msgs= rosmessage(vel_pub);
    vel_msgs.Linear.X=v;
    vel_msgs.Angular.Z=-w;
    send(vel_pub,vel_msgs);
    disp('Command Published!');
end
