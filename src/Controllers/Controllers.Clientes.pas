unit Controllers.Clientes;

interface

uses
  System.Generics.Collections,
  System.JSON,
  Horse,
  Service.Clientes,
  System.SysUtils;

type
  TControllerClientes = class

  class procedure ObtemClientes(ARequest: THorseRequest; AResponse: THorseResponse);
  class procedure CriarClientes(ARequest: THorseRequest; AResponse: THorseResponse);
  class procedure AlteraClientes(ARequest: THorseRequest; AResponse: THorseResponse);
  class procedure ObterClientesPorId(ARequest: THorseRequest; AResponse: THorseResponse);
  public
    class procedure Registry;

end;

implementation

{ TControllerClientes }

class procedure TControllerClientes.AlteraClientes(ARequest: THorseRequest;
  AResponse: THorseResponse);
var
  LServiceClientes: TServiceClientes;
begin
  LServiceClientes := TServiceClientes.Create;
  try
    LServiceClientes.EditarCliente(StrToInt(ARequest.Params['id_pss']),ARequest.Body<TJSONObject>);
    AResponse.Send('Alterado com sucesso').Status(200)
  finally
    FreeAndNil(LServiceClientes);
  end;

end;

class procedure TControllerClientes.CriarClientes(ARequest: THorseRequest;
  AResponse: THorseResponse);
var
  LServiceClientes: TServiceClientes;
begin
  LServiceClientes := TServiceClientes.Create;
  try
    LServiceClientes.CadastrarCliente(ARequest.Body<TJSONObject>);
    AResponse.Send(LServiceClientes.JSONObject).Status(201);
  finally
    FreeAndNil(LServiceClientes);
  end;

end;

class procedure TControllerClientes.ObtemClientes(ARequest: THorseRequest;
  AResponse: THorseResponse);
var
  LServiceClientes: TServiceClientes;
begin
  LServiceClientes := TServiceClientes.Create;
  try
    LServiceClientes.ListarCliente(ARequest.Query.Dictionary);
    AResponse.Send(LServiceClientes.JSONArray);
  finally
    FreeAndNil(LServiceClientes);
  end;

end;

class procedure TControllerClientes.ObterClientesPorId(ARequest: THorseRequest;
  AResponse: THorseResponse);
var
  LServiceClientes: TServiceClientes;
begin
  LServiceClientes := TServiceClientes.Create;
  try
    LServiceClientes.LocalizarClientePorId(StrToInt(ARequest.Params['id_pss']));
    AResponse.Send(LServiceClientes.JSONObject).Status(200);
  finally
    FreeAndNil(LServiceClientes);
  end;

end;

class procedure TControllerClientes.Registry;
begin
  THorse.Get('/cliente', ObtemClientes);
  THorse.Get('/cliente/:id_pss', ObterClientesPorId);
  THorse.Post('/cliente', CriarClientes);
  THorse.Put('/cliente/:id_pss', AlteraClientes);
end;

end.
