unit WTSApi;

interface

uses
   Winapi.Windows,
   Winapi.Messages,
   System.SysUtils,
   System.Variants,
   System.Classes,
   Vcl.Graphics,
   Vcl.Controls,
   Vcl.Forms,
   Vcl.Dialogs,
   Vcl.ExtCtrls,
   IdComponent,
   IdTCPConnection,
   IdTCPClient,
   IdHTTP,
   IdMultipartFormData,
   IdAuthentication,
   System.NetEncoding,
   System.JSON,
   Vcl.StdCtrls,
   System.MaskUtils,
   Soap.EncdDecd,
   Registry;

var
  apiApyKey,
  apiToken: String;

function CampoJSON(json, Tag: String): String;
function apiGET(servidor, endpoint, sessao, token: String): String;
function apiPOST(servidor, endpoint, sessao, token, webhook, json: String): String;
function EncodeFile(const FileName: String): String;
function IniciarSessao(Servidor,Endpoint,Sessao,Token,Webhook:String):String;
function GetMIMEType(FileName: String): String;

implementation


function GetMIMEType(FileName: String): String;
var
  reg: TRegistry;
  ext: String;
  list: TStringList;
  i: Integer;
begin
  Result := '';
  ext := LowerCase(ExtractFileExt(Filename));
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CLASSES_ROOT;

    if reg.OpenKeyReadOnly('\' + ext) then
    begin
      Result := reg.ReadString('Content Type');
      reg.CloseKey;
    end;

    if Result = '' then
    begin
      if reg.OpenKeyReadOnly('\MIME\Database\Content Type') then
      begin
        list := TStringList.Create;
        try
          reg.GetKeyNames(list);
          for i := 0 to list.Count - 1 do begin
            if Reg.OpenKeyReadOnly('\MIME\Database\ContentType\' + list[i]) then
            begin
              if AnsiSameText(ext,
                reg.ReadString('Extension')) then begin
                Result := list[i];
                Break;
              end;
            end;
          end;
        finally
          list.Free;
        end;
        reg.CloseKey;
      end;
    end;
  finally
  reg.Free;
  end;
  if Result = '' then Result := 'application/octet-stream';
end;


function IniciarSessao(Servidor,Endpoint,Sessao,Token,Webhook:String):String;
var
  Retorno : String;
begin
  try
    result := apiPOST(servidor,endpoint,sessao,token,webhook,'');
  except
    on E: exception do
    begin
       //result := '{"status": "' + e.ToString + '"}';
    end;
  end;
end;



//GERAR BASE64 DO ARQUIVO
function EncodeFile(const FileName: String): String;
var
  stream: TMemoryStream;
begin
  stream := TMemoryStream.Create;
  try
    stream.LoadFromFile(Filename);
    result := EncodeBase64(stream.Memory, stream.Size);
  finally
    stream.Free;
  end;
end;


//OBTEM CAMPO DO JSON
function CampoJSON(json, Tag: String): String;
var
   LJSONObject: TJSONObject;
function TrataObjeto(jObj:TJSONObject):string;
var
   i:integer;
   jPar: TJSONPair;
begin
   if (json ='') then
   begin
      result := '';
      exit;
   end;
   result := '';
   for i := 0 to jObj.Count - 1 do
   begin
      jPar := jObj.Pairs[i];
      if jPar.JsonValue Is TJSONObject then
         result := TrataObjeto((jPar.JsonValue As TJSONObject)) else
      if sametext(trim(jPar.JsonString.Value),Tag) then
      begin
         Result := jPar.JsonValue.Value;
         break;
      end;
      if result <> '' then
         break;
   end;
end;
begin
   try
      LJSONObject := nil;
      LJSONObject := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json),0)
      as TJSONObject;
      result := TrataObjeto(LJSONObject);
   finally
      LJSONObject.Free;
   end;
end;


//EXECUTAR GET
//function apiPOST(servidor, endpoint, sessao, token, webhook, json: String): String;
function apiGET(servidor, endpoint, sessao, token: String): String;
var
   sResponse : String;
   HTTP      : TIdHTTP;
   retorno   : Boolean;
   Error     : String;
begin
   try
      HTTP := TIdHTTP.Create;
      HTTP.Request.Method := 'GET';
      HTTP.Request.CustomHeaders.Values['accept'] := '*/*';
      HTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + token;
      try
         sResponse := HTTP.Get(servidor + '/api/' + sessao + '/' + endpoint);
      except
         on E: Exception do
         begin
            Error  := e.Message;
            result := Error;
         end;
      end;
      HTTP.Free;
      result := sResponse;
  except
      result := Error;
  end;
end;


//EXECUTAR POST
function apiPOST(servidor, endpoint, sessao, token, webhook, json: String): String;
var
   sResponse : String;
   dados: TStringStream;
   HTTP : TIdHTTP;
begin
   endpoint := servidor + '/api/' + sessao + '/' + endpoint;
   dados := TStringStream.Create( UTF8Encode(json) )  ;
   try
      HTTP := TIdHTTP.Create(nil);
      HTTP.Request.Method := 'POST';
      HTTP.Request.Clear;
      HTTP.Request.ContentType := 'application/json';
      HTTP.Request.CharSet := 'UTF-8';
      HTTP.Request.CustomHeaders.Values['accept'] := '*/*';
      HTTP.Request.CustomHeaders.Values['Content-Type'] := 'application/json';
      if (token <> '') then
         HTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + token;
      try
         sResponse := HTTP.post(endpoint, dados );
      except
         on E: Exception do
         begin
            result := '{"status":"'+ e.ToString +'"}';
         end;
      end;
      result := sResponse;
  finally
      HTTP.Free;
      dados.Free;
  end;
end;


end.
