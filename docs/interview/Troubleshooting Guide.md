This document outlines various commands and techniques for troubleshooting system issues. Each command provides specific insights that can help diagnose and resolve problems efficiently.

## System Load and Uptime

- `uptime` - Displays the load average of the system.

## Kernel Errors

- `dmesg -T | tail` - Shows the latest kernel errors with human-readable timestamps.
## Memory and CPU Statistics  

- `vmstat 1` - Provides statistics on memory, CPU, and processes every second.

- `mpstat -P ALL 1` - Shows CPU load by cores every second.

- `pidstat 1` - Reports statistics on CPU usage by processes every second.
## Disk I/O

- `iostat -xz 1` - Displays detailed disk I/O statistics every second.

## Memory Usage

- `free -m` - Shows the amount of free and used memory in the system in MB.

- `free -mh` - Shows the memory usage in a more human-readable form, including swap usage.  
## Network I/O

- `sar -n DEV 1` - Reports network I/O statistics every second.

- `sar -n TCP,ETCP 1` - Displays detailed TCP networking statistics.
## Service Management

- `systemctl status <service_name>` - Checks the status of a system service using systemd.

- `service <service_name> status` - Checks the status of a service on systems using init.

- `launchctl list | grep <service_name>` - Checks the status of a service on macOS.
## System Logs

- `journalctl -xe` - Displays extended system logs.

- `journalctl -u <service_name>` - Shows logs for a specific service.

## Open Files and Ports

- `lsof -c nginx` - Lists open files for processes related to nginx.

- `sudo lsof -i :12345` - Lists all processes that are using port 12345.

## Disk Usage

- `df -h` - Shows disk space usage in human-readable form.

- `df -i` - Displays inode usage.

- `du -sh /*` - Displays disk usage for each directory in the root.

## Hardware Information

- `lsblk` - Lists information about all available block devices.

- `lsscsi` - Lists SCSI devices like CD-ROMs.

- `lspci` - Shows PCI devices. Install necessary tools with `sudo apt-get install usbutils pciutils`.
## Drive Health

- `smartctl -a /dev/sda` - Displays health information for a disk. Install with `apt install smartmontools`.

## Top Processes

- `top -o %MEM` - Sorts processes based on memory usage.

- `top -o %CPU` - Sorts processes based on CPU usage.

## Kernel Parameters

- `sysctl -a` - Lists all kernel parameters.

## Network Diagnostics

- `ping -s 9000 ya.ru` - Sends a packet with a specific size to test network latency.

- `netstat -at` - Lists all TCP connections.

- `netstat -au` - Lists all UDP connections.

- `netstat -s` - Provides network statistics.

- `route -n` - Displays the routing table.

## Network Scanning

- `nmap -sT <ip_address>` - Scans an IP address for open TCP ports.

## Network Performance

- `iperf -s` - Starts an iPerf server to test network throughput.

- `iperf -c <server_ip>` - Connects to an iPerf server and tests throughput from the client side.

## RAID Array Status

- `mdstat` - Displays the status of RAID arrays.

## Additional Troubleshooting

- `dstat` - Provides a comprehensive view combining vmstat, iostat, netstat, and ifstat.

- `iotop -o` - Displays only those processes that are actually doing I/O.

## SSH Connection Troubleshooting

- Check firewall rules with `iptables -L` and `ufw status`.

- Verify the SSH service status with `systemctl status sshd`.

- Check SELinux status with `sestatus`.

- Review the SSH port configuration with `grep Port /etc/ssh/sshd_config`.

- List listening sockets with `ss -plnt`.

	For detailed guides and tutorials, refer to [this article](https://www.8host.com/blog/ustranenie-nepoladok-ssh-problemy-s-podklyucheniem-k-serveru/).

