{
  Add selected forms to a FLST record, optionally creating one first
  -----
  Hotkey: Ctrl+E
}
unit AddToFLST;

var chosen_flst, flst_lnams: IInterface;

function Process(e: IInterface): integer;
var
  proceed: boolean;
  str_flst_formid, str_edid, str_full: string;
  formid_array_added: boolean;
  i: integer;
begin
  // if the FLST to add records to hasn't been chosen yet, go through that process
  if not Assigned(chosen_flst) then begin
    // get the FLST Form ID to put the records in
    proceed := InputQuery('Specify FLST FormID, or leave empty for new', 'Form ID', str_flst_formid);
    if not proceed then begin
      AddMessage('User cancelled');
      Result := 1;
      exit;
    end;

    if str_flst_formid = '' then begin  // new FLST
      // ask for EDID
      proceed := InputQuery('What editor ID should the new FLST have?', 'Editor ID', str_edid);
      if not proceed then begin
        AddMessage('User cancelled');
        Result := 1;
        exit;
      end;

      // ask for FULL
      proceed := InputQuery('What name should the new FLST have?', 'FULL - Name', str_full);
      if not proceed then begin
        AddMessage('User cancelled');
        Result := 1;
        exit;
      end;

      // create FLST record
      chosen_flst := Add(GroupBySignature(GetFile(e), 'FLST'), 'FLST', True);

      // set EDID
      SetEditValue(Add(chosen_flst, 'EDID', True), str_edid);

      // set FULL
      if str_full <> '' then
        SetEditValue(Add(chosen_flst, 'FULL', True), str_full);

      AddMessage('Created form list ' + Name(chosen_flst));
    end
    else begin  // add to existing FLST
      chosen_flst := RecordByHexFormID(str_flst_formid);
      if Signature(chosen_flst) <> 'FLST' then begin
        AddMessage('ERROR: invalid record type chosen: ' + Name(chosen_flst));
        Result := 1;
        exit;
      end;
      // TODO add special case where chosen FLST is in main ESM file and has no overrides
      //  present file list minus main ESM and ask to pick where override should go, including a new file?
      //
      // TODO add special case where chosen FLST has overrides
      //  present file list plus an additional option for creating a new override IF not all files (minus the main ESM and the originating record ESM) have overrides yet
      //  user picks one or more file to edit the override in, if new override, possibility of new file exists.

      // TODO check if FLST has an override in the plugin where 'e' resides and use that instead
      (* ---> IN PROGRESS CODE --->
      frm := frmFileSelect;
      try
        frm.Caption := 'Which override to use?';
        clb := TCheckListBox(frm.FindComponent('CheckListBox1'));
      // <--- IN PROGRESS CODE <--- *)
      AddMessage('Using form list ' + Name(chosen_flst));
    end;
  end;

  // add file of record 'e' as master to plugin holding FLST
  if GetFileName(GetFile(chosen_flst)) <> GetFileName(GetFile(e)) then
    AddMasterIfMissing(GetFile(chosen_flst), GetFileName(GetFile(e)));

  // check to make sure the flst has "FormIDs" array, add if it doesn't
  if not Assigned(flst_lnams) then begin
    // add LNAM array
    flst_lnams := Add(chosen_flst, 'FormIDs', True);
  end;

  // prevent FLST from being added to itself
  if ShortName(e) = ShortName(chosen_flst) then begin
    AddMessage('Skipped: ' + ShortName(chosen_flst) + ', cannot add FLST to itself');
    exit;
  end;

  // prevent existing FormIDs from being duplicated
  for i := 0 to Pred(ElementCount(flst_lnams)) do
    if GetEditValue(ElementByIndex(flst_lnams, i)) = Name(e) then begin
      AddMessage('Skipped: ' + ShortName(e) + ' already exists in ' + ShortName(chosen_flst));
      exit;
    end;

  // add 'e' to FLST
  ElementAssign(flst_lnams, HighInteger, e, False);
  AddMessage('Added ' + ShortName(e) + ' to ' + ShortName(chosen_flst));
end;

end.
