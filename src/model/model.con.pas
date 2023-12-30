unit model.con;

interface

uses
  System.SysUtils,
  System.Classes,
  Winapi.ActiveX,
  Data.DBXMySQL,
  Data.DB,
  Data.SqlExpr,
  Data.Win.ADODB,
  DotEnv4Delphi;

const
  c_strProviderDefault  = 'MSOLEDBSQL19.1';

type
  TdmCon = class(TDataModule)
    DB: TADOConnection;
  private
    { Private declarations }
    procedure ConfigureDB;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

constructor TdmCon.Create(AOwner: TComponent);
begin
  CoInitialize(nil);

  inherited Create(AOwner);

  ConfigureDB;
end;

procedure TdmCon.ConfigureDB;
var
  strCon : String;
begin
  DB.Close;

  strCon := 'Provider=' + c_strProviderDefault +
            ';Data Source=' + DotEnv.Env('SQLSERVER_HOST') + ',' + DotEnv.Env('SQLSERVER_PORT') +
            ';User ID=' + DotEnv.Env('SQLSERVER_USER') +
            ';Password=' + DotEnv.Env('SQLSERVER_PASSWORD') +
            ';Initial Catalog=' + DotEnv.Env('SQLSERVER_DATABASE') +
            ';Persist Security Info=True;Use Encryption for Data=Optional';

  DB.ConnectionString := strCon;
  DB.LoginPrompt      := False;

  DB.Open;
end;

end.
