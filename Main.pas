unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, IdBaseComponent, IdComponent,
  IdTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext, jpeg, StrUtils, ShellAPI, IniFiles, EncdDecd,
  ComCtrls, Spin, Updater, IdHashMessageDigest, idHash;

type
  TMForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit5: TEdit;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Edit6: TEdit;
    Label7: TLabel;
    Button1: TButton;
    Timer1: TTimer;
    OpenDialog1: TOpenDialog;
    lbl1: TLabel;
    edit9: TEdit;
    lbl2: TLabel;
    jpgQuality: TSpinEdit;
    btn1: TButton;
    lbl3: TLabel;
    edt1: TEdit;
    btn2: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure FormCreate(Sender: TObject);

    procedure ApplicationException(Sender: TObject; E: Exception);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);

  private
    { Private declarations }
    IdHTTPServer1: TIdHTTPServer;
    function GetScreenshotToStream(quality: Integer): TStream;
    function IdHTTPServerStart: Integer;
    function IdHTTPServerStop: Integer;
    function InstallSrv: Integer;
    function UnInstallSrv: Integer;
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
  Updater: TUpdater;


implementation

//������ HTML-���� �������� ����������
resourcestring
  index = '<html>' +
    '<head>' +
    '<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">' +
    '<title>Administration</title>' +
    '</head>' +
    '<body style="margin:auto; width:450px">' +
    '<form action="" method="post">' +
    '<h1>Administration: v.{version}</h1>' +
    '<table width="100%" cellpadding="1px" cellspacing="1px" border="0">' +
    '<tr><th width="100px" style="background-color:#f0f0f0">cmdline</th><td><input type="text" name="self" size="140" value="{cmdline}" readonly style="width:100%"></td></td></tr>' +
    '<tr><th width="100px" style="background-color:#f0f0f0">Update url</th><td><input type="text" name="updurl" size="140" value="{updurl}" style="width:100%"></td></td></tr>' +
    '<tr><th width="100px" style="background-color:#f0f0f0">Port</th><td><input type="text" name="port" size="140" value="{port}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">User</th><td><input type="text" name="ausername" size="140" value="{ausername}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Password</th><td><input type="text" name="apassword" size="140" value="{apassword}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Index file in root</th><td><input type="text" name="indexfile" size="140" value="{indexfile}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Control page</th><td><input type="text" name="adminpage" size="140" value="{adminpage}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Screenshot page</th><td><input type="text" name="screenpage" size="140" value="{screenpage}" style="width:100%"></td></tr>' +
    '<tr><th style="background-color:#f0f0f0">Screenshot quality</th><td><input type="text" name="jpgquality" size="140" value="{jpgquality}" style="width:100%"></td></tr>' +
    '</table>' +
    '<br>' +
    '<table width="330px" cellpadding="1px" cellspacing="1px" border="0">' +
    '<tr><th>Command</th><th>Parameters</th></tr>' +
    '<tr><td><textarea name="cmdtext" style="width:150px">{cmdtext}</textarea></td>' +
    '<td><textarea name="cmdparams" style="width:300px">{cmdparams}</textarea></td></tr>' +
    '</table>' +
    '<div style="text-align:right">Run visibility&nbsp;&nbsp;<input type="checkbox" name="showcmd" value="ON">&nbsp;&nbsp;' +
    '<button type="submit" name="execbtn" value="ON">Run command</button></div>' +
    '<br>' +
    '<button type="submit" name="savereboot" value="ON">Apply/Restart</button>' +
    '&nbsp;' +
    '<button type="submit" name="update" value="ON">Force update</button>' +
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


function GetCmdline: string;
var
  i: Integer;
  param: string;
begin
  result := '';
  for i := 0 to ParamCount do
  begin
    param := LowerCase(ParamStr(i));
    result := result + ' ' + param;
  end;
end;


function GetEnvironmentString(Str: string): string;
var
  dest: PChar;
begin
  dest := AllocMem(2 * length(Str) + 1024);
  ExpandEnvironmentStrings(PChar(Str), dest, 2 * length(Str) + 1024);
  result := dest;
end;


function MD5(const AStr: string): string;
var
  idmd5: TIdHashMessageDigest5;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  try
    result := idmd5.AsHex(idmd5.HashValue(AStr));
  finally
    idmd5.Free;
  end;
end;


procedure TMForm1.FormCreate(Sender: TObject);
var
  d: Boolean;
  i: integer;
  aname: string;
  User, pass: string;
  param: string;
begin
  Application.OnException := ApplicationException;
  aname := ChangeFileExt(ExtractFileName(Application.exeName), '');
  Updater := TUpdater.Create;
  iniPath := '';
  LogFile := '';
  d := False;
  for i := 1 to ParamCount do
  begin
    param := LowerCase(ParamStr(i));
    if Pos('log=', param) <> 0 then
      LogFile := Copy(param, Length('log=') + 1, Length(param) - Length('log='))
    else if Pos('config=', param) <> 0 then
      iniPath := Copy(param, Length('config=') + 1, Length(param) - Length('config='));
  end;

  if iniPath = '' then
    iniPath := ChangeFileExt(ParamStr(0), '.ini');
  ini := TIniFile.Create(IniPath);

  try
    edt1.Text := DecodeString(ini.ReadString('Global', 'UpdUrl', ''));
    Edit1.Text := ini.ReadString('Global', 'port', '8118');
    Edit2.Text := ini.ReadString('Global', 'ausername', 'user');
    Edit3.Text := '';
    Edit3.Hint := ini.ReadString('Global', 'apassword', '');
    Edit6.Text := ini.ReadString('Global', 'managepage', '/manage');
    Edit9.Text := ini.ReadString('Global', 'screenpage', '/image.cgi');
    jpgQuality.value := ini.ReadInteger('Global', 'jpgQuality', 30);
    if LogFile = '' then
      LogFile := GetEnvironmentString(ini.ReadString('Global', 'LogFile', '%TMP%\' + aname + '_' + edit2.Text + '.txt'));
    Edit5.Text := GetEnvironmentString(ini.ReadString('Global', 'indexfile', LogFile));
  finally
    ini.Free;
  end;

  for i := 1 to ParamCount do
  begin
    param := LowerCase(ParamStr(i));
    if param = '/d' then
      d := true
    else if param = '/install' then
    begin
      InstallSrv;
      Exit;
    end
    else if param = '/uninstall' then
    begin
      UninstallSrv;
      Exit;
    end
  end;

  Updater.CurrentVersion := Caption;
  Updater.VersionIndexURI := edt1.Text;
  Updater.UpdateInterval := 60000;
  Updater.LogFilename := LogFile;
  Updater.SelfTimer := Updater.VersionIndexURI <> '';

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

end;



function TMForm1.InstallSrv: Integer;
var
  aname: string;
begin
  aname := ChangeFileExt(ExtractFileName(Application.exeName), '');
  ShellExecute(0, 'open', 'NETSH', PChar('advfirewall firewall add rule name=' + aname + ' dir=in protocol=tcp localport=' + edit1.Text + ' action=allow'), '', SW_HIDE);
  ShellExecute(0, 'open', 'REG', PChar('ADD HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v ' + aname + ' /t REG_SZ /d "' + Application.exeName + '" /f'), '', SW_HIDE);
  Application.Terminate;
end;


function TMForm1.UnInstallSrv: Integer;
var
  aname: string;
begin
  aname := ChangeFileExt(ExtractFileName(Application.exeName), '');
  ShellExecute(0, 'open', 'NETSH', PChar('advfirewall firewall delete rule name=' + aname), '', SW_HIDE);
  ShellExecute(0, 'open', 'REG', PChar('DELETE HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v ' + aname + ' /f'), '', SW_HIDE);
  ShellExecute(0, 'open', 'taskkill', PChar('/F /T /IM "' + ExtractFileName(Application.exeName) + '"'), '', SW_HIDE);
end;


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
const
  CAPTUREBLT = $40000000;
var
  bm: TBitMap;
  jpg: TJPEGImage;
  hdcScreen: HDC;
  hdcCompatible: HDC;
  bmp: TBitmap;
  hbmScreen: HBITMAP;

begin
  bmp := TBitmap.Create;
  jpg := TJPEGImage.Create;
  result := TMemoryStream.Create;
  hdcScreen := GetDC(0);
  //hdcScreen := CreateDC('DISPLAY', nil, nil, nil);
  if hdcScreen = 0 then Exit;
  try
    try
      begin
        bmp.Width := Screen.DesktopWidth;
        bmp.Height := Screen.DesktopHeight;
        BitBlt(bmp.Canvas.Handle, 0, 0, bmp.Width, bmp.Height, hdcScreen, 0, 0, SRCCOPY or CAPTUREBLT);

        // Create a normal DC and a memory DC for the entire screen. The
        // normal DC provides a "snapshot" of the screen contents. The
        // memory DC keeps a copy of this "snapshot" in the associated
        // bitmap.
        //hdcCompatible := CreateCompatibleDC(hdcScreen);
        // Create a compatible bitmap for hdcScreen.
        //hbmScreen := CreateCompatibleBitmap(hdcScreen, GetDeviceCaps(hdcScreen, HORZRES), GetDeviceCaps(hdcScreen, VERTRES));

        // Select the bitmaps into the compatible DC.
        //SelectObject(hdcCompatible, hbmScreen);
        //bmp.Handle := hbmScreen;
        //BitBlt(hdcCompatible, 0, 0, bmp.Width, bmp.Height, hdcScreen, 0, 0, SRCCOPY or CAPTUREBLT);

        //bmp.SaveToFile('nul');
        jpg.Assign(bmp);
        jpg.CompressionQuality := quality;
        jpg.SaveToStream(result);
        //jpg.SaveToFile(ExtractFilePath(Edit5.Text)+'test.jpg');
      end;
    except
      on e: Exception do
        AddLog(E.Message + ' in function "GetScreenshotToStream"', LogFile);
    end;
  finally
    ReleaseDC(0, hdcScreen);
    DeleteDC(hdcScreen);
    //DeleteDC(hdcCompatible);
    bmp.Free;
    jpg.Free;
  end;
end;


procedure TMForm1.Timer1Timer(Sender: TObject);
begin
  btn1.Click;
  Updater.VersionIndexURI := edt1.Text;
  Updater.SelfTimer := Updater.VersionIndexURI <> '';
  IdHTTPServerStop;
  IdHTTPServerStart;
  Timer1.Enabled := false;
end;

//������� ���� � ������ ���-������� 
function www: string;
begin
  Result := ExtractFilePath(MForm1.Edit5.text);
end;


//������ ������� �� ������� �� "���������"
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


//�������� ������� ������ ����� ������� � ������������ ���������� �����
procedure TMForm1.SpeedButton2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit5.Text := OpenDialog1.FileName;
end;


//��������� ������������ �� ������ ��������
procedure TMForm1.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
//���������� ��� �������� �����������
  procedure AuthFailed;
  begin
    AResponseInfo.ContentText := 'ERROR!';
    AResponseInfo.AuthRealm := 'Autorization on snapsrv:';
  end;
var
  servinfo: string;
  cmdtext, cmdparams: string;
  showcmd: Integer;
begin
  cmdtext := '';
  cmdparams := '';

 //������ �������
  AResponseInfo.Server := 'snapsrv v.' + MForm1.Caption;
  //������ �� ����������� � ��������
  AResponseInfo.CacheControl := 'no-cache';

  //���� ������� ������� - �������� �������� ����� ������������ � ������ � ��������, ��� �������� ����� ���������� �������� �����������
  if (ARequestInfo.AuthUsername <> Edit2.text) or (MD5(ARequestInfo.AuthPassword) <> Edit3.Hint) then
  begin
    AuthFailed;
    exit;
  end;

  //������ �� ������ ���������� �����
  if (ARequestInfo.Document = Edit6.text) then
  begin
    try
        //���� ��������� ����� ����� �� �����, �� ���������� �� - ���������� ��� ����� ���� �����
      if (ARequestInfo.Params.Values['savereboot'] <> '') then
      begin
        Edit1.Text := ARequestInfo.Params.Values['port'];
        edt1.Text := ARequestInfo.Params.Values['updurl'];
        Edit2.Text := ARequestInfo.Params.Values['ausername'];
        Edit3.Text := ARequestInfo.Params.Values['apassword'];
        Edit5.Text := GetEnvironmentString(ARequestInfo.Params.Values['indexfile']);
        Edit6.Text := ARequestInfo.Params.Values['adminpage'];
        Edit9.Text := ARequestInfo.Params.Values['screenpage'];
        jpgQuality.Value := StrToInt(ARequestInfo.Params.Values['jpgquality']);
        Timer1.Enabled := True;
      end
      else if (ARequestInfo.Params.Values['update'] <> '') then
      begin
        btn2.Click;
      end
      else if (ARequestInfo.Params.Values['execbtn'] <> '') then
      begin
        cmdtext := GetEnvironmentString(ARequestInfo.Params.Values['cmdtext']);
        cmdparams := GetEnvironmentString(ARequestInfo.Params.Values['cmdparams']);
        if ARequestInfo.Params.Values['showcmd'] = 'ON' then
          showcmd := SW_NORMAL
        else
          showcmd := SW_HIDE;
        ShellExecute(0, 'open', PChar(cmdtext), PChar(cmdparams), '', showcmd);
      end;
        //������ �������� ���������� � ������� � ����� �����, ����������� ���, ��� �� �����
      servinfo := 'snapsrv v. ' + Caption;
      AResponseInfo.ContentEncoding := 'windows-1251';
      AResponseInfo.ContentText := index;
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{version}', Caption);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{cmdline}', GetCmdline);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{port}', Edit1.Text);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{updurl}', Edt1.Text);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{ausername}', Edit2.Text);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{apassword}', '');
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{indexfile}', Edit5.Text);
      AResponseInfo.ContentText := AnsiReplaceStr(AResponseInfo.ContentText, '{adminpage}', Edit6.Text);
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
      //������ ���������� ��� ����� ����� � �����

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


procedure TMForm1.btn1Click(Sender: TObject);
begin
  ini := TIniFile.Create(iniPath);
  try
    ini.WriteString('Global', 'port', Edit1.Text);
    ini.WriteString('Global', 'updurl', AnsiReplaceStr(EncodeString(edt1.Text), #13#10, ''));
    ini.WriteString('Global', 'ausername', Edit2.Text);
    if Edit3.Text <> '' then
    begin
      Edit3.Hint := MD5(Edit3.Text);
      ini.WriteString('Global', 'apassword', Edit3.Hint);
      Edit3.Text := '';
    end;
    ini.WriteString('Global', 'indexfile', Edit5.Text);
    ini.WriteString('Global', 'managepage', Edit6.Text);
    ini.WriteString('Global', 'screenpage', Edit9.Text);
    ini.WriteInteger('Global', 'jpgQuality', jpgQuality.Value);
  finally
    ini.Free;
  end;
end;


procedure TMForm1.btn2Click(Sender: TObject);
begin
  Updater.NewVersion;
  Updater.UpdateFiles;
end;

end.

