program PromptMasteryTool;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Compression,
  Horse.HandleException,
  Horse.Jhonson,
  Horse.Logger,
  Horse.Logger.Provider.LogFile,
  DotEnv4Delphi,
  System.SysUtils,
  System.IOUtils,
  controller.login in 'src\controller\controller.login.pas',
  model.con in 'src\model\model.con.pas',
  model.login in 'src\model\model.login.pas',
  controller.jwt in 'src\controller\controller.jwt.pas',
  model.users in 'src\model\model.users.pas',
  controller.users in 'src\controller\controller.users.pas',
  utils.logger in 'src\utils\utils.logger.pas';

var
  strPath : String;
begin
  strPath := ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))));

  DotEnv.Config(TPath.Combine(strPath, '.env'), True);

  THorseLoggerManager.RegisterProvider(THorseLoggerProviderLogFile.New(GetLoggerConfig(strPath)));

  THorse.Use(Compression());
  THorse.Use(Jhonson());
  THorse.Use(HandleException);
  THorse.Use(THorseLoggerManager.HorseCallback);

  controller.login.Login;
  controller.users.Users;

  THorse.Listen(StrToInt(DotEnv.Env('SERVER_PORT')));
end.
