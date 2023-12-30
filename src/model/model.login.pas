unit model.login;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  model.con,
  Data.DB,
  Data.Win.ADODB,
  DataSet.Serialize;

type
  TdmLogin = class(TdmCon)
    qLogin: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function Login(Json : TJSONObject) : TJSONObject;
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

function TdmLogin.Login(Json : TJSONObject) : TJSONObject;
begin
  qLogin.SQL.Add('SELECT * FROM Users WHERE UserName = :UserName AND Password = :Password');

  qLogin.Parameters.ParamByName('UserName').Value := Json.GetValue<String>('UserName');
  qLogin.Parameters.ParamByName('Password').Value := Json.GetValue<String>('Password');

  qLogin.Open;

  Result := qLogin.ToJSONObject;
end;

end.
