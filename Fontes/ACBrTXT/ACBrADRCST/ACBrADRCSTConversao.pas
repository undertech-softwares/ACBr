{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo: Ribamar M. Santos                               }
{                              Juliomar Marchetti                              }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrADRCSTConversao;

interface

type
  TADRCSTLayout = (
    lyADRCST,
    //Leiaute doADRC-ST
    //0000 Registro de abertura e identifica��o do contribuinte
    //1000 Registro anal�tico do produto
    //1010 Invent�rio total do produto
    //1100 Registro totalizador das entradas
    //1110 Registro das notas fiscais de entrada
    //1120 Registro das notas fiscais de devolu��o das entradas
    //1200 Registro totalizador das sa�das internas para consumidor final
    //1210 Registro das notas fiscais de sa�da interna para consumidor final
    //1220 Registro das notas fiscais de devolu��o das sa�das internas para consumidor final
    //1300 Registro totalizador das sa�das para outros estados
    //1310 Registro das notas fiscais de sa�da para outros estados
    //1320 Registro das notas fiscais de devolu��o das sa�das para outros estados
    //1400 Registro totalizador das sa�das internas que trata o art. 119 do RICMS/17
    //1410 Registro das notas fiscais de sa�das internas que trata o art. 119 do RICMS/17
    //1420 Registro das notas fiscais de devolu��o das sa�das internas que trata o art. 119 do RICMS/17
    //1500 Registro totalizador das sa�das internas destinadas a contribuinte do Simples Nacional
    //1510 Registro das notas fiscais de sa�das internas destinadas a contribuinte do Simples Nacional
    //1520 Registro das notas fiscais de devolu��o das sa�das internas destinadas a contribuinte do SimplesNacional
    //1999 Registro de encerramento do bloco 1
    //9000 Apura��o do Total do Arquivo
    //9999 Registro de encerramento do arquivo

    lyADRCSTCD
    //Leiaute do Arquivo de Centro de Distribui��o ou de Estabelecimento que centraliza as aquisi��es dos produtos sujeitos � substitui��otribut�ria
    //0001 Registro de abertura e identifica��o do contribuinte
    //1001 Registro anal�tico do produto
    //1101 Registro totalizador das entradas do produto
    //1111 Registro das notas fiscais de entrada
    //9999 Registro de encerramento do arquivo
  );
  //Versao Leiaute doADRC-ST
  TADRCSTVersao = (
    vlADRCSTVersao100, //Versao 100
    vlADRCSTVersao110 //Versao 110
    );
  //Versao Leiaute do Arquivo de Centro de Distribui��o
  TADRCSTCDVersao = (
    vlADRCSTCDVersao100 //Versao 100
    );

  TADRCSTFinalidade = (
    afnArquivoOriginal,//0 � Arquivo original
    afnArquivoSubstittuo//1 � Arquivo substituto
    );

  TADRCSTIndicadorProdutoFECOP = (
    indProdutoNaoSujeitoFECOP, //0 � Produto n�o est� sujeito ao FECOP
    indProdutoSujeitoFECOP//1 � Produto est� sujeito ao FECOP
    );

  TADRCSTIndicadorResponsavelRetencao = (
    inRRRemetenteDireto,//1 � Remetente direto
    inRRRemetenteIndireto,//2 � Remetente indireto
    inRRProprioDeclarante//3 � Pr�prio declarante
    );

  TADRCSTIndicadorReaverRecolherImposto = (
    inRRIRecuperacaoContaGrafica,//0 � Recupera��o em conta gr�fica
    inRRIRessarcimentoFornecedor,//1 � Ressarcimento para fornecedor
    inRRIComplementacaoImposto,//2 � Complementa��o do Imposto
    inRRISemInformacao// '' Verificar se foi informada a op��o de reaver ou complementar o imposto no campo [OP��O_R1X00] quando houver informa��o no R1X00, caso contr�rio, o campo fica vazio.
    );

function ADRCSTVersaoToString(const ALayout: TADRCSTVersao): string;
function StringToADRCSTVersao(const ALayout: string): TADRCSTVersao;

function ADRCSTCDVersaoToString(const ALayout: TADRCSTCDVersao): string;
function StringToADRCSTCDVersao(const ALayout: string): TADRCSTCDVersao;

function ADRCSTFinalidadeToString(const AFinalidade: TADRCSTFinalidade): string;
function StringToADRCSTFinalidade(const AFinalidade: string): TADRCSTFinalidade;

function ADRCSTIndicadorProdutoFECOPToString(
  const AIndicador: TADRCSTIndicadorProdutoFECOP): string;
function StringToADRCSTIndicadorProdutoFECOP(const AIndicador: string):
  TADRCSTIndicadorProdutoFECOP;

function ADRCSTIndicadorResponsavelRetencaoToString(
  const AIndicador: TADRCSTIndicadorResponsavelRetencao): string;
function StringToADRCSTIndicadorResponsavelRetencao(
  const AIndicador: string): TADRCSTIndicadorResponsavelRetencao;

function ADRCSTIndicadorReaverRecolherImpostoToString(
  const AIndicador: TADRCSTIndicadorReaverRecolherImposto): string;
function StringToADRCSTIndicadorReaverRecolherImposto(
  const AIndicador: string): TADRCSTIndicadorReaverRecolherImposto;  

implementation

function ADRCSTVersaoToString(const ALayout: TADRCSTVersao): string;
begin
  case ALayout of
    vlADRCSTVersao100: Result := '100';
    vlADRCSTVersao110: Result := '110';
  end;
end;

function StringToADRCSTVersao(const ALayout: string): TADRCSTVersao;
begin
  if ALayout = '100' then
    Result := vlADRCSTVersao100
  else
  if ALayout = '110' then
    Result := vlADRCSTVersao110;
end;

function ADRCSTCDVersaoToString(const ALayout: TADRCSTCDVersao): string;
begin
  case ALayout of
    vlADRCSTCDVersao100: Result := '100';
  end;
end;

function StringToADRCSTCDVersao(const ALayout: string): TADRCSTCDVersao;
begin
  if ALayout = '100' then
    Result := vlADRCSTCDVersao100;
end;


function ADRCSTFinalidadeToString(const AFinalidade: TADRCSTFinalidade): string;
begin
  case AFinalidade of
    afnArquivoOriginal: Result := '0';
    afnArquivoSubstittuo: Result := '1';
  end;
end;

function StringToADRCSTFinalidade(const AFinalidade: string): TADRCSTFinalidade;
begin
  if AFinalidade = '0' then
    Result := afnArquivoOriginal
  else
  if AFinalidade = '1' then
    Result := afnArquivoSubstittuo;
end;


function ADRCSTIndicadorProdutoFECOPToString(
  const AIndicador: TADRCSTIndicadorProdutoFECOP): string;
begin
  case AIndicador of
    indProdutoNaoSujeitoFECOP: Result := '0';
    indProdutoSujeitoFECOP: Result := '1';
  end;
end;

function StringToADRCSTIndicadorProdutoFECOP(const AIndicador: string):
TADRCSTIndicadorProdutoFECOP;
begin
  if AIndicador = '0' then
    Result := indProdutoNaoSujeitoFECOP
  else
  if AIndicador = '1' then
    Result := indProdutoSujeitoFECOP;
end;

function ADRCSTIndicadorResponsavelRetencaoToString(
  const AIndicador: TADRCSTIndicadorResponsavelRetencao): string;
begin
  case AIndicador of
    inRRRemetenteDireto: Result := '1';
    inRRRemetenteIndireto: Result := '2';
    inRRProprioDeclarante: Result := '3';
  end;
end;

function StringToADRCSTIndicadorResponsavelRetencao(
  const AIndicador: string): TADRCSTIndicadorResponsavelRetencao;
begin
  if AIndicador = '1' then
    Result := inRRRemetenteDireto
  else
  if AIndicador = '2' then
    Result := inRRRemetenteIndireto
  else
  if AIndicador = '3' then
    Result := inRRProprioDeclarante;
end;

function ADRCSTIndicadorReaverRecolherImpostoToString(
  const AIndicador: TADRCSTIndicadorReaverRecolherImposto): string;
begin
  case AIndicador of
    inRRIRecuperacaoContaGrafica: Result := '0';
    inRRIRessarcimentoFornecedor: Result := '1';
    inRRIComplementacaoImposto: Result := '2';
    inRRISemInformacao: Result := '';
  end;
end;

function StringToADRCSTIndicadorReaverRecolherImposto(
  const AIndicador: string): TADRCSTIndicadorReaverRecolherImposto;
begin
  if AIndicador = '0' then
    Result := inRRIRecuperacaoContaGrafica
  else
  if AIndicador = '1' then
    Result := inRRIRessarcimentoFornecedor
  else
  if AIndicador = '2' then
    Result := inRRIComplementacaoImposto
  else if AIndicador = '' then
    Result := inRRISemInformacao;
end;

end.
