{******************************************************************************}
{ Projeto: Componente ACBrBlocoX                                               }
{ Biblioteca multiplataforma de componentes Delphi para Gera��o de arquivos    }
{ do Bloco X                                                                   }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{******************************************************************************}

{$I ACBr.inc}

unit ACBrBlocoX_Comum;

interface

uses
  Classes, SysUtils, pcnGerador;

type
  EACBrBlocoXException = class(Exception);

  TACBrBlocoX_TipoCodigo = (tpcGTIN, tpcEAN, tpcProprio);
  TACBrBlocoX_SitTributaria = (stIsento, stNaoTributado, stSubstTributaria, stTributado, stISSQN);
  TACBrBlocoX_Ippt = (ipptProprio, ipptTerceiros);

  TACBrBlocoX_Codigo = class
  private
    FTipo: TACBrBlocoX_TipoCodigo;
    FNumero: String;
  public
    property Tipo: TACBrBlocoX_TipoCodigo read FTipo write FTipo;
    property Numero: String read FNumero write FNumero;
  end;

  TACBrBlocoX_Produto = class(TCollectionItem)
  private
    FCodigo: TACBrBlocoX_Codigo;
    FDescricao: String;
    FValorUnitario: Double;
    FIppt: TACBrBlocoX_Ippt;
    FAliquota: Double;
    FUnidade: String;
    FQuantidade: Integer;
    FIndicadorArredondamento: Boolean;
    FSituacaoTributaria: TACBrBlocoX_SitTributaria;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    property Codigo: TACBrBlocoX_Codigo read FCodigo write FCodigo;
    property Descricao: String read FDescricao write FDescricao;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property Unidade: String read FUnidade write FUnidade;
    property ValorUnitario: Double read FValorUnitario write FValorUnitario;
    property SituacaoTributaria: TACBrBlocoX_SitTributaria read FSituacaoTributaria write FSituacaoTributaria;
    property Aliquota: Double read FAliquota write FAliquota;
    property IndicadorArredondamento: Boolean read FIndicadorArredondamento write FIndicadorArredondamento;
    property Ippt: TACBrBlocoX_Ippt read FIppt write FIppt;
  end;

  TACBrBlocoX_Servico = class(TACBrBlocoX_Produto);

  TACBrBlocoX_Produtos = class(TOwnedCollection)
  private
    function GetItem(Index: integer): TACBrBlocoX_Produto;
    procedure SetItem(Index: integer; const Value: TACBrBlocoX_Produto);
  public
    function Add: TACBrBlocoX_Produto;
    function Insert(Index: integer): TACBrBlocoX_Produto;

    property Items[Index: integer]: TACBrBlocoX_Produto read GetItem write SetItem; default;
  end;

  TACBrBlocoX_Servicos = class(TOwnedCollection)
  private
    function GetItem(Index: integer): TACBrBlocoX_Servico;
    procedure SetItem(Index: integer; const Value: TACBrBlocoX_Servico);
  public
    function Add: TACBrBlocoX_Servico;
    function Insert(Index: integer): TACBrBlocoX_Servico;

    property Items[Index: integer]: TACBrBlocoX_Servico read GetItem write SetItem; default;
  end;

  TACBrBlocoX_BaseFile = class(TComponent)
  protected
    FACBrBlocoX: TComponent;
    FGerador: TGerador;
    FXMLOriginal: String;
    FXMLAssinado: String;

    procedure GerarDadosEstabelecimento;
    procedure GerarDadosPafECF;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure GerarXML(const Assinar: Boolean = True); virtual;
    procedure SaveToFile(const AXmlFileName: String); virtual;
  end;

  function TipoCodigoToStr(const AValue: TACBrBlocoX_TipoCodigo): String;
  function SituacaoTributariaToStr(const AValue: TACBrBlocoX_SitTributaria): String;
  function IpptToStr(const AValue: TACBrBlocoX_Ippt): String;

  function StrToTipoCodigo(var OK: Boolean; const AValue: String): TACBrBlocoX_TipoCodigo;
  function StrToSituacaoTributaria(var OK: Boolean; const AValue: String): TACBrBlocoX_SitTributaria;
  function StrToIppt(var OK: Boolean; const AValue: String): TACBrBlocoX_Ippt;

implementation

uses
  ACBrBlocoX, ACBrUtil, StrUtils, pcnConversao;

function TipoCodigoToStr(const AValue: TACBrBlocoX_TipoCodigo): String;
begin
  Result := EnumeradoToStr(AValue,
    ['GTIN', 'EAN', 'Proprio'],
    [tpcGTIN, tpcEAN, tpcProprio]
  );
end;

function SituacaoTributariaToStr(const AValue: TACBrBlocoX_SitTributaria): String;
begin
  Result := EnumeradoToStr(AValue,
    ['I', 'N', 'F', 'T', 'S'],
    [stIsento, stNaoTributado, stSubstTributaria, stTributado, stISSQN]
  );
end;

function IpptToStr(const AValue: TACBrBlocoX_Ippt): String;
begin
  Result := EnumeradoToStr(AValue,
    ['P', 'T'],
    [ipptProprio, ipptTerceiros]
  );
end;

function StrToTipoCodigo(var OK: Boolean; const AValue: String): TACBrBlocoX_TipoCodigo;
begin
  Result := StrToEnumerado(OK, AValue,
    ['GTIN', 'EAN', 'Proprio'],
    [tpcGTIN, tpcEAN, tpcProprio]
  );
end;

function StrToSituacaoTributaria(var OK: Boolean; const AValue: String): TACBrBlocoX_SitTributaria;
begin
  Result := StrToEnumerado(OK, AValue,
    ['I', 'N', 'F', 'T', 'S'],
    [stIsento, stNaoTributado, stSubstTributaria, stTributado, stISSQN]
  );
end;

function StrToIppt(var OK: Boolean; const AValue: String): TACBrBlocoX_Ippt;
begin
  Result := StrToEnumerado(OK, AValue,
    ['P', 'T'],
    [ipptProprio, ipptTerceiros]
  );
end;

{ TACBrBlocoX_Produto }

constructor TACBrBlocoX_Produto.Create(Collection: TCollection);
begin
  inherited;
  FCodigo := TACBrBlocoX_Codigo.Create;
end;

destructor TACBrBlocoX_Produto.Destroy;
begin
  FCodigo.Free;
  inherited;
end;

{ TACBrBlocoX_Produtos }

function TACBrBlocoX_Produtos.Add: TACBrBlocoX_Produto;
begin
  Result := TACBrBlocoX_Produto(inherited Add);
end;

function TACBrBlocoX_Produtos.GetItem(Index: integer): TACBrBlocoX_Produto;
begin
  Result := TACBrBlocoX_Produto(inherited Items[Index]);
end;

function TACBrBlocoX_Produtos.Insert(Index: integer): TACBrBlocoX_Produto;
begin
  Result := TACBrBlocoX_Produto(inherited Insert(Index));
end;

procedure TACBrBlocoX_Produtos.SetItem(Index: integer;
  const Value: TACBrBlocoX_Produto);
begin
  Items[Index].Assign(Value);
end;

{ TACBrBlocoX_Servicos }

function TACBrBlocoX_Servicos.Add: TACBrBlocoX_Servico;
begin
  Result := TACBrBlocoX_Servico(inherited Add);
end;

function TACBrBlocoX_Servicos.GetItem(Index: integer): TACBrBlocoX_Servico;
begin
  Result := TACBrBlocoX_Servico(inherited Items[Index]);
end;

function TACBrBlocoX_Servicos.Insert(Index: integer): TACBrBlocoX_Servico;
begin
  Result := TACBrBlocoX_Servico(inherited Insert(Index));
end;

procedure TACBrBlocoX_Servicos.SetItem(Index: integer;
  const Value: TACBrBlocoX_Servico);
begin
  Items[Index].Assign(Value);
end;

{ TACBrBlocoX_BaseFile }

constructor TACBrBlocoX_BaseFile.Create(AOwner: TComponent);
begin
  inherited;

  FACBrBlocoX := TACBrBlocoX(AOwner);
  FGerador := TGerador.Create;
end;

destructor TACBrBlocoX_BaseFile.Destroy;
begin
  FGerador.Free;
  inherited;
end;

procedure TACBrBlocoX_BaseFile.GerarXML(const Assinar: Boolean = True);
begin
  raise EACBrBlocoXException.Create('M�todo n�o implementado "GerarXML"');
end;

procedure TACBrBlocoX_BaseFile.SaveToFile(const AXmlFileName: String);
begin
  raise EACBrBlocoXException.Create('M�todo n�o implementado "SaveToFileName"');
end;

procedure TACBrBlocoX_BaseFile.GerarDadosEstabelecimento;
begin
  FGerador.wGrupo('Estabelecimento');
  with TACBrBlocoX(FACBrBlocoX) do
  begin
    FGerador.wCampo(tcStr, '', 'Ie', 0, 0, 1, Estabelecimento.Ie);
    FGerador.wCampo(tcStr, '', 'Cnpj', 14, 14, 1, OnlyNumber(Estabelecimento.Cnpj));
    FGerador.wCampo(tcStr, '', 'NomeEmpresarial', 0, 0, 1, Estabelecimento.NomeEmpresarial);
  end;
  FGerador.wGrupo('/Estabelecimento');
end;

procedure TACBrBlocoX_BaseFile.GerarDadosPafECF;
begin
  FGerador.wGrupo('PafEcf');
  with TACBrBlocoX(FACBrBlocoX) do
  begin
    FGerador.wCampo(tcStr, '', 'NumeroCredenciamento', 0, 0, 1, PafECF.NumeroCredenciamento);
    FGerador.wCampo(tcStr, '', 'NomeComercial', 0, 0, 1, PafECF.NomeComercial);
    FGerador.wCampo(tcStr, '', 'Versao', 1, 20, 1, PafECF.Versao);
    FGerador.wCampo(tcStr, '', 'CnpjDesenvolvedor', 14, 14, 1, OnlyNumber(PafECF.CnpjDesenvolvedor));
    FGerador.wCampo(tcStr, '', 'NomeEmpresarialDesenvolvedor', 0, 0, 1, PafECF.NomeEmpresarialDesenvolvedor);
  end;
  FGerador.wGrupo('/PafEcf');
end;

end.
