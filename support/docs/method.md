# METHOD

nifskope:
- create nif by editing an existing one; will need to mess with the "Rotation" parameter on each BSGeometry block, and possibly the "Translation" parameter as well

xEdit:
- create new Movable Static record
    - define the NIF to use
    - set appropriate snap template
- create new Cell record
    - copy cell data from another one
        - editor id usually follows template "PackInShipPISMOD<Type(Cargo/Struct/Etc)><Manufacturer><Model><AttachLocation>StorageCell"
    - place 3 temporary REFRs
        - 1 is OutpostGroupPackinDummy [STAT:00015804]
        - 2 is PrefabPackinPivotDummy [STAT:0003F808]
        - 3 is the MSTT you just created
- create new Pack-In record
    - set CNAM - Cell to reference newly-created Cell record
    - copy other data from another PKIN, changing as necessary
- create new Generic Base Form record
- add GBFM to the appropriate FormID List record (will probably have to copy FLST as override)
