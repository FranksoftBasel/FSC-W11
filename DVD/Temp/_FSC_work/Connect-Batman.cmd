netsh wlan add profile filename=%~dp0\WLAN-Batman.xml user=all

netsh wlan connect name="Batman"
