// Support SubsystemID
// Driver Version
// MHI (For PCIe mode) - v2.0.0.3 (LE1.2 based. Win10 20H1 & Win11 22000 & Win11 SV2 HLK,
                        Fix the DVL issue during the Win11 SV2 HLK test (Static Tools Logo Test item)    2022/07/06)
                        05301723                CR2970117.patch for  MBIM driver occurred YB43 during the WinPvt power stress restart test 2021/08/17)
			            05086811,   	        Fix GNSS YB43           2021/03/29,
                        05137119                patch for Cellular missing when device resume from S4           2021/03/29)
// UDE - v2.0.0.3 (Win10 20H1 & Win11 22000 & Win11 SV2 HLK. DFX enable.
                  Fix the DVL issue during the Win11 SV2 HLK test (Static Tools Logo Test item)    2022/07/06)
			05353988	USB_CAP_DEVICE_TYPE UsbCapDeviceType = USB_CAP_DEVICE_TYPE_UDE_MBIM;	Fix D3 cold error in system HLK Test (TestPowerStates)	2021/09/29)
			04940821	RELEASE_HARDWARE_HANG_FIX.zip	patch for 0x9f when UDE uninstall	2020/12/06)
// Modem (QUD) - v1.0.1.3 (r1.00.70 based. Win10 20H1 & Win11 22000 DUA)
// Diagnostic (QUD) - v1.0.1.3 (r1.00.70 based. Win10 20H1 & Win11 22000 DUA)
// Location GNSS Qmux (GNSS) - v2.0.0.3 (LE1.2 based. SIMService V1.0.0.57 based.Add Details Description. Win10 20H1 & Win11 22000 & Win11 SV2 HLK,
                        Fix the DVL issue during the Win11 SV2 HLK test (Static Tools Logo Test item)    2022/07/06)
                        05182822   "CR2910203_hostdrivers.win.1.3.patch" (BSOD 0x9f, 0x7e, 0x13a) and "review-1900643.diff" (BSOD0xC4)     2021/06/19
			            05086811,  Fix GNSS YB43           2021/03/29,
// Location GNSS (GNSS) - v2.0.0.3 (LE1.2 based. Win10 20H1 & Win11 22000 & Win11 SV2 HLK,
			05349224   	                      CR#2955710_31085858.diff  Fix GNSS YB43           2021/08/17,
			05086811,   	                                                Fix GNSS YB43           2021/03/29,
			17271		#define _MAX_LOCCLIENT_OPEN_RETRY_COUNT_ 30	Fix GNSS YB31 		2020/12/10)
// FOTA - v1.0.7.7 (T99W175.F0.1.0.0.9 (AP076). Win10 20H1 & Win11 22000 & Win11 SV2 HLK)

// Procedure
1. Install PCIe device with MHI driver(MhiHost.inf) (set driver search path \MHI)
2. Replace MHI child node to UDE driver(qcude.inf) (\UDE)
3. Update all Unknown UDE Client device with QUD driver (\QUD_GNSS)


