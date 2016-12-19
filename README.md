#Humanoid Robot Framework for Research on Cognitive Robotics

## Cognitive algorithms for Humanoid Robots

AI is built upon the Cross Architecture \[[1]] \[[2]]. Some methods used for the Vision System can be found in \[[3]] and \[[4]]. A Control technique applied to improve the robot's stability can be found in \[[5]]. A qualitative localization studied for the robot can be found in \[[6]].

[1]: http://dx.doi.org/10.1109/SBR.LARS.Robocontrol.2014.39
[2]: http://dx.doi.org/10.1007/978-3-662-48134-9_4
[3]: http://dx.doi.org/10.1109/SBR.LARS.Robocontrol.2014.51
[4]: http://dx.doi.org/10.1109/LARS-SBR.2015.43
[5]: http://dx.doi.org/10.1109/LARS-SBR.2015.41
[6]: http://dx.doi.org/10.1109/LARS-SBR.2015.44


### Setup

1. compile the code of the robot running *./setup.sh*

## Simulator

RoboFEI-HT simulator used for developing AI (decision, localization, planning etc).

### Setup

1. Once the AI is compiled, run *./start_simulator.sh* for running the simulator and the AI

2. Press *a* for inserting each robot on the soccer field 

### Changing objects' positions

**Robots:** It is possible to change the position of the robots by pressing the number of the robot + *INSERT*. Example: if I want to change robot 1 position I will press *1* followed by *INSERT*. The robot will be moved following the mouse pointer position. The orientation will be random.

**Ball:** It is possible to change the position of the ball by pressing *b*. The ball will be moved following the mouse pointer position.

### Simulator Help

**F1:** opens a help with all the possible commands in the simulator.

## Telemetry

RoboFEI-HT telemetry interface used for remote monitoring of real robots.

### Setup Telemetry Variables

1. Certify that the desired variable is been published in the shared memory.

2. Insert the variables into the communication protocol, by editing  *AI/Communication/src/sending.py*. 
Find out `End of Message`, which appends an **"OUT"** to the message string.
Then insert the wanted variable in string format.

3. Now the variables need to be added to the telemetry, by editing *Simulator/telemetry.py*.
Add the variable to `self.variables` on the `__init__()`function of the class `Telemetry`.
Note that it is an Array composed of `["Variables_Name", True, "Initial_Value"]`, where **True** signs if the variable should be shown from default. 

4. Still on *telemetry.py*, in function `change()`, find out where the telemetry reads the **"OUT"** message, then save the next `data` to the variable just added on the previous step.

5. To finish the process the **"OUT"** message has to come as the last part of `data`.

### Running

1. Turn on every wanted process on the robot.

2. On a computer, connected at the same network as the robot, run *./start_telemetry.sh*.

3. A symbol of the robot should appear on the interface.

## OS and dependencies for AI and Simulator

This program was tested in Ubuntu 14.04 LTS 64 bits

* Main Dependencies:
    * cmake
    * g++
    * python 2.7 
    * python-pygame
    * python-numpy
    * python-opencv
    * libboost-all-dev
    
## License

GNU GENERAL PUBLIC LICENSE.
Version 3, 29 June 2007
   
