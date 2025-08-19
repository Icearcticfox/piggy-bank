**System Activity Reporter**
[`sar`](https://rtfm.co.ua/linux-utilita-sar-opisanie-primery/)

The `sar` (System Activity Reporter) command in Linux is a powerful tool for monitoring system performance. It collects, reports, and saves system activity information, making it a valuable utility for analyzing the performance of CPU, memory, disk, and network activities over time.

### Basic Usage of `sar`

Here are some essential `sar` commands and their use cases:

- **Basic CPU Usage Monitoring**

  To monitor CPU usage at 1-second intervals for 5 iterations:

  ```bash
  sar 1 5
  ```

  - The first argument (`1`) specifies the interval in seconds between each report.
  - The second argument (`5`) specifies the number of reports to generate.

  This command outputs CPU usage statistics such as user time, system time, and idle time at each interval.

- **Monitoring Disk Activity**

  To monitor disk activity at 1-second intervals for 5 iterations:

  ```bash
  sar -d 1 5
  ```

  - `-d`: Reports disk activity statistics, including read/write operations per second and average request size.

  This command provides a snapshot of disk performance, helping identify I/O bottlenecks or issues with disk utilization.

### Understanding `sar` Output

The output of `sar` varies depending on the options used. Here's a brief overview of common metrics:

- **CPU Metrics**:
  - `%user`: Percentage of CPU utilization that occurred while executing user-level code.
  - `%system`: Percentage of CPU utilization that occurred while executing system-level code.
  - `%idle`: Percentage of CPU time spent idle.

- **Disk Metrics**:
  - `tps`: Transfers per second (I/O operations).
  - `rd_sec/s`: Number of sectors read per second.
  - `wr_sec/s`: Number of sectors written per second.
  - `avgrq-sz`: Average size (in sectors) of the requests that were issued to the device.

### Practical Use Cases

- **Real-Time CPU Monitoring**: Use `sar` to get a quick overview of CPU usage in real-time, which can help identify processes that are overutilizing the CPU.

  ```bash
  sar 1 5
  ```

- **Analyzing Disk I/O Performance**: If your system is experiencing slow disk performance, use `sar -d` to monitor disk I/O and identify potential bottlenecks.

  ```bash
  sar -d 1 5
  ```

- **Historical Performance Analysis**: `sar` can be configured to collect system performance data over time, which can then be analyzed to identify trends or issues that develop gradually.

  For example, to view historical CPU usage from the sar logs:

  ```bash
  sar -f /var/log/sa/sa10
  ```

  Here, `/var/log/sa/sa10` refers to a sar log file for a specific day.

### Conclusion

The `sar` command is a versatile and powerful tool for system performance monitoring in Linux. Whether you're interested in real-time performance data or historical analysis, `sar` provides detailed insights into CPU, disk, and other system activities. For more in-depth usage and advanced options, refer to the `man sar` page or explore additional resources like the linked [sar guide](https://rtfm.co.ua/linux-utilita-sar-opisanie-primery/).