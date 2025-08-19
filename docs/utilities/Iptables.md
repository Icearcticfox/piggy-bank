
## Detailed Guide on `iptables` and Routing in Linux

`iptables` is a powerful command-line tool for configuring the Linux kernel's built-in firewall. It allows you to define rules for controlling network traffic. Alongside `iptables`, understanding routing is essential for managing how packets move through your network.

### `iptables` Basics

`iptables` operates on a set of tables, each containing chains of rules that match packets and define actions. The most common tables are:

- **Filter Table**: The default table used for filtering packets (allowing or blocking traffic).
- **NAT Table**: Used for network address translation, which modifies packet source or destination addresses.
- **Mangle Table**: Used for specialized packet alterations.
- **Raw Table**: Used for configuring exemptions from connection tracking.

Each table consists of several predefined chains:

- **INPUT**: Handles packets destined for the local system.
- **OUTPUT**: Handles packets originating from the local system.
- **FORWARD**: Handles packets being routed through the local system.
- **PREROUTING**: Alters packets before routing.
- **POSTROUTING**: Alters packets after routing.

### Basic Commands

- **List Existing Rules**

  To list all rules in the `filter` table:

  ```bash
  sudo iptables -L
  ```

  For detailed output with line numbers:

  ```bash
  sudo iptables -L -v -n --line-numbers
  ```

- **Add a Rule**

  To add a rule that allows incoming HTTP traffic (port 80):

  ```bash
  sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
  ```

  - `-A INPUT`: Appends a rule to the INPUT chain.
  - `-p tcp`: Specifies the protocol (TCP).
  - `--dport 80`: Specifies the destination port (80).
  - `-j ACCEPT`: The action is to accept the packet.

- **Delete a Rule**

  To delete the rule added above (using the rule number from the list command):

  ```bash
  sudo iptables -D INPUT 1
  ```

  Here, `1` is the line number of the rule you want to delete.

- **Block an IP Address**

  To block all incoming traffic from a specific IP address:

  ```bash
  sudo iptables -A INPUT -s 192.168.1.100 -j DROP
  ```

- **Allow All Traffic on a Specific Interface**

  To allow all traffic on a specific network interface (e.g., `eth0`):

  ```bash
  sudo iptables -A INPUT -i eth0 -j ACCEPT
  ```

### NAT and Port Forwarding

Network Address Translation (NAT) is often used to route packets between private networks and the internet.

- **Masquerading**

  This is used when the system is acting as a gateway for a private network. It translates the source address of outgoing packets to the public IP address of the gateway:

  ```bash
  sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  ```

  - `-t nat`: Specifies the NAT table.
  - `-o eth0`: Specifies the outgoing interface.
  - `-j MASQUERADE`: Performs masquerading on the packet.

- **Port Forwarding**

  To forward incoming traffic on port 8080 to an internal server on port 80:

  ```bash
  sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 192.168.1.10:80
  ```

  - `-j DNAT`: Destination NAT, changing the destination IP/port.

- **Saving Rules**

  To make sure your rules persist after a reboot, you can save them:

  - On Debian/Ubuntu:

    ```bash
    sudo iptables-save > /etc/iptables/rules.v4
    ```

  - On RedHat/CentOS:

    ```bash
    sudo service iptables save
    ```

### Advanced Features

- **Logging**

  To log packets that match a certain rule:

  ```bash
  sudo iptables -A INPUT -p tcp --dport 22 -j LOG --log-prefix "SSH Connection: "
  ```

  This logs packets with a custom prefix to `/var/log/messages` or a similar log file depending on your distribution.

- **Rate Limiting**

  To limit the number of incoming connections (e.g., to avoid brute-force attacks on SSH):

  ```bash
  sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
  sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 -j DROP
  ```

### Routing Basics

Routing determines how packets are forwarded from one network to another. In Linux, routing decisions are made based on the routing table, which can be viewed and managed using the `ip` command.

- **View the Routing Table**

  To view the current routing table:

  ```bash
  ip route show
  ```

  The output will show routes in the format: `destination via gateway dev interface`.

- **Add a Static Route**

  To add a route for a specific network:

  ```bash
  sudo ip route add 192.168.2.0/24 via 192.168.1.1 dev eth0
  ```

  This command routes traffic for the `192.168.2.0/24` network via `192.168.1.1` on interface `eth0`.

- **Delete a Route**

  To delete a route:

  ```bash
  sudo ip route del 192.168.2.0/24
  ```

- **Set Default Gateway**

  To set the default gateway (the route packets take if no other route matches):

  ```bash
  sudo ip route add default via 192.168.1.1 dev eth0
  ```

### Policy-Based Routing

Policy-based routing allows for more complex routing decisions based on policies other than just destination IP.

- **Create a New Routing Table**

  Edit `/etc/iproute2/rt_tables` and add a new table:

  ```
  200 my_custom_table
  ```

- **Add Routes to the Custom Table**

  ```bash
  sudo ip route add 192.168.2.0/24 via 192.168.1.1 dev eth0 table my_custom_table
  ```

- **Add a Routing Rule**

  ```bash
  sudo ip rule add from 192.168.1.100/32 table my_custom_table
  ```

  This command routes traffic from `192.168.1.100` using the custom table.

### Conclusion

`iptables` and routing are essential components of network management in Linux. They allow you to control how traffic flows into, out of, and through your network. Whether you’re managing a simple server or a complex network, understanding these tools will enable you to secure and optimize your network effectively.

For more advanced usage, refer to the `man iptables`, `man ip`, and `man ip rule` pages.