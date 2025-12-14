object frmTanque: TfrmTanque
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Gerenciamento de Tanques'
  ClientHeight = 531
  ClientWidth = 784
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
    Width = 784
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = clNavy
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 10
      Top = 10
      Width = 310
      Height = 32
      Alignment = taCenter
      Caption = 'Gerenciamento de Tanques'
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
    Width = 784
    Height = 150
    Align = alTop
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 1
    object lblNome: TLabel
      Left = 12
      Top = 12
      Width = 30
      Height = 13
      Caption = 'Nome'
      FocusControl = edtNome
    end
    object lblTipo: TLabel
      Left = 325
      Top = 12
      Width = 22
      Height = 13
      Caption = 'Tipo'
      FocusControl = edtTipo
    end
    object lblCapacidade: TLabel
      Left = 537
      Top = 12
      Width = 60
      Height = 13
      Caption = 'Capacidade'
      FocusControl = edtCapacidade
    end
    object lblNivelAtual: TLabel
      Left = 649
      Top = 12
      Width = 55
      Height = 13
      Caption = 'N'#237'vel Atual'
      FocusControl = edtNivelAtual
    end
    object edtNome: TEdit
      Left = 12
      Top = 31
      Width = 300
      Height = 21
      MaxLength = 100
      TabOrder = 0
      OnKeyPress = edtNomeKeyPress
    end
    object edtTipo: TEdit
      Left = 325
      Top = 31
      Width = 200
      Height = 21
      MaxLength = 50
      TabOrder = 1
      OnKeyPress = edtTipoKeyPress
    end
    object edtCapacidade: TEdit
      Left = 537
      Top = 31
      Width = 100
      Height = 21
      TabOrder = 2
      OnKeyPress = edtCapacidadeKeyPress
    end
    object edtNivelAtual: TEdit
      Left = 649
      Top = 31
      Width = 100
      Height = 21
      TabOrder = 3
      OnKeyPress = edtNivelAtualKeyPress
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 200
    Width = 784
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 2
    object btnNovo: TButton
      Left = 14
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
      Left = 260
      Top = 12
      Width = 75
      Height = 25
      Caption = '&Deletar'
      Enabled = False
      TabOrder = 3
      OnClick = btnDeletarClick
    end
    object btnFechar: TButton
      Left = 699
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
    Top = 250
    Width = 784
    Height = 281
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 3
    object sgTanques: TStringGrid
      Left = 10
      Top = 10
      Width = 764
      Height = 261
      Align = alClient
      DefaultRowHeight = 20
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
      TabOrder = 0
      OnSelectCell = sgTanquesSelectCell
      ColWidths = (
        50
        130
        149
        166
        176)
    end
  end
end
