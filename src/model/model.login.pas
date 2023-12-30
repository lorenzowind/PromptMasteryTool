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
    function Login(ABody : TJSONObject) : TJSONObject;
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

function TdmLogin.Login(ABody : TJSONObject) : TJSONObject;
begin
  qLogin.SQL.Add('SELECT * FROM Users WHERE UserName = :UserName AND Password = :Password');

  qLogin.Parameters.ParamByName('UserName').Value := ABody.GetValue<String>('UserName');
  qLogin.Parameters.ParamByName('Password').Value := ABody.GetValue<String>('Password');

  qLogin.Open;

  Result := qLogin.ToJSONObject;
end;

end.
