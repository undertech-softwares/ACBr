{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Fernando Castelano Banhos                       }
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

unit pnfsNFSeW_AssessorPublico;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ELSE}

{$ENDIF}
  SysUtils, Classes,
  ACBrConsts,
  pnfsNFSeW, pcnAuxiliar, pcnConversao, pcnGerador, pnfsNFSe, pnfsConversao;

type
  { TNFSeW_AssessorPublico }

  TNFSeW_AssesorPublico = class(TNFSeWClass)
  protected
    procedure GerarNotas;
    procedure GerarServicos;
  public
    constructor Create(ANFSeW: TNFSeW); override;

    function ObterNomeArquivo: String; override;
    function GerarXml: Boolean; override;
  end;

implementation

uses
  ACBrUtil;

{==============================================================================}
{ Essa unit tem por finalidade exclusiva de gerar o XML do RPS segundo o       }
{ layout do provedor Assesor Publico.                                          }
{ Sendo assim s� ser� criado uma nova unit para um novo layout.                }
{==============================================================================}

{ TNFSeW_AssesorPublico }

constructor TNFSeW_AssesorPublico.Create(ANFSeW: TNFSeW);
begin
  inherited Create(ANFSeW);
end;

procedure TNFSeW_AssesorPublico.GerarNotas;
begin
  Gerador.wGrupo('NOTA');

  Gerador.wCampo(tcStr, '', 'LOTE', 1, 1, 1, NFSe.NumeroLote, '');
  Gerador.wCampo(tcStr, '', 'SEQUENCIA', 1, 1, 1, NFSe.IdentificacaoRps.Numero, '');
  Gerador.wCampo(tcStr, '', 'DATAEMISSAO', 1, 1, 1, FormatDateTime('dd/MM/yyyy',NFSe.DataEmissao), '');
  Gerador.wCampo(tcHor, '', 'HORAEMISSAO', 1, 1, 1, NFSe.DataEmissao, '');

  if NFSe.Servico.CodigoMunicipio = IntToStr(NFSe.Servico.MunicipioIncidencia) then begin
    Gerador.wCampo(tcStr, '', 'LOCAL', 1, 1, 1, 'D', '');
  end
  else begin
    Gerador.wCampo(tcStr, '', 'LOCAL', 1, 1, 1, 'F', '');
//    Gerador.wCampo(tcStr, '', 'UFFORA', 1, 1, 1, '1', '');
//    Gerador.wCampo(tcStr, '', 'MUNICIPIOFORA', 1, 1, 1, '1', '');
//    Gerador.wCampo(tcStr, '', 'PAISFORA', 1, 1, 1, '1', '');
  end;


// devem ser previamente cadastrados no sistema
  Gerador.wCampo(tcStr, '', 'SITUACAO', 1, 1, 1, NFSe.Situacao, '');

  if NFSe.Servico.Valores.IssRetido = stRetencao then
    Gerador.wCampo(tcStr, '', 'RETIDO', 1, 1, 1, 'S', '')
  else
    Gerador.wCampo(tcStr, '', 'RETIDO', 1, 1, 1, 'N', '');

  Gerador.wCampo(tcStr, '', 'ATIVIDADE', 1, 1, 1, NFSe.Servico.ItemListaServico, '');
  Gerador.wCampo(tcDe2, '', 'ALIQUOTAAPLICADA', 1, 1, 1, NFSe.Servico.Valores.Aliquota, '');
  Gerador.wCampo(tcDe2, '', 'DEDUCAO', 1, 1, 1,  NFSe.Servico.Valores.ValorDeducoes, '');
  Gerador.wCampo(tcDe2, '', 'IMPOSTO', 1, 1, 1, NFSe.Servico.Valores.valorOutrasRetencoes, '');
  Gerador.wCampo(tcDe2, '', 'RETENCAO', 1, 1, 1, NFSe.Servico.Valores.ValorIssRetido, '');
  Gerador.wCampo(tcStr, '', 'OBSERVACAO', 1, 1, 1, NFSe.Servico.Discriminacao, '');
  Gerador.wCampo(tcStr, '', 'CPFCNPJ', 1, 1, 1, NFSe.Tomador.IdentificacaoTomador.CpfCnpj, '');
  Gerador.wCampo(tcStr, '', 'RGIE', 1, 1, 1, NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual, '');
  Gerador.wCampo(tcStr, '', 'NOMERAZAO', 1, 1, 1, NFSe.Tomador.RazaoSocial, '');
  Gerador.wCampo(tcStr, '', 'NOMEFANTASIA', 1, 1, 1, NFSe.Tomador.RazaoSocial, '');
  Gerador.wCampo(tcStr, '', 'MUNICIPIO', 1, 1, 1, NFSe.Tomador.Endereco.CodigoMunicipio, '');
  Gerador.wCampo(tcStr, '', 'BAIRRO', 1, 1, 1, NFSe.Tomador.Endereco.Bairro, '');
  Gerador.wCampo(tcStr, '', 'CEP', 1, 1, 1, NFSe.Tomador.Endereco.CEP, '');
  Gerador.wCampo(tcStr, '', 'PREFIXO', 1, 1, 1, 'RUA', '');
  Gerador.wCampo(tcStr, '', 'LOGRADOURO', 1, 1, 1, NFSe.Tomador.Endereco.Endereco, '');
  Gerador.wCampo(tcStr, '', 'COMPLEMENTO', 1, 1, 1, NFSe.Tomador.Endereco.Complemento, '');
  Gerador.wCampo(tcStr, '', 'NUMERO', 1, 1, 1, NFSe.Tomador.Endereco.Numero, '');
//  Gerador.wCampo(tcStr, '', 'EMAIL', 1, 1, 1, NFSe.Tomador.Contato.Email, '');
  Gerador.wCampo(tcStr, '', 'DENTROPAIS', 1, 1, 1, 'S', '');
  Gerador.wCampo(tcDe2, '', 'PIS', 1, 1, 1,NFSe.Servico.Valores.ValorPis, '');
  Gerador.wCampo(tcDe2, '', 'COFINS', 1, 1, 1, NFSe.Servico.Valores.ValorCofins, '');
  Gerador.wCampo(tcDe2, '', 'INSS', 1, 1, 1, NFSe.Servico.Valores.ValorInss , '');
  Gerador.wCampo(tcDe2, '', 'IR', 1, 1, 1, NFSe.Servico.Valores.ValorIr, '');
  Gerador.wCampo(tcDe2, '', 'CSLL', 1, 1, 1,  NFSe.Servico.Valores.ValorCsll  , '');

  GerarServicos;

  Gerador.wGrupo('/NOTA');
end;

procedure TNFSeW_AssesorPublico.GerarServicos;
var
  i : integer;
begin
  Gerador.wGrupo('SERVICOS');

  for i := 0 to NFSe.Servico.ItemServico.Count - 1 do begin
    Gerador.wGrupo('SERVICO');

    Gerador.wCampo(tcStr, '', 'DESCRICAO', 1, 1, 1, NFSe.Servico.ItemServico.Items[i].Descricao, '');
    Gerador.wCampo(tcDe2, '', 'VALORUNIT', 1, 1, 1, NFSe.Servico.ItemServico.Items[i].ValorUnitario, '');
    Gerador.wCampo(tcDe4, '', 'QUANTIDADE', 1, 1, 1, NFSe.Servico.ItemServico.Items[i].Quantidade, '');
    Gerador.wCampo(tcDe2, '', 'DESCONTO', 1, 1, 1, NFSe.Servico.ItemServico.Items[i].DescontoIncondicionado, '');

    Gerador.wGrupo('/SERVICO');
  end;

  Gerador.wGrupo('/SERVICOS');
end;

function TNFSeW_AssesorPublico.GerarXml: Boolean;
begin
  Gerador.ListaDeAlertas.Clear;

  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo           := FPrefixo4;

  Gerador.Opcoes.QuebraLinha := FQuebradeLinha;

  FDefTipos := FServicoEnviar;

  GerarNotas;

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

function TNFSeW_AssesorPublico.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

end.
