{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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

{$I ACBr.inc}

unit pnfsNFSeW_Elotech;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ELSE}

{$ENDIF}
  SysUtils, Classes, StrUtils,
  synacode, ACBrConsts,
  pcnAuxiliar, pcnConversao, pcnGerador, pcnConsts,
  pnfsNFSeW, pnfsNFSe, pnfsConversao, pnfsConsts;

type
  { TNFSeW_Elotech }

  TNFSeW_Elotech = class(TNFSeWClass)
  private
    FSituacao: String;
    FTipoRecolhimento: String;
  protected
    procedure GerarIdentificacaoRequerente;
    procedure GerarLoteRps;
    procedure GerarListaRps;
    procedure GerarDeclaracaoPrestacaoServico;
    procedure GerarInfDeclaracaoPrestacaoServico;
    procedure GerarRps;
    procedure GerarIdentificacaoRPS;
    procedure GerarServico;
    procedure GerarValores;
    procedure GerarListaItensServico;
    procedure GerarDadosPrestador;
    procedure GerarIdentificacaoPrestador;
    procedure GerarDadosPrestadorEndereco;
    procedure GerarDadosPrestadorContato;

    procedure GerarTomador;
    procedure GerarIdentificacaoTomador;
    procedure GerarEnderecoTomador;
    procedure GerarContatoTomador;

    procedure GerarXML_Elotech;

  public
    Homologacao : Boolean;
    constructor Create(ANFSeW: TNFSeW); override;

    function ObterNomeArquivo: String; override;
    function GerarXml: Boolean; override;

    property Situacao: String         read FSituacao;
    property TipoRecolhimento: String read FTipoRecolhimento;
  end;

implementation

uses
  ACBrUtil;

{==============================================================================}
{ Essa unit tem por finalidade exclusiva de gerar o XML do RPS segundo o       }
{ layout da Elotech.                                                           }
{ Sendo assim s� ser� criado uma nova unit para um novo layout.                }
{==============================================================================}

{ TNFSeW_Elotech }

procedure TNFSeW_Elotech.GerarIdentificacaoRequerente;
begin
  Gerador.wGrupo('IdentificacaoRequerente');

  Gerador.wGrupo('CpfCnpj');
  if length(OnlyNumber(NFSe.Prestador.Cnpj)) <= 11 then
    Gerador.wCampo(tcStr, '#34', 'Cpf ', 11, 11, 1, OnlyNumber(NFSe.Prestador.Cnpj), DSC_CPF)
  else
    Gerador.wCampo(tcStr, '#34', 'Cnpj', 14, 14, 1, OnlyNumber(NFSe.Prestador.Cnpj), DSC_CNPJ);
  Gerador.wGrupo('/CpfCnpj');

  Gerador.wCampo(tcStr, '', 'InscricaoMunicipal', 0, 20, 0, NFSe.Prestador.InscricaoMunicipal);
  Gerador.wCampo(tcStr, '', 'Senha', 6, 30, 1, NFSe.Prestador.Senha);

  if NFSe.Producao = snNao then
    Gerador.wCampo(tcStr, '', 'Homologa', 1, 1, 1, '1')
  else
    Gerador.wCampo(tcStr, '', 'Homologa', 1, 1, 1, '0');

  Gerador.wGrupo('/IdentificacaoRequerente');
end;

procedure TNFSeW_Elotech.GerarLoteRps;
begin
  Gerador.wGrupo('LoteRps');
  Gerador.wCampo(tcStr, '', 'NumeroLote', 1, 15, 1, NFSe.IdentificacaoRps.Numero);
  Gerador.wCampo(tcStr, '', 'QuantidadeRps', 1, 4, 1, '1');
  GerarListaRps;
  Gerador.wGrupo('/LoteRps');
end;

procedure TNFSeW_Elotech.GerarListaRps;
begin
  Gerador.wGrupo('ListaRps');
  GerarDeclaracaoPrestacaoServico;
  Gerador.wGrupo('/ListaRps');
end;

procedure TNFSeW_Elotech.GerarDeclaracaoPrestacaoServico;
begin
  Gerador.wGrupo('DeclaracaoPrestacaoServico');
  GerarInfDeclaracaoPrestacaoServico;
  Gerador.wGrupo('/DeclaracaoPrestacaoServico');
end;

procedure TNFSeW_Elotech.GerarInfDeclaracaoPrestacaoServico;
begin
  Gerador.wGrupo('InfDeclaracaoPrestacaoServico');
  GerarRps;
  Gerador.wCampo(tcStr, '', 'Competencia', 10, 10, 1, FormatDateTimeBr(NFSe.DataEmissaoRps, 'yyyy-mm-dd'), DSC_DEMI);
  GerarServico;
  GerarDadosPrestador;
  GerarTomador;
  Gerador.wCampo(tcStr, '', 'RegimeEspecialTributacao', 1, 1, 0, RegimeEspecialTributacaoToStr(NFSe.RegimeEspecialTributacao));
  Gerador.wCampo(tcStr, '', 'IncentivoFiscal', 1, 1, 1, '2'); //1 - Sim / 2 � N�o
  Gerador.wGrupo('/InfDeclaracaoPrestacaoServico');
end;

procedure TNFSeW_Elotech.GerarRps;
begin
  Gerador.wGrupo('Rps');
  GerarIdentificacaoRps;
  Gerador.wCampo(tcStr, '', 'Status', 1, 1, 1, '1'); //C�digo de status do RPS (1 � Normal / 2 � Cancelado)
  Gerador.wCampo(tcStr, '', 'DataEmissao', 1, 10, 1, FormatDateTimeBr(NFSe.DataEmissaoRps, 'yyyy-mm-dd'), DSC_DEMI);
  Gerador.wGrupo('/Rps');
end;

procedure TNFSeW_Elotech.GerarIdentificacaoRPS;
begin
  Gerador.wGrupo('IdentificacaoRps');
  Gerador.wCampo(tcStr, '', 'Numero', 1, 15, 1, NFSe.IdentificacaoRps.Numero);
  Gerador.wCampo(tcStr, '', 'Serie', 1, 5, 1, NFSe.IdentificacaoRps.Serie);
  Gerador.wCampo(tcStr, '', 'Tipo', 1, 1, 1, '1'); // 1 - RPS / 2 � Nota Fiscal Conjugada(Mista) / 3 � Cupom / 4 � Nota Fiscal S�rie �nica
  Gerador.wGrupo('/IdentificacaoRps');
end;

procedure TNFSeW_Elotech.GerarServico;
begin
  Gerador.wGrupo('Servico');
  GerarValores;

  if NFSe.Servico.Valores.ValorIssRetido > 0 then
    Gerador.wCampo(tcStr, '', 'IssRetido', 1, 1, 1, '1') //1 - Sim
  else
    Gerador.wCampo(tcStr, '', 'IssRetido', 1, 1, 1, '2'); //2 - N�o

  Gerador.wCampo(tcStr, '', 'Discriminacao', 1, 2000, 0, NFSe.Servico.Discriminacao);
  Gerador.wCampo(tcStr, '', 'CodigoMunicipio', 0, 7, 0, NFSe.Servico.CodigoMunicipio);

  //1 � Exig�vel / 2 � N�o incid�ncia / 3 � Isen��o / 4 � Exporta��o / 5 � Imunidade
  //6 � Exigibilidade Suspensa por Decis�o Judicial / 7 � Exigibilidade Suspensa por Processo Administrativo
  Gerador.wCampo(tcStr, '', 'ExigibilidadeISS', 1, 1, 1, '1');

  Gerador.wCampo(tcStr, '', 'MunicipioIncidencia', 0, 7, 0, NFSe.Servico.MunicipioIncidencia);
  GerarListaItensServico;
  Gerador.wGrupo('/Servico');
end;

procedure TNFSeW_Elotech.GerarValores;
begin
  Gerador.wGrupo('Valores');
  Gerador.wCampo(tcDe2, '', 'ValorServicos', 1, 17, 1, NFSe.Servico.Valores.ValorServicos);
  Gerador.wCampo(tcDe2, '', 'Aliquota', 0, 6, 0, NFSe.Servico.Valores.Aliquota);
  Gerador.wCampo(tcDe2, '', 'DescontoIncondicionado', 0, 17, 0, NFSe.Servico.Valores.DescontoIncondicionado);
  Gerador.wGrupo('/Valores');
end;

procedure TNFSeW_Elotech.GerarListaItensServico;
var
  i: Integer;
begin
  Gerador.wGrupo('ListaItensServico');

  for I := 0 to NFSe.Servico.ItemServico.Count - 1 do
  begin
    Gerador.wGrupo('ItemServico');
    Gerador.wCampo(tcStr, '', 'ItemListaServico', 1, 6, 1, NFSe.Servico.ItemServico[i].ItemListaServico);
    Gerador.wCampo(tcStr, '', 'CodigoCnae', 1, 7, 0, NFSe.Servico.CodigoCnae);
    Gerador.wCampo(tcStr, '', 'Descricao', 1, 20, 0, NFSe.Servico.ItemServico[i].Descricao);
    Gerador.wCampo(tcStr, '', 'Tributavel', 1, 1, 0, SimNaoToStr(NFSe.Servico.ItemServico[i].Tributavel));
    Gerador.wCampo(tcDe2, '', 'Quantidade', 0, 17, 0, NFSe.Servico.ItemServico[i].Quantidade);
    Gerador.wCampo(tcDe2, '', 'ValorUnitario', 0, 17, 0, NFSe.Servico.ItemServico[i].ValorUnitario);
    Gerador.wCampo(tcDe2, '', 'ValorDesconto', 0, 17, 1, NFSe.Servico.ItemServico[i].DescontoCondicionado);
    Gerador.wCampo(tcDe2, '', 'ValorLiquido', 0, 17, 1, NFSe.Servico.ItemServico[i].ValorTotal);
    Gerador.wGrupo('/ItemServico');
  end;
  Gerador.wGrupo('/ListaItensServico');
end;

procedure TNFSeW_Elotech.GerarDadosPrestador;
begin
  Gerador.wGrupo('DadosPrestador');
  GerarIdentificacaoPrestador;
  Gerador.wCampo(tcStr, '', 'RazaoSocial', 1, 150, 1, NFSe.Prestador.RazaoSocial);
  Gerador.wCampo(tcStr, '', 'NomeFantasia', 1, 60, 0, NFSe.Prestador.Fantasia);
  GerarDadosPrestadorEndereco;
  GerarDadosPrestadorContato;
  Gerador.wGrupo('/DadosPrestador');
end;

procedure TNFSeW_Elotech.GerarIdentificacaoPrestador;
begin
  Gerador.wGrupo('IdentificacaoPrestador');

  Gerador.wGrupo('CpfCnpj');
  if length(OnlyNumber(NFSe.Prestador.Cnpj)) <= 11 then
    Gerador.wCampo(tcStr, '#34', 'Cpf ', 11, 11, 1, OnlyNumber(NFSe.Prestador.Cnpj), DSC_CPF)
  else
    Gerador.wCampo(tcStr, '#34', 'Cnpj', 14, 14, 1, OnlyNumber(NFSe.Prestador.Cnpj), DSC_CNPJ);
  Gerador.wGrupo('/CpfCnpj');

  Gerador.wCampo(tcStr, '', 'InscricaoMunicipal', 0, 20, 0, NFSe.Prestador.InscricaoMunicipal);
  Gerador.wGrupo('/IdentificacaoPrestador');
end;

procedure TNFSeW_Elotech.GerarDadosPrestadorEndereco;
begin
  Gerador.wGrupo('Endereco');
  Gerador.wCampo(tcStr, '', 'Endereco', 1, 125, 0, NFSe.Prestador.Endereco.Endereco);
  Gerador.wCampo(tcStr, '', 'Numero', 1, 10, 0, NFSe.Prestador.Endereco.Numero);
  Gerador.wCampo(tcStr, '', 'Complemento', 1, 60, 0, NFSe.Prestador.Endereco.Complemento);
  Gerador.wCampo(tcStr, '', 'Bairro', 1, 60, 0, NFSe.Prestador.Endereco.Bairro);
  Gerador.wCampo(tcStr, '', 'CodigoMunicipio', 0, 7, 0, NFSe.Prestador.Endereco.CodigoMunicipio);
  Gerador.wCampo(tcStr, '', 'CidadeNome', 1, 125, 0, NFSe.Prestador.Endereco.xMunicipio);
  Gerador.wCampo(tcStr, '', 'Uf', 1, 2, 0, NFSe.Prestador.Endereco.UF);
  Gerador.wCampo(tcStr, '', 'CodigoPais', 1, 4, 0, NFSe.Prestador.Endereco.CodigoPais);
  Gerador.wCampo(tcStr, '', 'Cep', 0, 8, 0, OnlyNumber(NFSe.Prestador.Endereco.CEP));
  Gerador.wGrupo('/Endereco');
end;

procedure TNFSeW_Elotech.GerarDadosPrestadorContato;
begin
  Gerador.wGrupo('Contato');
  Gerador.wCampo(tcStr, '', 'Telefone', 1, 20, 0, OnlyNumber(NFSe.Prestador.Telefone));
  Gerador.wCampo(tcStr, '', 'Email', 1, 80, 0, NFSe.Prestador.Email);
  Gerador.wGrupo('/Contato');
end;

procedure TNFSeW_Elotech.GerarTomador;
begin
  Gerador.wGrupo('Tomador');
  GerarIdentificacaoTomador;
  Gerador.wCampo(tcStr, '', 'RazaoSocial', 1, 150, 0, NFSe.Tomador.RazaoSocial);
  GerarEnderecoTomador;
  GerarContatoTomador;
  Gerador.wGrupo('/Tomador');
end;

procedure TNFSeW_Elotech.GerarIdentificacaoTomador;
begin
  Gerador.wGrupo('IdentificacaoTomador');

  Gerador.wGrupo('CpfCnpj');
  if length(OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj)) <= 11 then
    Gerador.wCampo(tcStr, '#34', 'Cpf ', 11, 11, 1, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), DSC_CPF)
  else
    Gerador.wCampo(tcStr, '#34', 'Cnpj', 14, 14, 1, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), DSC_CNPJ);
  Gerador.wGrupo('/CpfCnpj');

  Gerador.wCampo(tcStr, '', 'InscricaoMunicipal', 1, 10, 0, NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal);
  Gerador.wGrupo('/IdentificacaoTomador');
end;

procedure TNFSeW_Elotech.GerarEnderecoTomador;
begin
  Gerador.wGrupo('Endereco');
  Gerador.wCampo(tcStr, '', 'Endereco', 1, 125, 0, NFSe.Tomador.Endereco.Endereco);
  Gerador.wCampo(tcStr, '', 'Numero', 1, 10, 0, NFSe.Tomador.Endereco.Numero);
  Gerador.wCampo(tcStr, '', 'Bairro', 1, 60, 0, NFSe.Tomador.Endereco.Bairro);
  Gerador.wCampo(tcStr, '', 'CodigoMunicipio', 0, 7, 0, NFSe.Tomador.Endereco.CodigoMunicipio);
  Gerador.wCampo(tcStr, '', 'CidadeNome', 1, 125, 0, NFSe.Tomador.Endereco.xMunicipio);
  Gerador.wCampo(tcStr, '', 'Uf', 1, 2, 0, NFSe.Tomador.Endereco.UF);
  Gerador.wCampo(tcStr, '', 'Cep', 0, 8, 0, OnlyNumber(NFSe.Tomador.Endereco.CEP));
  Gerador.wGrupo('/Endereco');
end;

procedure TNFSeW_Elotech.GerarContatoTomador;
begin
  Gerador.wGrupo('Contato');
  Gerador.wCampo(tcStr, '', 'Telefone', 1, 20, 0, NFSe.Tomador.Contato.Telefone);
  Gerador.wCampo(tcStr, '', 'Email', 1, 80, 0, NFSe.Tomador.Contato.Email);
  Gerador.wGrupo('/Contato');
  Gerador.wCampo(tcStr, '', 'InscricaoEstadual', 1, 20, 0, NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual);
end;

procedure TNFSeW_Elotech.GerarXML_Elotech;
begin
  Gerador.Opcoes.DecimalChar := '.';

  Gerador.Prefixo := '';

  Gerador.wGrupo('EnviarLoteRpsSincronoEnvio');
  GerarIdentificacaoRequerente;
  GerarLoteRps;
  Gerador.wGrupo('/EnviarLoteRpsSincronoEnvio');
end;

constructor TNFSeW_Elotech.Create(ANFSeW: TNFSeW);
begin
  Homologacao := False;
  inherited Create(ANFSeW);
end;

function TNFSeW_Elotech.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

function TNFSeW_Elotech.GerarXml: Boolean;
begin
  Gerador.ListaDeAlertas.Clear;

  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo           := FPrefixo4;

  Gerador.Opcoes.QuebraLinha := FQuebradeLinha;

  FDefTipos := FServicoEnviar;

  if (RightStr(FURL, 1) <> '/') and (FDefTipos <> '')
    then FDefTipos := '/' + FDefTipos;

  if Trim(FPrefixo4) <> ''
    then Atributo := ' xmlns:' + StringReplace(Prefixo4, ':', '', []) + '="' + FURL + FDefTipos + '"'
    else Atributo := ' xmlns="' + FURL + FDefTipos + '"';

  FNFSe.InfID.ID := FNFSe.IdentificacaoRps.Numero;

  GerarXML_Elotech;

  Gerador.gtAjustarRegistros(NFSe.InfID.ID);
  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.
