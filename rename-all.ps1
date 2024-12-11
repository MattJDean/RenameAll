
# RenameAll.ps1
# Author: Matt Dean
# Contact: matt@mattdean.tech
# Version: 1.0.0
# Created: 11/12/24
# Description: 
# Script to rename all files in a directory 
# based on a user-specified base name 
# and appends or prepends a sequential index.


# PowerShell Execution Policy Bypass
# Temporarily bypass - Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# Turn policy back on (IMPORTANT) - Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Restricted


# Function to select a folder using a graphical dialog
function Select-FolderDialog {
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $DialogResult = $FolderBrowser.ShowDialog()
    if ($DialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
        return $FolderBrowser.SelectedPath
    } else {
        Write-Host "No folder selected. Exiting script." -ForegroundColor Red
        Pause
        Exit
    }
}

try {
    # Select directory
    Write-Host "Please select the directory containing your files:"
    $DirectoryPath = Select-FolderDialog
    if (-Not (Test-Path -Path $DirectoryPath)) {
        Write-Host "Error: Directory does not exist." -ForegroundColor Red
        Pause
        Exit
    }

    # Input parameters
    $BaseFileName = Read-Host "Enter the base filename (e.g. 'my-file')"
    Write-Host "Choose where to place the sequential index:"
    Write-Host "1. Append (e.g., my-file-1)"
    Write-Host "2. Prepend (e.g., 1-my-file)"
    $PlacementChoice = Read-Host "Enter your choice (1 or 2)"
    if ($PlacementChoice -notin @("1", "2")) {
        Write-Host "Invalid placement choice." -ForegroundColor Red
        Pause
        Exit
    }

    # Get files
    $Files = Get-ChildItem -Path $DirectoryPath -File
    if (-Not $Files) {
        Write-Host "No files found in the directory." -ForegroundColor Red
        Pause
        Exit
    }

    # Process files
    $Index = 1
    Write-Host "Found $($Files.Count) files in the directory."
    foreach ($File in $Files) {
        try {
            Write-Host "Processing file: $($File.Name)"

            # Ensure file extension
            $FileExtension = if ($File.Extension) { $File.Extension } else { "" }
            Write-Host "File extension: $FileExtension"

            # Construct new filename
            $NewFileName = if ($PlacementChoice -eq "1") {
                "$BaseFileName-$Index$FileExtension"
            } else {
                "$Index-$BaseFileName$FileExtension"
            }
            $NewFileName = [string]$NewFileName
            Write-Host "New file name: $NewFileName"

            # Validate new path
            $NewFilePath = Join-Path -Path $DirectoryPath -ChildPath $NewFileName
            Write-Host "New file path: $NewFilePath"

            if ([string]::IsNullOrWhiteSpace($NewFilePath)) {
                Write-Host "Error: Generated file path is empty or invalid for $($File.FullName)" -ForegroundColor Red
                Continue
            }

            # Rename file
            Rename-Item -Path $File.FullName -NewName $NewFilePath
            Write-Host "File renamed to: $NewFileName" -ForegroundColor Green

            # Increment index
            $Index++

        } catch {
            Write-Host "Error renaming file '$($File.FullName)' to '$NewFilePath'" -ForegroundColor Red
            Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Yellow
            Pause
            Continue
        }
    }

    Write-Host "All files renamed successfully."
    Write-Host "Press Enter to exit."
    Read-Host

} catch {
    Write-Host "Unexpected error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Press Enter to exit."
    Read-Host
}
