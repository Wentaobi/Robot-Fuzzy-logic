#include "ros/ros.h"
#include "nav_msgs/Odometry.h"
#include "sensor_msgs/LaserScan.h"

// Needed to convert rotation ...
#include <tf/LinearMath/Quaternion.h>
#include <tf/LinearMath/Matrix3x3.h>

#include "std_msgs/MultiArrayLayout.h"
#include "std_msgs/MultiArrayDimension.h"
#include "std_msgs/Float64MultiArray.h"

class fuzzy_control
{
public:
    fuzzy_control(ros::NodeHandle& nh);

    void odomCallback(const nav_msgs::Odometry::ConstPtr& msg);
    void scanCallback(const sensor_msgs::LaserScan::ConstPtr& msg);
    void velPublisher(double linearVelMPS, double angularVelRadPS);

    void spin();

protected:
    ros::Subscriber odomSub;
    ros::Subscriber scanSub;
    ros::Publisher velPub;
    ros::Publisher commandPub;

    double odom_x,odom_y,odom_a;
    double odom_x_prev,odom_y_prev;
};

fuzzy_control::fuzzy_control(ros::NodeHandle& nh)
{
    odom_x_prev=0;
    odom_y_prev=0;
    odomSub=nh.subscribe("base_pose_ground_truth",1,&fuzzy_control::odomCallback,this);
    scanSub=nh.subscribe("base_scan",1,&fuzzy_control::scanCallback,this);
    velPub=nh.advertise<geometry_msgs::Twist>("cmd_vel", 1);
    commandPub=nh.advertise<std_msgs::Float64MultiArray>("command", 1);
}
void fuzzy_control::scanCallback(const sensor_msgs::LaserScan::ConstPtr& msg)
{
    int index_scan,i;
    double angle_min,angle_max,angle_increment;
    double d2,d3,d4;
    
    d2=20;
    d3=20;
    d4=20;
    angle_min = msg->angle_min;
    angle_max = msg->angle_max;
    angle_increment = msg->angle_increment;

    index_scan=ceil((angle_max-angle_min)/angle_increment);
    for(i=index_scan/5;i<2*(index_scan/5);i++)
    {
        if(d2>msg->ranges[i]) d2=msg->ranges[i];
    }
    for(i=9*(index_scan/19);i<10*(index_scan/19);i++)
    {
        if(d3>msg->ranges[i]) d3=msg->ranges[i];
    }
    for(i=3*(index_scan/5);i<4*(index_scan/5);i++)
    {
        if(d4>msg->ranges[i]) d4=msg->ranges[i];
    }
    //ROS_INFO_STREAM("d2 " << d2);
    //ROS_INFO_STREAM("d3 " << d3);
    //ROS_INFO_STREAM("d4 " << d4);
    if((odom_x!=odom_x_prev)&&(odom_y!=odom_y_prev))
    {    
	ROS_INFO_STREAM("*********************");
	ROS_INFO_STREAM("x:" << odom_x);
 	ROS_INFO_STREAM("y:" << odom_y);
    }

    odom_x_prev=odom_x;
    odom_y_prev=odom_y;

    std_msgs::Float64MultiArray command_val;
    command_val.data.clear();

    command_val.data.push_back(d2);
    command_val.data.push_back(d3);
    command_val.data.push_back(d4);
    command_val.data.push_back(odom_x);
    command_val.data.push_back(odom_y);
    command_val.data.push_back(odom_a);
    commandPub.publish(command_val);


}
void fuzzy_control::odomCallback(const nav_msgs::Odometry::ConstPtr& msg)
{
    double heading,pitch,roll;

    odom_x=msg->pose.pose.position.x;
    odom_y=msg->pose.pose.position.y;
    tf::Quaternion q = tf::Quaternion(msg->pose.pose.orientation.x, msg->pose.pose.orientation.y, msg->pose.pose.orientation.z, msg->pose.pose.orientation.w);
    tf::Matrix3x3(q).getEulerYPR(heading, pitch, roll);
    odom_a=heading;

}
void fuzzy_control::velPublisher(double linearVelMPS, double angularVelRadPS)
{
    geometry_msgs::Twist msg;
    msg.linear.x=linearVelMPS;
    msg.angular.z = angularVelRadPS;
    velPub.publish(msg);
}
void fuzzy_control::spin()
{
    ros::Rate rate(10);
    while(ros::ok())
    {
        srand(time(0));
        ros::spinOnce();
        rate.sleep();
    }
}

int main(int argc,char **argv)
{
    ros::init(argc,argv,"tracking_control");
    ros::NodeHandle n;
    fuzzy_control tra(n);
    tra.spin();
    return 0;
}
