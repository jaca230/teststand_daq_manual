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

## Installation Guide

1 **Install Software Dependencies**
[ROOT](software_dependencies.md#root), [Midas](software_dependencies.md#midas), [Boost](software_dependencies.md#boost), [ipmitool](software_dependencies.md), and [Cactus](software_dependencies.md#ipbus-cactus) are all required to build and run the DAQ frontends. Install them following the instructions on the [Software Dependencies Page](software_dependencies.md).

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

**Note**: To clone a different branch, simply change the `multi-crate` parameter. You can also checkout a different branch after this is done.

3 **Setup Environment**

4 **Make Frontends**

5 **Configure Crate Contents File**

6 **Start Midas Webpage**

7 **Generate the ODB**


There are some keys in the ODB that need to be modified based on your system configuration. More details are in the [ODB configuration](odb_config.md) page.