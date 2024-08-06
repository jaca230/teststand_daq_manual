# Midas Online Data Base (ODB) Configuration

## ODB basics

Below are some basic usage examples of midas' ODB

### Accessing the ODB

#### Command line interface

You can edit the ODB via command line without needing a midas webserver running.
```
$MIDASSYS/bin/odbedit
```
Then you can navigate through the ODB as you would with linux directory commands. From here, you can type "help" or view the [odbedit command list](https://daq00.triumf.ca/MidasWiki/index.php/Odbedit_command_list) for a list of commands.

#### Via Midas Webpage

You can start a midas webpage by running `mhttpd` (or `mhttpd6`)
```
$MIDASSYS/bin/mhttpd
```
Then view the ODB by clicking the **ODB** button on the left sidebar

### General ODB Configuration Examples

For a general guide on how to use Midas' ODB, see the [ODB Access and Use wiki page](https://daq00.triumf.ca/MidasWiki/index.php/ODB_Access_and_Use). Below are a few of common ODB

#### Toggle Logger Data Writing
Change `Logger/Write Data` to `yes` or `no`.

#### Change Logger Data Writing Directory
Change `Logger/Data dir` to the desire path.

#### Toggle Logger to generate ODB backups for each run
Change `Logger/ODB Dump` to `yes` or `no`.

#### Change Webpage Port
First, run `mhttpd` or `mhttpd6` at least once. It doesn't need to be successful, it just needs to generate the `WebServer` ODB directory.

Then, change `WebServer/localhost port` from `8080` to whatever port is desired. The `WebServer` ODB directory provides much more webserver config as well.

#### Disable a Frontend
Every Midas frontend generates a `Common` section it's ODB. For example, `Equipment/AMC13001/Common` will be generated. To disable a frontend, set `/Equipment/Frontend Name/Common/Enabled` to `no`. This is useful for toggling off crates in multicrate setups.

#### Change the Data Buffer for a Frontend
Change `/Equipment/Frontend Name/Common/Buffer` to the desired buffer name.

#### Changing Run Number
Change `/Runinfo/Run number` to the desired run number.

---

## g-2 Modified DAQ Specific ODB Configuration

Below are some important settings in the ODB for the g-2 modified DAQ. This is not a complete description of every setting in the ODB. Many settings are artifacts from g-2 that don't serve any purpose anymore.

### Master Frontend ODB settings

#### Trigger Source

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**           | `/Equipment/MasterGM2/Settings/Globals/Trigger Source`             |
| **Description**    | Determines what source the Master will use to trigger events       |
| **Valid Values**   | `GPS`, `PP` (currently broken), `Fake`, `Socket` (untested), `None`, `ODB`, and `FC7` |
| **Suggested Value**| `FC7`                                                              |

**Note**: The meaning of each value is specified below:

- **GPS**: Uses the Meinberg GPS timestamps for Master triggers.

- **PP**: Uses parallel port signals as the trigger source (currently broken).

- **Fake**: Uses a fake signal for testing purposes. Further configuration in ODB.

- **Socket**: Uses a socket connection as the trigger source (untested).

- **None**: No trigger source is used, no master triggers are made.

- **ODB**: Reads ODB to send triggers at a rate similar to the rate the AMC13 receives triggers.

- **FC7**: Uses FC7's trigger counter over IPMI to trigger events

#### Front End Offset

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/MasterGM2/Settings/Globals/Front End Offset`           |
| **Description** | Offset for index for the IPs of the first frontend. For example if your MCH IP is 192.168.3.15, then you'd want this offset to be 3. |
| **Valid Values**| Positive integer < 1000                                            |
| **Suggested Value**| `1`                                                             |

#### Encoder Front End

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/MasterGM2/Settings/Globals/Encoder Front End`          |
| **Description** | Identifier for frontend that corresponds to the crate containing the encoder FC7 |
| **Valid Values**| `AMC13001`, `AMC13002`, ...                                        |
| **Suggested Value**| `AMC13001`                                                      |


### AMC13 Readout Frontend ODB settings

Any setting not mentioned is either an artifact of g-2 (doesn't do anything) or shouldn't need to be modified from its default value. For example, most of the `TQ01`, `TQ02`, `TQ03`, and `TQ04` no longer function.

#### Send to Event Builder

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Globals/Send to Event Builder`       |
| **Description** | Defines whether or not data is sent to event builder frontend      |
| **Valid Values**| `yes` or `no`                                                      |
| **Suggested Value**| `yes`                                                           |

**Note**: It is best to have this set to `yes` as it won't affect data readout even if the event buidler isn't used.

#### MCH IP Address

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Globals/MCH IP Address`              |
| **Description** | Set to MCH IP address for the MCH in this crate                    |
| **Valid Values**| Any valid IP address                                               |
| **Suggested Value**| `192.168.1.15`                                                  |

**Note**: This is the address in which the frontends sent IPMI commands to. If this is incorrect none of the crate components can be properly intialized for a data run. Each frontend (crate) should have it's own MCH IP address.

#### CCC: FC7 Slot Number (1-12)

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Globals/CCC: FC7 Slot Number (1-12)` |
| **Description** | Slot number of the encoder FC7 in the uTCA crate                   |
| **Valid Values**| `1`, `2`, ... `12`                                                 |
| **Suggested Value**| `10`                                                            |


**Note**: For crates without an FC7, this value does not matter. Just set it to the same value as the crate with the encoder FC7.

#### CCC: FMC Location (top,bottom)

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Globals/CCC: FMC Location (top,bottom)`          |
| **Description** |  The location of the SFP interface FMC card on the FC7 board       |
| **Valid Values**| `top` or `bottom`                                                  |
| **Suggested Value**| `top`                                                           |

**Note**: See [FC7 Labeling](miscellaneous_info.md#fc7-labeling) to decide whether your FMC SFP interface is on the top or the bottom (the FC7 firmware requires the SFP interface FMC is in the top slot).

#### CCC: FMC SFP Number (1-8)

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Globals/CCC: FMC SFP Number (1-8)`    |
| **Description** | The FC7 SFP slot number this AMC13 is connected to by optical cable |
| **Valid Values**| `1`, `2`, ... `8`                                                   |
| **Suggested Value**| `1` (for the first crate)                                        |

**Note**: See [FC7 Labeling](miscellaneous_info.md#fc7-labeling) to decide which port your optical connection is.

#### AMC13 10GbE Link Enable

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Link01/Enabled`                      |
| **Description** |  Toggles the 10GbE link for this AMC13                             |
| **Valid Values**| `0` or `1`                                                         |
| **Suggested Value**| `1`                                                             |

#### AMC13 SFP IP Address

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Link01/AMC13 SFP IP Address`         |
| **Description** |  Specifies the 10GbE link IP                                       |
| **Valid Values**|  Any valid IP                                                      |
| **Suggested Value**| `192.168.50.1`                                                  |

**Note**: This is the AMC13 IP that data is sent over. If this is incorrect, not data will be transferred from the crate. Each frontend (crate) should have a different AMC13 SFP IP address.

#### AMC13 SFP Port Number

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Link01/AMC13 SFP Port Number`        |
| **Description** |  Specifies which SFP port on the AMC13 is used for the 10GbE link  |
| **Valid Values**| `0x00001234`, unsure about others                                  |
| **Suggested Value**| `0x00001234`                                                    |

**Note**: `0x00001234` corresponds to the top port on the AMC13. I would not change this value unless you know what you're doing.

#### AMC13 T1 Firmware Version Required

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/AMC13/AMC13 T1 Firmware Version Required`         |
| **Description** |  The minimum required firmware version for the virtex (T1) FPGA in the AMC13        |
| **Valid Values**| Any positive integer                                 |
| **Suggested Value**| `33087`                                                    |

#### AMC13 T2 Firmware Version Required

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/AMC13/AMC13 T1 Firmware Version Required`         |
| **Description** | The minimum required firmware version for the spartan (T2) FPGA in the AMC13       |
| **Valid Values**| Any positive integer                                               |
| **Suggested Value**| `46`                                                            |


#### AMC13 T1 Address Table Location

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/AMC13/AMC13 T1 Address Table Location`         |
| **Description** | The path to the AMC13 virtex (T1) adress table xml file            |
| **Valid Values**| Any valid path                                                     |
| **Suggested Value**| `$GM2DAQ_DIR/address_tables/AMC13XG_T1.xml`                     |


#### AMC13 T2 Address Table Location

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/AMC13/AMC13 T2 Address Table Location`         |
| **Description** | The path to the AMC13 spartan (T2) adress table xml file           |
| **Valid Values**| Any valid path                                                     |
| **Suggested Value**| `$GM2DAQ_DIR/address_tables/AMC13XG_T2.xml`                     |

#### Enable FC7

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/FC7-{slot #}/Common/Enabled`         |
| **Description** | Whether or not this FC7 in the crate is enabled or not             |
| **Valid Values**| `yes` or `no`                                                      |
| **Suggested Value**| `yes`                                                           |

#### FC7 Address Table

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/FC7-{slot #}/Common/Address Table Location`         |
| **Description** | The path to the FC7 address table xml file                         |
| **Valid Values**| Any valid path                                                     |
| **Suggested Value**| `$GM2DAQ_DIR/address_tables/FC7_CCC.xml`                        |

#### FC7 Board Type

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/FC7-{slot #}/Common/Board (encoder,fanout,trigger)` |
| **Description** | What job the FC7 is set to do                                      |
| **Valid Values**| `encoder`,`fanout`, or `trigger`                                   |
| **Suggested Value**| `encoder`                                                       |

**Note**: The FC7 firmware has been modified so now the `encoder` FC7 can do the job of the `trigger` and `encoder` FC7s.

#### FC7 Firmware Version Required

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/FC7-{slot #}/Common/FPGA Firmware Version Required` |
| **Description** | The minimum required firmware version for the FC7                         |
| **Valid Values**| Any valid string (ex. `8.1.7`)                                     |
| **Suggested Value**| `8.1.7`                                                         |


#### Internal Trigger

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/FC7-{slot #}/Encoder/Internal Trig Enabled` |
| **Description** | Whether an external or internal trigger are used to trigger events |
| **Valid Values**| `yes` or `no`                                                      |
| **Suggested Value**| `no`                                                            |

**Note**: This is useful for debugging because it removes the need for having/building an external trigger signal. However, the triggers are periodic so the digitized data will be "random" windows of signal or noise.

#### Internal Trigger Period (us)

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/FC7-{slot #}/Encoder/Internal Trig Period (us)` |
| **Description** | The period of the internal trigger in micro seconds                |
| **Valid Values**| any positive integer                                               |
| **Suggested Value**| `500`                                                           |

**Note**: After each trigger, there is some [deadtime](odb_config.md#ttc-deadtime-ns). Therefore this value should be longer than the deadtime; otherwise there will be unintended results.


#### Internal Trigger Pulse Width (ns)

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/FC7-{slot #}/Encoder/Internal Pulse Width (ns)` |
| **Description** | The width of the internal trigger pulse in nanoseconds             |
| **Valid Values**| any positive integer                                               |
| **Suggested Value**| `100`                                                           |

#### TTC deadtime (ns)

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/FC7-{slot #}/Encoder/TTC deadtime (ns)` |
| **Description** | The amount of deadtime (time with no new triggers) after each trigger |
| **Valid Values**| any positive integer                                               |
| **Suggested Value**| `100000`                                                        |

**Note**: The achievable rate is limited by this value. For example, if using the suggested value the DAQ cannot trigger at more than 10 kHz.

#### Enabled WFD5

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Rider{slot #}/Board/Address Table Location`|
| **Description** | Whether or not this WFD5 is active for data taking                              |
| **Valid Values**| `yes` or `no`                                                           |
| **Suggested Value**| `yes`                              |

#### WFD5 Address Table

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Rider{slot #}/Board/Address Table Location`|
| **Description** | The path to the WFD5 address table xml file                              |
| **Valid Values**| Any valid path                                                           |
| **Suggested Value**| `$GM2DAQ_DIR/address_tables/WFD5.xml`                              |

#### WFD5 Master Firmware Version

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Rider{slot #}/Board/Master Firmware Version`         |
| **Description** | Channel Firmware version for the WFD5                              |
| **Valid Values**| any valid version string                                           |
| **Suggested Value**| `3.1.1`                                                         |

#### WFD5 Channel Firmware Version

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Rider{slot #}/Board/Chanel Firmware Version`         |
| **Description** | Channel Firmware version for the WFD5                              |
| **Valid Values**| any valid version string                                           |
| **Suggested Value**| `3.1.1`                                                         |

#### WFD5 Digitization Frequency

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Rider{slot #}/Board/Gitization Frequency (MHz)` |
| **Description** | Frequency at which samples are digitized                         |
| **Valid Values**| `800` divided by any power of 2 (for example, `200` is valid)    |
| **Suggested Value**| `800`                                                         |

#### WFD5 Circular Buffer Mode Enabled

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Rider{slot #}/Board/CircBuf Mode: Enabled`         |
| **Description** | Puts a WFD5 into circular buffer mode for data taking              |
| **Valid Values**| `yes` or `no`                                                      |
| **Suggested Value**| `yes`                                                           |

#### WFD5 Waveform Length

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Rider{slot #}/Board/Async CBuf Waveform Length`  |
| **Description** | The total number of samples digitized for each waveform trigger    |
| **Valid Values**| Any positive integer                                               |
| **Suggested Value**| `800`                                                           |

**Note** Each sample corresponds to a time window of 1/Digitization Frequency. So by default each sample corresponds to a 1.25 ns time window.

#### WFD5 Waveform Presamples

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Rider{slot #}/Board/Async CBuf Waveform Presamples`  |
| **Description** | How many of the waveform samples are taken before the trigger      |
| **Valid Values**| Any positive integer                                               |
| **Suggested Value**| `600`                  |

**Note**: This value must be less than the value of [WFD5 Waveform Length](odb_config.md#wfd5-waveform-length).

#### WFD5 Channel Enabled

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Rider{slot #}/Channel{channel #}/Enabled`  |
| **Description** | Whether this channel of the WFD5 is enabled for data taking or not      |
| **Valid Values**| `yes` or `no`                                               |
| **Suggested Value**| `yes`                  |

#### TQ methods GPU Bank Processing

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/TQ{#}/GPU T,Q,P bank processing`  |
| **Description** | Whether the GPU is used to process this midas bank or not      |
| **Valid Values**| `yes` or `no`                                               |
| **Suggested Value**| `no`                  |

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/TQ{#}/GPU H bank processing`  |
| **Description** | Whether the GPU is used to process this midas bank or not      |
| **Valid Values**| `yes` or `no`                                               |
| **Suggested Value**| `no`                  |

**Note**: All of the TQ method settings are artifacts of g-2. We just want to make sure they are off.

#### WFD5 Async Mode

"Async Mode" refers to a mode where each midas event contains 20 traces from each digitizer channel, which may increase the effective data collection rate. **However, this mode is currently not working.**

To turn on async mode set [WFD5 Async Mode Enabled (in another place)](odb_config.md#wfd5-async-mode-enabled-in-another-place) and [TTC Async Mode Enabled](odb_config.md#ttc-async-mode-enabled) to `yes`. For each digitizer, set [WFD5 Async Mode Enabled](odb_config.md#wfd5-async-mode-enabled) to `yes`. Furthermore [WFD5 Circular Buffer Mode](odb_config.md#wfd5-circular-buffer-mode-enabled) should be set to `no`. Otherwise the behavior will be unpredictable. I understand this is a bit convoluted, but this was hastily put together during the 2023 PSI LYSO test beam. There is slightly more documentation on [this elog entry](https://maxwell.npl.washington.edu/elog/pienuxe/R23/139).


##### WFD5 Async Mode Enabled

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/Rider{slot #}/Board/Async Mode: Enabled`         |
| **Description** | Puts a WFD5 into async mode for data taking                        |
| **Valid Values**| `yes` or `no`                                                      |
| **Suggested Value**| `no`                                                            |

##### WFD5 Async Mode Enabled (in another place)

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/FC7-{slot #}/Encoder/WFD5 Async Mode Enabled`         |
| **Description** | Lets FC7s know WFD5s are in async mode for data taking             |
| **Valid Values**| `yes` or `no`                                                      |
| **Suggested Value**| `no`                                                            |

##### TTC Async Mode Enabled

| Field           | Description                                                        |
|-----------------|--------------------------------------------------------------------|
| **Path**        | `/Equipment/AMC13{frontend #}/Settings/FC7-{slot #}/Encoder/TTC Async Mode Enabled`         |
| **Description** | Puts FC7 into async mode for data taking             |
| **Valid Values**| `yes` or `no`                                                      |
| **Suggested Value**| `no`                                                            |


