---
layout: default
title: Support Act
description: AppleScript utilities to support your <a href="https://gigperformer.com/">Gig Performer</a> habit. Use it to check that your system is ready for the gig, then start up apps you need for your gig, and finally starts Gig Performer. It can do a long list of checks and actions that get your system ready for GP. Oh, you can also make another script to restore your settings after the gig too.
gitrepo: https://github.com/musios-app/support-act
tags: gig-performer utility script
image: assets/images/gig-performer-icon-512x512.jpg
---

# Support Act

Support Act is a configurable AppleScript script to set up your Mac for a performance. Use it to check that your system is ready for the gig, then start up apps you need for your gig, and finally starts Gig Performer (or your preferred live software). You can also make another script to restore your settings after the gig too.

<div class="alert alert-warning" role="alert">
NOTE:
<li>This utility is for MacOS only because it uses AppleScript</li>
<li>This version is an early release thats needs wider testing</li>
</div>


## Capabilities

<div class="next-list-check"></div>

* Check connections:
  * Internet connections and that specific sites are reachable
  * External storage
  * Audio devices
  * MIDI devices
  * USB devices
  * Bluetooth devices
* Set up your audio devices
* Open applications, files and web pages:
  * Chart files, playlists, lyrics...
  * MuseScore, Ultimate Guitar, lyrics
  * BOME and other MIDI Utilities
  * Web pages for lyrics, sheet music
  * Documents such as Word, Excel, Notes
  * Open documents like playlists, lyrics, etc.
* Other environment setup
  * Switch to light or dark mode
* Start Gig Performer with your Gig file
* And most other tasks you need that can be run from the command line


The implementation is intended to be resilient to errors. For example, if an external drive is missing, an audio device is not connected, or a web page is unreachable, then the script will offer you the option to continue or stop. (There are some limits to this that can be addressed in future versions.)

## Example

To create your own script open Apple's `Script Editor` application and create a new script. 

This example shows some things that can be done with support act. There's an explanation of each utility function below so that you can change and add actions to suit your rig and performance needs.

Need to restore your computer when you're back home? Just create a similar script that restores things for your studio.

```applescript
-- Setup for Friday night gig

tell script "support-act"  
  setDarkMode()
  disableSiri()
  
  showInstruction("Manual", "Enable Do Not Disturb mode")

  checkAudioDeviceConnected("FLOW8")
  setSoundDevice("input", "FLOW8")
  setSoundDevice("output", "FLOW8")
  setVolume("input", 50)
  setVolume("output", 90) -- about -1dB

  checkUSBDeviceConnected("XPIANO73")

  -- No beeps through FOH speakers!
  setSoundDevice("alert", "Mac mini Speakers")
  setVolume("alert", 20)

  checkNetAccess("www.musescore.com")

  checkFileOrFolderAccessible("/Volumes/ExternalSSD/Instruments")
  openDocument("/Users/musios/Documents/Bome MIDI Translator/Presets/numa-x-piano73.bmtp")
  openWebPage("Google Chrome", "https://musescore.com/official_scores/scores/6937415")
  openDocument("/Users/musios/charts/Let me entertain you - Robbie Williams.pdf")
  openDocument("/Users/musios/Documents/Gig Performer/Gig Files/practice.gig")
end tell
```

#### Notes on AppleScript syntax

AppleScript is written to be human-readable. You don't need programming experience to modify the script. Two things that might help to know:

1. Text after "--" is a comment (that's 2 hyphens)
1. The `'¬'` character is a 'line continuation' character meaning that the current line continues on to the next line. I use it for arrays with many items. 
1. If you need to copy file names to the script, then you can drag and drop the file into the Script Editor window. The full path will be copied to the script.
1. Or... you can Copy the file in Finder then paste into the Script Editor window. The full path will be copied to the script.  You may need to remove the `\` backslash characters and/or add double quotes around the filename.


## Install the Support Act script

[Support act](https://github.com/musios-app/support-act/releases) is maintained in GitHub in the [`support-act`](https://github.com/musios-app/support-act) repository.

1. Got to the script page for [support-act.applescript](https://github.com/musios-app/support-act/blob/main/support-act.applescript)
1. Click the download button 
1. Now in Finder, open your Downloads directory and Copy the file `support-act.applescript`
1. Also in Finder, use the "Go -> Go to folder..."
1. Enter "~/Library" then hit Return
1. Right-click (or Ctrl-click) on "Script Libraries" then "Services > New Terminal in Folder". 
1. Before using the terminal, open the "Script Libraries" (double-click)
1. Paste the `support-act.applescript` file
1. In the terminal, run this command `osacompile -o support-act.scpt support-act.applescript`
1. Check that there is now a file `support-act.scpt`


## Utility functions

### `setLightMode(); setDarkMode()`

Switch your desktop to light or dark mode.

```applescript
setLightMode()
setDarkMode()
```

### `disableSiri(); enableSiri()`

Siri and other Apple AI can compete for system resources. Disable Siri before a gig and re-enable afterwards (if you use Siri).

NOTE: on Sequoia 15.2, the menu bar icon for Siri does not update when Siri is enabled/disabled by this utility. Same for the Siri state in the System Settings. This appears to be a minor Mac issue.

```applescript
disableSiri()
enableSiri()
```


### `listConnectedAudioDevices()`

Pops a text editor window with all the audio devices currently connected to your system. This is useful for getting the exact device names.

```applescript
listConnectedAudioDevices()
```


### `setSoundDevice(<type>, <deviceName>)`

<div class="alert alert-warning" role="alert">
NOTES: 

* This utility requires that a separate SwitchAudioSource app is installed from https://github.com/deweller/switchaudio-osx
* This sets the computer's Sound Preferences. It is sufficient for many rigs but not more complex devices and systems.
</div>

Select a sound device. The `type` must be one of `"input"`, `"output"` or `"alert"`. These correspond to the 3 devices in Mac's Sound Settings.  "Alert" is for beeps for mail, social media, system errors and all the other noise you don't want through front-of-house.

The device name must be exactly as listed by `listConnectedAudioDevices()`.

```applescript
setSoundDevice("input", "XPIANO73")
setSoundDevice("output", "XPIANO73")
setSoundDevice("alert", "Mac mini Speakers")
```

### `setVolume(<type>, <volumeLevel>)`

Set the volume of a sound device. The `type` must be one of `"input"`, `"output"` or `"alert"`. These correspond to the 3 devices in Mac's Sound Settings.  "Alert" is for beeps for mail, social media, system errors and all the other noise you don't want through front-of-house.

The `volumeLevel` must be an integer from 0-100 which is `-Inf DB` to `0dB`. For values in between, open Apple's "Audio MIDI Setup" application. Open the "Audio Devices" window. This shows the mapping from the integer volume level to dB level.  (For example, `50` is equivalent to `-6dB`)

```applescript
setVolume("input", 50)
setVolume("output", 90)
setVolume("alert", 50)
```

### `checkNetAccess(<web address>)`

This function checks that the computer has internet access and that a specific site is reachable. You must provide a web address to check. For general checks a site like `www.google.com` is a good choice. If your performance relies on a specific site, then use that.

```applescript
checkNetAccess("www.google.com")
checkNetAccess("www.musescore.com")
checkNetAccess("127.0.0.1")
```

### `cloudDownload(<file-path>)`

Cloud storage like Dropbox, Google Drive, and iCloud have defauly mode of storing files in the cloud to space on your drive. But for music performance you want as much content stored on your disk as practice to avoid delays.

This function need to force a download files to your local drive so your performance isn't slowed.

Depending upon the size of the file or directory, this may take a while. It's recommended that you use the "Keep Local" option in your cloud storage app to keep the files on your computer.

```applescript
cloudDownload("/Users/musios/Hey Bulldog - The Beatles")
```

### `checkFileOrFolderAccessible(<disk-path>)`

Check that external disks are connected to ensure that plugin data, sheet music or other data is accessible.

```applescript
checkFileOrFolderAccessible("/Volumes/MusicSSD/Instruments")
```

Note: `checkFileOrFolderAccessible` does not force a download of cloud files. For that, use `cloudDownload()`.


### `checkAudioDevice(<device-name>)`

Check that a specific audio device is connected. 

```applescript
checkAudioDeviceConnected("EVO8")
checkAudioDeviceConnected("FLOW8")
checkAudioDeviceConnected("MacBook Air Speakers")
checkAudioDeviceConnected("MacBook Air Microphone")
```

Note: this check does NOT distinguish between input and output devices (but this doesn't normally matter).

To find out the exact names of your audio devices try one of these...

1. Use the `listConnectedAudioDevices()` function in the script,
2. Or, open the System Information app and navigate to the "Audio" section. The names of the devices are what you need to use in the script.
3. Or, use the `system_profiler SPAudioDataType` command in a terminal


### `checkUSBDevice(<device-name>)`

Check that a USB device is connected by providing the exact name.

```applescript
checkUSBDeviceConnected("XPIANO73")
checkUSBDeviceConnected("Stream Deck Plus")
```

To find the exact names of your USB devices:

```applescript
listConnectedUSBDevices()
```

Or, open the MacOS System Information app and navigate to the "USB" section.

Or, open a terminal and run `system_profiler SPUSBDataType` 
and `system_profiler SPBluetoothDataType` command in a terminal


### `checkBluetoothDevice(<device-name>)`

Check that a Bluetooth device is connected by providing the exact name.

```applescript
checkBluetoothDeviceConnected("FS-1-WL")
checkBluetoothDeviceConnected("Seaboard Block JU4X")
```

To find the exact names of your USB devices:

```applescript
listConnectedBlueoothDevices()
```

Or, open the MacOS System Information app and navigate to the "Bluetooth" section.

Or, open a terminal and run `system_profiler SPBluetoothDataType` 



### `openWebPage(<browser>, <web-address>)`

Open a web page in your preferred browser, such as "Safari", "Google Chrome", "Arc", or "Firefox". Use the full name that appears in your Application list. 

```applescript
openWebPage("Firefox", "https://musescore.com/official_scores/scores/6937415")
openWebPage("Google Chrome", "https://tabs.ultimate-guitar.com/tab/royal-blood/figure-it-out-official-2007289")
```

Note: Firefox is preferrable to Chromium-based browsers (Google Chrome, Safari, Arc, Brave...) because of it's lower memory footprint.


### `openDocument(<document-path>)`

The `openDocument` function opens a document in the default application that Finder would use. For example, a PDF will typically open in Preview, a text file in TextEdit, a spreadsheet in Excel and so on. 

Files for musical applications also work (if they work in Finder). For example, `.gig` files for Gig Performer, `.mscz` files for MuseScore, `.bmtp` files for BOME MIDI Translator, and many more.

```applescript
openDocument("/Users/musios/charts/I'll forget you.pdf")
openDocument("/Users/musios/charts/Celebration - Kool & the Gang/Celebration.mscz")
openDocument("/Users/musios/charts/Song List.xlsx")
openDocument("/Users/musios/charts/text-doc.txt")
openDocument("/Users/musios/Documents/Bome MIDI Translator/Presets/Korg.bmtp")
```

Notes: 

* Many songs names contain quote characters like single apostrophe. These may cause script issues. If so, consider removing the quotes character from the filename and script
* `openDocument` does not work with web pages
* It does not work with regular expressions to match multiple files. If you need to open multiple files, then use a terminal command (below) to open them all at once.




### `runTerminalCommand(<command>)`

### `itermCommand(<command>)`

The `runTerminalCommand` and `itermCommand` functions each run a command in a terminal window - the first in the MacOS Terminal app and the second in iTerm2 (a popular alternative). 

This is useful for commands that need to be monitored or stopped (like web servers, MIDI utilities) as the terminal window will stay open after the command has run.

```applescript
runTerminalCommand("echo 'howdy'")

itermCommand("open -a 'Bome MIDI Translator Pro' '/Users/musios/Documents/Bome MIDI Translator/Presets/Casio PX-5S.bmtp'")

-- Open a folder full of PDF files in Preview
itermCommand("open -a Preview /Users/musios/charts/*.pdf")
```


### `showInstruction(theTitle, theMessage)`

### `showStepInstructions(theTitle, theSteps)`

When something cannot be automated by Support Act, use a popup with instructions on how to perform a task manually.  This is useful to:

* Manually perform tasks that cannot be automated by Support Act (e.g. switch on hardware)
* Perform tasks that require synchonisation (e.g. switch on hardware at the right point in the Support Act sequence)
* Steps that require additional security (e.g. admin privileges)

```applescript
showInstruction("Turn on the mixer", "Turn on the mixer then press Continue")
```

```applescript
set theSteps to { ¬
  "In the menu bar, click the Dropbox icon", ¬
  "Find the sync status at the bottom on the Dropbox popup", ¬
  "Select \"Pause until tomorrow\"" ¬
}

showStepInstructions("Pause DropBox sync", theSteps)
```



### Finally, start Gig Performer

Once all the checks are complete, you can start Gig Performer with a specific Gig file. 

```applescript
openDocument("/Users/musios/Documents/Gig Performer/Gig Files/demo.gig")
```


## Roadmap, Security & MacOS changes

Most MacOS major releases (Monterey, Ventura, Sonoma, Sequoia etc.) introduce changes that affect the desktop design and security model. 
For a tool like Support Act, this makes it challenging maintain a stable version across the varients.

Some important utility functions that are not yet implemented for security:

* Disable internet connection (requires admin permission)
* [#20](https://github.com/musios-app/support-act/issues/20) - Enable "Do Not Disturb" mode (the terminal commands and UI have changed)
* [#19](https://github.com/musios-app/support-act/issues/19) - Disabling CPU-hogging daemons (requires admin permission and care)

## WIP / Roadmap

I think these a priorities from the [Issues](https://github.com/musios-app/support-act/issues) list.
I still need to determine which ones can be achieved correctly and safely from the script.

* [#21](https://github.com/musios-app/support-act/issues/21) - Run a user-defined shortcut
* [#8](https://github.com/musios-app/support-act/issues/8) - Disable desktop widgets
* [#10](https://github.com/musios-app/support-act/issues/10) - Disable sleep and screen saver (or start Amphetimine)
* [#13](https://github.com/musios-app/support-act/issues/13) - Disable Spotlight indexing
* [#16](https://github.com/musios-app/support-act/issues/15) - List Rosetta apps in use

## Support & Feedback

Please send your feedback and suggestions about this new project.

The [GitHub issues page for support-act](https://github.com/musios-app/support-act/issues) is the best place questions, suggestions, bugs and requests. 

Alternatively, post a message on the Gig Performer forum. I'm there as "[Andrew](https://community.gigperformer.com/u/andrew/summary)".


