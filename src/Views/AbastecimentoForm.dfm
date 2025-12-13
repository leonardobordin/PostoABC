object frmAbastecimento: TfrmAbastecimento
  Left = 0
  Top = 0
  Caption = 'Gerenciamento de Abastecimentos'
  ClientHeight = 700
  ClientWidth = 1000
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
    Width = 1000
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = clNavy
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 998
    object lblTitle: TLabel
      Left = 10
      Top = 10
      Width = 398
      Height = 32
      Alignment = taCenter
      Caption = 'Gerenciamento de Abastecimentos'
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
    Width = 1000
    Height = 180
    Align = alTop
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 1
    ExplicitWidth = 998
    object lblBomba: TLabel
      Left = 12
      Top = 12
      Width = 36
      Height = 13
      Caption = 'Bomba'
      FocusControl = cbxBomba
    end
    object lblQuantidade: TLabel
      Left = 170
      Top = 12
      Width = 28
      Height = 13
      Caption = 'Litros'
      FocusControl = edtQuantidade
    end
    object lblValorUnitario: TLabel
      Left = 278
      Top = 12
      Width = 71
      Height = 13
      Caption = 'Valor Unit'#225'rio'
      FocusControl = edtValorUnitario
    end
    object lblValorAbastecimento: TLabel
      Left = 386
      Top = 12
      Width = 89
      Height = 13
      Caption = 'V. Abastecimento'
      FocusControl = edtValorAbastecimento
    end
    object lblImposto: TLabel
      Left = 494
      Top = 12
      Width = 42
      Height = 13
      Caption = 'Imposto'
      FocusControl = edtImposto
    end
    object lblValorTotal: TLabel
      Left = 602
      Top = 12
      Width = 37
      Height = 13
      Caption = 'V. Total'
      FocusControl = edtValorTotal
    end
    object cbxBomba: TComboBox
      Left = 12
      Top = 31
      Width = 150
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbxBombaChange
      OnKeyPress = cbxBombaKeyPress
    end
    object edtQuantidade: TEdit
      Left = 170
      Top = 31
      Width = 100
      Height = 21
      MaxLength = 10
      TabOrder = 1
      OnChange = edtQuantidadeChange
      OnKeyPress = edtQuantidadeKeyPress
    end
    object edtValorUnitario: TEdit
      Left = 278
      Top = 31
      Width = 100
      Height = 21
      MaxLength = 10
      TabOrder = 2
      OnChange = edtValorUnitarioChange
      OnKeyPress = edtValorUnitarioKeyPress
    end
    object edtValorAbastecimento: TEdit
      Left = 386
      Top = 31
      Width = 100
      Height = 21
      ReadOnly = True
      TabOrder = -1
    end
    object edtImposto: TEdit
      Left = 494
      Top = 31
      Width = 100
      Height = 21
      ReadOnly = True
      TabOrder = -1
    end
    object edtValorTotal: TEdit
      Left = 602
      Top = 31
      Width = 100
      Height = 21
      ReadOnly = True
      TabOrder = -1
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 230
    Width = 1000
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 2
    ExplicitWidth = 998
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
    object btnDeletar: TButton
      Left = 178
      Top = 12
      Width = 75
      Height = 25
      Caption = '&Deletar'
      Enabled = False
      TabOrder = 2
      OnClick = btnDeletarClick
    end
    object btnFechar: TButton
      Left = 913
      Top = 12
      Width = 75
      Height = 25
      Caption = '&Fechar'
      TabOrder = 3
      OnClick = btnFecharClick
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 280
    Width = 1000
    Height = 420
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 3
    ExplicitWidth = 998
    ExplicitHeight = 412
    object sgAbastecimentos: TStringGrid
      Left = 10
      Top = 10
      Width = 980
      Height = 400
      Align = alClient
      ColCount = 9
      DefaultRowHeight = 20
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
      TabOrder = 0
      OnSelectCell = sgAbastecimentosSelectCell
      ExplicitWidth = 978
      ExplicitHeight = 392
      ColWidths = (
        50
        200
        80
        80
        100
        100
        100
        80
        150)
    end
  end
end
