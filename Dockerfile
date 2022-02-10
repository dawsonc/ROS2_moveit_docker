FROM althack/ros2:galactic-dev 

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
   && apt-get -y install --no-install-recommends python3-colcon-common-extensions \
   python3-colcon-mixin \
   python3-vcstool \
   #
   # Clean up
   && apt-get autoremove -y \
   && apt-get clean -y \
   && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog

# Clone the moveit tutorials
WORKDIR /home/ros/ws_moveit/src
RUN git clone https://github.com/ros-planning/moveit2_tutorials.git
RUN vcs import < moveit2_tutorials/moveit2_tutorials.repos

# Get ROS dependencies
USER ros
RUN rosdep update
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update \
   && sudo apt dist-upgrade -y
ENV DEBIAN_FRONTEND=dialog

USER ros
RUN rosdep install -r --from-paths . --ignore-src --rosdistro $ROS_DISTRO -y

# Setup colcon
USER root
WORKDIR /home/ros/ws_moveit
RUN colcon mixin add default https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml \
   && colcon mixin update default

# Build
RUN colcon build --mixin release --executor parallel --parallel-workers 8

# Set up auto-source of workspace for ros user
RUN echo "if [ -f /home/ros/ws_moveit/install/setup.bash ]; then source /home/ros/ws_moveit/install/setup.bash; fi" >> /home/ros/.bashrc

