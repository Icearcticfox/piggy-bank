**System Call Tracer**  
[`strace`](https://losst.ru/komanda-strace-v-linux)

The `strace` command in Linux is a powerful diagnostic and debugging tool used to monitor and analyze system calls made by a process and the signals it receives. This tool is particularly useful for understanding how a program interacts with the operating system, and for troubleshooting issues related to system calls.

Here are some essential `strace` commands and their use cases:

- **Basic Usage**

  To trace the system calls made by a simple command (e.g., `uname`):

  ```bash
  strace uname
  ```

  This command outputs a list of all system calls made by the `uname` command, along with their return values.

- **Trace a Command with Detailed Output**

  To run a command with `strace` and see detailed output, including following child processes (`-f`) and setting a string limit for output (`-s`):

  ```bash
  strace -s 1024 -f bash -c "ls | grep hello"
  ```

  - `-s 1024`: Sets the maximum string size to print in the trace to 1024 characters.
  - `-f`: Follows child processes created by `fork()`.

  This command traces the execution of the `ls | grep hello` pipeline within a `bash` shell, providing a detailed view of system calls, including those made by any child processes.

- **Attach to a Running Process**

  To attach `strace` to an already running process by its PID (e.g., PID 123):

  ```bash
  sudo strace -p 123
  ```

  This allows you to observe the system calls made by a process that is already running. It's useful for diagnosing issues in long-running processes without restarting them.

### Understanding `strace` Output

The output of `strace` consists of lines that represent individual system calls. Each line typically includes:

- **System Call Name**: The name of the system call being made (e.g., `open`, `read`, `write`).
- **Arguments**: The arguments passed to the system call.
- **Return Value**: The result of the system call (e.g., a file descriptor, number of bytes read/written, or an error code).

For example, an output line might look like this:

```bash
open("/etc/hosts", O_RDONLY) = 3
```

This line indicates that the `open` system call was used to open the file `/etc/hosts` in read-only mode, and the call returned the file descriptor `3`.

### Practical Use Cases

- **Debugging Program Execution**: `strace` is often used to debug issues where a program is not behaving as expected. By observing the system calls, you can identify where a program might be failing or getting stuck.
  
  ```bash
  strace -o output.txt ./my_program
  ```

  This command runs `my_program` and saves the `strace` output to `output.txt` for later analysis.

- **Analyzing File Access**: If you need to see which files a program is trying to access, `strace` can help identify any missing files or permission issues.
  
  ```bash
  strace -e trace=file ./my_program
  ```

  The `-e trace=file` option limits the trace to file-related system calls.

- **Monitoring Network Activity**: You can use `strace` to monitor network-related system calls, such as `connect`, `sendto`, and `recvfrom`.
  
  ```bash
  strace -e trace=network ./network_program
  ```

  This is useful for debugging network connectivity issues.

- **Understanding Program Behavior**: Sometimes, `strace` is used simply to understand how a program interacts with the operating system, which can be useful for learning or documentation purposes.

### Conclusion

The `strace` command is an indispensable tool for debugging and understanding the behavior of Linux programs. Whether you're troubleshooting a stubborn bug, analyzing a program's performance, or simply curious about how a program interacts with the system, `strace` provides deep insights into the underlying system calls. For more detailed usage, refer to the `man strace` page or explore additional resources like the linked [strace guide](https://losst.ru/komanda-strace-v-linux).