The following Linux versions of the programs will work in both BIOS and UEFI mode
In BIOS mode in the boot menu, you need to go to the Grub4Dos menu (down arrow)
In EFI mode, the default Microsoft standard EFI boot loader is used.
You must manually switch the bootloader to GRUB2
To expand functionality when booting in UEFI mode, you can switch to the GRUB2 bootloader.
However, booting with Secure Boot enabled on all computers is not guaranteed.

Switch between EFI loaders Microsoft or GRUB2, you need to run the batch file on a flash drive in the EFI/boot folder
_MICROSOFT_EFI.bat - switches to the Microsoft bootloader
_GRUB2_EFI.bat - switches to GRUB2 bootloader

You can always see which boot loader is active by file in the EFI/boot folder
[MICROSOFT_MODE] - Microsoft loaders are active
[GRUB2_MODE] - GRUB2 boot loaders are active

When using the GRUB2 boot loader in EFI, you can add Acronis True Image 2018/2019/2020, Acronis Disk Director 12, Kaspersky Rescue Disk 2018, Ñlonezilla, and TeraByte Image for Linux, Parted Magic, Ubuntu Desktop amd64. (download both in UEFI and BIOS)

Note: For Acronis True Image, it is not necessary to extract the entire ISO image. It is now large in size and will be
take up a lot of space. 
For the x64 version, just extract the files from the ISO image to the folders below:
dat10.dat, dat11.dat and dat12.dat
For x86 version:
dat2.dat, dat3.dat and dat4.dat

Acronis True Image 2024
Unpack the ISO image into a folder on the USB flash drive
Linux/Acronis2024

Acronis True Image 2021
Unpack the ISO image into a folder on the USB flash drive
Linux/Acronis2021

Acronis True Image 2020
Unpack the ISO image into a folder on the USB flash drive
Linux/Acronis2020

Acronis True Image 2019
Unpack the ISO image into a folder on the USB flash drive
Linux/Acronis2019

Acronis True Image 2018
Unpack the ISO image into a folder on the USB flash drive
Linux/Acronis2018

Acronis Disk Director 12
Unpack the ISO image into a folder on the USB flash drive
Linux/ADD12

Kaspersky Rescue Disk 2018
Download ISO image from the official site http://rescuedisk.kaspersky-labs.com/updatable/2018/krd.iso
and unpack the image to the Linux/krd2018 folder on the USB flash drive.

Parted Magic 2020
ISO image rename in pmagic.iso and copy the folder
Linux/pmagic

Ubuntu Desktop amd64
Unpack the ISO image into a folder on the USB flash drive
Linux/ubuntu

Clonezilla
Download ISO image from official site, rename it to clonezilla.iso and copy ISO image to folder
Linux/clonezilla32 or Linux/clonezilla64 according to the size of the image.

TeraByte Image for Linux
Unpack the ISO image, respectively, the bit depth in the folder on the USB flash drive
Linux/TeraByteImageLinux32 or Linux/TeraByteImageLinux64