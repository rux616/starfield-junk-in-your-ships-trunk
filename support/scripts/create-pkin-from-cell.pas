{
  Creates pack-in records from cell records in the same file
}
unit CreatePKINFromCell;

var
  mod_type, mod_manufacturer, mod_series, mod_model: string;

// Called before processing
// You can remove it if script doesn't require initialization code
function Initialize: integer;
var
  proceed: boolean;
begin
  proceed := InputQuery('title', 'type something', mod_type);
  AddMessage('proceed: ' + IntToStr(proceed) + ', input: ' + mod_type);
  if not proceed then
    AddMessage('User cancelled');
    Result := -1;
    Exit;
end;

function Process(e: IInterface): integer;
var
  i: integer;
  template_pkin, new_pkin, template_pkin_element_record: IInterface;
  to_file: IwbFile;
begin
  Result := 0;

  // EDID naming conventions:
  //  GBFM:
  //    non-weapons:
  //      SM<SHIP_CLASS>_<Type_gbfm>_<Manufacturer>_<Model-Series-And-Number>[_<Orientation>][_lvl<#>]
  //    weapons:
  //      SM<SHIP_CLASS>_<Type_gbfm>_<WeaponType>_<Manufacturer>_<Model-Series-And-Number>[_<Orientation>]_lvl<#>
  //  PKIN:
  //    non-hab,non-weapon:
  //      ShipPI_SMOD_<Type_pkin>_Manufacturer_<Model-Series-And-Number>

  // types:
  //  Cargo
  //  CargoShielded
  //  Shield
  //  Reactor
  //  GravDrive (GBFM) / Grav (PKIN)
  //  Weapon
  //  Cockpit
  //  Docker
  //  FuelTank
  //  Hab
  //  Lander
  //  Struct
  //  ScanJammer01
  //  ScanJammer02
  //  ScanJammer03
  //  Bay
  //  CrossBrace
  //  Engine (GBFM) / Eng (PKIN)

  // manufacturers:
  //  Panoptes
  //  Reladyne
  //  DeepCore
  //  Dogstar
  //  Slayton
  //  AmunDunn
  //  Xiang
  //  Protectorate
  //  Nautilus
  //  Sextant
  //  Vanguard
  //  Ballistic
  //  Horizon
  //  Shinigami
  //  LightScythe
  //  Nova
  //  Deimos
  //  Taiyo
  //  Stroud
  //  HopeTech
  //  Hope

  to_file := GetFile(e);
  AddMessage('File: ' + GetFileName(to_file) + ', Load Order: ' + IntToStr(GetLoadOrder(to_file)));
  AddMessage('fileformidtoloadorderformid: ' + IntToHex(FileFormIDtoLoadOrderFormID(to_file, $00000AC3), 8));
  template_pkin := RecordByFormID(to_file, StrToInt('$' + IntToStr(GetLoadOrder(to_file)) + '000AC3'), False);
  AddMessage('template: ' + FullPath(template_pkin));
  // new_pkin := wbCopyElementToFile(template_pkin, to_file, True, True);
  // AddMessage('new: ' + FullPath(new_pkin));
  // new_pkin := Add(GroupBySignature(to_file, 'PKIN'), 'PKIN', True);
  // for i := 1 to Pred(ElementCount(template_pkin)) do begin
  //   template_pkin_element_record := ElementByIndex(template_pkin, i);
  //   wbCopyElementToRecord(template_pkin_element_record, new_pkin, True, True);
  // end;
  Exit;
end;

// // called for every record selected in xEdit
// function Process(e: IInterface): integer;
// var
//   i, j: integer;
//   old_cell_group, template_pkin_element_record, cell_subrecord, subrecord_element_record, new_pkin, new_subrecord, template_pkin: IInterface;
//   to_file: IwbFile;
// begin
//   Result := 0;

//   // if Signature(e) <> 'CELL' then
//   //   Exit;

//   to_file := GetFile(e);
//   AddMessage('Processing: ' + FullPath(e));
//   AddMessage('ShortName: ' + ShortName(e));
//   AddMessage('Elements: ' + IntToStr(ElementCount(e)));
//   AddMessage('File: ' + GetFileName(to_file));

//   // get template pkin
//   // copy template pkin
//   // get cell EDID
//   // parse cell EDID
//   // change EDID of new pkin
//   // change FLTR of new pkin?

//   template_pkin := RecordByFormID(to_file, $00000AC3, False);
//   // template_pkin := RecordByEditorID(to_file, 'AAA_JIYT_TEMPLATE_ShipPI_SMOD_Aft');
//   AddMessage('found template pkin: ' + FullPath(template_pkin));

//   // copies pack-in
//   new_pkin := ContainingMainRecord(Add(GroupBySignature(to_file, 'PKIN'), 'PKIN', True));
//   AddMessage('New Pack-In: ' + IntToHex(FixedFormID(new_pkin), 8));

//   // copy element records from old cell to new cell
//   for i := 0 to Pred(ElementCount(template_pkin)) do begin
//     template_pkin_element_record := ElementByIndex(template_pkin, i);
//     AddMessage('i: ' + IntToStr(i) + ', Sig: ' + Signature(template_pkin_element_record) + ' Elements: ' + IntToStr(ElementCount(template_pkin_element_record)));
//     wbCopyElementToRecord(template_pkin_element_record, new_pkin, True, False);
//   end;
//   Exit;

//   // create new subrecords for temporary subrecords
//   old_cell_group := FindChildGroup(ChildGroup(e), group_type_cell_temporary_children, e);
//   AddMessage('# temporary children: ' + IntToStr(ElementCount(old_cell_group)));
//   for i := 0 to Pred(ElementCount(old_cell_group)) do begin
//     cell_subrecord := ElementByIndex(old_cell_group, i);
//     AddMessage('Subrecord: ' + ShortName(cell_subrecord) + ' ' + GetElementEditValues(cell_subrecord, 'NAME'));
//     AddMessage('FullPath: ' + FullPath(cell_subrecord));
//     new_subrecord := Add(new_pkin, Signature(cell_subrecord), True);

//     // copy element records from old subrecords to new subrecords
//     for j := 1 to Pred(ElementCount(cell_subrecord)) do begin
//       subrecord_element_record := ElementByIndex(cell_subrecord, j);
//       wbCopyElementToRecord(subrecord_element_record, new_subrecord, False, True);
//       AddMessage('j: ' + IntToStr(j) + ', Sig: ' + Signature(subrecord_element_record) + ' Elements: ' + IntToStr(ElementCount(subrecord_element_record)));
//     end;
//   end;

//   // create new subrecords for persistent subrecords
//   old_cell_group := FindChildGroup(ChildGroup(e), group_type_cell_persistent_children, e);
//   AddMessage('# persistent children: ' + IntToStr(ElementCount(old_cell_group)));
//   for i := 0 to Pred(ElementCount(old_cell_group)) do begin
//     cell_subrecord := ElementByIndex(old_cell_group, i);
//     AddMessage('Subrecord: ' + ShortName(cell_subrecord) + ' ' + GetElementEditValues(cell_subrecord, 'NAME'));
//     AddMessage('FullPath: ' + FullPath(cell_subrecord));
//     new_subrecord := Add(new_pkin, Signature(cell_subrecord), True);

//     // copy element records from old subrecords to new subrecords
//     for j := 1 to Pred(ElementCount(cell_subrecord)) do begin
//       subrecord_element_record := ElementByIndex(cell_subrecord, j);
//       wbCopyElementToRecord(subrecord_element_record, new_subrecord, False, True);
//       AddMessage('j: ' + IntToStr(j) + ', Sig: ' + Signature(subrecord_element_record) + ' Elements: ' + IntToStr(ElementCount(subrecord_element_record)));
//     end;

//     SetIsPersistent(new_subrecord, True);
//   end;

// end;



// Called after processing
// You can remove it if script doesn't require finalization code
function Finalize: integer;
begin
  Result := 0;
end;

end.
