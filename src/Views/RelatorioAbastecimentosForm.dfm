object frmRelatorioAbastecimentos: TfrmRelatorioAbastecimentos
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Relat'#243'rio de Abastecimentos'
  ClientHeight = 250
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 13
  object pnlTitulo: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = clNavy
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 44
      Top = 15
      Width = 299
      Height = 19
      Caption = 'Selecione o Per'#237'odo para o Relat'#243'rio'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlDatas: TPanel
    Left = 0
    Top = 50
    Width = 400
    Height = 150
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 20
    Padding.Top = 20
    Padding.Right = 20
    Padding.Bottom = 20
    TabOrder = 1
    object lblDataInicio: TLabel
      Left = 20
      Top = 20
      Width = 64
      Height = 13
      Caption = 'Data In'#237'cio:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblDataFim: TLabel
      Left = 20
      Top = 60
      Width = 53
      Height = 13
      Caption = 'Data Fim:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dtDataInicio: TDateTimePicker
      Left = 20
      Top = 35
      Width = 360
      Height = 21
      Date = 45261.000000000000000000
      Time = 45261.000000000000000000
      TabOrder = 0
    end
    object dtDataFim: TDateTimePicker
      Left = 20
      Top = 75
      Width = 360
      Height = 21
      Date = 45261.000000000000000000
      Time = 45261.000000000000000000
      TabOrder = 1
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 200
    Width = 400
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnGerar: TButton
      Left = 95
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Gerar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnGerarClick
    end
    object btnCancelar: TButton
      Left = 205
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
end
