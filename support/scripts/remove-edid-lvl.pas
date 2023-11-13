{
  Removes '_lvlXX' from EDIDs
}
unit RemoveLevelFromEDID;

function Process(e: IInterface): integer;
var
  editor_id_element: IInterface;
  editor_id, editor_id_old: string;
begin
  editor_id_element := ElementBySignature(e, 'EDID');

  // make sure that there's an EDID on the record
  if Assigned(editor_id_element) then begin
    editor_id := GetEditValue(editor_id_element);
    editor_id_old := GetEditValue(editor_id_element);
    // make sure that '_lvlXX' is at the end
    if Pos('_lvl', editor_id) > Length(editor_id) - 6 then begin
      editor_id := LeftStr(editor_id, Pos('_lvl', editor_id) - 1);
      SetEditValue(editor_id_element, editor_id);
      AddMessage('EDID of [' + Signature(e) + ':' + IntToHex(FormID(e), 8) + '] changed from ''' + editor_id_old + ''' to ''' + editor_id + '''');
    end;
  end;
end;

end.
