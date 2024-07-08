# Additional Software

## Eigen 

### Overview

Eigen is a high-performance C++ library for linear algebra operations, including matrices, vectors, numerical solvers, and related algorithms. It is widely used in various fields such as scientific computing, machine learning, and computer graphics due to its efficiency and ease of use. Eigen provides a wide range of matrix sizes and storage formats, making it versatile for both small and large-scale computations.

### Installation Guide

#### Via yum (ALMA9)

```
sudo yum install -y eigen3-devel
```

#### From Source (CentOS7)

```
git clone https://gitlab.com/libeigen/eigen.git
cd eigen
mkdir build && cd build
cmake ..
make
sudo make install
```

---

## Midas Event Unpacker

### Overview

This is a midas event unpacker used for the g-2 modified DAQ system during the 2023 LYSO test beam, but has seen more development afterwards. The [github page](https://github.com/PIONEER-Experiment/test-beam-2023-unpacker/tree/develop) has it's own list of instructions for download and use.

### Installation Guide

Follow the instructions on the [github page](https://github.com/PIONEER-Experiment/test-beam-2023-unpacker/tree/develop). In particular:

```
git clone --branch develop git@github.com:PIONEER-Experiment/test-beam-2023-unpacker.git unpacker
cd unpacker
mkdir build  
cd build  
cmake ..
make install  
```

### Usage

Follow the instructions on the [github page](https://github.com/PIONEER-Experiment/test-beam-2023-unpacker/tree/develop). In particular run the following command over a generated midas file.

```
./pioneer_unpacker MIDAS_FILE.mid.lz4 0 detector_mapping.json
```

---

## Publisher

### Overview
The publisher is C++ project aimed to publish data over a socket using ZeroMQ. There are two versions:

1. The [General Publisher](software_add_ons.md#general-publisher) which is stable and well documented, but does not provide any midas interfacing.
2. The [Midas Event Publisher](software_add_ons.md#midas-event-publisher) which is less stable and not well document, but does provide midas interfacing.

### General Publisher

The [general publishing tool](https://github.com/PIONEER-Experiment/midas_publisher/tree/main?tab=readme-ov-file) is a framework used to publish data over ZeroMQ seemlessly. This tool generally only depends on ZeroMQ and cppZMQ. **This branch does not interface with midas at all**. However, there is still useful information on this branch about how to configure the publisher and how it works, see the [wiki for the publisher](https://github.com/PIONEER-Experiment/midas_publisher/wiki).

#### Installation Guide

Follow the [steps on the wiki](https://github.com/PIONEER-Experiment/midas_publisher/wiki/Compiling-the-Publisher).

### Midas Event Publisher

**Warning**: This branch was hastefully put together. As a result it is not straightfoward to install and has many issues. Try following this guide first, but if you have issues you can [contact the creator (Jack Carlton)](index.md#contact).

This is a different branch of the publisher specialized to using [mdump](https://daq00.triumf.ca/MidasWiki/index.php/Mdump) and the [midas event unpacker](software_add_ons.md#midas-event-unpacker) to publish unpacked midas data from a live data run over a socket using zeroMQ. **In some cases, we have found that using mdump in this manner lowers the rate capabilites of the DAQ**. However, this software is still useful for low rate [data quality monitoring](software_add_ons.md#basic-dqm).

These features are located on the [develop branch](https://github.com/PIONEER-Experiment/midas_publisher/tree/devel?tab=readme-ov-file) of the publisher. Which can be installed with the following steps

#### Installation Guide

1 **Clone the branch**
```
git clone -b devel git@github.com:PIONEER-Experiment/midas_publisher.git publisher
cd publisher
```

2 **Set up environment**

```
./detect_environment.sh
cat environment_variables.txt
```
Ensure each environment variable points to the correct directory. If not, fix it using your favorite text editor. See this example below:

```
MIDASSYS=/home/installation_testing/packages/midas
MIDAS_EXPTAB=/home/installation_testing/online/exptab
MIDAS_EXPT_NAME=DAQ
UNPACKING_ROOT=/home/installation_testing/packages/unpacking
ROOT_ROOT=/home/installation_testing/packages/ROOT
BOOST_1_70_0_ROOT=/home/installation_testing/packages/boost-1.70.0
ZEROMQ_ROOT=/home/installation_testing/packages/zeroMQ
CPPZMQ_ROOT=/home/installation_testing/packages/cppzmq
EIGEN_ROOT=/home/installation_testing/packages/eigen-3.4.0
```

**Note:** `BOOST_1_70_0_ROOT` is poorly named. This can point to any version of boost past version 1.70.0.

**Note:** If this turns out to be too painful a process, you may find it easier to hardcode [CMakeLists.txt](https://github.com/PIONEER-Experiment/midas_publisher/blob/devel/CMakeLists.txt). For example, one would find where the CPPZMQ header files are and replace the line `$ENV{CPPZMQ_ROOT}/include` with a hardcoded path.

```
source ./setup_environment.sh
```

3 **Build and install**

```
cd ..
mkdir build
cd build
cmake ..
make install -j$(nproc)
```

4 **Edit config**

Edit config.json in your favorite text editor, for instance:

```
cd ..
vi config.json
```

In particular, 
```
"detector-mapping-file": "/home/installation_testing/packages/unpacking/python/detector_mapping.json" 
```
needs to be set to a valid detector mapping. The unpacking library has one in `unpacking/python/detector_mapping.json`

You also may need to change the buffer in
```
"command": "$(MIDASSYS)/bin/mdump -l 1 -z BUF001 -f d",
```
to `SYSTEM` or whatever buffer you want the publisher to listen to.

### Usage

#### "By Hand"
Once installed, you can simply run
```
./publisher
```
And the publisher will begin. You can increase the `verbose` setting in `config.json` to see what it's publishing in real time.

#### "Cronjob" Screen
In the scripts directory you can start a "cronjob" screen that runs the publisher
```
cd scripts
./screen_publisher_cronjob.sh
```

You can stop this screen with 

```
./stop_publisher_cronjob_screen.sh
```

**Note**: This isn't really a cronjob, but rather a shell script that periodically kills the publisher and restarts it. There is a memory leak in this branch that hasn't been tracked down, and this is band-aid solution.

---

## Basic DQM

### Overview

This is a "generalized" DQM that samples a midas experiment running the g-2 modified DAQ and displays some traces from each active channel. It comes packaged with [publisher](software_add_ons.md#publisher) right now, but may migrate to it's own seperate project.

### Installation Guide

See installation guide for [midas event publisher](software_add_ons.md#midas-event-publisher).

You also need some python packages:

```
pip install Flask Flask-SocketIO pyzmq
```

**Note**: You may need to use `pip3` on some systems.

### Usage

First, navigate to the publisher root directory. Then

#### "By Hand"

```
cd dashboard_webpage
python main.py
```

**Note**: You may need to use `python3` on some systems.

Then open your favorite web browser to `localhost:8000` to view the webpage.

#### Screening Script

```
cd scripts
./screen_webpage.sh
```

Then open your favorite web browser to `localhost:8000` to view the webpage.

To stop the webpage,
```
./stop_webpage_screen.sh
```

---

## Crate Monitor

### Overview

The crate monitor is a webpage to view the status of g-2 crate components such as the [WFD5](hardware_overview.md#wfd5-waveform-digitizer), [FC7](hardware_overview.md#fc7-flexible-controller), and [AMC13](hardware_overview.md#amc13-advanced-mezzanine-card). 

### Installation Guide

1 **Clone the repository**
```
git clone git@github.com:PIONEER-Experiment/utcaMonitor.git
```

2 **Edit run.py**

In your favorite text editor, edit `run.py`. For example, with `vi`:
```
vi run.py
```

In particular, change these variables

```
# variable defaults
verbose   = 0
debug     = 0
teststand = 0
n_crates  = 1
# amcs in a crate will have ip address 192.168.[crate].[slot]:  Create the default list of n_crate crate numbers
crates = [100]
# types of modules in given crate
amc13100_types = ['FC7','WFD5']
crate_types = [amc13100_types]
encoder_crate = 100
encoder_slot = 8

host = 'gm26221.classe.cornell.edu'
```

For instance, for a one crate system I used:
```
# variable defaults
verbose   = 0
debug     = 0
teststand = 0
n_crates  = 1
# amcs in a crate will have ip address 192.168.[crate].[slot]:  Create the default list of n_crate crate numbers
crates = [1]
# types of modules in given crate
amc13100_types = ['FC7','WFD5']
crate_types = [amc13100_types]
encoder_crate = 1
encoder_slot = 10

host = 'localhost'
```

3 **Run the crate montior**
```
python run.py
```
Then open `localhost:7000` in your favorite web browser.

**Note**: You may need to pdate `socket.io.min.js`. Here's how you do it manually:

You may need to update `socket.io.min.js` (for reasons I'm not entirely sure of). You can get the file on [socket io's client installation webpage](https://socket.io/docs/v4/client-installation/). Here is a [cloudflare link to the version I used](https://cdnjs.cloudflare.com/ajax/libs/socket.io/4.7.5/socket.io.min.js); you can copy this to your clipboard

Replace the contents of socket.io.min.js in your favorite text editor. For instance in `vi`:
```
vi utcaMonitor/app/dist/js/socket.io.min.js
```
Hit `ggdG` to erase all lines. Hit `i` to enter insert mode. `Ctrl-V` to paste the contents. `Esc` and `:wq` to save and exit.

After this, rety running the crate monitor.

---


