unit controller.login;

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
  controller.jwt,
  model.login;

procedure Login;
procedure ProcessLogin(Req : THorseRequest; Res : THorseResponse);

function GenerateToken(nUserID : Integer) : String;

implementation

procedure Login;
begin
  THorse.Post('/login', ProcessLogin);
end;

procedure ProcessLogin(Req : THorseRequest; Res : THorseResponse);
var
  DmLogin : TdmLogin;
  Json    : TJSONObject;
begin
  try
    DmLogin := TdmLogin.Create(nil);
    try
      Json := DmLogin.Login(TJSONObject.ParseJSONValue(Req.Body) as TJSONObject);

      Json.AddPair('jwt', GenerateToken(Json.GetValue<Integer>('id')));

      Res.Send<TJSONObject>(Json);
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

function GenerateToken(nUserID : Integer) : String;
var
  Token    : TJWT;
  Claims   : TCustomClaims;
  strToken : String;
begin
  Token := TJWT.Create();
  try
    Claims := TCustomClaims(Token.Claims);

    Claims.Expiration := IncHour(Now, 1);
    Claims.Id         := IntToStr(nUserID);

    strToken := TJOSE.SHA256CompactToken(DotEnv.Env('JWT_PASSWORD'), Token);
  finally
    FreeAndNil(Token);
  end;

  Result := strToken;
end;

end.
