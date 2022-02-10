# ROS2 MoveIt Docker

## Building

A pre-built image is available on [DockerHub](https://hub.docker.com/r/dawsonc/ros2_moveit).

To build the docker yourself (this can take a while), run `docker build -t dawsonc/ros2_moveit` from this directory.

## Running

To launch the container with GUI access, run

```
docker run \
    --network=host \
    --device=/dev/dri:/dev/dri \
    -e DISPLAY=$DISPLAY \
    --volume=/tmp/.X11-unix:/tmp/.X11-unix \
    --user ros \
    -it \
    dawsonc/ros2_moveit \
    bash
```

To run through the [MoveIt quickstart](https://moveit.picknik.ai/galactic/doc/tutorials/quickstart_in_rviz/quickstart_in_rviz_tutorial.html), start by launching the demo:

```
ros2 launch moveit2_tutorials demo.launch.py rviz_tutorial:=true
```

You should see an empty RViz window. Follow the instructions at [MoveIt quickstart](https://moveit.picknik.ai/galactic/doc/tutorials/quickstart_in_rviz/quickstart_in_rviz_tutorial.html) to play around with a MoveIt arm interface.

To run the C++ MoveIt interface demo, open two shells using the command above in different terminal windows. In the first shell, run

```
ros2 launch moveit2_tutorials move_group.launch.py
```

In the second shell, run

```
ros2 launch moveit2_tutorials move_group_interface_tutorial.launch.py
```
