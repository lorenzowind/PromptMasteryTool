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
  model.con in 'src\model\model.con.pas' {dmCon: TDataModule},
  model.login in 'src\model\model.login.pas' {dmLogin: TDataModule};

begin
  DotEnv.Config(TPath.Combine(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0)))), '.env'), True);

  THorse.Use(Jhonson);

  controller.login.Login;

  THorse.Listen(StrToInt(DotEnv.Env('SERVER_PORT')));
end.
