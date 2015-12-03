unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, IdBaseComponent, IdComponent,
  IdTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext, jpeg, StrUtils, ShellAPI, IniFiles, EncdDecd,
  ComCtrls, Spin, Updater;

type
  TMForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    Edit3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit5: TEdit;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Edit6: TEdit;
    Label7: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Button1: TButton;
    Timer1: TTimer;
    OpenDialog1: TOpenDialog;
    lbl1: TLabel;
    edit9: TEdit;
    lbl2: TLabel;
    jpgQuality: TSpinEdit;
    btn1: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure FormCreate(Sender: TObject);

    procedure ApplicationException(Sender: TObject; E: Exception);
    procedure btn1Click(Sender: TObject);

  private
    { Private declarations }
    IdHTTPServer1: TIdHTTPServer;
    function GetScreenshotToStream(quality: Integer): TStream;
    function IdHTTPServerStart: Integer;
    function IdHTTPServerStop: Integer;
    //function InstallSrv: Integer;
    //function GetNewVersion: Integer;
    //function CopyNewVersion: Integer;
  public
    { Public declarations }
  end;


var
  MForm1: TMForm1;
  //jpgQuality: Integer;
  ini: TIniFile;
  IniPath: string;
  LogFile: string;
  UpdUrl: string;
  Updater: TUpdater;


implementation

//ШАБЛОН HTML-КОДА СТРАНИЦЫ УПРАВЛЕНИЯ
resourcestring
  index = '<html>' +
    '<head>' +
    '<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">' +
    '<title>Administration</title>' +
    '</head>' +
    '<body style="margin:auto; width:350px">' +
    '<form action="" method="post">' +
    '<h1>Administration</h1>' +
    '<table width="330px" cellpadding="1px" cellspacing="1px" border="0">' +
    '<tr><th width="100px" style="background-color:#f0f0f0">Порт</th><td><input type="text" name="port" size="14" value="{port}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Autorization</th><td><input type="checkbox" name="useauth" value="ON" {useauth}></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">User</th><td><input type="text" name="ausername" size="14" value="{ausername}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Password</th><td><input type="text" name="apassword" size="14" value="{apassword}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Index file in root</th><td><input type="text" name="indexfile" size="14" value="{indexfile}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Control page</th><td><input type="text" name="adminpage" size="14" value="{adminpage}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Administrator</th><td><input type="text" name="musername" size="14" value="{musername}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Admin password</th><td><input type="text" name="mpassword" size="14" value="{mpassword}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Screenshot page</th><td><input type="text" name="screenpage" size="14" value="{screenpage}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Screenshot quality</th><td><input type="text" name="jpgquality" size="14" value="{jpgquality}" style="width:100%"></td></tr>' +
    '</table>' +
    '<br>' +
    '<table width="330px" cellpadding="1px" cellspacing="1px" border="0">' +
    '<tr><th>Команда</th><th>Parameters</th></tr>' +
    '<tr><td><textarea name="cmdtext" style="width:160px">{cmdtext}</textarea></td>' +
    '<td><textarea name="cmdparams" style="width:160px">{cmdparams}</textarea></td></tr>' +
    '</table>' +
    '<div style="text-align:right">Run visibility&nbsp;&nbsp;<input type="checkbox" name="showcmd" value="ON">&nbsp;&nbsp;' +
    '<button type="submit" name="execbtn" value="ON">Run</button></div>' +
    '<br>' +
    '<button type="submit" name="savereboot" value="ON">Apply/Restart</button>' +
    '</form>' +
    '</body>' +
    '</html>';


{$R *.dfm}


procedure AddLog(LogString: string; LogFileName: string);
var
  F: TFileStream;
  PStr: PChar;
  Str: string;
  LengthLogString: Cardinal;
begin
  Str := DateTimeToStr(Now()) + ': ' + LogString + #13#10;
  LengthLogString := Length(Str);
  try
    if FileExists(LogFileName) then
      F := TFileStream.Create(LogFileName, fmOpenWrite)
    else
    begin
      ForceDirectories(ExtractFilePath(LogFileName));
      F := TFileStream.Create(LogFileName, fmCreate);
    end;
  except
    Exit;
  end;
  PStr := StrAlloc(LengthLogString + 1);
  try
    try
      StrPCopy(PStr, Str);
      F.Position := F.Size;
      F.Write(PStr^, LengthLogString);
    except
      Exit;
    end;
  finally
    StrDispose(PStr);
    F.Free;
  end;
end;

function GetEnvironmentString(Str: string): string;
var
  dest: PChar;
begin
  dest := AllocMem(1024);
  ExpandEnvironmentStrings(PChar(Str), dest, 1024);
  result := dest;
end;


//function TMForm1.InstallSrv: Integer;
//var
//  aname: string;
//begin
//  aname := ChangeFileExt(ExtractFileName(Application.exeName), '');
//  ShellExecute(0, 'open', 'NETSH', PChar('firewall add allowedprogram program="' + Application.exeName + '" name=' + aname + ' mode=enable scope=all profile=all'), '', SW_HIDE);
//  ShellExecute(0, 'open', 'REG', PChar('ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v ' + aname + ' /t REG_SZ /d "' + Application.exeName + '" /f'), '', SW_HIDE);
//end;


procedure TMForm1.ApplicationException(Sender: TObject; E: Exception);
begin
  AddLog(E.Message, LogFile);
end;

function TMForm1.IdHTTPServerStart: Integer;
var
  strlist: TStringList;
begin
  IdHTTPServer1 := TIdHTTPServer.Create;
  StrList := TStringList.Create;
  try
    try
      IdHTTPServer1.DefaultPort := StrToInt(Edit1.Text);
      IdHTTPServer1.OnCommandGet := IdHTTPServer1CommandGet;
      IdHTTPServer1.MIMETable.SaveToStrings(strlist);
      strlist.Values['.jpg'] := 'image/jpeg';
      IdHTTPServer1.MIMETable.LoadFromStrings(strlist);
      IdHTTPServer1.Active := True;
      Button1.Caption := 'Stop';
      Button1.Tag := 2;
    except
      on e: Exception do
        AddLog(E.Message + ' in function "IdHTTPServerStart"', LogFile);
    end
  finally
    strlist.Free;
  end;
end;

function TMForm1.IdHTTPServerStop: Integer;
begin
  try
    if IdHTTPServer1 <> nil then
    begin
      IdHTTPServer1.Active := False;
      IdHTTPServer1.Free;
      IdHTTPServer1 := nil;
      Button1.Caption := 'Run';
      Button1.Tag := 1;
    end;
  except
    on e: Exception do
      AddLog(E.Message + ' in function "IdHTTPServerStop"', LogFile);
  end
end;

function TMForm1.GetScreenshotToStream(quality: Integer): TStream;
var
  bm: TBitMap;
  jpg: TJPEGImage;
  dc: HDC;
begin
  bm := TBitMap.Create;
  jpg := TJPEGImage.Create;
  result := TMemoryStream.Create;
  dc := GetDC(0);
  if dc = 0 then Exit;
  try
    try
      begin
        bm.Width := Screen.DesktopWidth;
        bm.Height := Screen.DesktopHeight;
        BitBlt(bm.Canvas.Handle, 0, 0, bm.Width, bm.Height, dc, 0, 0, SRCCOPY);
        jpg.Assign(bm);
        jpg.CompressionQuality := quality;
        jpg.SaveToStream(result);
      end;
    except
      on e: Exception do
        AddLog(E.Message + ' in function "GetScreenshotToStream"', LogFile);
    end;
  finally
    ReleaseDC(0, dc);
    jpg.Free;
    bm.Free;
  end;
end;


procedure TMForm1.Timer1Timer(Sender: TObject);
begin
  btn1.Click;
  IdHTTPServerStop;
  IdHTTPServerStart;
  Timer1.Enabled := false;
end;

//возврат пути к файлам веб-сервера

function www: string;
begin
  Result := ExtractFilePath(MForm1.Edit5.text);
end;

//запуск сервера по нажатию на "Запустить"

procedure TMForm1.Button1Click(Sender: TObject);
begin
  case Button1.Tag of
    1: begin
        IdHTTPServerStart;
      end;
    2: begin
        IdHTTPServerStop;
      end;
  end;

end;

//открытие диалога выбора файла индекса и одновременно директории сайта

procedure TMForm1.SpeedButton2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit5.Text := OpenDialog1.FileName;
end;

//обработка поступившенй на сервер комманды

procedure TMForm1.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
//процедурка для неверной авторизации
  procedure AuthFailed;
  begin
    AResponseInfo.ContentText := 'ERROR!';
    AResponseInfo.AuthRealm := 'Autorization on snapsrv:';
  end;
var
  chk1, servinfo: string;
  cmdtext, cmdparams: string;
  showcmd: Integer;
begin
  cmdtext := '';
  cmdparams := '';

 //версия сервера
  AResponseInfo.Server := 'snapsrv v. 1.0';
  //запрет на кэширование в браузере
  AResponseInfo.CacheControl := 'no-cache';

  //если отмечен чекбокс - проверка введённых имени пользователя и пароля с таковыми, при неуспехе вызов процедурки неверной авторизации
  if (CheckBox1.Checked and (((ARequestInfo.AuthUsername <> Edit2.text) or (ARequestInfo.AuthPassword <> Edit3.text)) and ((ARequestInfo.AuthUsername <> Edit7.text) or (ARequestInfo.AuthPassword <> Edit8.text)))) then
  begin
    AuthFailed;
    exit;
  end;


  //запрос на выдачу индексного файла
  if (ARequestInfo.Document = Edit6.text) then
  begin
    if ((ARequestInfo.AuthUsername <> Edit7.text) or (ARequestInfo.AuthPassword <> Edit8.text)) then
    begin
      AuthFailed;
      exit;
    end;
    try
        //если параметры полей ввода не пусты, то применение их - заполнение ими полей вода формы
      if (ARequestInfo.Params.Values['savereboot'] <> '') then
      begin
        Edit1.Text := ARequestInfo.Params.Values['port'];
        Edit2.Text := ARequestInfo.Params.Values['ausername'];
        Edit3.Text := ARequestInfo.Params.Values['apassword'];
        Edit5.Text := ARequestInfo.Params.Values['indexfile'];
        Edit6.Text := ARequestInfo.Params.Values['adminpage'];
        Edit7.Text := ARequestInfo.Params.Values['musername'];
        Edit8.Text := ARequestInfo.Params.Values['mpassword'];
        Edit9.Text := ARequestInfo.Params.Values['screenpage'];
        jpgQuality.Value := StrToInt(ARequestInfo.Params.Values['jpgquality']);
        if ARequestInfo.Params.Values['useauth'] = 'ON' then
          CheckBox1.Checked := true
        else
          CheckBox1.Checked := false;
        Timer1.Enabled := True;
      end
      else if (ARequestInfo.Params.Values['execbtn'] <> '') then
      begin
        cmdtext := ARequestInfo.Params.Values['cmdtext'];
        cmdparams := ARequestInfo.Params.Values['cmdparams'];
        if ARequestInfo.Params.Values['showcmd'] = 'ON' then
          showcmd := SW_NORMAL
        else
          showcmd := SW_HIDE;
        ShellExecute(0, 'open', PChar(cmdtext), PChar(cmdparams), '', showcmd);
      end;
        //выдача страницы управления с данными в полях ввода, идентичными тем, что на форме
      servinfo := 'snapsrv v. ' + MForm1.Caption;
      if CheckBox1.Checked = true then chk1 := 'checked' else chk1 := '';
      AResponseInfo.ContentEncoding := 'windows-1251';
      AResponseInfo.ContentText := index;
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{port}', Edit1.Text);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{useauth}', chk1);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{ausername}', Edit2.Text);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{apassword}', Edit3.Text);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{indexfile}', Edit5.Text);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{adminpage}', Edit6.Text);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{musername}', Edit7.Text);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{mpassword}', Edit8.Text);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{screenpage}', Edit9.Text);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{jpgquality}', IntToStr(jpgQuality.Value));
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{cmdtext}', cmdtext);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{cmdparams}', cmdparams);

    except
      AResponseInfo.ContentText := 'Server Error!';
    end;

  end
  else
    if ARequestInfo.Document = edit9.Text then
    begin
      try
        AResponseInfo.ContentType := IdHTTPServer1.MIMETable.GetFileMIMEType('.jpg');
        AResponseInfo.ContentStream := GetScreenshotToStream(jpgQuality.value);
      except
        on e: Exception do
          AddLog(E.Message + ' in function "IdHTTPServer1CommandGet"', LogFile);
      end
    end
    else
    begin
      try
      //отдача индексного или иного файла с диска

        if ARequestInfo.Document = '/' then
        begin
          AResponseInfo.ContentType := IdHTTPServer1.MIMETable.GetFileMIMEType(Edit5.text);
          AResponseInfo.ContentStream := TFileStream.Create(Edit5.text, fmOpenRead)
        end
        else
        begin
          AResponseInfo.ContentType := IdHTTPServer1.MIMETable.GetFileMIMEType(ARequestInfo.Document);
          AResponseInfo.ContentStream := TFileStream.Create(www + ARequestInfo.Document, fmOpenRead);
        end;
      except
        AResponseInfo.ContentText := 'File not found or access denied!';
      end;
    end;
end;



procedure TMForm1.FormCreate(Sender: TObject);
var
  d: Boolean;
  i: integer;
  User, pass: string;

begin
  Application.OnException := ApplicationException;
  Updater := TUpdater.Create;
  iniPath := '';
  LogFile := '';
  d := False;
  for i := 1 to ParamCount do
  begin
    if Pos('log=', ParamStr(i)) <> 0 then
      LogFile := Copy(ParamStr(i), Length('log=') + 1, Length(ParamStr(i)) - Length('log='))
    else if Pos('config=', ParamStr(i)) <> 0 then
      iniPath := Copy(ParamStr(i), Length('config=') + 1, Length(ParamStr(i)) - Length('config='))
    else if ParamStr(i) = '-d' then
      d := true
    //else if ParamStr(i) = '/install' then
    //  InstallSrv
    else if Pos('help', ParamStr(i)) <> 0 then
    begin
      MessageBox(Handle, PChar('Usage: [log=logFile] | [config=configFile] | [-d] | [help]'), PChar(ExtractFileName(Application.ExeName) + ' v. ' + MForm1.Caption), MB_ICONQUESTION);
      Application.Terminate;
      Exit;
    end;
  end;

  if iniPath = '' then
    iniPath := ChangeFileExt(ParamStr(0), '.ini');
  ini := TIniFile.Create(IniPath);

  try
    UpdUrl := ini.ReadString('Global', 'UpdUrl', 'localhost');
    Edit1.Text := ini.ReadString('Global', 'port', '80');
    CheckBox1.Checked := ini.ReadBool('Global', 'useauth', false);
    Edit2.Text := ini.ReadString('Global', 'ausername', 'user');
    Edit3.Text := DecodeString(ini.ReadString('Global', 'apassword', ''));
    Edit5.Text := GetEnvironmentString(ini.ReadString('Global', 'indexfile', ''));
    Edit6.Text := ini.ReadString('Global', 'managepage', '/manage');
    Edit7.Text := ini.ReadString('Global', 'musername', 'admin');
    Edit8.Text := DecodeString(ini.ReadString('Global', 'mpassword', ''));
    Edit9.Text := ini.ReadString('Global', 'screenpage', '/image.cgi');
    jpgQuality.value := ini.ReadInteger('Global', 'jpgQuality', 30);
    if LogFile = '' then
      LogFile := ini.ReadString('Global', 'LogFile', '');
    LogFile := GetEnvironmentString(LogFile);



    if d then
    begin
      ShowWindow(Handle, SW_NORMAL);
      Application.ShowMainForm := True;
    end
    else
    begin
      ShowWindow(Handle, SW_HIDE);
      Application.ShowMainForm := false;
      IdHTTPServerStart;
    end;
  finally
    ini.Free;
  end;


  Updater.CurrentVersion := Caption;
  Updater.VersionIndexURI := UpdUrl;
  Updater.UpdateInterval := 60000;
  Updater.LogFilename := LogFile;
  Updater.SelfTimer := true;
end;

procedure TMForm1.btn1Click(Sender: TObject);
begin
  ini := TIniFile.Create(iniPath);
  try
    ini.WriteString('Global', 'port', Edit1.Text);
    ini.WriteBool('Global', 'useauth', CheckBox1.Checked);
    ini.WriteString('Global', 'ausername', Edit2.Text);
    ini.WriteString('Global', 'apassword', EncodeString(Edit3.Text));
    ini.WriteString('Global', 'indexfile', Edit5.Text);
    ini.WriteString('Global', 'managepage', Edit6.Text);
    ini.WriteString('Global', 'musername', Edit7.Text);
    ini.WriteString('Global', 'mpassword', EncodeString(Edit8.Text));
    ini.WriteString('Global', 'screenpage', Edit9.Text);
    ini.WriteInteger('Global', 'jpgQuality', jpgQuality.Value);
  finally
    ini.Free;
  end;
end;

end.

