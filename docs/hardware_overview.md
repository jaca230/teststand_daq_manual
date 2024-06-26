# Hardware Documentation

## General Hardware Overview
### Conceptual Diagram (One Crate System)
![DAQ_Diagram](images/DAQ_Diagram.png){: style="max-width:100%; height:auto;"}

- **Differential signal into WFD5 (Waveform Digitizer)**: Differential signaling are input into Cornell's WFD5s. Data is aggregated by AMC13 on triggers.
- **Trigger signal into FC7 (Flexible Controller)**: Provides flexible triggering, FC7 sends trigger signals over optical links to the AMC13.
- **AMC13 (Advanced Mezzanine Card)**: Aggregates data from digitizers on a trigger and packages for sending over 10GbE (10 Gigabit Ethernet). Transfers this to the desktop for further processing.
- **MCH (MicroTCA Carrier Hub)**: Facilitates communication between the desktop and the crate system via 1GbE Ethernet, managing system-level (crate) operations in a way.
- **Desktop CPU**: Processes events received from the AMC13. Data is unpacked and formed into midas events for storage.
- **Meinberg**: Provides precise trigger timestamps using GPS timing. This is an artifact of g-2 more than anything, were multiple disconnected systems needed to be correlated. 

### Labled Picture (One Crate System)
![DAQ_Diagram](images/DAQ_image_labled.png){: style="max-width:100%; height:auto;"}

---

## IPMI

### Overview

Intelligent Platform Management Interface (IPMI) is a standardized interface used for managing and monitoring computer systems. It allows for the remote management of systems independently of the operating system state or the system's power state. IPMI provides a way to manage a server using a set of standardized commands and messages that can be sent over a network or via a direct serial connection.

### Features of IPMI

- **Remote Management**: Allows administrators to remotely manage systems, including power on/off, rebooting, and accessing system logs.
- **Hardware Monitoring**: Monitors hardware components like temperature, voltage, fans, and power supply status.
- **Serial Over LAN (SOL)**: Provides serial console access over a network, allowing remote troubleshooting and management.
- **Event Logging**: Logs critical system events such as hardware failures or temperature thresholds being exceeded.
- **Security**: Supports user authentication, encrypted communication, and access control.

### Common IPMI Tools

- **ipmitool**: A command-line utility for managing IPMI-enabled devices. It supports a wide range of commands for sensor reading, system status checking, power control, and firmware updates. ipmitool commands are the building blocks used in many of the configuration scripts for the hardware. See [ipmitool](software_dependencies.md#ipmitool) for more information.

### Example Commands Using `ipmitool`

1 **Print Field Replaceable Unit (FRU) Information**:

```
ipmitool -H 192.168.1.41 fru print
```

This command retrieves and prints the Field Replaceable Unit (FRU) information from the IPMI device located at IP address `192.168.1.41`.

- `-H 192.168.1.41`: Specifies the IP address of the IPMI device. Replace `192.168.1.41` with the actual IP address of your IPMI device.
- `fru print`: Command to retrieve and display the FRU information. FRU information includes details about hardware components that can be replaced in the system, such as part numbers and descriptions.

2 **Send Raw Command to IPMI Device**:

```
ipmitool -I lan -H 192.168.1.41 -m 0x20 -B 0 -T 0x82 -b 7 -t 0x86 raw 0x06 0x1
```

This command sends a raw IPMI command to a device over LAN with specified parameters.

- `-I lan`: Specifies the interface type (`lan` in this case), which indicates that the IPMI command will be sent over the LAN interface.
- `-H 192.168.1.41`: Specifies the IP address of the IPMI device.
- `-m 0x20`: Specifies the channel number to communicate with the BMC (Baseboard Management Controller). The default is usually `0x20`, but for some reason we need to specify this on some systems.
- `-B 0`: Specifies the BMC instance number.
- `-T 0x82`: Specifies the target address in the IPMI device. This is the MCH.
- `-b 7`: Specifies the bus number.
- `-t 0x86`: Specifies the target channel number. This is the device you're targeting, in this case it's FC7 in slot 11 of the microTCA crate.
- `raw 0x06 0x1`: Command to send a raw IPMI command (`0x06 0x1` in this case) to the specified IPMI device. The raw command `0x06 0x1` varies based on the specific IPMI command you intend to send.

You can read a bit more about these commands in the manuals linked in the [MCH section](hardware_overview.md#mch-microtca-carrier-hub).

---

## WFD5 (Waveform Digitizer)

### Configuration

### Updating Firmware

---

## FC7 (Flexible Controller)

### Configuration

### Updating Firmware

---

## AMC13 (Advanced Mezzanine Card)

### Configuration

### Updating Firmware

---

## MCH (MicroTCA Carrier Hub)

### Configuration
