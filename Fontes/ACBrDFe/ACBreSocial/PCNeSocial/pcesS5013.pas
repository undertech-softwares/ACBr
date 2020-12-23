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

unit pcesS5013;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  ACBrBase, pcnConversao, pcnLeitor, ACBrUtil,
  pcesCommon, pcesConversaoeSocial;

type
  TInfoFGTS = class;
  TInfoBaseFGTS = class;
  TInfoDpsFGTS = class;
  TEvtFGTS = class;

  TS5013 = class(TInterfacedObject, IEventoeSocial)
  private
    FTipoEvento: TTipoEvento;
    FEvtFGTS: TEvtFGTS;

    function GetXml : string;
    procedure SetXml(const Value: string);
    function GetTipoEvento : TTipoEvento;
  public
    constructor Create;
    destructor Destroy; override;

    function GetEvento : TObject;
    property Xml: String read GetXml write SetXml;
    property TipoEvento: TTipoEvento read GetTipoEvento;
    property EvtFGTS: TEvtFGTS read FEvtFGTS write FEvtFGTS;
  end;

  TDpsPerApurCollectionItem = class(TObject)
  private
    FtpDps: Integer;
    FvrFGTS: Currency;
  public
    property tpDps: Integer read FtpDps write FtpDps;
    property vrFGTS: Currency read FvrFGTS write FvrFGTS;
  end;

  TDpsPerApurCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TDpsPerApurCollectionItem;
    procedure SetItem(Index: Integer; Value: TDpsPerApurCollectionItem);
  public
    function Add: TDpsPerApurCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TDpsPerApurCollectionItem;
    property Items[Index: Integer]: TDpsPerApurCollectionItem read GetItem write SetItem;
  end;

  TInfoDpsFGTS = class(TObject)
  private
    FDpsPerApur: TDpsPerApurCollection;

    procedure SetDpsPerApur(const Value: TDpsPerApurCollection);
  public
    constructor Create;
    destructor Destroy; override;
    property dpsPerApur: TDpsPerApurCollection read FDpsPerApur write SetDpsPerApur;
  end;

  TBasePerApurCollectionItem = class(TObject)
  private
    FtpValor: Integer;
    FbaseFGTS: Currency;
  public
    property tpValor: Integer read FtpValor write FtpValor;
    property baseFGTS: Currency read FbaseFGTS write FbaseFGTS;
  end;

  TBasePerApurCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TBasePerApurCollectionItem;
    procedure SetItem(Index: Integer; Value: TBasePerApurCollectionItem);
  public
    function Add: TBasePerApurCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TBasePerApurCollectionItem;
    property Items[Index: Integer]: TBasePerApurCollectionItem read GetItem write SetItem;
  end;

  TInfoBaseFGTS = class(TObject)
  private
    FBasePerApur: TBasePerApurCollection;
//    FInfoDpsFGTS: TDpsPerApurCollection;

    procedure SetBasePerApur(const Value: TBasePerApurCollection);
  public
    constructor Create;
    destructor Destroy; override;
    property basePerApur: TBasePerApurCollection read FBasePerApur write SetBasePerApur;
  end;

  TInfoFGTS = class(TObject)
  private
    FnrRecArqBase: String;
    FindExistInfo: Integer;
    FInfoBaseFGTS: TInfoBaseFGTS;
    FInfoDpsFGTS: TInfoDpsFGTS;

    procedure SetInfoBaseFGTS(const Value: TInfoBaseFGTS);
    procedure SetInfoDpsFGTS(const Value: TInfoDpsFGTS);
  public
    constructor Create;
    destructor Destroy; override;

    property nrRecArqBase: String read FnrRecArqBase;
    property indExistInfo: Integer read FindExistInfo;
    property infoBaseFGTS: TInfoBaseFGTS read FInfoBaseFGTS write SetInfoBaseFGTS;
    property infoDpsFGTS: TInfoDpsFGTS read FInfoDpsFGTS write SetInfoDpsFGTS;
  end;

  TEvtFGTS = class(TObject)
  private
    FLeitor: TLeitor;
    FId: String;
    FXML: String;

    FIdeEvento: TIdeEvento5;
    FIdeEmpregador: TIdeEmpregador;
    FInfoIRRF: TInfoFGTS;
  public
    constructor Create;
    destructor  Destroy; override;

    function LerXML: Boolean;
    function SalvarINI: boolean;

    property IdeEvento: TIdeEvento5 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property InfoFGTS: TInfoFGTS read FInfoIRRF write FInfoIRRF;
    property Leitor: TLeitor read FLeitor write FLeitor;
    property Id: String      read FId;
    property XML: String     read FXML;
  end;

implementation

uses
  IniFiles;

{ TS5013 }

constructor TS5013.Create;
begin
  FTipoEvento := teS5013;
  FEvtFGTS := TEvtFGTS.Create;
end;

destructor TS5013.Destroy;
begin
  FEvtFGTS.Free;

  inherited;
end;

function TS5013.GetEvento : TObject;
begin
  Result := self;
end;

function TS5013.GetXml : string;
begin
  Result := FEvtFGTS.XML;
end;

procedure TS5013.SetXml(const Value: string);
begin
  if Value = FEvtFGTS.XML then Exit;

  FEvtFGTS.FXML := Value;
  FEvtFGTS.Leitor.Arquivo := Value;
  FEvtFGTS.LerXML;

end;

function TS5013.GetTipoEvento : TTipoEvento;
begin
  Result := FTipoEvento;
end;

{ TEvtFGTS }

constructor TEvtFGTS.Create;
begin
  inherited Create;
  FLeitor        := TLeitor.Create;
  FIdeEvento     := TIdeEvento5.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FInfoIRRF      := TInfoFGTS.Create;
end;

destructor TEvtFGTS.Destroy;
begin
  FLeitor.Free;
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FInfoIRRF.Free;

  inherited;
end;

{ TInfoFGTS }

constructor TInfoFGTS.Create;
begin
  inherited Create;
  FInfoBaseFGTS := TInfoBaseFGTS.Create;
  FInfoDpsFGTS  := TInfoDpsFGTS.Create;
end;

destructor TInfoFGTS.Destroy;
begin
  FInfoBaseFGTS.Free;
  FInfoDpsFGTS.Free;

  inherited;
end;

procedure TInfoFGTS.SetInfoBaseFGTS(const Value: TInfoBaseFGTS);
begin
  FInfoBaseFGTS := Value;
end;

procedure TInfoFGTS.SetInfoDpsFGTS(const Value: TInfoDpsFGTS);
begin
  FInfoDpsFGTS := Value;
end;

function TEvtFGTS.LerXML: Boolean;
var
  ok: Boolean;
  i: Integer;
begin
  Result := False;
  try
    FXML := Leitor.Arquivo;

    if leitor.rExtrai(1, 'evtFGTS') <> '' then
    begin
      FId := Leitor.rAtributo('Id=');

      if leitor.rExtrai(2, 'ideEvento') <> '' then
        IdeEvento.perApur := leitor.rCampo(tcStr, 'perApur');

      if leitor.rExtrai(2, 'ideEmpregador') <> '' then
      begin
        IdeEmpregador.TpInsc := eSStrToTpInscricao(ok, leitor.rCampo(tcStr, 'tpInsc'));
        IdeEmpregador.NrInsc := leitor.rCampo(tcStr, 'nrInsc');
      end;

      if leitor.rExtrai(2, 'infoFGTS') <> '' then
      begin
        InfoFGTS.FnrRecArqBase := leitor.rCampo(tcStr, 'nrRecArqBase');
        InfoFGTS.FindExistInfo := leitor.rCampo(tcInt, 'indExistInfo');

        if leitor.rExtrai(3, 'infoBaseFGTS') <> '' then
        begin
           i := 0;
           while Leitor.rExtrai(4, 'basePerApur', '', i + 1) <> '' do
           begin
             InfoFGTS.infoBaseFGTS.basePerApur.New;
             InfoFGTS.infoBaseFGTS.basePerApur.Items[i].tpValor  := leitor.rCampo(tcInt, 'tpValor');
             InfoFGTS.infoBaseFGTS.basePerApur.Items[i].baseFGTS := leitor.rCampo(tcDe2, 'baseFGTS');
             inc(i);
           end;
        end;

        if leitor.rExtrai(3, 'infoDpsFGTS') <> '' then
        begin
           i := 0;
           while Leitor.rExtrai(4, 'dpsPerApur', '', i + 1) <> '' do
           begin
             InfoFGTS.infoDpsFGTS.dpsPerApur.New;
             InfoFGTS.infoDpsFGTS.dpsPerApur.Items[i].tpDps  := leitor.rCampo(tcInt, 'tpDps');
             InfoFGTS.infoDpsFGTS.dpsPerApur.Items[i].vrFGTS := leitor.rCampo(tcDe2, 'vrFGTS');
             inc(i);
           end;
        end;
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TEvtFGTS.SalvarINI: boolean;
//var
//  AIni: TMemIniFile;
//  sSecao: String;
//  i: Integer;
begin
  Result := True;

//  AIni := TMemIniFile.Create('');
//  try
//    Result := True;
//
//  finally
//    AIni.Free;
//  end;
end;

{ TInfoBaseFGTS }

constructor TInfoBaseFGTS.Create;
begin
  inherited Create;
  FBasePerApur := TBasePerApurCollection.Create;
end;

destructor TInfoBaseFGTS.Destroy;
begin
  FBasePerApur.Free;
  inherited;
end;

procedure TInfoBaseFGTS.SetBasePerApur(const Value: TBasePerApurCollection);
begin
  FBasePerApur := Value;
end;

{ TBasePerApurCollection }

function TBasePerApurCollection.Add: TBasePerApurCollectionItem;
begin
  Result := Self.New;
end;

function TBasePerApurCollection.GetItem(Index: Integer): TBasePerApurCollectionItem;
begin
  Result := TBasePerApurCollectionItem(inherited Items[Index]);
end;

procedure TBasePerApurCollection.SetItem(Index: Integer; Value: TBasePerApurCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TInfoDpsFGTSCollection }

function TDpsPerApurCollection.Add: TDpsPerApurCollectionItem;
begin
  Result := Self.New;
end;

function TDpsPerApurCollection.GetItem(Index: Integer): TDpsPerApurCollectionItem;
begin
  Result := TDpsPerApurCollectionItem(inherited Items[Index]);
end;

procedure TDpsPerApurCollection.SetItem(Index: Integer; Value: TDpsPerApurCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TBasePerApurCollection.New: TBasePerApurCollectionItem;
begin
  Result := TBasePerApurCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfoDpsFGTS }

constructor TInfoDpsFGTS.Create;
begin
  inherited Create;
  FDpsPerApur := TDpsPerApurCollection.Create;
end;

destructor TInfoDpsFGTS.Destroy;
begin
  FDpsPerApur.Free;
  inherited;
end;

procedure TInfoDpsFGTS.SetDpsPerApur(const Value: TDpsPerApurCollection);
begin
  FDpsPerApur := Value;
end;

function TDpsPerApurCollection.New: TDpsPerApurCollectionItem;
begin
  Result := TDpsPerApurCollectionItem.Create;
  Self.Add(Result);
end;

end.
