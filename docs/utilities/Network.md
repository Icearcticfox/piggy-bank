
Here's a mini-guide on essential networking commands in Linux:

---

## Essential Networking Commands in Linux

This guide covers several key networking commands in Linux, useful for managing, troubleshooting, and monitoring networks.

### `ifconfig`

The `ifconfig` command is used to configure, manage, and display network interface information in Linux. While it's considered deprecated in favor of the `ip` command, it's still widely used.

- **Display network interfaces:**

  ```bash
  ifconfig
  ```

- **Bring an interface up or down:**

  ```bash
  ifconfig eth0 up
  ifconfig eth0 down
  ```

- **Assign an IP address to an interface:**

  ```bash
  ifconfig eth0 192.168.1.100 netmask 255.255.255.0
  ```

### `ip`

The `ip` command is the modern replacement for `ifconfig`, offering more features and flexibility.

- **Display all network interfaces and their IP addresses:**

  ```bash
  ip addr show
  ```

- **Bring an interface up or down:**

  ```bash
  ip link set eth0 up
  ip link set eth0 down
  ```

- **Assign an IP address to an interface:**

  ```bash
  ip addr add 192.168.1.100/24 dev eth0
  ```

- **Display routing table:**

  ```bash
  ip route show
  ```

### `iptables`

The `iptables` command is used to configure the Linux kernel firewall, allowing you to define rules for packet filtering and NAT (Network Address Translation).

- **View existing rules:**

  ```bash
  sudo iptables -L
  ```

- **Allow incoming SSH connections:**

  ```bash
  sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
  ```

- **Block an IP address:**

  ```bash
  sudo iptables -A INPUT -s 192.168.1.100 -j DROP
  ```

- **Save iptables rules (Debian/Ubuntu):**

  ```bash
  sudo iptables-save > /etc/iptables/rules.v4
  ```

### `nc` (Netcat)

`nc` is a versatile networking tool used for creating network connections, scanning ports, and transferring data.

- **Scan for open ports:**

  ```bash
  nc -zv 192.168.1.1 1-1000
  ```

- **Create a simple TCP server:**

  ```bash
  nc -l 1234
  ```

- **Connect to a TCP server:**

  ```bash
  nc 192.168.1.1 1234
  ```

- **Transfer a file:**

  **On the receiving side:**

  ```bash
  nc -l 1234 > received_file
  ```

  **On the sending side:**

  ```bash
  nc 192.168.1.1 1234 < file_to_send
  ```

### `nmap`

`nmap` is a powerful network scanning tool used for discovering hosts and services on a network.

- **Basic scan to detect open ports:**

  ```bash
  nmap 192.168.1.1
  ```

- **Scan a range of IP addresses:**

  ```bash
  nmap 192.168.1.1-255
  ```

- **Scan using a specific port range:**

  ```bash
  nmap -p 1-1000 192.168.1.1
  ```

- **Detect the operating system of a remote host:**

  ```bash
  sudo nmap -O 192.168.1.1
  ```

### `tcpdump`

`tcpdump` is a command-line packet analyzer used for capturing and analyzing network traffic.

- **Capture all packets on a specific interface:**

  ```bash
  sudo tcpdump -i eth0
  ```

- **Capture packets from a specific host:**

  ```bash
  sudo tcpdump -i eth0 host 192.168.1.1
  ```

- **Capture only TCP packets:**

  ```bash
  sudo tcpdump -i eth0 tcp
  ```

- **Save captured packets to a file:**

  ```bash
  sudo tcpdump -i eth0 -w capture.pcap
  ```

### `ping`

The `ping` command is used to test the reachability of a host on an IP network and to measure the round-trip time for messages sent from the source to the destination.

- **Ping a host:**

  ```bash
  ping 192.168.1.1
  ```

- **Ping a host with a specific count of packets:**

  ```bash
  ping -c 4 192.168.1.1
  ```

### `traceroute`

`traceroute` displays the route that packets take to reach a network host.

- **Trace the route to a host:**

  ```bash
  traceroute 192.168.1.1
  ```

### `netstat`

`netstat` is a command-line tool that provides information about network connections, routing tables, interface statistics, masquerade connections, and multicast memberships.

- **Display all active connections:**

  ```bash
  netstat -a
  ```

- **Display listening ports:**

  ```bash
  netstat -l
  ```

- **Display network interface statistics:**

  ```bash
  netstat -i
  ```

### `ss`

`ss` is a utility to investigate sockets. It can display more detailed information than `netstat` and is considered its replacement.

- **Display all TCP connections:**

  ```bash
  ss -t
  ```

- **Display all UDP connections:**

  ```bash
  ss -u
  ```

- **Display listening ports:**

  ```bash
  ss -l
  ```

