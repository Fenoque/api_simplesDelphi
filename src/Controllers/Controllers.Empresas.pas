unit Controllers.Empresas;

interface

uses
  System.Generics.Collections,
  System.JSON,
  Horse,
  Service.Empresa,
  System.SysUtils;

type
  TControllerEmpresas = class

  class procedure ObtemEmpresas(ARequest: THorseRequest; AResponse: THorseResponse);

  public
    class procedure Registry;

end;

implementation

{ TControllerEmpresas }

class procedure TControllerEmpresas.ObtemEmpresas(ARequest: THorseRequest;
  AResponse: THorseResponse);
var
  LServiceEmpresa: TServiceEmpresa;
begin
  LServiceEmpresa := TServiceEmpresa.Create;
  try
    LServiceEmpresa.ListarEmpresa(ARequest.Query.Dictionary);
    AResponse.Send(LServiceEmpresa.JSONArray);
  finally
    FreeAndNil(LServiceEmpresa);
  end;

end;

class procedure TControllerEmpresas.Registry;
begin
  THorse.Get('/empresa', ObtemEmpresas);
end;

end.
