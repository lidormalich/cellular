@echo off
color 0A
echo *******************************************************************************
echo *******************************************************************************
echo *******************************************************************************
echo *******************************************************************************
echo **************************    Lidor Malich    *********************************
echo *******************************************************************************
adb kill-server
adb shell
adb shell "getprop ro.product.system.name"
echo Model: 
adb shell "getprop ro.product.model"
echo ************
echo ************
echo Baseband:
adb shell "getprop ro.build.version.incremental"
echo ************
echo ************
echo VERSION ANDROID:
adb shell "getprop ro.build.version.release"
echo ************
echo ************
echo VERSION MODEM:
adb shell "getprop gsm.version.baseband"
echo ************
echo ************
echo Disable samsung update app...
adb shell pm disable-user --user 0 com.wssyncmldm
adb shell pm disable-user --user 0 com.sec.android.soagent
echo ************
echo ************
echo DONE!
echo ************
echo ************
echo *************************************************************************************
echo ******************************    Lidor Malich   ************************************
echo *************************************************************************************
pause