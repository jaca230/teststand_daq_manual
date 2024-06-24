# Networking Basics

To network the DAQ hardware together, understanding basic concepts such as IP addressing, subnetting, and network interfaces is crucial. This page will introduce you to fundamental networking terms in linux.

## Reading Network Port Information

On linux systems, you can use the command `ifconfig` to list all active ports on the system and some information about them. Below is an example.
### Example `ifconfig` Output
```
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.100  netmask 255.255.240.0  broadcast 192.168.1.255
        inet6 fe80::215:5dff:fe8f:7013  prefixlen 64  scopeid 0x20<link>
        ether 00:15:5d:8f:70:13  txqueuelen 1000  (Ethernet)
        RX packets 38935  bytes 56933483 (56.9 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 5766  bytes 471459 (471.4 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

#### Explanation:

**Interface Name (`eth0`)**:

- This is the name of the network interface.

**Flags**:

- `UP`: Indicates that the network interface is currently enabled and operational. When an interface is "up," it means the operating system has activated it and it is ready to send and receive data.

- `BROADCAST`: This flag signifies that the network interface supports broadcasting. Broadcasting allows a single packet to be sent to all devices within the same subnet. Devices use broadcast addresses to receive these packets.

- `RUNNING`: Indicates that the network interface is operational and actively sending or receiving data. It confirms that the interface is functioning correctly and is capable of transferring data packets.

- `MULTICAST`: Indicates that the network interface supports multicasting. Multicasting allows a single packet to be sent to multiple specific recipients who have joined a multicast group. It is more efficient than broadcasting for sending data to multiple destinations simultaneously.


**MTU (`mtu 1500`)**:

- Maximum Transmission Unit, the largest packet size in bytes.
- Default is usually 1500 bytes.
- For 10GbE links, this must be increased for efficiency. Typically to ~9000 bytes.

**IPv4 Address (`inet 192.168.1.100`)**:

- IP address assigned to the interface.

**Netmask (`netmask 255.255.255.0`)**:

- Defines the network portion of the IP address.

**Broadcast Address (`broadcast 192.168.1.255`)**:

- Address used for broadcasting messages.

**RX (Receive) and TX (Transmit) Packets**:

- Count of packets received and transmitted.

**RX (Receive) and TX (Transmit) Bytes**:

- Total bytes received and transmitted.

## Using Network Scripts

In Red Hat-based Linux systems (like Alma, CentOS, Fedora, or RHEL), network interfaces are often configured using `ifcfg` files located in `/etc/sysconfig/network-scripts/`. These files contain key configuration parameters that define how network interfaces behave and interact with the network.

### Example `ifcfg` File: `/etc/sysconfig/network-scripts/ifcfg-eth0`

```
DEVICE=eth0
BOOTPROTO=static
ONBOOT=yes
IPADDR=192.168.1.100
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
MTU=1500
```

#### Explanation:

- **`DEVICE=eth0`**: Specifies the network interface name (`eth0`). This parameter identifies which network interface the configuration applies to.

- **`BOOTPROTO=static`**: Defines the method used to configure the IP address. `static` indicates that the IP address is manually configured rather than assigned dynamically (e.g., via `DHCP`).

- **`ONBOOT=yes`**: Ensures that the network interface (`eth0`) is automatically activated during system boot. Setting this to `yes` ensures the interface is brought up when the system starts.

- **`IPADDR=192.168.1.100`**: Sets the static IPv4 address (`192.168.1.100`) for the `eth0` interface. Replace this with the desired IP address for your network configuration.

- **`NETMASK=255.255.255.0`**: Specifies the subnet mask (`255.255.255.0`) associated with the IP address. The subnet mask determines which part of the IP address is the network portion and which part is the host portion.

- **`GATEWAY=192.168.1.1`**: Defines the default gateway (`192.168.1.1`) for the network interface. The gateway is used for routing traffic to destinations outside the local subnet.

- **`MTU=1500`**: Sets the Maximum Transmission Unit (MTU) to `1500` bytes for the `eth0` interface. MTU defines the largest packet size that can be transmitted over the network interface without fragmentation.

## Subnet Masks and Network Ranges
Masks are very important for segmenting your network so traffic is routed appropriately. There are two notations to do this:

1. Subnet masks like `255.255.255.0`
2. CIDR notation like `/24`
Both of these do the same thing, but you'll see both used "in the wild."

#### Subnet Mask `255.255.255.0` (CIDR `/24`):

- **Explanation**: This subnet mask (`255.255.255.0`) allows for up to 254 usable IP addresses within the same network.

##### Example with Network `192.168.1.xxx`:

- **Network Address**: `192.168.1.0/24`
    - **Range of IP Addresses**: `192.168.1.1` to `192.168.1.254`
    - **Subnet Mask**: `255.255.255.0`

- **Usage**: 
    - This subnet mask divides the IP address `192.168.1.0` into a network portion (`192.168.1`) and a host portion (`xxx`). The last octet (`xxx`) ranges from `1` to `254`, with `0` reserved as the network address and `255` reserved as the broadcast address.

#### Subnet Mask `255.255.0.0` (CIDR `/16`):

- **Explanation**: This subnet mask (`255.255.0.0`) allows for up to 65,534 usable IP addresses within the same network.

##### Example with Network `192.168.xxx.xxx`:

- **Network Address**: `192.168.0.0/16`
    - **Range of IP Addresses**: `192.168.0.1` to `192.168.255.254`
    - **Subnet Mask**: `255.255.0.0`

- **Usage**: 
    - This subnet mask divides the IP address `192.168.0.0` into a network portion (`192.168`) and two host portions (`xxx.xxx`). The third and fourth octets (`xxx.xxx`) range from `0.1` to `255.254`, with `0.0` reserved as the network address and `255.255` reserved as the broadcast address.

### Additional Examples:

#### Subnet Mask `255.0.0.0` (CIDR `/8`):

- **Example**: 
    - **Network Address**: `192.0.0.0/8`
    - **Range of IP Addresses**: `192.0.0.1` to `192.255.255.254`
    - **Subnet Mask**: `255.0.0.0`

- **Usage**: 
    - This subnet mask divides the IP address `192.0.0.0` into a network portion (`192`) and three host portions (`xxx.xxx.xxx`). The second, third, and fourth octets (`xxx.xxx.xxx`) range from `0.0.1` to `255.255.254`, with `0.0.0.0` reserved as the network address and `255.255.255.255` reserved as the broadcast address.

#### Subnet Mask `255.255.128.0` (CIDR `/17`):

- **Example**: 
    - **Network Address**: `192.168.0.0/17`
    - **Range of IP Addresses**: `192.168.0.1` to `192.168.127.254`
    - **Subnet Mask**: `255.255.128.0`

- **Usage**: 
    - This subnet mask divides the IP address `192.168.0.0` into a network portion (`192.168.0`) and a host portion (`xxx`). The third octet (`0.xxx`) ranges from `0.1` to `127.254`, with `0.0` reserved as the network address and `127.255` reserved as the broadcast address.

