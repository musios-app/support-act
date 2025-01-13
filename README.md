# Support Act

Support Act is a configurable AppleScript script to set up your Mac for a performance. Use it to check that your system is ready for the gig, then start up apps you need for your gig, and finally starts Gig Performer (or your preferred live software). You can also make another script to restore your settings after the gig too.

Visit the [Support Act page on musios.app](https://musios.app/projects/support-act/) for 

* Documentation
* Example scripts
* Installation

<div class="alert alert-warning" role="alert">
NOTE:
<li>This utility is for MacOS only because it uses AppleScript</li>
<li>This version is an early release thats needs wider testing</li>
<li>Developed and tested on macOS Sequoia 15.2 with Applescript version 2.8</li>
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
