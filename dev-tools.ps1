while ($true) {
    Write-Host "Microsoft frameworks and programs install:`n1. .NET Runtime`n2. ASP.NET Core`n3. Preview .NET Version`n5. Visual Studio Code`n5. Close the program"
    [int]$option = Read-Host "Option"
    if ($option -eq 1 -or $option -eq 2) {
        [Int]$version = Read-Host "Version"
    }
    switch ($option) {
        '1' {
            Clear-Host
            # Install .NET runtime
            winget install Microsoft.DotNet.Runtime.$version
            # Install .NET Desktop runtime
            winget install Microsoft.DotNet.DesktopRuntime.$version
        } '2' {
            Clear-Host
            # Install ASP.NET core
            winget install Microsoft.DotNet.AspNetCore.$version
        } '3' {
            Clear-Host
            # Install .NET preview version
            winget install Microsoft.DotNet.DesktopRuntime.Preview  
        } '4' {
            # Download Microsoft Visual C++ Libraries
            Invoke-WebRequest "https://aka.ms/vs/17/release/vc_redist.x64.exe"
            Start-Process "vc_redist.x64.exe" 
        } '5' {
            Clear-Host
            # Install Visual Studio Code
            winget install --id=Microsoft.VisualStudioCode
        } '6' {
            Write-Host "Closing the program..."
            return
        } Default {
            Clear-Host
            Write-Host "Invalid input"
        }
    }
}








