# Renode-TensorFlow
This repo will teach you how to install and run simple TensorFlow programs in Renode

## What is Renode?

```bash
docker build --no-cache -t renode_tf .
```

```bash
./run.sh
```

```bash
./enter.sh
```

Run ArduinoIDE

```bash
arduino-ide --no-sandbox
```

Run renode in separate terminal

```bash
renode
```

Load Arduino Nano 33 BLE Sense board

```bash
mach create "Arduino Nano 33 BLE Sense"
machine LoadPlatformDescription @platforms/boards/arduino_nano_33_ble.repl
```

https://renode.readthedocs.io/en/latest/introduction/supported-boards.html

Look at peripherals

```bash
peripherals
```

```bash
sysbus LoadELF @/workspace/Blink/build/arduino.mbed_nano.nano33ble/Blink.ino.elf 

start

logLevel 3
logLevel -1 gpio0

gpio0 GetGPIOs

pause
quit
```

UART 0 not working patch:

https://renode.readthedocs.io/en/latest/host-integration/arduino.html
