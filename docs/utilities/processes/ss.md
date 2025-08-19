### Detailed Guide on `ss`

The `ss` command in Linux is a powerful utility for investigating sockets. It can display detailed information about network connections, listening ports, and much more. It is often considered a more modern and feature-rich alternative to the older `netstat` command.

### Basic Usage of `ss`

The `ss` command provides a comprehensive set of options to display various types of socket information. Here are some of the most commonly used options:

- **`-t`**: Display only TCP sockets.
- **`-u`**: Display only UDP sockets.
- **`-l`**: Show only listening sockets.
- **`-a`**: Show both listening and non-listening (active) sockets.
- **`-p`**: Display the process using the socket.
- **`-n`**: Do not resolve service names (use numeric values).
- **`-r`**: Resolve numeric addresses to hostnames.
- **`-s`**: Display summary statistics.
- **`-4`**: Display only IPv4 sockets.
- **`-6`**: Display only IPv6 sockets.

### Examples

#### 1. List All TCP Connections

To list all TCP connections:

```bash
ss -t
```

This command will show all active TCP connections on the system.

#### 2. List All Listening Ports (TCP)

To display all listening TCP ports:

```bash
ss -tl
```

This command lists only the listening TCP ports. This is useful to see which services are waiting for incoming connections.

#### 3. Show Detailed Information with Process Names

To display detailed information, including process names, for TCP sockets:

```bash
sudo ss -tpla
```

- `-p`: Includes the process using the socket.
- `-l`: Includes only listening sockets.
- `-a`: Shows all sockets (listening and non-listening).

#### 4. Filter by Process Name

To filter the results by a specific process, such as MySQL:

```bash
sudo ss -tap | grep mysql
```

This command will display only the TCP sockets associated with the MySQL service.

Alternatively, if you want to see all sockets (listening and established) related to MySQL:

```bash
sudo ss -tlap | grep mysql
```

- `-t`: Show TCP sockets.
- `-l`: Include listening sockets.
- `-a`: Show all sockets.
- `-p`: Include process information.

#### 5. Show TCP Connections with Hostname Resolution

To display TCP connections and resolve IP addresses to hostnames:

```bash
sudo ss -tr
```

- `-r`: Resolves IP addresses to hostnames.

#### 6. List All UDP Connections

To display all active UDP connections:

```bash
ss -u
```

This will list all UDP connections without showing listening sockets by default.

#### 7. Show IPv4 Only or IPv6 Only Sockets

To list only IPv4 sockets:

```bash
ss -4
```

To list only IPv6 sockets:

```bash
ss -6
```

#### 8. Display Summary Statistics

To display summary statistics of the socket usage:

```bash
ss -s
```

This provides an overview of the current socket state, including the number of established, closed, orphaned, and waiting connections.

### Understanding the Output

When you run a basic `ss` command, the output columns include:

- **Netid**: The type of socket (e.g., `tcp`, `udp`).
- **State**: The current state of the connection (e.g., `ESTAB` for established, `LISTEN` for listening).
- **Recv-Q**: The number of bytes not copied by the user program connected to this socket.
- **Send-Q**: The number of bytes not acknowledged by the remote host.
- **Local Address:Port**: The local IP address and port number.
- **Peer Address:Port**: The remote IP address and port number.
- **Process**: The process name and PID associated with the socket (shown with `-p`).

### Practical Use Cases

- **Monitoring open ports**: Use `ss -tl` to see which ports are open and listening for connections. This is useful for security audits.
- **Diagnosing network issues**: Use `ss -t` to see active TCP connections, which can help diagnose connectivity problems.
- **Identifying resource hogs**: Use `ss -tpla` to find processes that are consuming network resources.

### Conclusion

The `ss` command is a powerful tool for network troubleshooting and monitoring. It provides detailed information about all sockets on your system, including established connections, listening sockets, and the processes associated with them. Whether you're a system administrator or a network engineer, `ss` is an indispensable tool for managing and securing your Linux environment.

For further details, consult the `man ss` page or explore additional options and filters to tailor the output to your specific needs.