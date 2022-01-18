object FPrincipal: TFPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Integra'#231#227'o WhatsApp'
  ClientHeight = 498
  ClientWidth = 759
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 303
    Top = 16
    Width = 50
    Height = 16
    Caption = 'Telefone'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 472
    Top = 16
    Width = 43
    Height = 16
    Caption = 'Arquivo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 303
    Top = 59
    Width = 62
    Height = 16
    Caption = 'Mensagem'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblStatusEnvio: TLabel
    Left = 303
    Top = 191
    Width = 267
    Height = 36
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object Panel1: TPanel
    Left = 8
    Top = 17
    Width = 289
    Height = 310
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object lblSituacaoConexao: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 286
      Width = 273
      Height = 19
      Margins.Left = 6
      Margins.Right = 6
      Align = alBottom
      Alignment = taCenter
      Caption = 'Situa'#231#227'o da Conex'#227'o'
      Color = clNavy
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
      ExplicitWidth = 171
    end
    object qrCode: TImage
      Left = 8
      Top = 7
      Width = 273
      Height = 273
    end
  end
  object botConectarWhatsapp: TButton
    Left = 8
    Top = 333
    Width = 289
    Height = 36
    Caption = 'Conectar WhatsApp'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = botConectarWhatsappClick
  end
  object edtTelefone: TEdit
    Left = 303
    Top = 32
    Width = 163
    Height = 21
    TabOrder = 2
  end
  object botSelecionar: TButton
    Left = 688
    Top = 31
    Width = 63
    Height = 23
    Caption = 'Selecionar'
    TabOrder = 7
    OnClick = botSelecionarClick
  end
  object txtMensagem: TMemo
    Left = 303
    Top = 75
    Width = 448
    Height = 110
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object botEnviar: TButton
    Left = 576
    Top = 191
    Width = 175
    Height = 36
    Caption = 'Enviar Mensagem'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = botEnviarClick
  end
  object Panel2: TPanel
    Left = 303
    Top = 233
    Width = 448
    Height = 136
    TabOrder = 8
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 89
      Height = 16
      Caption = 'Nome do Grupo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 183
      Top = 8
      Width = 68
      Height = 16
      Caption = 'ID do Grupo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 9
      Top = 51
      Width = 188
      Height = 16
      Caption = 'Telefones separados por virgula.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblStatusGrupo: TLabel
      Left = 9
      Top = 94
      Width = 257
      Height = 35
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object edtNomeGrupo: TEdit
      Left = 8
      Top = 24
      Width = 169
      Height = 21
      TabOrder = 0
    end
    object edtIDGrupo: TEdit
      Left = 183
      Top = 24
      Width = 258
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edtParticipantes: TEdit
      Left = 9
      Top = 67
      Width = 432
      Height = 21
      TabOrder = 2
    end
    object botCriarGrupo: TButton
      Left = 272
      Top = 94
      Width = 169
      Height = 35
      Caption = 'Criar Grupo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = botCriarGrupoClick
    end
  end
  object edtArquivo: TEdit
    Left = 472
    Top = 32
    Width = 217
    Height = 21
    Color = clBtnFace
    Enabled = False
    TabOrder = 3
  end
  object chkGrupo: TCheckBox
    Left = 693
    Top = 56
    Width = 58
    Height = 19
    Alignment = taLeftJustify
    Caption = 'GRUPO'
    TabOrder = 5
  end
  object edtRetorno: TMemo
    Left = 8
    Top = 375
    Width = 743
    Height = 115
    Color = clInfoBk
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 9
  end
  object botFotoGrupo: TButton
    Left = 303
    Top = 191
    Width = 177
    Height = 36
    Caption = 'Trocar Foto do Grupo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    OnClick = botFotoGrupoClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Documento / Imagem|*.*'
    Title = 'Selecione'
    Left = 696
    Top = 88
  end
  object TimerQr: TTimer
    Enabled = False
    OnTimer = TimerQrTimer
    Left = 312
    Top = 89
  end
end
