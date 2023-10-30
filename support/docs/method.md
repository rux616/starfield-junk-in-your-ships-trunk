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
- add GBFM to the appropriate FormID List record (will probably have to copy FLST as override)
