---------------------------------------------------------------------------------
-- Configurable utility script that prepares for and starts up Gig Performer
-- 
-- Author: Andrew Hunt - andrew at musios.app
-- License: Creative Commons CC0 1.0 Universal
-- Documentation: https://musios.app
-- Source, comments: https://github.com/musios-app/gp-support-act
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------
-- Your configuration replaces this section
---------------------------------------------------------------------------------

-- Always initialize first
initialize()

-- Maintain a progress bar. It needs a rough number of tasks to be done
-- This sample script has 30 tasks, but you can adjust this as needed
progress_start(30, "GP Support Act", "Getting ready to perform!")

-- Light or dark mode for on-stage performance?
setDarkMode()
--setLightMode()

-- Check we have internet access (only if needed)
checkNetAccess("www.google.com")
checkNetAccess("www.musescore.com")

-- Check for required folders and files
checkFileOrFolderAccessible("/Volumes/MusicSSD/Instruments")
checkFileOrFolderAccessible("/Volumes/MusicSSD/Instruments/Native Instruments")
checkFileOrFolderAccessible("/Volumes/MusicSSD/Instruments/ROLI")
checkFileOrFolderAccessible("/Volumes/MusicSSD/Instruments/Spitfire/Spitfire Audio - BBC Symphony Orchestra")

-- Download folders & files that may be in cloud storage
cloudDownload("/Users/musios/Hey Bulldog - The Beatles")

-- Get lists of devices that are currently connected
-- Use the exact device names in the checks below
listConnectedAudioDevices()
listConnectedUSBDevices()
listConnectedBluetoothDevices()

-- Check that required audio devices are connected
checkAudioDeviceConnected("XPIANO73")
checkAudioDeviceConnected("FLOW8")
checkAudioDeviceConnected("Mac mini Speakers")

-- Check that required USB devices are connected
checkUSBDeviceConnected("XPIANO73")
checkUSBDeviceConnected("Stream Deck Plus")

-- Check that required Bluetooth devices are connected
checkBluetoothDeviceConnected("FS-1-WL")
checkBluetoothDeviceConnected("Seaboard Block JU4X")

-- Open web pages in your preferred browser
-- The browser name must be its exact Application name (without the .app extension)
openWebPage("Firefox", "https://musescore.com/official_scores/scores/6937415")
openWebPage("Google Chrome", "https://tabs.ultimate-guitar.com/tab/royal-blood/figure-it-out-official-2007289")

-- Open documents in their default application
openDocument("/Users/musios/charts/I'll forget you.pdf")
openDocument("/Users/musios/charts/Celebration - Kool & the Gang/Celebration.mscz")
openDocument("/Users/musios/charts/Song List.xlsx")
openDocument("/Users/musios/charts/text-doc.txt")
openDocument("/Users/musios/Documents/Bome MIDI Translator/Presets/Korg.bmtp")

-- Run shell scripts in Terminal or iTerm2
runTerminalCommand("echo 'howdy'")

itermCommand("open -a 'Bome MIDI Translator Pro' '/Users/musios/Documents/Bome MIDI Translator/Presets/Casio PX-5S.bmtp'")
itermCommand("open -a Preview /Users/musios/charts/*.pdf")

-- Finally, let's get Gig Performer started!
openDocument("/Users/musios/Documents/Gig Performer/Gig Files/demo.gig")


---------------------------------------------------------------------------------
--    Supporting functions
--    You probably won't need to change below here
---------------------------------------------------------------------------------

global gpWindow, numTasks, taskNum
set gpWindow to missing value
set numTasks to missing value
set taskNum to missing value


on initialize()
  set gpWindow to missing value
end initialize


-- Basic progress bar functions
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


-- Select dark or light mode
on setDarkMode()
	progress_next("Setting dark mode")

  tell application "System Events"
    tell appearance preferences
      set dark mode to true
    end tell
  end tell
end setDarkMode

on setLightMode()
	progress_next("Setting light mode")

  tell application "System Events"
    tell appearance preferences
      set dark mode to false
    end tell
  end tell
end setLightMode


-- Force the download of files in a path by recursively processing the contents (which forces the download)
-- This call can be slow due to the download process and possibly the time to count the files
on cloudDownload(path)
	progress_next("Ensure a local copy of: " & path)

  set shellScript to "find '" & path & "' -type f -exec wc {} \\;"

  try
    set report to do shell script shellScript
  on error errMsg number errNum
    display dialog ("Error: " & errMsg & " (Error number: " & errNum & ")") buttons {"Continue", "Cancel"} default button "Cancel" with title "WARNING"
  end try
end cloudDownload


-- Check network access to a site with netcat
on checkNetAccess(site)
	progress_next("Checking network access to " & site)

  set shellScript to "TEMP=$(nc -z -G 5 " & site & " 80 2>&1); echo $TEMP"
  set report to do shell script shellScript

  if (offset of "succeeded" in report) is 0 then
    display dialog ("Network access failed to: " & site) buttons {"Continue", "Cancel"} default button "Cancel" with title "WARNING"
  end if
end checkNetAccess


-- Check if a file or folder is accessible
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


-- List connected devices: audio, USB and Bluetooth
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


-- Utility wrapper around system_profiler
on check_system_profiler(dataTypeText, dataType, deviceName)
	set shellScript to "system_profiler -detailLevel full " & dataType

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


-- Use system_profiler to list attached devices
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


-- Open a web page in a browser
on openWebPage(browser, page)
	progress_next("Opening page in " & browser & ": " & page)

  tell application browser
    open location page
    activate
  end tell
end openWebPage


-- Open a document in its default application
on openDocument(docPath)
	progress_next("Opening document: " & docPath)

  set targetPath to POSIX file docPath as alias
  tell application "Finder" to open targetPath
end openDocument


-- Run a command in iTerm2
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


-- Run a command in Terminal app
on runTerminalCommand(cmd)
	progress_next("Running command in Terminal: " & cmd)

  tell application "Terminal"
    do script cmd
    activate
  end tell
end runTerminalCommand
