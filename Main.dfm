object MForm1: TMForm1
  Left = 365
  Top = 219
  BorderStyle = bsDialog
  Caption = '1.4'
  ClientHeight = 417
  ClientWidth = 395
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
    Top = 94
    Width = 29
    Height = 16
    Caption = 'User'
  end
  object Label4: TLabel
    Left = 167
    Top = 123
    Width = 60
    Height = 16
    Caption = 'Password'
  end
  object SpeedButton2: TSpeedButton
    Left = 128
    Top = 158
    Width = 28
    Height = 27
    Caption = '...'
    OnClick = SpeedButton2Click
  end
  object Label6: TLabel
    Left = 167
    Top = 161
    Width = 110
    Height = 16
    Caption = 'index file of project'
  end
  object Label7: TLabel
    Left = 167
    Top = 201
    Width = 77
    Height = 16
    Caption = 'Control page'
  end
  object Label8: TLabel
    Left = 167
    Top = 233
    Width = 78
    Height = 16
    Caption = 'Administrator'
  end
  object Label9: TLabel
    Left = 167
    Top = 260
    Width = 100
    Height = 16
    Caption = 'Admin password'
  end
  object lbl1: TLabel
    Left = 167
    Top = 289
    Width = 103
    Height = 16
    Caption = 'Screenshot page'
  end
  object lbl2: TLabel
    Left = 167
    Top = 319
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
    Top = 89
    Width = 149
    Height = 24
    TabOrder = 1
    Text = 'User'
  end
  object CheckBox1: TCheckBox
    Left = 10
    Top = 69
    Width = 208
    Height = 21
    Caption = 'Use Auth'
    TabOrder = 2
  end
  object Edit3: TEdit
    Left = 10
    Top = 118
    Width = 149
    Height = 24
    TabOrder = 3
  end
  object Edit5: TEdit
    Left = 10
    Top = 158
    Width = 109
    Height = 24
    TabOrder = 4
  end
  object Edit6: TEdit
    Left = 10
    Top = 197
    Width = 149
    Height = 24
    TabOrder = 5
    Text = '/manage'
  end
  object Edit7: TEdit
    Left = 10
    Top = 226
    Width = 149
    Height = 24
    TabOrder = 6
    Text = 'Admin'
  end
  object Edit8: TEdit
    Left = 10
    Top = 256
    Width = 149
    Height = 24
    TabOrder = 7
  end
  object Button1: TButton
    Tag = 1
    Left = 10
    Top = 364
    Width = 92
    Height = 31
    Caption = 'Run'
    TabOrder = 8
    OnClick = Button1Click
  end
  object edit9: TEdit
    Left = 10
    Top = 286
    Width = 149
    Height = 24
    TabOrder = 9
    Text = '/image.cgi'
  end
  object jpgQuality: TSpinEdit
    Left = 10
    Top = 315
    Width = 149
    Height = 26
    MaxValue = 100
    MinValue = 1
    TabOrder = 10
    Value = 30
  end
  object btn1: TButton
    Left = 118
    Top = 364
    Width = 100
    Height = 31
    Caption = 'Save'
    TabOrder = 11
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
