# Software Dependencies

## PIONEER Experiment Repositories

Access the repositories here: [PIONEER Experiment GitHub](https://github.com/PIONEER-Experiment).

### Contact for Access

- Patrick Schwendimann: [schwenpa@uw.edu](mailto:schwenpa@uw.edu)
- Joshua Labounty: [jjlab@uw.edu](mailto:jjlab@uw.edu)

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
This guide should work for RHEL systems (CentOS7 and ALMA9 included), though you may need to install yum on ALMA9.

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

**Note**: CentOS7 may not have python3 available in base repositories, you can install via `yum install -y rh-python36`.

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
wget https://root.cern/download/root_v6.32.02.Linux-almalinux9.4-x86_64-gcc11.4.tar.gz
tar -xzvf root_v6.32.02.Linux-almalinux9.4-x86_64-gcc11.4.tar.gz
cd root
source bin/thisroot.sh
```

#### CentOS 7

1 **Enable the EPEL repository**:

```
sudo yum install epel-release
```

2 **Download and Install ROOT**:

```
yum install root
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
make -j$(nproc) install
```
**Note**: On CentOS7 you may need to use `cmake3` as opposed to `cmake`; install with `sudo yum install cmake3`. Alternatively, you can install `cmake` from source to ensure it is up to date.

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

Boost can be installed on CentOS 7 and AlmaLinux 9 using package managers or from source. Here are detailed instructions for each method:

#### CentOS 7 and AlmaLinux 9


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

#### CentOS 7

1 **Remove previous version (if applicable)**:

```
sudo yum groupremove uhal
```

2 **Download yum repo file**:

```
sudo curl https://ipbus.web.cern.ch/doc/user/html/_downloads/ipbus-sw.centos7.repo -o /etc/yum.repos.d/ipbus-sw.repo
```

3 **Install uHAL**:

```
sudo yum clean all
sudo yum groupinstall uhal
```

**Note**: I personally had trouble getting this to work on CentOS7 and had to resort to building from source (see below).

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
