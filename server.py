import socket
import time

RED = '\033[91m'
RESET = '\033[0m'
MAGENTA = '\033[35m'
YELLOW = '\033[33m'
BLUE = '\033[34m'

BROADCAST_PORT = 12345
SERVER_PORT = 12345

udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
udp_socket.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

print("Listening for server IP broadcast...")
udp_socket.bind(('', BROADCAST_PORT))
data, addr = udp_socket.recvfrom(1024)
server_ip = data.decode('utf-8')
print(f"Received broadcast from {server_ip}")

while True:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((server_ip, SERVER_PORT))
        s.sendall(("pwd\n").encode())
        current_directory = s.recv(4096).decode()

    print(f"{MAGENTA}{current_directory.strip()} > {RESET}", end="")

    command = input()

    if command.lower() == 'exit':
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((server_ip, SERVER_PORT))
            s.sendall(("exit\n").encode())
        print("Exiting...")
        break

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        try:
            s.connect((server_ip, SERVER_PORT))
            s.sendall((command + "\n").encode())
            output = s.recv(4096).decode()

            if command.startswith("get "):
                filename = command[4:]
                with open(filename, "w") as file:
                    file.write(output)
                print(f"{YELLOW}File '{filename}' received and saved.{RESET}")
            else:
                print(output)
        except ConnectionRefusedError:
            print(f"{RED}Connection failed. Is the server running?{RESET}")
        except Exception as e:
            print(f"{RED}An error occurred: {e}{RESET}")
