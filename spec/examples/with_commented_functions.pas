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
