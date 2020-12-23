{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Teno Dias                                }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

unit ACBrLibCTeStaticImportMT;

{$IfDef FPC}
{$mode objfpc}{$H+}
{$EndIf}

{.$Define STDCALL}

interface

uses
  Classes, SysUtils;

const
 {$IfDef MSWINDOWS}
  {$IfDef CPU64}
  CACBrCTeLIBName = 'ACBrCTe64.dll';
  {$Else}
  CACBrCTeLIBName = 'ACBrCTe32.dll';
  {$EndIf}
 {$Else}
  {$IfDef CPU64}
  CACBrCTeLIBName = 'acbrcte64.so';
  {$Else}
  CACBrCTeLIBName = 'acbrcte32.so';

  {$EndIf}
 {$EndIf}

function CTE_Inicializar(var libHandle: longint; const eArqConfig, eChaveCrypt: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;
function CTE_Finalizar(const libHandle: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_Nome(const libHandle: longint; const sNome: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_Versao(const libHandle: longint; const sVersao: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_UltimoRetorno(const libHandle: longint; const sMensagem: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ConfigLer(const libHandle: longint; const eArqConfig: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ConfigGravar(const libHandle: longint; const eArqConfig: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ConfigLerValor(const libHandle: longint; const eSessao, eChave: PChar; sValor: PChar;
  var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ConfigGravarValor(const libHandle: longint; const eSessao, eChave, eValor: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_CarregarXML(const libHandle: longint; const eArquivoOuXML: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_CarregarINI(const libHandle: longint; const eArquivoOuINI: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ObterXml(const libHandle: longint; AIndex: longint; const sResposta: PChar;
  var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_GravarXml(const libHandle: longint; AIndex: longint;
  const eNomeArquivo, ePathArquivo: PChar): longint;
      {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_CarregarEventoXML(const libHandle: longint; const eArquivoOuXML: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_CarregarEventoINI(const libHandle: longint; const eArquivoOuINI: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_LimparLista(const libHandle: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_LimparListaEventos(const libHandle: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_Assinar(const libHandle: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_Validar(const libHandle: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ValidarRegrasdeNegocios(const libHandle: longint; const sResposta: PChar;
  var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_VerificarAssinatura(const libHandle: longint; const sResposta: PChar;
  var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_StatusServico(const libHandle: longint; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_Consultar(const libHandle: longint; const eChaveOuCTe: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_Inutilizar(const libHandle: longint; const ACNPJ, AJustificativa: PChar;
  Ano, Modelo, Serie, NumeroInicial, NumeroFinal: integer;
  const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_Enviar(const libHandle: longint; ALote: integer; Imprimir: boolean; const sResposta: PChar;
  var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ConsultarRecibo(const libHandle: longint; ARecibo: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;
      {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_Cancelar(const libHandle: longint; const eChave, eJustificativa, eCNPJ: PChar;
  ALote: integer; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_EnviarEvento(const libHandle: longint; idLote: integer; const sResposta: PChar;
  var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ConsultaCadastro(const libHandle: longint; cUF, nDocumento: PChar; nIE: boolean;
  const sResposta: PChar; var esTamanho: longint): longint;
      {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_DistribuicaoDFePorUltNSU(const libHandle: longint; const AcUFAutor: integer;
  eCNPJCPF, eultNSU: PChar; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_DistribuicaoDFePorNSU(const libHandle: longint; const AcUFAutor: integer;
  eCNPJCPF, eNSU: PChar; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_DistribuicaoDFePorChave(const libHandle: longint; const AcUFAutor: integer;
  eCNPJCPF, echCTe: PChar; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_EnviarEmail(const libHandle: longint; const ePara, eChaveCTe: PChar; const AEnviaPDF: boolean;
  const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_EnviarEmailEvento(const libHandle: longint; const ePara, eChaveEvento, eChaveCTe: PChar;
  const AEnviaPDF: boolean; const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_Imprimir(const libHandle: longint; const cImpressora: PChar; nNumCopias: integer;
  const cProtocolo, bMostrarPreview: PChar): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ImprimirPDF(const libHandle: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ImprimirEvento(const libHandle: longint; const eArquivoXmlCTe, eArquivoXmlEvento: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ImprimirEventoPDF(const libHandle: longint;
  const eArquivoXmlCTe, eArquivoXmlEvento: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ImprimirInutilizacao(const libHandle: longint; const eArquivoXml: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

function CTE_ImprimirInutilizacaoPDF(const libHandle: longint; const eArquivoXml: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCTeLIBName;

implementation

end.

