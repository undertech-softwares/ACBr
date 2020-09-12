{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo: Rafael Teno Dias                                }

{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }

{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }

{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrLibNFeBase;

interface

uses
  Classes, SysUtils, Forms,
  ACBrLibComum, ACBrLibNFeDataModule;

type

  { TACBrLibNFe }

  TACBrLibNFe = class(TACBrLib)
  private
    FNFeDM: TLibNFeDM;

    function SetRetornoNFeCarregadas(const NumNFe: integer): integer;
    function SetRetornoEventoCarregados(const NumEventos: integer): integer;

  protected
    procedure CriarConfiguracao(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
    procedure Executar; override;
  public
    constructor Create(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
    destructor Destroy; override;

    property NFeDM: TLibNFeDM read FNFeDM;

    function CarregarXML(const eArquivoOuXML: PChar): longint;
    function CarregarINI(const eArquivoOuINI: PChar): longint;
    function ObterXml(AIndex: longint; const sResposta: PChar;
      var esTamanho: longint): longint;
    function GravarXml(AIndex: longint;
      const eNomeArquivo, ePathArquivo: PChar): longint;
    function ObterIni(AIndex: longint; const sResposta: PChar;
      var esTamanho: longint): longint;
    function GravarIni(AIndex: longint;
      const eNomeArquivo, ePathArquivo: PChar): longint;
    function CarregarEventoXML(const eArquivoOuXML: PChar): longint;
    function CarregarEventoINI(const eArquivoOuINI: PChar): longint;
    function LimparLista: longint;
    function LimparListaEventos: longint;
    function Assinar: longint;
    function Validar: longint;
    function ValidarRegrasdeNegocios(const sResposta: PChar;
      var esTamanho: longint): longint;
    function VerificarAssinatura(const sResposta: PChar;
      var esTamanho: longint): longint;
    function GerarChave(ACodigoUF, ACodigoNumerico, AModelo, ASerie,
      ANumero, ATpEmi: longint; AEmissao, ACNPJCPF: PChar;
      const sResposta: PChar; var esTamanho: longint): longint;
    function ObterCertificados(const sResposta: PChar; var esTamanho: longint): longint;
    function GetPath(ATipo: longint; const sResposta: PChar;
      var esTamanho: longint): longint;
    function GetPathEvento(ACodEvento: PChar; const sResposta: PChar;
      var esTamanho: longint): longint;
    function StatusServico(const sResposta: PChar; var esTamanho: longint): longint;
    function Consultar(const eChaveOuNFe: PChar; AExtrairEventos: boolean;
      const sResposta: PChar; var esTamanho: longint): longint;
    function Inutilizar(const ACNPJ, AJustificativa: PChar;
      Ano, Modelo, Serie, NumeroInicial, NumeroFinal: integer;
      const sResposta: PChar; var esTamanho: longint): longint;
    function Enviar(ALote: integer; AImprimir, ASincrono, AZipado: boolean;
      const sResposta: PChar; var esTamanho: longint): longint;
    function ConsultarRecibo(ARecibo: PChar; const sResposta: PChar;
      var esTamanho: longint): longint;
    function Cancelar(const eChave, eJustificativa, eCNPJCPF: PChar;
      ALote: integer; const sResposta: PChar;
      var esTamanho: longint): longint;
    function EnviarEvento(idLote: integer; const sResposta: PChar;
      var esTamanho: longint): longint;
    function ConsultaCadastro(cUF, nDocumento: PChar; nIE: boolean;
      const sResposta: PChar; var esTamanho: longint): longint;
    function DistribuicaoDFePorUltNSU(const AcUFAutor: integer;
      eCNPJCPF, eultNSU: PChar;
      const sResposta: PChar;
      var esTamanho: longint): longint;
    function DistribuicaoDFePorNSU(const AcUFAutor: integer;
      eCNPJCPF, eNSU: PChar; const sResposta: PChar;
      var esTamanho: longint): longint;
    function DistribuicaoDFePorChave(const AcUFAutor: integer;
      eCNPJCPF, echNFe: PChar; const sResposta: PChar;
      var esTamanho: longint): longint;
    function EnviarEmail(const ePara, eChaveNFe: PChar; const AEnviaPDF: boolean;
      const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
    function EnviarEmailEvento(const ePara, eChaveEvento, eChaveNFe: PChar;
      const AEnviaPDF: boolean;
      const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
    function Imprimir(const cImpressora: PChar; nNumCopias: integer;
      const cProtocolo, bMostrarPreview, cMarcaDagua,
      bViaConsumidor, bSimplificado: PChar): longint;
    function ImprimirPDF: longint;
    function ImprimirEvento(const eArquivoXmlNFe, eArquivoXmlEvento: PChar): longint;
    function ImprimirEventoPDF(const eArquivoXmlNFe, eArquivoXmlEvento: PChar): longint;
    function ImprimirInutilizacao(const eArquivoXml: PChar): longint;
    function ImprimirInutilizacaoPDF(const eArquivoXml: PChar): longint;
  end;

implementation

uses
  ACBrNFeDANFeESCPOS, ACBrLibConsts, ACBrLibNFeConsts, ACBrLibConfig,
  ACBrLibResposta, ACBrLibDistribuicaoDFe, ACBrLibConsReciDFe,
  ACBrLibConsultaCadastro, ACBrLibNFeConfig, ACBrLibNFeRespostas,
  ACBrDFeUtil, ACBrNFe, ACBrMail, ACBrUtil, ACBrLibCertUtils,
  pcnConversao, pcnConversaoNFe, pcnAuxiliar, blcksock;

{ TACBrLibNFe }

constructor TACBrLibNFe.Create(ArqConfig: string; ChaveCrypt: ansistring);
begin
  inherited Create(ArqConfig, ChaveCrypt);
  FNFeDM := TLibNFeDM.Create(nil);
  FNFeDM.Lib := self;
end;

destructor TACBrLibNFe.Destroy;
begin
  FNFeDM.Free;

  inherited Destroy;
end;

procedure TACBrLibNFe.CriarConfiguracao(ArqConfig: string; ChaveCrypt: ansistring);
begin
  fpConfig := TLibNFeConfig.Create(Self, ArqConfig, ChaveCrypt);
end;

procedure TACBrLibNFe.Executar;
begin
  inherited Executar;
  FNFeDM.AplicarConfiguracoes;
end;

function TACBrLibNFe.SetRetornoNFeCarregadas(const NumNFe: integer): integer;
begin
  Result := SetRetorno(0, Format(SInfNFeCarregadas, [NumNFe]));
end;

function TACBrLibNFe.SetRetornoEventoCarregados(const NumEventos: integer): integer;
begin
  Result := SetRetorno(0, Format(SInfEventosCarregados, [NumEventos]));
end;

function TACBrLibNFe.CarregarXML(const eArquivoOuXML: PChar): longint;
var
  EhArquivo: boolean;
  ArquivoOuXml: string;
begin
  try
    ArquivoOuXml := string(eArquivoOuXML);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_CarregarXML(' + ArquivoOuXml + ' )', logCompleto, True)
    else
      GravarLog('NFE_CarregarXML', logNormal);

    EhArquivo := StringEhArquivo(ArquivoOuXml);
    if EhArquivo then
      VerificarArquivoExiste(ArquivoOuXml);

    NFeDM.Travar;
    try
      if EhArquivo then
        NFeDM.ACBrNFe1.NotasFiscais.LoadFromFile(ArquivoOuXml)
      else
        NFeDM.ACBrNFe1.NotasFiscais.LoadFromString(ArquivoOuXml);

      Result := SetRetornoNFeCarregadas(NFeDM.ACBrNFe1.NotasFiscais.Count);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.CarregarINI(const eArquivoOuINI: PChar): longint;
var
  ArquivoOuINI: string;
begin
  try
    ArquivoOuINI := string(eArquivoOuINI);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_CarregarINI(' + ArquivoOuINI + ' )', logCompleto, True)
    else
      GravarLog('NFE_CarregarINI', logNormal);

    if StringEhArquivo(ArquivoOuINI) then
      VerificarArquivoExiste(ArquivoOuINI);

    NFeDM.Travar;

    try
      NFeDM.ACBrNFe1.NotasFiscais.LoadFromIni(ArquivoOuINI);
      Result := SetRetornoNFeCarregadas(NFeDM.ACBrNFe1.NotasFiscais.Count);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.ObterXml(AIndex: longint; const sResposta: PChar; var esTamanho: longint): longint;
var
  Resposta: string;
begin
  try
    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_ObterXml(' + IntToStr(AIndex) + ' )', logCompleto, True)
    else
      GravarLog('NFE_ObterXml', logNormal);

    NFeDM.Travar;

    try
      if (NFeDM.ACBrNFe1.NotasFiscais.Count < 1) or (AIndex < 0) or
         (AIndex >= NFeDM.ACBrNFe1.NotasFiscais.Count) then
         raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

      if EstaVazio(NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].XMLOriginal) then
        NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].GerarXML;

      Resposta := NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].XMLOriginal;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.GravarXml(AIndex: longint; const eNomeArquivo, ePathArquivo: PChar): longint;
var
  ANomeArquivo, APathArquivo: string;
begin
  try
    ANomeArquivo := string(eNomeArquivo);
    APathArquivo := string(ePathArquivo);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_GravarXml(' + IntToStr(AIndex) + ',' +
        ANomeArquivo + ',' + APathArquivo + ' )', logCompleto, True)
    else
      GravarLog('NFE_GravarXml', logNormal);

    NFeDM.Travar;
    try
      if (NFeDM.ACBrNFe1.NotasFiscais.Count < 1) or (AIndex < 0) or
         (AIndex >= NFeDM.ACBrNFe1.NotasFiscais.Count) then
         raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

      if NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].GravarXML(ANomeArquivo, APathArquivo) then
        Result := SetRetorno(ErrOK)
      else
        Result := SetRetorno(ErrGerarXml);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.ObterIni(AIndex: longint; const sResposta: PChar; var esTamanho: longint): longint;
var
  Resposta: string;
begin
  try
    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_ObterIni(' + IntToStr(AIndex) + ' )', logCompleto, True)
    else
      GravarLog('NFE_ObterIni', logNormal);

    NFeDM.Travar;
    try
      if (NFeDM.ACBrNFe1.NotasFiscais.Count < 1) or (AIndex < 0) or (AIndex >= NFeDM.ACBrNFe1.NotasFiscais.Count) then
        raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

      if EstaVazio(NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].XMLOriginal) then
        NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].GerarXML;

      Resposta := NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].GerarNFeIni;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.GravarIni(AIndex: longint; const eNomeArquivo, ePathArquivo: PChar): longint;
var
  ANFeIni, ANomeArquivo, APathArquivo: string;
begin
  try
    ANomeArquivo := string(eNomeArquivo);
    APathArquivo := string(ePathArquivo);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_GravarIni(' + IntToStr(AIndex) + ',' +
        ANomeArquivo + ',' + APathArquivo + ' )', logCompleto, True)
    else
      GravarLog('NFE_GravarIni', logNormal);

    NFeDM.Travar;
    try
      if (NFeDM.ACBrNFe1.NotasFiscais.Count < 1) or (AIndex < 0) or (AIndex >= NFeDM.ACBrNFe1.NotasFiscais.Count) then
        raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

      ANomeArquivo := ExtractFileName(ANomeArquivo);

      if EstaVazio(ANomeArquivo) then
        raise EACBrLibException.Create(ErrExecutandoMetodo, 'Nome de arquivo não informado');

      if EstaVazio(APathArquivo) then
        APathArquivo := ExtractFilePath(ANomeArquivo);
      if EstaVazio(APathArquivo) then
        APathArquivo := NFeDM.ACBrNFe1.Configuracoes.Arquivos.PathSalvar;

      APathArquivo := PathWithDelim(APathArquivo);

      if EstaVazio(NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].XMLOriginal) then
        NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].GerarXML;

      ANFeIni := NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].GerarNFeIni;
      if not DirectoryExists(APathArquivo) then
        ForceDirectories(APathArquivo);

      WriteToTXT(APathArquivo + ANomeArquivo, ANFeIni, False, False);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.CarregarEventoXML(const eArquivoOuXML: PChar): longint;
var
  EhArquivo: boolean;
  ArquivoOuXml: string;
begin
  try
    ArquivoOuXml := string(eArquivoOuXML);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_CarregarEventoXML(' + ArquivoOuXml + ' )', logCompleto, True)
    else
      GravarLog('NFE_CarregarEventoXML', logNormal);

    EhArquivo := StringEhArquivo(ArquivoOuXml);
    if EhArquivo then
      VerificarArquivoExiste(ArquivoOuXml);

    NFeDM.Travar;
    try
      if EhArquivo then
        NFeDM.ACBrNFe1.EventoNFe.LerXML(ArquivoOuXml)
      else
        NFeDM.ACBrNFe1.EventoNFe.LerXMLFromString(ArquivoOuXml);

      Result := SetRetornoEventoCarregados(NFeDM.ACBrNFe1.EventoNFe.Evento.Count);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.CarregarEventoINI(const eArquivoOuINI: PChar): longint;
var
  ArquivoOuINI: string;
begin
  try
    ArquivoOuINI := string(eArquivoOuINI);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_CarregarEventoINI(' + ArquivoOuINI + ' )', logCompleto, True)
    else
      GravarLog('NFE_CarregarEventoINI', logNormal);

    if StringEhArquivo(ArquivoOuINI) then
      VerificarArquivoExiste(ArquivoOuINI);

    NFeDM.Travar;
    try
      NFeDM.ACBrNFe1.EventoNFe.LerFromIni(ArquivoOuINI, False);
      Result := SetRetornoEventoCarregados(NFeDM.ACBrNFe1.EventoNFe.Evento.Count);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.LimparLista: longint;
begin
  try
    GravarLog('NFE_LimparLista', logNormal);

    NFeDM.Travar;
    try
      NFeDM.ACBrNFe1.NotasFiscais.Clear;
      Result := SetRetornoNFeCarregadas(NFeDM.ACBrNFe1.NotasFiscais.Count);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.LimparListaEventos: longint;
begin
  try
    GravarLog('NFE_LimparListaEventos', logNormal);


    NFeDM.Travar;
    try
      NFeDM.ACBrNFe1.EventoNFe.Evento.Clear;
      Result := SetRetornoEventoCarregados(NFeDM.ACBrNFe1.EventoNFe.Evento.Count);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.Assinar: longint;
begin
  try
    GravarLog('NFe_Assinar', logNormal);

    NFeDM.Travar;
    try
      try
        NFeDM.ACBrNFe1.NotasFiscais.Assinar;
      except
        on E: EACBrNFeException do
          Result := SetRetorno(ErrAssinarNFe, E.Message);
      end;

      Result := SetRetornoNFeCarregadas(NFeDM.ACBrNFe1.NotasFiscais.Count);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.Validar: longint;
begin
  try
    GravarLog('NFE_Validar', logNormal);

    NFeDM.Travar;
    try
      try
        NFeDM.ACBrNFe1.NotasFiscais.Validar;
      except
        on E: EACBrNFeException do
          Result := SetRetorno(ErrValidacaoNFe, E.Message);
      end;
      Result := SetRetornoNFeCarregadas(NFeDM.ACBrNFe1.NotasFiscais.Count);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.ValidarRegrasdeNegocios(const sResposta: PChar; var esTamanho: longint): longint;
var
  Erros: string;
begin
  try
    GravarLog('NFE_ValidarRegrasdeNegocios', logNormal);

    NFeDM.Travar;
    try
      Erros := '';
      NFeDM.ACBrNFe1.NotasFiscais.ValidarRegrasdeNegocios(Erros);
      MoverStringParaPChar(Erros, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Erros);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.VerificarAssinatura(const sResposta: PChar; var esTamanho: longint): longint;
var
  Erros: string;
begin
  try
    GravarLog('NFE_VerificarAssinatura', logNormal);

    NFeDM.Travar;
    try
      Erros := '';
      NFeDM.ACBrNFe1.NotasFiscais.VerificarAssinatura(Erros);
      MoverStringParaPChar(Erros, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Erros);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.GerarChave(ACodigoUF, ACodigoNumerico,  AModelo, ASerie, ANumero, ATpEmi: longint;
                                AEmissao, ACNPJCPF: PChar;const sResposta: PChar; var esTamanho: longint): longint;
var
  Resposta, CNPJCPF: string;
  Emissao: TDateTime;
begin
  try
    Emissao := StrToDate(AEmissao);
    CNPJCPF := string(ACNPJCPF);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_GerarChave(' + IntToStr(ACodigoUF) + ',' + IntToStr(ACodigoNumerico) + ',' + IntToStr(AModelo) +
        ',' + IntToStr(AModelo) + ',' + IntToStr(ASerie) + ',' + IntToStr(ANumero) + ',' + IntToStr(ATpEmi) +
        ',' + DateToStr(Emissao) + ',' + CNPJCPF + ' )', logCompleto, True)
    else
      GravarLog('NFE_GerarChave', logNormal);


    NFeDM.Travar;

    try
      Resposta := '';
      Resposta := GerarChaveAcesso(ACodigoUF, Emissao, CNPJCPF, ASerie, ANumero, ATpEmi, ACodigoNumerico, AModelo);
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.ObterCertificados(const sResposta: PChar; var esTamanho: longint): longint;
var
  Resposta: string;
begin
  try
    GravarLog('NFE_ObterCertificados', logNormal);

    NFeDM.Travar;

    try
      Resposta := '';
      Resposta := ObterCerticados(NFeDM.ACBrNFe1.SSL);
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.GetPath(ATipo: longint; const sResposta: PChar; var esTamanho: longint): longint;
var
  Resposta: string;
begin
  try
    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_GetPath(' + IntToStr(ATipo) + ' )', logCompleto, True)
    else
      GravarLog('NFE_GetPath', logNormal);

    NFeDM.Travar;

    try
      with NFeDM do
      begin
        Resposta := '';

        case ATipo of
          0: Resposta := ACBrNFe1.Configuracoes.Arquivos.GetPathNFe();
          1: Resposta := ACBrNFe1.Configuracoes.Arquivos.GetPathInu();
          2: Resposta := ACBrNFe1.Configuracoes.Arquivos.GetPathEvento(teCCe);
          3: Resposta := ACBrNFe1.Configuracoes.Arquivos.GetPathEvento(teCancelamento);
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      end;
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.GetPathEvento(ACodEvento: PChar; const sResposta: PChar; var esTamanho: longint): longint;
var
  Resposta, CodEvento: string;
  ok: boolean;
begin
  try
    CodEvento := string(ACodEvento);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_GetPathEvento(' + CodEvento + ' )', logCompleto, True)
    else
      GravarLog('NFE_GetPathEvento', logNormal);

    NFeDM.Travar;

    try
      with NFeDM do
      begin
        Resposta := '';
        Resposta := ACBrNFe1.Configuracoes.Arquivos.GetPathEvento(StrToTpEventoNFe(ok, CodEvento));
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      end;
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.StatusServico(const sResposta: PChar; var esTamanho: longint): longint;
var
  Resp: TStatusServicoResposta;
  Resposta: string;
begin
  try
    GravarLog('NFE_StatusServico', logNormal);

    NFeDM.ValidarIntegradorNFCe;
    NFeDM.Travar;
    Resp := TStatusServicoResposta.Create(Config.TipoResposta, Config.CodResposta);
    try
      with NFeDM.ACBrNFe1 do
      begin
        WebServices.StatusServico.Executar;

        Resp.Processar(NFeDM.ACBrNFe1);
        Resposta := Resp.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      end;
    finally
      Resp.Free;
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.Consultar(const eChaveOuNFe: PChar; AExtrairEventos: boolean; const sResposta: PChar;
                                      var esTamanho: longint): longint;
var
  EhArquivo: boolean;
  ChaveOuNFe: string;
  Resp: TConsultaNFeResposta;
  Resposta: string;
begin
  try
    ChaveOuNFe := string(eChaveOuNFe);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_Consultar(' + ChaveOuNFe + ', ' +
        BoolToStr(AExtrairEventos, True) + ' )', logCompleto, True)
    else
      GravarLog('NFE_Consultar', logNormal);

    NFeDM.Travar;

    EhArquivo := StringEhArquivo(ChaveOuNFe);

    if EhArquivo and not ValidarChave(ChaveOuNFe) then
    begin
      VerificarArquivoExiste(ChaveOuNFe);
      NFeDM.ACBrNFe1.NotasFiscais.LoadFromFile(ChaveOuNFe);
    end;

    if NFeDM.ACBrNFe1.NotasFiscais.Count = 0 then
    begin
      if ValidarChave(ChaveOuNFe) then
        NFeDM.ACBrNFe1.WebServices.Consulta.NFeChave := ChaveOuNFe
      else
        raise EACBrLibException.Create(ErrChaveNFe, Format(SErrChaveInvalida, [ChaveOuNFe]));
    end
    else
      NFeDM.ACBrNFe1.WebServices.Consulta.NFeChave := NFeDM.ACBrNFe1.NotasFiscais.Items[NFeDM.ACBrNFe1.NotasFiscais.Count - 1].NumID;

    NFeDM.ACBrNFe1.WebServices.Consulta.ExtrairEventos := AExtrairEventos;
    Resp := TConsultaNFeResposta.Create(Config.TipoResposta, Config.CodResposta);

    try
      with NFeDM.ACBrNFe1 do
      begin
        WebServices.Consulta.Executar;
        Resp.Processar(NFeDM.ACBrNFe1);

        Resposta := Resp.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      end;
    finally
      Resp.Free;
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.Inutilizar(const ACNPJ, AJustificativa: PChar; Ano, Modelo, Serie, NumeroInicial,
                                       NumeroFinal: integer; const sResposta: PChar; var esTamanho: longint): longint;
var
  Resp: TInutilizarNFeResposta;
  Resposta, CNPJ, Justificativa: string;
begin
  try
    Justificativa := string(AJustificativa);
    CNPJ := string(ACNPJ);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_InutilizarNFe(' + CNPJ + ',' + Justificativa + ',' + IntToStr(Ano) + ',' + IntToStr(modelo) + ','
             + IntToStr(Serie) + ',' + IntToStr(NumeroInicial) + ',' + IntToStr(NumeroFinal) + ' )', logCompleto, True)
    else
      GravarLog('NFE_InutilizarNFe', logNormal);

    CNPJ := OnlyNumber(CNPJ);

    if not ValidarCNPJ(CNPJ) then
      raise EACBrNFeException.Create('CNPJ: ' + CNPJ + ', inválido.');

    NFeDM.Travar;
    Resp := TInutilizarNFeResposta.Create(Config.TipoResposta, Config.CodResposta);

    try
      with NFeDM.ACBrNFe1 do
      begin
        with WebServices do
        begin
          Inutilizacao.CNPJ := CNPJ;
          Inutilizacao.Justificativa := Justificativa;
          Inutilizacao.Modelo := Modelo;
          Inutilizacao.Serie := Serie;
          Inutilizacao.Ano := Ano;
          Inutilizacao.NumeroInicial := NumeroInicial;
          Inutilizacao.NumeroFinal := NumeroFinal;

          Inutilizacao.Executar;
          Resp.Processar(NFeDM.ACBrNFe1);
          Resposta := Resp.Gerar;
          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      end;
    finally
      Resp.Free;
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);
    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.Enviar(ALote: integer; AImprimir, ASincrono, AZipado: boolean; const sResposta: PChar;
                                   var esTamanho: longint): longint;
var
  Resposta: string;
  RespEnvio: TEnvioResposta;
  RespRetorno: TRetornoResposta;
  ImpResp: TLibImpressaoResposta;
  i, ImpCount: integer;
begin
  try
    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_Enviar(' + IntToStr(ALote) + ',' + BoolToStr(AImprimir, 'Imprimir', '') +
                 BoolToStr(ASincrono, 'Sincrono', '') + BoolToStr(AZipado, 'Zipado', '') + ' )', logCompleto, True)
    else
      GravarLog('NFe_Enviar', logNormal);


    NFeDM.Travar;

    try
      with NFeDM.ACBrNFe1 do
      begin
        if NotasFiscais.Count <= 0 then
          raise EACBrLibException.Create(ErrEnvio, 'ERRO: Nenhuma NF-e adicionada ao Lote');

        if NotasFiscais.Count > 50 then
           raise EACBrLibException.Create(ErrEnvio, 'ERRO: Conjunto de NF-e transmitidas (máximo de 50 NF-e)' +
                                                    ' excedido. Quantidade atual: ' + IntToStr(NotasFiscais.Count));

        NFeDM.ValidarIntegradorNFCe;

        Resposta := '';
        WebServices.Enviar.Clear;
        WebServices.Retorno.Clear;

        NotasFiscais.Assinar;
        NotasFiscais.Validar;

        if (ALote = 0) then
          WebServices.Enviar.Lote := '1'
        else
          WebServices.Enviar.Lote := IntToStr(ALote);

        WebServices.Enviar.Sincrono := ASincrono;
        WebServices.Enviar.Zipado := AZipado;
        WebServices.Enviar.Executar;

        RespEnvio := TEnvioResposta.Create(Config.TipoResposta, Config.CodResposta);

        try
          RespEnvio.Processar(NFeDM.ACBrNFe1);
          Resposta := RespEnvio.Gerar;
        finally
          RespEnvio.Free;
        end;

        if not ASincrono or ((NaoEstaVazio(WebServices.Enviar.Recibo)) and (WebServices.Enviar.cStat = 103)) then
        begin
          WebServices.Retorno.Recibo := WebServices.Enviar.Recibo;
          WebServices.Retorno.Executar;

          RespRetorno := TRetornoResposta.Create('NFe', Config.TipoResposta, Config.CodResposta);

          try
            RespRetorno.Processar(WebServices.Retorno.NFeRetorno,
                                  WebServices.Retorno.Recibo,
                                  WebServices.Retorno.Msg,
                                  WebServices.Retorno.Protocolo,
                                  WebServices.Retorno.ChaveNFe);

            Resposta := Resposta + sLineBreak + RespRetorno.Gerar;
          finally
            RespRetorno.Free;
          end;
        end;

        if AImprimir then
        begin
          NFeDM.ConfigurarImpressao();

          ImpCount := 0;
          for I := 0 to NotasFiscais.Count - 1 do
          begin
            if NotasFiscais.Items[I].Confirmada then
            begin
              NotasFiscais.Items[I].Imprimir;
              Inc(ImpCount);
            end;
          end;

          if ImpCount > 0 then
          begin
            ImpResp := TLibImpressaoResposta.Create(ImpCount, Config.TipoResposta, Config.CodResposta);
            try
              Resposta := Resposta + sLineBreak + ImpResp.Gerar;
            finally
              ImpResp.Free;
            end;
          end;
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      end;
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.ConsultarRecibo(ARecibo: PChar; const sResposta: PChar; var esTamanho: longint): longint;
var
  Resp: TReciboResposta;
  sRecibo, Resposta: string;
begin
  try
    sRecibo := string(ARecibo);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_ConsultarRecibo(' + sRecibo + ' )', logCompleto, True)
    else
      GravarLog('NFE_ConsultarRecibo', logNormal);

    NFeDM.Travar;

    try
      with NFeDM.ACBrNFe1 do
      begin
        WebServices.Recibo.Recibo := sRecibo;
        WebServices.Recibo.Executar;

        Resp := TReciboResposta.Create('NFe', Config.TipoResposta, Config.CodResposta);

        try
          Resp.Processar(WebServices.Recibo.NFeRetorno, WebServices.Recibo.Recibo);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      end;
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);
    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.Cancelar(const eChave, eJustificativa, eCNPJCPF: PChar; ALote: integer;
                                     const sResposta: PChar; var esTamanho: longint): longint;
var
  AChave, AJustificativa, ACNPJCPF: string;
  Resp: TCancelamentoResposta;
  Resposta: string;
begin
  try
    AChave := string(eChave);
    AJustificativa := string(eJustificativa);
    ACNPJCPF := string(eCNPJCPF);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_Cancelar(' + AChave + ',' + AJustificativa + ',' + ACNPJCPF + ','
                 + IntToStr(ALote) + ' )', logCompleto, True)
    else
      GravarLog('NFe_Cancelar', logNormal);

    NFeDM.Travar;

    try
      if not ValidarChave(AChave) then
        raise EACBrLibException.Create(ErrChaveNFe, Format(SErrChaveInvalida, [AChave]))
      else
        NFeDM.ACBrNFe1.WebServices.Consulta.NFeChave := AChave;

      if not NFeDM.ACBrNFe1.WebServices.Consulta.Executar then
        raise EACBrLibException.Create(ErrConsulta, NFeDM.ACBrNFe1.WebServices.Consulta.Msg);

      NFeDM.ACBrNFe1.EventoNFe.Evento.Clear;
      with NFeDM.ACBrNFe1.EventoNFe.Evento.New do
      begin
        Infevento.CNPJ := ACNPJCPF;
        if Trim(Infevento.CNPJ) = '' then
          Infevento.CNPJ := copy(OnlyNumber(NFeDM.ACBrNFe1.WebServices.Consulta.NFeChave), 7, 14)
        else
        begin
          if not ValidarCNPJouCPF(ACNPJCPF) then
            raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJCPFInvalido, [ACNPJCPF]));
        end;

        Infevento.nSeqEvento := 1;
        InfEvento.tpAmb := NFeDM.ACBrNFe1.Configuracoes.WebServices.Ambiente;
        Infevento.cOrgao := StrToIntDef(copy(OnlyNumber(NFeDM.ACBrNFe1.WebServices.Consulta.NFeChave), 1, 2), 0);
        Infevento.dhEvento := now;
        Infevento.tpEvento := teCancelamento;
        Infevento.chNFe := NFeDM.ACBrNFe1.WebServices.Consulta.NFeChave;
        Infevento.detEvento.nProt := NFeDM.ACBrNFe1.WebServices.Consulta.Protocolo;
        Infevento.detEvento.xJust := AJustificativa;
      end;

      if (ALote = 0) then
        ALote := 1;

      NFeDM.ACBrNFe1.WebServices.EnvEvento.idLote := ALote;
      NFeDM.ACBrNFe1.WebServices.EnvEvento.Executar;

      Resp := TCancelamentoResposta.Create(Config.TipoResposta, Config.CodResposta);
      try
        Resp.Processar(NFeDM.ACBrNFe1);
        Resposta := Resp.Gerar;
      finally
        Resp.Free;
      end;

      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.EnviarEvento(idLote: integer; const sResposta: PChar; var esTamanho: longint): longint;
var
  i, j: integer;
  Resp: TEventoResposta;
  Resposta, chNfe: string;
begin
  try
    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_EnviarEvento(' + IntToStr(idLote) + ' )', logCompleto, True)
    else
      GravarLog('NFe_EnviarEvento', logNormal);

    NFeDM.Travar;

    try
      with NFeDM.ACBrNFe1 do
      begin
        if EventoNFe.Evento.Count = 0 then
          raise EACBrLibException.Create(ErrEnvioEvento, 'ERRO: Nenhum Evento adicionado ao Lote');

        if EventoNFe.Evento.Count > 20 then
          raise EACBrLibException.Create(ErrEnvioEvento,  'ERRO: Conjunto de Eventos transmitidos (máximo de 20) ' +
                                                          'excedido. Quantidade atual: ' + IntToStr(EventoNFe.Evento.Count));

        {Atribuir nSeqEvento, CNPJ, Chave e/ou Protocolo quando não especificar}
        for i := 0 to EventoNFe.Evento.Count - 1 do
        begin
          if EventoNFe.Evento.Items[i].InfEvento.nSeqEvento = 0 then
            EventoNFe.Evento.Items[i].infEvento.nSeqEvento := 1;

          EventoNFe.Evento.Items[i].InfEvento.tpAmb := Configuracoes.WebServices.Ambiente;

          if NotasFiscais.Count > 0 then
          begin
            chNfe := OnlyNumber(EventoNFe.Evento.Items[i].InfEvento.chNfe);

            // Se tem a chave da NFe no Evento, procure por ela nas notas carregadas //
            if NaoEstaVazio(chNfe) then
            begin
              for j := 0 to NotasFiscais.Count - 1 do
              begin
                if chNfe = NotasFiscais.Items[j].NumID then
                  Break;
              end;

              if j = NotasFiscais.Count then
                raise EACBrLibException.Create(ErrEnvioEvento, 'Não existe NFe com a chave [' + chNfe + '] carregada');
            end
            else
              j := 0;

            if trim(EventoNFe.Evento.Items[i].InfEvento.CNPJ) = '' then
              EventoNFe.Evento.Items[i].InfEvento.CNPJ := NotasFiscais.Items[j].NFe.Emit.CNPJCPF;

            if chNfe = '' then
              EventoNFe.Evento.Items[i].InfEvento.chNfe := NotasFiscais.Items[j].NumID;

            if trim(EventoNFe.Evento.Items[i].infEvento.detEvento.nProt) = '' then
            begin
              if EventoNFe.Evento.Items[i].infEvento.tpEvento = teCancelamento then
              begin
                EventoNFe.Evento.Items[i].infEvento.detEvento.nProt := NotasFiscais.Items[j].NFe.procNFe.nProt;

                if trim(EventoNFe.Evento.Items[i].infEvento.detEvento.nProt) = '' then
                begin
                  WebServices.Consulta.NFeChave := EventoNFe.Evento.Items[i].InfEvento.chNfe;

                  if not WebServices.Consulta.Executar then
                    raise EACBrLibException.Create(ErrEnvioEvento, WebServices.Consulta.Msg);

                  EventoNFe.Evento.Items[i].infEvento.detEvento.nProt := WebServices.Consulta.Protocolo;
                end;
              end;
            end;
          end;
        end;

        if (idLote = 0) then
          idLote := 1;

        WebServices.EnvEvento.idLote := idLote;
        WebServices.EnvEvento.Executar;
      end;

      try
        Resp := TEventoResposta.Create(Config.TipoResposta, Config.CodResposta);
        Resp.Processar(NFeDM.ACBrNFe1);
        Resposta := Resp.Gerar;
      finally
        Resp.Free;
      end;

      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);
    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.ConsultaCadastro(cUF, nDocumento: PChar; nIE: boolean;
                                             const sResposta: PChar; var esTamanho: longint): longint;
var
  Resp: TConsultaCadastroResposta;
  AUF, ADocumento: string;
  Resposta: string;
begin
  try
    AUF := string(cUF);
    ADocumento := string(nDocumento);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFE_ConsultaCadastro(' + AUF + ',' + ADocumento + ',' + BoolToStr(nIE, True) + ' )', logCompleto, True)
    else
      GravarLog('NFE_ConsultaCadastro', logNormal);

    NFeDM.Travar;
    try
      NFeDM.ACBrNFe1.WebServices.ConsultaCadastro.UF := AUF;
      if nIE then
        NFeDM.ACBrNFe1.WebServices.ConsultaCadastro.IE := ADocumento
      else
      begin
        if Length(ADocumento) > 11 then
          NFeDM.ACBrNFe1.WebServices.ConsultaCadastro.CNPJ := ADocumento
        else
          NFeDM.ACBrNFe1.WebServices.ConsultaCadastro.CPF := ADocumento;
      end;

      NFeDM.ACBrNFe1.WebServices.ConsultaCadastro.Executar;
      Resp := TConsultaCadastroResposta.Create(Config.TipoResposta, Config.CodResposta);

      try
        Resp.Processar(NFeDM.ACBrNFe1.WebServices.ConsultaCadastro.RetConsCad);
        Resposta := Resp.Gerar;
      finally
        Resp.Free;
      end;

      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.DistribuicaoDFePorUltNSU(const AcUFAutor: integer;  eCNPJCPF, eultNSU: PChar;
                                                     const sResposta: PChar; var esTamanho: longint): longint;
var
  AultNSU, ACNPJCPF: string;
  Resposta: string;
  Resp: TDistribuicaoDFeResposta;
begin
  try
    ACNPJCPF := string(eCNPJCPF);
    AultNSU := string(eultNSU);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_DistribuicaoDFePorUltNSU(' + IntToStr(AcUFAutor) + ',' + ACNPJCPF + ',' + AultNSU + ')', logCompleto, True)
    else
      GravarLog('NFe_DistribuicaoDFePorUltNSU', logNormal);

    NFeDM.Travar;

    try
      if not ValidarCNPJ(ACNPJCPF) then
        raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJCPFInvalido, [ACNPJCPF]));

      with NFeDM do
      begin
        ACBrNFe1.WebServices.DistribuicaoDFe.cUFAutor := AcUFAutor;
        ACBrNFe1.WebServices.DistribuicaoDFe.CNPJCPF := ACNPJCPF;
        ACBrNFe1.WebServices.DistribuicaoDFe.ultNSU := AultNSU;
        ACBrNFe1.WebServices.DistribuicaoDFe.NSU := '';
        ACBrNFe1.WebServices.DistribuicaoDFe.chNFe := '';

        ACBrNFe1.WebServices.DistribuicaoDFe.Executar;

        Resp := TDistribuicaoDFeResposta.Create(Config.TipoResposta, Config.CodResposta);

        try
          Resp.Processar(ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt,
                         ACBrNFe1.WebServices.DistribuicaoDFe.Msg,
                         ACBrNFe1.WebServices.DistribuicaoDFe.NomeArq,
                         ACBrNFe1.WebServices.DistribuicaoDFe.ListaArqs);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      end;
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.DistribuicaoDFePorNSU(const AcUFAutor: integer; eCNPJCPF, eNSU: PChar;
                                                  const sResposta: PChar; var esTamanho: longint): longint;
var
  ANSU, ACNPJCPF: string;
  Resposta: string;
  Resp: TDistribuicaoDFeResposta;
begin
  try
    ACNPJCPF := string(eCNPJCPF);
    ANSU := string(eNSU);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_DistribuicaoDFePorNSU(' + IntToStr(AcUFAutor) +
        ',' + ACNPJCPF + ',' + ANSU + ')', logCompleto, True)
    else
      GravarLog('NFe_DistribuicaoDFePorNSU', logNormal);

    NFeDM.Travar;

    try
      if not ValidarCNPJ(ACNPJCPF) then
        raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJCPFInvalido, [ACNPJCPF]));

      with NFeDM do
      begin
        ACBrNFe1.WebServices.DistribuicaoDFe.cUFAutor := AcUFAutor;
        ACBrNFe1.WebServices.DistribuicaoDFe.CNPJCPF := ACNPJCPF;
        ACBrNFe1.WebServices.DistribuicaoDFe.ultNSU := '';
        ACBrNFe1.WebServices.DistribuicaoDFe.NSU := ANSU;
        ACBrNFe1.WebServices.DistribuicaoDFe.chNFe := '';

        ACBrNFe1.WebServices.DistribuicaoDFe.Executar;

        Resp := TDistribuicaoDFeResposta.Create(Config.TipoResposta, Config.CodResposta);

        try
          Resp.Processar(ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt,
                         ACBrNFe1.WebServices.DistribuicaoDFe.Msg,
                         ACBrNFe1.WebServices.DistribuicaoDFe.NomeArq,
                         ACBrNFe1.WebServices.DistribuicaoDFe.ListaArqs);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      end;
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.DistribuicaoDFePorChave(const AcUFAutor: integer; eCNPJCPF, echNFe: PChar;
                                                    const sResposta: PChar; var esTamanho: longint): longint;
var
  AchNFe, ACNPJCPF: string;
  Resposta: string;
  Resp: TDistribuicaoDFeResposta;
begin
  try
    ACNPJCPF := string(eCNPJCPF);
    AchNFe := string(echNFe);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_DistribuicaoDFePorChave(' + IntToStr(AcUFAutor) + ',' + ACNPJCPF + ',' + AchNFe + ')', logCompleto, True)
    else
      GravarLog('NFe_DistribuicaoDFePorChave', logNormal);

    NFeDM.Travar;

    try
      if not ValidarCNPJ(ACNPJCPF) then
        raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJCPFInvalido, [ACNPJCPF]));

      if not ValidarChave(AchNFe) then
        raise EACBrLibException.Create(ErrChaveNFe, Format(SErrChaveInvalida, [AchNFe]));

      with NFeDM do
      begin
        ACBrNFe1.WebServices.DistribuicaoDFe.cUFAutor := AcUFAutor;
        ACBrNFe1.WebServices.DistribuicaoDFe.CNPJCPF := ACNPJCPF;
        ACBrNFe1.WebServices.DistribuicaoDFe.ultNSU := '';
        ACBrNFe1.WebServices.DistribuicaoDFe.NSU := '';
        ACBrNFe1.WebServices.DistribuicaoDFe.chNFe := AchNFe;

        ACBrNFe1.WebServices.DistribuicaoDFe.Executar;

        Resp := TDistribuicaoDFeResposta.Create(Config.TipoResposta, Config.CodResposta);

        try
          Resp.Processar(ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt,
                         ACBrNFe1.WebServices.DistribuicaoDFe.Msg,
                         ACBrNFe1.WebServices.DistribuicaoDFe.NomeArq,
                         ACBrNFe1.WebServices.DistribuicaoDFe.ListaArqs);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      end;
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.EnviarEmail(const ePara, eChaveNFe: PChar; const AEnviaPDF: boolean;
                                        const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
var
  Resposta, APara, AChaveNFe, AAssunto, ACC, AAnexos, AMensagem: string;
  slMensagemEmail, slCC, slAnexos: TStringList;
  EhArquivo: boolean;
  Resp: TLibNFeResposta;
begin
  try
    APara := string(ePara);
    AChaveNFe := string(eChaveNFe);
    AAssunto := string(eAssunto);
    ACC := string(eCC);
    AAnexos := string(eAnexos);
    AMensagem := string(eMensagem);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_EnviarEmail(' + APara + ',' + AChaveNFe + ',' + BoolToStr(AEnviaPDF, 'PDF', '') + ',' + AAssunto
                 + ',' + ACC + ',' + AAnexos + ',' + AMensagem + ' )', logCompleto, True)
    else
      GravarLog('NFe_EnviarEmail', logNormal);

    NFeDM.Travar;

    try
      with NFeDM do
      begin
        EhArquivo := StringEhArquivo(AChaveNFe);

        if EhArquivo then
          VerificarArquivoExiste(AChaveNFe);

        if EhArquivo then
          ACBrNFe1.NotasFiscais.LoadFromFile(AchaveNFe);

        if ACBrNFe1.NotasFiscais.Count = 0 then
          raise EACBrLibException.Create(ErrEnvio, Format(SInfNFeCarregadas, [ACBrNFe1.NotasFiscais.Count]))
        else
        begin
          slMensagemEmail := TStringList.Create;
          slCC := TStringList.Create;
          slAnexos := TStringList.Create;

          Resp := TLibNFeResposta.Create('EnviaEmail', Config.TipoResposta, Config.CodResposta);

          try
            with ACBrNFe1 do
            begin
              slMensagemEmail.DelimitedText := sLineBreak;
              slMensagemEmail.Text := StringReplace(AMensagem, ';', sLineBreak, [rfReplaceAll]);

              slCC.DelimitedText := sLineBreak;
              slCC.Text := StringReplace(ACC, ';', sLineBreak, [rfReplaceAll]);

              slAnexos.DelimitedText := sLineBreak;
              slAnexos.Text := StringReplace(AAnexos, ';', sLineBreak, [rfReplaceAll]);

              if (AEnviaPDF) then
                NFeDM.ConfigurarImpressao('', True);
              NotasFiscais.Items[0].EnviarEmail(
                  APara,
                  AAssunto,
                  slMensagemEmail,
                  AEnviaPDF, // Enviar PDF junto
                  slCC,      // Lista com emails que serão enviado cópias - TStrings
                  slAnexos); // Lista de slAnexos - TStrings

              Resp.Msg := 'Email enviado com sucesso';
              Resposta := Resp.Gerar;

              Result := SetRetorno(ErrOK, Resposta);
            end;
          finally
            Resp.Free;
            slCC.Free;
            slAnexos.Free;
            slMensagemEmail.Free;
          end;
        end;
      end;
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.EnviarEmailEvento(const ePara, eChaveEvento, eChaveNFe: PChar; const AEnviaPDF: boolean;
                                              const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
var
  APara, AChaveEvento, AChaveNFe, AAssunto, ACC, AAnexos, AMensagem, ArqPDF: string;
  slMensagemEmail, slCC, slAnexos: TStringList;
  EhArquivo: boolean;
  Resposta: TLibNFeResposta;
begin
  try
    APara := string(ePara);
    AChaveEvento := string(eChaveEvento);
    AChaveNFe := string(eChaveNFe);
    AAssunto := string(eAssunto);
    ACC := string(eCC);
    AAnexos := string(eAnexos);
    AMensagem := string(eMensagem);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_EnviarEmailEvento(' + APara + ',' + AChaveEvento + ',' + AChaveNFe + ',' +
                 BoolToStr(AEnviaPDF, 'PDF', '') + ',' + AAssunto + ',' + ACC + ',' + AAnexos + ',' + AMensagem +
                 ' )', logCompleto, True)
    else
      GravarLog('NFe_EnviarEmailEvento', logNormal);

    NFeDM.Travar;

    try
      with NFeDM.ACBrNFe1 do
      begin
        EventoNFe.Evento.Clear;
        NotasFiscais.Clear;

        EhArquivo := StringEhArquivo(AChaveEvento);

        if EhArquivo then
          VerificarArquivoExiste(AChaveEvento);

        if EhArquivo then
          EventoNFe.LerXML(AChaveEvento);

        EhArquivo := StringEhArquivo(AChaveNFe);

        if EhArquivo then
          VerificarArquivoExiste(AChaveNFe);

        if EhArquivo then
          NotasFiscais.LoadFromFile(AchaveNFe);

        if EventoNFe.Evento.Count = 0 then
          raise EACBrLibException.Create(ErrEnvio, Format(SInfEventosCarregados, [EventoNFe.Evento.Count]))
        else
        begin
          slMensagemEmail := TStringList.Create;
          slCC := TStringList.Create;
          slAnexos := TStringList.Create;
          Resposta := TLibNFeResposta.Create('EnviaEmail', Config.TipoResposta, Config.CodResposta);

          try
            if AEnviaPDF then
            begin
              try
                NFeDM.ConfigurarImpressao('', True);
                ImprimirEventoPDF;

                ArqPDF := OnlyNumber(EventoNFe.Evento[0].Infevento.id);
                ArqPDF := PathWithDelim(DANFe.PathPDF) + ArqPDF + '-procEventoNFe.pdf';
              except
                raise EACBrLibException.Create(ErrRetorno, 'Erro ao criar o arquivo PDF');
              end;
            end;

            with mail do
            begin
              slMensagemEmail.DelimitedText := sLineBreak;
              slMensagemEmail.Text := StringReplace(AMensagem, ';', sLineBreak, [rfReplaceAll]);

              slCC.DelimitedText := sLineBreak;
              slCC.Text := StringReplace(ACC, ';', sLineBreak, [rfReplaceAll]);

              slAnexos.DelimitedText := sLineBreak;
              slAnexos.Text := StringReplace(AAnexos, ';', sLineBreak, [rfReplaceAll]);

              slAnexos.Add(AChaveEvento);

              if AEnviaPDF then
                slAnexos.Add(ArqPDF);

              try
                NFeDM.ACBrNFe1.EnviarEmail(
                    APara,
                    AAssunto,
                    slMensagemEmail,
                    slCC,      // Lista com emails que serão enviado cópias - TStrings
                    slAnexos); // Lista de slAnexos - TStrings

                Resposta.Msg := 'Email enviado com sucesso';
                Result := SetRetorno(ErrOK, Resposta.Gerar);
              except
                on E: Exception do
                  raise EACBrLibException.Create(ErrRetorno, 'Erro ao enviar email' + sLineBreak + E.Message);
              end;
            end;
          finally
            Resposta.Free;
            slCC.Free;
            slAnexos.Free;
            slMensagemEmail.Free;
          end;
        end;
      end;
    finally
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.Imprimir(const cImpressora: PChar; nNumCopias: integer; const cProtocolo, bMostrarPreview,
                                     cMarcaDagua, bViaConsumidor, bSimplificado: PChar): longint;
var
  Resposta: TLibImpressaoResposta;
  NumCopias: integer;
  Impressora, Protocolo, MostrarPreview, MarcaDagua, ViaConsumidor,
  Simplificado: string;
begin
  try
    Impressora := string(cImpressora);
    Protocolo := string(cProtocolo);
    MostrarPreview := string(bMostrarPreview);
    MarcaDagua := string(cMarcaDagua);
    ViaConsumidor := string(bViaConsumidor);
    Simplificado := string(bSimplificado);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_Imprimir(' + Impressora + ',' + IntToStr(nNumCopias) + ',' + Protocolo + ',' + MostrarPreview +
                 ',' + MarcaDagua + ',' + ViaConsumidor + ',' + Simplificado + ')', logCompleto, True)
    else
      GravarLog('NFe_Imprimir', logNormal);


    NFeDM.Travar;
    Resposta := TLibImpressaoResposta.Create(NFeDM.ACBrNFe1.NotasFiscais.Count, Config.TipoResposta, Config.CodResposta);

    try
      NFeDM.ConfigurarImpressao(Impressora, False, Protocolo, MostrarPreview, MarcaDagua, ViaConsumidor, Simplificado);
      NumCopias := NFeDM.ACBrNFe1.DANFE.NumCopias;
      if nNumCopias > 0 then
        NFeDM.ACBrNFe1.DANFE.NumCopias := nNumCopias;

      NFeDM.ACBrNFe1.NotasFiscais.Imprimir;
      Result := SetRetorno(ErrOK, Resposta.Gerar);
    finally
      NFeDM.ACBrNFe1.DANFE.NumCopias := NumCopias;
      if NFeDM.ACBrPosPrinter1.Ativo then
          NFeDM.ACBrPosPrinter1.Desativar;
      Resposta.Free;
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.ImprimirPDF: longint;
var
  Resposta: TLibImpressaoResposta;
begin
  try
    GravarLog('NFe_ImprimirPDF', logNormal);

    NFeDM.Travar;
    Resposta := TLibImpressaoResposta.Create(NFeDM.ACBrNFe1.NotasFiscais.Count, Config.TipoResposta, Config.CodResposta);

    try
      NFeDM.ConfigurarImpressao('', True);
      NFeDM.ACBrNFe1.NotasFiscais.ImprimirPDF;

      Resposta.Msg := NFeDM.ACBrNFe1.DANFE.ArquivoPDF;
      Result := SetRetorno(ErrOK, Resposta.Gerar);
    finally
      Resposta.Free;
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.ImprimirEvento(const eArquivoXmlNFe, eArquivoXmlEvento: PChar): longint;
var
  EhArquivo: boolean;
  AArquivoXmlNFe: string;
  AArquivoXmlEvento: string;
  Resposta: TLibImpressaoResposta;
begin
  try
    AArquivoXmlNFe := string(eArquivoXmlNFe);
    AArquivoXmlEvento := string(eArquivoXmlEvento);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_ImprimirEvento(' + AArquivoXmlNFe + ',' + AArquivoXmlEvento + ' )', logCompleto, True)
    else
      GravarLog('NFe_ImprimirEvento', logNormal);

    NFeDM.Travar;
    Resposta := TLibImpressaoResposta.Create(NFeDM.ACBrNFe1.EventoNFe.Evento.Count, Config.TipoResposta, Config.CodResposta);

    try
      EhArquivo := StringEhArquivo(AArquivoXmlNFe);

      if EhArquivo then
        VerificarArquivoExiste(AArquivoXmlNFe);

      if EhArquivo then
        NFeDM.ACBrNFe1.NotasFiscais.LoadFromFile(AArquivoXmlNFe);

      EhArquivo := StringEhArquivo(AArquivoXmlEvento);

      if EhArquivo then
        VerificarArquivoExiste(AArquivoXmlEvento);

      if EhArquivo then
        NFeDM.ACBrNFe1.EventoNFe.LerXML(AArquivoXmlEvento);

      NFeDM.ConfigurarImpressao;
      NFeDM.ACBrNFe1.ImprimirEvento;

      Result := SetRetorno(ErrOK, Resposta.Gerar);
    finally
      if NFeDM.ACBrPosPrinter1.Ativo then
          NFeDM.ACBrPosPrinter1.Desativar;
      Resposta.Free;
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.ImprimirEventoPDF(const eArquivoXmlNFe, eArquivoXmlEvento: PChar): longint;
var
  EhArquivo: boolean;
  AArquivoXmlNFe: string;
  AArquivoXmlEvento: string;
  Resposta: TLibImpressaoResposta;
begin
  try
    AArquivoXmlNFe := string(eArquivoXmlNFe);
    AArquivoXmlEvento := string(eArquivoXmlEvento);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_ImprimirEventoPDF(' + AArquivoXmlNFe + ',' + AArquivoXmlEvento + ' )', logCompleto, True)
    else
      GravarLog('NFe_ImprimirEventoPDF', logNormal);

    NFeDM.Travar;
    Resposta := TLibImpressaoResposta.Create(NFeDM.ACBrNFe1.EventoNFe.Evento.Count, Config.TipoResposta, Config.CodResposta);

    try
      EhArquivo := StringEhArquivo(AArquivoXmlNFe);

      if EhArquivo then
        VerificarArquivoExiste(AArquivoXmlNFe);

      if EhArquivo then
        NFeDM.ACBrNFe1.NotasFiscais.LoadFromFile(AArquivoXmlNFe);

      EhArquivo := StringEhArquivo(AArquivoXmlEvento);

      if EhArquivo then
        VerificarArquivoExiste(AArquivoXmlEvento);

      if EhArquivo then
        NFeDM.ACBrNFe1.EventoNFe.LerXML(AArquivoXmlEvento);

      NFeDM.ConfigurarImpressao('', True);
      NFeDM.ACBrNFe1.ImprimirEventoPDF;

      Resposta.Msg := NFeDM.ACBrNFe1.DANFE.ArquivoPDF;
      Result := SetRetorno(ErrOK, Resposta.Gerar);
    finally
      Resposta.Free;
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.ImprimirInutilizacao(const eArquivoXml: PChar): longint;
var
  EhArquivo: boolean;
  AArquivoXml: string;
  Resposta: TLibImpressaoResposta;
begin
  try
    AArquivoXml := string(eArquivoXml);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_ImprimirInutilizacao(' + AArquivoXml + ' )', logCompleto, True)
    else
      GravarLog('NFe_ImprimirInutilizacao', logNormal);

    EhArquivo := StringEhArquivo(AArquivoXml);

    if EhArquivo then
      VerificarArquivoExiste(AArquivoXml);

    NFeDM.Travar;
    Resposta := TLibImpressaoResposta.Create(1, Config.TipoResposta, Config.CodResposta);

    try
      if EhArquivo then
        NFeDM.ACBrNFe1.InutNFe.LerXML(AArquivoXml);

      NFeDM.ConfigurarImpressao;
      NFeDM.ACBrNFe1.ImprimirInutilizacao;

      Result := SetRetorno(ErrOK, Resposta.Gerar);
    finally
      if NFeDM.ACBrPosPrinter1.Ativo then
          NFeDM.ACBrPosPrinter1.Desativar;
      Resposta.Free;
      NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function TACBrLibNFe.ImprimirInutilizacaoPDF(const eArquivoXml: PChar): longint;
var
  EhArquivo: boolean;
  AArquivoXml: string;
  Resposta: TLibImpressaoResposta;
begin
  try
    AArquivoXml := string(eArquivoXml);

    if Config.Log.Nivel > logNormal then
      GravarLog('NFe_ImprimirInutilizacaoPDF(' + AArquivoXml + ' )', logCompleto, True)
    else
      GravarLog('NFe_ImprimirInutilizacaoPDF', logNormal);

    EhArquivo := StringEhArquivo(AArquivoXml);

    if EhArquivo then
      VerificarArquivoExiste(AArquivoXml);

    NFeDM.Travar;
    Resposta := TLibImpressaoResposta.Create(1, Config.TipoResposta, Config.CodResposta);
    try
      if EhArquivo then
        NFeDM.ACBrNFe1.InutNFe.LerXML(AArquivoXml);

      NFeDM.ConfigurarImpressao('', True);
      NFeDM.ACBrNFe1.ImprimirInutilizacaoPDF;

      Result := SetRetorno(ErrOK, Resposta.Gerar);
    finally
        Resposta.Free;
        NFeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

end.
