# dev_tools_installer

This powerShell script will allow you to install the necessary tools and extensions to start bootcamp, as Chocolately package manager, PowerShell Core terminal, VS Code (and its extensions), Bicep, Azure Power Shell module, and Git (with user settings).

## Instructions:
1. Clone the repository or directly download the script file (".ps1" extension)
2. located the file in your preferred folder, open your favorite terminal and navigate into the file location
3. Run the script as follow:  .\dev_tools_installer.ps1

## Additional notes:
* You will not need to run the terminal as administrator, the script will be executed with "elevated" privileges
* The Script will automatically change the execution policy "Set-ExecutionPolicy RemoteSigned"
* The script will validate if any of the tools is installed or outdated (with its respective path)
