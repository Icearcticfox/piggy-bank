[ps commands](https://blog.sedicomm.com/2018/05/28/30-poleznyh-komand-ps-dlya-monitoringa-protsessov-linux/)  

The `ps` command in Linux is a versatile tool used for monitoring and managing processes. It provides detailed information about running processes, including process IDs (PIDs), CPU and memory usage, and much more. This command is essential for system administrators and anyone needing to manage or troubleshoot processes on a Linux system.

Here are some essential `ps` commands and their use cases:

- **List All Processes**

  To display a list of all processes running on the system:

  ```bash
  ps aux
  ```

  This command provides a comprehensive view of all running processes along with their resource usage.

- **View a Specific Process**

  To view detailed information about a specific process by its PID (e.g., PID 123):

  ```bash
  ps -up 123
  ```

  This command shows detailed information about the process with PID 123.

- **Sort Processes by Resource Usage**

  - **By Memory Usage**:

    ```bash
    ps aux --sort -rss
    ```

    Or using `sort`:

    ```bash
    ps aux | sort -nk 4
    ```

  - **By CPU Usage**:

    ```bash
    ps aux --sort -%cpu
    ```

    Or using `sort`:

    ```bash
    ps aux | sort -nk 3
    ```

  These commands allow you to quickly identify processes that are consuming the most memory or CPU resources.

- **Display Process Hierarchy**

  To display processes in a hierarchical tree format, showing their parent-child relationships:

  ```bash
  ps auxf
  ```

  Or to view the process hierarchy for a specific user (e.g., `icefox`):

  ```bash
  ps -f -U icefox
  ```

- **List Processes Related to Your Terminal**

  To list all processes related to your current terminal session:

  ```bash
  ps -x
  ```

### Process State Codes

When you run `ps`, you might notice different state codes in the output, especially in the `STAT` or `S` columns. These codes represent the current state of the process:

- **D**: Uninterruptible sleep (usually I/O).
- **R**: Running or runnable (on run queue).
- **S**: Interruptible sleep (waiting for an event to complete).
- **T**: Stopped, either by a job control signal or because it is being traced.
- **W**: Paging (not valid since kernel 2.6.xx).
- **X**: Dead (should never be seen).
- **Z**: Defunct ("zombie") process, terminated but not reaped by its parent.

### Additional `ps` Commands and Use Cases

- **List All Processes with Detailed Information**

  To display a more detailed list of all running processes:

  ```bash
  ps -ef
  ```

  This command provides extended information about each process, including parent PIDs (PPIDs) and start times.

- **View a Specific User's Processes**

  To view all processes owned by a specific user (e.g., `username`):

  ```bash
  ps -u username
  ```

  This command lists only the processes started by the specified user.

- **Monitor Processes Continuously**

  Although `ps` does not inherently provide continuous monitoring like `top`, you can use `watch` to periodically run the `ps` command:

  ```bash
  watch -n 1 'ps aux --sort=-%cpu | head'
  ```

  This command updates the list of top CPU-consuming processes every second.

### Conclusion

The `ps` command is a powerful and flexible tool for managing and monitoring processes on a Linux system. Whether you need to identify resource-hungry processes, view the process hierarchy, or simply check the state of running processes, `ps` offers a wide range of options to meet your needs. For more advanced usage, refer to the `man ps` page or explore additional resources like the linked [ps commands guide](https://blog.sedicomm.com/2018/05/28/30-poleznyh-komand-ps-dlya-monitoringa-protsessov-linux/).