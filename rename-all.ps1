
# RenameAll.ps1
# Author: Matt Dean
# Contact: matt@mattdean.tech
# Version: 1.0.0
# Created: 11/12/24
# Description: 
# Script to rename all files in a directory 
# based on a user-specified base name 
# and appends or prepends a sequential index.


# Temporarily bypass PowerShell execution policy if required
# (For script to run without permanent policy changes)
# "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass"

# Turn policy back on (IMPORTANT) - 
# "Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Restricted"



# -- Script Start -- #

# Function to select a folder using a graphical dialog
function Select-FolderDialog {
    # Load Windows Forms for GUI dialog
    Add-Type -AssemblyName System.Windows.Forms
    
    # Create folder browser dialog
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $DialogResult = $FolderBrowser.ShowDialog()

    # Return selected folder path or exit if cancelled
    if ($DialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
        return $FolderBrowser.SelectedPath
    } else {
        Write-Host "No folder selected. Exiting script." -ForegroundColor Red
        Pause
        Exit
    }
}

try {
    # Prompt user to select a directory
    Write-Host "Please select the directory containing your files:"
    $DirectoryPath = Select-FolderDialog

    # Check if the selected directory exists
    if (-Not (Test-Path -Path $DirectoryPath)) {
        Write-Host "Error: Directory does not exist." -ForegroundColor Red
        Pause
        Exit
    }

    # Prompt user for base filename and index placement
    $BaseFileName = Read-Host "Enter the base filename (e.g. 'my-file')"
    Write-Host "Choose where to place the sequential index:"
    Write-Host "1. Append (e.g., my-file-1)"
    Write-Host "2. Prepend (e.g., 1-my-file)"
    $PlacementChoice = Read-Host "Enter your choice (1 or 2)"

    # Validate the placement choice input
    if ($PlacementChoice -notin @("1", "2")) {
        Write-Host "Invalid placement choice." -ForegroundColor Red
        Pause
        Exit
    }

    # Retrieve all files in the selected directory
    $Files = Get-ChildItem -Path $DirectoryPath -File
    
    # Exit if no files are found
    if (-Not $Files) {
        Write-Host "No files found in the directory." -ForegroundColor Red
        Pause
        Exit
    }

    # Initialize the sequential index for renaming
    $Index = 1
    Write-Host "Found $($Files.Count) files in the directory."

    # Loop through each file and rename it
    foreach ($File in $Files) {
        try {
            Write-Host "Processing file: $($File.Name)"

            # Ensure file extension is included
            $FileExtension = if ($File.Extension) { $File.Extension } else { "" }
            Write-Host "File extension: $FileExtension"

            # Generate the new file name based on user input
            $NewFileName = if ($PlacementChoice -eq "1") {
                "$BaseFileName-$Index$FileExtension"
            } else {
                "$Index-$BaseFileName$FileExtension"
            }
            $NewFileName = [string]$NewFileName
            Write-Host "New file name: $NewFileName"

           # Build the full path for the new file name
            $NewFilePath = Join-Path -Path $DirectoryPath -ChildPath $NewFileName
            Write-Host "New file path: $NewFilePath"

            # Validate that the new file path is not empty or invalid
            if ([string]::IsNullOrWhiteSpace($NewFilePath)) {
                Write-Host "Error: Generated file path is empty or invalid for $($File.FullName)" -ForegroundColor Red
                Continue
            }

            # Rename the current file to the new file name
            Rename-Item -Path $File.FullName -NewName $NewFilePath
            Write-Host "File renamed to: $NewFileName" -ForegroundColor Green

            # Increment the sequential index
            $Index++

        } catch {
            # Handle errors during the renaming process
            Write-Host "Error renaming file '$($File.FullName)' to '$NewFilePath'" -ForegroundColor Red
            Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Yellow
            Pause
            Continue
        }
    }

    # Notify the user that all files were successfully renamed
    Write-Host "All files renamed successfully."
    Write-Host "Press Enter to exit."
    Read-Host

} catch {
    # Handle unexpected script errors
    Write-Host "Unexpected error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Press Enter to exit."
    Read-Host
}

# -- Script End -- #