### date

Convert unixtime to human
```bash
date -r 1692541552253
```

### watch
**Periodically Execute a Command**

The `watch` command in Linux allows you to execute a command periodically, displaying the output in the terminal. It's particularly useful for monitoring system status and changes in real-time.

- **Basic Usage**

  To run a command every 2 seconds:

  ```bash
  watch -n 2 "some action"
  ```

  - `-n 2`: Specifies the interval (in seconds) between command executions.

### SSH and SCP Utilities

#### Copying SSH Key to a Remote Host

To copy your SSH public key to a remote server for passwordless authentication:

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub YOUR_USER_NAME@IP_ADDRESS_OF_THE_SERVER
```

- **Batch Copying SSH Keys to Multiple Servers**

  If you have a list of servers in a file and want to copy your SSH key to all of them:

  ```bash
  #!/bin/bash
  for ip in `cat /home/list_of_servers`; do
      ssh-copy-id -i ~/.ssh/id_rsa.pub $ip
  done
  ```

  This script reads a list of IP addresses from `/home/list_of_servers` and copies the SSH key to each server.

#### Accelerating File Transfers with SCP

To speed up file transfers with SCP using the Blowfish encryption algorithm:

```bash
scp -c blowfish root@host:/home/itsecforu/* /home/itsecforu
```

- **Copying Files to/from a Remote Host**

  Basic usage of `scp` to copy files between hosts:

  ```bash
  scp [other options] [source username@IP]:/[directory and file name] [destination username@IP]:/[destination directory]
  ```

  Example:

  ```bash
  scp user@192.168.1.1:/home/user/file.txt /local/directory/
  ```

- **Running Commands on Multiple Hosts**

  To run a set of commands on multiple hosts listed in a file:

  ```bash
  for HOST in $(cat hosts.txt); do ssh -f $HOST "uptime; df -h"; done
  ```

  This command executes `uptime` and `df -h` on each host listed in `hosts.txt`.

- **Additional SSH Resources**
  - [30 Questions and Answers about SSH](https://itsecforu.ru/2022/01/10/%F0%9F%96%A7-30-%D0%B2%D0%BE%D0%BF%D1%80%D0%BE%D1%81%D0%BE%D0%B2-%D0%B8-%D0%BE%D1%82%D0%B2%D0%B5%D1%82%D0%BE%D0%B2-%D0%BD%D0%B0-%D0%B8%D0%BD%D1%82%D0%B5%D1%80%D0%B2%D1%8C%D1%8E-%D0%BF%D0%BE-ssh/)

---

### Managing Sudo Privileges

#### Granting a User Sudo Access Without a Password

To allow a user to execute `sudo` commands without being prompted for a password, add them to the `/etc/sudoers` file:

1. **Manually Edit `/etc/sudoers`**:

   Add the following line:

   ```bash
   username  ALL=(ALL) NOPASSWD:ALL
   ```

2. **Use a Command to Automate This**:

   Alternatively, you can automate this process with:

   ```bash
   echo "username  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/username
   ```

   This command adds the necessary line to a new file in `/etc/sudoers.d/`.

- **Reference**: [How to Add User to Sudoers in Ubuntu](https://linuxize.com/post/how-to-add-user-to-sudoers-in-ubuntu/)

---

### OpenSSL

**Viewing SSL Certificate Data**

To view detailed information about an SSL certificate:

```bash
openssl x509 -in CERTPATH -text -noout
```

- `CERTPATH`: The path to the SSL certificate file.

To initiate a TLS/SSL connection to a server and diagnose SSL issues use: 
```bash
openssl s_client -connect myservername.domen.my:443 -servername myservername.domen.my
```

- `openssl s_client`: This tool connects to a remote server using SSL/TLS and helps in diagnosing SSL connections.
- `-connect myservername.domen.my:443`: Specifies the server (`myservername.domen.my`) and port (`443`) to connect to. Port 443 is the default for HTTPS.
- `-servername myservername.domen.my`: Sends the Server Name Indication (SNI), which allows the server to present the correct SSL certificate if it's hosting multiple domains.

This command is useful for checking SSL certificate details, supported ciphers, and diagnosing connection issues.

---

### Performance Testing

**Apache Benchmarking**

To test the performance of a website using the Apache `ab` (Apache Benchmark) tool:

- **Usage Example**:

  ```bash
  ab -n 1000 -c 10 http://example.com/
  ```

  - `-n 1000`: Number of requests to perform.
  - `-c 10`: Number of multiple requests to make at a time.

- **Resource**: [Apache Benchmarking Guide](https://admins.su/site-speed-ab/)
  
---
