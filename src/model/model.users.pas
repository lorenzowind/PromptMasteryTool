unit model.users;

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
  TdmUsers = class(TdmCon)
    qUsers: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetUser(nUserID : Integer) : TJSONObject;
    function CreateUser(Json : TJSONObject) : TJSONObject;
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

function TdmUsers.GetUser(nUserID : Integer) : TJSONObject;
begin
  qUsers.SQL.Add('SELECT * FROM Users WHERE Id = :Id');

  qUsers.Parameters.ParamByName('Id').Value := nUserID;

  qUsers.Open;

  Result := qUsers.ToJSONObject;
end;

function TdmUsers.CreateUser(Json : TJSONObject) : TJSONObject;
begin
  qUsers.SQL.Add('SELECT * FROM Users');

  qUsers.Open;

  qUsers.LoadFromJSON(Json);

  qUsers.Last;

  Result := qUsers.ToJSONObject;
end;

end.
