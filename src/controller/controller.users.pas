unit controller.users;

interface

uses
  Horse,
  Horse.JWT,
  System.DateUtils,
  System.SysUtils,
  System.JSON,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  DotEnv4Delphi,
  model.users;

procedure Users;
procedure ProcessGetUser(Req : THorseRequest; Res : THorseResponse);
procedure ProcessCreateUser(Req : THorseRequest; Res : THorseResponse);

implementation

procedure Users;
begin
  THorse
    .AddCallback(HorseJWT(DotEnv.Env('JWT_PASSWORD')))
    .Get('/users/:id', ProcessGetUser);

  THorse
    .AddCallback(HorseJWT(DotEnv.Env('JWT_PASSWORD')))
    .Post('/users', ProcessCreateUser);
end;

procedure ProcessGetUser(Req : THorseRequest; Res : THorseResponse);
var
  DmUsers : TdmUsers;
begin
  try
    DmUsers := TdmUsers.Create(nil);
    try
      Res.Send<TJSONObject>(DmUsers.GetUser(StrToInt(Req.Params.Items['id'])));
    finally
      Res.Status(200);
      FreeAndNil(DmUsers);
    end;
  except
    on E : Exception do
      begin
        Res.Status(400);
        Res.Send(E.Message);
      end;
  end;
end;

procedure ProcessCreateUser(Req : THorseRequest; Res : THorseResponse);
var
  DmUsers : TdmUsers;
  Json    : TJSONObject;
begin
  try
    DmUsers := TdmUsers.Create(nil);
    try
      Res.Send<TJSONObject>(DmUsers.CreateUser(TJSONObject.ParseJSONValue(Req.Body) as TJSONObject));
    finally
      Res.Status(200);
      FreeAndNil(DmUsers);
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
