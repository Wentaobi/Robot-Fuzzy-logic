#include "ros/ros.h"
#include "nav_msgs/Odometry.h"

// Needed to convert rotation ...
#include <tf/LinearMath/Quaternion.h>
#include <tf/LinearMath/Matrix3x3.h>

#include "std_msgs/MultiArrayLayout.h"
#include "std_msgs/MultiArrayDimension.h"
#include "std_msgs/Float64MultiArray.h"

#define vd 2
#define wd 2
#define k2 2
#define k3 2

class tracking_control
{
public:
    tracking_control(ros::NodeHandle& nh);

    void odomCallback(const nav_msgs::Odometry::ConstPtr& msg);
    void velPublisher(double linearVelMPS, double angularVelRadPS);
    void wayPointsCallback(const std_msgs::Float64MultiArray::ConstPtr& msg);

    void spin();
    double prd_x,prd_y,prd_a;

protected:
    ros::Subscriber odomSub;
    ros::Subscriber wayPointsSub;
    ros::Publisher velPub;
};

tracking_control::tracking_control(ros::NodeHandle& nh)
{
    odomSub=nh.subscribe("odom",1,&tracking_control::odomCallback,this);
    wayPointsSub=nh.subscribe("way_points",1,&tracking_control::wayPointsCallback,this);
    velPub=nh.advertise<geometry_msgs::Twist>("cmd_vel", 1);

    //prd_x=10;
    //prd_y=4;
}
void tracking_control::wayPointsCallback(const std_msgs::Float64MultiArray::ConstPtr& msg)
{
    prd_x=msg->data[0];
    prd_y=msg->data[1];
}
void tracking_control::odomCallback(const nav_msgs::Odometry::ConstPtr& msg)
{
    double heading,pitch,roll;
    double odom_x,odom_y,odom_a;
    double error_d,error_l,error_a;
    double vc,wc;

    odom_x=msg->pose.pose.position.x;
    odom_y=msg->pose.pose.position.y;
    tf::Quaternion q = tf::Quaternion(msg->pose.pose.orientation.x, msg->pose.pose.orientation.y, msg->pose.pose.orientation.z, msg->pose.pose.orientation.w);
    tf::Matrix3x3(q).getEulerYPR(heading, pitch, roll);
    odom_a=heading;

    error_d=(prd_x-odom_x)*cos(odom_a)+(prd_y-odom_y)*sin(odom_a);
    error_l=-(prd_x-odom_x)*sin(odom_a)+(prd_y-odom_y)*cos(odom_a);
    error_a=prd_a-odom_a;

    prd_a=atan2(prd_y-odom_y,prd_x-odom_x);

    vc=vd*cos(error_a);
    wc=wd+k2*vd*error_l+k3*vd*sin(error_a);

    ROS_INFO_STREAM("prd_x: " << prd_x);
    ROS_INFO_STREAM("prd_y: " << prd_y);

    ROS_INFO_STREAM("x: " << odom_x);
    ROS_INFO_STREAM("y: " << odom_y);
    ROS_INFO_STREAM("error_a: " << error_a);
    ROS_INFO_STREAM("vc: " << vc);
    ROS_INFO_STREAM("wc: " << wc);
    ROS_INFO_STREAM("ang: " << prd_a);
    ROS_INFO_STREAM("*********************");

    velPublisher(vc,wc);

}
void tracking_control::velPublisher(double linearVelMPS, double angularVelRadPS)
{
    geometry_msgs::Twist msg;
    msg.linear.x=linearVelMPS;
    msg.angular.z = angularVelRadPS;
    velPub.publish(msg);
}
void tracking_control::spin()
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
    tracking_control tra(n);
    tra.spin();
    return 0;
}
