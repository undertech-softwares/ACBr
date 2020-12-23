{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
{                              Jean Carlo Cantu                                }
{                              Tiago Ravache                                   }
{                              Guilherme Costa                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 28/08/2017: Leivio Fontenele - leivio@yahoo.com.br
|*  - Implementa��o comunica��o, envelope, status e retorno do componente com webservice.
******************************************************************************}

{$I ACBr.inc}

unit pcesS5002;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  ACBrBase,
  pcnConversao, pcnLeitor, ACBrUtil,
  pcesCommon, pcesConversaoeSocial;

type
  TInfoIrrfCollectionItem = class;
  TbasesIrrfCollection = class;
  TbasesIrrfCollectionItem = class;
  TirrfCollection = class;
  TirrfCollectionItem = class;
  TidePgtoExt = class;
  TEvtIrrfBenef = class;

  TS5002 = class(TInterfacedObject, IEventoeSocial)
  private
    FTipoEvento: TTipoEvento;
    FEvtirrfBenef: TEvtirrfBenef;

    function GetXml : string;
    procedure SetXml(const Value: string);
    function GetTipoEvento : TTipoEvento;
  public
    constructor Create;
    destructor Destroy; override;

    function GetEvento : TObject;
    property Xml: String read GetXml write SetXml;
    property TipoEvento: TTipoEvento read GetTipoEvento;
    property EvtirrfBenef: TEvtirrfBenef read FEvtirrfBenef write FEvtirrfBenef;
  end;

  TInfoDep = class(TObject)
  private
    FvrDedDep: Double;
  public
    property vrDedDep: Double read FvrDedDep;
  end;

  TInfoIrrfCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfoIrrfCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfoIrrfCollectionItem);
  public
    function Add: TInfoIrrfCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfoIrrfCollectionItem;
    property Items[Index: Integer]: TInfoIrrfCollectionItem read GetItem write SetItem;
  end;

  TInfoIrrfCollectionItem = class(TObject)
  private
    FCodCateg: integer;
    FindResBr: String;
    FbasesIrrf: TbasesIrrfCollection;
    Firrf: TirrfCollection;
    FidePgtoExt: TidePgtoExt;

    procedure SetbasesIrrf(const Value: TbasesIrrfCollection);
    procedure Setirrf(const Value: TirrfCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property CodCateg: integer read FCodCateg;
    property indResBr: String read FindResBr;
    property basesIrrf: TbasesIrrfCollection read FbasesIrrf write SetbasesIrrf;
    property irrf: TirrfCollection read Firrf write Setirrf;
    property idePgtoExt: TidePgtoExt read FidePgtoExt write FidePgtoExt;
  end;

  TbasesIrrfCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TbasesIrrfCollectionItem;
    procedure SetItem(Index: Integer; Value: TbasesIrrfCollectionItem);
  public
    function Add: TbasesIrrfCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TbasesIrrfCollectionItem;
    property Items[Index: Integer]: TbasesIrrfCollectionItem read GetItem write SetItem;
  end;

  TbasesIrrfCollectionItem = class(TObject)
  private
    Fvalor: Double;
    FtpValor: Integer;
  public
    property tpValor: Integer read FtpValor;
    property valor: Double read Fvalor;
  end;

  TirrfCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TirrfCollectionItem;
    procedure SetItem(Index: Integer; Value: TirrfCollectionItem);
  public
    function Add: TirrfCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TirrfCollectionItem;
    property Items[Index: Integer]: TirrfCollectionItem read GetItem write SetItem;
  end;

  TirrfCollectionItem = class(TObject)
  private
    FtpCR: string;
    FvrIrrfDesc: Double;
  public
    property tpCR: string read FtpCR;
    property vrIrrfDesc: Double read FvrIrrfDesc;
  end;

  TidePgtoExt = class(TObject)
  private
    FidePais: TidePais;
    FendExt: TendExt;
  public
    constructor Create;
    destructor Destroy; override;
    property idePais: TidePais read FidePais write FidePais;
    property endExt: TendExt read FendExt write FendExt;
  end;

  TEvtIrrfBenef = class(TObject)
  private
    FLeitor: TLeitor;
    FId: String;
    FXML: String;

    FIdeEvento: TIdeEvento5;
    FIdeEmpregador: TIdeEmpregador;
    FIdeTrabalhador: TIdeTrabalhador3;
    FInfoDep: TInfoDep;
    FInfoIrrf: TInfoIrrfCollection;

    procedure SetInfoIrrf(const Value: TInfoIrrfCollection);
  public
    constructor Create;
    destructor  Destroy; override;

    function LerXML: boolean;
    function SalvarINI: boolean;

    property IdeEvento: TIdeEvento5 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeTrabalhador: TIdeTrabalhador3 read FIdeTrabalhador write FIdeTrabalhador;
    property InfoDep: TInfoDep read FInfoDep write FInfoDep;
    property InfoIrrf: TInfoIrrfCollection read FInfoIrrf write SetInfoIrrf;
    property Leitor: TLeitor read FLeitor write FLeitor;
    property Id: String      read FId;
    property XML: String     read FXML;
  end;

implementation

uses
  IniFiles;

{ TS5002 }

constructor TS5002.Create;
begin
  inherited Create;
  FTipoEvento   := teS5002;
  FEvtIrrfBenef := TEvtIrrfBenef.Create;
end;

destructor TS5002.Destroy;
begin
  FEvtIrrfBenef.Free;

  inherited;
end;

function TS5002.GetEvento : TObject;
begin
  Result := self;
end;

function TS5002.GetXml : string;
begin
  Result := FEvtIrrfBenef.XML;
end;

procedure TS5002.SetXml(const Value: string);
begin
  if Value = FEvtIrrfBenef.XML then Exit;

  FEvtIrrfBenef.FXML := Value;
  FEvtIrrfBenef.Leitor.Arquivo := Value;
  FEvtIrrfBenef.LerXML;

end;

function TS5002.GetTipoEvento : TTipoEvento;
begin
  Result := FTipoEvento;
end;

{ TInfoIrrfCollection }

function TInfoIrrfCollection.Add: TInfoIrrfCollectionItem;
begin
  Result := Self.New;
end;

function TInfoIrrfCollection.GetItem(
  Index: Integer): TInfoIrrfCollectionItem;
begin
  Result := TInfoIrrfCollectionItem(inherited Items[Index]);
end;

procedure TInfoIrrfCollection.SetItem(Index: Integer;
  Value: TInfoIrrfCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfoIrrfCollection.New: TInfoIrrfCollectionItem;
begin
  Result := TInfoIrrfCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfoIrrfCollectionItem }

constructor TInfoIrrfCollectionItem.Create;
begin
  inherited Create;
  FbasesIrrf  := TbasesIrrfCollection.Create;
  Firrf       := TirrfCollection.Create;
  FidePgtoExt := TidePgtoExt.Create;
end;

destructor TInfoIrrfCollectionItem.Destroy;
begin
  FbasesIrrf.Free;
  Firrf.Free;
  FidePgtoExt.Free;

  inherited;
end;

procedure TInfoIrrfCollectionItem.SetbasesIrrf(const Value: TbasesIrrfCollection);
begin
  FbasesIrrf := Value;
end;

procedure TInfoIrrfCollectionItem.Setirrf(const Value: TirrfCollection);
begin
  Firrf := Value;
end;

{ TbaseIrrfCollection }

function TbasesIrrfCollection.Add: TbasesIrrfCollectionItem;
begin
  Result := Self.New;
end;

function TbasesIrrfCollection.GetItem(
  Index: Integer): TbasesIrrfCollectionItem;
begin
  Result := TbasesIrrfCollectionItem(inherited Items[Index]);
end;

procedure TbasesIrrfCollection.SetItem(Index: Integer;
  Value: TbasesIrrfCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TirrfCollection }

function TirrfCollection.Add: TirrfCollectionItem;
begin
  Result := Self.New;
end;

function TirrfCollection.GetItem(Index: Integer): TirrfCollectionItem;
begin
  Result := TirrfCollectionItem(inherited Items[Index]);
end;

procedure TirrfCollection.SetItem(Index: Integer;
  Value: TirrfCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TirrfCollection.New: TirrfCollectionItem;
begin
  Result := TirrfCollectionItem.Create;
  Self.Add(Result);
end;

{ TidePgtoExt }

constructor TidePgtoExt.Create;
begin
  inherited Create;
  FidePais := TidePais.Create;
  FendExt  := TendExt.Create;
end;

destructor TidePgtoExt.Destroy;
begin
  FidePais.Free;
  FendExt.Free;

  inherited;
end;

{ TEvtIrrfBenef }

constructor TEvtIrrfBenef.Create;
begin
  inherited Create;
  FLeitor         := TLeitor.Create;
  FIdeEvento      := TIdeEvento5.Create;
  FIdeEmpregador  := TIdeEmpregador.Create;
  FIdeTrabalhador := TIdeTrabalhador3.Create;
  FInfoDep        := TInfoDep.Create;
  FInfoIrrf       := TInfoIrrfCollection.Create;
end;

destructor TEvtIrrfBenef.Destroy;
begin
  FLeitor.Free;
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeTrabalhador.Free;
  FInfoDep.Free;
  FInfoIrrf.Free;

  inherited;
end;

procedure TEvtIrrfBenef.SetInfoIrrf(const Value: TInfoIrrfCollection);
begin
  FInfoIrrf := Value;
end;

function TEvtIrrfBenef.LerXML: boolean;
var
  ok: Boolean;
  i, j: Integer;
begin
  Result := False;
  try
    FXML := Leitor.Arquivo;

    if leitor.rExtrai(1, 'evtIrrfBenef') <> '' then
    begin
      FId := Leitor.rAtributo('Id=');

      if leitor.rExtrai(2, 'ideEvento') <> '' then
      begin
        IdeEvento.nrRecArqBase := leitor.rCampo(tcStr, 'nrRecArqBase');
        IdeEvento.IndApuracao  := eSStrToIndApuracao(ok, leitor.rCampo(tcStr, 'IndApuracao'));
        IdeEvento.perApur      := leitor.rCampo(tcStr, 'perApur');
      end;

      if leitor.rExtrai(2, 'ideEmpregador') <> '' then
      begin
        IdeEmpregador.TpInsc := eSStrToTpInscricao(ok, leitor.rCampo(tcStr, 'tpInsc'));
        IdeEmpregador.NrInsc := leitor.rCampo(tcStr, 'nrInsc');
      end;

      if leitor.rExtrai(2, 'ideTrabalhador') <> '' then
        IdeTrabalhador.cpfTrab := leitor.rCampo(tcStr, 'cpfTrab');

      if leitor.rExtrai(2, 'infoDep') <> '' then
        infoDep.FvrDedDep := leitor.rCampo(tcDe2, 'vrDedDep');

      i := 0;
      while Leitor.rExtrai(2, 'infoIrrf', '', i + 1) <> '' do
      begin
        InfoIrrf.New;
        InfoIrrf.Items[i].FCodCateg := leitor.rCampo(tcInt, 'codCateg');
        InfoIrrf.Items[i].FindResBr := leitor.rCampo(tcStr, 'indResBr');

        j := 0;
        while Leitor.rExtrai(3, 'basesIrrf', '', j + 1) <> '' do
        begin
          InfoIrrf.Items[i].basesIrrf.New;
          InfoIrrf.Items[i].basesIrrf.Items[j].FtpValor := leitor.rCampo(tcInt, 'tpValor');
          InfoIrrf.Items[i].basesIrrf.Items[j].Fvalor   := leitor.rCampo(tcDe2, 'valor');
          inc(j);
        end;

        j := 0;
        while Leitor.rExtrai(3, 'irrf', '', j + 1) <> '' do
        begin
          InfoIrrf.Items[i].irrf.New;
          InfoIrrf.Items[i].irrf.Items[j].FtpCR       := leitor.rCampo(tcStr, 'tpCR');
          InfoIrrf.Items[i].irrf.Items[j].FvrIrrfDesc := leitor.rCampo(tcDe2, 'vrIrrfDesc');
          inc(j);
        end;
        
        if leitor.rExtrai(3, 'idePgtoExt') <> '' then
        begin
          if leitor.rExtrai(4, 'idePais') <> '' then
          begin
            InfoIrrf.Items[i].idePgtoExt.idePais.codPais  := leitor.rCampo(tcStr, 'codPais');
            InfoIrrf.Items[i].idePgtoExt.idePais.indNIF   := eSStrToIndNIF(ok, leitor.rCampo(tcStr, 'indNIF'));
            InfoIrrf.Items[i].idePgtoExt.idePais.nifBenef := leitor.rCampo(tcStr, 'nifBenef');
          end;

          if leitor.rExtrai(4, 'endExt') <> '' then
          begin
            InfoIrrf.Items[i].idePgtoExt.endExt.dscLograd := leitor.rCampo(tcStr, 'dscLograd');
            InfoIrrf.Items[i].idePgtoExt.endExt.nrLograd  := leitor.rCampo(tcStr, 'nrLograd');
            InfoIrrf.Items[i].idePgtoExt.endExt.complem   := leitor.rCampo(tcStr, 'complem');
            InfoIrrf.Items[i].idePgtoExt.endExt.bairro    := leitor.rCampo(tcStr, 'bairro');
            InfoIrrf.Items[i].idePgtoExt.endExt.nmCid     := leitor.rCampo(tcStr, 'nmCid');
            InfoIrrf.Items[i].idePgtoExt.endExt.codPostal := leitor.rCampo(tcStr, 'codPostal');
          end;
        end;

        inc(i);
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TEvtIrrfBenef.SalvarINI: boolean;
var
  AIni: TMemIniFile;
  sSecao: String;
  i, j: Integer;
begin
  Result := True;

  AIni := TMemIniFile.Create('');
  try
    with Self do
    begin
      sSecao := 'evtIrrfBenef';
      AIni.WriteString(sSecao, 'Id', Id);

      sSecao := 'ideEvento';
      AIni.WriteString(sSecao, 'nrRecArqBase', IdeEvento.nrRecArqBase);
      AIni.WriteString(sSecao, 'perApur',      IdeEvento.perApur);

      sSecao := 'ideEmpregador';
      AIni.WriteString(sSecao, 'tpInsc', eSTpInscricaoToStr(IdeEmpregador.TpInsc));
      AIni.WriteString(sSecao, 'nrInsc', IdeEmpregador.nrInsc);

      sSecao := 'ideTrabalhador';
      AIni.WriteString(sSecao, 'cpfTrab', ideTrabalhador.cpfTrab);

      sSecao := 'infoDep';
      AIni.WriteFloat(sSecao, 'vrDedDep', infoDep.vrDedDep);

      for i := 0 to infoIrrf.Count -1 do
      begin
        sSecao := 'infoIrrf' + IntToStrZero(I, 1);

        AIni.WriteInteger(sSecao, 'codCateg', infoIrrf.Items[i].CodCateg);
        AIni.WriteString(sSecao, 'indResBr',  infoIrrf.Items[i].indResBr);

        for j := 0 to InfoIrrf.Items[i].basesIrrf.Count -1 do
        begin
          sSecao := 'basesIrrf' + IntToStrZero(I, 1) + IntToStrZero(j, 2);

          AIni.WriteInteger(sSecao, 'tpValor', InfoIrrf.Items[i].basesIrrf.Items[j].tpValor);
          AIni.WriteFloat(sSecao, 'valor',     InfoIrrf.Items[i].basesIrrf.Items[j].valor);
        end;

        for j := 0 to InfoIrrf.Items[i].irrf.Count -1 do
        begin
          sSecao := 'irrf' + IntToStrZero(I, 1) + IntToStrZero(j, 2);

          AIni.WriteString(sSecao, 'tpCR',      InfoIrrf.Items[i].irrf.Items[j].tpCR);
          AIni.WriteFloat(sSecao, 'vrIrrfDesc', InfoIrrf.Items[i].irrf.Items[j].vrIrrfDesc);
        end;

        sSecao := 'idePais' + IntToStrZero(I, 1);

        AIni.WriteString(sSecao, 'codPais',  infoIrrf.Items[i].idePgtoExt.idePais.codPais);
        AIni.WriteString(sSecao, 'indNIF',   eSIndNIFToStr(infoIrrf.Items[i].idePgtoExt.idePais.indNIF));
        AIni.WriteString(sSecao, 'nifBenef', infoIrrf.Items[i].idePgtoExt.idePais.nifBenef);

        sSecao := 'endExt' + IntToStrZero(I, 1);

        AIni.WriteString(sSecao, 'dscLograd', infoIrrf.Items[i].idePgtoExt.endExt.dscLograd);
        AIni.WriteString(sSecao, 'nrLograd',  infoIrrf.Items[i].idePgtoExt.endExt.nrLograd);
        AIni.WriteString(sSecao, 'complem',   infoIrrf.Items[i].idePgtoExt.endExt.complem);
        AIni.WriteString(sSecao, 'bairro',    infoIrrf.Items[i].idePgtoExt.endExt.bairro);
        AIni.WriteString(sSecao, 'nmCid',     infoIrrf.Items[i].idePgtoExt.endExt.nmCid);
        AIni.WriteString(sSecao, 'codPostal', infoIrrf.Items[i].idePgtoExt.endExt.codPostal);
      end;
    end;
  finally
    AIni.Free;
  end;
end;

function TbasesIrrfCollection.New: TbasesIrrfCollectionItem;
begin
  Result := TbasesIrrfCollectionItem.Create;
  Self.Add(Result);
end;

end.
