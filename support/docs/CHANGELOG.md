Junk In Your (Ship's) Trunk
===========================

Table Of Contents
-----------------
- [Junk In Your (Ship's) Trunk](#junk-in-your-ships-trunk)
    - [Table Of Contents](#table-of-contents)
- [Changelog](#changelog)
    - [v2.15.0](#v2150)
    - [v2.14.1](#v2141)
    - [v2.14.0](#v2140)
    - [v2.13.0](#v2130)
    - [v2.12.0](#v2120)
    - [v2.11.0](#v2110)
    - [v2.10.0](#v2100)
    - [v2.9.0](#v290)
    - [v2.8.0](#v280)
    - [v2.7.0](#v270)
    - [v2.6.0](#v260)
    - [v2.5.0](#v250)
    - [v2.4.0](#v240)
    - [v2.3.0](#v230)
    - [v2.2.0](#v220)
    - [v2.1.0](#v210)
    - [v2.0.0](#v200)
    - [v1.1.0](#v110)
    - [v1.0.0](#v100)


Changelog
=========

v2.15.0
-------
- Added decorative weapons
- Split "Decorative" Ship Builder category into distinct subcategories for the different module types
- Trimmed the names of decorative modules to remove the "type"
- Fixed name of Nautilus Titan 350/450/550 decorative fuel tank
- Updated EditorIDs of some fuel tanks
- Added compatibility patch for Ultimate Shipyards Unlocked "USU - Quest Rewards.esm" modular plugin

([TOC](#table-of-contents))

v2.14.1
-------
- Fixed Dogstar StorMax 60 Cargo Hold "starboard vertical" flip to actually be the starboard vertical flip
- Fixed Decorative Dogstar StorMax 60 Cargo Hold "starboard vertical" flip to actually be the starboard vertical flip

([TOC](#table-of-contents))

v2.14.0
-------
- Added 10 Ballistic 100G/200G Fuel Tank orientations
- Added 10 Ballistic 300G Fuel Tank orientations
- Added 11 Ballistic 400G Fuel Tank orientations
- Added 2 Ballistic 500T Fuel Tank orientations
- Added 23 Ballistic 600T/700T/900T Fuel Tank orientations
- Split Ballistic 800T Fuel Tank into 800T-A Fuel Tank and 800T-B Fuel Tank
- Added 10 Ballistic 800T-A Fuel Tank orientations
- Added 5 Ballistic 800T-B Fuel Tank orientations
- Added 23 Dogstar Ulysses M10/M20 Fuel Tank orientations
- Added 22 Dogstar Ulysses M30 Fuel Tank orientations
- Added 22 Dogstar Ulysses M40/M50 Fuel Tank orientations
- Added 10 Dogstar Atlas H10 Fuel Tank orientations
- Added 10 Dogstar Atlas H20 Fuel Tank orientations
- Added 10 Dogstar Atlas H30 Fuel Tank orientations
- Added 10 Dogstar Atlas H40 Fuel Tank orientations
- Added 10 Nautilus Titan 350/450/550 Fuel Tank orientations
- Added "Decorative" versions of all Fuel Tanks
- Fixed typo in the names of the Dogstar decorative cargo modules (Dogstart -> Dogstar)

([TOC](#table-of-contents))

v2.13.0
-------
- Added a "Decorative" category to the Ship Builder with decorative versions of all added modules
- Added new decorative cargo hold, Dogstar StorMax Empty, with 12 orientations
- Fixed display name of the Protectorate Caravel V102 Cargo Hold modules
- Changed up description in README a bit

([TOC](#table-of-contents))

v2.12.0
-------
- Added 22 Sextant Deflector SG-10/SG-20/SG-30/SG-35/SG-40/SG-50/SG-60 Shield Generator orientations:
    - fore/aft top/bottom/port/starboard
    - port/starboard top/bottom/fore/aft
    - top fore/aft/port/starboard
    - bottom port/starboard
- Added 4 Dogstar Defender 11T/22T/28T/33T/44T Shield Generator orientations:
    - fore/aft/top/bottom
- Added 5 Nautilus Tower N400/N410/N420 Shield Generator orientations:
    - port/starboard/fore/aft/bottom
- Added 5 Vanguard Bulwark Shield Generator orientations:
    - port/starboard/fore/aft/bottom
- Added 5 Protectorate Osiris 2020-B/2030-B/2040-B Shield Generator orientations:
    - port/starboard/fore/aft/bottom
- Added 5 Sextant Warden SG-100/SG-200/SG-300/SG-400 Shield Generator orientations:
    - port/starboard/fore/aft/bottom
- Added 4 Dogstar Guardian 101D/102D/103D/104D Shield Generator orientations:
    - fore/aft/top/bottom
- Added 5 Nautilus Fortress A1/A2/A3 Shield Generator orientations:
    - port/starboard/fore/aft/bottom
- Added 5 Sextant Assurance SG-1000/SG-1800/SG-2000/SG-3000 Shield Generator orientations:
    - port/starboard/fore/aft/bottom
- Added 5 Protectorate Odin 3030-C/3040-C/3050-C Shield Generator orientations:
    - port/starboard/fore/aft/bottom
- Corrected some positioning on the Nautilus "Bastille" shield generators
- Changed some editor IDs to follow a more consistent naming pattern
- Changed some module names from "model_number model_series" to "model_series model_number", e.g. from "100CM Ballast" to "Ballast 100CM" and from "11T Defender" to "Defender 11T"
- Forwarded relevant changes and fixes made in main plugin to Cargo Expander plugins

([TOC](#table-of-contents))

v2.11.0
-------
- Added additional snap points to fore/aft/port/starboard Protectorate Galleon S202 Cargo Hold variants
- Added additional snap points to fore/aft/port/starboard Protectorate Galleon S203 Cargo Hold variants
- Added additional snap points to fore/aft/port/starboard Sextant 10T/10ST Hauler Cargo Hold variants
- Added additional snap points to fore/aft/port/starboard Sextant 20T Hauler Cargo Hold variants
- Added additional snap points to fore/aft/port/starboard Sextant 30T/40T Hauler Cargo Hold variants
- Corrected some EDIDs on records associated with the Sextant 10T/10ST Hauler Cargo Hold
- Added 9 Dogstar Protector 10S/20S/30S/40S/50S/60S Shield Generator orientations:
    - fore/aft horizontal/vertical
    - port/starboard vertical
    - top port-to-starboard
    - bottom fore-to-aft/port-to-starboard
- Added 15 Nautilus Bastille S80/S81/S82/S83/S84 Shield Generator orientations:
    - fore/aft horizontal/vertical
    - fore/aft
    - port/starboard
    - port/starboard vertical
    - bottom
    - top/bottom fore-to-aft/port-to-starboard
- Added 5 Protectorate Marduk 1010-A/1020-A/1030-A/1040-A Shield Generator orientations:
    - fore/aft/port/starboard/bottom

([TOC](#table-of-contents))

v2.10.0
------
- Added 11 Panoptes Polo 2000/2010/2020/2030 Cargo Hold orientations:
    - bottom port-to-starboard
    - top fore-to-aft and port-to-starboard
    - fore/aft/port/starboard vertical/horizontal
- Added 10 Dogstar StorMax 30/40/50/60 Cargo Hold orientations:
    - fore/aft
    - port/starboard/fore/aft vertical
    - bottom/top fore-to-aft/port-to-starboard

([TOC](#table-of-contents))

v2.9.0
------
- Added 10 Protectorate Galleon S201 Cargo Hold orientations:
    - fore/aft
    - port/starboard/fore/aft vertical
    - bottom/top fore-to-aft/port-to-starboard
- Added 20 Protectorate Galleon S202 Cargo Hold orientations:
    - bottom/top fore/aft
    - fore/aft top/bottom/port/starboard
    - port/starboard top/bottom/fore/aft
- Added 20 Protectorate Galleon S203 Cargo Hold orientations:
    - bottom/top fore/aft
    - fore/aft top/bottom/port/starboard
    - port/starboard top/bottom/fore/aft
- Added 2 Protectorate Galleon S204 Cargo Hold orientations:
    - vertical fore-to-aft/port-to-starboard
- Added some override records and changed CELL EDIDs to avoid duplicates
- Changed some EDIDs to more closely follow vanilla patterning

([TOC](#table-of-contents))

v2.8.0
------
- Added 22 Panoptes da Gama 1000/1000 Shielded/1010/1010 Shielded/1020 Cargo Hold orientations:
    - port/starboard/fore/aft top
    - port/starboard vertical fore/aft
    - fore/aft vertical port/starboard
    - fore/aft bottom
    - bottom/top fore-to-aft (left)/fore-to-aft (right)/port-to-starboard (fore)/port-to-starboard (aft)
- Changed Sextant 30T/40T Hauler Cargo Holds so that an icon is shown in the Ship Builder (initially, anyway)
- Converted all images to JPEG (quality 80) for space savings

([TOC](#table-of-contents))

v2.7.0
------
- Added 10 Protectorate Caravel V103 Cargo Hold orientations:
    - port/starboard vertical
    - fore/aft horizontal/vertical
    - bottom/top fore-to-aft/port-to-starboard
- Added 10 Protectorate Caravel V104 Cargo Hold orientations:
    - port/starboard vertical
    - fore/aft horizontal/vertical
    - bottom/top fore-to-aft/port-to-starboard
- Condensed ship module listing in the README a bit

([TOC](#table-of-contents))

v2.6.0
------
- Added 10 Protectorate Caravel V102 Shielded/Unshielded Cargo Hold orientations:
    - port/starboard vertical
    - fore/aft horizontal/vertical
    - bottom/top fore-to-aft/port-to-starboard

([TOC](#table-of-contents))

v2.5.0
------
- Added 10 Protectorate Caravel V101 Shielded/Unshielded Cargo Hold orientations:
    - port/starboard vertical
    - fore/aft horizontal/vertical
    - bottom/top fore-to-aft/port-to-starboard

([TOC](#table-of-contents))

v2.4.0
------
- Added 20 Sextant 30T/40T Hauler Cargo Hold orientations:
    - bottom/top fore/aft
    - fore/aft top/bottom/port/starboard
    - port/starboard top/bottom/fore/aft

([TOC](#table-of-contents))

v2.3.0
------
- Added 11 Sextant 20T Hauler Cargo Hold orientations:
    - bottom port-to-starboard
    - top fore-to-aft and port-to-starboard
    - fore/aft/port/starboard vertical/horizontal
- Added notes in README/mod description about compatibility with a few other similar mods

([TOC](#table-of-contents))

v2.2.0
------
- Added 22 Sextant 10T/10ST Hauler Cargo Hold (unshielded and shielded, respectively) orientations:
    - fore/aft top/bottom/port/starboard orientations
    - port/starboard top/bottom/fore/aft orientations
    - top fore/aft/port/starboard orientations
    - bottom port/starboard orientations

([TOC](#table-of-contents))

v2.1.0
------
- Added 7 Sextant 100CM Ballast Cargo Hold shielded and unshielded variants:
    - fore, port, and starboard
    - inverted aft, fore, port, and starboard

([TOC](#table-of-contents))

v2.0.0
------
- Adjusted method of variant creation, requires clean install if upgrading from previous versions!
- Removed meshes as they are no longer needed
- Added 3x and 10x Cargo Expander optional plugins
- Made FOMOD installer
- Added vertical orientations of fore, aft, port, and starboard shielded and unshielded 200CM Ballast Cargo Holds
- Added 300CM Ballast Cargo Hold variants:
    - fore and aft
    - vertical fore/aft/port/starboard
    - fore-to-aft and port-to-starboard top and bottom
- Added 400CM Ballast Cargo Hold variants:
    - fore and aft
    - vertical fore/aft/port/starboard
    - fore-to-aft and port-to-starboard top and bottom

([TOC](#table-of-contents))

v1.1.0
------
- Packed all loose files inside a BA2 archive
- Refined README
- Added top (fore-to-aft and port-to-starboard orientation) and bottom (fore-to-aft and port-to-starboard orientation) versions of the shielded and unshielded Sextant 200CM Ballast Cargo Hold

([TOC](#table-of-contents))

v1.0.0
------
- Initial release
- Added fore and aft versions of the shielded and unshielded Sextant 200CM Ballast Cargo Hold

([TOC](#table-of-contents))
