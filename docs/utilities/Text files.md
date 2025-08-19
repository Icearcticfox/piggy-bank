
## `grep`

```
cat syslog | grep -E ‘2005/07/19 09:00./ivr/common’ | grep -v ‘try_transfer' > sample_nauivrd.log.
```
[grep operators](https://rtfm.co.ua/grep-poisk-s-operatorami-and-i-or-ili-not-ne/)

---
## `sed`

### Splitting a File into Parts

To split a file into parts where `4646` is the starting line and `9999` is the ending line:

```bash
sed -n 4646,9999p old.file > new.file
```

### Display Lines 5-10

To display lines 5 through 10:

```bash
sed -n '5,10p' /etc/group
```

### Display All Lines Except 5-10

To display all lines except for lines 5 through 10:

```bash
sed -n '5,10d' /etc/group
```

### Substitution Command

The command `s/pattern1/pattern2/` is used for substitution. The letter "s" stands for "substitute."

### Extracting a Portion of a File

To extract a portion of a file from byte 10001 to 20000:

```bash
cat blabla.dump | cut -b 10001-20000 > mumu.dump
```

Here's a mini-guide on using the `tail` command in Linux:

---
## `tail`

The `tail` command is used to display the last part of a file or stream in Linux. By default, it shows the last 10 lines of a file, but you can customize this behavior with various options.

### Basic Usage

To display the last 10 lines of a file:

```bash
tail filename
```

### Display a Specific Number of Lines

To display a specific number of lines from the end of a file, use the `-n` option followed by the number of lines:

```bash
tail -n 20 filename
```

This will display the last 20 lines of the file.

### Display the Last N Bytes

If you want to display the last N bytes instead of lines, use the `-c` option:

```bash
tail -c 50 filename
```

This will display the last 50 bytes of the file.

### Follow a File in Real-Time

One of the most powerful features of `tail` is the ability to follow a file in real-time as new lines are added. This is particularly useful for monitoring log files:

```bash
tail -f filename
```

This command will display the last few lines of the file and continue to output new lines as they are written to the file.

You can combine `-f` with `-n` to start from a specific number of lines and continue following:

```bash
tail -n 50 -f filename
```

### Stop Following After a Certain Period

If you want to follow a file for a limited amount of time, use the `--pid` option along with a process ID, or `--max-unchanged-stats` to stop after a certain period of inactivity:

```bash
tail -f filename --pid=1234
```

Or:

```bash
tail -f filename --max-unchanged-stats=5s
```

### Example: Monitoring System Logs

A common use case for `tail` is monitoring system logs:

```bash
tail -f /var/log/syslog
```

This command will display the latest system log entries as they are added to the file.


Here are mini-guides for the `tar` and `tr` commands in Linux:

---
## `tar` Command in Linux

The `tar` command is used to create, extract, and manage archive files in Linux. It is commonly used to compress and package multiple files into a single file for easier distribution or backup.

### Basic Usage

To create a `tar` archive:

```bash
tar -cvf archive_name.tar directory_or_file
```

- `-c` : Create a new archive.
- `-v` : Verbose mode, shows progress in the terminal.
- `-f` : Specifies the filename of the archive.

### Compressing an Archive with `gzip`

To compress the archive using `gzip`, use the `-z` option:

```bash
tar -czvf archive_name.tar.gz directory_or_file
```

- `-z` : Compress the archive using `gzip`.

### Extracting an Archive

To extract a `tar` archive:

```bash
tar -xvf archive_name.tar
```

- `-x` : Extract files from an archive.

For compressed archives:

```bash
tar -xzvf archive_name.tar.gz
```

### Extracting a Specific File

To extract a specific file from a `tar` archive:

```bash
tar -xvf archive_name.tar file_to_extract
```

### List Contents of an Archive

To list the contents of a `tar` archive without extracting:

```bash
tar -tvf archive_name.tar
```

- `-t` : List the contents of the archive.

### Example: Creating and Extracting an Archive

Create a compressed archive:

```bash
tar -czvf backup.tar.gz /path/to/directory
```

Extract the compressed archive:

```bash
tar -xzvf backup.tar.gz
```

---

## `tr` Command in Linux

The `tr` command is used to translate or delete characters from the input provided to it. It reads from standard input and writes to standard output, making it useful for various text processing tasks.

### Basic Usage

To translate characters, specify the characters to replace and their replacements:

```bash
echo "hello world" | tr 'a-z' 'A-Z'
```

This command converts all lowercase letters to uppercase:

**Output:**
```
HELLO WORLD
```

### Delete Specific Characters

To delete specific characters, use the `-d` option:

```bash
echo "hello 123 world" | tr -d '0-9'
```

This will remove all digits from the text:

**Output:**
```
hello  world
```

### Replace Multiple Spaces with a Single Space

To replace multiple spaces with a single space:

```bash
echo "hello     world" | tr -s ' '
```

- `-s` : Squeeze, which replaces sequences of a character with a single instance.

**Output:**
```
hello world
```

### Example: Translating and Deleting Characters

Translate spaces to newlines:

```bash
echo "apple orange banana" | tr ' ' '\n'
```

Delete all vowels from the input:

```bash
echo "hello world" | tr -d 'aeiou'
```

**Output:**
```
hll wrld
```
