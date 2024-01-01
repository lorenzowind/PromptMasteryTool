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
  Horse.Jhonson,
  DotEnv4Delphi,
  System.IOUtils,
  controller.login,
  controller.users;

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
begin
  DotEnv.Config(TPath.Combine(ExtractFileDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))), '.env'), True);

  THorse.Use(Jhonson);

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
