
# Managing Processes and Services

**Supervisor** is a powerful tool for managing and monitoring processes and services in Unix-like operating systems. It allows you to control your services, ensuring they are always running and can be restarted if they fail.

## Key Features of Supervisor

- **Process Monitoring**: Supervisor can automatically restart processes that fail, ensuring high availability.
- **Simple Configuration**: Configuration files are written in a simple INI-style format, making them easy to understand and manage.
- **Web Interface**: An optional web-based interface allows for easy management and monitoring of processes.
- **Logging**: Supervisor provides detailed logging for each managed process, which is crucial for debugging and monitoring.
- **Process Grouping**: Allows you to group related processes, so they can be managed together (e.g., starting or stopping a group of processes at once).

## Installing Supervisor

To install Supervisor on a Debian-based system (such as Ubuntu), use the following command:

```bash
sudo apt-get install supervisor
```

On CentOS or RHEL-based systems, you can install Supervisor using:

```bash
sudo yum install supervisor
```

## Configuring Supervisor

Supervisor’s configuration files are located in the `/etc/supervisor/` directory. The main configuration file is `supervisord.conf`, and individual process configurations are stored in the `/etc/supervisor/conf.d/` directory.

### Example Configuration

Here’s an example of a Supervisor configuration file for managing a simple Python application:

```ini
[program:myapp]
command=/usr/bin/python /path/to/app.py
autostart=true
autorestart=true
stderr_logfile=/var/log/myapp/myapp.err.log
stdout_logfile=/var/log/myapp/myapp.out.log
```

- **command**: Specifies the command to start the program.
- **autostart**: Ensures that the program starts automatically when Supervisor starts.
- **autorestart**: Configures the program to restart automatically if it exits unexpectedly.
- **stderr_logfile** and **stdout_logfile**: Define the log files for capturing standard error and output.

### Starting Supervisor

After configuring your processes, you can start Supervisor using:

```bash
sudo service supervisor start
```

Or, on systems using `systemd`:

```bash
sudo systemctl start supervisor
```

### Managing Processes with Supervisor

You can manage your processes using the `supervisorctl` command:

- **Start a Process**:

  ```bash
  sudo supervisorctl start myapp
  ```

- **Stop a Process**:

  ```bash
  sudo supervisorctl stop myapp
  ```

- **Restart a Process**:

  ```bash
  sudo supervisorctl restart myapp
  ```

- **Check the Status of a Process**:

  ```bash
  sudo supervisorctl status myapp
  ```

- **View Logs**:

  You can view the logs of a managed process directly from the log files defined in the configuration or by using Supervisor’s logging command:

  ```bash
  sudo supervisorctl tail -f myapp
  ```

## Using the Web Interface

Supervisor comes with an optional web interface that you can enable for easier process management. To enable it, add the following section to your `supervisord.conf`:

```ini
[inet_http_server]
port=*:9001
username=user
password=pass
```

- **port**: Defines the port where the web interface will be accessible.
- **username** and **password**: Set the credentials for accessing the web interface.

After making these changes, restart Supervisor to apply the configuration:

```bash
sudo supervisorctl reload
```

You can now access the web interface by navigating to `http://<your-server-ip>:9001` in your web browser.

## Conclusion

Supervisor is an essential tool for anyone managing services and processes on a Linux system. It provides robust features for ensuring that your processes are always running and easily manageable. For more detailed instructions and advanced configurations, you can refer to this [article](https://rtfm.co.ua/linux-supervisor-upravlenie-processami-i-servisami/).