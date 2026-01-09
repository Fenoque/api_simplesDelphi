// unit Horse.Logger.Middleware.pas
unit Horse.Logger.Middleware;

interface

uses
  Horse,
  Horse.Commons,
  System.SysUtils,
  System.DateUtils;

type
  THorseLoggerMiddleware = class
  public
    class procedure OnRequest(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ THorseLoggerMiddleware }

class procedure THorseLoggerMiddleware.OnRequest(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LStartTime: TDateTime;
  LMethod: string;
  LPath: string;
begin
  LStartTime := Now;
  LMethod := Req.Method.ToString;
  LPath := Req.RawWebRequest.PathInfo;

  // Log da requisição
  Writeln(Format('[%s] REQUEST: %s %s',
    [FormatDateTime('hh:nn:ss', Now), LMethod, LPath]));

  try
    Next;
  finally
    // Log da resposta
    Writeln(Format('[%s] RESPONSE: %s %s -> %d (%d ms)',
      [FormatDateTime('hh:nn:ss', Now),
       LMethod,
       LPath,
       Res.Status,
       MilliSecondsBetween(Now, LStartTime)]));
  end;
end;

end.
