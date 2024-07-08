# Debugging Common Errors

Below are some common errors and their solutions. This is not a complete list of all errors.

## Initialization Errors

### MCH: IPMI Communication Failed

Verify the [MCH](hardware_overview.md#mch-microtca-carrier-hub) is connected to the DAQ computer via 1GbE. Verify you can ping the MCH:
```
ping 192.168.[crate].15
```
Verify the [MCH IP ODB setting](odb_config.md#mch-ip-address) is correct.

### AMC13: T1 IP Address Read Failure

Verify the [AMC13](hardware_overview.md#amc13-advanced-mezzanine-card) is plugged into the appropriate slot (above the MCH, see the [labeled crate picture](hardware_overview.md#labled-picture-one-crate-system)). Try pinging T1 and T2 on the AMC13
```
ping 192.168.[crate].13
ping 192.168.[crate].14
```
If not, use [ipmitool](hardware_overview.md#example-commands-using-ipmitool) to verify the AMC13 is recognized in the crate. Try to [reconfigure the AMC13](hardware_overview.md#amc13-advanced-mezzanine-card).

**Note**: I have seen cases where `ipmitool -H 192.168.[crate].15 fru print` will not show the AMC13, however the system still works as intended.

### Enabled Top SFP Ports Failure

Verify the [SFP port location](odb_config.md#ccc-fmc-sfp-number-1-8) and [FMC location](odb_config.md#ccc-fmc-location-topbottom) ODB settings are correct. Make sure you are using SFPs (such as a Finisar SFP) and not an SFP+ (such as Avago SFP+) in the FC7 and AMC13 optical link. Verify unconnected frontends (crates) are [disabled in the ODB](odb_config.md#disable-a-frontend).

### AMC13: TTC Signal Absent

Verify the [SamTech Cable](hardware_overview.md#samtech-ribbon-cable-to-bank-board) is appropriately connected to the FC7 and bank board. You can put these in the bank backwards, see the [labeled bank image](miscellaneous_info.md#bank-signals) for the correct orientation. Verify the signal integrity of the 40MHz clock fed into the signal bank.

### Link01: Invalid AMC13 SFP IP Address

Verify the [SFP IP in the ODB](odb_config.md#amc13-sfp-ip-address) matches the value read in [AMC13Tool2.exe](hardware_overview.md#configuring-the-amc13-with-amc13tool2exe) using
```
rv 0x1c1c
```
Convert this hex value to an IP and verify it matches the ODB value.


### AMC13 Initialization Failed

This error seems to pop up in different cases. Sometimes, it's enough to simply wait 5 minute and try [running the frontends](installing_and_building.md#running-the-frontends) again. Another solution is to power cycle the crate.

If you don't want to power cycle the crate, you can issue a "cold reset" to the AMC13:
```
cd $GM2DAQ_DIR/amc13/amc13_v1_2_18/dev_tools/amc13Config
```
[Ensure `systemVars.py` looks correct](hardware_overview.md#). Then issue a cold reset:
```
./coldReset.py
```
Then reconfigure the AMC13; you made need to set the T1 and T2 IPs again. At the minimum you should re-initialize using [AMC13Tool2.exe](hardware_overview.md#configuring-the-amc13-with-amc13tool2exe).



### TCP initialization failed

Verify the [10GbE NIC](hardware_overview.md#10gbe-nic-10-gigabit-ethernet-network-interface-card) is functioning and [properly connected to the AMC13](hardware_overview.md#10gbe-link-to-daq-computer). Verify the [10GbE link is properly configured](hardware_overview.md#configuring-the-amc13-with-amc13tool2exe). For instance, in AMC13Tool2.exe
```
rv 0x1c1c
```
Convert this hex value to an IP and try pinging it, for instance
```
ping 192.168.51.1
```
If you cannot ping this IP, check your [network settings](networking.md#networking-basics) for the 10GbE NIC. Verify the IP read above matches the [SFP IP ODB value](odb_config.md#amc13-sfp-ip-address).

---

## Alarms and Run Ending Errors

### Alarm: CCC Run Aborted

This was a common error during g-2. At it's worst, it should occur on ~6 hour time scales. You must [restart the frontends](installing_and_building.md#running-the-frontends) to re-initialize the crate hardware.

### tcp_thread: break the tcp thread loop becuase of a reading error -1

This was a common error during the 2023 test beam at PSI. This error usually occurs because the data buffer between reading in data and processing data has filled up. I.e. midas events are being created slower than events are coming in. As a result, the tcp_thread has nowhere to store incoming data and errors out.

This error is rate dependant. One way to fix it is to simply lower the rate. However, the DAQ has been tested and run for long periods at ~5kHz. A better solution would be to minimize the use other processes running on the DAQ computer, particularly those that interact with midas. For example, the [publisher](software_add_ons.md#publisher) is a culprit for causing delays within midas.

---