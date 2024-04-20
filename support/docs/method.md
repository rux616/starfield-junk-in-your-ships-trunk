# METHOD

xEdit:
- create new Movable Static record (once per module model)
    - copy one of the existing MSTT's for the module being worked on
    - remove the snap template
- create any Moveable Static records to contain the snap templates
- create new Cell record
    - copy cell data from another one
        - editor id usually follows template "PackInShipPISMOD<Type(Cargo/Struct/Etc)><Manufacturer><Model><AttachLocation>StorageCell"
    - place 4 temporary REFRs
        - 1 is OutpostGroupPackinDummy [STAT:00015804]
        - 2 is PrefabPackinPivotDummy [STAT:0003F808]
        - 3 is the snap MSTT
        - 4 is the module MSTT
    - mess with the ref to the module MSTT to get it rotated and positioned properly
- create new Pack-In record
    - set CNAM - Cell to reference newly-created Cell record
    - copy other data from another PKIN, changing as necessary
- create new Generic Base Form record
- add GBFM to the appropriate FormID List record (copy FLST as override or create new)
- update COBJ if necessary

new method
- use create-new-part to clone a base PKIN and its CELL (but not MSTT, STAT)
- duplicate main MSTT that has a snap template attached
- remove that snap template
- replace original MSTT in the base PKIN CELL with the new one
- for the module that is being worked on:
    - create new PKINs with CELLs and populate them with REFRs to the usual OutpostGroupPackinDummy and PrefabPackinPivotDummy STATs
    - add REFR for the base PKIN and adjust rotation however is needed
    - add REFR for whatever snap template(s) is(are) needed

## Snap Template EDID Meaning

EDID: ShipSnap_SMOD_Generic_(x width)x(y width)y(z width)z_(nodes)

x width, y width, z width: a three digit number that is the width of a dimension, or "CTR" if that dimension isn't specified and the node appears centered for that axis. the three digit number represents widths between 0.0 and 99.9, simply removing the decimal point, so 8.0 would be 080. (A standard class A grav drive module is 8.0 units on the x axis, 8.0 units on the y axis, and 3.5 units on the z axis.)

nodes: (normally) alphabetical list of the nodes included in the snap template. Contains "All" or some combination of "Aft", "Btm", "Fore", "Port", "Stbd", and "Top", or maybe "Flush". If a node has "E" after it (e.g. "Aft**E**PortStbd"), it's an enhanced node, meaning it has adjacent nodes of the same type to allow for more customizable positioning. If the word "Flush" appears in the node list, the first node listed is not alphabetized, and all the listed nodes between the first the word "Flush" are flush to the first node. Nodes after the word "Flush" appears are not flush to anything, and are alphabetized, e.g. (...)\_Node0[E]NodeA1[E][NodeB1[E]][...][NodeN1[E]]Flush[NodeA2[E]][NodeB2[E]][...][NodeN2[E]]
