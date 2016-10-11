object MForm1: TMForm1
  Left = 1047
  Top = 317
  BorderStyle = bsDialog
  Caption = '1.7'
  ClientHeight = 359
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
    Left = 168
    Top = 40
    Width = 23
    Height = 16
    Caption = 'port'
  end
  object Label3: TLabel
    Left = 168
    Top = 104
    Width = 29
    Height = 16
    Caption = 'User'
  end
  object Label4: TLabel
    Left = 168
    Top = 136
    Width = 60
    Height = 16
    Caption = 'Password'
  end
  object SpeedButton2: TSpeedButton
    Left = 128
    Top = 168
    Width = 28
    Height = 27
    Caption = '...'
    OnClick = SpeedButton2Click
  end
  object Label6: TLabel
    Left = 168
    Top = 168
    Width = 110
    Height = 16
    Caption = 'index file of project'
  end
  object Label7: TLabel
    Left = 168
    Top = 200
    Width = 77
    Height = 16
    Caption = 'Control page'
  end
  object lbl1: TLabel
    Left = 168
    Top = 232
    Width = 103
    Height = 16
    Caption = 'Screenshot page'
  end
  object lbl2: TLabel
    Left = 168
    Top = 264
    Width = 110
    Height = 16
    Caption = 'Screenshot quality'
  end
  object lbl3: TLabel
    Left = 168
    Top = 72
    Width = 62
    Height = 16
    Caption = 'Update url'
  end
  object Edit1: TEdit
    Left = 8
    Top = 40
    Width = 149
    Height = 24
    TabOrder = 0
    Text = '80'
  end
  object Edit2: TEdit
    Left = 8
    Top = 104
    Width = 149
    Height = 24
    TabOrder = 1
    Text = 'User'
  end
  object Edit3: TEdit
    Left = 8
    Top = 136
    Width = 149
    Height = 24
    TabOrder = 2
  end
  object Edit5: TEdit
    Left = 8
    Top = 168
    Width = 109
    Height = 24
    TabOrder = 3
  end
  object Edit6: TEdit
    Left = 8
    Top = 200
    Width = 149
    Height = 24
    TabOrder = 4
    Text = '/manage'
  end
  object Button1: TButton
    Tag = 1
    Left = 10
    Top = 316
    Width = 60
    Height = 31
    Caption = 'Run'
    TabOrder = 5
    OnClick = Button1Click
  end
  object edit9: TEdit
    Left = 8
    Top = 232
    Width = 149
    Height = 24
    TabOrder = 6
    Text = '/image.cgi'
  end
  object jpgQuality: TSpinEdit
    Left = 8
    Top = 264
    Width = 149
    Height = 26
    MaxValue = 100
    MinValue = 1
    TabOrder = 7
    Value = 30
  end
  object btn1: TButton
    Left = 150
    Top = 316
    Width = 60
    Height = 31
    Caption = 'Save'
    TabOrder = 8
    OnClick = btn1Click
  end
  object edt1: TEdit
    Left = 8
    Top = 72
    Width = 149
    Height = 24
    TabOrder = 9
    Text = 'updurl'
  end
  object btn2: TButton
    Tag = 1
    Left = 82
    Top = 316
    Width = 60
    Height = 31
    Caption = 'Update'
    TabOrder = 10
    OnClick = btn2Click
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
