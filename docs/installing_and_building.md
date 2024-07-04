# Installing and building g-2 modified DAQ
## Overview

The g-2 modified DAQ software repurposes the DAQ software used for g-2 to be slightly more flexible. It allows for readout and communication with hardware described in the [Hardware Overview](hardware_overview.md) page.

### Software Diagram

![software_diagram](images/software_diagram.png){: style="max-width:100%; height:auto;"}
**Note**: Not pictured are the hardware links, see [Hardware Diagram](hardware_overview.md#conceptual-diagram-one-crate-system)

#### MasterGM2
This is a C++ executable midas frontend whose job is to count triggers to check that crate hardware and CaloReadoutAMC13 frontends are not missing triggers.

- **Trigger Thread**: Recieves processed triggers from a source (ex. Meinberg PCIe Card) and reports them to the Midas thread.
- **Midas Thread**: Puts data recieved from trigger thread into a midas bank for each event

#### CaloReadoutAMC13
This is a C++ executable midas frontend whose job is to recieve digitized data from the AMC13 and process it before being placed in midas data banks.

- **TCP Thread**: Recieves TCP packets over 10GbE from an AMC13. Unpacks the data into header, trailer, and payload information.
- **"GPU" Thread**: Recieves processed data from TCP thread. In g-2, GPUs were used for additional data processing. They have been turned off and the "GPU" thread is a legacy buffer for the data to go through. No processing is done on the data here.
- **Midas Thread**: Puts data recieved from gpu thread into midas banks for each event

#### Event Builder
This is a C++ executable midas frontend whose job is to collect data sitting in the midas buffers of all the frontends (MasterGM2, CaloReadoutAMC13 #1, CaloReadoutAMC13 #2, ...) and combine them into one midas event before being logged to a data file.

## Installer
There is an [installer for the g-2 modified DAQ](miscellaneous_info.md#2023-psi-lyso-testbeam-daq-installer). Though, it is currently out of date and I would not recommend using it.

## Manual Installation Guide

1 **Install Software Dependencies**

[ROOT](software_dependencies.md#root), [Midas](software_dependencies.md#midas), [Boost](software_dependencies.md#boost), [ipmitool](software_dependencies.md#ipmitool), and [Cactus](software_dependencies.md#ipbus-cactus) are all required to build and run the DAQ frontends. [Meinberg](software_dependencies.md#meinberg) is needed if using GPS mode for the master triggers. Install them following the instructions on the [Software Dependencies Page](software_dependencies.md).

2 **Clone the Appropriate Branch**

Make sure you have access to the [PIONEER Experiment GitHub](https://github.com/PIONEER-Experiment). See these [contacts](software_dependencies.md#pioneer-experiment-repositories) for gaining access. Additionally, make sure your github account is linked to your system via SSH token; you can do this by following [these instructions](software_dependencies.md#setting-up-a-github-ssh-token-on-rhel79-systems). After installing the software dependencies, you should have a `packages` directory, where it's best to put the software. To clone, follow the commands below:

```
cd /path/to/packages
mkdir experiment
cd experiment
git clone --branch multi-crate https://github.com/PIONEER-Experiment/gm2daq-modified.git
cd gm2daq-modified
git checkout multi-crate
```

**Note**: To clone a different branch, simply change the `--branch` parameter from `multi-crate` to the appropriate branch. You can also checkout a different branch after this is done.

3 **Setup Environment**

```
cd environment_setup
./detect_environment.sh
```

This will populate a local file `environment_variables.txt`, check it with:
```
cat environment_variables.txt
```

Here's an example of what `environment_variables.txt` will look like
```
GM2DAQ_DIR=/home/installation_testing/packages/experiment/lxedaq
CACTUS_ROOT=/home/installation_testing/packages/cactus
BOOST_ROOT=/home/backup_installation_testing/packages/boost-1.53.0
PUGIXML_ROOT=/home/installation_testing/packages/pugixml-1.8
ROOT_ROOT=/usr/include/root
MIDASSYS=/home/installation_testing/packages/midas
MIDAS_EXPTAB=/home/installation_testing/online/exptab
MIDAS_EXPT_NAME=DAQ
```

Verify that each environment variable above points to the correct path for each piece of software. If not, manually change it with your favorite text editor. Then, run
```
source ./setup_environment.sh
```

**Note**: To set up the environment every time you log in automatically, source this script in your `.bashrc` file. Modify the path in the following command to add `setup_environment.sh` to the .bashrc file
```
echo "source /path/to/gm2daq-modified/environment_setup/setup_environment.sh" >> ~/.bashrc
```

4 **Make Frontends**

Make the master frontend:
```
cd $GM2DAQ_DIR/frontends/MasterGM2
make clean
make -j$(nproc)
```

Make the AMC13 readout frontend:
```
cd $GM2DAQ_DIR/frontends/CaloReadoutAMC13
make clean
make -j$(nproc)
```

Make the event builder frontend:
```
cd $GM2DAQ_DIR/eventbuilder
make clean
make
```


5 **Configure Crate Contents File**

Edit `AMC13xx_config.xml` file in your favorite text edit, for instance:
```
vi $GM2DAQ_DIR/frontends/AMC13xx_config.xml
```
An example file for a one crate system looks like this:
```
<!-- The purpose of this file is to specify what devices are in each frontend crate -->
<!-- To declare frontend AMC13xx create root node <frontend id="xx">  -->
<!-- (xx = "0" will automatically be written as "00" in ODB settings, i.e. single digits are okay) -->
<!-- To declare device in slot 'y' of create, create node <slot id="y" type="device_type" -->
<!-- Select "device_type" from FC7, WFD, or Rider (WFD and Rider are the same device) -->
<?xml version="1.0" encoding="UTF-8"?>
<frontend id="1">
    <slot id="1"  type="WFD" />
    <slot id="2"  type="WFD" />
    <slot id="3"  type="WFD" />
    <slot id="4"  type="WFD" />
    <slot id="5"  type="WFD" />
    <slot id="6"  type="WFD" />
    <slot id="7"  type="WFD" />
    <slot id="10" type="FC7" />
    <slot id="11"  type="WFD" />
</frontend>
```
An example file for a two crate system looks this like:
```
<?xml version="1.0" encoding="UTF-8"?>
<frontend id="1">
    <slot id="1"  type="WFD" />
    <slot id="2"  type="WFD" />
    <slot id="3"  type="WFD" />
    <slot id="4"  type="WFD" />
    <slot id="5"  type="WFD" />
    <slot id="6"  type="WFD" />
    <slot id="7"  type="WFD" />
    <slot id="10" type="FC7" />
    <slot id="11"  type="WFD" />
</frontend>
<frontend id="2">
    <slot id="3" type="WFD" />
    <slot id="5" type="WFD" />
</frontend>
```

**Note**: The frontend id should correspond to the subnet you placed (or will place) the crate components on when configuring the hardware.

This file is used to build the ODB. **Any hardware not specified in this file will be ignored.** You can still disable any hardware listed in this file in the ODB after it has been generated. However if you want to move the FC7 to a different slot, this file and the ODB need to be editted accordingly.

6 **Start Midas Webpage**
```
cd $GM2DAQ_DIR/webpage_scripts
./start_midas_webpage
```
Then open `localhost:8080` in your favorite web browser.

**Note**: If this doesn't work, verify that `mlogger`, `mhttpd` (or `mhttpd6`), and `mserver` and all running as screens, i.e. check:
```
screen -ls
```
You can also run `mhttpd` manually to look for error messages for debugging:
```
$MIDASSYS/bin/mhttpd
```


7 **Generate the ODB**

The first time the frontends are run, they will automatically populate the ODB with the default settings. Run the frontends for the first time (they will error out):

```
cd $GM2DAQ_DIR/frontends/MasterGM2
./frontend -e DAQ
```

```
cd $GM2DAQ_DIR/frontends/CaloReadoutAMC13
./frontend -e DAQ -i {frontend id}
```
where `{frontend id}` is replaced with the frontend ids specified in the crate configuration file above. This command needs to be run once for each frontend (each crate) to properly generate the ODB.

On the midas webpage view the ODB. Verify that `/Equipment/MasterGM2` and each `/Equipment/AMC13xxx` now exist.

8 **Configure the ODB**

Before the DAQ can run, the ODB needs to be properly configured. First, make sure the Logger [writes data](odb_config.md#toggle-logger-data-writing) and [makes ODB backup files for each run](odb_config.md#toggle-logger-to-generate-odb-backups-for-each-run). Then following the instructions on the [ODB configruation page](odb_config.md#g-2-modified-daq-specific-odb-configuration), read through each setting and ensure they are correct for your setup.