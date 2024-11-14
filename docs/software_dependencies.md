# Software Dependencies

## PIONEER Experiment Repositories

Access the repositories here: [PIONEER Experiment GitHub](https://github.com/PIONEER-Experiment).

### Contact for Access

Patrick Schwendimann: <br>
<i class="fas fa-envelope"></i> Email: [schwenpa@uw.edu](mailto:schwenpa@uw.edu)<br>
<i class="fab fa-github"></i> GitHub: [PatrickSchwendimann](https://github.com/PatrickSchwendimann)

Joshua Labounty: <br>
<i class="fas fa-envelope"></i> Email: [jjlab@uw.edu](mailto:jjlab@uw.edu)<br>
<i class="fab fa-github"></i> GitHub: [jlabounty](https://github.com/jlabounty)

## Setting Up a GitHub SSH Token on RHEL7/9 Systems

### 1. Generate an SSH Key Pair

1. Open your terminal.
2. Generate a new SSH key. Replace `your_email@example.com` with the email address associated with your GitHub account.

    ```
    ssh-keygen -t ed25519 -C "your_email@example.com"
    ```

    If you are using an older system that doesn’t support the `ed25519` algorithm, you can use `rsa` instead:

    ```
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```

3. Follow the prompts to save the key in the default location (`~/.ssh/id_ed25519`) and set a passphrase.

### 2. Add the SSH Key to the SSH-Agent

1. Start the SSH agent in the background:

    ```
    eval "$(ssh-agent -s)"
    ```

2. Add your SSH private key to the ssh-agent. Replace `id_ed25519` with the name of your private key file if you used a different name.

    ```
    ssh-add ~/.ssh/id_ed25519
    ```

### 3. Add the SSH Key to Your GitHub Account

1. Copy the SSH key to your clipboard:

    ```
    cat ~/.ssh/id_ed25519.pub
    ```
    This will display for the key. Copy all of it.

2. Log in to your GitHub account and navigate to **Settings** > **SSH and GPG keys** > **New SSH key**.
3. Paste your SSH key into the "Key" field and add a descriptive title.
4. Click "Add SSH key".

### 4. Test Your SSH Connection

1. Test the connection to make sure everything is set up correctly:

    ```
    ssh -T git@github.com
    ```

2. You should see a message like:

    ```
    Hi username! You've successfully authenticated, but GitHub does not provide shell access.
    ```
### Example Steps in Terminal

```
# Step 1: Generate an SSH Key Pair
ssh-keygen -t ed25519 -C "your_email@example.com"

# Step 2: Start the SSH agent in the background
eval "$(ssh-agent -s)"

# Step 3: Add your SSH private key to the ssh-agent
ssh-add ~/.ssh/id_ed25519

# Step 4: Copy the SSH key to your clipboard
cat ~/.ssh/id_ed25519.pub

# Step 5: Add the SSH key to GitHub via the GitHub web interface

# Step 6: Test your SSH connection
ssh -T git@github.com
```

---

## Development Tools

### Overview

These tools include compilers, libraries, and other utilities that facilitate software development and installation.

### Installation Guide
This guide should work for ALMA9. You can use dnf alone for ALMA9, but I prefer to work with yum

1 **Install yum package manager**

```
sudo dnf install yum
```

2 **Update the package index**:

```
sudo yum update
```

3 **Enable the EPEL repository**:

```
sudo yum install epel-release
```

4 **Install Development Tools and Dependencies**:

```
sudo yum groupinstall "Development Tools"
sudo yum install cmake gcc-c++ gcc binutils libX11-devel libXpm-devel libXft-devel libXext-devel
```

5 **Install Python**
```
sudo yum install python3
```

---

## ipmitool

### Overview
`ipmitool` is a widely used command-line utility that facilitates interaction with IPMI-enabled devices. It allows administrators to perform various management tasks remotely and locally. Here's a more detailed look at `ipmitool`:

- **Sensor Monitoring**: `ipmitool` can read and display sensor data, such as temperature, voltage, and fan speed, helping to monitor the health and status of the hardware.
- **System Management**: It provides commands to control system power states (on, off, reset) and to manage system settings remotely.
- **Firmware Management**: `ipmitool` supports updating and managing firmware of the IPMI-enabled devices.
- **Event Log Management**: It can display and clear the system event log (SEL), which records critical system events.
- **Chassis Management**: Commands to control and manage the chassis, including power control and identifying LEDs.
- **User Management**: Supports adding, modifying, and deleting IPMI users.

### Installation Guide

1 **Install `ipmitool`**:

```
sudo yum install ipmitool
```

2 **Verify Installation**:

```
ipmitool -V
```

---

## ROOT

### Overview

[ROOT](https://root.cern.ch/) is an open-source data analysis framework developed by CERN. It is widely used in high-energy physics for data processing, statistical analysis, visualization, and storage. It is needed for some features of Midas.

### Installation Guide
General installaiton guides are provided by ROOT at their [Installing ROOT](https://root.cern/install/) and [Building ROOT from source](https://root.cern/install/build_from_source/) pages.

#### AlmaLinux 9

1 **Enable the EPEL repository**:

```
sudo yum install epel-release
```

2 **Download and Install ROOT**:

```
sudo yum install root
```

#### Building from source (Linux)

1 **Example building latest stable branch from source**

```
git clone --branch latest-stable --depth=1 https://github.com/root-project/root.git root_src
mkdir root_build root_install && cd root_build
cmake -DCMAKE_INSTALL_PREFIX=../root_install ../root_src # && check cmake configuration output for warnings or errors
cmake --build . -- install -j4 # if you have 4 cores available for compilation
source ../root_install/bin/thisroot.sh # or thisroot.{fish,csh}
```

**Note**: Adjust the ROOT version and the download URL as needed. Always check for the latest version on the [official ROOT website](https://root.cern.ch/). Furthermore, if you are not building from source you are installing precompiled binaries, which may not be up to date versions of ROOT. For specific versions, you may need to build root from source.

---

## Midas

### Overview

[Midas](https://daq00.triumf.ca/MidasWiki/index.php/Main_Page) is a data acquisition system used in high-energy physics experiments.
Midas provides the following functionalities:

- Run control
- Experiment configuration
- Data readout
- Event building
- Data storage
- Slow control
- Alarm systems
- ... much more ...

### Installation Guide

For a general Midas installation, you can follow this [Linux Quick Start Guide](https://daq00.triumf.ca/MidasWiki/index.php/Quickstart_Linux). For the g-2 modified DAQ, we use a custom version of midas, which can be cloned and installed as follows:

1 **Set experiment name environment variable**

```
export MIDAS_EXPT_NAME=DAQ
```
2 **Create exptab file**

```
mkdir online
cd online
touch exptab
echo "$MIDAS_EXPT_NAME $(pwd) system" >> exptab
export MIDAS_EXPTAB=$(pwd)/exptab	
```
3 **Install Midas**

```
cd ..
mkdir packages
git clone --recursive git@github.com:PIONEER-Experiment/midas-modified.git midas
cd midas
mkdir build
cd build
cmake ..
make -j$(nproc) install
cd ..
```

4 **Set `MIDASSYS` environment variable and add to path**

```
export MIDASSYS=$(pwd)
export PATH=$PATH:$MIDASSYS/bin
```
**Note**: you can hardcode the environment variables `MIDASSYS` (and add to path), `MIDAS_EXPTAB`, and `MIDAS_EXPT_NAME` by adding the appropriate commands to your .bashrc file. This way, the environment variables are set with each new terminal session for that user.

---

## Boost

### Overview

[Boost](https://www.boost.org/) is a comprehensive collection of C++ libraries that provide support for various tasks and structures including linear algebra, multithreading, image processing, regex (regular expressions), and more.

### Installation Guide

Boost can be installed on AlmaLinux 9 using package managers or from source. Here are detailed instructions for each method:

#### AlmaLinux 9


1 **Install Development Tools and Dependencies**:

```
sudo yum groupinstall "Development Tools"
sudo yum install cmake
```

2 **Install Boost Libraries**:

```
sudo yum install epel-release
sudo yum install boost-devel
```

#### Install Boost 1.76 from Source

1 **Download and Extract Boost**:

```
wget https://sourceforge.net/projects/boost/files/boost/1.76.0/boost_1_76_0.tar.gz
tar -xzf boost_1_76_0.tar.gz
cd boost_1_76_0
```

2 **Configure and Build Boost**:

```
./bootstrap.sh --prefix=/usr/local
./b2
```

Replace `/usr/local` with your desired installation path.
**Note:** You may need to manually link python to boost, to do this:
```
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/opt/rh/rh-python36/root/usr/include/python3.6m
./bootstrap.sh --prefix=/usr/local --with-python="/opt/rh/rh-python36/root/usr/bin/python3" --with-python-root="/opt/rh/rh-python36/root" --with-python-version="3.6"
```
where `/opt/rh/rh-python36/root/usr/include/python3.6m`, `/opt/rh/rh-python36/root/usr/bin/python3`, `/opt/rh/rh-python36/root`, and `3.6` are replaced with the appropriate values for your system.

3 **Install Boost**:

```
./b2 -j$(nproc) install --prefix=/usr/local
```
Replace `/usr/local` with your desired installation path.

4 **Verify Boost Installation**:

```
sudo ldconfig
```

---

## IPBus (Cactus)

### Overview

[IPBus](https://ipbus.web.cern.ch/), part of the Cactus framework, is a protocol for remote control and monitoring of hardware devices over Ethernet. It's commonly used in high-energy DAQ systems.

### Installation Guide

For a general installation guide, see ipbus' [Installing the Software](https://ipbus.web.cern.ch/doc/user/html/software/installation.html) page.

#### AlmaLinux 9

1 **Remove previous version (if applicable)**:

```
sudo yum groupremove uhal
```

2 **Download yum repo file**:

```
sudo curl https://ipbus.web.cern.ch/doc/user/html/_downloads/ipbus-sw.el9.repo -o /etc/yum.repos.d/ipbus-sw.repo
```

3 **Install uHAL**:

```
sudo yum clean all
sudo yum groupinstall uhal
```

#### Example building from source
See [Compiling and installing from source](https://ipbus.web.cern.ch/doc/user/html/software/install/compile.html), an example is below:
```
sudo yum install pugixml-devel
git clone --depth=1 -b v2.7.3 --recurse-submodules https://github.com/ipbus/ipbus-software.git
cd ipbus-software
make -j$(nproc) EXTERN_BOOST_INCLUDE_PREFIX="/opt/boost/include" EXTERN_BOOST_LIB_PREFIX="/opt/boost/lib" EXTERN_PUGIXML_INCLUDE_PREFIX="/usr/local/include" EXTERN_PUGIXML_LIB_PREFIX="/usr/local/lib64/"
sudo make install -j$(nproc)
```
**Note**: You may not need to specify `EXTERN_BOOST_INCLUDE_PREFIX`, `EXTERN_BOOST_LIB_PREFIX`, `EXTERN_PUGIXML_INCLUDE_PREFIX`, `EXTERN_PUGIXML_LIB_PREFIX`. Otherwise, you may need to find where pugixml and boost were installed and replace the paths above respectively.

---

## System Monitor

### Overview

The system monitor software is a custom software package used to attach system resource usage to midas data banks to aid in debugging rate slowdowns. It is a required dependency currently. It's contents can be found in the midas databank `SI00` where `00` is replaced with the frontend index. 

### Installation Guide

See the [github page](https://github.com/jaca230/system_diagnostics/tree/main) for more details.

1 **Clone the repository**
```
git clone https://github.com/jaca230/system_diagnostics.git
cd system_diagnostics
```

2 **Build the library**
```
cd scripts
./build.sh
```

3 **Verify installation**
```
cd ..
cd bin
./system_diagnostics --help
./system_diagnostics
```

---

## Meinberg

### Overview

[Meinberg](https://www.meinbergglobal.com/) provides a range of synchronization solutions, including Network Time Protocol (NTP) servers, precision time protocol (PTP) solutions, and GPS radio clocks. These tools are essential for accurate time synchronization in various high-precision applications.

In our case, we use it to apply a GPS timestamp to each event. In reality, this is an artifact from g-2 where seperate systems needed to be time correlated. Only the "GPS" master trigger mode needs the meinberg.

### Installation Guide

For more general information about Meinberg devices, see Meinberg's [Installing the Software](https://kb.meinbergglobal.com/) page.

#### AlmaLinux 9

1 **Clone the repository**:

```
git clone https://git.meinbergglobal.com/drivers/mbgtools-lx.git
cd mbgtools-lx
git pull
```
**Note**: Ensure that the URLs and repository paths are correct.

2 **Compile the source code**:

```
make clean
make
```

**Note**: You may need to use a development kernel. This command will install the development kernel for your current kernel version.

```
sudo yum install kernel-devel-$(uname -r) gcc make
```

3 **Install the software**:

```
sudo make install
sudo /sbin/modprobe mbgclock
make install_svc
```

4 **Verify installation**

```
mbgstatus
```

The output of this command should look similar to this:
```
mbgstatus v4.2.24 copyright Meinberg 2001-2023

TCR180PEX 039212025430 (FW 1.21, ASIC 9.00) at port 0xE000, irq 47
Date/time:  Tu, 2024-01-30  04:36:10.33 UTC
Signal: 0%  (IRIG B122/B123, ** UTC offs not configured **)
Status info: *** NO INPUT SIGNAL
Status info: *** Ref. Time is Invalid
Last sync:  We, 2023-10-04  11:36:55.00 UTC

** Warning: The IRIG receiver has not yet been configured!

Please make sure the correct IRIG Code Format has been
selected, and enter the correct IRIG Time Offset from UTC
according to the settings of the IRIG generator.
The command "mbgirigcfg" can be used to change the settings.
```

**Note**: Check the README in `mbgtools-lx` which provides step by step debugging for this installation.

---
