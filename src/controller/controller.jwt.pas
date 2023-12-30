unit controller.jwt;

interface

uses
  JOSE.Core.JWT,
  JOSE.Types.JSON;

type
  TCustomClaims = class(TJWTClaims)
  strict private
    function  GetId : String;
    procedure SetId(const strValue : String);

  public
    property Id : String read GetId write SetId;
  end;

implementation

{ TCustomClaims }

function TCustomClaims.GetId : String;
begin
  Result := TJSONUtils.GetJSONValue('id', FJSON).AsString;
end;

procedure TCustomClaims.SetId(const strValue : String);
begin
  TJSONUtils.SetJSONValueFrom<String>('id', strValue, FJSON);
end;

end.
