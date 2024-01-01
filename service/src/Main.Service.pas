unit Main.Service;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.SvcMgr,
  Vcl.Dialogs;

type
  TPromptMasteryTool = class(TService)
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceStart (Sender: TService; var Started: Boolean);
    procedure ServiceStop  (Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  PromptMasteryTool: TPromptMasteryTool;

implementation

uses
  Horse,
  Horse.Compression,
  Horse.HandleException,
  Horse.Jhonson,
  Horse.Logger,
  Horse.Logger.Provider.LogFile,
  DotEnv4Delphi,
  System.IOUtils,
  controller.login,
  controller.users,
  utils.logger;

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  PromptMasteryTool.Controller(CtrlCode);
end;

function TPromptMasteryTool.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TPromptMasteryTool.ServiceCreate(Sender: TObject);
var
  strPath : String;
begin
  strPath := ExtractFileDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0)))));

  DotEnv.Config(TPath.Combine(strPath, '.env'), True);

  THorseLoggerManager.RegisterProvider(THorseLoggerProviderLogFile.New(GetLoggerConfig(strPath)));

  THorse.Use(Compression());
  THorse.Use(Jhonson());
  THorse.Use(HandleException);
  THorse.Use(THorseLoggerManager.HorseCallback);

  Login;
  Users;
end;

procedure TPromptMasteryTool.ServiceStart(Sender: TService; var Started: Boolean);
begin
  THorse.Listen(StrToInt(DotEnv.Env('SERVER_PORT')));
  Started := True;
end;

procedure TPromptMasteryTool.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  THorse.StopListen;
  Stopped := True;
end;

end.
