---------------------------------------------------------------------------------
-- Configurable utility script that prepares for and starts up Gig Performer
-- 
-- Author: Andrew Hunt - andrew at musios.app
-- License: Creative Commons CC0 1.0 Universal
-- Documentation & source: https://github.com/musios-app/support-act
---------------------------------------------------------------------------------

on setDarkMode()
	tell application "System Events"
		tell appearance preferences
			set dark mode to true
		end tell
	end tell
end setDarkMode

on setLightMode()
	tell application "System Events"
		tell appearance preferences
			set dark mode to false
		end tell
	end tell
end setLightMode



on setSoundDevice(type, deviceName)
	set types to {"alert", "input", "output"}
	if not (types contains type) then
		error "setSoundDevice passed unknown type: " & type
	end if
	
	-- We'll use MacOS naming consistent with System Settings for Sound
	if type is "alert" then set type to "system"
	
	try
		set soundScript to "/opt/homebrew/bin/SwitchAudioSource -t " & type & " -s \"" & deviceName & "\""
		do shell script soundScript
	on error errMsg
		if (offset of "No such file or directory" in errMsg) > 0 then
			set dialogText to "Unable to set sound device.  SwitchAudioSource is required. Visit: https://github.com/deweller/switchaudio-osx"
			display dialog dialogText buttons {"Continue", "Cancel"} default button "Cancel" with title "WARNING"
		else
			display dialog "Error: " & errMsg buttons {"OK"} default button "OK"
		end if	
	end try
end setSoundDevice


on setVolume(type, volumeLevel)
	if type is "input" then
		set volume input volume volumeLevel
	else if type is "output" then
		set volume output volume volumeLevel
	else if type is "alert" then
		set volume alert volume volumeLevel
	else
		error "setVolume passed unknown type: " & type
	end if
end setVolume


on listConnectedAudioDevices()
	set shellScript to "TEMP=\"$(mktemp -d)/audio-devices.txt\"; system_profiler -detailLevel basic SPAudioDataType > $TEMP; open -a TextEdit $TEMP"
	do shell script shellScript
end listConnectedAudioDevices

on listConnectedUSBDevices()
	set shellScript to "TEMP=\"$(mktemp -d)/usb-devices.txt\"; system_profiler -detailLevel basic SPUSBDataType > $TEMP; open -a TextEdit $TEMP"
	do shell script shellScript
end listConnectedUSBDevices

on listConnectedBluetoothDevices()
	set shellScript to "TEMP=\"$(mktemp -d)/bluetooth-devices.txt\"; system_profiler -detailLevel basic SPBluetoothDataType > $TEMP; open -a TextEdit $TEMP"
	do shell script shellScript
end listConnectedBluetoothDevices


-- Force the download of files in a path by recursively processing the contents (which forces the download)
on cloudDownload(path)
	set shellScript to "find '" & path & "' -type f -exec wc {} \\;"
	-- display dialog shellScript buttons {"OK"} default button 1
	set report to do shell script shellScript
end cloudDownload


on checkNetAccess(site)
	-- Use netcat to check if a site is accessible
	set shellScript to "TEMP=$(nc -z -G 5 " & site & " 80 2>&1); echo $TEMP"
	set report to do shell script shellScript
	
	if (offset of "succeeded" in report) is 0 then
		display dialog ("Network access failed to: " & site) buttons {"Continue", "Cancel"} default button "Cancel" with title "WARNING"
	end if
end checkNetAccess


on checkFileOrFolderAccessible(path)
	tell application "System Events"
		if (exists disk item path) then
			log "  Required file/folder: " & path & " OK"
		else
			log "  Required file/folder: " & path & " MISSING"
			display dialog ("Missing file or directory: " & path) buttons {"Continue", "Cancel"} default button "Cancel" with title "WARNING"
		end if
	end tell
end checkFileOrFolderAccessible


on check_system_profiler(dataTypeText, dataType, deviceName)
	set shellScript to "system_profiler -detailLevel full " & dataType
	set report to do shell script shellScript
	
	if report contains deviceName then
		log "  " & dataTypeText & ": " & deviceName & " OK"
	else
		log "  " & dataTypeText & ": " & deviceName & " MISSING"
		display dialog ("Missing " & dataTypeText & ": " & deviceName) buttons {"Continue", "Cancel"} default button "Cancel" with title "WARNING"
		set OK to false
	end if
end check_system_profiler


on checkAudioDeviceConnected(deviceName)
	check_system_profiler("Audio device", "SPAudioDataType", deviceName)
end checkAudioDeviceConnected


on checkUSBDeviceConnected(deviceName)
	check_system_profiler("USB device", "SPUSBDataType", deviceName)
end checkUSBDeviceConnected


on checkBluetoothDeviceConnected(deviceName)
	check_system_profiler("Bluetooth device", "SPBluetoothDataType", deviceName)
end checkBluetoothDeviceConnected



on openWebPage(browser, page)
	tell application browser
		open location page
		activate
	end tell
end openWebPage


on openDocument(docPath)
	set targetPath to POSIX file docPath as alias
	tell application "Finder" to open targetPath
end openDocument


on itermCommand(cmd)
    tell application "iTerm"
        activate
        set newWindow to (create window with default profile)
        tell current session of newWindow
            write text cmd
        end tell
    end tell
end itermCommand

on runTerminalCommand(cmd)
	tell application "Terminal"
		do script cmd
		activate
	end tell
end runTerminalCommand

