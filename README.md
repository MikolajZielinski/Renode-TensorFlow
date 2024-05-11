# Renode-TensorFlow-Arduino
This repo will teach you how to install and run simple TensorFlow programs in Renode. We will use simulated Arduino Nano 33 BLE Sense board to run our code.

## What is Renode?
Renode is an open source software developed by Antmicro. It allows you to create, develop and test multinode IoT system on your local machine. Big advantage of of Renode is that you can upload the same binary code to your simulated environment and to your boards and it will work exactly the same.

## Getting started

We will use docker in this tutorial but no worries you don't need to understand docker to do all the tasks .

Use below comand do build docker image with preinstalled ArduinoIDE, Renode and TensorFlowLite. Make yourself a :coffee: because it may take a while 
```bash
docker build --no-cache -t renode_tf .
```
Once done, you can start a docker container with the bash script.
```bash
# !!! You may need to add executable permissions first !!!
sudo chmod +x run.sh

./run.sh
```
This script will take you to the docker container. It also creates `renode_workspace` in your `home` folder on the host machine. `reonde_workspace` is connected to the `workspace` folder inside container.

> :warning: **Warning** : All files will be deleted when you close the container. In order to prevent that, always save your work within `workspace` folder.

If there will be a need to open another terminal inside container just run below script.
```bash
# !!! You may need to add executable permissions first !!!
sudo chmod +x enter.sh

./enter.sh
```

## Begining with Renode

Having the environment setup we can proceed with Renode.
Run Renode in terminal (inside container).

```bash
renode
```

Renode CLI will pop up.
Now we can configure Arduino board simulation.
Inside CLI we can create a machine called `Arduino Nano 33 BLE Sense` and load its profile.

```bash
using sysbus

# Create machine, name is optional
mach create "Arduino Nano 33 BLE Sense"

# Load preconfigured board profile
machine LoadPlatformDescription @platforms/boards/arduino_nano_33_ble.repl
```
Machines in Renode as name suggests are separate devices you can simulate. 
In Renode it is possible to have multiple machines but for the sake of this tutorial we will only use one. You can check what kind of preconfigured boards are avaliable on [renode docks](https://renode.readthedocs.io/en/latest/introduction/supported-boards.html) or configure [your own](https://renode.readthedocs.io/en/latest/advanced/platform_description_format.html) with its peripherials.


Let's take a look at `Arduino Nano 33 BLE Sense` peripherals with the command.

```bash
peripherals
```
We can see among others `gpio0`, `uart0`, `uart1`. We will make use of them in this tutorial.

### Uploading Blink to the board

Blink is a simple "Hello World!" like program wihich is blinkin a LED on the Arduino borads connected to the pin 13.

Now open a new terminal inside docker and start the ArduinoIDE.

```bash
arduino-ide --no-sandbox
```

Navigate to the `Files -> Examples -> 01.Basics` and open `Blink`.
Now we have to save the project in our workspace so go to in `Files -> Save As...` and on the left hand side choose `workspace` as a directory and click `Save`.

Next step is to choose our board click on `Select Board` on the top bar and then click `Select other board and port...` from the drop down list choose `Arduino Nano 33 BLE Sense`. Then in the bottom right corner the prompt will appear asking if you would like to install board dependenices choose `Yes`.

Now you are ready to go and compile the code! To do that go to `Sketch` and select `Export Compiled Binary`. You can find binary files inside `/workspace/Blink/blink/`

```bash
ls /workspace/Blink/blink/
```
Let's go back to Renode CLI and upload the code to the board.

```bash
# You may need to change the path
sysbus LoadELF @/workspace/Blink/build/arduino.mbed_nano.nano33ble/Blink.ino.elf 
```

Finally we can start the board and see what's hapenning.

```bash
start

# You have to set proper logging levels in order to observe changes in real time
logLevel 3
logLevel -1 gpio0

# Alternatively you can use this command to check gpio0 status only once
gpio0 GetGPIOs
```
In the terminal window form which we started Renode we shoud now see something like this:

```
01:47:22.8103 [NOISY] gpio0: Setting pin 13 output to True
01:47:23.8260 [NOISY] gpio0: Setting pin 13 output to False
```
The LED is blinking :tada:!

To pause or quit simply use
```bash
pause
quit
```
Once finished with this tutorial you can just remove the docker image
```bash
docker rmi renode_tf
```

> :warning: **Warning** : In theory to upload new code to the board you should pause it upload the code and start it again. It never worked for me that way. Each time I had to use `Clear` command and configure the board once again. It is very frustrating but at the moment of writing this, it is the only solution I found to this problem.

### Task for you

Make a program which will send `"ON"` message over serial port when the LED is on and `"OFF"` otherwise.

To see what is coming on uart use the command

```bash
showAnalyzer sysbus.uart0
```

> :warning: **Warning** : Renode right now does not support USB_Uart so in your code use `Serial1` instead of `Serial`.

## Running TensorFlow

TensorFlowLite is preinstalled in this docker image. We will run `hello world` example from `File -> Examples -> Arduino_TensorFlowLite`. In this example a model is trying to predict sine wave values in a loop and is printing them to the uart. Open, save and compile the code same way as previously, then run it in Renode with

```bash
using sysbus
mach create "Arduino Nano 33 BLE Sense"
machine LoadPlatformDescription @platforms/boards/arduino_nano_33_ble.repl

# You may need to change the path
sysbus LoadELF @/workspace/hello_world/build/arduino.mbed_nano.nano33ble/hello_world.ino.elf

start
```
We can observe sine wave values with command

```bash
showAnalyzer sysbus.uart0
```

### Task for you

You can find informations on how to prepare, train, and compile model for uploading into Arduino in [this](https://www.youtube.com/watch?v=BzzqYNYOcWc) and [this](https://www.youtube.com/watch?v=dU01M61RW8s&t=37s) tutorials. Based on them create a model which will be bahaving as XOR logic gate. Make it work in a loop and print input values and output result into serial port.

The final output should look like this:
```
0 0 | 0
0 1 | 1
1 0 | 1
1 1 | 0
```