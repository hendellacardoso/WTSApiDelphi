unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Soap.EncdDecd;

type
  TFPrincipal = class(TForm)
    Panel1: TPanel;
    lblSituacaoConexao: TLabel;
    qrCode: TImage;
    botConectarWhatsapp: TButton;
    edtTelefone: TEdit;
    Label6: TLabel;
    edtArquivo: TEdit;
    Label7: TLabel;
    botSelecionar: TButton;
    txtMensagem: TMemo;
    Label8: TLabel;
    botEnviar: TButton;
    OpenDialog1: TOpenDialog;
    TimerQr: TTimer;
    Panel2: TPanel;
    edtNomeGrupo: TEdit;
    Label1: TLabel;
    edtIDGrupo: TEdit;
    Label2: TLabel;
    edtParticipantes: TEdit;
    Label3: TLabel;
    botCriarGrupo: TButton;
    chkGrupo: TCheckBox;
    lblStatusEnvio: TLabel;
    lblStatusGrupo: TLabel;
    edtRetorno: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure botSelecionarClick(Sender: TObject);
    procedure botConectarWhatsappClick(Sender: TObject);
    procedure botEnviarClick(Sender: TObject);
    procedure TimerQrTimer(Sender: TObject);
    procedure botCriarGrupoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function PreparaTexto(Texto: String): String;
  public
    { Public declarations }
    var
      strServidor,
      strSessao,
      strToken,
      strWebhook: String;
      qrContador: Integer;
      fileData: String;
  end;

var
  FPrincipal: TFPrincipal;

implementation

{$R *.dfm}

uses
  System.NetEncoding, System.JSON, WTSApi;


//CONECTAR WHATSAPP;
procedure TFPrincipal.botConectarWhatsappClick(Sender: TObject);
var
  JSON,
  Retorno,
  base64,
  Status: String;
begin
  qrContador := 0;
  Retorno := IniciarSessao(strServidor,'start-session',strSessao,strToken,strWebhook);
  TimerQr.Enabled := true;
end;



//CRIAR GRUPO
procedure TFPrincipal.botCriarGrupoClick(Sender: TObject);
var
  JSON: String;
  ResponseJSON: TJSONObject;
  JSonValue : TJSonValue;
  idGrupo : string;
begin
  ResponseJSON := TJSONObject.Create;
  ResponseJSON.AddPair('name', edtNomeGrupo.Text);
  ResponseJSON.AddPair('participants', edtParticipantes.Text);
  JSON := apiPOST(strServidor,'create-group',strSessao, strToken,'', ResponseJSON.ToString);

    JsonValue := TJSonObject.ParseJSONValue(JSON);
    idGrupo := JsonValue.GetValue<string>('response.groupInfo[0].id');

    edtIDGrupo.Text := idGrupo;
    edtTelefone.Text:= idGrupo;
  lblStatusGrupo.Caption := CampoJSON( JSON, 'status');
  edtRetorno.Text := ResponseJSON.ToString();
end;


//ENVIAR MENSAGEM / ANEXO;
procedure TFPrincipal.botEnviarClick(Sender: TObject);
var
  JSON: String;
  ResponseJSON: TJSONObject;
begin

  if (lblSituacaoConexao.Caption <> 'CONNECTED') then
  begin
     ShowMessage('Você tem que conectar o WhatsApp.');
     exit;
  end;

  if ((txtMensagem.Text = '') and (edtArquivo.Text = '')) then
  begin
     ShowMessage('Defina uma mensagem ou anexo!');
     exit;
  end;

  if (edtTelefone.Text = '') then
  begin
     ShowMessage('Defina o número de telefone!');
     exit;
  end;

  if (edtArquivo.Text = '') then
     if (txtMensagem.Text = '') then
     begin
       ShowMessage('Defina defina a mensagem de envio!');
       exit;
     end;

  ResponseJSON := TJSONObject.Create;

  if (edtArquivo.Text ='') then //<<-- Enviar mensagem;
  begin
    ResponseJSON.AddPair('phone', edtTelefone.Text);
    ResponseJSON.AddPair('message', PreparaTexto(txtMensagem.Text));
    if chkGrupo.Checked then
       ResponseJSON.AddPair('isGroup', TJSONFalse.Create(true))
    else
       ResponseJSON.AddPair('isGroup', TJSONFalse.Create(false));
    JSON := apiPOST(strServidor,'send-message',strSessao, strToken,'', ResponseJSON.ToString);
  end
  else
  begin
    ResponseJSON.AddPair('phone', edtTelefone.Text);
    ResponseJSON.AddPair('base64', fileData + StringReplace(EncodeFile(edtArquivo.Text),#13#10,'',[rfReplaceAll]) );
    ResponseJSON.AddPair('fileName', ExtractFileName(edtArquivo.Text));
    if chkGrupo.Checked then
       ResponseJSON.AddPair('isGroup', TJSONFalse.Create(true))
    else
       ResponseJSON.AddPair('isGroup', TJSONFalse.Create(false));
    if (txtMensagem.Text<>'') then
       ResponseJSON.AddPair('message', PreparaTexto(txtMensagem.Text));
    JSON := apiPOST(strServidor,'send-file-base64',strSessao, strToken,'', ResponseJSON.ToString);
  end;
  lblStatusEnvio.Caption := CampoJSON( JSON, 'status');
  edtRetorno.Text := ResponseJSON.ToString();

end;



//SELECIONAR ARQUIVO;
procedure TFPrincipal.botSelecionarClick(Sender: TObject);
begin
  edtArquivo.Text := '';
  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      edtArquivo.Text := OpenDialog1.FileName;
      fileData := 'data:'+getMIMEType(OpenDialog1.FileName)+';base64,';
    end;
  end;
end;



procedure TFPrincipal.Button1Click(Sender: TObject);
var
  JSonValue : TJSonValue;
  idGrupo : string;
begin

 { Convertendo uma string para json object }
  JsonValue := TJSonObject.ParseJSONValue(edtRetorno.Text);
  { Obtendo um valor dentro do json }
  idGrupo := JsonValue.GetValue<string>('response.groupInfo[0].id');
  ShowMessage(idGrupo);

end;

//DEFINIR DADOS INICIAIS;
procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  lblSituacaoConexao.Caption := 'Situação da Conexão';
  strServidor := 'http://127.0.0.1:28045'; //SOLICITE SEU TOKEN EM (62)9.8165-9440
  strSessao   := '5562981659440';
  strToken    := '$2b$10$QW0IZunHbSDGNxaCFu0Szuih01rwj_T4KR0pXun7P0pIuHp5zNPxO';
  strWebhook  := '';
end;



//PREPARA MENSAGEM;
function TFPrincipal.PreparaTexto(Texto: String): String;
begin
  if (Texto = '') then
     result := ''
  else
     result := StringReplace( Texto, #13#10, '\n', [rfReplaceAll] );
end;



//TIMER DO QRCODE
procedure TFPrincipal.TimerQrTimer(Sender: TObject);
var
  Retorno,
  Status,
  strQrCode: String;
  LInput: TMemoryStream;
  LOutput: TMemoryStream;
  Memo : TStringList;
begin

  Retorno := IniciarSessao(strServidor,'status-session',strSessao,strToken,strWebhook);
  Status  := CampoJSON(Retorno,'status');
  if (Status = 'CONNECTED') then
  begin
    edtRetorno.Text := '';
    lblSituacaoConexao.Caption := Status;
    TimerQr.Enabled := false;
    qrContador := 0;
    QrCode.Picture := nil;
    lblSituacaoConexao.Caption := 'Situação da Conexão';
    exit;
  end;


  if (qrContador = 60000) and (TimerQr.Interval = 15000) then
  begin
    TimerQr.Enabled := false;
    QrCode.Picture := nil;
    qrContador := 0;
    edtRetorno.Text := '';
    lblSituacaoConexao.Caption := 'API CLOSED';
    exit;
  end;


  Retorno := IniciarSessao(strServidor,'start-session',strSessao,strToken,strWebhook);
  Status  := CampoJSON(Retorno,'status');
  edtRetorno.Text := '';
  lblSituacaoConexao.Caption := Status;

  Application.ProcessMessages;

  if (Status = 'CONNECTED') then
  begin
    TimerQr.Enabled := false;
    QrCode.Picture := nil;
    qrContador := 0;
    exit;
  end;

  if (Status = 'QRCODE') then
  begin
     TimerQr.Interval := 15000;
     strQrCode := CampoJSON(Retorno, 'qrcode');
     strQrCode := StringReplace(strQrCode,'data:image/png;base64,','',[rfReplaceAll]);
     LInput := TMemoryStream.Create;
     LOutput := TMemoryStream.Create;
     Memo := TStringList.Create;
     Memo.Text := strQrCode;
     try
       Memo.SaveToStream(LInput);
       LInput.Position  := 0;
       TNetEncoding.Base64.Decode( LInput, LOutput );
       LOutput.Position := 0;
       QrCode.Picture.LoadFromStream(LOutput);
       Application.ProcessMessages;
     finally
       LInput.Free;
       LOutput.Free;
       Memo.Free;
     end;
  end;

  Retorno := IniciarSessao(strServidor,'status-session',strSessao,strToken,strWebhook);
  Status  := CampoJSON(Retorno,'status');
  if (Status = 'CONNECTED') then
  begin
    edtRetorno.Text := '';
    lblSituacaoConexao.Caption := Status;
    TimerQr.Enabled := false;
    qrContador := 0;
    QrCode.Picture := nil;
    exit;
  end;

  Application.ProcessMessages;
  qrContador := qrContador + 15000;

end;




end.
