Junk In Your (Ship's) Trunk
===========================
by rux616

Version: 2.20.0

Table Of Contents
-----------------
- Junk In Your (Ship's) Trunk
    - Table Of Contents
- Overview
    - Summary
    - Cargo Expanders
    - Compatibility
    - Known Issues
- Installation
    - Requirements
    - Upgrading
    - Mod Manager
    - Manual (NOT RECOMMENDED)
    - Archive Invalidation
- License
- Credits and Acknowledgements
- Contact
- List of Modules


Overview
========

Summary
-------
(Cargo holds, fuel tanks, grav drives, shields, weapons. You want variety? We got variety. Adds new flips and decorative versions of many different ship modules.)

NOTE: Now requires Ship Builder Categories (https://www.nexusmods.com/starfield/mods/7310) - you will get a CTD without it installed and above this mod in your load order!

You want variety? We got variety! Up? Yes! Down? Also yes! Left? Still yes! Right? You get three guesses, and the first two don't count! The JIYT Consortium is proud to offer an additional 455 cargo, 444 shield, 309 fuel tank, and 920 grav drive flips/orientations/variants over and above the defaults. Want that module to stick on the back, but it only sticks to the side right now? Come on in.

But wait, there's more! As a bonus, you also get additional decorative versions of all of them! Plus weapons! That's right! All the looks with only a fraction of the cost or weight. And none of the functionality, but who cares about that when your ship looks this good, am I right? You can find these marvelous new modules in the various "Decorative [...]" categories in the Ship Builder.

There are even some additional snap points added so you can do interesting things like putting certain "vertical" modules next to something else, though only for cargo holds and grav drives at the moment; more modules will be converted in the future. (The JIYT Consortium is not responsible for any cursed creations you make with this feature.)

For a complete listing of all modules provided, please see the "List of Modules" section at the bottom of this document.

Cargo Expanders
---------------
I know that some people use mods that increase the capacity of cargo modules by 3x or even 10x, so I've included a couple additional plugins that can adjust the capacity of the cargo modules touched by JIYT to match.

Compatibility
-------------
- All ship parts unlevelled at all vendors (ESM) (https://www.nexusmods.com/starfield/mods/6060) by SKK50: [Patch required] Depending on whether JIYT or this mod is set to higher priority, either some parts simply won't show up or will still have level or vendor requirements. Use the included compatibility patch. (checked 2024-04-16; version 002)
- Avontech Shipyards (https://www.nexusmods.com/starfield/mods/8057) by kaosnyrb: Fully compatible. (checked 2024-04-16; version 1.2.0)
- Better Ship Part Flips (https://www.nexusmods.com/starfield/mods/5953) by Freschu: Fully compatible. (checked 2024-04-16; version 0.5.0)
- Better Ship Part Snaps (https://www.nexusmods.com/starfield/mods/5698) by Freschu: If using the Ship Colorize compatibility patch, there is an additional patch (included) that should be used to restore feature parity with Better Ship Part Snaps. Note the flips added by JIYT won't usually have any particularly enhanced snaps. (checked 2024-04-16; version 0.3.0)
- DerreTech (https://www.nexusmods.com/starfield/mods/5686) by DerekM17x: Fully compatible. (checked 2024-04-16; version 1.7.7b)
- Ship Colorize (https://www.nexusmods.com/starfield/mods/7003) by DerekM17x: [Patch required] Changes made by Ship Colorize to the Dogstar StorMax 40/60 Cargo Holds won't show up or the flips will be weird, depending on which mod wins the conflict. Additionally, the Reladyne Class C J-5x grav drives and the the Ballistic 600T fuel tank won't have their modified color changes available. Use the included compatibility patch. (checked 2024-04-16; version 1.0.8)
- Ship Module Snap Expansion (https://www.nexusmods.com/starfield/mods/6029) by Gilibran: Fully compatible with all-in-one plugin; other plugins not checked - use at your own risk. (checked 2024-04-16; version 1.0.1)
- Starfield Extended - Shields Rebalanced (https://www.nexusmods.com/starfield/mods/6238) by Gambit77: [Patch required] Shields will either be missing flips or not have higher health, depending on which mod wins the conflict. Use the included compatibility patch. (checked 2024-04-16; version 1.0)
- TN's Ship Modifications All in One (https://www.nexusmods.com/starfield/mods/6376) by TheOGTennessee: [Patch required] Decoratives will conflict, and also some cargo hold capacity will be different, depending on which mod wins the conflicts. Use the compatibility patch available on the TN's Ship Modifications All in One mod page. (checked 2024-04-16; version v2.0.2)
- Ultimate Shipyards Unlocked (https://www.nexusmods.com/starfield/mods/4723) by JustAnOrdinaryGuy: [Patch required] Incompatibilities with the All In One plugin, and the "No Level Requirements" and "Quest Rewards" modules from the modular version. Use the included compatibility patch/patches. (checked 2024-04-16; version 1.4)

Known Issues
------------
- Module icons (for the added orientations) in the Ship Builder are missing. This is another thing that is probably going to have to wait until we get access to the CK to get fixed.
- Some modules (shields, for example) don't really visually attach to certain other modules in certain orientations well. Bethesda did a really good job designing a modular ship system with one major exception: the visual attachment points. There is one style of attachment points for fore/aft, a different style for port/starboard, and yet another style for top/bottom. Because none of them match, some module variants/orientations just don't look right when attaching to others. I'm not redesigning or redoing all the 3D models for every ship part in the game (yet, at least. lol), so if some modules don't match quite in the way you want them to and it bothers you that much, you're going to either need to not use that particular variant/orientation combination, or find a different combination that _does_ work.
- Protectorate Caravel V101, V102, V103, and V104 Cargo Holds have some snap points slightly misaligned in vertical orientations (and a couple others). The snap points are not actually misaligned, the model is, and will thus need to wait until the CK is released to get fixed.


Installation
============
Requirements
------------
- Plugins.txt Enabler (https://www.nexusmods.com/starfield/mods/4157)
- Ship Builder Categories (https://www.nexusmods.com/starfield/mods/7310)

Upgrading
---------
When upgrading non-major versions (for example v2.something to v2.something-else), you don't need to do anything except replace the installed mod files.

When upgrading major versions (for example v1.whatever to v2.whatever), you need to do a clean install:
- Open the game and load your latest save
- Remove all JIYT-added modules from your ship
- Save your game, then quit
- Uninstall the previous version of the plugin and all its files
- Open the game and load your last save
- You will see a warning about missing the plugin you just uninstalled, choose to continue
- Save your game again, then quit
- Install the new version of the plugin

Mod Manager
-----------
Download and install both the archive for this mod and for any required mods with either Mod Organizer 2 (https://github.com/ModOrganizer2/modorganizer/releases) (version 2.5.0 or later) or Vortex (https://www.nexusmods.com/site/mods/1). I personally recommend Mod Organizer 2 (with the optional Root Builder (https://kezyma.github.io/?p=rootbuilder) plugin to use with SFSE or any other mod that requires files be put directly in the game's installation folder). Ensure that the plugins of the required mods are ABOVE the plugins from this one in your load order.

Manual (NOT RECOMMENDED)
------------------------
Extract the archive to your Starfield installation's "Data" folder (typically something like "C:\Games\SteamLibrary\steamapps\common\Starfield\data"). Add the plugin file names to your plugins.txt file if they aren't already there, making sure the ones you want enabled are preceded by an asterisk ("`*`"). Make sure that the plugins from the required mods are ABOVE the plugins from this mod and are also enabled, or you will get a CTD.

Archive Invalidation
--------------------
Make sure your `StarfieldCustom.ini` file in the "Documents\My Games\Starfield" folder (or your profile folder if using a mod manager and profiles) contains the following:

    [Archive]
    bInvalidateOlderFiles=1
    sResourceDataDirsFinal=


License
=======
- All code files are copyright 2023, 2024 Dan Cassidy, and are licensed under the GPL v3.0 or later (https://www.gnu.org/licenses/gpl-3.0.en.html).
- All non-code files are copyright 2023, 2024 Dan Cassidy, and are licensed under the CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/) license.


Credits and Acknowledgements
============================
hexabit: For a newer NifSkope release that supports the version of nif files that Starfield uses
ElminsterAU: For xEdit
Mod Organizer 2 team: For getting Mod Organizer 2 with Starfield support out the door so quickly
Nexus Mods: For mod hosting and for the Vortex Mod Manager
Avi: Help writing the summary to make it a bit less dry, and for helping to test this mod
Lively: For helping to test this mod
TheOGTennessee: For the idea to include 3x and 10x cargo capacity modifiers
Freschu: For developing a really handy xEdit script that makes my life easier, and helping me with the rotate_cell_contents xedit script
fireundubh: For adding the trig functions to xEdit that were necessary to make my rotate_cell_contents script possible

This mod's repo contains the following programs, each having their own copyrights and licenses:

- 7-Zip 23.01 (2023-06-20) Console Executable by Igor Pavlov (https://www.7-zip.org/)
- BSArch v0.9c (part of xEdit 4.1.4u) by zilav, ElminsterAU, and Sheson (https://github.com/TES5Edit/TES5Edit)
- SpriggitCLI v0.18 by Noggog (https://github.com/Mutagen-Modding/Spriggit)


Contact
=======
If you find a bug or have a question about the mod, please post it on the mod page at Nexus Mods (https://www.nexusmods.com/starfield/mods/5954), or in the GitHub project (https://github.com/rux616/starfield-junk-in-your-ships-trunk).

If you need to contact me personally, I can be reached through one of the following means:
- Nexus Mods: rux616 (https://www.nexusmods.com/users/124191) (Send a message via the "CONTACT" button.)
- Email: rux616-at-pm-dot-me (replace `-at-` with `@` and `-dot-` with `.`)
- Discord: rux616 (user ID 234489279991119873) - make sure to "@" me
    - Lively's Modding Hub (https://discord.gg/livelymods)
    - Nexus Mods (https://discord.gg/nexusmods)
    - Collective Modding (https://discord.gg/pF9U5FmD6w) ("🔧-chaotic-cognitions" channel)
    - Starfield Modding (https://discord.gg/6R4Yq5KjW2)


List of Modules
===============
Cargo Holds:
- Dogstar StorMax 30 Cargo Hold (v2.10.0)
- Dogstar StorMax 40 Cargo Hold (v2.10.0)
- Dogstar StorMax 50 Cargo Hold (v2.10.0)
- Dogstar StorMax 60 Cargo Hold (v2.10.0)
- Panoptes da Gama 1000 Cargo Hold (v2.8.0)
- Panoptes da Gama 1000 Shielded Cargo Hold (v2.8.0)
- Panoptes da Gama 1010 Cargo Hold (v2.8.0)
- Panoptes da Gama 1010 Shielded Cargo Hold (v2.8.0)
- Panoptes da Gama 1020 Cargo Hold (v2.8.0)
- Panoptes Polo 2000 Cargo Hold (v2.10.0)
- Panoptes Polo 2010 Cargo Hold (v2.10.0)
- Panoptes Polo 2020 Cargo Hold (v2.10.0)
- Panoptes Polo 2030 Cargo Hold (v2.10.0)
- Protectorate Caravel V101 Cargo Hold (v2.5.0)
- Protectorate Caravel V101 Shielded Cargo Hold (v2.5.0)
- Protectorate Caravel V102 Cargo Hold (v2.6.0)
- Protectorate Caravel V102 Shielded Cargo Hold (v2.6.0)
- Protectorate Caravel V103 Cargo Hold (v2.7.0)
- Protectorate Caravel V104 Cargo Hold (v2.7.0)
- Protectorate Galleon S201 Cargo Hold (v2.9.0)
- Protectorate Galleon S202 Cargo Hold (v2.9.0)
- Protectorate Galleon S203 Cargo Hold (v2.9.0)
- Protectorate Galleon S204 Cargo Hold (v2.9.0)
- Sextant Ballast 100CM Cargo Hold (v2.1.0)
- Sextant Ballast 100CM Shielded Cargo Hold (v2.1.0)
- Sextant Ballast 200CM Cargo Hold (v1.0.0, v1.1.0, v2.0.0)
- Sextant Ballast 200CM Shielded Cargo Hold (v1.0.0, v1.1.0, v2.0.0)
- Sextant Ballast 300CM Cargo Hold (v2.0.0)
- Sextant Ballast 400CM Cargo Hold (v2.0.0)
- Sextant Hauler 10T Cargo Hold (v2.2.0)
- Sextant Hauler 10ST Shielded Cargo Hold (v2.2.0)
- Sextant Hauler 20T Cargo Hold (v2.3.0)
- Sextant Hauler 30T Cargo Hold (v2.4.0)
- Sextant Hauler 40T Cargo Hold (v2.4.0)
Fuel Tanks:
- Ballistic 100G Fuel Tank (v2.14.0)
- Ballistic 200G Fuel Tank (v2.14.0)
- Ballistic 300G Fuel Tank (v2.14.0)
- Ballistic 400G Fuel Tank (v2.14.0)
- Ballistic 500T Fuel Tank (v2.14.0)
- Ballistic 600T Fuel Tank (v2.14.0)
- Ballistic 700T Fuel Tank (v2.14.0)
- Ballistic 800T-A Fuel Tank (v2.14.0)
- Ballistic 800T-B Fuel Tank (v2.14.0)
- Ballistic 900T Fuel Tank (v2.14.0)
- Dogstar Ulysses M10 Fuel Tank (v2.14.0)
- Dogstar Ulysses M20 Fuel Tank (v2.14.0)
- Dogstar Ulysses M30 Fuel Tank (v2.14.0)
- Dogstar Ulysses M40 Fuel Tank (v2.14.0)
- Dogstar Ulysses M50 Fuel Tank (v2.14.0)
- Dogstar Atlas H10 Fuel Tank (v2.14.0)
- Dogstar Atlas H20 Fuel Tank (v2.14.0)
- Dogstar Atlas H30 Fuel Tank (v2.14.0)
- Dogstar Atlas H40 Fuel Tank (v2.14.0)
- Nautilus Titan 350 Fuel Tank (v2.14.0)
- Nautilus Titan 450 Fuel Tank (v2.14.0)
- Nautilus Titan 550 Fuel Tank (v2.14.0)
Grav Drives:
- DeepCore Helios 100 Grav Drive (v2.19.0)
- DeepCore Helios 200 Grav Drive (v2.19.0)
- DeepCore Helios 300 Grav Drive (v2.19.0)
- DeepCore Helios 400 Grav Drive (v2.19.0)
- DeepCore Aurora 11G Grav Drive (v2.19.0)
- DeepCore Aurora 12G Grav Drive (v2.19.0)
- DeepCore Aurora 13G Grav Drive (v2.19.0)
- DeepCore Apollo GV100 Grav Drive (v2.19.0)
- DeepCore Apollo GV200 Grav Drive (v2.19.0)
- DeepCore Apollo GV300 Grav Drive (v2.19.0)
- Nova Galactic NG150 Grav Drive (v2.19.0)
- Nova Galactic NG160 Grav Drive (v2.19.0)
- Nova Galactic NG170 Grav Drive (v2.19.0)
- Nova Galactic NG200 Grav Drive (v2.19.0)
- Nova Galactic NG210 Grav Drive (v2.19.0)
- Nova Galactic NG220 Grav Drive (v2.19.0)
- Nova Galactic NG300 Grav Drive (v2.19.0)
- Nova Galactic NG320 Grav Drive (v2.19.0)
- Nova Galactic NG340 Grav Drive (v2.19.0)
- Reladyne R-1000 Alpha Grav Drive (v2.19.0)
- Reladyne R-2000 Alpha Grav Drive (v2.19.0)
- Reladyne R-3000 Alpha Grav Drive (v2.19.0)
- Reladyne R-4000 Alpha Grav Drive (v2.19.0)
- Reladyne RD-1000 Beta Grav Drive (v2.19.0)
- Reladyne RD-2000 Beta Grav Drive (v2.19.0)
- Reladyne RD-3000 Beta Grav Drive (v2.19.0)
- Reladyne J-51 Gamma Grav Drive (v2.19.0)
- Reladyne J-52 Gamma Grav Drive (v2.19.0)
- Reladyne J-53 Gamma Grav Drive (v2.19.0)
- Slayton Aerospace SGD 1100 Grav Drive (v2.19.0)
- Slayton Aerospace SGD 1200 Grav Drive (v2.19.0)
- Slayton Aerospace SGD 1300 Grav Drive (v2.19.0)
- Slayton Aerospace SGD 1400 Grav Drive (v2.19.0)
- Slayton Aerospace SGD 2100 Grav Drive (v2.19.0)
- Slayton Aerospace SGD 2200 Grav Drive (v2.19.0)
- Slayton Aerospace SGD 2300 Grav Drive (v2.19.0)
- Slayton Aerospace SGD 3100 Grav Drive (v2.19.0)
- Slayton Aerospace SGD 3200 Grav Drive (v2.19.0)
- Slayton Aerospace SGD 3300 Grav Drive (v2.19.0)
- Vanguard Recon Grav Drive (v2.19.0)
Reactors:
- Amun Dunn 330T Stellarator Reactor (v2.20.0)
- Amun Dunn 340T Stellarator Reactor (v2.20.0)
- Amun Dunn 350T Stellarator Reactor (v2.20.0)
- Amun Dunn 360T Stellarator Reactor (v2.20.0)
- Amun Dunn 370T Stellarator Reactor (v2.20.0)
- Amun Dunn 380T Stellarator Reactor (v2.20.0)
- Amun Dunn Theta Pinch A9 Reactor (v2.20.0)
- Amun Dunn Theta Pinch B9 Reactor (v2.20.0)
- Amun Dunn Theta Pinch C9 Reactor (v2.20.0)
- Amun Dunn Theta Pinch D9 Reactor (v2.20.0)
- Amun Dunn Z-Machine 1000 Reactor (v2.20.0)
- Amun Dunn Z-Machine 2000 Reactor (v2.20.0)
- Amun Dunn Z-Machine 2020 Reactor (v2.20.0)
- Amun Dunn Z-Machine 3000 Reactor (v2.20.0)
- Amun Dunn Z-Machine 4000 Reactor (v2.20.0)
- Deep Core DC301 Fast Ignition Reactor (v2.20.0)
- Deep Core DC302 Fast Ignition Reactor (v2.20.0)
- Deep Core DC303 Fast Ignition Reactor (v2.20.0)
- Deep Core Fusor DC401 Reactor (v2.20.0)
- Deep Core Fusor DC402 Reactor (v2.20.0)
- Deep Core Fusor DC403 Reactor (v2.20.0)
- Deep Core Spheromak DC201 Reactor (v2.20.0)
- Deep Core Spheromak DC202 Reactor (v2.20.0)
- Dogstar 101DS Mag Inertial Reactor (v2.20.0)
- Dogstar 102DS Mag Inertial Reactor (v2.20.0)
- Dogstar 103DS Mag Inertial Reactor (v2.20.0)
- Dogstar 104DS Mag Inertial Reactor (v2.20.0)
- Dogstar 114MM Toroidal Reactor (v2.20.0)
- Dogstar 124MM Toroidal Reactor (v2.20.0)
- Dogstar 134MM Toroidal Reactor (v2.20.0)
- Dogstar 144MM Toroidal Reactor (v2.20.0)
- Dogstar 154MM Toroidal Reactor (v2.20.0)
- Dogstar 164MM Toroidal Reactor (v2.20.0)
- Dogstar SF10 Sheared Flow Reactor (v2.20.0)
- Dogstar SF20 Sheared Flow Reactor (v2.20.0)
- Dogstar SF30 Sheared Flow Reactor (v2.20.0)
- Dogstar SF40 Sheared Flow Reactor (v2.20.0)
- Xiang Ion Beam H-1010 Reactor (v2.20.0)
- Xiang Ion Beam H-1020 Reactor (v2.20.0)
- Xiang Ion Beam H-1030 Reactor (v2.20.0)
- Xiang Pinch 5Z Reactor (v2.20.0)
- Xiang Pinch 6Z Reactor (v2.20.0)
- Xiang Pinch 7Z Reactor (v2.20.0)
- Xiang Pinch 8A Reactor (v2.20.0)
- Xiang Pinch 8Z Reactor (v2.20.0)
- Xiang Tokamak X-050 Reactor (v2.20.0)
- Xiang Tokamak X-100 Reactor (v2.20.0)
- Xiang Tokamak X-120S Reactor (v2.20.0)
- Xiang Tokamak X-150 Reactor (v2.20.0)
- Xiang Tokamak X-200 Reactor (v2.20.0)
- Xiang Tokamak X-250 Reactor (v2.20.0)
- Xiang Tokamak X-300 Reactor (v2.20.0)
Shields:
- Dogstar Defender 11T Shield Generator (v2.12.0)
- Dogstar Defender 22T Shield Generator (v2.12.0)
- Dogstar Defender 28T Shield Generator (v2.12.0)
- Dogstar Defender 33T Shield Generator (v2.12.0)
- Dogstar Defender 44T Shield Generator (v2.12.0)
- Dogstar Guardian 101D Shield Generator (v2.12.0)
- Dogstar Guardian 102D Shield Generator (v2.12.0)
- Dogstar Guardian 103D Shield Generator (v2.12.0)
- Dogstar Guardian 104D Shield Generator (v2.12.0)
- Dogstar Protector 10S Shield Generator (v2.11.0)
- Dogstar Protector 20S Shield Generator (v2.11.0)
- Dogstar Protector 30S Shield Generator (v2.11.0)
- Dogstar Protector 40S Shield Generator (v2.11.0)
- Dogstar Protector 50S Shield Generator (v2.11.0)
- Dogstar Protector 60S Shield Generator (v2.11.0)
- Nautilus Bastille S80 Shield Generator (v2.11.0)
- Nautilus Bastille S81 Shield Generator (v2.11.0)
- Nautilus Bastille S82 Shield Generator (v2.11.0)
- Nautilus Bastille S83 Shield Generator (v2.11.0)
- Nautilus Bastille S84 Shield Generator (v2.11.0)
- Nautilus Fortress A1 Shield Generator (v2.12.0)
- Nautilus Fortress A2 Shield Generator (v2.12.0)
- Nautilus Fortress A3 Shield Generator (v2.12.0)
- Nautilus Tower N400 Shield Generator (v2.12.0)
- Nautilus Tower N410 Shield Generator (v2.12.0)
- Nautilus Tower N420 Shield Generator (v2.12.0)
- Protectorate Marduk 1010-A Shield Generator (v2.11.0)
- Protectorate Marduk 1020-A Shield Generator (v2.11.0)
- Protectorate Marduk 1030-A Shield Generator (v2.11.0)
- Protectorate Marduk 1040-A Shield Generator (v2.11.0)
- Protectorate Odin 3030-C Shield Generator (v2.12.0)
- Protectorate Odin 3040-C Shield Generator (v2.12.0)
- Protectorate Odin 3050-C Shield Generator (v2.12.0)
- Protectorate Osiris 2020-B Shield Generator (v2.12.0)
- Protectorate Osiris 2030-B Shield Generator (v2.12.0)
- Protectorate Osiris 2040-B Shield Generator (v2.12.0)
- Sextant Assurance SG-1000 Shield Generator (v2.12.0)
- Sextant Assurance SG-1800 Shield Generator (v2.12.0)
- Sextant Assurance SG-2000 Shield Generator (v2.12.0)
- Sextant Assurance SG-3000 Shield Generator (v2.12.0)
- Sextant Deflector SG-10 Shield Generator (v2.12.0)
- Sextant Deflector SG-20 Shield Generator (v2.12.0)
- Sextant Deflector SG-30 Shield Generator (v2.12.0)
- Sextant Deflector SG-35 Shield Generator (v2.12.0)
- Sextant Deflector SG-40 Shield Generator (v2.12.0)
- Sextant Deflector SG-50 Shield Generator (v2.12.0)
- Sextant Deflector SG-60 Shield Generator (v2.12.0)
- Sextant Warden SG-100 Shield Generator (v2.12.0)
- Sextant Warden SG-200 Shield Generator (v2.12.0)
- Sextant Warden SG-300 Shield Generator (v2.12.0)
- Sextant Warden SG-400 Shield Generator (v2.12.0)
- Vanguard Bulwark Shield Generator (v2.12.0)
Decorative Cargo:
- Decorative: Dogstar StorMax 30 (v2.13.0)
- Decorative: Dogstar StorMax 40 (v2.13.0)
- Decorative: Dogstar StorMax 50 (v2.13.0)
- Decorative: Dogstar StorMax 60 (v2.13.0)
- Decorative: Dogstar StorMax Empty (v2.13.0)
- Decorative: Panoptes da Gama 1000/1010/1020 (v2.13.0)
- Decorative: Panoptes Polo 2000/2010/2020/2030 (v2.13.0)
- Decorative: Protectorate Caravel V101 (v2.13.0)
- Decorative: Protectorate Caravel V102 (v2.13.0)
- Decorative: Protectorate Caravel V103 (v2.13.0)
- Decorative: Protectorate Caravel V104 (v2.13.0)
- Decorative: Protectorate Galleon S201 (v2.13.0)
- Decorative: Protectorate Galleon S202 (v2.13.0)
- Decorative: Protectorate Galleon S203 (v2.13.0)
- Decorative: Protectorate Galleon S204 (v2.13.0)
- Decorative: Sextant Ballast 100CM (v2.13.0)
- Decorative: Sextant Ballast 200CM (v2.13.0)
- Decorative: Sextant Ballast 300CM/400CM (v2.13.0)
- Decorative: Sextant Hauler 10T (v2.13.0)
- Decorative: Sextant Hauler 20T (v2.13.0)
- Decorative: Sextant Hauler 30T/40T (v2.13.0)
Decorative Fuel Tanks:
- Decorative: Ballistic 100G/200G (v2.14.0)
- Decorative: Ballistic 300G/400G (v2.14.0)
- Decorative: Ballistic 500T (v2.14.0)
- Decorative: Ballistic 600T/700T/900T (v2.14.0)
- Decorative: Ballistic 800T-A (v2.14.0)
- Decorative: Ballistic 800T-B (v2.14.0)
- Decorative: Dogstar Ulysses M10/M20 (v2.14.0)
- Decorative: Dogstar Ulysses M30 (v2.14.0)
- Decorative: Dogstar Ulysses M40/M50 (v2.14.0)
- Decorative: Dogstar Atlas H10 (v2.14.0)
- Decorative: Dogstar Atlas H20 (v2.14.0)
- Decorative: Dogstar Atlas H30 (v2.14.0)
- Decorative: Dogstar Atlas H40 (v2.14.0)
- Decorative: Nautilus Titan 350/450/550 (v2.14.0)
Decorative Grav Drives:
- Decorative: DeepCore Helios (v2.19.0)
- Decorative: DeepCore Aurora (v2.19.0)
- Decorative: DeepCore Apollo (v2.19.0)
- Decorative: Nova NG1xx (v2.19.0)
- Decorative: Nova NG2xx (v2.19.0)
- Decorative: Nova NG3xx (v2.19.0)
- Decorative: Reladyne Alpha (v2.19.0)
- Decorative: Reladyne Beta (v2.19.0)
- Decorative: Reladyne Gamma (v2.19.0)
- Decorative: Slayton SGD 1xxx (v2.19.0)
- Decorative: Slayton SGD 2xxx (v2.19.0)
- Decorative: Slayton SGD 3xxx (v2.19.0)
- Decorative: Vanguard Recon (v2.19.0)
Decorative Reactors:
- Decorative: 101DS Mag Inertial Reactor (v2.20.0)
- Decorative: 114MM Toroidal Reactor (v2.20.0)
- Decorative: 330T Stellarator Reactor (v2.20.0)
- Decorative: DC301 Fast Ignition Reactor (v2.20.0)
- Decorative: Fusor DC401 Reactor (v2.20.0)
- Decorative: Ion Beam H-1010 Reactor (v2.20.0)
- Decorative: Pinch 5Z Reactor (v2.20.0)
- Decorative: SF10 Sheared Flow Reactor (v2.20.0)
- Decorative: Spheromak DC201 Reactor (v2.20.0)
- Decorative: Theta Pinch A9 Reactor (v2.20.0)
- Decorative: Tokamak X-050 Reactor (v2.20.0)
- Decorative: Z-Machine 1000 Reactor (v2.20.0)
Decorative Shields:
- Decorative: Dogstar Defender (v2.13.0)
- Decorative: Dogstar Guardian (v2.13.0)
- Decorative: Dogstar Protector (v2.13.0)
- Decorative: Nautilus Bastille (v2.13.0)
- Decorative: Nautilus Fortress (v2.13.0)
- Decorative: Nautilus Tower (v2.13.0)
- Decorative: Protectorate Marduk (v2.13.0)
- Decorative: Protectorate Odin (v2.13.0)
- Decorative: Protectorate Osiris (v2.13.0)
- Decorative: Sextant Assurance (v2.13.0)
- Decorative: Sextant Deflector (v2.13.0)
- Decorative: Sextant Warden (v2.13.0)
- Decorative: Vanguard Bulwark (v2.13.0)
Decorative Weapons (Ballistic):
- Decorative: Ballistic BLS-A (v2.15.0)
- Decorative: Ballistic BLS-B (v2.15.0)
- Decorative: Ballistic BLS-B Turret (v2.15.0)
- Decorative: Ballistic BLS-C (v2.15.0)
- Decorative: Ballistic BLS-C Turret (v2.15.0)
- Decorative: Horizon BLS-A (v2.15.0)
- Decorative: Horizon BLS-B (v2.15.0)
- Decorative: Horizon BLS-B Turret (v2.15.0)
- Decorative: Horizon BLS-C (v2.15.0)
- Decorative: Horizon BLS-C Turret (v2.15.0)
- Decorative: Shinigami BLS-A (v2.15.0)
- Decorative: Shinigami BLS-B (v2.15.0)
- Decorative: Shinigami BLS-B Turret (v2.15.0)
- Decorative: Shinigami BLS-C (v2.15.0)
- Decorative: Shinigami BLS-C Turret (v2.15.0)
- Decorative: Vanguard BLS-A (v2.15.0)
Decorative Weapons (EM):
- Decorative: Ballistic LCT-A (v2.15.0)
- Decorative: Ballistic LCT-B (v2.15.0)
- Decorative: Ballistic LCT-C (v2.15.0)
- Decorative: Light Scythe LCT-A (v2.15.0)
- Decorative: Light Scythe LCT-B (v2.15.0)
- Decorative: Light Scythe LCT-C (v2.15.0)
- Decorative: Shinigami LCT-A (v2.15.0)
- Decorative: Shinigami LCT-B (v2.15.0)
- Decorative: Shinigami LCT-C (v2.15.0)
Decorative Weapons (Laser):
- Decorative: Horizon LSR-A (v2.15.0)
- Decorative: Horizon LSR-B (v2.15.0)
- Decorative: Horizon LSR-B Turret (v2.15.0)
- Decorative: Horizon LSR-C (v2.15.0)
- Decorative: Horizon LSR-C Turret (v2.15.0)
- Decorative: Light Scythe LSR-A (v2.15.0)
- Decorative: Light Scythe LSR-B (v2.15.0)
- Decorative: Light Scythe LSR-C (v2.15.0)
- Decorative: Light Scythe LSR-C Turret (v2.15.0)
- Decorative: Light Scythe LSR-D (v2.15.0)
- Decorative: Light Scythe LSR-D Turret (v2.15.0)
- Decorative: Shinigami LSR-A (v2.15.0)
- Decorative: Shinigami LSR-B (v2.15.0)
- Decorative: Shinigami LSR-B Turret (v2.15.0)
- Decorative: Shinigami LSR-C (v2.15.0)
- Decorative: Shinigami LSR-C Turret (v2.15.0)
- Decorative: Vanguard LSR-A (v2.15.0)
Decorative Weapons (Missile):
- Decorative: Ballistic MSL-A (v2.15.0)
- Decorative: Ballistic MSL-B (v2.15.0)
- Decorative: Ballistic MSL-C (v2.15.0)
- Decorative: Ballistic MSL-D (v2.15.0)
- Decorative: Horizon MSL-A (v2.15.0)
- Decorative: Horizon MSL-B (v2.15.0)
- Decorative: Horizon MSL-C (v2.15.0)
- Decorative: Light Scythe MSL-A (v2.15.0)
- Decorative: Light Scythe MSL-B (v2.15.0)
- Decorative: Light Scythe MSL-C (v2.15.0)
- Decorative: Shinigami MSL-A (v2.15.0)
- Decorative: Shinigami MSL-B (v2.15.0)
- Decorative: Shinigami MSL-C (v2.15.0)
- Decorative: Vanguard MSL-A (v2.15.0)
Decorative Weapons (Particle):
- Decorative: Ballistic PRT-A (v2.15.0)
- Decorative: Ballistic PRT-B (v2.15.0)
- Decorative: Ballistic PRT-B Turret (v2.15.0)
- Decorative: Ballistic PRT-C (v2.15.0)
- Decorative: Ballistic PRT-C Turret (v2.15.0)
- Decorative: Horizon PRT-A (v2.15.0)
- Decorative: Horizon PRT-B (v2.15.0)
- Decorative: Horizon PRT-B Turret (v2.15.0)
- Decorative: Horizon PRT-C (v2.15.0)
- Decorative: Horizon PRT-C Turret (v2.15.0)
- Decorative: Light Scythe PRT-A (v2.15.0)
- Decorative: Light Scythe PRT-B (v2.15.0)
- Decorative: Light Scythe PRT-B Turret (v2.15.0)
- Decorative: Light Scythe PRT-C (v2.15.0)
- Decorative: Light Scythe PRT-C Turret (v2.15.0)
- Decorative: Vanguard PRT-A (v2.15.0)
- Decorative: Vanguard PRT-B (v2.15.0)
