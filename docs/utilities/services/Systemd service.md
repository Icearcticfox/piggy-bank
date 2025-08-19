
### Viewing the Full Content of a Systemd Service with `systemctl cat`

The `systemctl cat` command is a powerful and useful feature of `systemctl` that allows you to view the full content of a systemd service unit file, including any drop-in configuration files that override or extend the default settings.

#### **Purpose of `systemctl cat`**

When you run `systemctl cat <service_name>`, it displays the contents of the main unit file along with any additional configuration files located in the `/etc/systemd/system/<service_name>.service.d/` directory. This command is particularly useful for debugging or understanding how a service is configured, especially when changes have been made using drop-in files.

#### **Example Usage**

Suppose you want to inspect the `puppet` service unit file, including any modifications or overrides that might be in place. You would run the following command:

```bash
sudo systemctl cat puppet
```

#### **Sample Output Explanation**

```bash
sudo systemctl cat puppet
```

Output:
```
# /lib/systemd/system/puppet.service
#
# Local settings can be configured without being overwritten by package upgrades, for example
# if you want to increase puppet open-files-limit to 10000,
# you need to increase systemd's LimitNOFILE setting, so create a file named
# "/etc/systemd/system/puppet.service.d/limits.conf" containing:
# [Service]
# LimitNOFILE=10000
# You can confirm it worked by running systemctl daemon-reload
# then running systemctl show puppet | grep LimitNOFILE
#
[Unit]
Description=Puppet agent
Wants=basic.target
After=basic.target network.target

[Service]
EnvironmentFile=-/etc/sysconfig/puppetagent
EnvironmentFile=-/etc/sysconfig/puppet
EnvironmentFile=-/etc/default/puppet
ExecStart=/opt/puppetlabs/puppet/bin/puppet agent $PUPPET_EXTRA_OPTS --no-daemonize
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process

[Install]
WantedBy=multi-user.target
```

**Explanation:**

- **Main Unit File**:  
  The output shows the contents of the main unit file located at `/lib/systemd/system/puppet.service`. This file is provided by the package and contains the default configuration for the `puppet` service.

- **Configuration File Locations**:
  - **EnvironmentFile**: The `EnvironmentFile` entries reference external files (`/etc/sysconfig/puppetagent`, `/etc/sysconfig/puppet`, and `/etc/default/puppet`) that can set environment variables for the service. The `-` prefix means that these files are optional; the service will still start if they are not found.
  - **ExecStart**: Specifies the command to start the service. In this case, it runs the Puppet agent with any additional options defined by `$PUPPET_EXTRA_OPTS`.
  - **ExecReload**: Specifies the command to reload the service without stopping it, typically sending a signal to the main process.
  - **KillMode**: Defines how processes are terminated when the service is stopped.

- **Custom Configuration**:
  - The commented section explains how to create a custom configuration file, `/etc/systemd/system/puppet.service.d/limits.conf`, to increase the `LimitNOFILE` setting (which controls the maximum number of open files). This custom configuration will not be overwritten during package upgrades, as it's stored in the `/etc` directory.

#### **Modifying and Extending Service Configurations**

To modify or extend the configuration of a systemd service without altering the original unit file, you can create drop-in configuration files in the `/etc/systemd/system/<service_name>.service.d/` directory.

**Example:**

To increase the `LimitNOFILE` for the `puppet` service:

1. **Create a Drop-In Directory**:

   ```bash
   sudo mkdir -p /etc/systemd/system/puppet.service.d/
   ```

2. **Create a Drop-In Configuration File**:

   ```bash
   sudo nano /etc/systemd/system/puppet.service.d/limits.conf
   ```

3. **Add the Configuration**:

```ini
   [Service]
   LimitNOFILE=10000
```

4. **Reload systemd Configuration**:
   
   After saving the file, reload the systemd configuration to apply the changes:
   
   ```bash
   sudo systemctl daemon-reload
   ```

5. **Verify the Change**:

   You can verify that the change took effect by running:

   ```bash
   systemctl show puppet | grep LimitNOFILE
   ```

This command will show the current `LimitNOFILE` setting for the `puppet` service, confirming that your configuration change has been applied.
### Summary

The `systemctl cat` command is an excellent tool for inspecting service unit files, including any custom modifications made through drop-in configurations. This approach is crucial for managing services in a way that ensures your custom configurations are preserved across system updates and service changes. By using `systemctl cat`, you gain full visibility into how a service is configured, making it easier to diagnose issues, make adjustments, and understand the service's behavior on your system.