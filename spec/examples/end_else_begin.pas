unit unit1;

interface


implementation

Function DEL_ALL_SPACE(S: String): String;
Var
  CNT, N  : Integer;
  STR, S1 : String;
begin
  Result := '';
  CNT    := 1;
  STR    := Trim(S);
  N      := Length(STR);

  While CNT <= N do
  begin
    S1 := Copy(STR, CNT ,1);
    if IsKanjiUp(S1) then
    begin
      If( CNT = N ) Then
      Begin
        Break;
      End
      Else
      if (S1 = Chr($81))
        and (Copy(STR,CNT + 1, 1) = Chr($40)) then
      begin
        Cnt := Cnt + 1;
      End Else Begin
        Result := Result + Copy(Str,Cnt, 2);
        Cnt := Cnt + 1;
      End;
    end
    else
    begin
      If( S1 <> Chr($20) ) Then
      Begin
        Result := Result + S1;
      End;
    end;
    CNT := CNT + 1;
  end;
end;
