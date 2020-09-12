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

unit pnfsNFSeW_CONAM;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ELSE}

{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrConsts,
  pnfsNFSeW, pcnAuxiliar, pcnConversao, pcnGerador,
  pnfsNFSe, pnfsConversao, pnfsConsts;

type
  { TNFSeW_CONAM }

  TNFSeW_CONAM = class(TNFSeWClass)
  private
    FQtdReg30: Integer;
    FValReg30: Real;
  protected
    procedure GerarListaServicos;
    procedure GeraTributos;
    procedure GerarValoresServico;
    procedure GerarXML_CONAM;
  public
    constructor Create(ANFSeW: TNFSeW); override;
    function ObterNomeArquivo: String; override;
    function GerarXml: Boolean; override;

    property QtdReg30: Integer read FQtdReg30 write FQtdReg30;
    property ValReg30: Real read FValReg30 write FValReg30;
  end;

implementation

uses
  ACBrUtil;

{==============================================================================}
{ Essa unit tem por finalidade exclusiva de gerar o XML do RPS segundo o       }
{ layout do CONAM.                                                             }
{ Sendo assim s� ser� criado uma nova unit para um novo layout.                }
{==============================================================================}

{ TNFSeW_CONAM }

constructor TNFSeW_CONAM.Create(ANFSeW: TNFSeW);
begin
  inherited Create(ANFSeW);
end;

function TNFSeW_CONAM.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

procedure TNFSeW_CONAM.GerarListaServicos;
var
  i: Integer;
  CpfCnpj: String;
  MunTomador: String;
  MunPrestador: String;
begin
  Gerador.wGrupo('Reg20Item');

  if FNFSe.IdentificacaoRps.Tipo = trRPS then
    Gerador.wCampo(tcStr, '', 'TipoNFS', 01, 3, 1, 'RPS' , '')
  else
    Gerador.wCampo(tcStr, '', 'TipoNFS', 01, 3, 1, 'RPC' , '');

  Gerador.wCampo(tcStr, '', 'NumRps', 01, 9, 1, FNFSe.IdentificacaoRps.Numero , DSC_NUMRPS);

  if NFSe.IdentificacaoRps.Serie = '' then
    Gerador.wCampo(tcStr, '', 'SerRps', 01, 03, 1, '001', DSC_SERIERPS)
  else
    Gerador.wCampo(tcStr, '', 'SerRps', 01, 03, 1, NFSe.IdentificacaoRps.Serie, DSC_SERIERPS);

  Gerador.wCampo(tcStr, '', 'DtEmi', 01, 10, 1, FormatDateTime('dd/mm/yyyy',NFse.DataEmissaoRps), '');

  if NFSe.Servico.Valores.IssRetido = stNormal then
    Gerador.wCampo(tcStr, '', 'RetFonte', 01, 03, 1, 'NAO', '')
  else
    Gerador.wCampo(tcStr, '', 'RetFonte', 01, 03, 1, 'SIM', '');

  Gerador.wCampo(tcStr, '', 'CodSrv'   , 01,   05, 1, NFSe.Servico.ItemListaServico, '');
  Gerador.wCampo(tcStr, '', 'DiscrSrv' , 01, 4000, 1, StringReplace( NFSe.Servico.Discriminacao, ';', FQuebradeLinha, [rfReplaceAll, rfIgnoreCase] ), '');
  Gerador.wCampo(tcDe2, '', 'VlNFS'    , 01,   16, 2, NFSe.Servico.Valores.ValorServicos, '');
  Gerador.wCampo(tcDe2, '', 'VlDed'    , 01,   16, 2, NFSe.Servico.Valores.ValorDeducoes, '');
  Gerador.wCampo(tcStr, '', 'DiscrDed' , 01, 4000, 1,StringReplace( NFSe.Servico.Valores.JustificativaDeducao, ';', FQuebradeLinha, [rfReplaceAll, rfIgnoreCase] ), '');
  Gerador.wCampo(tcDe2, '', 'VlBasCalc', 01,   16, 2, NFSe.Servico.Valores.BaseCalculo, '');
  Gerador.wCampo(tcDe2, '', 'AlqIss'   , 01,   05, 2, NFSe.Servico.Valores.Aliquota, '');
  Gerador.wCampo(tcDe2, '', 'VlIss'    , 01,   16, 2, NFSe.Servico.Valores.ValorIss, '');
  Gerador.wCampo(tcDe2, '', 'VlIssRet' , 01,   16, 2, NFSe.Servico.Valores.ValorIssRetido, '');

  CpfCnpj := UpperCase(StringReplace(StringReplace(StringReplace(NFSe.Tomador.IdentificacaoTomador.CpfCnpj, '.', '', [rfReplaceAll]), '-', '', [rfReplaceAll]), '/', '', [rfReplaceAll]));

  {Todo: por : almp1
    Se hover municipios com apostofro deve ser substituido por espa�o,
    por exemplo SANTA BARBARA D'OESTE
    deve informar SANTA BARBARA D OESTE
  }
  MunPrestador:= UpperCase(StringReplace(NFSe.PrestadorServico.Endereco.xMunicipio, '''', ' ', [rfReplaceAll]));
  MunTomador:= UpperCase(StringReplace(NFSe.Tomador.Endereco.xMunicipio, '''', ' ', [rfReplaceAll]));

  Gerador.wCampo(tcStr, '', 'CpfCnpTom'  , 01, 14, 1, CpfCnpj, '');
  Gerador.wCampo(tcStr, '', 'RazSocTom'  , 01, 60, 1, NFSe.Tomador.RazaoSocial, '');
  Gerador.wCampo(tcStr, '', 'TipoLogtom' , 01, 10, 1, NFSe.Tomador.Endereco.TipoLogradouro, '');
  Gerador.wCampo(tcStr, '', 'LogTom'     , 01, 60, 1, NFSe.Tomador.Endereco.Endereco, '');
  Gerador.wCampo(tcStr, '', 'NumEndTom'  , 01, 10, 1, NFSe.Tomador.Endereco.Numero, '');
  Gerador.wCampo(tcStr, '', 'ComplEndTom', 01, 60, 0, NFSe.Tomador.Endereco.Complemento, '');
  Gerador.wCampo(tcStr, '', 'BairroTom'  , 01, 60, 1, NFSe.Tomador.Endereco.Bairro, '');

  if CpfCnpj='CONSUMIDOR'  then
   begin
    Gerador.wCampo(tcStr, '', 'MunTom'    , 01, 60, 1, MunPrestador, '');
    Gerador.wCampo(tcStr, '', 'SiglaUFTom', 01, 02, 1, NFSe.PrestadorServico.Endereco.UF, '');
   end
  else
   begin
    Gerador.wCampo(tcStr, '', 'MunTom'    , 01, 60, 1, MunTomador, '');
    Gerador.wCampo(tcStr, '', 'SiglaUFTom', 01, 02, 1, NFSe.Tomador.Endereco.UF, '');
   end;

  Gerador.wCampo(tcStr, '', 'CepTom'            , 01, 08, 1, OnlyNumber(NFSe.Tomador.Endereco.CEP), '');
  Gerador.wCampo(tcStr, '', 'Telefone'          , 00, 10, 1, RightStr(OnlyNumber(NFSe.Tomador.Contato.Telefone),8), '');
  Gerador.wCampo(tcStr, '', 'InscricaoMunicipal', 01, 20, 1, NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, '');

  {Todo: por : mauroasl
   Se o local que for prestado o servi�o for no endere�o do tomador, ent�o preencher com os dados do tomador,
  caso contratio, preencher com os dados do prestador do servi�o.
  Exemplo pratico � um estacionamento, quando � solicitado uma nfse de servi�o. Servi�o prestado no prestador.
  }

  Gerador.wCampo(tcStr, '', 'TipoLogLocPre' , 01, 10, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.TipoLogradouro, NFSe.PrestadorServico.Endereco.TipoLogradouro), '');
  Gerador.wCampo(tcStr, '', 'LogLocPre'     , 01, 60, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.Endereco, NFSe.PrestadorServico.Endereco.Endereco), '');
  Gerador.wCampo(tcStr, '', 'NumEndLocPre'  , 01, 10, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.Numero, NFSe.PrestadorServico.Endereco.Numero), '');
  Gerador.wCampo(tcStr, '', 'ComplEndLocPre', 01, 60, 0, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.Complemento, NFSe.PrestadorServico.Endereco.Complemento), '');
  Gerador.wCampo(tcStr, '', 'BairroLocPre'  , 01, 60, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.Bairro, NFSe.PrestadorServico.Endereco.Bairro), '');
  Gerador.wCampo(tcStr, '', 'MunLocPre'     , 01, 60, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, MunTomador, MunPrestador), '');
  Gerador.wCampo(tcStr, '', 'SiglaUFLocpre' , 01, 02, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, NFSe.Tomador.Endereco.UF, NFSe.PrestadorServico.Endereco.UF), '');
  Gerador.wCampo(tcStr, '', 'CepLocPre'     , 01, 08, 1, IfThen(NFSe.LogradouLocalPrestacaoServico = llpTomador, OnlyNumber(NFSe.Tomador.Endereco.CEP), OnlyNumber(NFSe.PrestadorServico.Endereco.CEP)), '');

  Gerador.wCampo(tcStr, '', 'Email1', 01, 120, 1, NFSe.Tomador.Contato.Email, '');

  for i:= 0 to NFSe.email.Count - 1 do
    Gerador.wCampo(tcStr, '', 'Email' + IntToStr(i+2), 01, 120,  1, NFSe.email.Items[i].emailCC, '');

  {Todo: por : almp1
    caso tenham tributos, estes podem ser declarados no registro 30 do XML
    assim eles serao destacados de forma separada na impressao da NFse
  }
  //So gera se houver tributos declarados
  if (NFSe.Servico.Valores.AliquotaPis > 0) or
     (NFSe.Servico.Valores.AliquotaCofins > 0) or
     (NFSe.Servico.Valores.AliquotaCsll > 0) or
     (NFSe.Servico.Valores.AliquotaInss > 0) or
     (NFSe.Servico.Valores.AliquotaIr > 0) then
     GeraTributos;

  Gerador.wGrupo('/Reg20Item');
end;

procedure TNFSeW_CONAM.GeraTributos;
begin
  (*
  Cont�m os tributos municipais, Estaduais e Federais que devem ser
  destacados na nota fiscal eletr�nica impressa.
  Siglas de tributos permitidas:
  COFINS
  CSLL
  INSS
  IR
  PIS
*)
  QtdReg30:=0;
  ValReg30:=0;
  Gerador.wGrupo('Reg30');

  if NFSe.Servico.Valores.AliquotaPis > 0 then
    begin
      Gerador.wGrupo('Reg30Item');
      Gerador.wCampo(tcStr, '', 'TributoSigla'   , 01,  06, 1, 'PIS', '');
      Gerador.wCampo(tcDe2, '', 'TributoAliquota', 01,  05, 2, NFSe.Servico.Valores.AliquotaPis, '');
      Gerador.wCampo(tcDe2, '', 'TributoValor'   , 01,  16, 2, NFSe.Servico.Valores.ValorPis, '');
      Gerador.wGrupo('/Reg30Item');
      QtdReg30:=QtdReg30+1;
      ValReg30:=ValReg30+NFSe.Servico.Valores.ValorPis;
    end;

  if NFSe.Servico.Valores.AliquotaCofins > 0 then
    begin
      Gerador.wGrupo('Reg30Item');
      Gerador.wCampo(tcStr, '', 'TributoSigla'   , 01,  06, 1, 'COFINS', '');
      Gerador.wCampo(tcDe2, '', 'TributoAliquota', 01,  05, 2, NFSe.Servico.Valores.AliquotaCofins, '');
      Gerador.wCampo(tcDe2, '', 'TributoValor'   , 01,  16, 2, NFSe.Servico.Valores.ValorCofins, '');
      Gerador.wGrupo('/Reg30Item');
      QtdReg30:=QtdReg30+1;
      ValReg30:=ValReg30+NFSe.Servico.Valores.ValorCofins;
    end;

  if NFSe.Servico.Valores.AliquotaCsll > 0 then
    begin
      Gerador.wGrupo('Reg30Item');
      Gerador.wCampo(tcStr, '', 'TributoSigla'   , 01,  06, 1, 'CSLL', '');
      Gerador.wCampo(tcDe2, '', 'TributoAliquota', 01,  05, 2, NFSe.Servico.Valores.AliquotaCsll, '');
      Gerador.wCampo(tcDe2, '', 'TributoValor'   , 01,  16, 2, NFSe.Servico.Valores.ValorCsll, '');
      Gerador.wGrupo('/Reg30Item');
      QtdReg30:=QtdReg30+1;
      ValReg30:=ValReg30+NFSe.Servico.Valores.ValorCsll;
    end;

  if NFSe.Servico.Valores.AliquotaInss > 0 then
    begin
      Gerador.wGrupo('Reg30Item');
      Gerador.wCampo(tcStr, '', 'TributoSigla'   , 01,  06, 1, 'INSS', '');
      Gerador.wCampo(tcDe2, '', 'TributoAliquota', 01,  05, 2, NFSe.Servico.Valores.AliquotaInss, '');
      Gerador.wCampo(tcDe2, '', 'TributoValor'   , 01,  16, 2, NFSe.Servico.Valores.ValorInss, '');
      Gerador.wGrupo('/Reg30Item');
      QtdReg30:=QtdReg30+1;
      ValReg30:=ValReg30+NFSe.Servico.Valores.ValorInss;
    end;

  if NFSe.Servico.Valores.AliquotaIr > 0 then
    begin
      Gerador.wGrupo('Reg30Item');
      Gerador.wCampo(tcStr, '', 'TributoSigla'   , 01,  06, 1, 'IR', '');
      Gerador.wCampo(tcDe2, '', 'TributoAliquota', 01,  05, 2, NFSe.Servico.Valores.AliquotaIr, '');
      Gerador.wCampo(tcDe2, '', 'TributoValor'   , 01,  16, 2, NFSe.Servico.Valores.ValorIr, '');
      Gerador.wGrupo('/Reg30Item');
      QtdReg30:=QtdReg30+1;
      ValReg30:=ValReg30+NFSe.Servico.Valores.ValorIr;
    end;

  Gerador.wGrupo('/Reg30');
end;

procedure TNFSeW_CONAM.GerarValoresServico;
begin
  Gerador.wGrupo('Reg90');

  Gerador.wCampo(tcStr, '', 'QtdRegNormal'  , 01, 05, 1, '1', '');
  Gerador.wCampo(tcDe2, '', 'ValorNFS'      , 01, 16, 2, NFSe.Servico.Valores.ValorServicos, '');
  Gerador.wCampo(tcDe2, '', 'ValorISS'      , 01, 16, 2, NFSe.Servico.Valores.ValorIss, '');
  Gerador.wCampo(tcDe2, '', 'ValorDed'      , 01, 16, 2, NFSe.Servico.Valores.ValorDeducoes, '');
  Gerador.wCampo(tcDe2, '', 'ValorIssRetTom', 01, 16, 2, NFSe.Servico.Valores.ValorIssRetido, '');
  Gerador.wCampo(tcDe2, '', 'ValorTributos' , 01, 16, 2, ValReg30, '');
  Gerador.wCampo(tcStr, '', 'QtdReg30'      , 01, 05, 1, QtdReg30, '');

  Gerador.wGrupo('/Reg90');
end;

function TNFSeW_CONAM.GerarXml: Boolean;
begin
  Gerador.ListaDeAlertas.Clear;
  Gerador.ArquivoFormatoXML := '';

  GerarXML_CONAM;

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

procedure TNFSeW_CONAM.GerarXML_CONAM;
begin
  Gerador.Opcoes.DecimalChar := ',';
  Gerador.Opcoes.QuebraLinha := FQuebradeLinha;

  GerarListaServicos;
end;

end.

