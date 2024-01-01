unit utils.logger;

interface

uses
  Horse.Logger.Provider.LogFile;

function GetLoggerFormat                   : String;
function GetLoggerDir   (strPath : String) : String;
function GetLoggerConfig(strPath : String) : THorseLoggerLogFileConfig;

implementation

uses
  System.IOUtils,
  System.SysUtils,
  System.DateUtils;

function GetLoggerFormat : String;
begin
  Result := '[${time}]';
  Result := Result + ' [ip=${request_clientip}]';
  Result := Result + ' : Response';
  Result := Result + ' [${execution_time} ms]';
  Result := Result + ' [${response_content_length} bytes]';
  Result := Result + ' [status=${response_status}]';
  Result := Result + ' : Request';
  Result := Result + ' [${request_content_length} bytes]';
  Result := Result + ' [${request_method} :${request_server_port}${request_path_info}/${request_query}]';
  Result := Result + ' [${request_version}:${request_user_agent}:${request_connection}]';
  Result := Result + ' [auth=${request_authorization}]';
end;

function GetLoggerDir(strPath : String) : String;
var
  dtDate    : TDateTime;
  strMonth  : String;
  strDay    : String;
  strFolder : String;
begin
  dtDate   := Today;
  strMonth := IntToStr(MonthOf(dtDate));

  if (Length(strMonth) = 1) then
    strMonth := '0' + strMonth;

  strDay := IntToStr(DayOf(dtDate));

  if (Length(strDay) = 1) then
    strDay := '0' + strDay;

  strFolder := 'EventLogs' + IntToStr(YearOf(dtDate)) + strMonth + strDay;

  Result := TPath.Combine(strPath, 'data');
  Result := TPath.Combine(Result, 'log');
  Result := TPath.Combine(Result, strFolder);
end;

function GetLoggerConfig(strPath : String) : THorseLoggerLogFileConfig;
begin
  Result := THorseLoggerLogFileConfig.New.SetLogFormat(GetLoggerFormat).SetDir(GetLoggerDir(strPath));
end;

end.
