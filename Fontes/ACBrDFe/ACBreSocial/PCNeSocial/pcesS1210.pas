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

unit pcesS1210;

interface

uses
  SysUtils, Classes, Controls,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  ACBrBase,
  pcnConversao, pcnGerador, ACBrUtil, pcnConsts,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type

  TPgtoExt = class;
  TIdeBenef = class;
  TInfoPgtoCollection = class;
  TInfoPgtoItem = class;
  TdetPgtoFlCollection = class;
  TdetPgtoFlItem = class;
  TEvtPgtos = class;
  TS1210CollectionItem = class;
  TDeps = class;
  TDetPgtoBenPr = class;
  TDetPgtoFerCollection = class;
  TDetPgtoFerItem = class;
  TRubricasComPensaoCollection = class;
  TRubricasComPensaoItem = class;
  TDetPgtoAntCollection = class;
  TDetPgtoAntItem = class;
  TInfoPgtoAntCollection = class;
  TInfoPgtoAntItem = class;

  TS1210Collection = class(TeSocialCollection)
  private
    function GetItem(Index: Integer): TS1210CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1210CollectionItem);
  public
    function Add: TS1210CollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TS1210CollectionItem;
    property Items[Index: Integer]: TS1210CollectionItem read GetItem write SetItem; default;
  end;

  TS1210CollectionItem = class(TObject)
  private
    FTipoEvento: TTipoEvento;
    FEvtPgtos: TEvtPgtos;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    property TipoEvento: TTipoEvento read FTipoEvento;
    property evtPgtos: TEvtPgtos read FEvtPgtos write FEvtPgtos;
  end;

  TEvtPgtos = class(TeSocialEvento)
  private
    FIdeEvento : TIdeEvento3;
    FIdeEmpregador : TIdeEmpregador;
    FIdeBenef : TIdeBenef;

    {Geradores da classe}
    procedure GerarIdeBenef(objIdeBenef: TIdeBenef);
    procedure GerarInfoPgto(objInfoPgto: TInfoPgtoCollection);
    procedure GerardetPgtoFl(objdetPgtofl: TdetPgtoFlCollection);
    procedure GerarRubricasComPensao(pRubricasComPensao: TRubricasComPensaoCollection; const GroupName: String = 'retPgtoTot');
    procedure GerarDetPgtoBenPr(pDetPgtoBenPr: TDetPgtoBenPr);
    procedure GerarDetPgtoFer(pDetPgtoFer: TDetPgtoFerCollection);
    procedure GeraridePgtoExt(objPgtoExt: TPgtoExt);
    procedure GerarDeps(pDeps: TDeps);
    procedure GerarCamposRubricas(pRubrica: TRubricaCollectionItem);
    procedure GerarDetPgtoAnt(pDetPgtoAnt: TDetPgtoAntCollection);
    procedure GerarInfoPgtoAnt(pInfoPgtoAnt: TInfoPgtoAntCollection);
  public
    constructor Create(AACBreSocial: TObject); override;
    destructor Destroy; override;

    function GerarXML: Boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property IdeEvento : TIdeEvento3 read FIdeEvento write FIdeEvento;
    property IdeEmpregador : TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeBenef : TIdeBenef read FIdeBenef write FIdeBenef;
  end;

  TIdeBenef = class(TObject)
  private
    FCpfBenef : String;
    FDeps: TDeps;
    FInfoPgto : TInfoPgtoCollection;

    function getDeps: TDeps;
    function getInfoPgto : TInfoPgtoCollection;
  public
    constructor Create;
    destructor  Destroy; override;

    function depsInst: boolean;

    property CpfBenef : String read FCpfBenef write FCpfBenef;
    property deps: TDeps read getDeps write FDeps;
    property InfoPgto : TInfoPgtoCollection read getInfoPgto write FInfoPgto;
  end;

  TDeps = class(TObject)
  private
    FVrDedDep: Double;
  public
    property vrDedDep: Double read FVrDedDep write FVrDedDep;
  end;

  TInfoPgtoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfoPgtoItem;
    procedure SetItem(Index: Integer; const Value: TInfoPgtoItem);
  public
    function Add: TInfoPgtoItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfoPgtoItem;
    property Items[Index: Integer]: TInfoPgtoItem read GetItem write SetItem;
  end;

  TInfoPgtoItem = class(TObject)
  private
    FDtPgto      : TDate;
    FTpPgto      : tpTpPgto;
    FIndResBr    : tpSimNao;
    FdetPgtoFl   : TdetPgtoFlCollection;
    FdetPgtoBenPr: TdetPgtoBenPr;
    FDetPgtoFer  : TDetPgtoFerCollection;
    FDetPgtoAnt  : TDetPgtoAntCollection;
    FIdePgtoExt  : TPgtoExt;

    function GetdetPgtoFl : TdetPgtoFlCollection;
    function GetIdePgtoExt : TPgtoExt;
    function getDetPgtoBenPr: TdetPgtoBenPr;
    function getDetPgtoFer: TDetPgtoFerCollection;
    function getDetPgtoAnt: TDetPgtoAntCollection;
  public
    constructor Create;
    destructor  Destroy; override;

    function detPgtoFlInst(): Boolean;
    function detidePgtoExtInst(): Boolean;
    function detPgtoBenPrInst(): Boolean;
    function detPgtoFerInst(): Boolean;
    function detPgtoAntInst(): Boolean;

    property DtPgto : TDate read FDtPgto write FDtPgto;
    property IndResBr : TpSimNao read FIndResBr write FIndResBr;
    property TpPgto : tpTpPgto read FTpPgto write FTpPgto;
    property detPgtoFl: TdetPgtoFlCollection read GetdetPgtoFl write FdetPgtoFl;
    property detPgtoBenPr: TdetPgtoBenPr read getDetPgtoBenPr write FdetPgtoBenPr;
    property detPgtoFer: TDetPgtoFerCollection read getDetPgtoFer write FDetPgtoFer;
    property detPgtoAnt: TDetPgtoAntCollection read getDetPgtoAnt write FDetPgtoAnt;
    property IdePgtoExt : TPgtoExt read GetIdePgtoExt write FIdePgtoExt;
  end;

  TDetPgtoBenPr = class(TObject)
  private
    FPerRef: String;
    FIdeDmDev: string;
    FIndPgtoTt: tpSimNao;
    FVrLiq: Double;
    FRetPgtoTot: TRubricaCollection;
    FInfoPgtoParc: TRubricaCollection;

    function getRetPgtoTot: TRubricaCollection;
    function getInfoPgtoParc: TRubricaCollection;
  public
    constructor Create;
    destructor Destroy; override;

    function retPgtoTotInst: boolean;
    function infoPgtoParcInst: boolean;

    property perRef: string read FPerRef write FPerRef;
    property ideDmDev: string read FIdeDmDev write FIdeDmDev;
    property indPgtoTt: tpSimNao read FIndPgtoTt write FIndPgtoTt;
    property vrLiq: Double read FVrLiq write FVrLiq;
    property retPgtoTot: TRubricaCollection read getRetPgtoTot write FRetPgtoTot;
    property infoPgtoParc: TRubricaCollection read getInfoPgtoParc write FInfoPgtoParc;
  end;

  TRubricasComPensaoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRubricasComPensaoItem;
    procedure SetItem(Index: Integer; const Value: TRubricasComPensaoItem);
  public
    function Add: TRubricasComPensaoItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRubricasComPensaoItem;
    property Items[Index: integer]: TRubricasComPensaoItem read GetItem write SetItem;
      default;
  end;

  TRubricasComPensaoItem = class(TRubricaCollectionItem)
  private
    FPenAlim: TPensaoAlimCollection;

    function getpenAlim: TPensaoAlimCollection;
  public
    constructor Create;
    destructor  Destroy; override;

    function pensaoAlimInst: boolean;
    property penAlim: TPensaoAlimCollection read getpenAlim write FPenAlim;
  end;

  TdetPgtoFlCollection = class(TACBrObjectList)
  private
    function GetITem(Index: Integer): TdetPgtoFlItem;
    procedure SetItem(Index: Integer; const Value: TdetPgtoFlItem);
  public
    function Add: TdetPgtoFlItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TdetPgtoFlItem;
    property Items[Index: Integer]: TdetPgtoFlItem read GetItem write SetItem;
  end;

  TdetPgtoFlItem = class(TObject)
  private
    FperRef : String;
    FIdeDmDev: string;
    FIndPagtoTt: tpSimNao;
    FVrLiq: Double;
    FNrRecArq: string;
    FRetPagtoTot: TRubricasComPensaoCollection;
    FInfoPgtoParc: TRubricaCollection;

    function getRetPagtoTot: TRubricasComPensaoCollection;
    function getInfoPgtoParc: TRubricaCollection;
  public
    constructor Create;
    destructor  Destroy; override;

    function retPagtoToInst: boolean;
    function infoPgtoFlInst: boolean;

    property perRef : String read FperRef write FperRef;
    property ideDmDev: string read FIdeDmDev write FIdeDmDev;
    property indPagtoTt: tpSimNao read FIndPagtoTt write FIndPagtoTt;
    property vrLiq: Double read FVrLiq write FVrLiq;
    property nrRecArq: string read FNrRecArq write FNrRecArq;
    property retPagtoTot: TRubricasComPensaoCollection read getRetPagtoTot write FRetPagtoTot;
    property infoPgtoParc: TRubricaCollection read getInfoPgtoParc write FInfoPgtoParc;
  end;

  TPgtoExt = class(TObject)
  private
    FidePais : TIdePais;
    FEndExt : TEndExt;
  public
    constructor Create;
    destructor  Destroy; override;

    property idePais: TIdePais read FIdePais write FIdePais;
    property endExt: TEndExt read FEndExt write FEndExt;
  end;

  TDetPgtoFerCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TDetPgtoFerItem;
    procedure SetItem(Index: Integer; const Value: TDetPgtoFerItem);
  public
    function Add: TDetPgtoFerItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TDetPgtoFerItem;
    property Items[Index: Integer]: TDetPgtoFerItem read GetItem write SetITem;
      default;
  end;

  TDetPgtoFerItem = class(TObject)
  private
    FCodCateg: integer;
    FDtIniGoz: TDate;
    FQtDias: Integer;
    FVrLiq: Double;
    FDetRubrFer: TRubricasComPensaoCollection;
    Fmatricula: String;
  public
    constructor Create;
    destructor Destroy; override;

    property codCateg: integer read FCodCateg write FCodCateg;
    property matricula: String read Fmatricula write Fmatricula;
    property dtIniGoz: TDate read FDtIniGoz write FDtIniGoz;
    property qtDias: integer read FQtDias write FQtDias;
    property vrLiq: Double read FVrLiq write FVrLiq;
    property detRubrFer: TRubricasComPensaoCollection read FDetRubrFer write FDetRubrFer;
  end;

  TDetPgtoAntCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TDetPgtoAntItem;
    procedure SetItem(Index: Integer; const Value: TDetPgtoAntItem);
  public
    function Add: TDetPgtoAntItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TDetPgtoAntItem;
    property Items[Index: Integer]: TDetPgtoAntItem read GetItem write SetITem;
      default;
  end;

  TDetPgtoAntItem = class(TObject)
  private
    FCodCateg: Integer;
    FInfoPgtoAnt: TInfoPgtoAntCollection;
  public
    constructor Create;
    destructor Destroy; override;

    property codCateg: Integer read FCodCateg write FCodCateg;
    property infoPgtoAnt: TInfoPgtoAntCollection read FInfoPgtoAnt write FInfoPgtoAnt;
  end;

  TInfoPgtoAntCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfoPgtoAntItem;
    procedure SetItem(Index: Integer; const Value: TInfoPgtoAntItem);
  public
    function Add: TInfoPgtoAntItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfoPgtoAntItem;
    property Items[Index: Integer]: TInfoPgtoAntItem read GetItem write SetITem;
      default;
  end;

  TInfoPgtoAntItem = class(TObject)
  private
    FTpBcIRRF: tpCodIncIRRF;
    FVrBcIRRF: Double;
  public
    property tpBcIRRF: tpCodIncIRRF read FTpBcIRRF write FTpBcIRRF;
    property vrBcIRRF: Double read FVrBcIRRF write FVrBcIRRF;
  end;

implementation

uses
  IniFiles,
  ACBreSocial;

{ TS1210Collection }

function TS1210Collection.Add: TS1210CollectionItem;
begin
  Result := Self.New;
end;

function TS1210Collection.GetItem(Index: Integer): TS1210CollectionItem;
begin
  Result := TS1210CollectionItem(inherited Items[Index]);
end;

procedure TS1210Collection.SetItem(Index: Integer; Value: TS1210CollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TS1210Collection.New: TS1210CollectionItem;
begin
  Result := TS1210CollectionItem.Create(FACBreSocial);
  Self.Add(Result);
end;

{ TS1210CollectionItem }

constructor TS1210CollectionItem.Create(AOwner: TComponent);
begin
  inherited Create;
  FTipoEvento := teS1210;
  FEvtPgtos   := TEvtPgtos.Create(AOwner);
end;

destructor TS1210CollectionItem.Destroy;
begin
  FEvtPgtos.Free;

  inherited;
end;

{ TIdeBenef }

constructor TIdeBenef.create;
begin
  inherited;

  FDeps := nil;
  FInfoPgto := TInfoPgtoCollection.Create;
end;

destructor TIdeBenef.destroy;
begin
  FreeAndNil(FDeps);
  FInfoPgto.Free;

  inherited;
end;

function TIdeBenef.getDeps: TDeps;
begin
  if not Assigned(FDeps) then
    FDeps := TDeps.Create;
  Result := FDeps;
end;

function TIdeBenef.depsInst: boolean;
begin
  result := Assigned(FDeps);
end;

function TIdeBenef.getInfoPgto: TInfoPgtoCollection;
begin
  if (not Assigned(FInfoPgto)) then
    FInfoPgto := TInfoPgtoCollection.Create;
  Result := FInfoPgto;
end;

{ TInfoPgtoAntCollection }

function TInfoPgtoAntCollection.Add: TInfoPgtoAntItem;
begin
  Result := Self.New;
end;

function TInfoPgtoAntCollection.GetItem(Index: Integer): TInfoPgtoAntItem;
begin
  Result := TInfoPgtoAntItem(inherited Items[Index]);
end;

procedure TInfoPgtoAntCollection.SetItem(Index: Integer; const Value: TInfoPgtoAntItem);
begin
  inherited Items[Index] := Value;
end;

function TInfoPgtoAntCollection.New: TInfoPgtoAntItem;
begin
  Result := TInfoPgtoAntItem.Create;
  Self.Add(Result);
end;

{ TInfoPgtoCollection }

function TInfoPgtoCollection.Add: TInfoPgtoItem;
begin
  Result := Self.New;
end;

function TInfoPgtoCollection.GetItem(Index: Integer): TInfoPgtoItem;
begin
  Result := TInfoPgtoItem(inherited Items[Index]);
end;

procedure TInfoPgtoCollection.SetItem(Index: Integer; const Value: TInfoPgtoItem);
begin
  inherited Items[Index] := Value;
end;

function TInfoPgtoCollection.New: TInfoPgtoItem;
begin
  Result := TInfoPgtoItem.Create;
  Self.Add(Result);
end;

{ TInfoPgtoItem }

constructor TInfoPgtoItem.Create;
begin
  inherited Create;
  FdetPgtoFl    := TdetPgtoFlCollection.Create;
  FIdePgtoExt   := TPgtoExt.Create;
  FdetPgtoBenPr := nil;
  FDetPgtoFer   := nil;
  FDetPgtoAnt   := nil;
end;

destructor TInfoPgtoItem.Destroy;
begin
  FdetPgtoFl.Free;
  FIdePgtoExt.Free;
  FreeAndNil(FdetPgtoBenPr);
  FreeAndNil(FDetPgtoFer);
  FreeAndNil(FDetPgtoAnt);

  inherited;
end;

function TInfoPgtoItem.detPgtoAntInst: boolean;
begin
  Result := Assigned(FDetPgtoAnt);
end;

function TInfoPgtoItem.detPgtoFerInst: boolean;
begin
  Result := Assigned(FDetPgtoFer);
end;

function TInfoPgtoItem.detidePgtoExtInst: Boolean;
begin
  Result := Assigned(FidePgtoExt);
end;

function TInfoPgtoItem.detPgtoFlInst: Boolean;
begin
  Result := Assigned(FdetPgtoFl);
end;

function TInfoPgtoItem.detPgtoBenPrInst: boolean;
begin
  Result := Assigned(FdetPgtoBenPr);
end;

function TInfoPgtoItem.GetDetPgtoAnt: TDetPgtoAntCollection;
begin
  if not Assigned(FDetPgtoAnt) then
    FDetPgtoAnt := TDetPgtoAntCollection.Create;
  Result := FDetPgtoAnt;
end;

function TInfoPgtoItem.GetdetPgtoFl: TdetPgtoFlCollection;
begin
  if not (Assigned(FdetPgtoFl)) then
    FdetPgtoFl := TdetPgtoFlCollection.Create;
  Result := FdetPgtoFl;
end;

function TInfoPgtoItem.getDetPgtoBenPr: TDetPgtoBenPr;
begin
  if not Assigned(FdetPgtoBenPr) then
    FdetPgtoBenPr := TDetPgtoBenPr.Create;
  Result := FdetPgtoBenPr;
end;

function TInfoPgtoItem.GetIdePgtoExt: TPgtoExt;
begin
  if not (Assigned(FIdePgtoExt)) then
    FIdePgtoExt := TPgtoExt.Create;
  Result := FIdePgtoExt;
end;

function TInfoPgtoItem.getDetPgtoFer: TDetPgtoFerCollection;
begin
  if not Assigned(FDetPgtoFer) then
    FDetPgtoFer := TDetPgtoFerCollection.Create;
  Result := FDetPgtoFer;
end;

{ TPgtoExt }

constructor TPgtoExt.Create;
begin
  inherited Create;
  FIdePais := TIdePais.Create;
  FEndExt  := TEndExt.Create;
end;

destructor TPgtoExt.destroy;
begin
  FIdePais.Free;
  FEndExt.Free;

  inherited;
end;

{ TRubricasComPensaoCollection }

function TRubricasComPensaoCollection.add: TRubricasComPensaoItem;
begin
  Result := Self.New;
end;

function TRubricasComPensaoCollection.GetItem(Index: Integer): TRubricasComPensaoItem;
begin
  Result := TRubricasComPensaoItem(inherited Items[Index]);
end;

procedure TRubricasComPensaoCollection.SetItem(Index: Integer; const Value: TRubricasComPensaoItem);
begin
  inherited Items[Index] := Value;
end;

function TRubricasComPensaoCollection.New: TRubricasComPensaoItem;
begin
  Result := TRubricasComPensaoItem.Create;
  Self.Add(Result);
end;

{ TRubricasComPensaoItem }

constructor TRubricasComPensaoItem.Create;
begin
  inherited;

  FPenAlim := nil;
end;

destructor TRubricasComPensaoItem.Destroy;
begin
  FreeAndNil(FPenAlim);

  inherited;
end;

function TRubricasComPensaoItem.pensaoAlimInst: boolean;
begin
  result := Assigned(FPenAlim);
end;

function TRubricasComPensaoItem.getpenAlim: TPensaoAlimCollection;
begin
  if not Assigned(FPenAlim) then
    FPenAlim := TPensaoAlimCollection.Create;
  Result := FPenAlim;
end;

{ TdetPgtoFlCollection }

function TdetPgtoFlCollection.Add: TdetPgtoFlItem;
begin
  Result := Self.New;
end;

function TdetPgtoFlCollection.GetItem(Index: Integer): TdetPgtoFlItem;
begin
  Result := TdetPgtoFlItem(inherited Items[Index]);
end;

procedure TdetPgtoFlCollection.SetItem(Index: Integer; const Value: TdetPgtoFlItem);
begin
  inherited Items[Index] := Value;
end;

function TdetPgtoFlCollection.New: TdetPgtoFlItem;
begin
  Result := TdetPgtoFlItem.Create;
  Self.Add(Result);
end;

{ TdetPgtoFlItem }

constructor TdetPgtoFlItem.create;
begin
  inherited Create;
  FRetPagtoTot  := nil;
  FInfoPgtoParc := nil;
end;

destructor TdetPgtoFlItem.destroy;
begin
  FreeAndNil(FRetPagtoTot);
  FreeAndNil(FInfoPgtoParc);

  inherited;
end;

function TdetPgtoFlItem.getRetPagtoTot: TRubricasComPensaoCollection;
begin
  if not Assigned(FRetPagtoTot) then
    FRetPagtoTot := TRubricasComPensaoCollection.Create;
  Result := FRetPagtoTot;
end;

function TdetPgtoFlItem.retPagtoToInst: boolean;
begin
  Result := Assigned(FRetPagtoTot);
end;

function TdetPgtoFlItem.getInfoPgtoParc: TRubricaCollection;
begin
  if not Assigned(FInfoPgtoParc) then
    FInfoPgtoParc := TRubricaCollection.Create;
  Result := FInfoPgtoParc;
end;

function TdetPgtoFlItem.infoPgtoFlInst: boolean;
begin
  Result := Assigned(FInfoPgtoParc);
end;

{ TDetPgtoAntCollection }

function TDetPgtoAntCollection.Add: TDetPgtoAntItem;
begin
  Result := Self.New;
end;

function TDetPgtoAntCollection.GetItem(Index: Integer): TDetPgtoAntItem;
begin
  result := TDetPgtoAntItem(inherited Items[Index]);
end;

procedure TDetPgtoAntCollection.SetItem(Index: Integer; const Value: TDetPgtoAntItem);
begin
  inherited Items[Index] := Value;
end;

function TDetPgtoAntCollection.New: TDetPgtoAntItem;
begin
  Result := TDetPgtoAntItem.Create;
  Self.Add(Result);
end;

{ TDetPgtoAntItem }

constructor TDetPgtoAntItem.Create;
begin
  inherited Create;
  FInfoPgtoAnt := TInfoPgtoAntCollection.Create;
end;

destructor TDetPgtoAntItem.Destroy;
begin
  FInfoPgtoAnt.Free;

  inherited;
end;

{ TDetPgtoFerCollection }

function TDetPgtoFerCollection.Add: TDetPgtoFerItem;
begin
  Result := Self.New;
end;

function TDetPgtoFerCollection.GetItem(Index: Integer): TDetPgtoFerItem;
begin
  result := TDetPgtoFerItem(inherited Items[Index]);
end;

procedure TDetPgtoFerCollection.SetITem(Index: Integer; const Value: TDetPgtoFerItem);
begin
  inherited Items[Index] := Value;
end;

function TDetPgtoFerCollection.New: TDetPgtoFerItem;
begin
  Result := TDetPgtoFerItem.Create;
  Self.Add(Result);
end;

{ TDetPgtoFerItem }

constructor TDetPgtoFerItem.Create;
begin
  inherited Create;
  FDetRubrFer := TRubricasComPensaoCollection.Create;
end;

destructor TDetPgtoFerItem.Destroy;
begin
  inherited;

  FDetRubrFer.Free;
end;

{ TDetPgtoBenPr }

constructor TDetPgtoBenPr.Create;
begin
  inherited;

  FRetPgtoTot   := nil;
  FInfoPgtoParc := nil;
end;

destructor TDetPgtoBenPr.Destroy;
begin
  FreeAndNil(FRetPgtoTot);
  FreeAndNil(FInfoPgtoParc);

  inherited;
end;

function TDetPgtoBenPr.getInfoPgtoParc: TRubricaCollection;
begin
  if not Assigned(FInfoPgtoParc) then
    FInfoPgtoParc := TRubricaCollection.Create;
  Result := FInfoPgtoParc;
end;

function TDetPgtoBenPr.getRetPgtoTot: TRubricaCollection;
begin
  if not Assigned(FRetPgtoTot) then
    FRetPgtoTot := TRubricaCollection.Create;
  Result := FRetPgtoTot;
end;

function TDetPgtoBenPr.infoPgtoParcInst: boolean;
begin
  Result := Assigned(FInfoPgtoParc);
end;

function TDetPgtoBenPr.retPgtoTotInst: boolean;
begin
  Result := Assigned(FRetPgtoTot);
end;

{ TEvtPgtos }

constructor TEvtPgtos.Create(AACBreSocial: TObject);
begin
  inherited Create(AACBreSocial);

  FIdeEvento     := TIdeEvento3.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeBenef      := TIdeBenef.Create;
end;

destructor TEvtPgtos.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeBenef.Free;

  inherited;
end;

procedure TEvtPgtos.GerarCamposRubricas(pRubrica: TRubricaCollectionItem);
begin
  if (VersaoDF >= ve02_04_02) then
    Gerador.wCampo(tcStr, '', 'matricula', 1, 30, 0, pRubrica.matricula);

  Gerador.wCampo(tcStr, '', 'codRubr',    1, 30, 1, pRubrica.codRubr);
  Gerador.wCampo(tcStr, '', 'ideTabRubr', 1,  8, 1, pRubrica.ideTabRubr);
  Gerador.wCampo(tcDe2, '', 'qtdRubr',    1,  6, 0, pRubrica.qtdRubr);
  Gerador.wCampo(tcDe2, '', 'fatorRubr',  1,  5, 0, pRubrica.fatorRubr);
  Gerador.wCampo(tcDe2, '', 'vrUnit',     1, 14, 0, pRubrica.vrUnit);
  Gerador.wCampo(tcDe2, '', 'vrRubr',     1, 14, 1, pRubrica.vrRubr);
end;

procedure TEvtPgtos.GerarRubricasComPensao(
  pRubricasComPensao: TRubricasComPensaoCollection;
  const GroupName: string = 'retPgtoTot');
var
  i: Integer;
begin
  for i := 0 to pRubricasComPensao.Count - 1 do
  begin
    Gerador.wGrupo(GroupName);

    GerarCamposRubricas(pRubricasComPensao[i]);

    if pRubricasComPensao[i].pensaoAlimInst() then
      GerarPensaoAlim(pRubricasComPensao[i].penAlim, 'penAlim');

    Gerador.wGrupo('/'+GroupName);
  end;

  if pRubricasComPensao.Count > 99 then
    Gerador.wAlerta('', GroupName, 'Lista de ' + GroupName, ERR_MSG_MAIOR_MAXIMO + '99');
end;

procedure TEvtPgtos.GerardetPgtoFl(objdetPgtofl: TdetPgtoFlCollection);
var
  i: Integer;
begin
  for i := 0 to objdetPgtofl.Count - 1 do
  begin
    Gerador.wGrupo('detPgtoFl');

    Gerador.wCampo(tcStr, '', 'perRef',    7,  7, 0, objdetPgtofl.Items[i].perRef);
    Gerador.wCampo(tcStr, '', 'ideDmDev',  1, 30, 1, objdetPgtofl.Items[i].ideDmDev);
    Gerador.wCampo(tcStr, '', 'indPgtoTt', 1,  1, 1, eSSimNaoToStr(objdetPgtofl.Items[i].indPagtoTt));
    Gerador.wCampo(tcDe2, '', 'vrLiq',     1, 14, 1, objdetPgtoFl.items[i].vrLiq);
    Gerador.wCampo(tcStr, '', 'nrRecArq',  1, 40, 0, objdetPgtofl.Items[i].nrRecArq);

    if objdetPgtofl.Items[i].retPagtoToInst() then
      GerarRubricasComPensao(objdetPgtofl.Items[i].retPagtoTot);

    if objdetPgtofl.Items[i].infoPgtoFlInst then
      GerarItensRemun(objdetPgtofl.Items[i].infoPgtoParc, 'infoPgtoParc');

    Gerador.wGrupo('/detPgtoFl');
  end;

  if objdetPgtofl.Count > 200 then
    Gerador.wAlerta('', 'detPgtoFl', 'Lista de Detalhamento de Pagamento', ERR_MSG_MAIOR_MAXIMO + '200');
end;

procedure TEvtPgtos.GerarDeps(pDeps: TDeps);
begin
  Gerador.wGrupo('deps');

  Gerador.wCampo(tcDe2, '', 'vrDedDep', 1, 14, 1, pDeps.vrDedDep);

  Gerador.wGrupo('/deps');
end;

procedure TEvtPgtos.GerarIdeBenef(objIdeBenef : TIdeBenef);
begin
  Gerador.wGrupo('ideBenef');
  Gerador.wCampo(tcStr, '', 'cpfBenef', 11, 11, 1, objIdeBenef.cpfBenef);

  if objIdeBenef.depsInst() then
    GerarDeps(objIdeBenef.deps);

  GerarInfoPgto(objIdeBenef.InfoPgto);

  Gerador.wGrupo('/ideBenef');
end;

procedure TEvtPgtos.GeraridePgtoExt(objPgtoExt: TPgtoExt);
begin
  Gerador.wGrupo('idePgtoExt');

  GerarIdePais(objPgtoExt.idePais);
  GerarEndExt(objPgtoExt.endExt);

  Gerador.wGrupo('/idePgtoExt');
end;

procedure TEvtPgtos.GerarDetPgtoBenPr(pDetPgtoBenPr: TDetPgtoBenPr);
begin
  Gerador.wGrupo('detPgtoBenPr');

  Gerador.wCampo(tcStr, '', 'perRef',    7,  7, 1, pDetPgtoBenPr.perRef);
  Gerador.wCampo(tcStr, '', 'ideDmDev',  1, 30, 1, pDetPgtoBenPr.ideDmDev);
  Gerador.wCampo(tcStr, '', 'indPgtoTt', 1,  1, 1, eSSimNaoToStr(pDetPgtoBenPr.indPgtoTt));
  Gerador.wCampo(tcDe2, '', 'vrLiq',     1, 14, 1, pDetPgtoBenPr.vrLiq);

  if pDetPgtoBenPr.retPgtoTotInst() then
    GerarItensRemun(pDetPgtoBenPr.retPgtoTot, 'retPgtoTot');

  if pDetPgtoBenPr.infoPgtoParcInst() then
    GerarItensRemun(pDetPgtoBenPr.retPgtoTot, 'infoPgtoParc');

  Gerador.wGrupo('/detPgtoBenPr');
end;

procedure TEvtPgtos.GerarDetPgtoFer(pDetPgtoFer: TDetPgtoFerCollection);
var
  i: integer;
begin
  for i := 0 to pDetPgtoFer.Count - 1 do
  begin
    Gerador.wGrupo('detPgtoFer');

    Gerador.wCampo(tcInt, '', 'codCateg',  1,  3, 1, pDetPgtoFer[i].codCateg);

    if (VersaoDF >= ve02_04_02) then
      Gerador.wCampo(tcStr, '', 'matricula', 1, 30, 0, pDetPgtoFer[i].matricula);

    Gerador.wCampo(tcDat, '', 'dtIniGoz', 10, 10, 1, pDetPgtoFer[i].dtIniGoz);
    Gerador.wCampo(tcInt, '', 'qtDias',    1,  2, 1, pDetPgtoFer[i].qtDias);
    Gerador.wCampo(tcDe2, '', 'vrLiq',     1, 14, 1, pDetPgtoFer[i].vrLiq);

    GerarRubricasComPensao(pDetPgtoFer[i].detRubrFer, 'detRubrFer');

    Gerador.wGrupo('/detPgtoFer');
  end;

  if pDetPgtoFer.Count > 5 then
    Gerador.wAlerta('', 'detPgtoFer', 'Lista de Detalhamento de Pagamento', ERR_MSG_MAIOR_MAXIMO + '5');
end;

procedure TEvtPgtos.GerarDetPgtoAnt(pDetPgtoAnt: TDetPgtoAntCollection);
var
  i: Integer;
begin
  for i := 0 to pDetPgtoAnt.Count - 1 do
  begin
    Gerador.wGrupo('detPgtoAnt');

    Gerador.wCampo(tcInt, '', 'codCateg', 1, 3, 1, pDetPgtoAnt[i].codCateg);

    GerarInfoPgtoAnt(pDetPgtoAnt[i].infoPgtoAnt);

    Gerador.wGrupo('/detPgtoAnt');
  end;

  if pDetPgtoAnt.Count > 99 then
    Gerador.wAlerta('', 'detPgtoAnt', 'Lista de Detalhamento de Pagamento Anterior', ERR_MSG_MAIOR_MAXIMO + '99');
end;

procedure TEvtPgtos.GerarInfoPgtoAnt(pInfoPgtoAnt: TInfoPgtoAntCollection);
var
  i: Integer;
begin
  for i := 0 to pInfoPgtoAnt.Count - 1 do
  begin
    Gerador.wGrupo('infoPgtoAnt');

    Gerador.wCampo(tcStr, '', 'tpBcIRRF', 2,  2, 1, eSCodIncIRRFToStr(pInfoPgtoAnt[i].tpBcIRRF));
    Gerador.wCampo(tcDe2, '', 'vrBcIRRF', 1, 14, 1, pInfoPgtoAnt[i].vrBcIRRF);

    Gerador.wGrupo('/infoPgtoAnt');
  end;

  if pInfoPgtoAnt.Count > 99 then
    Gerador.wAlerta('', 'infoPgtoAnt', 'Lista de Detalhamento de Pagamento', ERR_MSG_MAIOR_MAXIMO + '99');
end;

procedure TEvtPgtos.GerarInfoPgto(objInfoPgto: TInfoPgtoCollection);
var
  i: integer;
begin
  for i := 0 to objInfoPgto.Count - 1 do
  begin
    Gerador.wGrupo('infoPgto');

    Gerador.wCampo(tcDat, '', 'dtPgto',   10, 10, 1, objInfoPgto.Items[i].dtPgto);
    Gerador.wCampo(tcStr, '', 'tpPgto',    1,  2, 1, eSTpTpPgtoToStr(objInfoPgto.Items[i].tpPgto));
    Gerador.wCampo(tcStr, '', 'indResBr',  1,  1, 1, eSSimNaoToStr(objInfoPgto.Items[i].indResBr));

    if (objInfoPgto.Items[i].tpPgto in [tpPgtoRemun1200, tpPgtoResc2299, tpPgtoResc2399, tpPgtoRemun1202]) then
      if (objInfoPgto.Items[i].detPgtoFlInst()) then
        GerardetPgtoFl(objInfoPgto.Items[i].detPgtoFl);

    if objInfoPgto.Items[i].detPgtoBenPrInst() then
      GerarDetPgtoBenPr(objInfoPgto.Items[i].detPgtoBenPr);

    if objInfoPgto.Items[i].detPgtoFerInst() then
      GerarDetPgtoFer(objInfoPgto.Items[i].detPgtoFer);

    if objInfoPgto.Items[i].detPgtoAntInst() then
      GerarDetPgtoAnt(objInfoPgto.Items[i].detPgtoAnt);

    if (objInfoPgto.Items[i].indResBr = tpNao) then
      if (objInfoPgto.Items[i].detidePgtoExtInst) then
        GeraridePgtoExt(objInfoPgto.Items[i].idePgtoExt);

    Gerador.wGrupo('/infoPgto');
  end;

  if objInfoPgto.Count > 60 then
    Gerador.wAlerta('', 'infoPgto', 'Lista de Informa��es de Pagamento', ERR_MSG_MAIOR_MAXIMO + '60');
end;

function TEvtPgtos.GerarXML: Boolean;
begin
  try
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
     
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc, self.Sequencial);

    GerarCabecalho('evtPgtos');
    Gerador.wGrupo('evtPgtos Id="' + Self.Id + '"');

    GerarIdeEvento3(Self.IdeEvento);
    GerarIdeEmpregador(Self.ideEmpregador);
    GerarIdeBenef(Self.IdeBenef);

    Gerador.wGrupo('/evtPgtos');

    GerarRodape;

    FXML := Gerador.ArquivoFormatoXML;
//    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtPgtos');

//    Validar(schevtPgtos);
  except on e:exception do
    raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TEvtPgtos.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  Ok: Boolean;
  sSecao, sFim: String;
  I, J, K, L: Integer;
begin
  Result := True;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with Self do
    begin
      sSecao := 'evtPgtos';
      Id         := INIRec.ReadString(sSecao, 'Id', '');
      Sequencial := INIRec.ReadInteger(sSecao, 'Sequencial', 0);

      sSecao := 'ideEvento';
      ideEvento.indRetif    := eSStrToIndRetificacao(Ok, INIRec.ReadString(sSecao, 'indRetif', '1'));
      ideEvento.NrRecibo    := INIRec.ReadString(sSecao, 'nrRecibo', EmptyStr);
      ideEvento.IndApuracao := eSStrToIndApuracao(Ok, INIRec.ReadString(sSecao, 'indApuracao', '1'));
      ideEvento.perApur     := INIRec.ReadString(sSecao, 'perApur', EmptyStr);
      ideEvento.ProcEmi     := eSStrToProcEmi(Ok, INIRec.ReadString(sSecao, 'procEmi', '1'));
      ideEvento.VerProc     := INIRec.ReadString(sSecao, 'verProc', EmptyStr);

      sSecao := 'ideEmpregador';
      ideEmpregador.OrgaoPublico := (TACBreSocial(FACBreSocial).Configuracoes.Geral.TipoEmpregador = teOrgaoPublico);
      ideEmpregador.TpInsc       := eSStrToTpInscricao(Ok, INIRec.ReadString(sSecao, 'tpInsc', '1'));
      ideEmpregador.NrInsc       := INIRec.ReadString(sSecao, 'nrInsc', EmptyStr);

      sSecao := 'ideBenef';
      ideBenef.cpfBenef := INIRec.ReadString(sSecao, 'cpfBenef', EmptyStr);

      sSecao := 'deps';
      if INIRec.ReadString(sSecao, 'vrDedDep', '') <> '' then
        ideBenef.deps.vrDedDep := StringToFloatDef(INIRec.ReadString(sSecao, 'vrDedDep', ''), 0);

      I := 1;
      while true do
      begin
        // de 01 at� 60
        sSecao := 'infoPgto' + IntToStrZero(I, 2);
        sFim   := INIRec.ReadString(sSecao, 'dtPgto', 'FIM');

        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with ideBenef.InfoPgto.New do
        begin
          DtPgto   := StringToDateTime(sFim);
          TpPgto   := eSStrTotpTpPgto(Ok, INIRec.ReadString(sSecao, 'tpPgto', '1'));
          IndResBr := eSStrToSimNao(Ok, INIRec.ReadString(sSecao, 'indResBr', 'S'));

          J := 1;
          while true do
          begin
            // de 001 at� 200
            sSecao := 'detPgtoFl' + IntToStrZero(I, 2) + IntToStrZero(J, 3);
            sFim   := INIRec.ReadString(sSecao, 'perRef', 'FIM');

            if (sFim = 'FIM') then
              break;

            with detPgtoFl.New do
            begin
              perRef     := sFim;
              ideDmDev   := INIRec.ReadString(sSecao, 'ideDmDev', EmptyStr);
              indPagtoTt := eSStrToSimNao(Ok, INIRec.ReadString(sSecao, 'indPagtoTt', 'S'));
              vrLiq      := StringToFloatDef(INIRec.ReadString(sSecao, 'vrLiq', ''), 0);
              nrRecArq   := INIRec.ReadString(sSecao, 'nrRecArq', EmptyStr);

              K := 1;
              while true do
              begin
                // de 01 at� 99
                sSecao := 'retPgtoTot' + IntToStrZero(I, 2) + IntToStrZero(J, 3) +
                               IntToStrZero(K, 2);
                sFim   := INIRec.ReadString(sSecao, 'codRubr', 'FIM');

                if (sFim = 'FIM') or (Length(sFim) <= 0) then
                  break;

                with retPagtoTot.New do
                begin
                  codRubr    := sFim;
                  ideTabRubr := INIRec.ReadString(sSecao, 'ideTabRubr', EmptyStr);
                  qtdRubr    := StringToFloatDef(INIRec.ReadString(sSecao, 'qtdRubr', ''), 0);
                  fatorRubr  := StringToFloatDef(INIRec.ReadString(sSecao, 'fatorRubr', ''), 0);
                  vrUnit     := StringToFloatDef(INIRec.ReadString(sSecao, 'vrUnit', ''), 0);
                  vrRubr     := StringToFloatDef(INIRec.ReadString(sSecao, 'vrRubr', ''), 0);

                  L := 1;
                  while true do
                  begin
                    // de 01 at� 99
                    sSecao := 'penAlim' + IntToStrZero(I, 2) + IntToStrZero(J, 3) +
                                   IntToStrZero(K, 2) + IntToStrZero(L, 2);
                    sFim   := INIRec.ReadString(sSecao, 'cpfBenef', 'FIM');

                    if (sFim = 'FIM') or (Length(sFim) <= 0) then
                      break;

                    with penAlim.New do
                    begin
                      cpfBenef      := sFim;
                      dtNasctoBenef := StringToDateTime(INIRec.ReadString(sSecao, 'dtNasctoBenef', '0'));
                      nmBenefic     := INIRec.ReadString(sSecao, 'nmBenefic', EmptyStr);
                      vlrPensao     := StringToFloatDef(INIRec.ReadString(sSecao, 'vlrPensao', ''), 0);
                    end;

                    Inc(L);
                  end;

                end;

                Inc(K);
              end;

              K := 1;
              while true do
              begin
                // de 01 at� 99
                sSecao := 'infoPgtoParc' + IntToStrZero(I, 2) + IntToStrZero(J, 3) +
                               IntToStrZero(K, 2);
                sFim   := INIRec.ReadString(sSecao, 'codRubr', 'FIM');

                if (sFim = 'FIM') or (Length(sFim) <= 0) then
                  break;

                with infoPgtoParc.New do
                begin
                  matricula := INIRec.ReadString(sSecao, 'matricula', EmptyStr);
                  codRubr    := sFim;
                  ideTabRubr := INIRec.ReadString(sSecao, 'ideTabRubr', EmptyStr);
                  qtdRubr    := StringToFloatDef(INIRec.ReadString(sSecao, 'qtdRubr', ''), 0);
                  fatorRubr  := StringToFloatDef(INIRec.ReadString(sSecao, 'fatorRubr', ''), 0);
                  vrUnit     := StringToFloatDef(INIRec.ReadString(sSecao, 'vrUnit', ''), 0);
                  vrRubr     := StringToFloatDef(INIRec.ReadString(sSecao, 'vrRubr', ''), 0);
                end;

                Inc(K);
              end;

            end;

            Inc(J);
          end;

          sSecao := 'detPgtoBenPr' + IntToStrZero(I, 2);
          if INIRec.ReadString(sSecao, 'perRef', '') <> '' then
          begin
            detPgtoBenPr.perRef    := INIRec.ReadString(sSecao, 'perRef', EmptyStr);
            detPgtoBenPr.ideDmDev  := INIRec.ReadString(sSecao, 'ideDmDev', EmptyStr);
            detPgtoBenPr.indPgtoTt := eSStrToSimNao(Ok, INIRec.ReadString(sSecao, 'indPgtoTt', 'S'));
            detPgtoBenPr.vrLiq     := StringToFloatDef(INIRec.ReadString(sSecao, 'vrLiq', ''), 0);
          end;

          J := 1;
          while true do
          begin
            // de 01 at� 99
            sSecao := 'retPgtoTot' + IntToStrZero(I, 2) + IntToStrZero(J, 2);
            sFim   := INIRec.ReadString(sSecao, 'codRubr', 'FIM');

            if (sFim = 'FIM') or (Length(sFim) <= 0) then
              break;

            with detPgtoBenPr.retPgtoTot.New do
            begin
              codRubr    := sFim;
              ideTabRubr := INIRec.ReadString(sSecao, 'ideTabRubr', EmptyStr);
              qtdRubr    := StringToFloatDef(INIRec.ReadString(sSecao, 'qtdRubr', ''), 0);
              fatorRubr  := StringToFloatDef(INIRec.ReadString(sSecao, 'fatorRubr', ''), 0);
              vrUnit     := StringToFloatDef(INIRec.ReadString(sSecao, 'vrUnit', ''), 0);
              vrRubr     := StringToFloatDef(INIRec.ReadString(sSecao, 'vrRubr', ''), 0);
            end;

            Inc(J);
          end;

          J := 1;
          while true do
          begin
            // de 01 at� 99
            sSecao := 'infoPgtoParc' + IntToStrZero(I, 2) + IntToStrZero(J, 2);
            sFim   := INIRec.ReadString(sSecao, 'codRubr', 'FIM');

            if (sFim = 'FIM') or (Length(sFim) <= 0) then
              break;

            with detPgtoBenPr.infoPgtoParc.New do
            begin
              codRubr    := sFim;
              ideTabRubr := INIRec.ReadString(sSecao, 'ideTabRubr', EmptyStr);
              qtdRubr    := StringToFloatDef(INIRec.ReadString(sSecao, 'qtdRubr', ''), 0);
              fatorRubr  := StringToFloatDef(INIRec.ReadString(sSecao, 'fatorRubr', ''), 0);
              vrUnit     := StringToFloatDef(INIRec.ReadString(sSecao, 'vrUnit', ''), 0);
              vrRubr     := StringToFloatDef(INIRec.ReadString(sSecao, 'vrRubr', ''), 0);
            end;

            Inc(J);
          end;

          J := 1;
          while true do
          begin
            // de 1 at� 5
            sSecao := 'detPgtoFer' + IntToStrZero(I, 2) + IntToStrZero(J, 1);
            sFim   := INIRec.ReadString(sSecao, 'codCateg', 'FIM');

            if (sFim = 'FIM') or (Length(sFim) <= 0) then
              break;

            with detPgtoFer.New do
            begin
              codCateg  := StrToInt(sFim);
              matricula := INIRec.ReadString(sSecao, 'matricula', '');
              dtIniGoz  := StringToDateTime(INIRec.ReadString(sSecao, 'dtIniGoz', '0'));
              qtDias    := INIRec.ReadInteger(sSecao, 'qtDias', 0);
              vrLiq     := StringToFloatDef(INIRec.ReadString(sSecao, 'vrLiq', ''), 0);

              K := 1;
              while true do
              begin
                // de 01 at� 99
                sSecao := 'detRubrFer' + IntToStrZero(I, 2) + IntToStrZero(J, 1) +
                               IntToStrZero(K, 2);
                sFim   := INIRec.ReadString(sSecao, 'codRubr', 'FIM');

                if (sFim = 'FIM') or (Length(sFim) <= 0) then
                  break;

                with detRubrFer.New do
                begin
                  codRubr    := sFim;
                  ideTabRubr := INIRec.ReadString(sSecao, 'ideTabRubr', EmptyStr);
                  qtdRubr    := StringToFloatDef(INIRec.ReadString(sSecao, 'qtdRubr', ''), 0);
                  fatorRubr  := StringToFloatDef(INIRec.ReadString(sSecao, 'fatorRubr', ''), 0);
                  vrUnit     := StringToFloatDef(INIRec.ReadString(sSecao, 'vrUnit', ''), 0);
                  vrRubr     := StringToFloatDef(INIRec.ReadString(sSecao, 'vrRubr', ''), 0);

                  L := 1;
                  while true do
                  begin
                    // de 01 at� 99
                    sSecao := 'penAlim' + IntToStrZero(I, 2) + IntToStrZero(J, 1) +
                                   IntToStrZero(K, 2) + IntToStrZero(L, 2);
                    sFim   := INIRec.ReadString(sSecao, 'cpfBenef', 'FIM');

                    if (sFim = 'FIM') or (Length(sFim) <= 0) then
                      break;

                    with penAlim.New do
                    begin
                      cpfBenef      := sFim;
                      dtNasctoBenef := StringToDateTime(INIRec.ReadString(sSecao, 'dtNasctoBenef', '0'));
                      nmBenefic     := INIRec.ReadString(sSecao, 'nmBenefic', EmptyStr);
                      vlrPensao     := StringToFloatDef(INIRec.ReadString(sSecao, 'vlrPensao', ''), 0);
                    end;

                    Inc(L);
                  end;

                end;

                Inc(K);
              end;

            end;

            Inc(J);
          end;

          J := 1;
          while true do
          begin
            // de 01 at� 99
            sSecao := 'detPgtoAnt' + IntToStrZero(I, 2) + IntToStrZero(J, 2);
            sFim   := INIRec.ReadString(sSecao, 'codCateg', 'FIM');

            if (sFim = 'FIM') or (Length(sFim) <= 0) then
              break;

            with detPgtoAnt.New do
            begin
              codCateg := StrToInt(sFim);

              K := 1;
              while true do
              begin
                // de 01 at� 99
                sSecao := 'infoPgtoAnt' + IntToStrZero(I, 2) + IntToStrZero(J, 2) +
                               IntToStrZero(K, 2);
                sFim   := INIRec.ReadString(sSecao, 'tpBcIRRF', 'FIM');

                if (sFim = 'FIM') or (Length(sFim) <= 0) then
                  break;

                with infoPgtoAnt.New do
                begin
                  tpBcIRRF := eSStrToCodIncIRRF(Ok, sFim);
                  vrBcIRRF := StringToFloatDef(INIRec.ReadString(sSecao, 'vrBcIRRF', ''), 0);
                end;

                Inc(K);
              end;

            end;

            Inc(J);
          end;

          sSecao := 'idePgtoExt' + IntToStrZero(I, 2);
          if INIRec.ReadString(sSecao, 'codPais', '') <> '' then
          begin
            idePgtoExt.idePais.codPais  := INIRec.ReadString(sSecao, 'codPais', EmptyStr);
            idePgtoExt.idePais.indNIF   := eSStrToIndNIF(Ok, INIRec.ReadString(sSecao, 'indNIF', '1'));
            idePgtoExt.idePais.nifBenef := INIRec.ReadString(sSecao, 'nifBenef', EmptyStr);

            idePgtoExt.endExt.dscLograd := INIRec.ReadString(sSecao, 'dscLograd', EmptyStr);
            idePgtoExt.endExt.nrLograd  := INIRec.ReadString(sSecao, 'nrLograd', EmptyStr);
            idePgtoExt.endExt.complem   := INIRec.ReadString(sSecao, 'complem', EmptyStr);
            idePgtoExt.endExt.bairro    := INIRec.ReadString(sSecao, 'bairro', EmptyStr);
            idePgtoExt.endExt.nmCid     := INIRec.ReadString(sSecao, 'nmCid', EmptyStr);
            idePgtoExt.endExt.codPostal := INIRec.ReadString(sSecao, 'codPostal', EmptyStr);
          end;
        end;

        Inc(I);
      end;
    end;

    GerarXML;
    XML := FXML;
  finally
    INIRec.Free;
  end;
end;

end.
