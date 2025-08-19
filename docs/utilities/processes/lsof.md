**List Open Files**  [`lsof` Command Reference](https://habr.com/ru/company/ruvds/blog/337934/)

The `lsof` command is a powerful utility for listing open files and the processes that have them open. This tool is invaluable for system administrators when monitoring and troubleshooting a Linux system.

Here are some essential `lsof` commands and their use cases:

- **List Processes Using a Specific File or Directory**

  To list all processes that are using a specific file or directory:

  ```bash
  lsof /path/to/file
  ```

- **Count the Number of Open Files by a Specific User**

  To count the number of open files by the user `icefox`:

  ```bash
  lsof -u icefox | wc -l
  ```

- **Exclude a Specific User**

  To exclude processes run by a specific user (e.g., `icefox`):

  ```bash
  lsof -u^icefox | wc -l
  ```

  The `^` symbol is used to exclude the specified user.

- **List All Unix Domain Socket Files**

  To list all files related to Unix domain sockets:

  ```bash
  lsof -U
  ```

- **List Files Opened by Processes Starting with a Specific Command Name**

  To list files opened by processes with command names that start with a specified string (e.g., `python`):

  ```bash
  lsof -c python | head -15
  ```

  - **Exclude Specific Commands**: To list files opened by all `python` processes except those started with `python2.7`:

    ```bash
    lsof -c python -c^python2.7 | head -10
    ```

- **List Files Opened in a Specific Directory (Non-recursive)**

  To list files and folders opened within a specific directory (but not in its subdirectories):

  ```bash
  lsof +d /usr/bin | head -4
  ```

- **List Files Opened by a Specific Process (PID)**

  To list all files opened by a process with a specific PID:

  ```bash
  lsof -p <PID>
  ```

- **Find TCP Sockets Opened by a Specific Client**

  To find information about TCP sockets opened by a specific client, you can filter the output using `grep`:

  ```bash
  sudo lsof -Pni TCP | grep Mail
  ```

- **List Files with Specific Internet Addresses**

  The `-i` option lists information about files with internet addresses matching a specific pattern. If no address is specified, it will list all internet sockets and network files:

  ```bash
  lsof -i
  ```

  You can also filter by protocol (e.g., `TCP`, `UDP`) and port numbers.

---

### Detailed Guide on the `lsof` Command in Linux

The `lsof` (List Open Files) command is an essential tool for system administrators and users who need to monitor or troubleshoot open files and the processes that have opened them. Since everything in Linux is treated as a file (including network connections, devices, and directories), `lsof` can provide a wealth of information about the system's current state.

### Basic Usage of `lsof`

The `lsof` command is highly versatile, with many options to filter and format the output. Below are some of the most common use cases.

#### 1. List All Open Files

To list all open files on the system:

```bash
sudo lsof
```

Since the output can be extensive, it's common to pipe it to `less` for easier viewing:

```bash
sudo lsof | less
```

#### 2. List Open Files by a Specific User

To list all open files by a specific user (e.g., `username`):

```bash
sudo lsof -u username
```

#### 3. List Open Files by a Specific Process

To list all open files associated with a specific process ID (PID):

```bash
sudo lsof -p <PID>
```

For example, to list open files by the process with PID 1234:

```bash
sudo lsof -p 1234
```

#### 4. List Open Files for a Specific Command

To list open files associated with a specific command (e.g., `sshd`):

```bash
sudo lsof -c sshd
```

This will list all files opened by processes that match the command name `sshd`.

#### 5. List Open Files in a Specific Directory

To list all open files within a specific directory (e.g., `/var/log`):

```bash
sudo lsof +D /var/log
```

The `+D` option lists all open files under the specified directory recursively.

#### 6. List Open Network Connections

To list all open network connections:

```bash
sudo lsof -i
```

This command lists all open Internet, X.25, and UNIX domain socket files. It's particularly useful for troubleshooting network issues.

#### 7. List Open Files on a Specific Port

To list open files associated with a specific network port (e.g., port 80):

```bash
sudo lsof -i :80
```

You can specify both TCP and UDP ports by appending `/tcp` or `/udp`, like this:

```bash
sudo lsof -iTCP:80
```

#### 8. List Open Files by Protocol (TCP/UDP)

To filter open network files by protocol, you can use:

```bash
sudo lsof -i tcp
sudo lsof -i udp
```

These commands will list all open TCP or UDP network connections, respectively.

#### 9. Find Files Opened by a Specific Network Address

To list files opened by a specific IP address:

```bash
sudo lsof -i @192.168.1.1
```

You can combine this with a port number as well:

```bash
sudo lsof -i @192.168.1.1:80
```

#### 10. List Open Files by File Descriptor Type

To filter by file descriptor type, such as regular files, directories, or sockets:

```bash
sudo lsof -d 1-3
```

This command lists open files with file descriptors in the range of 1 to 3.

### Understanding the Output

The output of `lsof` typically contains the following columns:

- **COMMAND**: The name of the command associated with the open file.
- **PID**: The Process ID of the command.
- **USER**: The user who owns the process.
- **FD**: The file descriptor, which shows how the file is being used (e.g., `cwd` for current working directory, `txt` for text files, `mem` for memory-mapped files, and numbers for regular file descriptors).
- **TYPE**: The type of node associated with the file (e.g., `REG` for regular file, `DIR` for directory, `CHR` for character special file).
- **DEVICE**: The device number.
- **SIZE/OFF**: The size or offset of the file.
- **NODE**: The inode number of the file.
- **NAME**: The name of the file or network address.

### Practical Use Cases

- **Identifying Files in Use Before Unmounting**: Before unmounting a filesystem, use `lsof` to check if any files are still in use, which could prevent unmounting.
  
  ```bash
  sudo lsof /mnt/mydisk
  ```

- **Finding Open Files by Deleted Processes**: To find files that are still open by processes even after they’ve been deleted (useful for freeing up space):
  
  ```bash
  sudo lsof | grep deleted
  ```

- **Troubleshooting Network Services**: If a service isn’t starting because the port is already in use, you can identify which process is using the port:
  
  ```bash
  sudo lsof -i :80
  ```

- **Checking Which Files a Process is Using**: This is useful for debugging or security purposes to see exactly what files a process is accessing.

### Conclusion

The `lsof` command is a powerful utility for listing and managing open files on a Linux system. Whether you're troubleshooting system issues, monitoring network activity, or managing file systems, `lsof` provides invaluable insights into the current state of your system.

For more advanced usage, refer to the `man lsof` page, which contains additional options and examples.