object frmBomba: TfrmBomba
  Left = 0
  Top = 0
  Caption = 'Gerenciamento de Bombas'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 13
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = clNavy
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 10
      Top = 10
      Width = 307
      Height = 32
      Alignment = taCenter
      Caption = 'Gerenciamento de Bombas'
      Color = clNavy
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
  end
  object pnlForm: TPanel
    Left = 0
    Top = 50
    Width = 800
    Height = 130
    Align = alTop
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 1
    object lblNumero: TLabel
      Left = 12
      Top = 12
      Width = 41
      Height = 13
      Caption = 'N'#250'mero'
      FocusControl = edtNumero
    end
    object lblDescricao: TLabel
      Left = 110
      Top = 12
      Width = 49
      Height = 13
      Caption = 'Descri'#231#227'o'
      FocusControl = edtDescricao
    end
    object lblTanque: TLabel
      Left = 330
      Top = 12
      Width = 37
      Height = 13
      Caption = 'Tanque'
      FocusControl = cbxTanque
    end
    object lblStatus: TLabel
      Left = 548
      Top = 12
      Width = 32
      Height = 13
      Caption = 'Status'
      FocusControl = cbxStatus
    end
    object edtNumero: TEdit
      Left = 12
      Top = 31
      Width = 80
      Height = 21
      MaxLength = 10
      TabOrder = 0
      OnKeyPress = edtNumeroKeyPress
    end
    object edtDescricao: TEdit
      Left = 110
      Top = 31
      Width = 200
      Height = 21
      MaxLength = 50
      TabOrder = 1
    end
    object cbxTanque: TComboBox
      Left = 330
      Top = 31
      Width = 200
      Height = 21
      Style = csDropDownList
      TabOrder = 2
    end
    object cbxStatus: TComboBox
      Left = 548
      Top = 31
      Width = 100
      Height = 21
      Style = csDropDownList
      TabOrder = 3
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 180
    Width = 800
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 2
    object btnNovo: TButton
      Left = 12
      Top = 12
      Width = 75
      Height = 25
      Caption = '&Novo'
      TabOrder = 0
      OnClick = btnNovoClick
    end
    object btnInserir: TButton
      Left = 95
      Top = 12
      Width = 75
      Height = 25
      Caption = '&Inserir'
      Enabled = False
      TabOrder = 1
      OnClick = btnInserirClick
    end
    object btnAtualizar: TButton
      Left = 178
      Top = 12
      Width = 75
      Height = 25
      Caption = 'A&tualizar'
      Enabled = False
      TabOrder = 2
      OnClick = btnAtualizarClick
    end
    object btnDeletar: TButton
      Left = 261
      Top = 12
      Width = 75
      Height = 25
      Caption = '&Deletar'
      Enabled = False
      TabOrder = 3
      OnClick = btnDeletarClick
    end
    object btnFechar: TButton
      Left = 713
      Top = 12
      Width = 75
      Height = 25
      Caption = '&Fechar'
      TabOrder = 4
      OnClick = btnFecharClick
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 230
    Width = 800
    Height = 370
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 3
    object sgBombas: TStringGrid
      Left = 10
      Top = 10
      Width = 780
      Height = 350
      Align = alClient
      ColCount = 6
      DefaultRowHeight = 20
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 0
      OnSelectCell = sgBombasSelectCell
      ColWidths = (
        50
        80
        120
        100
        100
        80)
    end
  end
end
