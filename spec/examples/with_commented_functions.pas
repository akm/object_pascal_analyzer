unit unit1;

interface


implementation

// ---------------------------------------------------------------------------
  //function ADD_SPACE(TXT: String; TL: Integer): String;   // 文字列整形（所定スペースの追加）
  //function ADD_SPACE2(TXT: String; TL: Integer): String;  // 文字列整形（￥と所定スペースの追加）
  //Function DEL_ALL_SPACE(S: String): String;              // 文字列からスペースを取り除く

function ADD_SPACE(TXT: String; TL: Integer): String;
var
  S: String;
begin
  S := TXT;

  while Length(S) < TL do
  begin
    S := ' ' + S;
  end;

  Result := S;
end;

function ADD_SPACE2(TXT: String; TL: Integer): String;
var
  S: String;
begin
  S := TXT;
  S := '\ ' + S;

  while Length(S) <= TL do
  begin
    S := ' ' + S;
  end;

  Result := S;
end;

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
      End
      Else
      Begin
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


// ---------------------------------------------------------------------------
  //function SYO_CHAR(STR: String): Char;  // 諸費用の行番号をCharに変換する
  //procedure Print_Samabun(TBL2: TTable; tCode, aSama: String; PRT: TPrinter; X,Y: Integer);
  //function tecMiriToPixcel(AMiri:Extended; ADPI:Integer):Integer;     //mm -> pixcel に変換
  ////procedure POffSet(PRTDelivDatas: Tu8PRTDeliverySetupData); //項目微調整適用 2009/10 hitomi


// 諸費用の行番号をCharに変換する
function SYO_CHAR(STR: String): Char;
begin
  if STR = '951' then      Result := '1'
  else if STR = '952' then Result := '2'
  else if STR = '953' then Result := '3'
  else if STR = '954' then Result := '4'
  else if STR = '955' then Result := '5'
  else if STR = '956' then Result := '6'
  else if STR = '957' then Result := '7'
  else if STR = '958' then Result := '8'
  else                     Result := '0';
end;
