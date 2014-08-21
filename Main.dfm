object MForm1: TMForm1
  Left = 365
  Top = 219
  BorderStyle = bsDialog
  Caption = '1.3'
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
    Width = 158
    Height = 16
    Caption = #1040#1076#1084#1080#1085#1080#1089#1090#1088#1080#1088#1086#1074#1072#1085#1080#1077':'
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
    Width = 31
    Height = 16
    Caption = #1087#1086#1088#1090
  end
  object Label3: TLabel
    Left = 167
    Top = 94
    Width = 93
    Height = 16
    Caption = #1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
  end
  object Label4: TLabel
    Left = 167
    Top = 123
    Width = 47
    Height = 16
    Caption = #1087#1072#1088#1086#1083#1100
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
    Width = 219
    Height = 16
    Caption = #1080#1085#1076#1077#1082#1089#1085#1099#1081' '#1092#1072#1081#1083' '#1074' '#1087#1072#1087#1082#1077' '#1087#1088#1086#1077#1082#1090#1072
  end
  object Label7: TLabel
    Left = 167
    Top = 201
    Width = 144
    Height = 16
    Caption = #1089#1090#1088#1072#1085#1080#1094#1072' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103
  end
  object Label8: TLabel
    Left = 167
    Top = 233
    Width = 201
    Height = 16
    Caption = #1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1076#1083#1103' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103
  end
  object Label9: TLabel
    Left = 167
    Top = 260
    Width = 169
    Height = 16
    Caption = #1087#1072#1088#1086#1083#1100' '#1076#1083#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  end
  object lbl1: TLabel
    Left = 167
    Top = 289
    Width = 138
    Height = 16
    Caption = #1089#1090#1088#1072#1085#1080#1094#1072'  '#1089#1082#1088#1080#1085#1096#1086#1090#1072
  end
  object lbl2: TLabel
    Left = 167
    Top = 319
    Width = 134
    Height = 16
    Caption = #1082#1072#1095#1077#1089#1090#1074#1086' '#1089#1082#1088#1080#1085#1096#1086#1090#1072
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
    Caption = #1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1102
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
    Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100
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
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
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
