---------------------------------------------------------------------------------
-- Configurable utility script that prepares for and starts up Gig Performer
-- 
-- Author: Andrew Hunt - andrew at musios.app
-- License: Creative Commons CC0 1.0 Universal
-- Documentation & source: https://github.com/musios-app/gp-support-act
---------------------------------------------------------------------------------

set prepareScript to "cd \"$HOME/Library/Script Libraries\"; osacompile -o support-act.scpt support-act.applescript"
do shell script prepareScript


tell script "support-act"
	
	-- Select dark or light mode for performance
	setDarkMode()
	-- setLightMode()
	
	-- Check network access to required sites
	checkNetAccess("www.google.com")
	checkNetAccess("www.musescore.com")
	
	-- Download folders & files that may be in cloud storage	
	-- cloudDownload("/Users/musios/Hey Bulldog - The Beatles")
	
	-- Check for required folders and files	(e.g. on an external drive)
	-- checkFileOrFolderAccessible("/Volumes/musiosSSD/Instruments")
	-- checkFileOrFolderAccessible("/Volumes/musiosSSD/Instruments/Native Instruments")
	-- checkFileOrFolderAccessible("/Volumes/musiosSSD/Instruments/ROLI")
	-- checkFileOrFolderAccessible("/Volumes/musiosSSD/Instruments/Spitfire/Spitfire Audio - BBC Symphony Orchestra")
	
	-- List external devices: audio, USB, bluetooth
	listConnectedAudioDevices()
	listConnectedUSBDevices()
	listConnectedBluetoothDevices()
	
	-- Check that required audio devices are connected
	checkAudioDeviceConnected("MacBook Air Speakers")
	checkAudioDeviceConnected("MacBook Air Microphone")
	checkAudioDeviceConnected("EVO8")
	
	-- Check that required USB & Bluetooth devices are connected	
	checkUSBDeviceConnected("XPIANO73")
	checkUSBDeviceConnected("Stream Deck Plus")
	
	checkBluetoothDeviceConnected("FS-1-WL")
	
	-- Open web pages in your preferred browser	
	-- set browser to "Safari"
	-- set browser to "Google Chrome"
	set browser to "Firefox"
	
	openWebPage(browser, "https://musescore.com/official_scores/scores/6937415")
	openWebPage(browser, "https://tabs.ultimate-guitar.com/tab/royal-blood/figure-it-out-official-2007289")
	
	-- Open documents
	openDocument("/Users/musios/charts/All Torn Down.pdf")
	openDocument("/Users/musios/charts/Celebration - Kool & the Gang/Celebration.mscz")
	openDocument("/Users/musios/charts/Song List.xlsx")
	openDocument("/Users/musios/charts/text-doc.txt")
	openDocument("/Users/musios/Documents/Bome MIDI Translator/Presets/Korg.bmtp")
	
	-- Run shell scripts in Terminal or iTerm2	
	runTerminalCommand("echo 'howdy'")
	
	itermCommand("open -a 'Bome MIDI Translator Pro' '/Users/musios/Documents/Bome MIDI Translator/Presets/Casio PX-5S.bmtp'")
	itermCommand("open -a Preview /Users/musios/charts/*.pdf")
	
	-- Finally, start our performance software] Gig Performer started!	
	openDocument("/Users/musios/Documents/Gig Performer/Gig Files/demo.gig")
	
end tell
