### Comprehensive Guide on Disk Analysis, I/O, and Mounting in Linux

Managing disk space, analyzing disk I/O performance, and properly mounting file systems are crucial tasks for system administrators. This guide covers essential Linux commands for these tasks, including `dd`, `du`, `df`, `iostat`, and `mount`.

---
### Disk Analysis

#### 1. Viewing Disk Usage with `du`

The `du` (disk usage) command estimates the space used by files and directories.

- **Basic Usage**

  To display the disk usage of a directory and its subdirectories:

  ```bash
  du -h /path/to/directory
  ```

  - `-h`: Displays sizes in human-readable format (e.g., KB, MB, GB).

- **Summarize Disk Usage**

  To display the total size of a directory:

  ```bash
  du -sh /path/to/directory
  ```

  - `-s`: Summarize, only shows the total size.

- **Analyze Disk Usage with Sorting**

  To analyze disk usage and sort the results:

  ```bash
  du -hsx /var/lib/docker/* | sort -rh | head -n 35
  ```

  - `-x`: Skip directories on different file systems.
  - `sort -rh`: Sort by size in reverse order.
  - `head -n 35`: Display the top 35 entries.

  Another example for `/home` directory:

  ```bash
  du -hsx /home/* | sort -rh | head -n 35
  ```

#### 2. Checking Disk Space with `df`

The `df` (disk free) command reports file system disk space usage.

- **Basic Disk Space Usage**

  To display disk space usage for all mounted file systems:

  ```bash
  df -h
  ```

  - `-h`: Human-readable output.

- **Check Specific File System**

  To check the disk space usage of a specific file system:

  ```bash
  df -h /dev/sda1
  ```

  This will display information specific to the `/dev/sda1` file system.

#### 3. Disk I/O Analysis with `iostat`

The `iostat` command is used to monitor system I/O device loading by observing the time the devices are active relative to their average transfer rates.

- **Basic I/O Statistics**

  To display I/O statistics:

  ```bash
  iostat
  ```

- **Detailed Report**

  To get a detailed report with extended statistics:

  ```bash
  iostat -x
  ```

  - `-x`: Display extended statistics.

- **Monitoring I/O Continuously**

  To monitor I/O performance every few seconds:

  ```bash
  iostat 5
  ```

  This command will refresh the I/O statistics every 5 seconds.

### Disk Operations

#### 1. Copying Data at Binary Level with `dd`

The `dd` command is used to copy and convert files at a binary level. It’s commonly used for tasks like creating bootable USB drives, backing up disk partitions, and more.

- **Basic Copying**

  To copy data from one file or device to another:

  ```bash
  dd if=/dev/sda of=/dev/sdb bs=64K conv=noerror,sync
  ```

  - `if`: Input file (source).
  - `of`: Output file (destination).
  - `bs`: Block size, here 64K is used.
  - `conv=noerror,sync`: Continue on read errors and pad the output with zeros to maintain sync.

- **Backup and Restore a Disk**

  To create an image of a disk:

  ```bash
  dd if=/dev/sda of=/path/to/backup.img
  ```

  To restore from the image:

  ```bash
  dd if=/path/to/backup.img of=/dev/sda
  ```

- **Create a Bootable USB**

  To create a bootable USB from an ISO file:

  ```bash
  dd if=/path/to/iso of=/dev/sdb bs=4M status=progress
  ```

  - `status=progress`: Displays the progress of the operation.

### Mounting File Systems

Mounting is the process of making a file system accessible at a certain point in the Linux directory tree.

#### 1. Basic Mounting

To mount a disk or partition:

```bash
sudo mount /dev/sdb1 /mnt
```

- `/dev/sdb1`: The partition or disk to be mounted.
- `/mnt`: The directory where the file system will be accessible.

#### 2. Unmounting

To unmount a file system:

```bash
sudo umount /mnt
```

#### 3. Persistent Mounting (Adding to `/etc/fstab`)

To automatically mount a file system at boot, add an entry to `/etc/fstab`.

Example entry for `/dev/sdb1`:

```bash
/dev/sdb1  /mnt  ext4  defaults  0  2
```

- `ext4`: The file system type.
- `defaults`: Default mount options.
- `0 2`: Dump (backup) and fsck (file system check) options.

#### 4. Viewing Mounted File Systems

To view all currently mounted file systems:

```bash
mount | column -t
```

This command displays mounted file systems in a more readable format.

#### 5. Useful Resource for Mounting Persistent Disks

For detailed instructions on mounting disks in cloud environments, you can refer to the following guide:

- [How to Mount a Disk on Google Cloud](https://cloud.google.com/compute/docs/disks/add-persistent-disk)

### Conclusion

This guide provides a comprehensive overview of essential disk management commands in Linux. Understanding how to analyze disk usage, monitor I/O performance, and properly mount file systems is crucial for maintaining a healthy and efficient system.

These tools (`dd`, `du`, `df`, `iostat`, `mount`) are powerful and versatile, allowing you to perform a wide range of tasks, from simple file system checks to advanced disk operations. Always refer to the `man` pages (e.g., `man dd`, `man du`, `man mount`) for more detailed information and additional options.