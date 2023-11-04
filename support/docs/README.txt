Junk In Your (Ship's) Trunk
===========================
by rux616

Version: 2.4.0

Table Of Contents
-----------------
- Junk In Your (Ship's) Trunk
    - Table Of Contents
- Overview
    - Summary
    - Cargo Expanders
    - Compatibility
    - List of Modules
    - Known Issues
- Installation
    - Upgrading
    - Mod Manager
    - Manual (NOT RECOMMENDED)
    - Archive Invalidation
- License
- Credits and Acknowledgements
- Contact


Overview
========

Summary
-------
(Adds additional orientations for ship cargo modules.)

Starfield's ship builder is amazing. While it places a number of reasonable constraints on us as we get the ability to make better and better ships, some of those constraints are just silly, and I want to fix that!

This mod tackles one of those constraints. It will let you mount cargo holds (and in the future, other components) in more positions and in different directions on your ship. Want that item to stick on the back, but it only sticks to the side right now? Come on in.

I've started small, with the Sextant 200CM Cargo Hold (shielded and non-shielded varieties), one of the first cargo components available to players. In vanilla Starfield, this piece only mounts to the sides of ships, now you can mount it on the front, back, top, and bottom as well. In fact, the first cargo module I added was the "aft" version of the Sextant 200CM Ballast Cargo Hold, so Junk In Your (Ship's) Trunk just seemed to fit.

I'll be adding other components in the future, so stay tuned; for now, try this out and let me know what you think!

Cargo Expanders
---------------
I know that some people use mods that increase the capacity of cargo modules by 3x or even 10x, so I've included a couple additional plugins that can adjust the capacity of the cargo modules touched by JIYT to match.

Compatibility
-------------
Better Ship Part Flips (https://www.nexusmods.com/starfield/mods/5953) by Freschu: Compatible with v0.1.0 (checked 2023-11-01)
Better Ship Part Snaps (https://www.nexusmods.com/starfield/mods/5698) by Freschu: Partial conflict with v0.3.0, put JIYT lower in your load order (checked 2023-11-01)
Ship Module Snap Expansion (SMSEX) (https://www.nexusmods.com/starfield/mods/6029) by Gilibran: Compatible with v1.0 (checked 2023-11-01)

List of Modules
---------------
Cargo:
- Sextant 100CM Ballast Cargo Hold
    - fore, port, and starboard (v2.1.0)
    - inverted aft, fore, port, and starboard (v2.1.0)
- Sextant 100CM Ballast Shielded Cargo Hold
    - fore, port, and starboard (v2.1.0)
    - inverted aft, fore, port, and starboard (v2.1.0)
- Sextant 200CM Ballast Cargo Hold
    - fore, aft (v1.0.0)
    - top fore-to-aft, top port-to-starboard, bottom fore-to-aft, bottom port-to-starboard (v1.1.0)
    - vertical fore, aft, port, and starboard (v2.0.0)
- Sextant 200CM Ballast Shielded Cargo Hold
    - fore, aft (v1.0.0)
    - top fore-to-aft, top port-to-starboard, bottom fore-to-aft, bottom port-to-starboard (v1.1.0)
    - vertical fore, aft, port, and starboard (v2.0.0)
- Sextant 300CM Ballast Cargo Hold
    - fore, aft (v2.0.0)
    - top fore-to-aft, top port-to-starboard, bottom fore-to-aft, bottom port-to-starboard (v2.0.0)
    - vertical fore, aft, port, and starboard (v2.0.0)
- Sextant 400CM Ballast Cargo Hold
    - fore, aft (v2.0.0)
    - top fore-to-aft, top port-to-starboard, bottom fore-to-aft, bottom port-to-starboard (v2.0.0)
    - vertical fore, aft, port, and starboard (v2.0.0)
- Sextant 10T Hauler Cargo Hold:
    - fore/aft top/bottom/port/starboard rotations (v2.2.0)
    - port/starboard top/bottom/fore/aft rotations (v2.2.0)
    - top fore/aft/port/starboard rotations (v2.2.0)
    - bottom port/starboard rotations (v2.2.0)
- Sextant 10ST Hauler Shielded Cargo Hold:
    - fore/aft top/bottom/port/starboard rotations (v2.2.0)
    - port/starboard top/bottom/fore/aft rotations (v2.2.0)
    - top fore/aft/port/starboard rotations (v2.2.0)
    - bottom port/starboard rotations (v2.2.0)
- Sextant 20T Hauler Cargo Hold:
    - bottom port-to-starboard (v2.3.0)
    - top fore-to-aft and port-to-starboard (v2.3.0)
    - fore/aft/port/starboard vertical/horizontal (v2.3.0)
- Sextant 30T Hauler Cargo Hold:
    - bottom/top fore/aft (v2.4.0)
    - fore/aft top/bottom/port/starboard (v2.4.0)
    - port/starboard top/bottom/fore/aft (v2.4.0)
- Sextant 40T Hauler Cargo Hold:
    - bottom/top fore/aft (v2.4.0)
    - fore/aft top/bottom/port/starboard (v2.4.0)
    - port/starboard top/bottom/fore/aft (v2.4.0)

Known Issues
------------
- Modules are clean. The vanilla ship modules have a number of decals like scorch marks, dirt streaks, etc. applied to them. Due to the method by which they are applied, I can't reasonably add them until we get access to the CK.
- Module icons (for the added orientations) in the Ship Builder are missing. This is another thing that is probably going to have to wait until we get access to the CK to get fixed.


Installation
============
NOTE: Requires Plugins.txt Enabler (https://www.nexusmods.com/starfield/mods/4157)

Upgrading
---------
When upgrading major versions (for example v1.whatever to v2.whatever), you need to do a clean install:
- Open the game and load your latest save
- Remove all JIYT-added modules from your ship
- Save your game, then quit
- Uninstall the previous version of the plugin and all its files
- Open the game and load your last save
- You will see a warning about missing the plugin you just uninstalled, choose to continue
- Save your game again, then quit
- Install the new version of the plugin

When upgrading non-major versions (for example v2.something to v2.something-else), you don't need to do anything except replace the installed mod files.

Mod Manager
-----------
Download and install the archive with either Mod Organizer 2 v2.5.0 Beta 14 or later (MO2 Discord server (https://discord.gg/AKE9wRGpy4), "dev-builds" channel), or Vortex (https://www.nexusmods.com/site/mods/1). I personally recommend Mod Organizer 2 (with the optional Root Builder (https://kezyma.github.io/?p=rootbuilder) plugin to use with SFSE or any other mod that requires files be put directly in the game's installation folder).

To enable plugins.txt support in Mod Organizer 2, set the "enable_plugin_management" option to "True" in the "Tools" menu -> "Settings" option -> "Plugins" tab -> "Game" section -> "Starfield Support Plugin" plugin.

Manual (NOT RECOMMENDED)
------------------------
Extract the archive to your Starfield installation's "Data" folder (typically something like "C:\Games\SteamLibrary\steamapps\common\Starfield\data"). Add the plugin file names to your plugins.txt file if they aren't already there, making sure the ones you want enabled are preceded with "*".

Archive Invalidation
--------------------
Make sure your `StarfieldCustom.ini` file in the "Documents\My Games\Starfield" folder (or your profile folder if using a mod manager and profiles) contains the following:

    [Archive]
    bInvalidateOlderFiles=1
    sResourceDataDirsFinal=


License
=======
All nif files are derived from original Starfield assets, so BGS own the copyright and control their usage.

For all other content, the following licenses apply:
- All code files are copyright 2023 Dan Cassidy, and are licensed under the GPL v3.0 or later (https://www.gnu.org/licenses/gpl-3.0.en.html).
- All non-code files are copyright 2023 Dan Cassidy, and are licensed under the CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/) license.


Credits and Acknowledgements
============================
hexabit: For a newer NifSkope release that supports the version of nif files that Starfield uses
ElminsterAU: For xEdit
Mod Organizer 2 team: For getting Mod Organizer 2 with Starfield support out the door so quickly
Nexus Mods: For mod hosting and for the Vortex Mod Manager
Avi: Help writing the summary to make it a bit less dry, and for helping to test this mod
Lively: For helping to test this mod
TheOGTennessee: For the idea to include 3x and 10x cargo capacity modifiers

This mod's repo contains the following programs, each having their own copyrights and licenses:

- 7-Zip 23.01 (2023-06-20) Console Executable by Igor Pavlov (https://www.7-zip.org/)
- BSArch v0.9c (part of xEdit 4.1.4u) by zilav, ElminsterAU, and Sheson (https://github.com/TES5Edit/TES5Edit)

Contact
=======
If you find a bug or have a question about the mod, please post it on the mod page at Nexus Mods (https://www.nexusmods.com/starfield/mods/5954), or in the GitHub project (https://github.com/rux616/starfield-junk-in-your-ships-trunk).

If you need to contact me personally, I can be reached through one of the following means:
- Nexus Mods: rux616 (https://www.nexusmods.com/users/124191) (Send a message via the "CONTACT" button.)
- Email: rux616-at-pm-dot-me (replace `-at-` with `@` and `-dot-` with `.`)
- Discord: rux616 (I am in the Nexus Mods (https://discord.gg/nexusmods), Collective Modding (https://discord.gg/pF9U5FmD6w) ("🔧-chaotic-cognitions" channel), and Lively's Modding Hub (https://discord.gg/livelymods) servers, amongst others. Make sure to "@" me.)
