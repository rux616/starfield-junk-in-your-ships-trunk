{
  New script template, only shows processed records
  Assigning any nonzero value to Result will terminate script
}
unit CloneCell;

// TODO
// clone cell to new file
// determine whether to deal with worldspaces


const
  group_type_cell_persistent_children = 8;
  group_type_cell_temporary_children = 9;
// var NewCell, OldCell : IwbContainer;
//var ValidCopySignatures;
// cell record signature
// CELL
// possible record signatures in a CELL
// ACHR - Placed NPC
// REFR - Placed Object
// PGRE - Placed Projectile
// PMIS - Placed Missile
// PARW - Placed Arrow
// PBEA - Placed Beam
// PFLA - Placed Flame
// PCON - Placed Cone/Voice
// PBAR - Placed Barrier
// PHZD - Placed Hazard
// NAVM - Navigation Mesh

// Called before processing
// You can remove it if script doesn't require initialization code
function Initialize: integer;
begin
  Result := 0;
end;


// called for every record selected in xEdit
function Process(e: IInterface): integer;
var
  i, j: integer;
  old_cell_group, cell_element_record, cell_subrecord, subrecord_element_record, new_cell, new_subrecord: IInterface;
  to_file: IwbFile;
begin
  Result := 0;

  if Signature(e) <> 'CELL' then
    Exit;

  to_file := GetFile(e);
  AddMessage('Processing: ' + FullPath(e));
  AddMessage('ShortName: ' + ShortName(e));
  AddMessage('Elements: ' + IntToStr(ElementCount(e)));

  // add new cell
  new_cell := Add(GetContainer(GetContainer(GetContainer(e))), 'CELL', True);
  AddMessage('New Cell: ' + IntToHex(FixedFormID(new_cell), 8));

  // copy element records from old cell to new cell
  for i := 1 to Pred(ElementCount(e)) do begin
    cell_element_record := ElementByIndex(e, i);
    wbCopyElementToRecord(cell_element_record, new_cell, False, True);
    AddMessage('i: ' + IntToStr(i) + ', Sig: ' + Signature(cell_element_record) + ' Elements: ' + IntToStr(ElementCount(cell_element_record)));
  end;

  // create new subrecords for temporary subrecords
  old_cell_group := FindChildGroup(ChildGroup(e), group_type_cell_temporary_children, e);
  AddMessage('# temporary children: ' + IntToStr(ElementCount(old_cell_group)));
  for i := 0 to Pred(ElementCount(old_cell_group)) do begin
    cell_subrecord := ElementByIndex(old_cell_group, i);
    AddMessage('Subrecord: ' + ShortName(cell_subrecord) + ' ' + GetElementEditValues(cell_subrecord, 'NAME'));
    AddMessage('FullPath: ' + FullPath(cell_subrecord));
    new_subrecord := Add(new_cell, Signature(cell_subrecord), True);

    // copy element records from old subrecords to new subrecords
    for j := 1 to Pred(ElementCount(cell_subrecord)) do begin
      subrecord_element_record := ElementByIndex(cell_subrecord, j);
      wbCopyElementToRecord(subrecord_element_record, new_subrecord, False, True);
      AddMessage('j: ' + IntToStr(j) + ', Sig: ' + Signature(subrecord_element_record) + ' Elements: ' + IntToStr(ElementCount(subrecord_element_record)));
    end;
  end;

  // create new subrecords for persistent subrecords
  old_cell_group := FindChildGroup(ChildGroup(e), group_type_cell_persistent_children, e);
  AddMessage('# persistent children: ' + IntToStr(ElementCount(old_cell_group)));
  for i := 0 to Pred(ElementCount(old_cell_group)) do begin
    cell_subrecord := ElementByIndex(old_cell_group, i);
    AddMessage('Subrecord: ' + ShortName(cell_subrecord) + ' ' + GetElementEditValues(cell_subrecord, 'NAME'));
    AddMessage('FullPath: ' + FullPath(cell_subrecord));
    new_subrecord := Add(new_cell, Signature(cell_subrecord), True);

    // copy element records from old subrecords to new subrecords
    for j := 1 to Pred(ElementCount(cell_subrecord)) do begin
      subrecord_element_record := ElementByIndex(cell_subrecord, j);
      wbCopyElementToRecord(subrecord_element_record, new_subrecord, False, True);
      AddMessage('j: ' + IntToStr(j) + ', Sig: ' + Signature(subrecord_element_record) + ' Elements: ' + IntToStr(ElementCount(subrecord_element_record)));
    end;

    SetIsPersistent(new_subrecord, True);
  end;

end;



// Called after processing
// You can remove it if script doesn't require finalization code
function Finalize: integer;
begin
  Result := 0;
end;

end.
