program PromptMasteryTool;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  DotEnv4Delphi,
  System.SysUtils,
  System.IOUtils,
  controller.login in 'src\controller\controller.login.pas',
  model.con in 'src\model\model.con.pas',
  model.login in 'src\model\model.login.pas',
  controller.jwt in 'src\controller\controller.jwt.pas',
  model.users in 'src\model\model.users.pas',
  controller.users in 'src\controller\controller.users.pas';

begin
  DotEnv.Config(TPath.Combine(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0)))), '.env'), True);

  THorse.Use(Jhonson);

  controller.login.Login;
  controller.users.Users;

  THorse.Listen(StrToInt(DotEnv.Env('SERVER_PORT')));
end.
