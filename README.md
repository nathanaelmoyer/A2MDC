# A2MDC
Powershell script to install custom applications and apply police specific settings.

# Installation
Included folder structure on most recent github release is neccessary for script functionality.
- All install files can be found on internal network share:
>\\\city.a2\shared\SourceData\Misc\PD\CLEMIS\MDC image\A2_PowerShell

>Folder structer must be set up as follows:
>![image](https://github.com/nathanaelmoyer/A2MDC/assets/36149055/151748d8-fbe9-4412-a854-040a7e58eb77)

# Running
1. With the CLEMIS Imaging USB stick still inserted, open it in Windows Explorer; it should be drive D:\ 

2. Go to the A2_Powershell folder 

3. Right-click the A2_MDC_Automation.ps1 script and choose to Run with PowerShell 
> User must have administrative rights

4. Enter “1” to install/update everything below 
![image](https://github.com/nathanaelmoyer/A2MDC/assets/36149055/62b81a67-489d-4156-a15b-531cf5cc705b)

This script will install the following: 

>CLEMIS: McAfee, BigFix, ieSpell, NetMotion, Easy Street Draw (+ Activate) 

>A2: Talon MDC, Google Chrome Enterprise, ONLYOFFICE Editors, Axon Fleet Dashboard, Win10 Default App Associations for MS Office files to open in ONLYOFFICE, Activate Windows 

>Update the BIOS to the latest version we’ve downloaded 

This script will also set several settings for all users: 

1. Enable Webcam & Microphone Access/Functionality (Windows Privacy Settings – so officers can use MS Teams/Zoom from the vehicle within Chrome) 

2. Enable the ‘Show Menu toolbar’ in Internet Explorer (so officers can easily access the IESpell plugin) 

3. Set default MS Office File Associations to open in ONLYOFFICE 

4. Disable Airplane Mode and Tablet Mode 

5. Disable the Dock Audio Device (via Scheduled Task) – the dock will sometimes grab default audio device and this prevents that from happening. 

6. Set the Dock Ethernet adapter to static 192.168.0.2 for Axon/CLEMIS GPS compatibility (via Scheduled Task) 

The MDC will automatically reboot when the script is complete. Once the MDC reloads, log in as the agyadm user. This username should be an option at the bottom left corner 
