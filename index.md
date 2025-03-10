---
layout: default
title: Support Act
description: Utility scripts to prep your system for a gig
gitrepo: https://github.com/musios-app/support-act
tags: gig-performer utility script
image: /projects/support-act/assets/images/og-support-act.svg
icon: assets/images/gig-performer-icon-512x512.jpg
---


# Support Act

Support Act is a configurable AppleScript script to set up your Mac for a performance. Use it to check that your system is ready for the gig, then start up apps you need for your gig, and finally starts Gig Performer (or your preferred live software). You can also make another script to restore your settings after the gig too.

<div class="alert alert-warning" role="alert">
NOTE:
<li>This utility is for MacOS only because it uses AppleScript</li>
<li>This version is an early release thats needs wider testing</li>
<li>Developed and tested on macOS Sequoia 15.2 with Applescript version 2.8</li>
</div>


## Capabilities

<div class="next-list-check"></div>

<div class="container">
  <div class="row">
    <div class="col-4">
      <b>Set up your environment</b>
      <ul>
        <li> Audio devices for input, output and system alerts with volume </li>
        <li> Switch to light or dark mode </li>
        <li> Disable / enable Siri </li>
        <li> Disable / enable desktop widgets </li>
      </ul>
      <b>Misc tasks</b>
      <ul>
        <li> Popup reminders for manual tasks </li> 
        <li> Start Gig Performer with your Gig file </li> 
        <li> Run shell scripts </li> 
      </ul>
    </div>

    <div class="col-4">
      <b>Open applications, files and web pages:</b>
      <ul>
        <li> Chart files, playlists, lyrics... </li> 
        <li> MuseScore, Ultimate Guitar, lyrics </li> 
        <li> BOME and other MIDI Utilities </li> 
        <li> Web pages for lyrics, sheet music </li> 
        <li> Documents such as Word, Excel, Notes </li> 
        <li> Open documents like playlists, lyrics, etc. </li> 
      </ul> 
    </div>
    
    <div class="col-4">
      <b>Check connections:</b>
      <ul>
      <li> Internet connections and that specific sites are reachable </li> 
      <li> External storage </li>
      <li> Audio devices </li>
      <li> MIDI devices </li>
      <li> USB devices </li>
      <li> Bluetooth devices </li>
      </ul>
    </div>
  </div>
</div>

The implementation is intended to be resilient to errors. For example, if an external drive is missing, an audio device is not connected, or a web page is unreachable, then the script will offer you the option to continue or stop. (There are some limits to this that can be addressed in future versions.)

## Utilities

* This will become a table of contents (this text will be scrapped).
{:toc}


## Example

To create your own script open Apple's `Script Editor` application and create a new script. 

This example shows some things that can be done with support act. There's an explanation of each utility function below so that you can change and add actions to suit your rig and performance needs.

Need to restore your computer when you're back home? Just create a similar script that restores things for your studio.

```applescript
-- Setup for Friday night gig

tell script "support-act"  
  setDarkMode()
  disableSiri()
  hideDesktopWidgets()

  beep 1 -- get our attention

  -- When Support Act can't automate, popup user instructions
  showInstruction("Manual", "Enable Do Not Disturb mode")

  set steps to { "Open a terminal", "Run \"sudo lsof | grep MusicSSD\" " }
  showStepInstructions("Check usage of external drive", steps)

  -- Keep the computer awake with the screen on for 90 minutes
  startAmphetamineSession(90)

  -- Setup the audio and config
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

  -- Finally, let's kick off Gig Performer with the user's choice of Gig files
	set dir to "/Users/musios/Documents/Gig Performer/Gig Files"
	set gigFiles to {"gig-friday.gig", "thrash-klezmer.gig", "folktronica.gig"}
	set selected to chooseFile("Open which Gig file?" & return & dir & "...", gigFiles, dir)
	openDocument(selected)
end tell
```


#### Notes on AppleScript syntax

AppleScript is written to be human-readable. You don't need programming experience to create a Support Act script. Things that might help to know:

1. Text after 2 hyphens "--" is a comment
1. The `'¬'` character is a 'line continuation' character meaning that the current line continues on to the next line. I use it for arrays with many items. 
1. If you need to copy file names to the script, then you can drag and drop the file into the Script Editor window. The full path will be copied to the script.
1. Or... you can Copy the file in Finder then paste into the Script Editor window. The full path will be copied to the script.  You may need to remove the `\` backslash characters and/or add double quotes around the filename.
1. Need a simple notification? Try `beep 1` or `beep 11` for 1 or many alerts.
1. Put some text into the clipboard to save typing: `set the clipboard to "Example text"`.


## Install the Support Act script

[Support Act](https://github.com/musios-app/support-act) is maintained in GitHub.  To install, open the `Terminal` app from Application > Terminal.  Then copy and paste this entire command to do the installation or an update. It downloads the Support Act script and compiles it in your Script Libraries directory from where they can be utilitized by any script.

```
(cd ${HOME}/Library/Script\ Libraries && \
    curl -s https://raw.githubusercontent.com/musios-app/support-act/main/support-act.applescript -o support-act.applescript &&
    osacompile -o support-act.scpt support-act.applescript)
```

Alternatively, to install manually:

* Click on [support-act.applescript](https://raw.githubusercontent.com/musios-app/support-act/main/support-act.applescript) to download the script as source code
* Using Finder (or terminal), move the file from Downloads to the `Library/Script Libraries` in your home directory.


## Environment Utilities

### `setLightMode()`

### `setDarkMode()`

Switch your desktop to light or dark mode.

```applescript
tell script "support-act"
  setLightMode()
  setDarkMode()
end tell
```

### `showDesktopWidgets()`
### `hideDesktopWidgets()`

Show or hide widgets on the MacOS desktop and Stage Manager (if present).

```applescript
tell script "support-act"
  hideDesktopWidgets()
  showDesktopWidgets()
end tell
```


### `disableSiri()`
### `enableSiri()`

Siri and other Apple AI can compete for system resources. Disable Siri before a gig and re-enable afterwards (if you use Siri).

NOTE: on Sequoia 15.2, the menu bar icon for Siri does not update when Siri is enabled/disabled by this utility. Same for the Siri state in the System Settings. This appears to be a minor Mac issue.

```applescript
tell script "support-act"
  disableSiri()
  enableSiri()
end tell
```


### `startAmphetamineSession()`
### `endAmphetamineSession()`

[Amphetamine is a free app](https://apps.apple.com/app/amphetamine/id937984704) that prevents your Mac from sleeping and keeps the display on.

The recommended way to use Amphetamine is to create a "trigger" that will stop the computer from sleeping and keep the display **any time** you have Gig Performer running.

Support Act has a simple option to keep-alive for a number of minutes plus the corresponding end-session utility.

```applescript
tell script "support-act"
  startAmphetamineSession(90)
  endAmphetamineSession()
end tell
```


## Audio Utilities

### `listConnectedAudioDevices()`

Pops a text editor window with all the audio devices currently connected to your system. This is useful for getting the exact device names.

```applescript
tell script "support-act"
  listConnectedAudioDevices()
end tell
```


### `setSoundDevice(<type>, <deviceName>)`

<div class="alert alert-warning" role="alert">
NOTES: 
<li>This utility requires that a separate SwitchAudioSource app is installed from https://github.com/deweller/switchaudio-osx</li>
<li>This sets the computer's Sound Preferences. It is sufficient for many rigs but not more complex devices and systems.</li>
</div>

Select a sound device. The `type` must be one of `"input"`, `"output"` or `"alert"`. These correspond to the 3 devices in Mac's Sound Settings.  "Alert" is for beeps for mail, social media, system errors and all the other noise you don't want through front-of-house.

The device name must be exactly as listed by `listConnectedAudioDevices()`.

```applescript
tell script "support-act"
  setSoundDevice("input", "XPIANO73")
  setSoundDevice("output", "XPIANO73")
  setSoundDevice("alert", "Mac mini Speakers")
end tell
```

### `setVolume(<type>, <volumeLevel>)`

Set the volume of a sound device. The `type` must be one of `"input"`, `"output"` or `"alert"`. These correspond to the 3 devices in Mac's Sound Settings.  "Alert" is for beeps for mail, social media, system errors and all the other noise you don't want through front-of-house.

The `volumeLevel` must be an integer from 0-100 which is `-Inf DB` to `0dB`. For values in between, open Apple's "Audio MIDI Setup" application. Open the "Audio Devices" window. This shows the mapping from the integer volume level to dB level.  (For example, `50` is equivalent to `-6dB`)

```applescript
tell script "support-act"
  setVolume("input", 50)
  setVolume("output", 90)
  setVolume("alert", 50)
end tell
```

## Connectivity Utilities

### `checkNetAccess(<web address>)`

This function checks that the computer has internet access and that a specific site is reachable. You must provide a web address to check. For general checks a site like `www.google.com` is a good choice. If your performance relies on a specific site, then use that.

```applescript
tell script "support-act"
  checkNetAccess("www.google.com")
  checkNetAccess("www.musescore.com")
  checkNetAccess("127.0.0.1")
end tell
```

### `cloudDownload(<file-path>)`

Cloud storage like Dropbox, Google Drive, and iCloud have defauly mode of storing files in the cloud to space on your drive. But for music performance you want as much content stored on your disk as practice to avoid delays.

This function need to force a download files to your local drive so your performance isn't slowed.

Depending upon the size of the file or directory, this may take a while. It's recommended that you use the "Keep Local" option in your cloud storage app to keep the files on your computer.

```applescript
tell script "support-act"
  cloudDownload("/Users/musios/Hey Bulldog - The Beatles")
end tell
```

### `checkFileOrFolderAccessible(<disk-path>)`

Check that external disks are connected to ensure that plugin data, sheet music or other data is accessible.

```applescript
tell script "support-act"
  checkFileOrFolderAccessible("/Volumes/MusicSSD/Instruments")
end tell
```

Note: `checkFileOrFolderAccessible` does not force a download of cloud files. For that, use `cloudDownload()`.


### `checkAudioDevice(<device-name>)`

Check that a specific audio device is connected. 

```applescript
tell script "support-act"
  checkAudioDeviceConnected("EVO8")
  checkAudioDeviceConnected("FLOW8")

  checkAudioDeviceConnected("MacBook Air Speakers")
  checkAudioDeviceConnected("MacBook Air Microphone")
  
  checkAudioDeviceConnected("Mac mini Microphone")
end tell
```

Note: this check does NOT distinguish between input and output devices (but this doesn't normally matter).

To find out the exact names of your audio devices try one of these...

1. Use the `listConnectedAudioDevices()` function in the script,
2. Or, open the System Information app and navigate to the "Audio" section. The names of the devices are what you need to use in the script.
3. Or, use the `system_profiler SPAudioDataType` command in a terminal


### `checkUSBDevice(<device-name>)`

Check that a USB device is connected by providing the exact name.

```applescript
tell script "support-act"
  checkUSBDeviceConnected("XPIANO73")
  checkUSBDeviceConnected("Stream Deck Plus")
end tell
```

To find the exact names of your USB devices:

```applescript
tell script "support-act"
  listConnectedUSBDevices()
end tell
```

Or, open the MacOS System Information app and navigate to the "USB" section.

Or, open a terminal and run `system_profiler SPUSBDataType` 
and `system_profiler SPBluetoothDataType` command in a terminal


### `checkBluetoothDevice(<device-name>)`

Check that a Bluetooth device is connected by providing the exact name.

```applescript
tell script "support-act"
  checkBluetoothDeviceConnected("FS-1-WL")
  checkBluetoothDeviceConnected("Seaboard Block JU4X")
end tell
```

To find the exact names of your USB devices:

```applescript
tell script "support-act"
  listConnectedBlueoothDevices()
end tell
```

Or, open the MacOS System Information app and navigate to the "Bluetooth" section.

Or, open a terminal and run `system_profiler SPBluetoothDataType` 


## Documents & Apps

### `openWebPage(<browser>, <web-address>)`

Open a web page in your preferred browser, such as "Safari", "Google Chrome", "Arc", or "Firefox". Use the full name that appears in your Application list. 

```applescript
tell script "support-act"
  openWebPage("Firefox", "https://musescore.com/official_scores/scores/6937415")
  openWebPage("Google Chrome", "https://tabs.ultimate-guitar.com/tab/royal-blood/figure-it-out-official-2007289")
end tell
```

Note: Firefox is preferrable to Chromium-based browsers (Google Chrome, Safari, Arc, Brave...) because of it's lower memory footprint.


### `openDocument(<document-path>)`

The `openDocument` function opens a document in the default application that Finder would use. For example, a PDF will typically open in Preview, a text file in TextEdit, a spreadsheet in Excel and so on. 

Files for musical applications also work (if they work in Finder). For example, `.gig` files for Gig Performer, `.mscz` files for MuseScore, `.bmtp` files for BOME MIDI Translator, and many more.

```applescript
tell script "support-act"
  openDocument("/Users/musios/charts/I'll forget you.pdf")
  openDocument("/Users/musios/charts/Celebration - Kool & the Gang/Celebration.mscz")
  openDocument("/Users/musios/charts/Song List.xlsx")
  openDocument("/Users/musios/charts/text-doc.txt")
  openDocument("/Users/musios/Documents/Bome MIDI Translator/Presets/Korg.bmtp")
end tell
```

Notes: 

* Many songs names contain quote characters like single apostrophe. These may cause script issues. If so, consider removing the quotes character from the filename and script
* `openDocument` does not work with web pages
* It does not work with regular expressions to match multiple files. If you need to open multiple files, then use a terminal command (below) to open them all at once.


### `chooseFile(filenameList, [path])`

Utility that checks that files exist then provides the user a choice of files. The script returns the full path of a file that is confirmed to exist.

It provides the user an optional to cancel. It handles errors such empty lists and no valid Gig files.

```applescript
tell script "support-act"
	set dir to "/Users/musios/Documents/Gig Performer/Gig Files"
	set gigFiles to {"Decent Sampler/brass.gig", "gig-friday.gig", "bowie-tribute.gig", "template2.gig"}
	set selected to chooseFile("Open which Gig file?" & return & dir & "...", gigFiles, dir)

  openDocument(selected)
end tell
```


## Terminal & Command Utilities


### `runTerminalCommand(<command>)`

### `itermCommand(<command>)`

The `runTerminalCommand` and `itermCommand` functions each run a command in a terminal window - the first in the MacOS Terminal app and the second in iTerm2 (a popular alternative). 

This is useful for commands that need to be monitored or stopped (like web servers, MIDI utilities) as the terminal window will stay open after the command has run.

```applescript
tell script "support-act"
  runTerminalCommand("echo 'howdy'")

  itermCommand("open -a 'Bome MIDI Translator Pro' '/Users/musios/Documents/Bome MIDI Translator/Presets/Casio PX-5S.bmtp'")

  -- Open a folder full of PDF files in Preview
  itermCommand("open -a Preview /Users/musios/charts/*.pdf")
end tell
```

## Other Utilities

### `showInstruction(theTitle, theMessage)`

### `showStepInstructions(theTitle, theSteps)`

When something cannot be automated by Support Act, use a popup with instructions on how to perform a task manually.  This is useful to:

* Manually perform tasks that cannot be automated by Support Act (e.g. switch on hardware)
* Perform tasks that require synchonisation (e.g. switch on hardware at the right point in the Support Act sequence)
* Steps that require additional security (e.g. admin privileges)

```applescript
tell script "support-act"
  showInstruction("Turn on the mixer", "Turn on the mixer then press Continue")
end tell
```

```applescript
tell script "support-act"
  set theSteps to { ¬
    "In the menu bar, click the Dropbox icon", ¬
    "Find the sync status at the bottom on the Dropbox popup", ¬
    "Select \"Pause until tomorrow\"" ¬
  }

  showStepInstructions("Pause DropBox sync", theSteps)
end tell
```



### Finally, start Gig Performer

Once all the checks are complete, you can start Gig Performer with a specific Gig file. 

```applescript
tell script "support-act"
  openDocument("/Users/musios/Documents/Gig Performer/Gig Files/demo.gig")
end tell
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
* [#13](https://github.com/musios-app/support-act/issues/13) - Disable Spotlight indexing
* [#16](https://github.com/musios-app/support-act/issues/15) - List Rosetta apps in use

## Support & Feedback

Please send your feedback and suggestions about this new project.

The [GitHub issues page for support-act](https://github.com/musios-app/support-act/issues) is the best place questions, suggestions, bugs and requests. 

Alternatively, post a message on the Gig Performer forum. I'm there as "[Andrew](https://community.gigperformer.com/u/andrew/summary)".
