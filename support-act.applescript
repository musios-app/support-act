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


-- Enable or disable Siri
on disableSiri()
	set shellScript to "defaults write com.apple.assistant.support \"Assistant Enabled\" -bool false"
	do shell script shellScript
	
	-- set shellScript to "defaults write com.apple.Siri StatusMenuVisible -bool false"
	-- do shell script shellScript
end disableSiri

on enableSiri()	
	set shellScript to "defaults write com.apple.assistant.support \"Assistant Enabled\" -bool true"
	do shell script shellScript
	
	-- set shellScript to "defaults write com.apple.Siri StatusMenuVisible -bool true"
	-- do shell script shellScript
end enableSiri



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


on openWithApplication(theApp, path)
	tell application theApp
		activate
		delay 2
		open path
	end tell
end openWithApplication


on openDocument(docPath)
	set targetPath to POSIX file docPath as alias
	tell application "Finder" to open targetPath
end openDocument


on chooseFile(question, fileList, dir)
	set existsList to {}
	repeat with theFile in fileList
		try
			set sep to ""
			if theFile does not start with "/" and dir does not end with "/" then
				sep = "/"
			end if
			
			set filepath to dir & "/" & theFile
			set fileInfo to info for filepath
			copy theFile to the end of the existsList
		end try
	end repeat
	
	if existsList is {} then error "Not valid files in the list"

	choose from list existsList with prompt question OK button name "Open" cancel button name "Cancel"
	
	if the result is not false then
		set selectedFilePath to dir & "/" & (item 1 of the result)
		return selectedFilePath
	else
		error "No valid file selected"
	end if
	
end chooseFile


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


-- Popup that shows an instruction message to the user
on showInstruction(theTitle, theMessage)
	
	display dialog theMessage ¬
		with title theTitle ¬
		with icon note buttons {"Continue", "Stop"} ¬
		default button ¬
		"Continue" cancel button "Stop"
	
end showInstruction

-- Popup that shows multi-step instructions to the user
on showStepInstructions(theTitle, theSteps)
	
	set theMessage to ""
	set lineNum to 1
	repeat with theLine in theSteps
		set theMessage to theMessage & lineNum & ". " & theLine & tab & return
		set lineNum to lineNum + 1
	end repeat
	
	display dialog theMessage ¬
		with title theTitle ¬
		with icon note buttons {"Continue", "Stop"} ¬
		default button ¬
		"Continue" cancel button "Stop"
	
end showStepInstructions


-- Amphetamine is a free app that prevents your Mac from sleeping
-- Install from app store: https://apps.apple.com/app/amphetamine/id937984704
-- https://iffy.freshdesk.com/support/solutions/articles/48000078223-applescript-documentation

on startAmphetamineSession(durationMinutes)
	tell application "Amphetamine"
		activate
		delay 1
		start new session with options {duration: durationMinutes, interval: minutes, displaySleepAllowed: false}
	end tell	
end startAmphetamineSession

on endAmphetamineSession()
	tell application "Amphetamine" to end session
end endAmphetamineSession

