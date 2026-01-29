unit Service.Base;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Phys,
  FireDAC.Stan.Option,
  FireDAC.DApt,
  FireDAC.Stan.Async,
  FireDAC.Comp.Client,
  FireDAC.Phys.FBDef,
  FireDAC.Phys.PGDef,
  FireDAC.Stan.Pool,
  FireDAC.Phys.FB,
  FireDAC.Phys.PG,
  Data.DB,
  FireDAC.Stan.Intf,
  Horse;

type
  TServiceBase = class
  protected
    FConnection:  TFDConnection;
    FDriverLink: TFDPhysFBDriverLink;
    FJSONArray: TJSONArray;
    FJSONObject: TJSONObject;
  public
    property Connection: TFDConnection read FConnection;
    property JSONArray: TJSONArray read FJSONArray write FJSONArray;
    property JSONObject: TJSONObject read FJSONObject write FJSONObject;
    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TServiceBase }

constructor TServiceBase.Create;
var
  LLocalizacoes: array[0..2] of string;
  LPortas: array[0..2] of string;
  I: Integer;
  LConectado: Boolean;
begin


  LLocalizacoes[0] := 'C:\Users\Usuario\Desktop\Mult_Estudos\BD\files.fdb';
  LLocalizacoes[1] := 'C:\Users\Usuario\Desktop\multestudos\BD\FILES.FDB';
  LLocalizacoes[2] := 'C:\MultSistem\MultVendas\DataBases\FILES.FDB';

  LPortas[0] := '3050';
  LPortas[1] := '3050';
  LPortas[2] := '13070';

  LConectado := False;

  try
    FDriverLink := TFDPhysFBDriverLink.Create(nil);
    FDriverLink.VendorLib := 'C:\MultSistem\MultVendas\Bin\fbclient.dll';

    FConnection := TFDConnection.Create(nil);
    FConnection.DriverName := 'FB';
    FConnection.Params.AddPair('Server', 'LOCALHOST');
    FConnection.Params.UserName := 'SYSDBA';
    FConnection.Params.Password := 'masterkey';

    for I := 0 to 2 do
    begin
      if FileExists(LLocalizacoes[I]) then
      begin
        try
          FConnection.Params.Values['Port'] := LPortas[I];
          FConnection.Params.Database := LLocalizacoes[I];
          FConnection.Connected := True;

          if FConnection.Connected then
          begin
            LConectado := True;
            Break;
          end;
        except
          Continue;
        end;
      end;
    end;

    if not LConectado then
      raise EHorseException.New.Error('Banco de dados não encontrado em nenhuma localização!').Code(100);

  except
    on E: EHorseException do
      raise;
    on E: Exception do
      raise EHorseException.New.Error('Ocorreu um erro no servidor: ' + E.Message).Code(100);
  end;
end;

destructor TServiceBase.Destroy;
begin
  FreeAndNil(FConnection);
  inherited;
end;

end.
