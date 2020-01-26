{
  Replace StrSearch with StrReplace in EDID subrecords
}
unit UserScript;

var
  ReplaceCount: integer;
  StrSearch: string;
  StrReplace: string;

function Initialize: integer;
begin
  ReplaceCount := 0;
  Result := 0;
  // ask for string
  if not InputQuery('Enter', 'Search For', StrSearch) and InputQuery('Enter', 'Replace with', StrReplace) then begin
    Result := 2;
    Exit;
  end;
  // empty string - do nothing
  if StrSearch = '' then
    Result := 3;
end;

procedure SearchAndReplace(e: IInterface; s1, s2: string);
var
  s: string;
begin
  if not Assigned(e) then Exit;

  // remove rfIgnoreCase to be case sensitive
  s := StringReplace(GetEditValue(e), s1, s2, [rfReplaceAll, rfIgnoreCase]);

  if not SameText(s, GetEditValue(e)) then begin
    Inc(ReplaceCount);
    AddMessage('Replacing in ' + FullPath(e));
    SetEditValue(e, s);
  end;

end;

function Process(e: IInterface): integer;
begin
  SearchAndReplace(ElementBySignature(e, 'EDID'), StrSearch, StrReplace);
end;

function Finalize: integer;
begin
  AddMessage(Format('Replaced %d occurences.', [ReplaceCount]));
end;

end.
