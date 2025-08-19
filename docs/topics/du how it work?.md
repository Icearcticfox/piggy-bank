The `du` command works by analyzing the file system and calculating the number of blocks occupied by files and directories on the disk. The process of how this command works can be broken down into several stages:

### Stages of how the `du` command works:

1. **Searching for files and directories**:
   - When the `du` command is run without additional options, it starts from the specified directory (or the current directory if none is specified) and recursively traverses all files and subdirectories.
   - For each file and directory, it calculates how many disk blocks they occupy.

2. **Counting blocks**:
   - In Linux, files on the disk are stored in blocks of fixed size, usually 4KB (4096 bytes), but this may vary depending on the file system.
   - The `du` command calculates the number of these blocks for each file.
   - For directories, it sums up the size of all files and subdirectories they contain.

3. **Displaying size in blocks**:
   - By default, the `du` command displays the size of files and directories in blocks (usually 1 block = 1 kilobyte). However, using the `-h` flag allows you to output the size in a human-readable format (e.g., KB, MB, GB).

4. **Handling symbolic links**:
   - If a symbolic link is encountered, by default `du` only counts the size of the link itself (usually a few bytes) and not the size of the file it points to. This can be changed with flags (`-L` to count the target file's size).

5. **Ignoring duplicates via hard links**:
   - Hard links are multiple links to the same file on the disk. The `du` command by default counts the file's size only once, even if it has multiple hard links.

6. **Data aggregation**:
   - The command recursively processes all files and directories, summing their sizes, and then displays the total result for each directory. If the `-s` flag is specified, only the total size of the directory is shown without detailing its contents.

7. **Example of how it works at the system level**:
   Let's imagine you have a directory `/home/user` containing files. When you run `du /home/user`, the following happens:
   - `du` opens the `/home/user` directory and retrieves a list of all files and subdirectories.
   - For each file, the command accesses its metadata (using the `stat()` system call) to get information about the number of blocks occupied by this file.
   - If the file is a directory, `du` recursively descends into it, summing the sizes of all files and subdirectories.

### Interaction with the file system:

The `du` command uses system calls such as:
- **`opendir()` and `readdir()`** to open and read the contents of directories.
- **`stat()`** to retrieve file metadata, including information on the number of blocks, file owner, permissions, etc.
- **`lstat()`** to work with symbolic links (to differentiate a symbolic link from a regular file).

### Example of how it works:
If you run the `du` command on a large directory, the process will be as follows:
1. The command processes all files in the root directory.
2. It descends into each subdirectory and repeats the process.
3. For each file, it retrieves information on the number of blocks occupied by the file.
4. The sizes of all files and directories are summed to display the total directory size.

Thus, the `du` command gives you an understanding of how disk space is being used, providing information for each directory or file based on the blocks allocated by the file system. 
