object MForm1: TMForm1
  Left = 488
  Top = 336
  BorderStyle = bsDialog
  Caption = '1.7'
  ClientHeight = 390
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 115
  TextHeight = 16
  object Label1: TLabel
    Left = 98
    Top = 10
    Width = 103
    Height = 16
    Caption = 'Administration:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 167
    Top = 42
    Width = 23
    Height = 16
    Caption = 'port'
  end
  object Label3: TLabel
    Left = 167
    Top = 78
    Width = 29
    Height = 16
    Caption = 'User'
  end
  object Label4: TLabel
    Left = 167
    Top = 107
    Width = 60
    Height = 16
    Caption = 'Password'
  end
  object SpeedButton2: TSpeedButton
    Left = 128
    Top = 142
    Width = 28
    Height = 27
    Caption = '...'
    OnClick = SpeedButton2Click
  end
  object Label6: TLabel
    Left = 167
    Top = 145
    Width = 110
    Height = 16
    Caption = 'index file of project'
  end
  object Label7: TLabel
    Left = 167
    Top = 185
    Width = 77
    Height = 16
    Caption = 'Control page'
  end
  object Label8: TLabel
    Left = 167
    Top = 217
    Width = 78
    Height = 16
    Caption = 'Administrator'
  end
  object Label9: TLabel
    Left = 167
    Top = 244
    Width = 100
    Height = 16
    Caption = 'Admin password'
  end
  object lbl1: TLabel
    Left = 167
    Top = 273
    Width = 103
    Height = 16
    Caption = 'Screenshot page'
  end
  object lbl2: TLabel
    Left = 167
    Top = 303
    Width = 110
    Height = 16
    Caption = 'Screenshot quality'
  end
  object Edit1: TEdit
    Left = 10
    Top = 39
    Width = 149
    Height = 24
    TabOrder = 0
    Text = '80'
  end
  object Edit2: TEdit
    Left = 10
    Top = 73
    Width = 149
    Height = 24
    TabOrder = 1
    Text = 'User'
  end
  object Edit3: TEdit
    Left = 10
    Top = 102
    Width = 149
    Height = 24
    TabOrder = 2
  end
  object Edit5: TEdit
    Left = 10
    Top = 142
    Width = 109
    Height = 24
    TabOrder = 3
  end
  object Edit6: TEdit
    Left = 10
    Top = 181
    Width = 149
    Height = 24
    TabOrder = 4
    Text = '/manage'
  end
  object Edit7: TEdit
    Left = 10
    Top = 210
    Width = 149
    Height = 24
    TabOrder = 5
    Text = 'Admin'
  end
  object Edit8: TEdit
    Left = 10
    Top = 240
    Width = 149
    Height = 24
    TabOrder = 6
  end
  object Button1: TButton
    Tag = 1
    Left = 10
    Top = 348
    Width = 92
    Height = 31
    Caption = 'Run'
    TabOrder = 7
    OnClick = Button1Click
  end
  object edit9: TEdit
    Left = 10
    Top = 270
    Width = 149
    Height = 24
    TabOrder = 8
    Text = '/image.cgi'
  end
  object jpgQuality: TSpinEdit
    Left = 10
    Top = 299
    Width = 149
    Height = 26
    MaxValue = 100
    MinValue = 1
    TabOrder = 9
    Value = 30
  end
  object btn1: TButton
    Left = 118
    Top = 348
    Width = 100
    Height = 31
    Caption = 'Save'
    TabOrder = 10
    OnClick = btn1Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 264
    Top = 32
  end
  object OpenDialog1: TOpenDialog
    Left = 216
    Top = 32
  end
end
