# Miscellaneous Information

## Initialism Cheatsheet
| Initialism | Meaning                               | Example                      |
|------------|---------------------------------------|------------------------------|
| DAQ        | Data Acquisition                      |                              |
| ADC        | Analog-to-Digital Converter           |                              |
| 10GbE      | 10 Gigabit Ethernet                   |                              |
| AFE        | Analog Front End                      |                              |
| FPGA       | Field Programmable Gate Array          |                              |
| CPU        | Central Processing Unit               | Intel Core i7-12700K         |
| GPU        | Graphics Processing Unit              | NVIDIA A5000                 |
| uTCA (µTCA)| Micro Telecommunications Computing Architecture |                        |
| WFD        | Waveform Digitizer                    | WFD5                         |
| FC         | Flexible Controller                   | FC7                          |
| AMC        | Advanced Mezzanine Card               | AMC13 (also FC7 and WFD5)    |
| MCH        | MicroTCA Carrier Hub                  |                              |
| DDR        | Double Data Rate                      | DDR3, DDR4 (RAM)             |
| PCIe       | Peripheral Component Interconnect Express | PCIe2, PCIe3, ...         |

---

## Differential Signals

![Differential_signal](images/Differential_signal.png){: style="max-width:100%; height:auto;"}

Differential signals offer several advantages over single-ended signals:

- **More resistant to noise**: Differential signaling reduces susceptibility to noise interference, resulting in cleaner signal transmission.
- **Lower supply voltages**: Differential signaling allows for the use of lower supply voltages (like Low Voltage CMOS (LVCMOS) at 3.0–3.3V), which can lead to reduced power consumption.
- **Higher operating frequencies**: Due to better noise immunity and lower voltage swings, differential signals enable higher operating frequencies in electronic circuits.

[Read more about differential signaling on Wikipedia](https://en.wikipedia.org/wiki/Differential_signalling).

---

## Limitations of Meinberg Card
The meinberg card seems to be limited to rates of ~2.5KHz. As a result for higher rate applications the card cannot be used.

---

## Port Forwarding an SSH Connection

In many cases, you will need to access a web server running on a remote machine that has no Graphical User Interface (GUI). This can be done securely using SSH port forwarding. Below are instructions for setting up port forwarding on a RHEL Linux machine so you can view a webpage served on `localhost:8080` from your local machine with a GUI (ex. laptop).

### Prerequisites

- SSH access to the remote RHEL Linux machine.
- An SSH client on your local machine. e.g. `ssh` command in a terminal, (you can also use PuTTY on Windows though I would not recommend this; you can still use ssh on windows).
- Ensure the remote machine is configured to allow SSH connections. The SSH service should be running, and the firewall should permit SSH traffic (usually on port 22).

### Instructions

1. **Ensure SSH service is running on the remote machine:**

    ```
    sudo systemctl start sshd
    sudo systemctl enable sshd
    ```

2. **Configure the firewall to allow SSH connections on the remote machine:**

    ```
    sudo firewall-cmd --permanent --add-service=ssh
    sudo firewall-cmd --reload
    ```

3. **Open a terminal on your local machine.**

4. **Establish an SSH connection with port forwarding:**

    Use the following command to create an SSH tunnel. Replace `user` with your username on the remote machine and `remote_host` with the IP address or hostname of the remote machine.

    ```
    ssh -L 8080:localhost:8080 user@remote_host
    ```

    This command forwards your laptop's port `8080` to the remote machine's port `8080`. Here's a breakdown of the command:

    - `-L 8080:localhost:8080`: Specifies the local port (`8080`) to be forwarded to the remote port (`8080` on `localhost` of the remote machine).
    - `user@remote_host`: The SSH login to the remote machine.

5. **Access the webpage:**

    Open a web browser on your laptop and navigate to:

    ```
    http://localhost:8080
    ```

    You should see the webpage served by the remote machine on port `8080`.

### Example

If you want to access the root user on a machine with IP 192.168.50.10:

ssh -L 8080:localhost:8080 root@192.168.50.10

After running this command, open a browser on your laptop and go to `http://localhost:8080` to view the webpage hosted on the remote machine.

### Notes

- Ensure that the web server on the remote machine is configured to listen on `localhost:8080` and is running.
- If port `8080` is already in use on your local machine, you can use a different local port (e.g., `9090`) by changing the command to `-L 9090:localhost:8080` and then accessing `http://localhost:9090` on your laptop.

This setup allows you to securely access the web server running on your remote RHEL machine from your local laptop using SSH port forwarding.

---

## 2023 PSI LYSO Testbeam DAQ Installer
There is a [gm2daq-installer](https://github.com/PIONEER-Experiment/gm2daq-installer) that has been tested on RHEL7 systems. This will attempt to install the listed packages below. This installer's purpose was to streamline installation of the 2023 PSI LYSO testbeam usage of the DAQ. **WARNING: As some of these packages have been updated, the installer may fail. Use this at your own disgression.** In particular, I don't expect the [unpacker](), [publisher](), [meinberg](software_dependencies.md#meinberg), and [gm2daq software](installing_and_building.md#manual-installation-guide) to install correctly. If you use this tool, it would be best to install those by hand if needed by following the links. Furthermore on RHEL9 systems (such as ALMA9) , the distributed pre-compiled binaries are more up to date, which simplifies the installation process greatly. As a result, I would only suggest using the installer for RHEL7 systems (such as SL7 or CentOS7).


To attempt to install everything with the installer:
```
git clone git@github.com:PIONEER-Experiment/gm2daq-installer.git
cd gm2daq-installer
./install.sh
```

### List of Installed Software
If you navigate to
```
cd gm2daq-installer/subprocess_scripts
```
you can install packages individually:

| Script Name                   | Description                    |
|-------------------------------|--------------------------------|
| `install_epel-release.sh`     | EPEL Release                   |
| `install_openssl-devel.sh`    | OpenSSL Development Libraries  |
| `install_cmake.sh`            | CMake                          |
| `install_cmake3.sh`           | CMake3                         |
| `install_readline.sh`         | Readline                       |
| `install_root.sh`             | ROOT (pre-compiled binary)     |
| `install_erlang.sh`           | Erlang                         |
| `install_zlib.sh`             | zlib                           |
| `install_devtoolset-8.sh`     | Devtoolset-8                   |
| `install_devtoolset-11.sh`    | Devtoolset-11                  |
| `install_rh-python36.sh`      | Python 3.6                     |
| `install_libXft.sh`           | libXft                         |
| `install_libXpm.sh`           | libXpm                         |
| `install_libXt.sh`            | libXt                          |
| `install_libXext.sh`          | libXext                        |
| `install_patch.sh`            | Patch                          |
| `install_libtool.sh`          | Libtool                        |
| `install_meinberg_driver.sh`  | Meinberg Driver                |
| `install_midas.sh`            | MIDAS                          |
| `install_pugixml.sh`          | pugixml                        |
| `install_boost_1_53_0.sh`     | Boost 1.53.0                   |
| `install_cactus.sh`           | Cactus                         |
| `install_gm2daq.sh`           | gm2daq                         |
| `install_root_from_source.sh` | ROOT (from source)             |
| `install_boost_1_70_0.sh`     | Boost 1.70.0                   |
| `install_zeroMQ.sh`           | ZeroMQ                         |
| `install_cppzmq.sh`           | C++ ZeroMQ                     |
| `install_eigen.sh`            | Eigen                          |
| `install_unpacker.sh`         | Midas Data File Unpacker       |
| `install_publisher.sh`        | Midas Data Publisher           |


you can also run
```
./install.sh --skip root_from_source,zeroMQ,...
```
to skip certain packages, for example. From the list above, remove the `install_` and `.sh` parts and add it to the comma seperated list following the `--skip` flag to skip it. For instance, I would recommend trying:

---
