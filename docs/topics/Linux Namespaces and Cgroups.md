## **Introduction**

**Linux Namespaces** and **Cgroups** are key technologies in containerization, enabling isolated and controlled environments for processes. These mechanisms form the foundation for container technologies like Docker and are essential for modern cloud services. This article explores how namespaces and control groups function in Linux.

---

# **1. Linux Namespaces (Process Isolation)**

**Namespaces** isolate system resources (such as process IDs, networks, and file systems) between processes, making each isolated process believe it has its own operating system.

## **1.1. Overview of Namespaces and Their Use Cases**

| **Namespace** | **Purpose** | **Example Use Case** |
|-------------|------------|---------------------|
| **PID** (Process Isolation) | Isolates process IDs, making processes inside a container unaware of processes outside. | Containers have their own `PID 1`, appearing as a system process. |
| **NET** (Network Isolation) | Provides separate network stacks, interfaces, and IP configurations. | Containers get unique IP addresses and virtual interfaces. |
| **MNT** (Filesystem Isolation) | Creates independent mount points for different filesystems. | Containers can have their own root filesystems separate from the host. |
| **UTS** (Hostname Isolation) | Allows a container to have a different hostname from the host system. | Running a container named `webserver1` while the host is named `myhost`. |
| **IPC** (Interprocess Communication) | Isolates shared memory, semaphores, and message queues. | Prevents unauthorized access to IPC resources between containers. |
| **USER** (User Privilege Isolation) | Maps user IDs inside a container to different ones on the host, increasing security. | Running a process as root inside a container without root privileges on the host. |

---

## **1.2. How Namespaces Work**

### **1.2.1. PID Namespace (Process ID Isolation)**

- Ensures processes inside a container cannot see or interact with host processes.
- The first process inside a PID namespace starts with `PID 1`, acting as the system process.

**Example:**
```
unshare --fork --pid --mount-proc bash
ps aux
```
This command launches a new process namespace where only the `bash` process appears.

---

### **1.2.2. NET Namespace (Network Isolation)**

- Provides separate network interfaces and IP configurations per container.
- Uses **veth (virtual ethernet pairs)** to connect containers to the host network.

**Example:**
```
ip netns add mynamespace
ip netns list
```
Creates and lists a new network namespace.

---

### **1.2.3. MNT Namespace (Filesystem Isolation)**

- Containers see a different filesystem layout than the host.
- Prevents unwanted access to host files.

**Example:**
```
unshare --mount --propagation private
mount --make-rprivate /
```
Creates an independent mount namespace.

---

### **1.2.4. UTS Namespace (Hostname Isolation)**

- Enables containers to have unique hostnames.

**Example:**
```
unshare --uts bash
hostname container-host
hostname
```
The hostname inside this namespace differs from the host's actual hostname.

---

### **1.2.5. IPC Namespace (Interprocess Communication Isolation)**

- Prevents processes from different namespaces from sharing IPC mechanisms.

**Example:**
```
unshare --ipc bash
```
Ensures IPC resources are isolated.

---

### **1.2.6. USER Namespace (User Privilege Isolation)**

- Enables processes to run as root in a container while mapped to a non-root user on the host.

**Example:**
```
unshare --user --map-root-user bash
id
```
Inside this namespace, the user appears as `root`, but externally, it maps to an unprivileged user.

---

# **2. Cgroups (Control Groups: Resource Management)**

**Cgroups** allow fine-grained control over system resources for process groups.

## **2.1. Key Features of Cgroups**

| **Resource** | **Purpose** | **Example Use Case** |
|-------------|------------|---------------------|
| **CPU** | Limits CPU usage per process/group. | Prevents a container from consuming 100% of CPU. |
| **Memory** | Restricts memory usage, preventing one process from exhausting RAM. | Ensures a container cannot use more than 512MB of RAM. |
| **Disk I/O** | Controls read/write speeds to storage devices. | Limits a database container’s disk writes to prevent system slowdown. |
| **Network** | Limits bandwidth and network usage per container. | Ensures fair distribution of network resources between services. |

---

## **2.2. How Cgroups Work**

### **2.2.1. CPU Limits**

- **`cpu.shares`**: Assigns CPU time weight.
- **`cpu.cfs_quota_us`**: Limits CPU time per period.

**Example:**
```
echo 512 > /sys/fs/cgroup/cpu/mygroup/cpu.shares
```
Gives processes in `mygroup` more CPU time.

---

### **2.2.2. Memory Limits**

- **`memory.limit_in_bytes`**: Sets max RAM usage.
- **`memory.memsw.limit_in_bytes`**: Includes swap limits.

**Example:**
```
echo 512M > /sys/fs/cgroup/memory/mygroup/memory.limit_in_bytes
```
Limits the group to 512MB of RAM.

---

### **2.2.3. Disk I/O Limits**

- **`blkio.throttle.read_bps_device`**: Limits read speed.
- **`blkio.throttle.write_bps_device`**: Limits write speed.

**Example:**
```
echo "8:0 1048576" > /sys/fs/cgroup/blkio/mygroup/blkio.throttle.read_bps_device
```
Restricts reads to 1MB/s on device `8:0`.

---

### **2.2.4. Network Limits**

- **`net_cls.classid`**: Tags network packets for prioritization.
- **`net_prio.ifpriomap`**: Assigns network interface priorities.

**Example:**
```
echo 0x100001 > /sys/fs/cgroup/net_cls/mygroup/net_cls.classid
```
Assigns a class ID for traffic control.

---

# **3. Namespaces vs. Cgroups: A Simple Comparison**

| **Feature** | **Namespaces** | **Cgroups** |
|------------|---------------|------------|
| **Purpose** | Provides **isolation** of processes and resources. | Controls **resource allocation** for processes. |
| **Key Function** | Hides or restricts access to system resources. | Limits CPU, memory, disk I/O, and network usage. |
| **Example** | Each container has its own **network and PID space**. | Each container gets a **CPU and memory limit**. |
| **Common Use Case** | Creating **virtualized environments** inside a single OS. | Preventing **resource starvation** in multi-tenant environments. |

---

# **4. Practical Example: Using Namespaces and Cgroups Together**

A typical container runtime like **Docker** leverages **Namespaces for isolation** and **Cgroups for resource control**.

### **Example: Manually Creating an Isolated and Limited Environment**
```
# Create an isolated process space
unshare --fork --pid --mount-proc bash

# Set a memory limit using Cgroups
mkdir /sys/fs/cgroup/memory/mycontainer
echo 256M > /sys/fs/cgroup/memory/mycontainer/memory.limit_in_bytes
echo $$ > /sys/fs/cgroup/memory/mycontainer/cgroup.procs
```
This creates a **namespace-isolated** process with **256MB RAM limit**.

---

# **5. Conclusion**

**Namespaces** and **Cgroups** are the backbone of containerization, ensuring isolation and controlled resource usage.

- **Namespaces** isolate system resources **(processes, networks, filesystems)**.
- **Cgroups** manage **CPU, memory, disk I/O, and network usage**.

🚀 **Together, they provide the foundation for container technologies like Docker, Kubernetes, and LXC.**