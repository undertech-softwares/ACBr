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

unit pcesS2210;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  ACBrBase,
  pcnConversao, pcnGerador, ACBrUtil, pcnConsts,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  TS2210CollectionItem = class;
  TEvtCAT = class;
  TCat = class;
  TCatOrigem = class;
  TAtestado = class;
  TAgenteCausadorCollection = class;
  TAgenteCausadorItem = class;
  TParteAtingidaCollection = class;
  TParteAtingidaItem = class;
  TLocalAcidente = class;
  TideLocalAcid = class;

  TS2210Collection = class(TeSocialCollection)
  private
    function GetItem(Index: Integer): TS2210CollectionItem;
    procedure SetItem(Index: Integer; Value: TS2210CollectionItem);
  public
    function Add: TS2210CollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TS2210CollectionItem;
    property Items[Index: Integer]: TS2210CollectionItem read GetItem write SetItem; default;
  end;

  TS2210CollectionItem = class(TObject)
  private
    FTipoEvento: TTipoEvento;
    FEvtCAT: TEvtCAT;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtCAT: TEvtCAT read FEvtCAT write FEvtCAT;
  end;

  TEvtCAT = class(TeSocialEvento)
  private
    FIdeEvento: TIdeEvento2;
    FIdeEmpregador: TIdeEmpregador;
    FIdeVinculo: TIdeVinculo;
    FCat: TCat;

    procedure GerarCAT;
    procedure GerarLocalAcidente;
    procedure GerarIdeLocalAcid;
    procedure GerarParteAtingida;
    procedure GerarAgenteCausador;
    procedure GerarAtestado;
    procedure GerarCatOrigem;
  public
    constructor Create(AACBreSocial: TObject); override;
    destructor Destroy; override;

    function GerarXML: boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property IdeEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeVinculo: TIdeVinculo read FIdeVinculo write FIdeVinculo;
    property Cat: TCat read FCat write FCat;
  end;
          
  TCat = class(TObject)
  private
    FdtAcid: TDateTime;
    FTpAcid: string;
    FhrAcid: string;
    FhrsTrabAntesAcid: string;
    FtpCat: tpTpCat;
    FindCatObito: tpSimNao;
    FDtObito: TDateTime;
    FindComunPolicia: tpSimNao;
    FcodSitGeradora: integer;
    FiniciatCAT: tpIniciatCAT;
    FobsCAT: string;
    FLocalAcidente: TLocalAcidente;
    FParteAtingida: TParteAtingidaCollection;
    FAgenteCausador: TAgenteCausadorCollection;
    FAtestado: TAtestado;
    FCatOrigem: TCatOrigem;
  public
    constructor Create;
    destructor Destroy; override;

    property dtAcid: TDateTime read FdtAcid write FdtAcid;
    property TpAcid: string read FTpAcid write FTpAcid;
    property hrAcid: string read FhrAcid write FhrAcid;
    property hrsTrabAntesAcid: string read FhrsTrabAntesAcid write FhrsTrabAntesAcid;
    property tpCat: tpTpCat read FtpCat write FtpCat;
    property indCatObito: tpSimNao read FindCatObito write FindCatObito;
    property dtOBito: TDateTime read FDtObito write FDtObito;
    property indComunPolicia: tpSimNao read FindComunPolicia write FindComunPolicia;
    property codSitGeradora: integer read FcodSitGeradora write FcodSitGeradora;
    property iniciatCAT: tpIniciatCAT read FiniciatCAT write FiniciatCAT;
    property obsCAT: string read FobsCAT write FobsCAT;
    property LocalAcidente: TLocalAcidente read FLocalAcidente write FLocalAcidente;
    property ParteAtingida: TParteAtingidaCollection read FParteAtingida write FParteAtingida;
    property AgenteCausador: TAgenteCausadorCollection read FAgenteCausador write FAgenteCausador;
    property Atestado: TAtestado read FAtestado write FAtestado;
    property CatOrigem: TCatOrigem read FCatOrigem write FCatOrigem;
  end;

  TAtestado = class
  private
    FcodCNES: String;
    FdtAtendimento: TDateTime;
    FhrAtendimento: string;
    FindInternacao: tpSimNao;
    FdurTrat: integer;
    FindAfast: tpSimNao;
    FdscLesao: integer;
    FdscCompLesao: string;
    FdiagProvavel: string;
    FcodCID: string;
    Fobservacao: string;
    FEmitente: TEmitente;
  public
    constructor Create;
    destructor Destroy; override;

    property codCNES: String read FcodCNES write FcodCNES;
    property dtAtendimento: TDateTime read FdtAtendimento write FdtAtendimento;
    property hrAtendimento: string read FhrAtendimento write FhrAtendimento;
    property indInternacao: tpSimNao read FindInternacao write FindInternacao;
    property durTrat: integer read FdurTrat write FdurTrat;
    property indAfast: tpSimNao read FindAfast write FindAfast;
    property dscLesao: integer read FdscLesao write FdscLesao;
    property dscCompLesao: string read FdscCompLesao write FdscCompLesao;
    property diagProvavel: string read FdiagProvavel write FdiagProvavel;
    property codCID: string read FcodCID write FcodCID;
    property observacao: string read Fobservacao write Fobservacao;
    property Emitente: TEmitente read FEmitente write FEmitente;
  end;

  TCatOrigem = class
  private
    FnrRecCatOrig: string;
  public
    property nrRecCatOrig: string read FnrRecCatOrig write FnrRecCatOrig;
  end;

  TAgenteCausadorItem = class(TObject)
  private
    FcodAgntCausador: Integer;
  public
    property codAgntCausador: Integer read FcodAgntCausador write FcodAgntCausador;
  end;

  TAgenteCausadorCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TAgenteCausadorItem;
    procedure SetItem(Index: Integer; const Value: TAgenteCausadorItem);
  public
    function Add: TAgenteCausadorItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TAgenteCausadorItem;
    property Items[Index: Integer]: TAgenteCausadorItem read GetItem write SetItem;
  end;

  TParteAtingidaItem = class(TObject)
  private
    FcodParteAting: Integer;
    Flateralidade: tpLateralidade;
  public
    property codParteAting: Integer read FcodParteAting write FcodParteAting;
    property lateralidade: tpLateralidade read Flateralidade write Flateralidade;
  end;

  TParteAtingidaCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TParteAtingidaItem;
    procedure SetItem(Index: Integer; const Value: TParteAtingidaItem);
  public
    function Add: TParteAtingidaItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TParteAtingidaItem;
    property Items[Index: Integer]: TParteAtingidaItem read GetItem write SetItem;
  end;

  TideLocalAcid = class(TObject)
  private
    FtpInsc: tpTpInsc;
    FnrInsc: string;
  public
    property tpInsc: tpTpInsc read FtpInsc write FtpInsc;
    property nrInsc: String read FnrInsc write FnrInsc;
  end;

  TLocalAcidente = class
  private
    FtpLocal: tpTpLocal;
    FdscLocal: String;
    FcodAmb: String;
    FtpLograd: String;
    FdscLograd: String;
    FnrLograd: String;
    Fcomplemento: String;
    Fbairro: String;
    Fcep: String;
    FcodMunic: Integer;
    Fuf: tpuf;
    FPais: String;
    FCodPostal: String;
    FideLocalAcid: TideLocalAcid;
  public
    constructor Create;
    destructor Destroy; override;

    property tpLocal: tpTpLocal read FtpLocal write FtpLocal;
    property dscLocal: string read FdscLocal write FdscLocal;
    property codAmb: string read FcodAmb write FcodAmb;
    property tpLograd: string read FtpLograd write FtpLograd;
    property dscLograd: string read FdscLograd write FdscLograd;
    property nrLograd: string read FnrLograd write FnrLograd;
    property complemento: string read Fcomplemento write Fcomplemento;
    property bairro: string read Fbairro write Fbairro;
    property cep: string read Fcep write Fcep;
    property codMunic: Integer read FcodMunic write FcodMunic;
    property uf: tpuf read Fuf write Fuf;
    property pais: string read FPais write FPais;
    property codPostal: string read FCodPostal write FCodPostal;
    property ideLocalAcid: TideLocalAcid read FideLocalAcid write FideLocalAcid;
  end;

implementation

uses
  IniFiles,
  ACBreSocial;

{ TS2210Collection }

function TS2210Collection.Add: TS2210CollectionItem;
begin
  Result := Self.New;
end;

function TS2210Collection.GetItem(Index: Integer): TS2210CollectionItem;
begin
  Result := TS2210CollectionItem(inherited Items[Index]);
end;

procedure TS2210Collection.SetItem(Index: Integer;
  Value: TS2210CollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TS2210Collection.New: TS2210CollectionItem;
begin
  Result := TS2210CollectionItem.Create(FACBreSocial);
  Self.Add(Result);
end;

{ TS2210CollectionItem }

constructor TS2210CollectionItem.Create(AOwner: TComponent);
begin
  inherited Create;
  FTipoEvento := teS2210;
  FEvtCAT     := TEvtCAT.Create(AOwner);
end;

destructor TS2210CollectionItem.Destroy;
begin
  FEvtCAT.Free;

  inherited;
end;

{ TAtestado }

constructor TAtestado.Create;
begin
  inherited Create;
  FEmitente := TEmitente.Create;
end;

destructor TAtestado.Destroy;
begin
  FEmitente.Free;

  inherited;
end;

{ TAgenteCausadorCollection }

function TAgenteCausadorCollection.Add: TAgenteCausadorItem;
begin
  Result := Self.New;
end;

function TAgenteCausadorCollection.GetItem(Index: Integer): TAgenteCausadorItem;
begin
  Result := TAgenteCausadorItem(inherited Items[Index]);
end;

procedure TAgenteCausadorCollection.SetItem(Index: Integer; const Value: TAgenteCausadorItem);
begin
  inherited Items[Index] := Value;
end;

function TAgenteCausadorCollection.New: TAgenteCausadorItem;
begin
  Result := TAgenteCausadorItem.Create;
  Self.Add(Result);
end;

{ TParteAtingidaCollection }

function TParteAtingidaCollection.Add: TParteAtingidaItem;
begin
  Result := Self.New;
end;

function TParteAtingidaCollection.GetItem(Index: Integer): TParteAtingidaItem;
begin
  Result := TParteAtingidaItem(inherited Items[Index]);
end;

function TParteAtingidaCollection.New: TParteAtingidaItem;
begin
  Result := TParteAtingidaItem.Create;
  Self.Add(Result);
end;

procedure TParteAtingidaCollection.SetItem(Index: Integer; const Value: TParteAtingidaItem);
begin
  inherited Items[Index] := Value;
end;

{ TCat }

constructor TCat.Create;
begin
  inherited;

  FLocalAcidente  := TLocalAcidente.Create;
  FParteAtingida  := TParteAtingidaCollection.Create;
  FAgenteCausador := TAgenteCausadorCollection.Create;
  FAtestado       := TAtestado.Create;
  FCatOrigem      := TCatOrigem.Create;
end;

destructor TCat.Destroy;
begin
  FLocalAcidente.Free;
  FParteAtingida.Free;
  FAgenteCausador.Free;
  FAtestado.Free;
  FCatOrigem.Free;

  inherited;
end;

{ TEvtCAT }

constructor TEvtCAT.Create(AACBreSocial: TObject);
begin
  inherited Create(AACBreSocial);

  FIdeEvento     := TIdeEvento2.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeVinculo    := TIdeVinculo.Create;
  FCat           := TCat.Create;
end;

destructor TEvtCAT.destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeVinculo.Free;
  FCat.Free;

  inherited;
end;

procedure TEvtCAT.GerarAgenteCausador;
var
  i: integer;
begin
  for i:= 0 to Self.Cat.AgenteCausador.Count-1 do
  begin
    Gerador.wGrupo('agenteCausador');

    Gerador.wCampo(tcInt, '', 'codAgntCausador', 1, 9, 1, Self.Cat.AgenteCausador.Items[i].codAgntCausador);

    Gerador.wGrupo('/agenteCausador');
  end;

  if Self.Cat.AgenteCausador.Count > 99 then
    Gerador.wAlerta('', 'agenteCausador', 'Lista de Agentes Causadores', ERR_MSG_MAIOR_MAXIMO + '99');
end;

procedure TEvtCAT.GerarAtestado;
begin
  if Self.Cat.Atestado.dtAtendimento > 0 then
  begin
    Gerador.wGrupo('atestado');

    Gerador.wCampo(tcStr, '', 'codCNES',        1,   7, 0, Self.Cat.Atestado.codCNES);
    Gerador.wCampo(tcDat, '', 'dtAtendimento', 10,  10, 1, Self.Cat.Atestado.dtAtendimento);
    Gerador.wCampo(tcStr, '', 'hrAtendimento',  4,   4, 1, Self.Cat.Atestado.hrAtendimento);
    Gerador.wCampo(tcStr, '', 'indInternacao',  1,   1, 1, eSSimNaoToStr(Self.Cat.Atestado.indInternacao));
    Gerador.wCampo(tcInt, '', 'durTrat',        1,   4, 1, Self.Cat.Atestado.durTrat);
    Gerador.wCampo(tcStr, '', 'indAfast',       1,   1, 1, eSSimNaoToStr(Self.Cat.Atestado.indAfast));
    Gerador.wCampo(tcInt, '', 'dscLesao',       1,   9, 0, Self.Cat.Atestado.dscLesao);
    Gerador.wCampo(tcStr, '', 'dscCompLesao',   1, 200, 0, Self.Cat.Atestado.dscCompLesao);
    Gerador.wCampo(tcStr, '', 'diagProvavel',   1, 100, 0, Self.Cat.Atestado.diagProvavel);
    Gerador.wCampo(tcStr, '', 'codCID',         1,   4, 1, Self.Cat.Atestado.codCID);
    Gerador.wCampo(tcStr, '', 'observacao',     1, 255, 0, Self.Cat.Atestado.observacao);

    GerarEmitente(Self.Cat.Atestado.Emitente, teS2210);

    Gerador.wGrupo('/atestado');
  end;
end;

procedure TEvtCAT.GerarCAT;
begin
  Gerador.wGrupo('cat');

  Gerador.wCampo(tcDat, '', 'dtAcid',           10,  10, 1, Self.Cat.dtAcid);
  Gerador.wCampo(tcStr, '', 'tpAcid',            1,   6, 1, Self.Cat.tpAcid);
  Gerador.wCampo(tcStr, '', 'hrAcid',            4,   4, 1, Self.Cat.hrAcid);
  Gerador.wCampo(tcStr, '', 'hrsTrabAntesAcid',  4,   4, 1, Self.Cat.hrsTrabAntesAcid);
  Gerador.wCampo(tcStr, '', 'tpCat',             1,   1, 1, eSTpCatToStr(Self.Cat.tpCat));
  Gerador.wCampo(tcStr, '', 'indCatObito',       1,   1, 1, eSSimNaoToStr(Self.Cat.indCatObito));
  Gerador.wCampo(tcDat, '', 'dtObito',          10,  10, 0, Self.Cat.dtOBito);
  Gerador.wCampo(tcStr, '', 'indComunPolicia',   1,   1, 1, eSSimNaoToStr(Self.Cat.indComunPolicia));
  Gerador.wCampo(tcInt, '', 'codSitGeradora',    1,   9, 0, Self.Cat.codSitGeradora);
  Gerador.wCampo(tcStr, '', 'iniciatCAT',        1,   1, 1, eSIniciatCATToStr(Self.Cat.iniciatCAT));
  Gerador.wCampo(tcStr, '', 'obsCAT',            1, 255, 0, Self.Cat.obsCAT);

  GerarLocalAcidente;
  GerarParteAtingida;
  GerarAgenteCausador;
  GerarAtestado;
  GerarCatOrigem;

  Gerador.wGrupo('/cat');
end;

procedure TEvtCAT.GerarCatOrigem;
begin
  if Self.Cat.CatOrigem.nrRecCatOrig <> '' then
  begin
    Gerador.wGrupo('catOrigem');

    Gerador.wCampo(tcStr, '', 'nrRecCatOrig',  1, 40, 1, Self.Cat.CatOrigem.nrRecCatOrig);

    Gerador.wGrupo('/catOrigem');
  end;
end;

procedure TEvtCAT.GerarIdeLocalAcid;
begin
  if (Self.Cat.LocalAcidente.ideLocalAcid.nrInsc <> '') then
  begin
    Gerador.wGrupo('ideLocalAcid');

    Gerador.wCampo(tcStr, '', 'tpInsc', 1,  1, 1, eSTpInscricaoToStr(Self.Cat.LocalAcidente.ideLocalAcid.TpInsc));
    Gerador.wCampo(tcStr, '', 'nrInsc', 1, 15, 1, Self.Cat.LocalAcidente.ideLocalAcid.nrInsc);

    Gerador.wGrupo('/ideLocalAcid');
  end;
end;

procedure TEvtCAT.GerarLocalAcidente;
begin
  Gerador.wGrupo('localAcidente');

  Gerador.wCampo(tcStr, '', 'tpLocal',     1,   1, 1, eSTpLocalToStr(Self.Cat.LocalAcidente.tpLocal));
  Gerador.wCampo(tcStr, '', 'dscLocal',    1,  80, 0, Self.Cat.LocalAcidente.dscLocal);
  Gerador.wCampo(tcStr, '', 'codAmb',      1,  30, 0, Self.Cat.LocalAcidente.codAmb);
  Gerador.wCampo(tcStr, '', 'tpLograd',    1,   4, 0, Self.Cat.LocalAcidente.tpLograd);
  Gerador.wCampo(tcStr, '', 'dscLograd',   1, 100, 0, Self.Cat.LocalAcidente.dscLograd);
  Gerador.wCampo(tcStr, '', 'nrLograd',    1,  10, 0, Self.Cat.LocalAcidente.nrLograd);
  Gerador.wCampo(tcStr, '', 'complemento', 1,  30, 0, Self.Cat.LocalAcidente.complemento);
  Gerador.wCampo(tcStr, '', 'bairro',      1,  90, 0, Self.Cat.LocalAcidente.bairro);
  Gerador.wCampo(tcStr, '', 'cep',         1,   8, 0, Self.Cat.LocalAcidente.cep);
  Gerador.wCampo(tcInt, '', 'codMunic',    7,   7, 0, Self.Cat.LocalAcidente.codMunic);
  Gerador.wCampo(tcStr, '', 'uf',          2,   2, 0, eSufToStr(Self.Cat.LocalAcidente.uf));
  Gerador.wCampo(tcStr, '', 'pais',        1,   3, 0, Self.Cat.LocalAcidente.pais);
  Gerador.wCampo(tcStr, '', 'codPostal',   1,  12, 0, Self.Cat.LocalAcidente.codPostal);

  GerarIdeLocalAcid;

  Gerador.wGrupo('/localAcidente');
end;

procedure TEvtCAT.GerarParteAtingida;
var
  i: integer;
begin
  for i:= 0 to Self.Cat.ParteAtingida.Count-1 do
  begin
    Gerador.wGrupo('parteAtingida');

    Gerador.wCampo(tcInt, '', 'codParteAting', 1, 9, 1, Self.Cat.ParteAtingida.Items[i].codParteAting);
    Gerador.wCampo(tcStr, '', 'lateralidade',  1, 1, 1, eSLateralidadeToStr(Self.Cat.ParteAtingida.Items[i].lateralidade));

    Gerador.wGrupo('/parteAtingida');
  end;

  if Self.Cat.ParteAtingida.Count > 99 then
    Gerador.wAlerta('', 'parteAtingida', 'Lista de Partes Atingidas', ERR_MSG_MAIOR_MAXIMO + '99');
end;

function TEvtCAT.GerarXML: boolean;
begin
  try
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
     
    Self.Id := GerarChaveEsocial(now, Self.ideEmpregador.NrInsc, Self.Sequencial);

    GerarCabecalho('evtCAT');
    Gerador.wGrupo('evtCAT Id="' + Self.Id + '"');

    GerarIdeEvento2(Self.IdeEvento);
    GerarIdeEmpregador(Self.IdeEmpregador);
    GerarIdeVinculo(Self.IdeVinculo);
    GerarCAT;

    Gerador.wGrupo('/evtCAT');

    GerarRodape;

    FXML := Gerador.ArquivoFormatoXML;
//    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtCAT');

//    Validar(schevtCAT);
  except on e:exception do
    raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TEvtCAT.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  Ok: Boolean;
  sSecao, sFim: String;
  I: Integer;
begin
  Result := True;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with Self do
    begin
      sSecao := 'evtCAT';
      Id         := INIRec.ReadString(sSecao, 'Id', '');
      Sequencial := INIRec.ReadInteger(sSecao, 'Sequencial', 0);

      sSecao := 'ideEvento';
      ideEvento.indRetif    := eSStrToIndRetificacao(Ok, INIRec.ReadString(sSecao, 'indRetif', '1'));
      ideEvento.NrRecibo    := INIRec.ReadString(sSecao, 'nrRecibo', EmptyStr);
      ideEvento.ProcEmi     := eSStrToProcEmi(Ok, INIRec.ReadString(sSecao, 'procEmi', '1'));
      ideEvento.VerProc     := INIRec.ReadString(sSecao, 'verProc', EmptyStr);

      sSecao := 'ideEmpregador';
      ideEmpregador.OrgaoPublico := (TACBreSocial(FACBreSocial).Configuracoes.Geral.TipoEmpregador = teOrgaoPublico);
      ideEmpregador.TpInsc       := eSStrToTpInscricao(Ok, INIRec.ReadString(sSecao, 'tpInsc', '1'));
      ideEmpregador.NrInsc       := INIRec.ReadString(sSecao, 'nrInsc', EmptyStr);

      sSecao := 'ideVinculo';
      ideVinculo.CpfTrab   := INIRec.ReadString(sSecao, 'cpfTrab', EmptyStr);
      ideVinculo.NisTrab   := INIRec.ReadString(sSecao, 'nisTrab', EmptyStr);
      ideVinculo.Matricula := INIRec.ReadString(sSecao, 'matricula', EmptyStr);
      ideVinculo.codCateg  := INIRec.ReadInteger(sSecao, 'codCateg', 0);

      sSecao := 'cat';
      cat.dtAcid           := StringToDateTime(INIRec.ReadString(sSecao, 'dtAcid', '0'));
      cat.TpAcid           := INIRec.ReadString(sSecao, 'tpAcid', EmptyStr);
      cat.hrAcid           := INIRec.ReadString(sSecao, 'hrAcid', EmptyStr);
      cat.hrsTrabAntesAcid := INIRec.ReadString(sSecao, 'hrsTrabAntesAcid', EmptyStr);
      cat.tpCat            := eSStrToTpCat(Ok, INIRec.ReadString(sSecao, 'tpCat', '1'));
      cat.indCatObito      := eSStrToSimNao(Ok, INIRec.ReadString(sSecao, 'indCatObito', 'S'));
      cat.dtOBito          := StringToDateTime(INIRec.ReadString(sSecao, 'dtObito', '0'));
      cat.indComunPolicia  := eSStrToSimNao(Ok, INIRec.ReadString(sSecao, 'indComunPolicia', 'S'));
      cat.codSitGeradora   := INIRec.ReadInteger(sSecao, 'codSitGeradora', 0);
      cat.iniciatCAT       := eSStrToIniciatCAT(Ok, INIRec.ReadString(sSecao, 'iniciatCAT', '1'));
      cat.obsCAT           := INIRec.ReadString(sSecao, 'obsCAT', EmptyStr);

      sSecao := 'localAcidente';
      cat.localAcidente.tpLocal     := eSStrToTpLocal(Ok, INIRec.ReadString(sSecao, 'tpLocal', '1'));
      cat.localAcidente.dscLocal    := INIRec.ReadString(sSecao, 'dscLocal', EmptyStr);
      cat.localAcidente.codAmb      := INIRec.ReadString(sSecao, 'codAmb', EmptyStr);
      cat.localAcidente.tpLograd    := INIRec.ReadString(sSecao, 'tpLograd', EmptyStr);
      cat.localAcidente.dscLograd   := INIRec.ReadString(sSecao, 'dscLograd', EmptyStr);
      cat.localAcidente.nrLograd    := INIRec.ReadString(sSecao, 'nrLograd', EmptyStr);
      cat.localAcidente.complemento := INIRec.ReadString(sSecao, 'complemento', EmptyStr);
      cat.localAcidente.bairro      := INIRec.ReadString(sSecao, 'bairro', EmptyStr);
      cat.localAcidente.cep         := INIRec.ReadString(sSecao, 'cep', EmptyStr);
      cat.localAcidente.codMunic    := INIRec.ReadInteger(sSecao, 'codMunic', 0);
      cat.localAcidente.uf          := eSStrTouf(Ok, INIRec.ReadString(sSecao, 'uf', 'SP'));
      cat.localAcidente.pais        := INIRec.ReadString(sSecao, 'pais', EmptyStr);
      cat.localAcidente.codPostal   := INIRec.ReadString(sSecao, 'codPostal', EmptyStr);

      if INIRec.ReadString(sSecao, 'nrInsc', '') <> '' then
      begin
         cat.localAcidente.ideLocalAcid.TpInsc := eSStrToTpInscricao(Ok, INIRec.ReadString(sSecao, 'tpInsc', '1'));
         cat.localAcidente.ideLocalAcid.NrInsc := INIRec.ReadString(sSecao, 'nrInsc', EmptyStr);
      end;      

      I := 1;
      while true do
      begin
        // de 01 at� 99
        sSecao := 'parteAtingida' + IntToStrZero(I, 2);
        sFim   := INIRec.ReadString(sSecao, 'codParteAting', 'FIM');

        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with cat.parteAtingida.New do
        begin
          codParteAting := StrToInt(sFim);
          lateralidade  := eSStrToLateralidade(Ok, INIRec.ReadString(sSecao, 'lateralidade', '1'));
        end;

        Inc(I);
      end;

      I := 1;
      while true do
      begin
        // de 01 at� 99
        sSecao := 'agenteCausador' + IntToStrZero(I, 2);
        sFim   := INIRec.ReadString(sSecao, 'codAgntCausador', 'FIM');

        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with cat.agenteCausador.New do
        begin
          codAgntCausador := StrToInt(sFim);
        end;

        Inc(I);
      end;

      sSecao := 'atestado';
      if INIRec.ReadString(sSecao, 'dtAtendimento', '') <> '' then
      begin
        cat.atestado.codCNES       := INIRec.ReadString(sSecao, 'codCNES', EmptyStr);
        cat.atestado.dtAtendimento := StringToDateTime(INIRec.ReadString(sSecao, 'dtAtendimento', '0'));
        cat.atestado.hrAtendimento := INIRec.ReadString(sSecao, 'hrAtendimento', EmptyStr);
        cat.atestado.indInternacao := eSStrToSimNao(Ok, INIRec.ReadString(sSecao, 'indInternacao', 'S'));
        cat.atestado.durTrat       := INIRec.ReadInteger(sSecao, 'durTrat', 0);
        cat.atestado.indAfast      := eSStrToSimNao(Ok, INIRec.ReadString(sSecao, 'indAfast', 'S'));
        cat.atestado.dscLesao      := INIRec.ReadInteger(sSecao, 'dscLesao', 0);
        cat.atestado.dscCompLesao  := INIRec.ReadString(sSecao, 'dscCompLesao', EmptyStr);
        cat.atestado.diagProvavel  := INIRec.ReadString(sSecao, 'diagProvavel', EmptyStr);
        cat.atestado.codCID        := INIRec.ReadString(sSecao, 'codCID', EmptyStr);
        cat.atestado.observacao    := INIRec.ReadString(sSecao, 'observacao', EmptyStr);

        sSecao := 'emitente';
        cat.atestado.Emitente.nmEmit := INIRec.ReadString(sSecao, 'nmEmit', EmptyStr);
        cat.atestado.Emitente.ideOC  := eSStrToIdeOC(Ok, INIRec.ReadString(sSecao, 'ideOC', '1'));
        cat.atestado.Emitente.nrOc   := INIRec.ReadString(sSecao, 'nrOc', EmptyStr);
        cat.atestado.Emitente.ufOC   := INIRec.ReadString(sSecao, 'ufOC', 'SP');//eSStrTouf(Ok, INIRec.ReadString(sSecao, 'ufOC', 'SP'));
      end;

      sSecao := 'catOrigem';
      if INIRec.ReadString(sSecao, 'nrRecCatOrig', '') <> '' then
      begin
        cat.catOrigem.nrRecCatOrig := INIRec.ReadString(sSecao, 'nrRecCatOrig', '');
      end;
    end;

    GerarXML;
    XML := FXML;
  finally
    INIRec.Free;
  end;
end;

{ TLocalAcidente }

constructor TLocalAcidente.Create;
begin
  inherited;

  FideLocalAcid := TideLocalAcid.Create;
end;

destructor TLocalAcidente.Destroy;
begin
  FideLocalAcid.Free;
  
  inherited;
end;

end.
