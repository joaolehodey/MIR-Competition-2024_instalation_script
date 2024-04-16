#!/bin/bash

set -e

UBUNTU_RELEASE="`lsb_release -rs`"

if [[ "${UBUNTU_RELEASE}" != "22.04" ]]
then 
	echo "Your version of ubuntu is not supported, please install UBUNTU 22.04"
	exit 1
fi

### ROS 2 Instalation

locale  # check for UTF-8

sudo apt update && sudo apt install locales -y
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

sudo apt install software-properties-common -y
sudo add-apt-repository universe -y

sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update -y

sudo apt upgrade -y

sudo apt install ros-humble-desktop -y

sudo apt install ros-dev-tools -y

echo "ROS2 successfully Installed"

### Colcon build tools

sudo apt install python3-colcon-common-extensions -y
echo "Colcon build tools successfully Installed"
### PX4 Instalation

cd
mkdir MIR_Project_2024 && cd MIR_Project_2024

git clone --recurse-submodules https://github.com/joaolehodey/PX4-Autopilot

cd PX4-Autopilot

make clean
make distclean
git checkout glassy_MIR
make submodulesclean

bash ./Tools/setup/ubuntu.sh

echo "PX4-Autopilot successfully Installed"
### Gazebo classic Instalation
curl -sSL http://get.gazebosim.org | sh

### QGroundControl

cd ~/MIR_Project_2024
mkdir QGroundControl && cd QGroundControl

sudo usermod -a -G dialout $USER
sudo apt-get remove modemmanager -y
sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
sudo apt install libfuse2 -y
sudo apt install libxcb-xinerama0 libxkbcommon-x11-0 libxcb-cursor0 -y

wget https://github.com/mavlink/qgroundcontrol/releases/download/v4.3.0/QGroundControl.AppImage
chmod +x ./QGroundControl.AppImage


### Install Eigen3 (check if this works else try the other method)
sudo apt install libeigen3-dev

### uXRCE-DDS (PX4-ROS 2/DDS Bridge) 
cd ~/MIR_Project_2024

git clone https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
cd Micro-XRCE-DDS-Agent
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig /usr/local/lib/

### Challenge Code
cd ~/MIR_Project_2024

mkdir glassy_challenge_ws && cd glassy_challenge_ws
mkdir src && cd src

git clone https://github.com/joaolehodey/summer_challenge_IST_DSOR.git .
git clone https://github.com/PX4/px4_msgs.git

source /opt/ros/humble/setup.bash

cd ~/MIR_Project_2024/glassy_challenge_ws
colcon build

echo 'source /opt/ros/humble/setup.bash' >> ~/.bashrc 
echo  'source ~/MIR_Project_2024/glassy_challenge_ws/install/setup.bash' >> ~/.bashrc 

pip install scipy --upgrade






