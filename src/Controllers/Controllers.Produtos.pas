unit Controllers.Produtos;

interface

uses
  System.Generics.Collections,
  System.JSON,
  Horse,
  Service.Produtos,
  System.SysUtils;

type
  TControllerProdutos = class

  class procedure ObtemProdutos(ARequest: THorseRequest; AResponse: THorseResponse);
  class procedure ObterProdutoPorId(ARequest: THorseRequest; AResponse: THorseResponse);
  class procedure CadastrarProduto(ARequest: THorseRequest; AResponse: THorseResponse);
  class procedure AlterarProduto(ARequest: THorseRequest; AResponse: THorseResponse);
  class procedure ObterImagemProdutoPorId(ARequest: THorseRequest; AResponse: THorseResponse);
  class procedure PesquisaProdutos(ARequest: THorseRequest; AResponse: THorseResponse);
  
  public
    class procedure Registry;

end;

implementation

{ TControllerProdutos }                

class procedure TControllerProdutos.AlterarProduto(ARequest: THorseRequest;
  AResponse: THorseResponse);
var
 LServiceProdutos: TServiceProdutos;
begin
  LServiceProdutos := TServiceProdutos.Create;
  try
    LServiceProdutos.EditarProduto(StrToInt(ARequest.Params['id-prd']),ARequest.Body<TJSONObject>);
    AResponse.Send('Alterado com sucesso').Status(200);
  finally
    FreeAndNil(LServiceProdutos);
  end;
end;

class procedure TControllerProdutos.CadastrarProduto(ARequest: THorseRequest;
  AResponse: THorseResponse);
var
 LServiceProdutos: TServiceProdutos;
begin
  LServiceProdutos := TServiceProdutos.Create;
  try
    LServiceProdutos.CadastroProduto(ARequest.Body<TJSONObject>);
    AResponse.Send(LServiceProdutos.JSONObject).Status(201);
  finally
    FreeAndNil(LServiceProdutos);
  end;
end;

class procedure TControllerProdutos.ObtemProdutos(ARequest: THorseRequest;
  AResponse: THorseResponse);
var
 LServiceProdutos: TServiceProdutos;
begin
  LServiceProdutos := TServiceProdutos.Create;
  try
    LServiceProdutos.ListarProdutos(ARequest.Query.Dictionary);
    AResponse.Send(LServiceProdutos.JSONArray);
  finally
    FreeAndNil(LServiceProdutos);
  end;
end;

class procedure TControllerProdutos.ObterImagemProdutoPorId(
  ARequest: THorseRequest; AResponse: THorseResponse);
var
 LServiceProdutos: TServiceProdutos;
begin
  LServiceProdutos := TServiceProdutos.Create;
   try
      LServiceProdutos.ListarImagens(StrToInt(ARequest.Params['id-prd']));
      AResponse.Send(LServiceProdutos.JSONObject).Status(200);
    finally
      FreeAndNil(LServiceProdutos);
    end;

end;

class procedure TControllerProdutos.ObterProdutoPorId(ARequest: THorseRequest;
  AResponse: THorseResponse);
var
 LServiceProdutos: TServiceProdutos;
begin
  LServiceProdutos := TServiceProdutos.Create;
   try
      LServiceProdutos.LocalizarProdutoPorId(StrToInt(ARequest.Params['id-prd']));
      AResponse.Send(LServiceProdutos.JSONObject).Status(200);
    finally
      FreeAndNil(LServiceProdutos);
    end;
end;

class procedure TControllerProdutos.PesquisaProdutos(ARequest: THorseRequest;
  AResponse: THorseResponse);
var
 LServiceProdutos: TServiceProdutos;
begin
  LServiceProdutos := TServiceProdutos.Create;
  try
    LServiceProdutos.PesquisarProduto(ARequest.Query.Dictionary);
    AResponse.Send(LServiceProdutos.JSONArray);
  finally
    FreeAndNil(LServiceProdutos);
  end;

end;

class procedure TControllerProdutos.Registry;
begin
  THorse.Get('/produtos', ObtemProdutos);
  THorse.Get('/produtos/:id-prd', ObterProdutoPorId);
  THorse.Post('/produtos', CadastrarProduto);
  THorse.Put('/produto/:id-prd', AlterarProduto);
  THorse.Get('/imgProdutos', PesquisaProdutos);
  THorse.Get('/imgProdutos/:id-prd', ObterImagemProdutoPorId);
end;

end.
