---------------------------------------------------------------------------------
-- Configurable utility script that prepares for and starts up Gig Performer
-- 
-- Author: Andrew Hunt - andrew at musios.app
-- License: Creative Commons CC0 1.0 Universal
-- Documentation: https://musios.app
-- Source, comments: https://github.com/musios-app/gp-support-act
---------------------------------------------------------------------------------

-- Leave these varialbles as-is
global gpWindow, numTasks, taskNum
set gpWindow to missing value
set numTasks to missing value
set taskNum to missing value
-- 

setDarkMode()

checkNetAccess2("www.google.com")


---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--    Configuration this section for your rig and environment
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

-- Maintain a progress bar. It needs a rough number of tasks to be done
progress_start(20, "GP Support Act", "Getting ready to perform!")

-- Check network access
-- checkNetAccess("www.google.com")
-- checkNetAccess("www.musescore.com")
-- checkNetAccess("www.ilok.com")

-- Force download folders & files that may be in cloud storage
--cloudDownload("/Users/musios/Hey Bulldog - The Beatles")
-- cloudDownload("/Users/andrew/Dropbox/Music/Cover Songs/We Can Get Together - Icehouse")

-- Check for required folders and files
-- checkFileOrFolderAccessible("/Volumes/SilverMusic/Instruments")
-- checkFileOrFolderAccessible("/Volumes/SilverMusic/Instruments/Native Instruments")
-- checkFileOrFolderAccessible("/Volumes/SilverMusic/Instruments/ROLI")
-- checkFileOrFolderAccessible("/Volumes/SilverMusic/Instruments/Spitfire/Spitfire Audio - BBC Symphony Orchestra")

-- Check that required audio devices are connected
-- listConnectedAudioDevices()
-- checkAudioDeviceConnected("MacBook Air Speakers")
-- checkAudioDeviceConnected("MacBook Air Microphone")
-- checkAudioDeviceConnected("EVO8")

-- Check that required USB & Bluetooth devices are connected.
-- listConnectedUSBDevices()
-- listConnectedBluetoothDevices()
-- checkUSBDeviceConnected("XPIANO73")
-- checkUSBDeviceConnected("Stream Deck Plus")
-- checkBluetoothDeviceConnected("FS-1-WL")

-- Open web pages in your preferred browser ("Safari", "Google Chrome", "Brave", "Arc", "Firefox"...)
-- openWebPage("Safari", "https://musescore.com/official_scores/scores/6937415")
-- openWebPage("Google Chrome", "https://tabs.ultimate-guitar.com/tab/royal-blood/figure-it-out-official-2007289")

-- Open document(s)
-- openDocument("/Users/musios/charts/All Torn Down.pdf")
-- openDocument("/Users/musios/charts/Celebration - Kool & the Gang/Celebration.mscz")
-- openDocument("/Users/musios/charts/Song List.xlsx")
-- openDocument("/Users/musios/charts/text-doc.txt")
-- openDocument("/Users/musios/Documents/Bome MIDI Translator/Presets/Korg.bmtp")

-- openDocument("/Users/andrew/Dropbox/Music/Cover Songs/We Can Get Together - Icehouse/We Can Get Together - Icehouse - chart.pdf")
-- openDocument("/Users/andrew/Dropbox/Music/Cover Songs/We Can Get Together - Icehouse/We Can Get Together - Icehouse - chart.xlsx")
-- openDocument("/Users/andrew/Downloads/MIDI-app-switch-v2.bmtp")


-- Run shell scripts in Terminal or iTerm2
-- runTerminalCommand("echo 'howdy'")
-- itermCommand("open -a Preview /Users/andrew/Dropbox/Music/Cover\\ Songs/_CB_CHARTS/*.pdf")

-- Disable capabilities that may affect performance (renable utility needed for post-gig)
disableSiri()
-- disableBluetooth() -- root login required

-- enableSiri()
-- enableBluetooth()

--------------------
-- Finally, let's get Gig Performer started!
--------------------

-- openDocument("/Users/musios/Documents/Gig Performer/Gig Files/demo.gig")



---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--    Supporting functions
--    You probably won't need to change below here
---------------------------------------------------------------------------------
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


on listConnectedAudioDevices()
	progress_next("Listing connected audio devices")
	
	set shellScript to "TEMP=\"$(mktemp -d)/audio-devices.txt\"; system_profiler -detailLevel basic SPAudioDataType > $TEMP; open -a TextEdit $TEMP"
	do shell script shellScript
end listConnectedAudioDevices

on listConnectedUSBDevices()
	progress_next("Listing connected USB devices")
	
	set shellScript to "TEMP=\"$(mktemp -d)/usb-devices.txt\"; system_profiler -detailLevel basic SPUSBDataType > $TEMP; open -a TextEdit $TEMP"
	do shell script shellScript
end listConnectedUSBDevices

on listConnectedBluetoothDevices()
	progress_next("Listing connected Bluetooth devices")
	
	set shellScript to "TEMP=\"$(mktemp -d)/bluetooth-devices.txt\"; system_profiler -detailLevel basic SPBluetoothDataType > $TEMP; open -a TextEdit $TEMP"
	do shell script shellScript
end listConnectedBluetoothDevices



-- Force the download of files in a path by recursively processing the contents (which forces the download)
on cloudDownload(path)
	progress_next("Ensure a local copy of: " & path)
	
	set shellScript to "find '" & path & "' -type f -exec wc {} \\;"
	-- display dialog shellScript buttons {"OK"} default button 1
	set report to do shell script shellScript
end cloudDownload


on checkNetAccess(site)
	progress_next("Checking network access to " & site)
	
	set shellScript to "TEMP=$(nc -z -G 5 " & site & " 80 2>&1); echo $TEMP"
	set report to do shell script shellScript
	
	if (offset of "succeeded" in report) is 0 then
		display dialog ("Network access failed to: " & site) buttons {"Continue", "Cancel"} default button "Cancel" with title "WARNING"
	end if
end checkNetAccess


on checkFileOrFolderAccessible(path)
	progress_next("Checking access to file: " & path)
	
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
	progress_next("Checking for connected audio device: " & deviceName)
	
	check_system_profiler("Audio device", "SPAudioDataType", deviceName)
end checkAudioDeviceConnected


on checkUSBDeviceConnected(deviceName)
	progress_next("Checking for connected USB device: " & deviceName)
	
	check_system_profiler("USB device", "SPUSBDataType", deviceName)
end checkUSBDeviceConnected


on checkBluetoothDeviceConnected(deviceName)
	progress_next("Checking for connected Bluetooth device: " & deviceName)
	
	check_system_profiler("Bluetooth device", "SPBluetoothDataType", deviceName)
end checkBluetoothDeviceConnected



on disableSiri()
	progress_next("Disabling Siri")
	
	set shellScript to "defaults write com.apple.assistant.support \"Assistant Enabled\" -bool false"
	do shell script shellScript
	
	set shellScript to "defaults write com.apple.Siri StatusMenuVisible -bool false"
	do shell script shellScript
end disableSiri

on enableSiri()
	progress_next("Enabling Siri")
	
	set shellScript to "defaults write com.apple.assistant.support \"Assistant Enabled\" -bool true"
	do shell script shellScript
	
	set shellScript to "defaults write com.apple.Siri StatusMenuVisible -bool true"
	do shell script shellScript
end enableSiri



on disableBluetooth()
	progress_next("Disabling Bluetooth")
	
	set shellScript to "sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0 && 
            sudo pkill bluetoothd && exit"
	itermCommand(shellScript)
end disableBluetooth

on enableBluetooth()
	progress_next("Enabling Bluetooth")
	
	set shellScript to "sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 1 && 
            sudo killall -HUP bluetoothd"
	itermCommand(shellScript)
end enableBluetooth



on openWebPage(browser, page)
	progress_next("Opening page in " & browser & ": " & page)
	
	tell application browser
		open location page
		activate
	end tell
end openWebPage


on openDocument(docPath)
	progress_next("Opening document: " & docPath)
	
	set targetPath to POSIX file docPath as alias
	tell application "Finder" to open targetPath
end openDocument


on itermCommand(cmd)
	progress_next("Running command in iTerm: " & cmd)
	
	tell application "iTerm"
		activate
		
		if gpWindow is missing value then
			set gpWindow to create window with default profile
			
			tell current session of gpWindow
				write text cmd
			end tell
		else
			tell current session of gpWindow
				set nextSession to split horizontally with default profile
				
				tell nextSession
					write text cmd
				end tell
			end tell
		end if
	end tell
end itermCommand


on runTerminalCommand(cmd)
	progress_next("Running command in Terminal: " & cmd)
	
	tell application "Terminal"
		do script cmd
		activate
	end tell
end runTerminalCommand


on progress_start(numSteps, description, descript_add)
	set numTasks to numSteps
	set taskNum to 0
	
	set progress total steps to numSteps
	set progress completed steps to taskNum
	set progress description to description
	set progress additional description to descript_add
end progress_start

on progress_next(message)
	set taskNum to taskNum + 1
	if taskNum > numTasks then
		set numTasks to numTasks + 1
	end if
	
	set progress additional description to message & " (" & taskNum & " of " & numTasks & ")"
	
	delay 0.1
end progress_next

on progress_end()
	set progress total steps to 0
	set progress completed steps to 0
	set progress description to ""
	set progress additional description to ""
end progress_end
