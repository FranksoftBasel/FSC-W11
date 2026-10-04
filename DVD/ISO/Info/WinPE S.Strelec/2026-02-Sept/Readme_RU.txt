Нижеперечисленные Linux версии программ будут работать как в режиме BIOS так и UEFI
В режиме BIOS в меню загрузки, нужно перейти в Grub4Dos menu (стрелкой вниз)
В режиме EFI по умолчанию используется стандартный EFI загрузчик Microsoft.
Необходимо вручную переключить загрузчик на GRUB2
Для расширения функционала при загрузке в режиме UEFI вы можете переключиться на загрузчик GRUB2.
Однако загрузка с включенным Secure Boot на всех компьютерах не гарантированна, так что лучше Secure Boot отключить.
При загрузке с GRUB2, присутствуют утилиты проверки памяти, а также можно самостоятельно добавить различные
Linux образы.

Переключаться между EFI загрузчиками Microsoft или GRUB2, нужно запустив батник на флешке в папке EFI/boot
_MICROSOFT_EFI.bat - переключает на загрузчик Microsoft
_GRUB2_EFI.bat - переключает на загрузчик GRUB2

Посмотреть какой загрузчик активный, всегда можно по файлу в папке EFI/boot
[MICROSOFT_MODE] - активны загрузчики Microsoft
[GRUB2_MODE] - активны загрузчики GRUB2


Примечание: для Acronis True Image необязательно распаковывать весь ISO образ. Он сейчас имеет большой размер, и будет
занимать много места. 
Для х64 версии достаточно извлечь в нижеуказанные папки из ISO образа файлы:
dat10.dat, dat11.dat и dat12.dat
Для х86 версии:
dat2.dat, dat3.dat и dat4.dat

Acronis True Image 2024
Распаковать ISO образ в папку на флешке
Linux/Acronis2024

Acronis True Image 2021
Распаковать ISO образ в папку на флешке
Linux/Acronis2021

Acronis True Image 2020
Распаковать ISO образ в папку на флешке
Linux/Acronis2020

Acronis True Image 2019
Распаковать ISO образ в папку на флешке
Linux/Acronis2019

Acronis True Image 2018
Распаковать ISO образ в папку на флешке
Linux/Acronis2018

Acronis Disk Director 12
Распаковать ISO образ в папку на флешке
Linux/ADD12

Kaspersky Rescue Disk 2018
Скачать ISO образ с официального сайта http://rescuedisk.kaspersky-labs.com/updatable/2018/krd.iso
и распаковать образ в папку Linux/krd2018 на флешке.

Сlonezilla
Скачать ISO образ с официального сайта, переименовать его в clonezilla.iso и скопировать ISO образ в папку
Linux/clonezilla32 или Linux/clonezilla64 соответственно разрядности образа.

TeraByte Image for Linux
Распаковать ISO образ соответственно разрядности в папку на флешке
Linux/TeraByteImageLinux32 или Linux/TeraByteImageLinux64

Ubuntu Desktop amd64
Распаковать ISO образ в папку на флешке
Linux/ubuntu

Parted Magic 2020
ISO образ переименовать в pmagic.iso, и скопировать в папку
Linux/pmagic

Kali Linux 2019
Распаковать ISO образ в папку на флешке
Linux/kalilinux2019

Dr.Web LiveDisk
Скачать ISO образ с официального сайта http://download.geo.drweb.com/pub/drweb/livedisk/drweb-livedisk-900-cd.iso
и распаковать ISO образ в папку на флешке
Linux/DrWeb