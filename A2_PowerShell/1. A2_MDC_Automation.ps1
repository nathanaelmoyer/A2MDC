<#
Ann Arbor PD MDC Post-Image Automation Script
Author: Jonathan Bougher
Creation Date: 5/6/21
Modified by: Nathan Moyer
Modified Date: 05.12.23 #>
$script:Version = '05.12.23'
<#Latest Comments:
    - Added Windows Activation Function - 8.25.21
    - Removed Axon View XL installer - 5.3.23
    - Added Axon Fleet Dashboard Installer - 5.3.23
    - Disabled IESpell installer - 5.3.23
    - Updated Chrome MSI installer - 5.3.23
    - Added Remote Utilities insaller - 5.4.23
    - Added AAPD MDC Maps installer - 5.4.23
    - Updated Set-FileHandlerDefaults to replace Internet Explorer with Microsoft Edge - 5.4.23
    - Added Dell command update application install - 5.12.23
#>

#Check for Administrator rights and re-lauch the script as an Administrator if needed
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -WindowStyle Maximized -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

#Resize PowerShell Window to Fullscreen
$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
Add-Type -name win -member $t -namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 3) | Out-Null

#Set Script-wide variables
$script:MsgPleaseWait = ' -- Please wait ...'
$script:MsgProcessComplete = ' -- ... process complete'
$script:MsgInstConf = ' -- Already installed & configured. Skipping.'
$script:MsgInstalled = ' -- Already installed. Skipping.'
$script:MsgApplyingSettings = ' -- Applying Custom Settings'
$script:REBOOTNEEDED = $null


#Intro Visual
Write-Host '**************************************************************************************' -ForegroundColor Yellow
Write-Host '************************* Ann Arbor PD MDC Automation Script *************************' -ForegroundColor Yellow
Write-Host '**************************************************************************************' -ForegroundColor Yellow
Write-Host ' '

# ===============================================================================================================================================================================================================================
# === APP INSTALLS ==============================================================================================================================================================================================================
# ===============================================================================================================================================================================================================================

Function MsgCatchError {
            Write-Host '-------------------------------------------------------------' -BackgroundColor Red -ForegroundColor White    
            Write-Host '******************* An error has occured ********************' -BackgroundColor Red -ForegroundColor White
	        Write-Host '-------------------------------------------------------------' -BackgroundColor Red -ForegroundColor White
} 

<#
Build App Install Functions
#>

Function InternetConnectivityCheck {
    #Check for an Internet connection. This is needed for Easy Street Draw & Windows product activation later on in the script. This function prompts to plug in if
    #no Internet connection is detected
    if (!(Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet)) {     
        do {
            Write-Host '-------------------------------------------------------------                               ' -BackgroundColor Red -ForegroundColor White    
            Write-Host 'No active Internet connection. Connect the MDC to the Internet and press Enter to try again.' -BackgroundColor Red -ForegroundColor White
	        Write-Host '-------------------------------------------------------------                               ' -BackgroundColor Red -ForegroundColor White
            pause
        } Until (Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet)   
    } #End if
} #End Function



Function Install-CLEMISTrellix {
    #Set Variables
    $sourcepath = "${PSScriptRoot}\Script_Source_Files\Apps\CLEMIS_Trellix"

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Installing 1 of 13 - CLEMIS Trellix Agent (can take a while...just let it run)'
	Write-Host '-------------------------------------------------------------'
    
    #Install if not already installed
    if (!(Test-Path -Path "C:\Program Files\McAfee\Agent\")) {
        Write-Host $script:MsgPleaseWait
        Start-Process -Wait "$sourcepath\Trellix Agent 5.7.8.exe" -ArgumentList "/INSTALL=AGENT /SILENT"
        Start-Sleep -Seconds 3 # Short Delay
        Write-Host $script:MsgProcessComplete
    } else {
        Write-Host $script:MsgInstConf
    } #End if
} #End Function


Function Install-CLEMISBigFix {
    #Set Variables
    $sourcepath = "${PSScriptRoot}\Script_Source_Files\Apps\CLEMIS_BigFix"

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Installing 2 of 13 -  CLEMIS IBM BigFix Client'
	Write-Host '-------------------------------------------------------------'
    
    #Install if not already installed
    if (!(Test-Path -Path "C:\Program Files (x86)\BigFix Enterprise\BES Client\")) {
        Write-Host $script:MsgPleaseWait
        Start-Process -Wait msiexec.exe -ArgumentList "/i `"$sourcepath\BigFixAgent.msi`" /qb"
        Start-Sleep -Seconds 3 # Short Delay
        Write-Host $script:MsgProcessComplete
    } else {
        Write-Host $script:MsgInstConf
    } #End if
} #End Function


Function Install-CLEMISIESpell {
    #Set Variables
    #$sourcepath = "${PSScriptRoot}\Script_Source_Files\Apps\ieSpell\"
    #$packagepath = "C:\UTILS\IESpell"

    #Visual Feedback
    #Write-Host ' '
    #Write-Host '-------------------------------------------------------------'    
    #Write-Host 'Installing 3 of 13 -  CLEMIS IESpell Spellchecker'
	#Write-Host '-------------------------------------------------------------'

    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Skipping 3 of 13 -  CLEMIS IESpell Spellchecker'
    Write-Host 'This app install is currently disabled.'
	Write-Host '-------------------------------------------------------------'

    #if (!(Test-Path -Path "C:\Program Files (x86)\ieSpell")) {
    #    Write-Host $script:MsgPleaseWait
    #    #Create install directory, copy in Installer, install
    #    New-Item -Path "$packagepath" -ItemType Directory | Out-Null
    #    Copy-Item -Force -Recurse -Path "$sourcepath\*" -Destination "$packagepath"
    #    Start-Sleep -Seconds 3 #Short delay
    #    Start-Process -Wait "$packagepath\ieSpellSetup.exe" -ArgumentList "/S /K=$packagepath\ieSpell.lic"
    #    Start-Sleep -Seconds 3 #Short delay
    #    Write-Host $script:MsgProcessComplete
    #} else {
    #    Write-Host $script:MsgInstConf
    #} #End if
} #End Function


Function Install-CLEMISEasyStreetDraw {
    #Set Variables
    $packagepath = "C:\UTILS\Crash7"

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Installing 4 of 13 -  CLEMIS Easy Street Draw'
	Write-Host '-------------------------------------------------------------'

    #Check for an Internet connection. This is needed for product activation. Only proceed if there is an Internet connection. Also check for a file (A2EasyStreet.txt) to ensure we haven't run this before.
    if ((Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet) -and (!(Test-Path "$packagepath\A2EasyStreetInstallScriptWasRun.txt"))) {
        Write-Host $script:MsgPleaseWait
        #Uninstall the unactivated Easy Street Draw program
        Start-Process -Wait "C:\ProgramData\Package Cache\{b9002bce-d079-40a9-b88f-075804181a89}\Bootstrap.exe" -ArgumentList "/uninstall /quiet /norestart"
        Start-Sleep -Seconds 10 #Short delay
        #Install the activated Easy Street Draw program
        Start-Process -Wait "$packagepath\ESDraw_7_3_2_360.exe" -ArgumentList "/q LPW=bTDkeD74 LID=64538010 MUSTACTIVATE=TRUE"
        Copy-Item -Force -Path "$packagepath\app.ini" -Destination "C:\ProgramData\Easy Street Draw 7.3\"
        #Create a file to indicate that this piece of code has already been executed previously. This is so we don't have constant 
        #reinstalls/reactivations every time this script is subsequently run on the same PC
        New-Item -Force -ItemType File -Path "$packagepath\A2EasyStreetInstallScriptWasRun.txt" | Out-Null
        Start-Sleep -Seconds 3 #Short delay
        Write-Host $script:MsgProcessComplete
    } else {
        Write-Host $script:MsgInstConf
    } #End if
} #End Function


Function Install-A2TalonMDC {
    #Set Variables
    $sourcepath = "${PSScriptRoot}\Script_Source_Files\Apps\TalonMDC_MDC"

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Installing 5 of 13 - A2 TalonMDC Client'
    Write-Host '-------------------------------------------------------------'
    Write-Host $script:MsgPleaseWait

    #Create install directory and copy program files directly to it (there is no TalonMDC MSI install/etc)
    New-Item -Path "C:\ctccore" -ItemType Directory -ErrorAction SilentlyContinue
    #Set permsissions (may not be needed)
    Start-Process -Wait icacls -ArgumentList "`"C:\ctccore`" /grant `"NT AUTHORITY\Authenticated Users`":(OI)(CI)M /T /Q" -WindowStyle Hidden
    #Copy program files
    Start-Process -Wait robocopy -ArgumentList "`"$sourcepath\ctccore`" c:\ctccore * /E /NFL /NDL /NS /NC /NJH /NJS" -WindowStyle Hidden
    #Create Start Menu Shortcut
    Copy-Item -Force -Path "$sourcepath\TalonMDC.lnk" -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TalonMDC.lnk"
    #Create Desktop Shortcuts -- we can't use C:\Users\Public\Desktop or else two shortcuts will eventually be created. 
    #One will be shown from the Public\Desktop location and another will be duplicated on the user's actual Desktop (Users\user\Desktop) the first time TalonMDC is opened. That is a function of TalonMDC.
	    #Default User Desktop
	    Copy-Item -Force -Path "$sourcepath\TalonMDC.lnk" -Destination "C:\Users\Default\Desktop\TalonMDC.lnk"
	    #Current-User Desktop
	    Copy-Item -Force -Path "$sourcepath\TalonMDC.lnk" -Destination "$env:USERPROFILE\Desktop\TalonMDC.lnk"
        #AGYADM User Desktop (if it exists already
        if (Test-Path -Path "C:\Users\agyadm\Desktop\") {
            Copy-Item -Force -Path "$sourcepath\TalonMDC.lnk" -Destination "C:\Users\agyadm\Desktop\TalonMDC.lnk"
        } #End if
    	#AAMDC User Desktop (if it exists already)
	    if (Test-Path -Path "C:\Users\aamdc\Desktop\") {
            Copy-Item -Force -Path "$sourcepath\TalonMDC.lnk" -Destination "C:\Users\aamdc\Desktop\TalonMDC.lnk"
        } #End if
    Write-Host $script:MsgProcessComplete
} #End Function


Function Install-A2ChomeMDC {
    #Set Variables
    $sourcepath = "${PSScriptRoot}\Script_Source_Files\Apps\Chrome_MDC"

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Installing 6 of 13 - A2 Google Chrome Police MDC Implementation'
    Write-Host '-------------------------------------------------------------'

    #Install Chrome silently
    if (!(Test-Path -Path "C:\Program Files\Google\Chrome")) {
        Write-Host "$script:MsgPleaseWait"
        Start-Process -Wait msiexec.exe -ArgumentList "/i `"$sourcepath\GoogleChromeStandaloneEnterprise64.msi`" /qn"
    } else {
        Write-Host "$script:MsgInstalled (Chrome)"
    } #End if    #Install Google Legacy Browser Support silently
    if (!(Test-Path -Path "C:\Program Files\Google\Legacy Browser Support")) {
        Start-Process -Wait msiexec.exe -ArgumentList "/i `"$sourcepath\LegacyBrowserSupport_6.0.2.0_en_x64.msi`" /qn"
        Write-Host "$script:MsgProcessComplete"
    } else {
        Write-Host "$script:MsgInstalled (Chrome Legacy Browser Support)"
    } #End if
    Write-Host $script:MsgApplyingSettings
    Write-Host $script:MsgPleaseWait
    #Set important Chome policy settings in the registry
    ##Create base Registry key
    New-Item -Path "HKLM:\SOFTWARE\Policies\" -Name "Google" -Force | Out-Null

    ##Set Policies
    $regpath = New-Item -Path "HKLM:\SOFTWARE\Policies\Google" -Name "Chrome" -Force
    New-ItemProperty -Path "Registry::$regpath" -Name "BrowserSignin" -Value 0  -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "PasswordManagerEnabled" -Value 0  -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "AutofillAddressEnabled" -Value 0  -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "AutofillCreditCardEnabled" -Value 0  -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "DefaultBrowserSettingEnabled" -Value 0  -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "ShowAppsShortcutInBookmarkBar" -Value 0  -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "MetricsReportingEnabled" -Value 0  -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "ShowHomeButton" -Value 1  -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "BookmarkBarEnabled" -Value 1  -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "BrowserSwitcherEnabled" -Value 1  -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "RestoreOnStartup" -Value 5  -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "DiskCacheSize" -Value 1962934272  -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "HomepageLocation" -Value 'https://www.a2gov.org'  -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "NewTabPageLocation" -Value 'https://www.a2gov.org'  -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "AlternativeBrowserPath" -Value '${ie}'  -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "ManagedBookmarks" -Value '[{"toplevel_name":"AAPD MDC Bookmarks"},{"url":"https://annarborpd.evidence.com/index.aspx?class=UIX&proc=Login","name":"EVIDENCE.COM"},{"url":"https://telestaffpd.a2gov.org/","name":"Telestaff"},{"url":"https://www.mdepeaceq3.com/AnnArborMIPtrl/peACEq/login.cfm","name":"ADORE"},{"url":"https://powerdms.com/ui/login.aspx?siteID=a2gov&formsauth=true","name":"PowerDMS"},{"url":"https://library.municode.com/mi/ann_arbor/codes/code_of_ordinances","name":"Municode AA Ordinances"},{"url":"https://cityofannarbor.inclassnow.com/","name":"LMS/SafetySkills"},{"url":"https://www.office.com/login","name":"Microsoft Office 365"},{"url":"https://www.carfaxforpolice.com/","name":"CARFAX for Police"},{"url":"https://www.leadsonline.com/main/leadsonline/login/login.php","name":"LeadsOnline-Pawn"}]'  -PropertyType String -Force | Out-Null
    
    $regpath = New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "BrowserSwitcherUrlGreylist" -Force
    New-ItemProperty -Path "Registry::$regpath" -Name "1" -Value '*'  -PropertyType String -Force | Out-Null

    $regpath = New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "BrowserSwitcherUrlList" -Force
    New-ItemProperty -Path "Registry::$regpath" -Name "1" -Value 'apps2.clemis.org'  -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "2" -Value 'appst.clemis.org'  -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "3" -Value 'boe4.oakgov.com'  -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "4" -Value 'apps.clemis.org'  -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "5" -Value 'cvdb.clemis.org'  -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "6" -Value 'qaboe4.oakgov.com'  -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "7" -Value 'capfis.oakgov.com'  -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "8" -Value '172.16.160.107'  -PropertyType String -Force | Out-Null
    
    $regpath = New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "PopupsAllowedForUrls" -Force
    New-ItemProperty -Path "Registry::$regpath" -Name "1" -Value 'https://e24.ultipro.com'  -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "Registry::$regpath" -Name "2" -Value 'training.knowbe4.com'  -PropertyType String -Force | Out-Null
    
    $regpath = New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "RestoreOnStartupURLs" -Force
    New-ItemProperty -Path "Registry::$regpath" -Name "1" -Value 'https://www.a2gov.org'  -PropertyType String -Force | Out-Null

    ##Pre-approve/enable the Google Legacy Browser IE Addon (so no annoying 'do you want to enable this add-on' message appears
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext" -Name "CLSID" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Policies\Ext" -Name "CLSID" -Force | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID" -Name "{08B5789A-BD8E-4DAE-85DF-EF792C658B86}" -Value 1  -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID" -Name "{08B5789A-BD8E-4DAE-85DF-EF792C658B86}" -Value 1  -PropertyType String -Force | Out-Null

    ##Update Group Policy to apply registry settings [note - not all policies will be active until the PC joins a domain -- see https://stackoverflow.com/questions/57352094/why-is-chromium-blocking-defaultsearchproviderenabled-group-policy for more info
    Start-Process gpupdate -ArgumentList "/target:computer /force" -WindowStyle Hidden
    Write-Host $script:MsgProcessComplete
} #End Function


Function Install-A2OnlyOffice {
    #Set Variables
    $sourcepath = "${PSScriptRoot}\Script_Source_Files\Apps\OnlyOffice_MDC"

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Installing 7 of 13 - A2 ONLYOFFICE Editors (MS Office File Editors)'
    Write-Host '-------------------------------------------------------------'

    #Install OnlyOffice silently (if not already installed)
    if (!(Test-Path -Path "C:\Program Files\ONLYOFFICE\DesktopEditors\DesktopEditors.exe")) {
        Write-Host $script:MsgPleaseWait
        #Can use the /VERYSILENT switch below instead of /SILENT if you don't want to see anything while this is installing
        Start-Process -Wait "$sourcepath\DesktopEditors_x64.exe" -ArgumentList "/SP- /SILENT /SUPPRESSMSGBOXES /ALLUSERS /LOG /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LANG=en /TASKS=`"desktopicon`""
        Start-Sleep -Seconds 3 #Short delay
        Write-Host $script:MsgProcessComplete
    } else {
        Write-Host $script:MsgInstalled
    } #End if
    Write-Host $script:MsgApplyingSettings
    Write-Host $script:MsgPleaseWait
    #Turn off auto-updates
    $regpath = "HKCU:\Software\ONLYOFFICE\DesktopEditors"
    New-ItemProperty -Path "$regpath" -Name "CheckForUpdates" -Value 0  -PropertyType String -Force | Out-Null
    $regpath = "HKLM:\Software\ONLYOFFICE\DesktopEditors"
    New-ItemProperty -Path "$regpath" -Name "CheckForUpdates" -Value 0  -PropertyType String -Force | Out-Null

    #Turn off intial 'create an account' welcome message on first-launch
    #Copying in this folder structure and the one 000003.log file causes OnlyOffice to suppress the first time 'create a cloud account' welcome screen. I like turning that welcome screen off to avoid any user confusion.
    Copy-Item -Force -Recurse -Path "$sourcepath\ONLYOFFICE" -Destination "$env:localappdata"
    Copy-Item -Force -Recurse -Path "$sourcepath\ONLYOFFICE" -Destination "C:\Users\Default\AppData\Local\"
    if (Test-Path -Path C:\Users\aamdc\AppData\Local\) {
        Copy-Item -Force -Recurse -Path "$sourcepath\ONLYOFFICE\" -Destination "C:\Users\aamdc\AppData\Local\"
    } #End if
    if (Test-Path -Path C:\Users\agyadm\AppData\Local\) {
        Copy-Item -Force -Recurse -Path "$sourcepath\ONLYOFFICE\" -Destination "C:\Users\agyadm\AppData\Local\"
    } #End if

    #More command-line ONLYOFFICE install help:
    #https://jrsoftware.org/ishelp/index.php?topic=setupcmdline
    #https://help.pdq.com/hc/en-us/community/posts/360056275692-ONLYOFFICE-Desktop-Editors
    Write-Host $script:MsgProcessComplete

} #End Function


Function Install-A2Axon {
    #Set Variables
    $sourcepath = "$PSScriptRoot\Script_Source_Files\Apps\Axon_MDC"
    $RandNum = Get-Random

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Installing 8 of 13 - A2 Axon Fleet Dashboard'
    Write-Host '-------------------------------------------------------------'

    #Install Axon Fleet Dashboard silently
    if (!(Test-Path -Path "C:\Program Files (x86)\Axon Fleet Dashboard")) {
        Write-Host $script:MsgPleaseWait
        #Start-Process -Wait "$sourcepath\axon-fleet-1.15.5.exe" -ArgumentList "/install /passive /log `"$sourcepath\Logs\$RandNum.txt`""
        Start-Process -Wait msiexec.exe -ArgumentList "/i `"$sourcepath\Axon_Dashboard_1.2.3529.msi`" /q /norestart"
        Start-Sleep -Seconds 3 #Brief delay
        Write-Host $script:MsgProcessComplete
    } else {
        Write-Host $script:MsgInstConf
    } #End if
} #End Function


Function Install-CLEMIS_SecureAccess {
    #Set Variables
    $sourcepath = "$PSScriptRoot\Script_Source_Files\Apps\CLEMIS_SecureAccess"

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Installing 9 of 13 - CLEMIS Secure Access Client'
    Write-Host '-------------------------------------------------------------'

    if (!(Test-Path -Path "C:\Program Files\Secure Access Client\nomtray.exe")) {
        Write-Host $script:MsgPleaseWait
        #Install the MSI
        #Start-Process -Wait "$sourcepath\SecureAccess_client_12.72_x64_release.exe" -ArgumentList " NM_ADDRESS_VALUE=clmnm1.clemis.org /SILENT"
        Start-Process -Wait msiexec.exe -ArgumentList "/norestart /i `"$sourcepath\SecureAccess_client_12.72_x64_release.msi`" NM_ADDRESS_VALUE=clmnm1.clemis.org /qn"
        $script:REBOOTNEEDED = "YES"  #Set script-wide REBOOTNEEDED variable/flag [will hold value outside of the function]
        Start-Sleep -Seconds 5 #Short delay
        Write-Host $script:MsgProcessComplete
    } else {
        Write-Host $script:MsgInstConf
    } #End if
} #End Function

Function Install-AAPD_MDC_maps {
    #Set Variables
    $sourcepath = "$PSScriptRoot\Script_Source_Files\Apps\AAPD_MDC_maps"

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Installing 10 of 13 - AAPD_MDC_maps'
    Write-Host '-------------------------------------------------------------'

    if (!(Test-Path -Path "C:\Users\Public\Desktop\AAPS MDC Maps\AAPS School  Maps")) {
        Write-Host $script:MsgPleaseWait
        #Run the install.bat
        Start-Process -Wait "$sourcepath\install.bat"
        Start-Sleep -Seconds 5 #Short delay
        Write-Host $script:MsgProcessComplete
    } else {
        Write-Host $script:MsgInstConf
    } #End if
} #End Function

Function Install-RemoteUtilities {
    #Set Variables
    $sourcepath = "$PSScriptRoot\Script_Source_Files\Apps\RemoteUtilities"

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Installing 11 of 13 - Remote Utilities Host'
    Write-Host '-------------------------------------------------------------'

    if (!(Test-Path -Path "C:\Program Files (x86)\Remote Utilities - Host")) {
        Write-Host $script:MsgPleaseWait
        #Install the MSI
        Start-Process -Wait msiexec.exe -ArgumentList "/i `"$sourcepath\host-7.1.7.0_preconfigured.msi`" /qn"
        Start-Sleep -Seconds 5 #Short delay
        Write-Host $script:MsgProcessComplete
    } else {
        Write-Host $script:MsgInstConf
    } #End if
} #End Function

Function Install-DellSupportAssist {
    #Set Variables
    $sourcepath = "$PSScriptRoot\Script_Source_Files\Apps\DellSupportAssist"

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Installing 12 of 13 - Dell Support Assist'
    Write-Host '-------------------------------------------------------------'

    if (!(Test-Path -Path "C:\Program Files\Dell\SupportAssistAgent")) {
        Write-Host $script:MsgPleaseWait
        #Install the MSI
        Start-Process -Wait "$sourcepath\SupportAssistLauncher.exe" -ArgumentList "-s -v/qn"
        Start-Sleep -Seconds 5 #Short delay
        Write-Host $script:MsgProcessComplete
    } else {
        Write-Host $script:MsgInstConf
    } #End if
} #End Function

Function Install-DellCommandUpdate {
    #Set Variables
    $sourcepath = "$PSScriptRoot\Script_Source_Files\Apps\DellCommandUpdate"
    $RandNum = Get-Random

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Installing 13 of 13 - Dell Command Update'
    Write-Host '-------------------------------------------------------------'

    #Install Dell Command Update silently
    if (!(Test-Path -Path "C:\Program Files (x86)\Dell\CommandUpdate")) {
        Write-Host $script:MsgPleaseWait
        Start-Process -Wait msiexec.exe -ArgumentList "/i `"$sourcepath\DellCommandUpdate.msi`" /q /norestart"
        Start-Sleep -Seconds 3 #Brief delay
        Write-Host $script:MsgProcessComplete
    } else {
        Write-Host $script:MsgInstConf
    } #End if
} #End Function

# ===============================================================================================================================================================================================================================
# === SETTINGS ==================================================================================================================================================================================================================
# ===============================================================================================================================================================================================================================

<#
Build Settings Functions
#>
Function Set-FileHandlerDefaults {
    #Set Variables
    $sourcepath = "${PSScriptRoot}\Script_Source_Files\Settings\DefaultAppSettings"
    $XMLfolder = "C:\UTILS\Win10"

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Applying Settings 1 of 5 - A2 Default App Associations (MS Office files to open in ONLYOFFICE)'
    Write-Host '-------------------------------------------------------------'
    Write-Host $script:MsgPleaseWait

    #Backup Original CLEMIS Default App Associations file
    if (!(Test-Path -Path "$XMLfolder\CLEMISDefaultAppTypes-CLEMIS_ORIGINAL.xml")) {
        Rename-Item -Path "$XMLfolder\CLEMISDefaultAppTypes.xml" -NewName "CLEMISDefaultAppTypes-CLEMIS_ORIGINAL.xml"
    } #End if

    #Copy A2-Modified Default App Associations file in its place
    #Makes ONLYOFFICE the default for MS Office files
    Copy-Item -Force -Path "$sourcepath\CLEMISDefaultAppTypes.xml" -Destination "$XMLfolder"

    #Existing CLEMIS Group Policy Controls will enforce these defaults
    #See within local Group Policy: "Computer Configuration\Administrative Templates\Windows Components\File Explorer\Set a default associations configuration file"
    Write-Host $script:MsgProcessComplete
} #End Function


Function Set-CustomRegistryChanges {
    <# A2 MDC Custom Registry Changes
    i.	Enable Webcam & Microphone Access/Functionality (Windows Privacy Settings so officers can use MS Teams/Zoom from the vehicle within Chrome)
    ii.	Enable the 'Show Menu toolbar' in Internet Explorer (so officers can easily access the IESpell plugin) ***(IESpell is no longer installed as of 5.4.23)***
    iii. Set default MS Office File Associations to open in ONLYOFFICE 
    iv. Disable Tablet Mode #>

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Applying Settings 2 of 5 - A2 Custom Registry Changes'
    Write-Host '-------------------------------------------------------------'
    Write-Host $script:MsgPleaseWait

    #Build an array of users to apply the custom registry settings to
    $MDCusers = [System.Collections.ArrayList]@()
    ##Default User (we KNOW this is there)
    $MDCusers.Add("Default") | Out-Null
    ##Check if aamdc user's profile has already been created or not. If it's there, load that user's reg hive and apply settings
    if (Test-Path -Path C:\Users\aamdc\ntuser.dat) {
        $MDCusers.Add("aamdc") | Out-Null
    } #End if
    <#Check if the user running the script is agyadm. If not, test if the reg hive is present on the machine. 
    If it's there, load it and apply settings. If agyadmin is running the script, that is OK as well; 
    Those changes will be imported into HKCU further down in the code#>
    if ($env:username -notmatch "agyadm") {
        if (Test-Path -Path C:\Users\agyadm\ntuser.dat) {
        $MDCusers.Add("agyadm") | Out-Null
        } #End if
    } #End if

    Function ApplyRegSettings {
        param (
            $ConsentStore,
            $RegRoot
        )
        #Allow microphone access
        New-ItemProperty -Path "$ConsentStore\microphone" -Name "Value" -Value 'Allow' -PropertyType String -Force | Out-Null
        New-Item -Path "$ConsentStore\microphone" -Name "NonPackaged" -Force | Out-Null
        New-Item -Path "$ConsentStore\microphone" -Name "Microsoft.Win32WebViewHost_cw5n1h2txyewy" -Force | Out-Null
        New-Item -Path "$ConsentStore\microphone" -Name "Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -Force | Out-Null
        New-Item -Path "$ConsentStore\microphone" -Name "Windows.Photos_8wekyb3d8bbwe" -Force | Out-Null
        New-ItemProperty -Path "$ConsentStore\microphone\NonPackaged" -Name "Value" -Value 'Allow' -PropertyType String -Force | Out-Null
        New-ItemProperty -Path "$ConsentStore\microphone\Microsoft.Win32WebViewHost_cw5n1h2txyewy" -Name "Value" -Value 'Allow' -PropertyType String -Force | Out-Null
        New-ItemProperty -Path "$ConsentStore\microphone\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -Name "Value" -Value 'Allow' -PropertyType String -Force | Out-Null
        New-ItemProperty -Path "$ConsentStore\microphone\Windows.Photos_8wekyb3d8bbwe" -Name "Value" -Value 'Allow' -PropertyType String -Force | Out-Null

        #Allow webcam access
        New-ItemProperty -Path "$ConsentStore\webcam" -Name "Value" -Value 'Allow'  -PropertyType String -Force | Out-Null
        New-Item -Path "$ConsentStore\webcam" -Name "NonPackaged" -Force | Out-Null
        New-Item -Path "$ConsentStore\webcam" -Name "Microsoft.Win32WebViewHost_cw5n1h2txyewy" -Force | Out-Null
        New-Item -Path "$ConsentStore\webcam" -Name "Microsoft.Windows.Photos_8wekyb3d8bbwe" -Force | Out-Null
        New-Item -Path "$ConsentStore\webcam" -Name "Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -Force | Out-Null
        New-ItemProperty -Path "$ConsentStore\webcam\NonPackaged" -Name "Value" -Value 'Allow' -PropertyType String -Force | Out-Null
        New-ItemProperty -Path "$ConsentStore\webcam\Microsoft.Win32WebViewHost_cw5n1h2txyewy" -Name "Value" -Value 'Allow' -PropertyType String -Force | Out-Null
        New-ItemProperty -Path "$ConsentStore\webcam\Microsoft.Windows.Photos_8wekyb3d8bbwe" -Name "Value" -Value 'Allow' -PropertyType String -Force | Out-Null
        New-ItemProperty -Path "$ConsentStore\webcam\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -Name "Value" -Value 'Allow' -PropertyType String -Force | Out-Null
         
        #Disable Tablet Mode
        if (!(Test-Path -Path "$RegRoot\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell")) {
            New-Item -Path "$RegRoot\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ImmersiveShell" | Out-Null
        } #End if
        New-ItemProperty -Path "$RegRoot\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "TabletMode"  -Value 0 -Force | Out-Null #this will only currently disable tablet mode before the next switch prompt
        New-ItemProperty -Path "$RegRoot\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "TabletMode"  -Value 0 -Force | Out-Null #this will only currently disable tablet mode before the next switch prompt
        New-ItemProperty -Path "$RegRoot\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "SignInMode"  -Value 1 -Force | Out-Null #this will enable Desktop mode on Signin
        New-ItemProperty -Path "$RegRoot\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "ConvertibleSlateModePromptPreference"  -Value 0 -Force | Out-Null #this will prevent prompts and will preserve desktop mode

        #No ONLYOFFICE Update-checks
        New-Item -Path "$RegRoot\Software\ONLYOFFICE\" -Name "DesktopEditors" -Force | Out-Null
        New-ItemProperty -Path "$RegRoot\Software\ONLYOFFICE\DesktopEditors" -Name "CheckForUpdates" -Value 0  -PropertyType String -Force | Out-Null
        
        #Always show IE Menu Toolbar
        New-Item -Path "$RegRoot\Software\Microsoft\Internet Explorer\" -Name "MINIE" -Force | Out-Null
        New-ItemProperty -Path "$RegRoot\Software\Microsoft\Internet Explorer\MINIE" -Name "AlwaysShowMenus" -Value 1  -PropertyType DWORD -Force | Out-Null
    } #End Function

    #Apply Settings to the Default profile + MDC user profiles present on the system
    foreach ($user in $MDCusers) {
        Start-Process -Wait reg -ArgumentList "load HKU\TempSpace C:\users\$user\ntuser.dat" -WindowStyle Hidden
        New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS | Out-Null
        ApplyRegSettings -RegRoot "HKU:\TempSpace" -ConsentStore "HKU:\TempSpace\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore"
        Remove-PSDrive -Name HKU
        [gc]::collect() #needed here to solve reg unload issues - see https://social.technet.microsoft.com/Forums/en-US/78efe17d-1faa-4da1-a0e2-3387493a1e97/powershell-loading-unloading-and-reading-hku  AND  https://jrich523.wordpress.com/2012/03/06/powershell-loading-and-unloading-registry-hives/
        Start-Process -Wait reg -ArgumentList "unload HKU\TempSpace" -WindowStyle Hidden
    }

    #Apply Settings to Current User
    ApplyRegSettings -RegRoot "HKCU:\" -ConsentStore "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore"
    Write-Host $script:MsgProcessComplete
} #End Function


Function Set-OtherCustomSettings {
    <# A2 MDC Other Custom Settings - Other settings that are helpful on the MDCs#>

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Applying Settings 3 of 5 - A2 Other Custom Settings'
    Write-Host '-------------------------------------------------------------'
    Write-Host $script:MsgPleaseWait

    #Disable Airplane Mode
    $RmSvcStartup = (Get-Service -Name RmSvc).StartType
    if ($RmSvcStartup -notmatch "Disabled") {
        Set-Service -Name RmSvc -StartupType Disabled
        $script:REBOOTNEEDED = "YES"  #Set script-wide REBOOTNEEDED variable/flag [will hold value outside of the function]
    } #End if
    Write-Host $script:MsgProcessComplete
} #End Function


Function Set-ScheduledTaskScript {
    <# A2 MDC Scheduled Task setup to run script that sets USB Ethernet Adapter to 192.168.0.2 staticly + disables USB Dock Audio. This task & associated script runs on both startup and logon to be sure to 
    set these settings when the laptop is booted in a veh. This is probably only needed initially, but will run on each boot/logon. This was the only way I could think to pre-set these settings when the laptop 
    is imaged and configured at a desk and then later put inside a vehicle. These settings being in a scheduled task will ensure they happen when the laptop is later put in a vehicle.#>
    
    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Applying Settings 4 of 5 - A2 Scheduled Task Creation: Static IP Address and Dock Audio disable'
    Write-Host '-------------------------------------------------------------'
    Write-Host $script:MsgPleaseWait
    Write-Host ' -- Creating Scheduled Task to set static IP on dock Ethernet to 192.168.0.2 & disable dock audio device ...'

    #Set Variables
    $ScriptDir = "C:\ProgramData\A2\"
    $ScriptFile = "C:\ProgramData\A2\A2MDCScheduledTaskAction.ps1"
    $TaskAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-ExecutionPolicy Bypass -NonInteractive -NoLogo -NoProfile -File $ScriptFile" # https://www.thewindowsclub.com/what-is-pwsh-exe-list-of-pwsh-syntax-you-can-use
    $TaskTrigger1 = New-ScheduledTaskTrigger -AtStartup # https://technet.microsoft.com/itpro/powershell/windows/scheduledtasks/new-scheduledtasktrigger
    $TaskTrigger2 = New-ScheduledTaskTrigger -AtLogon # https://technet.microsoft.com/itpro/powershell/windows/scheduledtasks/new-scheduledtasktrigger
    $TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -Compatibility Win8
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId 'NT AUTHORITY\SYSTEM' -RunLevel Highest -LogonType ServiceAccount
    $TaskName = "A2 MDC Scheduled Startup Task"
    $Task = New-ScheduledTask -Action $TaskAction -Trigger $TaskTrigger1,$TaskTrigger2 -Settings $TaskSettings -Principal $TaskPrincipal
    #Create the actual script inside the below variable - this script sets static IP to 192.168.0.2 and disables the MDC dock audio components
$ScriptContent = @'
#Retrieve the Dock network adapter & set static IP details needed for Axon/CLEMIS interaction
$adapter = Get-NetAdapter -InterfaceDescription "Realtek USB*"
if ($adapter) {
    $IP = "192.168.0.2"
    $MaskBits = 24 #This means subnet mask = 255.255.255.0
    $Gateway = "192.168.0.1"
    $DNS = "192.168.0.1"
    $IPType = "IPv4"
    #Remove any existing IP, gateway from our ipv4 adapter
    If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
        $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
    }
    If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
        $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
    }
    #Configure the IP address and default gateway
    $adapter | New-NetIPAddress -AddressFamily $IPType -IPAddress $IP -PrefixLength $MaskBits -DefaultGateway $Gateway | Out-Null
    #Configure the DNS client server IP addresses
    $adapter | Set-DnsClientServerAddress -ServerAddresses $DNS | Out-Null
}

#Disable MDC Dock Audio Components
$DockAudioDevice = Get-PnpDevice -FriendlyName "CNXT Audio Dock"
if ($DockAudioDevice) {
    Write-Host "Dock Audio Device Present"
    $DockAudioDevice | Disable-PnpDevice -Confirm:$false
}
'@

    #Create C:\ProgramData\A2\ folder if it doesn't already exist
    if (!(Test-Path -Path "$ScriptDir")) {
        New-Item -ItemType Directory -Path "$ScriptDir" | Out-Null
    }
    #Create the script that the scheduled task will run
    if (!(Test-Path -Path "$ScriptFile")) {
        New-Item -ItemType File -Path "$ScriptFile" | Out-Null
    }
    Set-Content $ScriptFile -Force $ScriptContent | Out-Null

    #Create the scheduled task to launch the above Powershell script on each startup and logon event
    Register-ScheduledTask -TaskName $TaskName -InputObject $Task -Force | Out-Null

    #Run the scheduled task once right now (helpful if running this while already in a docked vehicle)
    Start-ScheduledTask -TaskName $TaskName | Out-Null
    
    Write-Host $script:MsgProcessComplete
} #End Function

Function Set-WindowsActivationOEM {
    


    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host 'Applying Settings 5 of 5 - A2 Windows Activation using OEM Product Key'
    Write-Host '-------------------------------------------------------------'
    Write-Host $script:MsgPleaseWait

    #Check if Windows is already active
    $activationStatus = Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "PartialProductKey IS NOT NULL" |
    Where-Object -Property Name -Like "Windows*" 
    if ($activationStatus.LicenseStatus -eq 1) 
    {
        #$true
        Write-Host " -- Windows is already active. Skipping process --"
        return
    } 
    else 
    {
        #$false

        #Set Variables
        $computer = Get-Content env:computername
        #Get the OEM Product Key from the local machine
        $oemkey = (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
        #Create a $service variable to activate with WMI later on
        $service = Get-WmiObject -query 'select * from SoftwareLicensingService'


        Write-Host " -- Windows OEM Product Key is: $oemkey"
        #Activate with the product key gathered above
        $service.InstallProductKey($oemkey)
        $service.RefreshLicenseStatus()
        Write-Host " -- Windows is now activated using the OEM Product Key"

        Write-Host $script:MsgProcessComplete
    }

    
} #End Function

# ===============================================================================================================================================================================================================================
# === BIOS UPDATE ===============================================================================================================================================================================================================
# ===============================================================================================================================================================================================================================

<#
Build BIOS Update Function
#>
Function Install-BIOSUpdate {
    #Set Variables
    $sourcepath = "$PSScriptRoot\Script_Source_Files\BIOS_Update"
    $UpdateBIOStoVersion = "1.40.0" #Change this if a newer version of the BIOS is to be installed (+ put the install package in the $sourcepath folder)
    $CurrentBIOSVer = (Get-CimInstance -ClassName Win32_BIOS).SMBIOSBIOSVersion #Get currently installed BIOS version
    $BIOSInstaller = "Latitude_7414_7214_5414_Rugged_$UpdateBIOStoVersion.exe" #BIOS installer filename
    $RandNum = Get-Random

    #Visual Feedback
    Write-Host ' '
    Write-Host '-------------------------------------------------------------'    
    Write-Host "Updating BIOS 1 of 1 - BIOS Update to $UpdateBIOStoVersion (if needed)"
    Write-Host '-------------------------------------------------------------'

    if ($CurrentBIOSVer -lt "$UpdateBIOStoVersion") {
        Write-Host " -- Updating BIOS to version $UpdateBIOStoVersion"
        Write-Host $script:MsgPleaseWait
        Start-Process -Wait "$sourcepath\$BIOSInstaller" -ArgumentList "/s /bls /l=`"$sourcepath\Logs\$RandNum.txt`""
        $script:REBOOTNEEDED = "YES"  #Set script-wide REBOOTNEEDED variable/flag [will hold value outside of the function]
        Write-Host $script:MsgProcessComplete
        Write-Host ' -- A reboot is required to finish the update'
    } else {
        Write-Host " -- BIOS is already up-to-date at version $UpdateBIOStoVersion"
    } #End if
} #End Function



# ===============================================================================================================================================================================================================================
# === REBOOT IF NEEDED ==========================================================================================================================================================================================================
# ===============================================================================================================================================================================================================================

<#
Reboot if needed by earlier Function
#>
Function RebootIfNeeded {
    if ($script:REBOOTNEEDED -eq "YES") {
        $MsgReboot = 'MDC automation script complete. Reboot Required.'
        $Seconds = 30
        $MsgStatus = "System will automatically reboot in $Seconds seconds"
        Write-Host ' '
        Write-Host '*************************************************************'  
        Write-Host "$MsgReboot $MsgStatus"
        Write-Host '*************************************************************'
        Write-Host ' '
        #Activate Timer
        $EndTime = [datetime]::UtcNow.AddSeconds($Seconds)
        while (($TimeRemaining = ($EndTime - [datetime]::UtcNow)) -gt 0) {
          Write-Progress -Activity $MsgReboot -Status "$MsgStatus - Ctrl+C to Cancel and Close" -SecondsRemaining $TimeRemaining.TotalSeconds
          Start-Sleep 1
        }
        Restart-Computer
        #no longer used: Start-Process shutdown -ArgumentList "/r /t 30 /c `"$RebootMessage`""

    } else {
        $MsgReboot = 'Script Complete. No reboot required.'
        $Seconds = 20
        $MsgStatus = "Closing in $Seconds seconds"
        Write-Host ' '
        Write-Host '*************************************************************'   
        Write-Host "$MsgReboot $MsgStatus"
        Write-Host '*************************************************************'
        #Activate Timer
        $EndTime = [datetime]::UtcNow.AddSeconds($Seconds)
        while (($TimeRemaining = ($EndTime - [datetime]::UtcNow)) -gt 0) {
          Write-Progress -Activity $MsgReboot -Status "$MsgStatus - Ctrl+C to Cancel and Close" -SecondsRemaining $TimeRemaining.TotalSeconds
          Start-Sleep 1
        }
    } #End if
} #End Function



# ===============================================================================================================================================================================================================================
# === MAIN MENU==================================================================================================================================================================================================================
# ===============================================================================================================================================================================================================================

Function Show-MainMenu {
    Try {
        do {
            Write-Host "######################################################################################" -ForegroundColor Yellow
            Write-Host "#  Please make a selection:                                                          #" -ForegroundColor Yellow
            Write-Host "#  ------------------------                                                          #" -ForegroundColor Yellow
            Write-Host "#  1. Install/Update ALL MDC Software/Settings (safe to overwrite previous installs) #" -ForegroundColor Yellow
            Write-Host "#  Q. Quit                                                                           #" -ForegroundColor Yellow
            Write-Host "######################################################################################" -ForegroundColor Yellow
            Write-Host "                                                                  Version $script:Version" -ForegroundColor Green

            $MenuOption = Read-Host "Choose option from above"
            Switch ($MenuOption) {
                '1' { #Execute Functions defined above in the following order:

                
                        Try {
                            InternetConnectivityCheck

                        } Catch {
                        MsgCatchError
                        } #End of Catch Section

                        Try {
                            Install-CLEMISTrellix

                        } Catch {
                        MsgCatchError
                        } #End of Catch Section

                        Try {
                            Install-CLEMISBigFix

                        } Catch {
                        MsgCatchError
                        }
                        
                        Try {
                             Install-CLEMISIESpell

                        } Catch {
                        MsgCatchError
                        }

                        Try {
                            Install-CLEMISEasyStreetDraw

                        } Catch {
                        MsgCatchError
                        }

                        Try {
                            Install-A2TalonMDC

                        } Catch {
                        MsgCatchError
                        }


                        Install-A2ChomeMDC
                        Install-A2OnlyOffice
                        Install-A2Axon
                        Install-CLEMIS_SecureAccess
                        Install-AAPD_MDC_maps
                        Install-RemoteUtilities
                        Install-DellSupportAssist
                        Set-FileHandlerDefaults
                        Set-CustomRegistryChanges
                        Set-OtherCustomSettings
                        Set-ScheduledTaskScript
                        Set-WindowsActivationOEM
                        Install-BIOSUpdate
                        RebootIfNeeded
                        return }
                'Q' { return }
                DEFAULT { Write-Host "Invalid option entered. Choose again." }
            } #End Switch
        pause
        } Until ($MenuOption -eq "Q")
    } Catch {
        MsgCatchError
        Write-Host "I'm sorry, an error has occurred. (Junior Developer here!)" -ForegroundColor Yellow
        
    } #End of Catch Section
} #End Function



# ===============================================================================================================================================================================================================================
# === EXECUTE FUNCTIONS =========================================================================================================================================================================================================
# ===============================================================================================================================================================================================================================

Show-MainMenu
Pause