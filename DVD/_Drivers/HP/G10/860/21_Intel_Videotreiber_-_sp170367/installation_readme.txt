;=============================================================================
;
; Copyright (c) Intel Corporation (2022-2025).
;
; INTEL MAKES NO WARRANTY OF ANY KIND REGARDING THE CODE.  THIS CODE IS
; LICENSED ON AN "AS IS" BASIS AND INTEL WILL NOT PROVIDE ANY SUPPORT,
; ASSISTANCE, INSTALLATION, TRAINING OR OTHER SERVICES.  INTEL DOES NOT
; PROVIDE ANY UPDATES, ENHANCEMENTS OR EXTENSIONS.  INTEL SPECIFICALLY
; DISCLAIMS ANY WARRANTY OF MERCHANTABILITY, NONINFRINGEMENT, FITNESS FOR ANY
; PARTICULAR PURPOSE, OR ANY OTHER WARRANTY.  Intel disclaims all liability,
; including liability for infringement of any proprietary rights, relating to
; use of the code. No license, express or implied, by estoppel or otherwise,
; to any intellectual property rights is granted herein.
;
;=============================================================================

DISCLAIMER: Intel is making no claims of usability, efficacy or warranty.  The INTEL SOFTWARE LICENSE AGREEMENT contained herein completely defines the license and use of this software.
This document contains information on products in the design phase of development. The information here is subject to change without notice. Do not finalize a design with this information.

CONTENTS OF THIS DOCUMENT
I.		System Requirements
II.		Localized Language Abbreviations
III.    Firmware Update Information
IV.	    Installing the Software
V.		Verifying Installation of the Software
VI.		Identifying the Software Version Number
VII.    Installation Switches
VIII.   Installation Exit Codes
IX.	    Uninstalling the Software

I.   SYSTEM REQUIREMENTS
1.  The software should be installed on systems with at least 4 GB of system memory.
2.  There should be sufficient hard disk space in the <TEMP> directory on the system in order to install this software.

II.   LOCALIZED LANGUAGE ABBREVIATIONS
The following list contains the hexadecimal key of all
languages into which the driver has been localized. You may
have to refer to this section while using this document.

ar-SA - Arabic (Saudi Arabia)
zh-CN - Chinese (Simplified)
zh-TW - Chinese (Traditional)
hr-HR - Croatian
cs-CZ - Czech
da-DK - Danish
nl-NL - Dutch (Netherlands)
en-US - English (US)
fi-FI - Finnish
fr-FR - French
de-DE - German
el-GR - Greek
he-IL - Hebrew (Israel)
hu-HU - Hungarian
it-IT - Italian
ja-JP - Japanese
ko-KR - Korean
nb-NO - Norwegian (Bokmal)
pl-PL - Polish
pt-BR - Portuguese (Brazilian)
pt-PT - Portuguese
ro-RO - Romanian
ru-RU - Russian
sk-SK - Slovak
sl-SI - Slovenian (Slovenia)
es-ES - Spanish
sv-SE - Swedish (Sweden)
th-TH - Thai
tr-TR - Turkish
uk-UA - Ukranian

III.   Firmware Update Information
As part of the graphics driver installation process, a firmware update may be included and executed if required for your system. Firmware updates are critical for maintaining hardware compatibility, improving system stability, fixing known issues, and enabling new features supported by the latest drivers.
Key Points:
1.  The firmware update is triggered automatically when needed and may extend the installation time.
2.	If a firmware update is executed, it is highly recommended to perform a full system shutdown (rather than a standard reboot) to ensure that all firmware-level changes are fully applied. After shutdown, the user should manually power the system back on.

IV.   INSTALLING THE SOFTWARE
General Installation Notes:
1.  The operating system must be installed prior to the installation of the
    driver.
2.  This installation procedure is specific only to the version of driver
    and installation file included in this release.
3.  This procedure assumes that all of the software associated with this
    release is located in the same directory.
4.  When updating from a non-DCH driver to a DCH driver, Have-Disk
    installation is not recommended, and may leave the system in an unstable state.
    If you are unsure if your drivers are DCH or non, we recommend only
    using installer.exe or the extractable EXE to install the driver.
	
ADDITIONAL OPTIONAL SOFTWARE
Please note: Intel may offer additional optional software as part of it's installation package. 
Users can opt in or out of installation of that additional optional software 
through the user interface installation or with the appropriate command line installation arguments for no extras.

INSTALLATION INSTRUCTIONS
------------------------------------------------------------------
To install from a Web download, you will download an .exe file. Double-click on
the file you downloaded and the installer splash screen will pop-up.

------------------------------------------------------------------
    Intel* "installer.exe" Installation - RECOMMENDED
------------------------------------------------------------------
1. Locate the Driver Files:
    - Open File Explorer or use your browser to find the directory containing the driver files.
2. Run the Installer:
    - Look for an executable file (installer.exe) in the driver directory.
    - Double-click on the executable file to start the installation process.
3. Initiate Installation:
    - The installation user interface will open. Follow the on-screen instructions to start the installation.
4. Accept License Agreement:
    - Review the presented License Agreement.
    - If you agree with the terms, follow the on-screen instructions to indicate your agreement and continue.
5. Select Software Components:
    - Some installations may allow you to choose specific software components to install.
    - Select the desired components based on your preferences.
    - Follow any on-screen instructions for this step to begin the installation.
6. Completion and Reboot (if necessary):
    - After the installation is complete, you will see a screen indicating successful installation.
    - Follow any on-screen instructions for completing the installation.
    - Note: Depending on the installation scenario, your system may need to be restarted. Follow the prompts if a reboot is required.

------------------------------------------------------------------
    Microsoft Windows* "Have-Disk" Installation - NOT RECOMMENDED
------------------------------------------------------------------
1. Locate the Driver Files:
    - Open File Explorer or use your browser to find the directory containing the driver files.
2. Open Device Manager:
    - Right-click on the Start button and select Device Manager.
3. Locate the Graphics Driver:
    - Expand the Display adapters section.
    - Right-click on the device which requires update and select Update driver.
4. Browse for the Driver:
    - Select Browse my computer for drivers.
    - Select Let me pick from a list of available drivers on my computer.
    - Select Have Disk.
5. Install the Driver:
    - Browse to the directory where the driver files are located.
    - Select the .inf file and click Open - iigd_dch.inf (integrated graphics) or iigd_dch_d.inf (discrete graphics)
    - Follow the on-screen instructions to install the driver.
6. Reboot (if necessary):
    - After the installation is complete, you may need to restart your system. Follow any on-screen instructions for this step.
        

To determine if the driver has been loaded correctly, refer to the section below.

V.   VERIFYING INSTALLATION OF THE SOFTWARE
1.  Right click "Start", select "Device Manager".
2.  In the "User Account Control" window, click "Yes".
3.  For Intel(R) Graphics Driver, expand "Display adapters". The Intel(R) Graphics Driver should
    be listed. If not, the driver is not installed correctly.
4.  For Intel(R) Display Audio Driver, expand "Sound, video and game controllers". The "Intel(R) Display
    Audio" driver should be listed and should not show a yellow bang.
    If not, the driver is not installed correctly.

To check the version of the driver, refer to the section below.

VI.   IDENTIFYING THE SOFTWARE VERSION NUMBER
Device Manager:
1.  Right click "Start", select "Device Manager".
2.  In the "User Account Control" window, click "Yes".
3.  For Intel(R) Graphics Driver, expand "Display adapters" and double-click the graphics controller. In the "Driver" tab, note the Driver Version.
4.  For Intel(R) Display Audio Driver, expand "Sound, video and game controllers" and double-click "Intel(R) Display Audio". In the "Driver" tab, click "Driver Details" and the function driver (IntcDAud.sys) version should be listed on this screen.

Intel(R) Graphics Command Center:
1.  Click on "Start", search for "Graphics Command Center" and launch the application.
2.  Select the "System" tab on the lefthand side.
3.  Choose the "Driver" header and note the driver version under Graphics Driver.

VII.   INSTALLATION SWITCHES
The switches in the installer.exe file will have the following syntax.
Switches are not case-sensitive and may be specified in any order
(except for the -s switch). Switches must be separated by spaces.
Installer.exe [-b] [-overwrite] [-g <LCID>] [-s] [-report <path>]

GFX-INSTALLATION CUSTOM SWITCHES
-b/--reboot Forces a system reboot after the installation completes.
In non-silent mode, the absence of this switch will prompt
the user to reboot. In silent mode, the absence of this
switch forces the installer.exe to complete without rebooting
(the user must manually reboot to conclude the installation
process). If a firmware update is required, the installer may
perform a shutdown instead of a reboot, requiring manual power-on.

-o/--overwrite Installs the Intel(R) Graphics Driver regardless of
the version of previously installed driver. In non-silent mode,
the absence of this switch will prompt the user to confirm
overwrite of a newer Intel(R) Graphics Driver. In silent mode,
the absence of this switch means that the installation will
abort any attempts to regress the revision of the Intel(R) Graphics
driver.

-g <LCID> Specifies the language used in the installation user
interface. Without this switch, the installation user interface
will be shown in the Display language of the OS by default.
Hexadecimal values for the supported languages can be found in
the localized language abbreviations section of this readme.

-s/--silent Runs in silent mode. The absence of this switch causes
the installation to be performed in verbose mode.

-f/--fresh Forces clean/fresh installation of the driver, removing all old drivers.
Works only with the silent installation.

--report <path> Specifies an alternate location for the log file
created by a silent installation. By default, the log file is
created and stored during a silent installation under <root
directory>\Intel\Logs directory as IntelGFX.log
(<WINDIR>\Temp\IntelGFX.log).

--noExtras Installs driver without additional components.
By default, all software which is included in the package
are installed along with the driver.

--outputFullLog Writes all output to the console. By default,
only specific messages are written to the console. This flag
forces the writing of all messages that are written to the log file too.

--terminateProcesses Forcefully terminates processes which are
required to be closed before driver installation.
Without this option in silent mode, the installation may
fail if certain processes need to be closed beforehand.

--unsigned Disables digital signature verification.
Caution: Activating this option may result in the installation of unauthorized Intel software!

--doNotForceInf Disables forcing of driver installation
(OS decides which driver will be in use by the system).
Note: In certain situations, enabling this option may
result in the system continuing to use an older
driver even after installing this one.

--nodrv Disables the driver installation step (graphics and audio).
Prevents the installation of the driver for both graphics and audio components.
This means that the system will not proceed with the usual steps involved in installing
the driver software related to graphics and audio functionalities.

--ver Displays the version of the drivers in the installation package.

--uninstaller Runs the uninstaller for all the Intel software including driver
and components uninstallation. This option can be used with silent mode.


VIII. INSTALLATION EXIT CODES

The installer may exit with one of the following numeric codes that help identify the outcome of the installation process:

0 - Success
The installation completed successfully.

1 - Generic error
An unspecified error occurred. For more details, refer to the installation log file.

2 - Rebooting system
The installation was successful, but the system had to be restarted.

5 - Platform not supported
The operating system is not supported by the installer.

6 - Closed by user
The user closed the installer before the installation could complete.

7 - Invalid command
The installer was launched with unsupported or incorrect command-line arguments. Please check the command-line usage instructions.

8 - Driver file not found
The installer could not find a suitable driver that matches the system's devices.

9 - Driver digital signature missing
The required driver files do not have a valid Intel digital signature.

10 - Extras digital signature missing
Files in the "Resource" folder are missing a valid Intel digital signature.

11 - Insufficient disk space
There is not enough free disk space to proceed with the installation.

13 - Reboot required before installation
A system reboot is required before the driver installation can continue.

14 - Reboot required
The installation was successful, but a system reboot is required to fully apply all settings or changes.

15 - Close processes before continuation
Certain running processes are preventing the installation from proceeding. These must be closed first.

16 - Another installation in progress
The installer detected that another installation is currently running. Wait for it to finish before trying again.

17 - Shutting down system
The installation was successful, but the system had to be shut down.

18 - Shut down required
The installation was successful, but a full shutdown and power-on cycle is needed to apply all changes.


IX.   UNINSTALLING THE SOFTWARE

------------------------------------------------------------------
    Intel* "uninstaller.exe" Uninstallation - RECOMMENDED
------------------------------------------------------------------
1. Right-click the Start Menu (the Windows icon at the bottom left corner).
2. Select "Settings" from the menu.
3. In the Settings window, click "Apps".
4. Select "Installed apps" from the menu in the middle.
5. Scroll through the list and find "Intel(R) Graphics Software & Drivers".
6. Click the three dots on the right side of the entry and select "Uninstall".
7. In the uninstaller window, choose the components or driver you want to uninstall.
8. Click "Uninstall" to start the process.
9. Once the uninstallation is complete, click "Finish" to close the window.

------------------------------------------------------------------
    Microsoft Windows* "Device Manager" Uninstallation - NOT RECOMMENDED
------------------------------------------------------------------
NOTE: This procedure assumes the above installation process
was successful. This uninstallation procedure is specific
only to the version of the driver and installation files
included in this package.

1.  Right click "Start", select "Device Manager".
2.  In the "User Account Control" window, click "Yes".
3.  For Intel(R) Graphics Driver, expand "Display adapters".
4.  Right click the Intel(R) Graphics Driver and select "Uninstall device".
5.  Select the "Delete the driver software for this device" check box and click "Uninstall".
6.  For Intel(R) Display Audio Driver, expand "Sound, video and game controllers".
7.  Right click the Intel(R) Display Audio Driver and select "Uninstall device".
8.  Select the "Delete the driver software for this device" check box and click "Uninstall".
