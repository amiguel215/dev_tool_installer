Write-Output "-----------------------------------------------------------------------------------------------------------"
Write-Output "Check Administrator Permissions"
Write-Output ""
Function CheckAdmin()
{
  #Get current user context
  $CurrentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  #Check user is running the script is member of Administrator Group
  if($CurrentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))
  {
       Write-host "Script is running as admin"
  }
  else
    {
       #Create a new Elevated process to Start PowerShell
       $ElevatedProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
       # Specify the current script path and name as a parameter
       $ElevatedProcess.Arguments = "& '" + $script:MyInvocation.MyCommand.Path + "'"
       #Set the Process to elevated
       $ElevatedProcess.Verb = "runas"
       #Start the new elevated process
       [System.Diagnostics.Process]::Start($ElevatedProcess)
       #Exit from the current, unelevated, process
       Exit
 
    }
} 
#Check Script is running with Elevated Privileges
CheckAdmin

#Check current execution policy
$policy = Get-ExecutionPolicy

# if the current policy is "Restricted", change to "RemoteSigned"
if ($policy -eq "Restricted") {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "Execution policy has been changed to RemoteSigned"
} else {
    Write-Host "The current execution policy is $policy"
}

# Install Chocolately 
Write-Output "-----------------------------------------------------------------------------------------------------------"
Write-Output "Installing Chocolately"
Write-Output ""
if (!(Test-Path -Path 'C:\ProgramData\chocolatey\choco.exe')) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
        Write-Output "Chocolately is already installed"
    }
}

# Install PowerShell Core
Write-Output "-----------------------------------------------------------------------------------------------------------"
Write-Output "Installing PowerShell Core"
Write-Output ""
if (!(Get-Command pwsh -ErrorAction SilentlyContinue)){
    choco install powershell-core -y
} else {
    Write-Output "PowerShell Core is already installed"
    Get-Command pwsh
}


# Check the current instance 'PowerShell Core'
Write-Output "-----------------------------------------------------------------------------------------------------------"
Write-Output "Check the current instance 'PowerShell Core'"
Write-Output ""
Start-Process -Wait -FilePath "pwsh.exe" -ArgumentList "-Command", "Get-Host"


# Install Git
Write-Output "-----------------------------------------------------------------------------------------------------------"
Write-Output "Installing Git"
Write-Output ""
if (!(Get-Command git -ErrorAction SilentlyContinue)){
    choco install git -y
} else {
    Write-Output "Git is already installed"
    Get-Command git
}
Write-Output ""
Write-Output "User Name"
if ((Get-Content -Path $HOME\.gitconfig -ErrorAction SilentlyContinue | Select-String -Pattern 'name')){

    # Get the current value of the user.name configuration setting
    $currentUserName = git config --global user.name

    # Prompt the user for the new value of the user.name configuration setting
    $newUserName = Read-Host "Enter the new value for the user.name configuration setting"

    # Set the new value for the user.name configuration setting
    git config --global user.name $newUserName

    # Display a message confirming the update
    Write-Host "The value of the user.name configuration setting has been updated from '$currentUserName' to '$newUserName'"
} 

Write-Output ""
Write-Output "Email"
if ((Get-Content -Path $HOME\.gitconfig -ErrorAction SilentlyContinue | Select-String -Pattern 'email')){

    # Get the current value of the user.email configuration setting
    $currentUserEmail = git config --global user.email

    # Prompt the user for the new value of the user.email configuration setting
    $newUserEmail = Read-Host "Enter the new value for the user.email configuration setting"

    # Set the new value for the user.email configuration setting
    git config --global user.email $newUserEmail

    # Display a message confirming the update
    Write-Host "The value of the user.email configuration setting has been updated from '$currentUserEmail' to '$newUserEmail'"
} 
Write-Output ""
Write-Host "The current configuration is: '$newUserName' - '$newUserEmail'"

# Install Visual Studio code
Write-Output "-----------------------------------------------------------------------------------------------------------"
Write-Output "Installing VS Code"
Write-Output ""
if (!(Get-Command code -ErrorAction SilentlyContinue)){
    choco install vscode -y
} else {
    Write-Output "Visual Studio Code is already installed"
    Get-Command code
}

Write-Output "Installing Extensions"
$extensions = @(
    'ms-vscode.azure-account',
    'ms-azure-devops.azure-pipelines',
    'ms-vscode.azurecli',
    'ms-vscode.azure-terraform',
    'ms-vscode.powershell',
    'ms-azuretools.vscode-azure-resource-manager',
    'ms-azuretools.vscode-bicep'
)

foreach ($extension in $extensions) {
    if (!(Get-ChildItem -Path $env:USERPROFILE\.vscode\extensions -Recurse -Directory | Where-Object {$_.Name -eq $extension})) {
        code --install-extension $extension
    }
}

# Install Azure Az PowerShell Module
Write-Output "-----------------------------------------------------------------------------------------------------------"
Write-Output "Installing Azure Az PowerShell Module"
Write-Output ""
if (!(Get-InstalledModule az -ErrorAction SilentlyContinue)){
    Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
} else {
    Write-Output "Azure Az PowerShell Module is already installed"
    Get-InstalledModule -Name Az
}

# Install Bicep
Write-Output "-----------------------------------------------------------------------------------------------------------"
Write-Output "Installing Bicep"
Write-Output ""
if (!(Get-Command bicep -ErrorAction SilentlyContinue)){
    choco install bicep -Force -y
} else {
    Write-Output "Bicep is already installed"
    Get-Command bicep
}

Write-Output "-----------------------------------------------------------------------------------------------------------"
Write-Output ""
Write-Output "Dev Tools installer completed"
Write-Host "Press any key to exit"
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')