### SSH Access with NAT Network

When using a NAT network in a virtual machine, direct SSH access can be challenging because NAT hides internal IP addresses. To access the VM via SSH, you need to set up port forwarding in the NAT configuration.

#### Steps to Configure Port Forwarding:

1. **Open the Virtual Machine Settings:**
   - Open VirtualBox and select the desired virtual machine.
   - Go to the **Settings** section of the virtual machine.

2. **Network Configuration:**
   - Navigate to the **Network** tab.
   - Ensure that the network is set to **NAT** mode.

3. **Adding Port Forwarding:**
   - In the **Advanced** section, click on the **Port Forwarding** button.
   - In the window that appears, add a new port forwarding rule.
   - The settings for SSH should be as follows:
	 - **Protocol**: TCP
     - **Host IP**: leave blank or enter `127.0.0.1`
     - **Host Port**: choose a port on the host (e.g., `2222`)
     - **Guest IP**: leave blank or enter the IP address inside the virtual machine
     - **Guest Port**: usually `22` (the default SSH port)

  ![[forvardports657889.png]]