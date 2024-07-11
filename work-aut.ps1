function domainChange {
    try {
        # Prompt the user to enter 'r' to leave the domain or 'a' to enter the domain
        $changeOption = Read-Host "Enter [l] to leave the domain [e] to enter the domain"

        # Check the user input
        if ($changeOption -eq 'l') {
            # If 'r' is entered, remove the computer from the domain
            Remove-Computer -UnjoinDomainCredential (Get-Credential) -WorkgroupName "WorkGroup" -Restart
        } elseif ($changeOption -eq 'e') {
            # Prompt the user to enter the domain name
            [string]$domain = Read-Host "Enter the domain name"
            # If 'a' is entered, add the computer to a domain
            Add-Computer -DomainName "$domain" -Credential (Get-Credential) -Restart
        } else {
            # If an invalid input is entered, display an error message and exit the script
            Write-Host "`nInvalid input."
        }
    } catch {
        Write-Host "The operation could not be completed."
        Write-Host "$($_.Exception.Message)"
    }
}

function rdpPortChange {
    try {
        # Get the value of the RDP port number from the registry
        $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'
        $portNumber = (Get-ItemProperty -Path $regPath -Name "PortNumber").PortNumber

        # Prompt the user to enter a new port value
        [int]$portValue = Read-Host "Enter the new port value (current: $portNumber)"

        # Validate the input to ensure it's a valid port number
        if (-not ($portValue -as [int]) -or $portValue -lt 1024 -or $portValue -gt 65535) {
            Write-Host "Invalid port number. Port number must be an integer between 1 and 65535."
        }

        # Set the RDP port number in the registry to the new value entered by the user
        Set-ItemProperty -Path $regPath -Name "PortNumber" -Value $portValue

        if (-not (Get-NetFirewallRule | Where-Object {$_.Direction -eq 'Inbound' -and $_.LocalPort -eq $portNumber})) {
            # Define the display name for the firewall rule
            $ruleName = "RDP Port $portValue"

            # Create a new inbound firewall rule for TCP and UDP traffic on the specified port
            New-NetFirewallRule -DisplayName "$ruleName (TCP)" -Profile Any -Direction Inbound -Action Allow -Protocol TCP -LocalPort $portValue
            New-NetFirewallRule -DisplayName "$ruleName (UDP)" -Profile Any -Direction Inbound -Action Allow -Protocol UDP -LocalPort $portValue
        }
    } catch {
        Write-Host "An error has occurred and the operation could not be completed."
        Write-Host "$($_.Exception.Message)"
    }
}

function deletePrinters {
    try {
        # Get a list of all printers installed on the computer
        $printers = Get-Printer
        
        # Iterate through each printer and remove it
        foreach ($printer in $printers) {
            if (-not($printer -eq 'Fax' -or 'Micosoft Print to PDF' -or 'Microsoft XPS Document Writer' -or 'OneNoe for Windows 10')) {
                Remove-Printer -Name $printer.Name
                Write-Host "Printer removed: $($printer.Name)"
            }
        }
        Write-Host "All printers removed."
    } catch {
        Write-Host "An error has occurred and the operation could not be completed."
        Write-Host "$($_.Exception.Message)"
    }
}

while ($true) {

    $option = Read-Host "Choose an operation:`n1. Domain change`n2. Change RDP port`n3. Delete all printers`n4. Close the program`nOption"

    switch ($option) {
        '1' {Clear-Host; domainChange; break}
        '2' {Clear-Host; rdpPortChange; break}
        '3' {Clear-Host; deletePrinters; break}
        '4' {Clear-Host; Write-Host "`nClosing the program..."; return}
        Default {Clear-Host; Write-Host "`nInvalid Input."; break}
    }
}