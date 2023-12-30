unit controller.login;

interface

uses
  Horse,
  model.login,
  System.SysUtils,
  System.JSON;

procedure Login;
procedure Post(Req: THorseRequest; Res: THorseResponse);

implementation

procedure Login;
begin
  THorse.Post('/login', Post);
end;

procedure Post(Req: THorseRequest; Res: THorseResponse);
var
  DmLogin : TdmLogin;
begin
  try
    DmLogin := TdmLogin.Create(nil);
    try
      Res.Send<TJSONObject>(DmLogin.Login(TJSONObject.ParseJSONValue(Req.Body) as TJSONObject));
    finally
      Res.Status(200);
      FreeAndNil(DmLogin);
    end;
  except
    on E : Exception do
      begin
        Res.Status(400);
        Res.Send(E.Message);
      end;
  end;
end;

end.
