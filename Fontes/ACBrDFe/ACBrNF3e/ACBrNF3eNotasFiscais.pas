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

unit ACBrNF3eNotasFiscais;

interface

uses
  Classes, SysUtils, StrUtils,
  ACBrNF3eConfiguracoes, pcnNF3e,
  {$IfDef DFE_ACBR_LIBXML2}
    ACBrNF3eXmlReader, ACBrNF3eXmlWriter,
  {$Else}
     pcnNF3eR, pcnNF3eW,
  {$EndIf}
   pcnConversao, pcnAuxiliar, pcnLeitor;

type

  { NotaFiscal }

  NotaFiscal = class(TCollectionItem)
  private
    FNF3e: TNF3e;
{$IfDef DFE_ACBR_LIBXML2}
    FNF3eW: TNF3eXmlWriter;
    FNF3eR: TNF3eXmlReader;
{$Else}
    FNF3eW: TNF3eW;
    FNF3eR: TNF3eR;
{$EndIf}

    FConfiguracoes: TConfiguracoesNF3e;
    FXMLAssinado: String;
    FXMLOriginal: String;
    FAlertas: String;
    FErroValidacao: String;
    FErroValidacaoCompleto: String;
    FErroRegrasdeNegocios: String;
    FNomeArq: String;

    function GetConfirmada: Boolean;
    function GetcStat: Integer;
    function GetProcessada: Boolean;
    function GetCancelada: Boolean;

    function GetMsg: String;
    function GetNumID: String;
    function GetXMLAssinado: String;
    procedure SetXML(const AValue: String);
    procedure SetXMLOriginal(const AValue: String);
    function ValidarConcatChave: Boolean;
    function CalcularNomeArquivo: String;
    function CalcularPathArquivo: String;
  public
    constructor Create(Collection2: TCollection); override;
    destructor Destroy; override;
    procedure Imprimir;
    procedure ImprimirPDF;

    procedure Assinar;
    procedure Validar;
    function VerificarAssinatura: Boolean;
    function ValidarRegrasdeNegocios: Boolean;

    function LerXML(const AXML: String): Boolean;
    function LerArqIni(const AIniString: String): Boolean;
    function GerarNF3eIni: String;

    function GerarXML: String;
    function GravarXML(const NomeArquivo: String = ''; const PathArquivo: String = ''): Boolean;

    function GerarTXT: String;
    function GravarTXT(const NomeArquivo: String = ''; const PathArquivo: String = ''): Boolean;

    function GravarStream(AStream: TStream): Boolean;

    procedure EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings = nil;
      EnviaPDF: Boolean = True; sCC: TStrings = nil; Anexos: TStrings = nil;
      sReplyTo: TStrings = nil);

    property NomeArq: String read FNomeArq write FNomeArq;
    function CalcularNomeArquivoCompleto(NomeArquivo: String = '';
      PathArquivo: String = ''): String;

    property NF3e: TNF3e read FNF3e;

    // Atribuir a "XML", faz o componente transferir os dados lido para as propriedades internas e "XMLAssinado"
    property XML: String         read FXMLOriginal   write SetXML;
    // Atribuir a "XMLOriginal", reflete em XMLAssinado, se existir a tag de assinatura
    property XMLOriginal: String read FXMLOriginal   write SetXMLOriginal;    // Sempre deve estar em UTF8
    property XMLAssinado: String read GetXMLAssinado write FXMLAssinado;      // Sempre deve estar em UTF8
    property Confirmada: Boolean read GetConfirmada;
    property Processada: Boolean read GetProcessada;
    property Cancelada: Boolean read GetCancelada;
    property cStat: Integer read GetcStat;
    property Msg: String read GetMsg;
    property NumID: String read GetNumID;

    property Alertas: String read FAlertas;
    property ErroValidacao: String read FErroValidacao;
    property ErroValidacaoCompleto: String read FErroValidacaoCompleto;
    property ErroRegrasdeNegocios: String read FErroRegrasdeNegocios;

  end;

  { TNotasFiscais }

  TNotasFiscais = class(TOwnedCollection)
  private
    FACBrNF3e: TComponent;
    FConfiguracoes: TConfiguracoesNF3e;

    function GetItem(Index: integer): NotaFiscal;
    procedure SetItem(Index: integer; const Value: NotaFiscal);

    procedure VerificarDANF3e;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);

    procedure GerarNF3e;
    procedure Assinar;
    procedure Validar;
    function VerificarAssinatura(out Erros: String): Boolean;
    function ValidarRegrasdeNegocios(out Erros: String): Boolean;
    procedure Imprimir;
    procedure ImprimirCancelado;
    procedure ImprimirResumido;
    procedure ImprimirPDF;
    procedure ImprimirResumidoPDF;
    function Add: NotaFiscal;
    function Insert(Index: integer): NotaFiscal;

    property Items[Index: integer]: NotaFiscal read GetItem write SetItem; default;

    function GetNamePath: String; override;
    // Incluido o Parametro AGerarNF3e que determina se ap�s carregar os dados da NF3e
    // para o componente, ser� gerado ou n�o novamente o XML da NF3e.
    function LoadFromFile(const CaminhoArquivo: String; AGerarNF3e: Boolean = False): Boolean;
    function LoadFromStream(AStream: TStringStream; AGerarNF3e: Boolean = False): Boolean;
    function LoadFromString(const AXMLString: String; AGerarNF3e: Boolean = False): Boolean;
    function LoadFromIni(const AIniString: String): Boolean;

    function GerarIni: String;
    function GravarXML(const APathNomeArquivo: String = ''): Boolean;
    function GravarTXT(const APathNomeArquivo: String = ''): Boolean;

    property ACBrNF3e: TComponent read FACBrNF3e;
  end;

implementation

uses
  dateutils, IniFiles,
  synautil,
  ACBrNF3e, ACBrUtil, ACBrDFeUtil, pcnConversaoNF3e;

{ NotaFiscal }

constructor NotaFiscal.Create(Collection2: TCollection);
begin
  inherited Create(Collection2);

  FNF3e := TNF3e.Create;
  {$IfDef DFE_ACBR_LIBXML2}
    FNF3eW := TNF3eXmlWriter.Create(FNF3e);
    FNF3eR := TNF3eXmlReader.Create(FNF3e);
{$Else}
    FNF3eW := TNF3eW.Create(FNF3e);
    FNF3eR := TNF3eR.Create(FNF3e);
{$EndIf}

  FConfiguracoes := TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e).Configuracoes;

  with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
  begin
    FNF3e.infNF3e.Versao := VersaoNF3eToDbl(Configuracoes.Geral.VersaoDF);

    FNF3e.Ide.modelo  := 66;
    FNF3e.Ide.verProc := 'ACBrNF3e';
    FNF3e.Ide.tpAmb   := Configuracoes.WebServices.Ambiente;
    FNF3e.Ide.tpEmis  := Configuracoes.Geral.FormaEmissao;
  end;
end;

destructor NotaFiscal.Destroy;
begin
  FNF3eW.Free;
  FNF3eR.Free;
  FNF3e.Free;

  inherited Destroy;
end;

procedure NotaFiscal.Imprimir;
begin
  with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
  begin
    if not Assigned(DANF3e) then
      raise EACBrNF3eException.Create('Componente DANF3e n�o associado.')
    else
      DANF3e.ImprimirDANF3e(NF3e);
  end;
end;

procedure NotaFiscal.ImprimirPDF;
begin
  with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
  begin
    if not Assigned(DANF3e) then
      raise EACBrNF3eException.Create('Componente DANF3e n�o associado.')
    else
      DANF3e.ImprimirDANF3ePDF(NF3e);
  end;
end;

procedure NotaFiscal.Assinar;
var
  XMLStr: String;
  XMLUTF8: AnsiString;
  Leitor: TLeitor;
begin
  with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
  begin
    if not Assigned(SSL.AntesDeAssinar) then
      SSL.ValidarCNPJCertificado( NF3e.Emit.CNPJ );
  end;

  // Gera novamente, para processar propriedades que podem ter sido modificadas
  XMLStr := GerarXML;

  // XML j� deve estar em UTF8, para poder ser assinado //
  XMLUTF8 := ConverteXMLtoUTF8(XMLStr);

  with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
  begin
    FXMLAssinado := SSL.Assinar(String(XMLUTF8), 'NF3e', 'infNF3e');
    // SSL.Assinar() sempre responde em UTF8...
    FXMLOriginal := FXMLAssinado;

    Leitor := TLeitor.Create;
    try
      leitor.Grupo := FXMLAssinado;
      NF3e.signature.URI := Leitor.rAtributo('Reference URI=');
      NF3e.signature.DigestValue := Leitor.rCampo(tcStr, 'DigestValue');
      NF3e.signature.SignatureValue := Leitor.rCampo(tcStr, 'SignatureValue');
      NF3e.signature.X509Certificate := Leitor.rCampo(tcStr, 'X509Certificate');
    finally
      Leitor.Free;
    end;

    with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
    begin
      NF3e.infNF3eSupl.qrCodNF3e := GetURLQRCode(NF3e.Ide.cUF,
                                                 NF3e.Ide.tpAmb,
                                                 NF3e.Ide.tpEmis,
                                                 NF3e.infNF3e.ID,
                                                 NF3e.infNF3e.Versao);

      GerarXML;
    end;

    if Configuracoes.Arquivos.Salvar and
       (not Configuracoes.Arquivos.SalvarApenasNF3eProcessadas) then
    begin
      if NaoEstaVazio(NomeArq) then
        Gravar(NomeArq, FXMLAssinado)
      else
        Gravar(CalcularNomeArquivoCompleto(), FXMLAssinado);
    end;
  end;
end;

procedure NotaFiscal.Validar;
var
  Erro, AXML: String;
  NotaEhValida{, ok}: Boolean;
  ALayout: TLayOut;
  VerServ: Real;
  cUF: Integer;
begin
  AXML := FXMLAssinado;
  if AXML = '' then
    AXML := XMLOriginal;

  with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
  begin
    VerServ := FNF3e.infNF3e.Versao;
    cUF     := FNF3e.Ide.cUF;

//    if EhAutorizacao( DblToVersaoNF3e(ok, VerServ), Modelo, cUF) then
//      ALayout := LayNF3eAutorizacao
//    else
      ALayout := LayNF3eRecepcao;

    // Extraindo apenas os dados da NF3e (sem nf3eProc)
    AXML := ObterDFeXML(AXML, 'NF3e', ACBRNF3e_NAMESPACE);

    if EstaVazio(AXML) then
    begin
      Erro := ACBrStr('NF3e n�o encontrada no XML');
      NotaEhValida := False;
    end
    else
      NotaEhValida := SSL.Validar(AXML, GerarNomeArqSchema(ALayout, VerServ), Erro);

    if not NotaEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o dos dados da nota: ') +
        IntToStr(NF3e.Ide.nNF) + sLineBreak + FAlertas ;
      FErroValidacaoCompleto := FErroValidacao + sLineBreak + Erro;

      raise EACBrNF3eException.CreateDef(
        IfThen(Configuracoes.Geral.ExibirErroSchema, ErroValidacaoCompleto,
        ErroValidacao));
    end;
  end;
end;

function NotaFiscal.VerificarAssinatura: Boolean;
var
  Erro, AXML: String;
  AssEhValida: Boolean;
begin
  AXML := FXMLAssinado;
  if AXML = '' then
    AXML := XMLOriginal;

  with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
  begin
    // Extraindo apenas os dados da NF3e (sem nf3eProc)
    AXML := ObterDFeXML(AXML, 'NF3e', ACBRNF3e_NAMESPACE);

    if EstaVazio(AXML) then
    begin
      Erro := ACBrStr('NF3e n�o encontrada no XML');
      AssEhValida := False;
    end
    else
      AssEhValida := SSL.VerificarAssinatura(AXML, Erro, 'infNF3e');

    if not AssEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o da assinatura da nota: ') +
        IntToStr(NF3e.Ide.nNF) + sLineBreak + Erro;
    end;
  end;

  Result := AssEhValida;
end;

function NotaFiscal.ValidarRegrasdeNegocios: Boolean;
const
  SEM_GTIN = 'SEM GTIN';
var
  Erros: String;
  Inicio, Agora: TDateTime;
//  I, J: Integer;
//  UltVencto: TDateTime;
//  fsvTotTrib, fsvBC, fsvICMS, fsvICMSDeson, fsvBCST, fsvST, fsvProd, fsvFrete : Currency;
//  fsvSeg, fsvDesc, fsvII, fsvIPI, fsvPIS, fsvCOFINS, fsvOutro, fsvServ, fsvNF, fsvTotPag : Currency;
//  fsvFCP, fsvFCPST, fsvFCPSTRet, fsvIPIDevol, fsvDup : Currency;
//  FaturamentoDireto, NFImportacao, UFCons : Boolean;

  procedure GravaLog(AString: String);
  begin
    //DEBUG
    //Log := Log + FormatDateTime('hh:nn:ss:zzz',Now) + ' - ' + AString + sLineBreak;
  end;

  procedure AdicionaErro(const Erro: String);
  begin
    Erros := Erros + Erro + sLineBreak;
  end;

begin
  Inicio := Now;
  Agora := IncMinute(Now, 5);  //Aceita uma toler�ncia de at� 5 minutos, devido ao sincronismo de hor�rio do servidor da Empresa e o servidor da SEFAZ.
  GravaLog('Inicio da Valida��o');

  with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
  begin
    Erros := '';
    {
    GravaLog('Validar: 701-vers�o');
    if NF3e.infNF3e.Versao < 3.10 then
      AdicionaErro('701-Rejei��o: Vers�o inv�lida');

    GravaLog('Validar 512-Chave de acesso');
    if not ValidarConcatChave then  //A03-10
      AdicionaErro(
        '502-Rejei��o: Erro na Chave de Acesso - Campo Id n�o corresponde � concatena��o dos campos correspondentes');

    GravaLog('Validar: 897-C�digo do documento: ' + IntToStr(NF3e.Ide.nNF));
    if not ValidarCodigoDFe(NF3e.Ide.cNF, NF3e.Ide.nNF) then
      AdicionaErro('897-Rejei��o: C�digo num�rico em formato inv�lido ');

    GravaLog('Validar 226-IF');
    if copy(IntToStr(NF3e.Emit.EnderEmit.cMun), 1, 2) <>
      IntToStr(Configuracoes.WebServices.UFCodigo) then //B02-10
      AdicionaErro('226-Rejei��o: C�digo da UF do Emitente diverge da UF autorizadora');

    GravaLog('Validar: 703-Data hora');
    if (NF3e.Ide.dEmi > Agora) then  //B09-10
      AdicionaErro('703-Rejei��o: Data-Hora de Emiss�o posterior ao hor�rio de recebimento');

    GravaLog('Validar: 228-Data Emiss�o');
    if ((Agora - NF3e.Ide.dEmi) > 30) then  //B09-20
      AdicionaErro('228-Rejei��o: Data de Emiss�o muito atrasada');

    //GB09.02 - Data de Emiss�o posterior � 31/03/2011
    //GB09.03 - Data de Recep��o posterior � 31/03/2011 e tpAmb (B24) = 2

    GravaLog('Validar: 253-Digito Chave');
    if not ValidarChave(NF3e.infNF3e.ID) then
      AdicionaErro('253-Rejei��o: Digito Verificador da chave de acesso composta inv�lida');

    GravaLog('Validar: 270-Digito Municipio Fato Gerador');
    if not ValidarMunicipio(NF3e.Ide.cMunFG) then //B12-10
      AdicionaErro('270-Rejei��o: C�digo Munic�pio do Fato Gerador: d�gito inv�lido');

    GravaLog('Validar: 271-Municipio Fato Gerador diferente');
    if (UFparaCodigo(NF3e.Emit.EnderEmit.UF) <> StrToIntDef(
      copy(IntToStr(NF3e.Ide.cMunFG), 1, 2), 0)) then//GB12.1
      AdicionaErro('271-Rejei��o: C�digo Munic�pio do Fato Gerador: difere da UF do emitente');

    GravaLog('Validar: 570-Tipo de Emiss�o SCAN/SVC');
    if ((NF3e.Ide.tpEmis in [teSCAN, teSVCAN, teSVCRS]) and
      (Configuracoes.Geral.FormaEmissao = teNormal)) then  //B22-30
      AdicionaErro(
        '570-Rejei��o: Tipo de Emiss�o 3, 6 ou 7 s� � v�lido nas conting�ncias SCAN/SVC');

    GravaLog('Validar: 571-Tipo de Emiss�o SCAN');
    if ((NF3e.Ide.tpEmis <> teSCAN) and (Configuracoes.Geral.FormaEmissao = teSCAN))
    then  //B22-40
      AdicionaErro('571-Rejei��o: Tipo de Emiss�o informado diferente de 3 para conting�ncia SCAN');

    GravaLog('Validar: 713-Tipo de Emiss�o SCAN/SVCRS');
    if ((Configuracoes.Geral.FormaEmissao in [teSVCAN, teSVCRS]) and
      (not (NF3e.Ide.tpEmis in [teSVCAN, teSVCRS]))) then  //B22-60
      AdicionaErro('713-Rejei��o: Tipo de Emiss�o diferente de 6 ou 7 para conting�ncia da SVC acessada');

    //B23-10
    GravaLog('Validar: 252-Ambiente');
    if (NF3e.Ide.tpAmb <> Configuracoes.WebServices.Ambiente) then
      //B24-10
      AdicionaErro('252-Rejei��o: Ambiente informado diverge do Ambiente de recebimento '
        + '(Tipo do ambiente da NF3-e difere do ambiente do Web Service)');

    GravaLog('Validar: 370-Tipo de Emiss�o');
    if (NF3e.Ide.procEmi in [peAvulsaFisco, peAvulsaContribuinte]) and
      (NF3e.Ide.tpEmis <> teNormal) then //B26-30
      AdicionaErro('370-Rejei��o: Nota Fiscal Avulsa com tipo de emiss�o inv�lido');

    GravaLog('Validar: 556-Justificativa Entrada');
    if (NF3e.Ide.tpEmis = teNormal) and ((NF3e.Ide.xJust > '') or
      (NF3e.Ide.dhCont <> 0)) then
      //B28-10
      AdicionaErro(
        '556-Justificativa de entrada em conting�ncia n�o deve ser informada para tipo de emiss�o normal');

    GravaLog('Validar: 557-Justificativa Entrada');
    if (NF3e.Ide.tpEmis in [teContingencia, teFSDA, teOffLine]) and
      (NF3e.Ide.xJust = '') then //B28-20
      AdicionaErro('557-A Justificativa de entrada em conting�ncia deve ser informada');

    GravaLog('Validar: 558-Data de Entrada');
    if (NF3e.Ide.dhCont > Agora) then //B28-30
      AdicionaErro('558-Rejei��o: Data de entrada em conting�ncia posterior a data de recebimento');

    GravaLog('Validar: 569-Data Entrada conting�ncia');
    if (NF3e.Ide.dhCont > 0) and ((Agora - NF3e.Ide.dhCont) > 30) then //B28-40
      AdicionaErro('569-Rejei��o: Data de entrada em conting�ncia muito atrasada');

    GravaLog('Validar: 207-CNPJ emitente');
    // adicionado CNPJ por conta do produtor rural
    if not ValidarCNPJouCPF(NF3e.Emit.CNPJCPF) then
      AdicionaErro('207-Rejei��o: CNPJ do emitente inv�lido');

    GravaLog('Validar: 272-C�digo Munic�pio');
    if not ValidarMunicipio(NF3e.Emit.EnderEmit.cMun) then
      AdicionaErro('272-Rejei��o: C�digo Munic�pio do Emitente: d�gito inv�lido');

    GravaLog('Validar: 273-C�digo Munic�pio difere da UF');
    if (UFparaCodigo(NF3e.Emit.EnderEmit.UF) <> StrToIntDef(
      copy(IntToStr(NF3e.Emit.EnderEmit.cMun), 1, 2), 0)) then
      AdicionaErro('273-Rejei��o: C�digo Munic�pio do Emitente: difere da UF do emitente');

    GravaLog('Validar: 229-IE n�o informada');
    if EstaVazio(NF3e.Emit.IE) then
      AdicionaErro('229-Rejei��o: IE do emitente n�o informada');

    GravaLog('Validar: 209-IE inv�lida');
    if not ValidarIE(NF3e.Emit.IE,NF3e.Emit.EnderEmit.UF) then
      AdicionaErro('209-Rejei��o: IE do emitente inv�lida ');

    GravaLog('Validar: 208-CNPJ destinat�rio');
    if (Length(Trim(OnlyNumber(NF3e.Dest.CNPJCPF))) >= 14) and
      not ValidarCNPJ(NF3e.Dest.CNPJCPF) then
      AdicionaErro('208-Rejei��o: CNPJ do destinat�rio inv�lido');

    GravaLog('Validar: 513-EX');
    if (NF3e.Retirada.UF = 'EX') and
       (NF3e.Retirada.cMun <> 9999999) then
      AdicionaErro('513-Rejei��o: C�digo Munic�pio do Local de Retirada deve ser 9999999 para UF retirada = "EX"');

    GravaLog('Validar: 276-Cod Munic�pio Retirada inv�lido');
    if (NF3e.Retirada.UF <> 'EX') and
       NaoEstaVazio(NF3e.Retirada.xMun) and
       not ValidarMunicipio(NF3e.Retirada.cMun) then
      AdicionaErro('276-Rejei��o: C�digo Munic�pio do Local de Retirada: d�gito inv�lido');

    GravaLog('Validar: 277-Cod Munic�pio Retirada diferente UF');
    if NaoEstaVazio(NF3e.Retirada.UF) and
     (NF3e.Retirada.cMun > 0)then
    if (UFparaCodigo(NF3e.Retirada.UF) <> StrToIntDef(
      copy(IntToStr(NF3e.Retirada.cMun), 1, 2), 0)) then
      AdicionaErro('277-Rejei��o: C�digo Munic�pio do Local de Retirada: difere da UF do Local de Retirada');

    GravaLog('Validar: 515-Cod Munic�pio Entrega EX');
    if (NF3e.Entrega.UF = 'EX') and
       (NF3e.Entrega.cMun <> 9999999) then
      AdicionaErro('515-Rejei��o: C�digo Munic�pio do Local de Entrega deve ser 9999999 para UF entrega = "EX"');

    GravaLog('Validar: 278-Cod Munic�pio Entrega inv�lido');
    if (NF3e.Entrega.UF <> 'EX') and
       NaoEstaVazio(NF3e.Entrega.xMun) and
       not ValidarMunicipio(NF3e.Entrega.cMun) then
      AdicionaErro('278-Rejei��o: C�digo Munic�pio do Local de Entrega: d�gito inv�lido');

    GravaLog('Validar: 279-Cod Munic�pio Entrega diferente UF');
    if NaoEstaVazio(NF3e.Entrega.UF)and
      (NF3e.Entrega.cMun > 0) then
    if (UFparaCodigo(NF3e.Entrega.UF) <> StrToIntDef(
      copy(IntToStr(NF3e.Entrega.cMun), 1, 2), 0)) then
      AdicionaErro('279-Rejei��o: C�digo Munic�pio do Local de Entrega: difere da UF do Local de Entrega');

    GravaLog('Validar: 542-CNPJ Transportador');
    if NaoEstaVazio(Trim(NF3e.Transp.Transporta.CNPJCPF)) and
       (Length(Trim(OnlyNumber(NF3e.Transp.Transporta.CNPJCPF))) >= 14) and
       not ValidarCNPJ(NF3e.Transp.Transporta.CNPJCPF) then
      AdicionaErro('542-Rejei��o: CNPJ do Transportador inv�lido');

    GravaLog('Validar: 543-CPF Transportador');
    if NaoEstaVazio(Trim(NF3e.Transp.Transporta.CNPJCPF)) and
       (Length(Trim(OnlyNumber(NF3e.Transp.Transporta.CNPJCPF))) <= 11) and
       not ValidarCPF(NF3e.Transp.Transporta.CNPJCPF) then
      AdicionaErro('543-Rejei��o: CPF do Transportador inv�lido');

    GravaLog('Validar: 559-UF do Transportador');
    if NaoEstaVazio(Trim(NF3e.Transp.Transporta.IE)) and
       EstaVazio(Trim(NF3e.Transp.Transporta.UF)) then
      AdicionaErro('559-Rejei��o: UF do Transportador n�o informada');

    GravaLog('Validar: 544-IE do Transportador');
    if NaoEstaVazio(Trim(NF3e.Transp.Transporta.IE)) and
       not ValidarIE(NF3e.Transp.Transporta.IE,NF3e.Transp.Transporta.UF) then
      AdicionaErro('544-Rejei��o: IE do Transportador inv�lida');

    if (NF3e.Ide.modelo = 65) then  //Regras v�lidas apenas para NFC-e - 65
    begin
      GravaLog('Validar: 704-NFCe Data atrasada');
      if (NF3e.Ide.dEmi < IncMinute(Agora,-10)) and
        (NF3e.Ide.tpEmis in [teNormal, teSCAN, teSVCAN, teSVCRS]) then
        //B09-40
        AdicionaErro('704-Rejei��o: NFC-e com Data-Hora de emiss�o atrasada');

      GravaLog('Validar: 705-NFCe Data de entrada/saida');
      if (NF3e.Ide.dSaiEnt <> 0) then  //B10-10
        AdicionaErro('705-Rejei��o: NFC-e com data de entrada/sa�da');

      GravaLog('Validar: 706-NFCe opera��o entrada');
      if (NF3e.Ide.tpNF = tnEntrada) then  //B11-10
        AdicionaErro('706-Rejei��o: NFC-e para opera��o de entrada');

      GravaLog('Validar: 707-NFCe opera��o interestadual');
      if (NF3e.Ide.idDest <> doInterna) then  //B11-10
        AdicionaErro('707-NFC-e para opera��o interestadual ou com o exterior');

      GravaLog('Validar: 709-NFCe formato DANF3e');
      if (not (NF3e.Ide.tpImp in [tiNFCe, tiMsgEletronica])) then
        //B21-10
        AdicionaErro('709-Rejei��o: NFC-e com formato de DANF3e inv�lido');

      GravaLog('Validar: 712-NFCe conting�ncia off-line');
      if (NF3e.Ide.tpEmis = teOffLine) and
        (AnsiIndexStr(NF3e.Emit.EnderEmit.UF, ['SP']) <> -1) then  //B22-20
        AdicionaErro('712-Rejei��o: NF3-e com conting�ncia off-line');

      GravaLog('Validar: 782-NFCe e SCAN');
      if (NF3e.Ide.tpEmis = teSCAN) then //B22-50
        AdicionaErro('782-Rejei��o: NFC-e n�o � autorizada pelo SCAN');

      GravaLog('Validar: 783-NFCe e SVC');
      if (NF3e.Ide.tpEmis in [teSVCAN, teSVCRS]) then  //B22-70
        AdicionaErro('783-Rejei��o: NFC-e n�o � autorizada pela SVC');

      GravaLog('Validar: 715-NFCe finalidade');
      if (NF3e.Ide.finNF3e <> fnNormal) then  //B25-20
        AdicionaErro('715-Rejei��o: Rejei��o: NFC-e com finalidade inv�lida');

      GravaLog('Validar: 716-NFCe opera��o');
      if (NF3e.Ide.indFinal = cfNao) then //B25a-10
        AdicionaErro('716-Rejei��o: NFC-e em opera��o n�o destinada a consumidor final');

      GravaLog('Validar: 717-NFCe entrega');
      if (not (NF3e.Ide.indPres in [pcPresencial, pcEntregaDomicilio])) then
        //B25b-20
        AdicionaErro('717-Rejei��o: NFC-e em opera��o n�o presencial');

      GravaLog('Validar: 785-NFCe entrega e UF');
      if (NF3e.Ide.indPres = pcEntregaDomicilio) and
        (AnsiIndexStr(NF3e.Emit.EnderEmit.UF, ['XX']) <> -1) then
        //B25b-30  Qual estado n�o permite entrega a domic�lio?
        AdicionaErro('785-Rejei��o: NFC-e com entrega a domic�lio n�o permitida pela UF');

      GravaLog('Validar: 708-NFCe referenciada');
      if (NF3e.Ide.NFref.Count > 0) then
        AdicionaErro('708-Rejei��o: NFC-e n�o pode referenciar documento fiscal');

      GravaLog('Validar: 718-NFCe e IE de ST');
      if NaoEstaVazio(Trim(NF3e.Emit.IEST)) then
        AdicionaErro('718-Rejei��o: NFC-e n�o deve informar IE de Substituto Tribut�rio');

      GravaLog('Validar: 787-NFCe entrega e Identifica��o');
      if (NF3e.Ide.indPres = pcEntregaDomicilio) and
        EstaVazio(Trim(NF3e.Entrega.xLgr)) and
        EstaVazio(Trim(NF3e.Dest.EnderDest.xLgr)) then
        AdicionaErro('787-Rejei��o: NFC-e de entrega a domic�lio sem a identifica��o do destinat�rio');

      GravaLog('Validar: 789-NFCe e destinat�rio');
      if (NF3e.Dest.indIEDest <> inNaoContribuinte) then
        AdicionaErro('789-Rejei��o: NFC-e para destinat�rio contribuinte de ICMS');

      GravaLog('Validar: 729-NFCe IE destinat�rio');
      if NaoEstaVazio(Trim(NF3e.Dest.IE)) then
        AdicionaErro('729-Rejei��o: NFC-e com informa��o da IE do destinat�rio');

      GravaLog('Validar: 730-NFCe e SUFRAMA');
      if NaoEstaVazio(Trim(NF3e.Dest.ISUF)) then
        AdicionaErro('730-Rejei��o: NFC-e com Inscri��o Suframa');

      GravaLog('Validar: 753-NFCe e Frete');
      if (NF3e.Transp.modFrete <> mfSemFrete) and
         (NF3e.Ide.indPres <> pcEntregaDomicilio)then
        AdicionaErro('753-Rejei��o: NFC-e com Frete');

      GravaLog('Validar: 754-NFCe e dados Transporte');
      if (NF3e.Ide.indPres <> pcEntregaDomicilio) and
         ((trim(NF3e.Transp.Transporta.CNPJCPF) <> '') or
         (trim(NF3e.Transp.Transporta.xNome) <> '') or
         (trim(NF3e.Transp.Transporta.IE) <> '') or
         (trim(NF3e.Transp.Transporta.xEnder) <> '') or
         (trim(NF3e.Transp.Transporta.xMun) <> '') or
         (trim(NF3e.Transp.Transporta.UF) <> '')) then
        AdicionaErro('754-Rejei��o: NFC-e com dados do Transportador');

      GravaLog('Validar: 786-NFCe entrega domicilio e dados Transporte');
      if (NF3e.Ide.indPres = pcEntregaDomicilio) and
         ((trim(NF3e.Transp.Transporta.CNPJCPF) = '') or
         (trim(NF3e.Transp.Transporta.xNome) = '')) then
        AdicionaErro('786-Rejei��o: NFC-e de entrega a domic�lio sem dados do Transportador');

      GravaLog('Validar: 755-NFCe reten��o ICMS Transporte');
      if (NF3e.Transp.retTransp.vServ > 0) or
         (NF3e.Transp.retTransp.vBCRet > 0) or
         (NF3e.Transp.retTransp.pICMSRet > 0) or
         (NF3e.Transp.retTransp.vICMSRet > 0) or
         (Trim(NF3e.Transp.retTransp.CFOP) <> '') or
         (NF3e.Transp.retTransp.cMunFG > 0) then
        AdicionaErro('755-Rejei��o: NFC-e com dados de Reten��o do ICMS no Transporte');

      GravaLog('Validar: 756-NFCe dados veiculo Transporte');
      if (Trim(NF3e.Transp.veicTransp.placa) <> '') or
         (Trim(NF3e.Transp.veicTransp.UF) <> '') or
         (Trim(NF3e.Transp.veicTransp.RNTC) <> '') then
        AdicionaErro('756-Rejei��o: NFC-e com dados do ve�culo de Transporte');

      GravaLog('Validar: 757-NFCe dados reboque Transporte');
      if NF3e.Transp.Reboque.Count > 0 then
        AdicionaErro('757-Rejei��o: NFC-e com dados de Reboque do ve�culo de Transporte');

      GravaLog('Validar: 758-NFCe dados vag�o Transporte');
      if NaoEstaVazio(Trim(NF3e.Transp.vagao)) then
        AdicionaErro('758-Rejei��o: NFC-e com dados do Vag�o de Transporte');

      GravaLog('Validar: 759-NFCe dados Balsa Transporte');
      if NaoEstaVazio(Trim(NF3e.Transp.balsa)) then
        AdicionaErro('759-Rejei��o: NFC-e com dados da Balsa de Transporte');

      GravaLog('Validar: 760-NFCe entrega dados cobran�a');
      if (Trim(NF3e.Cobr.Fat.nFat) <> '') or
         (NF3e.Cobr.Fat.vOrig > 0) or
         (NF3e.Cobr.Fat.vDesc > 0) or
         (NF3e.Cobr.Fat.vLiq > 0) or
         (NF3e.Cobr.Dup.Count > 0) then
        AdicionaErro('760-Rejei��o: NFC-e com dados de cobran�a (Fatura, Duplicata)');

      GravaLog('Validar: 769-NFCe formas pagamento');
      if NF3e.pag.Count <= 0 then
        AdicionaErro('769-Rejei��o: NFC-e deve possuir o grupo de Formas de Pagamento');

      GravaLog('Validar: 762-NFCe dados de compra');
      if Trim(NF3e.compra.xNEmp) + Trim(NF3e.compra.xPed) + Trim(NF3e.compra.xCont) <> '' then
        AdicionaErro('762-Rejei��o: NFC-e com dados de compras (Empenho, Pedido, Contrato)');

      GravaLog('Validar: 763-NFCe dados cana');
      if not(Trim(NF3e.cana.safra) = '') or not(Trim(NF3e.cana.ref) = '') or
         (NF3e.cana.fordia.Count > 0) or (NF3e.cana.deduc.Count > 0) then
        AdicionaErro('763-Rejei��o: NFC-e com dados de aquisi��o de Cana');

    end
    else if (NF3e.Ide.modelo = 55) then  //Regras v�lidas apenas para NF3-e - 55
    begin
      GravaLog('Validar: 504-Saida > 30');
      if ((NF3e.Ide.dSaiEnt - Agora) > 30) then  //B10-20  - Facultativo
        AdicionaErro('504-Rejei��o: Data de Entrada/Sa�da posterior ao permitido');

      GravaLog('Validar: 505-Saida < 30');
      if (NF3e.Ide.dSaiEnt <> 0) and ((Agora - NF3e.Ide.dSaiEnt) > 30) then  //B10-30  - Facultativo
        AdicionaErro('505-Rejei��o: Data de Entrada/Sa�da anterior ao permitido');

      GravaLog('Validar: 506-Saida < Emissao');
      if (NF3e.Ide.dSaiEnt <> 0) and (NF3e.Ide.dSaiEnt < NF3e.Ide.dEmi) then
        //B10-40  - Facultativo
        AdicionaErro('506-Rejei��o: Data de Sa�da menor que a Data de Emiss�o');

      GravaLog('Validar: 710-Formato DANF3e');
      if (NF3e.Ide.tpImp in [tiNFCe, tiMsgEletronica]) then  //B21-20
        AdicionaErro('710-Rejei��o: NF-e com formato de DANF3e inv�lido');

      GravaLog('Validar: 711-NF3e off-line');
      if (NF3e.Ide.tpEmis = teOffLine) then  //B22-10
        AdicionaErro('711-Rejei��o: NF-e com conting�ncia off-line');

      GravaLog('Validar: 254-NF3e complementar sem referenciada');
      if (NF3e.Ide.finNF3e = fnComplementar) and (NF3e.Ide.NFref.Count = 0) then  //B25-30
        AdicionaErro('254-Rejei��o: NF-e complementar n�o possui NF referenciada');

      GravaLog('Validar: 255-NF3e complementar e muitas referenciada');
      if (NF3e.Ide.finNF3e = fnComplementar) and (NF3e.Ide.NFref.Count > 1) then  //B25-40
        AdicionaErro('255-Rejei��o: NF-e complementar possui mais de uma NF referenciada');

      GravaLog('Validar: 269-CNPJ Emitente NF3e complementar');
      if (NF3e.Ide.finNF3e = fnComplementar) and (NF3e.Ide.NFref.Count = 1) and
        (((NF3e.Ide.NFref.Items[0].RefNF.CNPJ > '') and
        (NF3e.Ide.NFref.Items[0].RefNF.CNPJ <> NF3e.Emit.CNPJCPF)) or
        ((NF3e.Ide.NFref.Items[0].RefNFP.CNPJCPF > '') and
        (NF3e.Ide.NFref.Items[0].RefNFP.CNPJCPF <> NF3e.Emit.CNPJCPF))) then
        //B25-50
        AdicionaErro(
          '269-Rejei��o: CNPJ Emitente da NF Complementar difere do CNPJ da NF Referenciada');

      GravaLog('Validar: 678-UF NF3e referenciada e complementar');
      if (NF3e.Ide.finNF3e = fnComplementar) and (NF3e.Ide.NFref.Count = 1) and
        //Testa pelo n�mero para saber se TAG foi preenchida
        (((NF3e.Ide.NFref.Items[0].RefNF.nNF > 0) and
        (NF3e.Ide.NFref.Items[0].RefNF.cUF <> UFparaCodigo(
        NF3e.Emit.EnderEmit.UF))) or ((NF3e.Ide.NFref.Items[0].RefNFP.nNF > 0) and
        (NF3e.Ide.NFref.Items[0].RefNFP.cUF <> UFparaCodigo(
        NF3e.Emit.EnderEmit.UF))))
      then  //B25-60 - Facultativo
        AdicionaErro('678-Rejei��o: NF referenciada com UF diferente da NF-e complementar');

      GravaLog('Validar: 321-NF3e devolu��o sem referenciada');
      if (NF3e.Ide.finNF3e = fnDevolucao) and (NF3e.Ide.NFref.Count = 0) then
        //B25-70
        AdicionaErro('321-Rejei��o: NF-e devolu��o n�o possui NF referenciada');

      GravaLog('Validar: 794-NF3e e domic�cio NFCe');
      if (NF3e.Ide.indPres = pcEntregaDomicilio) then //B25b-10
        AdicionaErro('794-Rejei��o: NF-e com indicativo de NFC-e com entrega a domic�lio');

      GravaLog('Validar: 237-CPF destinat�rio ');
      if (Trim(OnlyNumber(NF3e.Dest.CNPJCPF)) <> EmptyStr) and
        (Length(Trim(OnlyNumber(NF3e.Dest.CNPJCPF))) <= 11) and
        not ValidarCPF(NF3e.Dest.CNPJCPF) then
        AdicionaErro('237-Rejei��o: CPF do destinat�rio inv�lido');

      GravaLog('Validar: 721-Op.Interstadual sem CPF/CNPJ');
      if (NF3e.Ide.idDest = doInterestadual) and
         (EstaVazio(Trim(NF3e.Dest.CNPJCPF))) then
        AdicionaErro('721-Rejei��o: Opera��o interestadual deve informar CNPJ ou CPF');

      GravaLog('Validar: 723-Op.interna com idEstrangeiro');
      if (NF3e.Ide.idDest = doInterna) and
         (NaoEstaVazio(Trim(NF3e.Dest.idEstrangeiro))) and
         (NF3e.Ide.indFinal <> cfConsumidorFinal)then
        AdicionaErro('723-Rejei��o: Opera��o interna com idEstrangeiro informado deve ser para consumidor final');

      GravaLog('Validar: 724-Nome destinat�rio');
      if EstaVazio(Trim(NF3e.Dest.xNome)) then
        AdicionaErro('724-Rejei��o: NF-e sem o nome do destinat�rio');

      GravaLog('Validar: 726-Sem Endere�o destinat�rio');
      if EstaVazio(Trim(NF3e.Dest.EnderDest.xLgr)) then
        AdicionaErro('726-Rejei��o: NF-e sem a informa��o de endere�o do destinat�rio');

      GravaLog('Validar: 509-EX e munic�pio');
      if (NF3e.Dest.EnderDest.UF <> 'EX') and
         not ValidarMunicipio(NF3e.Dest.EnderDest.cMun) then
        AdicionaErro('509-Rejei��o: Informado c�digo de munic�pio diferente de "9999999" para opera��o com o exterior');

      GravaLog('Validar: 727-Op exterior e UF');
      if (NF3e.Ide.idDest = doExterior) and
         (NF3e.Dest.EnderDest.UF <> 'EX') then
        AdicionaErro('727-Rejei��o: Opera��o com Exterior e UF diferente de EX');

      GravaLog('Validar: 771-Op.Interstadual e UF EX');
      if (NF3e.Ide.idDest = doInterestadual) and
         (NF3e.Dest.EnderDest.UF = 'EX') then
        AdicionaErro('771-Rejei��o: Opera��o Interestadual e UF de destino com EX');

      GravaLog('Validar: 773-Op.Interna e UF diferente');
      if (NF3e.Ide.idDest = doInterna) and
         (NF3e.Dest.EnderDest.UF <> NF3e.Emit.EnderEmit.UF) and
         (NF3e.Ide.indPres <> pcPresencial) then
        AdicionaErro('773-Rejei��o: Opera��o Interna e UF de destino difere da UF do emitente - n�o presencial');

      GravaLog('Validar: 790-Op.Exterior e Destinat�rio ICMS');
      if (NF3e.Ide.idDest = doExterior) and
         (NF3e.Dest.indIEDest <> inNaoContribuinte) then
        AdicionaErro('790-Rejei��o: Opera��o com Exterior para destinat�rio Contribuinte de ICMS');

      if NF3e.infNF3e.Versao < 4 then
      begin
        GravaLog('Validar: 768-NF3e < 4.0 com formas de pagamento');
        if (NF3e.pag.Count > 0) then
          AdicionaErro('768-Rejei��o: NF-e n�o deve possuir o grupo de Formas de Pagamento');
      end
      else
      begin
        GravaLog('Validar: 769-NF3e >= 4.0 sem formas pagamento');
        if (NF3e.pag.Count <= 0) then
          AdicionaErro('769-Rejei��o: NF-e deve possuir o grupo de Formas de Pagamento');
      end;

      if NF3e.infNF3e.Versao >= 4 then
      begin
        GravaLog('Validar: 864-Opera��o presencial, fora do estabelecimento e n�o informada campos refNF3e');
        if (NF3e.Ide.indPres = pcPresencialForaEstabelecimento) and
           (NF3e.Ide.NFref.Count <= 0) then
          AdicionaErro('864-Rejei��o: NF-e com indicativo de Opera��o presencial, fora do estabelecimento e n�o informada NF referenciada');

        GravaLog('Validar: 868-Se opera��o interestadual(idDest=2), n�o informar os Grupos Veiculo Transporte (id:X18; veicTransp) e Grupo Reboque (id: X22)');
        if (NF3e.Ide.idDest = doInterestadual) and
           (((trim(NF3e.Transp.veicTransp.placa) <> '') or
            (trim(NF3e.Transp.veicTransp.UF) <> '') or
            (trim(NF3e.Transp.veicTransp.RNTC) <> '')) or
            (NF3e.Transp.Reboque.Count > 0)) then
          AdicionaErro('868-Rejei��o: Grupos Veiculo Transporte e Reboque n�o devem ser informados');

        if NF3e.Ide.finNF3e in [fnNormal, fnComplementar] then
        begin
          GravaLog('Validar: 895-Valor do Desconto (vDesc, id:Y05) maior que o Valor Original da Fatura (vOrig, id:Y04)');
          if (NF3e.Cobr.Fat.vDesc > NF3e.Cobr.Fat.vOrig) then
            AdicionaErro('895-Rejei��o: Valor do Desconto da Fatura maior que Valor Original da Fatura');

          GravaLog('Validar: 896-Valor L�quido da Fatura (vLiq, id:Y06) difere do Valor Original da Fatura (vOrig; id:Y04) � Valor do Desconto (vDesc, id:Y05)');
          if (NF3e.Cobr.Fat.vLiq <> (NF3e.Cobr.Fat.vOrig - NF3e.Cobr.Fat.vDesc)) then
            AdicionaErro('896-Rejei��o: Valor Liquido da Fatura difere do Valor Original menos o Valor do Desconto');

          fsvDup := 0;
          UltVencto := DateOf(NF3e.Ide.dEmi);
          for I:=0 to NF3e.Cobr.Dup.Count-1 do
          begin
            fsvDup := fsvDup + NF3e.Cobr.Dup.Items[I].vDup;

            GravaLog('Validar: 857-Se informado o Grupo Parcelas de cobran�a (tag:dup, Id:Y07), N�mero da parcela (nDup, id:Y08) n�o informado ou inv�lido.');
            if EstaVazio(NF3e.Cobr.Dup.Items[I].nDup) then
              AdicionaErro('857-Rejei��o: N�mero da parcela inv�lido ou n�o informado');

            //898 - Verificar DATA de autoriza��o

            GravaLog('Validar: 894-Se informado o grupo de Parcelas de cobran�a (tag:dup, Id:Y07) e Data de vencimento (dVenc, id:Y09) n�o informada ou menor que a Data de Emiss�o (id:B09)');
            if (NF3e.Cobr.Dup.Items[I].dVenc < DateOf(NF3e.Ide.dEmi)) then
              AdicionaErro('894-Rejei��o: Data de vencimento da parcela n�o informada ou menor que Data de Emiss�o');

            GravaLog('Validar: 867-Se informado o grupo de Parcelas de cobran�a (tag:dup, Id:Y07) e Data de vencimento (dVenc, id:Y09) n�o informada ou menor que a Data de vencimento da parcela anterior (dVenc, id:Y09)');
            if (NF3e.Cobr.Dup.Items[I].dVenc < UltVencto) then
              AdicionaErro('867-Rejei��o: Data de vencimento da parcela n�o informada ou menor que a Data de vencimento da parcela anterior');

            UltVencto := NF3e.Cobr.Dup.Items[I].dVenc;
          end;

          GravaLog('Validar: 872-Se informado o grupo de Parcelas de cobran�a (tag:dup, Id:Y07) e a soma do valor das parcelas (vDup, id: Y10) difere do Valor L�quido da Fatura (vLiq, id:Y06).');
          //porque se n�o tiver parcela n�o tem valor para ser verificado
          if (NF3e.Cobr.Dup.Count > 0) and (((NF3e.Cobr.Fat.vLiq > 0) and (fsvDup < NF3e.Cobr.Fat.vLiq)) or
             (fsvDup < (NF3e.Cobr.Fat.vOrig-NF3e.Cobr.Fat.vDesc))) then
            AdicionaErro('872-Rejei��o: Soma do valor das parcelas difere do Valor L�quido da Fatura');
        end;
      end;
    end;

    for I:=0 to NF3e.autXML.Count-1 do
    begin
      GravaLog('Validar: 325-'+IntToStr(I)+'-CPF download');
      if (Length(Trim(OnlyNumber(NF3e.autXML[I].CNPJCPF))) <= 11) and
        not ValidarCPF(NF3e.autXML[I].CNPJCPF) then
        AdicionaErro('325-Rejei��o: CPF autorizado para download inv�lido');

      GravaLog('Validar: 323-'+IntToStr(I)+'-CNPJ download');
      if (Length(Trim(OnlyNumber(NF3e.autXML[I].CNPJCPF))) > 11) and
        not ValidarCNPJ(NF3e.autXML[I].CNPJCPF) then
        AdicionaErro('323-Rejei��o: CNPJ autorizado para download inv�lido');
    end;

    fsvTotTrib := 0;
    fsvBC      := 0;
    fsvICMS    := 0;
    fsvICMSDeson    := 0;
    fsvBCST    := 0;
    fsvST      := 0;
    fsvProd    := 0;
    fsvFrete   := 0;
    fsvSeg     := 0;
    fsvDesc    := 0;
    fsvII      := 0;
    fsvIPI     := 0;
    fsvPIS     := 0;
    fsvCOFINS  := 0;
    fsvOutro   := 0;
    fsvServ    := 0;
    fsvFCP     := 0;
    fsvFCPST   := 0;
    fsvFCPSTRet:= 0;
    fsvIPIDevol:= 0;
    FaturamentoDireto := False;
    NFImportacao := False;
    UFCons := False;

    for I:=0 to NF3e.Det.Count-1 do
    begin
      with NF3e.Det[I] do
      begin
        if Trim(Prod.NCM) <> '00' then
        begin
          // validar NCM completo somente quando n�o for servi�o
          GravaLog('Validar: 777-NCM info [nItem: '+IntToStr(Prod.nItem)+']');
          if Length(Trim(Prod.NCM)) < 8 then
            AdicionaErro('777-Rejei��o: Obrigat�ria a informa��o do NCM completo [nItem: '+IntToStr(Prod.nItem)+']');
        end;

        if (NF3e.Ide.modelo = 65) then
        begin
          GravaLog('Validar: 725-NFCe CFOP invalido [nItem: '+IntToStr(Prod.nItem)+']');
          if (pos(OnlyNumber(Prod.CFOP), 'XXXX,5101,5102,5103,5104,5115,5405,5656,5667,5933') <= 0)  then
            AdicionaErro('725-Rejei��o: NFC-e com CFOP inv�lido [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 774-NFCe indicador Total [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.IndTot = itNaoSomaTotalNFe) then
            AdicionaErro('774-Rejei��o: NFC-e com indicador de item n�o participante do total [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 736-NFCe Grupo veiculos novos [nItem: '+IntToStr(Prod.nItem)+']');
          if (NaoEstaVazio(Prod.veicProd.chassi)) then
            AdicionaErro('736-Rejei��o: NFC-e com grupo de Ve�culos novos [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 737-NCM info [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.med.Count > 0) then
            AdicionaErro('737-Rejei��o: NFC-e com grupo de Medicamentos [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 738-NFCe grupo Armamentos [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.arma.Count > 0) then
            AdicionaErro('738-Rejei��o: NFC-e com grupo de Armamentos [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 348-NFCe grupo RECOPI [nItem: '+IntToStr(Prod.nItem)+']');
          if (NaoEstaVazio(Prod.nRECOPI)) then
            AdicionaErro('348-Rejei��o: NFC-e com grupo RECOPI [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 766-NFCe CST 50 [nItem: '+IntToStr(Prod.nItem)+']');
          if (Imposto.ICMS.CST = cst50) then
            AdicionaErro('766-Rejei��o: NFC-e com CST 50-Suspens�o [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 740-NFCe CST 51 [nItem: '+IntToStr(Prod.nItem)+']');
          if (Imposto.ICMS.CST = cst51) then
            AdicionaErro('740-Rejei��o: NFC-e com CST 51-Diferimento [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 741-NFCe partilha ICMS [nItem: '+IntToStr(Prod.nItem)+']');
          if (Imposto.ICMS.CST in [cstPart10,cstPart90]) then
            AdicionaErro('741-Rejei��o: NFC-e com Partilha de ICMS entre UF [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 742-NFCe grupo IPI [nItem: '+IntToStr(Prod.nItem)+']');
          if ((Imposto.IPI.cEnq  <> '') or
              (Imposto.IPI.vBC   <> 0) or
              (Imposto.IPI.qUnid <> 0) or
              (Imposto.IPI.vUnid <> 0) or
              (Imposto.IPI.pIPI  <> 0) or
              (Imposto.IPI.vIPI  <> 0)) then
            AdicionaErro('742-Rejei��o: NFC-e com grupo do IPI [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 743-NFCe grupo II [nItem: '+IntToStr(Prod.nItem)+']');
          if (Imposto.II.vBc > 0) or
             (Imposto.II.vDespAdu > 0) or
             (Imposto.II.vII > 0) or
             (Imposto.II.vIOF > 0) or
             (Copy(Prod.CFOP,1,1) = '3') then
            AdicionaErro('743-Rejei��o: NFC-e com grupo do II [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 746-NFCe grupo PIS-ST [nItem: '+IntToStr(Prod.nItem)+']');
          if (Imposto.PISST.vBc > 0) or
             (Imposto.PISST.pPis > 0) or
             (Imposto.PISST.qBCProd > 0) or
             (Imposto.PISST.vAliqProd > 0) or
             (Imposto.PISST.vPIS > 0) then
           AdicionaErro('746-Rejei��o: NFC-e com grupo do PIS-ST [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 749-NFCe grupo COFINS-ST [nItem: '+IntToStr(Prod.nItem)+']');
          if (Imposto.COFINSST.vBC > 0) or
             (Imposto.COFINSST.pCOFINS > 0) or
             (Imposto.COFINSST.qBCProd > 0) or
             (Imposto.COFINSST.vAliqProd > 0) or
             (Imposto.COFINSST.vCOFINS > 0) then
            AdicionaErro('749-Rejei��o: NFC-e com grupo da COFINS-ST [nItem: '+IntToStr(Prod.nItem)+']');
        end
        else if(NF3e.Ide.modelo = 55) then
        begin
          if (NF3e.infNF3e.Versao >= 4) then
          begin
            GravaLog('Validar: 856-Obrigat�ria a informa��o do campo vPart (id: LA03d) para produto "210203001 � GLP" (tag:cProdANP) [nItem: '+IntToStr(Prod.nItem)+']');
            if (Prod.comb.cProdANP = 210203001) and (Prod.comb.vPart <= 0) then
              AdicionaErro('856-Rejei��o: Campo valor de partida n�o preenchido para produto GLP [nItem: '+IntToStr(Prod.nItem)+']');
          end;
        end;

        GravaLog('Validar: 528-ICMS BC e Aliq [nItem: '+IntToStr(Prod.nItem)+']');
        if (Imposto.ICMS.CST in [cst00,cst10,cst20,cst70]) and
           (NF3e.Ide.finNF3e = fnNormal) and
	       (ComparaValor(Imposto.ICMS.vICMS, Imposto.ICMS.vBC * (Imposto.ICMS.pICMS/100), 0.01) <> 0) then
          AdicionaErro('528-Rejei��o: Valor do ICMS difere do produto BC e Al�quota [nItem: '+IntToStr(Prod.nItem)+']');

        GravaLog('Validar: 625-Insc.SUFRAMA [nItem: '+IntToStr(Prod.nItem)+']');
        if (Imposto.ICMS.motDesICMS = mdiSuframa) and
           (EstaVazio(NF3e.Dest.ISUF))then
          AdicionaErro('625-Rejei��o: Inscri��o SUFRAMA deve ser informada na venda com isen��o para ZFM [nItem: '+IntToStr(Prod.nItem)+']');

        GravaLog('Validar: 530-ISSQN e IM [nItem: '+IntToStr(Prod.nItem)+']');
        if EstaVazio(NF3e.Emit.IM) and
          ((Imposto.ISSQN.vBC > 0) or
           (Imposto.ISSQN.vAliq > 0) or
           (Imposto.ISSQN.vISSQN > 0) or
           (Imposto.ISSQN.cMunFG > 0) or
           (Imposto.ISSQN.cListServ <> '')) then
          AdicionaErro('530-Rejei��o: Opera��o com tributa��o de ISSQN sem informar a Inscri��o Municipal [nItem: '+IntToStr(Prod.nItem)+']');

        GravaLog('Validar: 287-Cod.Munic�pio FG [nItem: '+IntToStr(Prod.nItem)+']');
        if (Imposto.ISSQN.cMunFG > 0) and
           not ValidarMunicipio(Imposto.ISSQN.cMunFG) then
          AdicionaErro('287-Rejei��o: C�digo Munic�pio do FG - ISSQN: d�gito inv�lido [nItem: '+IntToStr(Prod.nItem)+']');

        if (NF3e.infNF3e.Versao >= 4) then
        begin
          if (Trim(Prod.cEAN) = '') then
          begin
            //somente aplicavel em produ��o a partir de 01/12/2018
            //GravaLog('Validar: 883-GTIN (cEAN) sem informa��o [nItem:' + IntToStr(I) + ']');
            //AdicionaErro('883-Rejei��o: GTIN (cEAN) sem informa��o [nItem:' + IntToStr(I) + ']');
          end
          else
          begin
            if (Prod.cEAN <> SEM_GTIN) then
            begin
              GravaLog('Validar: 611-GTIN (cEAN) inv�lido [nItem: '+IntToStr(Prod.nItem)+']');
              if not ValidarGTIN(Prod.cEAN) then
                AdicionaErro('611-Rejei��o: GTIN (cEAN) inv�lido [nItem: '+IntToStr(Prod.nItem)+']');

              GravaLog('Validar: 882-GTIN (cEAN) com prefixo inv�lido [nItem: '+IntToStr(Prod.nItem)+']');
              if not ValidarPrefixoGTIN(Prod.cEAN) then
                AdicionaErro('882-Rejei��o: GTIN (cEAN) com prefixo inv�lido [nItem: '+IntToStr(Prod.nItem)+']');

              GravaLog('Validar: 885-GTIN informado, mas n�o informado o GTIN da unidade tribut�vel [nItem: '+IntToStr(Prod.nItem)+']');
              if (Trim(Prod.cEANTrib) = '') or ((Trim(Prod.cEANTrib) = SEM_GTIN)) then
                AdicionaErro('885-Rejei��o: GTIN informado, mas n�o informado o GTIN da unidade tribut�vel [nItem: '+IntToStr(Prod.nItem)+']');
            end;
          end;

          if (Trim(Prod.cEANTrib) = '') then
          begin
            //somente aplicavel em produ��o a partir de 01/12/2018
            //GravaLog('Validar: 888-GTIN da unidade tribut�vel (cEANTrib) sem informa��o [nItem:' + IntToStr(I) + ']');
            //AdicionaErro('888-Rejei��o: GTIN da unidade tribut�vel (cEANTrib) sem informa��o [nItem: '+IntToStr(Prod.nItem)+']');
          end
          else
          begin
            if (Prod.cEANTrib <> SEM_GTIN) then
            begin
              GravaLog('Validar: 612-GTIN da unidade tribut�vel (cEANTrib) inv�lido [nItem: '+IntToStr(Prod.nItem)+']');
              if not ValidarGTIN(Prod.cEANTrib) then
                AdicionaErro('612-Rejei��o: GTIN da unidade tribut�vel (cEANTrib) inv�lido [nItem: '+IntToStr(Prod.nItem)+']');

              GravaLog('Validar: 884-GTIN da unidade tribut�vel (cEANTrib) com prefixo inv�lido [nItem: '+IntToStr(Prod.nItem)+']');
              if not ValidarPrefixoGTIN(Prod.cEANTrib) then
                AdicionaErro('884-Rejei��o: GTIN da unidade tribut�vel (cEANTrib) com prefixo inv�lido [nItem: '+IntToStr(Prod.nItem)+']');

              GravaLog('Validar: 886-GTIN da unidade tribut�vel informado, mas n�o informado o GTIN [nItem: '+IntToStr(Prod.nItem)+']');
              if (Trim(Prod.cEAN) = '') or ((Trim(Prod.cEAN) = SEM_GTIN)) then
                AdicionaErro('886-Rejei��o: GTIN da unidade tribut�vel informado, mas n�o informado o GTIN [nItem: '+IntToStr(Prod.nItem)+']');
            end;
          end;

          GravaLog('Valida��o: 889-Obrigat�ria a informa��o do GTIN para o produto [nItem: '+IntToStr(Prod.nItem)+']');
          if (Trim(Prod.cEAN) = '') then
            AdicionaErro('889-Rejei��o: Obrigat�ria a informa��o do GTIN para o produto [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 879-Se informado indEscala=N- n�o relevante (id: I05d), deve ser informado CNPJ do Fabricante da Mercadoria (id: I05e) [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.indEscala = ieNaoRelevante) and
             EstaVazio(Prod.CNPJFab) then
            AdicionaErro('879-Rejei��o: Informado item Produzido em Escala N�O Relevante e n�o informado CNPJ do Fabricante [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 489-Se informado CNPJFab (id: I05e) - CNPJ inv�lido (DV, zeros) [nItem: '+IntToStr(Prod.nItem)+']');
          if NaoEstaVazio(Prod.CNPJFab) and (not ValidarCNPJ(Prod.CNPJFab)) then
            AdicionaErro('489-Rejei��o: CNPJFab informado inv�lido (DV ou zeros) [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 854-Informado campo cProdANP (id: LA02) = 210203001 (GLP) e campo uTrib (id: I13) <> �kg� (ignorar a diferencia��o entre mai�sculas e min�sculas) [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.comb.cProdANP = 210203001) and (UpperCase(Prod.uTrib) <> 'KG') then
            AdicionaErro('854-Rejei��o: Unidade Tribut�vel (tag:uTrib) incompat�vel com produto informado [nItem: '+IntToStr(Prod.nItem)+']');

          if not UFCons then
            UFCons := (Prod.comb.UFcons <> '') and (Prod.comb.UFcons <> NF3e.emit.EnderEmit.UF);

          for J:=0 to Prod.rastro.Count-1 do
          begin
            GravaLog('Validar: 877-Data de Fabrica��o dFab (id:I83) maior que a data de processamento [nItem: '+IntToStr(Prod.nItem)+']');
            if (Prod.rastro.Items[J].dFab > NF3e.Ide.dEmi) then
              AdicionaErro('877-Rejei��o: Data de fabrica��o maior que a data de processamento [nItem: '+IntToStr(Prod.nItem)+']');

            GravaLog('Validar: 870-Informada data de validade dVal(id: I84) menor que Data de Fabrica��o dFab (id: I83) [nItem: '+IntToStr(Prod.nItem)+']');
            if (Prod.rastro.Items[J].dVal < Prod.rastro.Items[J].dFab) then
              AdicionaErro('870-Rejei��o: Data de validade incompat�vel com data de fabrica��o [nItem: '+IntToStr(Prod.nItem)+']');
          end;

          for J:=0 to Prod.med.Count-1 do
          begin
            GravaLog('Validar: 873-Se informado Grupo de Medicamentos (tag:med) obrigat�rio preenchimento do grupo rastro (id: I80) [nItem: '+IntToStr(Prod.nItem)+']');
            if NaoEstaVazio(Prod.med[J].cProdANVISA) and (Prod.rastro.Count<=0) then
              AdicionaErro('873-Rejei��o: Opera��o com medicamentos e n�o informado os campos de rastreabilidade [nItem: '+IntToStr(Prod.nItem)+']');
          end;

          GravaLog('Validar: 461-Informado percentual do GLP (id: LA03a) ou percentual de G�s Natural Nacional (id: LA03b) ou percentual de G�s Natural Importado (id: LA03c) para produto diferente de "210203001 � GLP" (tag:cProdANP) [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.comb.cProdANP <> 210203001) and ((Prod.comb.pGLP > 0) or (Prod.comb.pGNn > 0) or (Prod.comb.pGNi > 0)) then
            AdicionaErro('461-Rejei��o: Informado campos de percentual de GLP e/ou GLGNn e/ou GLGNi para produto diferente de GLP [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 855-Informado percentual do GLP (id: LA03a) ou percentual de G�s Natural Nacional (id: LA03b) ou percentual de G�s Natural Importado (id: LA03c) para produto diferente de "210203001 � GLP" (tag:cProdANP) [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.comb.cProdANP = 210203001) and ((Prod.comb.pGLP + Prod.comb.pGNn + Prod.comb.pGNi) <> 100) then
            AdicionaErro('855-Rejei��o: Somat�rio percentuais de GLP derivado do petr�leo, GLGNn e GLGNi diferente de 100 [nItem: '+IntToStr(Prod.nItem)+']');
        end;

        if Prod.IndTot = itSomaTotalNFe then
        begin
          fsvTotTrib := fsvTotTrib + Imposto.vTotTrib;
          fsvBC      := fsvBC + Imposto.ICMS.vBC;
          fsvICMS    := fsvICMS + Imposto.ICMS.vICMS;
          fsvICMSDeson := fsvICMSDeson + Imposto.ICMS.vICMSDeson;
          fsvBCST    := fsvBCST + Imposto.ICMS.vBCST;
          fsvST      := fsvST + Imposto.ICMS.vICMSST;
          fsvFrete   := fsvFrete + Prod.vFrete;
          fsvSeg     := fsvSeg + Prod.vSeg;
          fsvDesc    := fsvDesc + Prod.vDesc;
          fsvII      := fsvII + Imposto.II.vII;
          fsvIPI     := fsvIPI + Imposto.IPI.vIPI;
          fsvPIS     := fsvPIS + Imposto.PIS.vPIS;
          fsvCOFINS  := fsvCOFINS + Imposto.COFINS.vCOFINS;
          fsvOutro   := fsvOutro + Prod.vOutro;
          fsvServ    := fsvServ + Imposto.ISSQN.vBC; //VERIFICAR
          fsvFCP     := fsvFCP + Imposto.ICMS.vFCP;;
          fsvFCPST   := fsvFCPST + Imposto.ICMS.vFCPST;;
          fsvFCPSTRet:= fsvFCPSTRet + Imposto.ICMS.vFCPSTRet;;
          fsvIPIDevol:= fsvIPIDevol + vIPIDevol;

          // quando for servi�o o produto n�o soma do total de produtos, quando for nota de ajuste tamb�m ir� somar
          if (Prod.NCM <> '00') or ((Prod.NCM = '00') and (NF3e.Ide.finNF3e = fnAjuste)) then
            fsvProd := fsvProd + Prod.vProd;
        end;

        if Prod.veicProd.tpOP = toFaturamentoDireto then
          FaturamentoDireto := True;

        if Copy(Prod.CFOP,1,1) = '3' then
          NFImportacao := True;
      end;
    end;

    if not UFCons then
    begin
      GravaLog('Validar: 772-Op.Interstadual e UF igual');
      if (NF3e.Ide.idDest = doInterestadual) and
         (NF3e.Dest.EnderDest.UF = NF3e.Emit.EnderEmit.UF) and
         (NF3e.Dest.CNPJCPF <> NF3e.Emit.CNPJCPF) then
        AdicionaErro('772-Rejei��o: Opera��o Interestadual e UF de destino igual � UF do emitente');
    end;

    if FaturamentoDireto then
      fsvNF := (fsvProd+fsvFrete+fsvSeg+fsvOutro+fsvII+fsvIPI+fsvServ)-(fsvDesc+fsvICMSDeson)
    else
      fsvNF := (fsvProd+fsvST+fsvFrete+fsvSeg+fsvOutro+fsvII+fsvIPI+fsvServ+fsvFCPST+fsvIPIDevol)-(fsvDesc+fsvICMSDeson);

    GravaLog('Validar: 531-Total BC ICMS');
    if (NF3e.Total.ICMSTot.vBC <> fsvBC) then
      AdicionaErro('531-Rejei��o: Total da BC ICMS difere do somat�rio dos itens');

    GravaLog('Validar: 532-Total ICMS');
    if (NF3e.Total.ICMSTot.vICMS <> fsvICMS) then
      AdicionaErro('532-Rejei��o: Total do ICMS difere do somat�rio dos itens');

    GravaLog('Validar: 795-Total ICMS desonerado');
    if (NF3e.Total.ICMSTot.vICMSDeson <> fsvICMSDeson) then
      AdicionaErro('795-Rejei��o: Total do ICMS desonerado difere do somat�rio dos itens');

    GravaLog('Validar: 533-Total BC ICMS-ST');
    if (NF3e.Total.ICMSTot.vBCST <> fsvBCST) then
      AdicionaErro('533-Rejei��o: Total da BC ICMS-ST difere do somat�rio dos itens');

    GravaLog('Validar: 534-Total ICMS-ST');
    if (NF3e.Total.ICMSTot.vST <> fsvST) then
      AdicionaErro('534-Rejei��o: Total do ICMS-ST difere do somat�rio dos itens');

    GravaLog('Validar: 564-Total Produto/Servi�o');
    if (NF3e.Total.ICMSTot.vProd <> fsvProd) then
      AdicionaErro('564-Rejei��o: Total do Produto / Servi�o difere do somat�rio dos itens');

    GravaLog('Validar: 535-Total Frete');
    if (NF3e.Total.ICMSTot.vFrete <> fsvFrete) then
      AdicionaErro('535-Rejei��o: Total do Frete difere do somat�rio dos itens');

    GravaLog('Validar: 536-Total Seguro');
    if (NF3e.Total.ICMSTot.vSeg <> fsvSeg) then
      AdicionaErro('536-Rejei��o: Total do Seguro difere do somat�rio dos itens');

    GravaLog('Validar: 537-Total Desconto');
    if (NF3e.Total.ICMSTot.vDesc <> fsvDesc) then
      AdicionaErro('537-Rejei��o: Total do Desconto difere do somat�rio dos itens');

    GravaLog('Validar: 601-Total II');
    if (NF3e.Total.ICMSTot.vII <> fsvII) then
      AdicionaErro('601-Rejei��o: Total do II difere do somat�rio dos itens');

    GravaLog('Validar: 538-Total IPI');
    if (NF3e.Total.ICMSTot.vIPI <> fsvIPI) then
      AdicionaErro('538-Rejei��o: Total do IPI difere do somat�rio dos itens');

    GravaLog('Validar: 602-Total PIS');
    if (NF3e.Total.ICMSTot.vPIS <> fsvPIS) then
      AdicionaErro('602-Rejei��o: Total do PIS difere do somat�rio dos itens sujeitos ao ICMS');

    GravaLog('Validar: 603-Total COFINS');
    if (NF3e.Total.ICMSTot.vCOFINS <> fsvCOFINS) then
      AdicionaErro('603-Rejei��o: Total da COFINS difere do somat�rio dos itens sujeitos ao ICMS');

    GravaLog('Validar: 604-Total vOutro');
    if (NF3e.Total.ICMSTot.vOutro <> fsvOutro) then
      AdicionaErro('604-Rejei��o: Total do vOutro difere do somat�rio dos itens');

    GravaLog('Validar: 861-Total do FCP');
    if (NF3e.Total.ICMSTot.vFCP <> fsvFCP) then
      AdicionaErro('861-Rejei��o: Total do FCP difere do somat�rio dos itens');

    if (NF3e.Ide.modelo = 55) then  //Regras v�lidas apenas para NF-e - 55
    begin
      GravaLog('Validar: 862-Total do FCP ST');
      if (NF3e.Total.ICMSTot.vFCPST <> fsvFCPST) then
        AdicionaErro('862-Rejei��o: Total do FCP ST difere do somat�rio dos itens');

      GravaLog('Validar: 859-Total do FCP ST retido anteriormente');
      if (NF3e.Total.ICMSTot.vFCPSTRet <> fsvFCPSTRet) then
        AdicionaErro('859-Rejei��o: Total do FCP retido anteriormente por Substitui��o Tribut�ria difere do somat�rio dos itens');

      GravaLog('Validar: 863-Total do IPI devolvido');
      if (NF3e.Total.ICMSTot.vIPIDevol <> fsvIPIDevol) then
        AdicionaErro('863-Rejei��o: Total do IPI devolvido difere do somat�rio dos itens');
    end;

    GravaLog('Validar: 610-Total NF');
    if not NFImportacao and
       (NF3e.Total.ICMSTot.vNF <> fsvNF) then
    begin
      if (NF3e.Total.ICMSTot.vNF <> (fsvNF+fsvICMSDeson)) then
        AdicionaErro('610-Rejei��o: Total da NF difere do somat�rio dos Valores comp�e o valor Total da NF.');
    end;

    GravaLog('Validar: 685-Total Tributos');
    if (NF3e.Total.ICMSTot.vTotTrib <> fsvTotTrib) then
      AdicionaErro('685-Rejei��o: Total do Valor Aproximado dos Tributos difere do somat�rio dos itens');

    if (NF3e.Ide.modelo = 65) and (NF3e.infNF3e.Versao < 4) then
    begin
      GravaLog('Validar: 767-NFCe soma pagamentos');
      fsvTotPag := 0;
      for I := 0 to NF3e.pag.Count-1 do
      begin
        fsvTotPag :=  fsvTotPag + NF3e.pag[I].vPag;
      end;

      if (NF3e.Total.ICMSTot.vNF <> fsvTotPag) then
        AdicionaErro('767-Rejei��o: NFC-e com somat�rio dos pagamentos diferente do total da Nota Fiscal');
    end
    else if (NF3e.infNF3e.Versao >= 4) then
    begin
      case NF3e.Ide.finNF3e of
        fnNormal, fnComplementar:
        begin
          fsvTotPag := 0;
          for I := 0 to NF3e.pag.Count-1 do
          begin
            fsvTotPag :=  fsvTotPag + NF3e.pag[I].vPag;
          end;

          if (NF3e.Ide.modelo = 65) then
          begin
            GravaLog('Validar: 899-NFCe sem pagamento');
            for I := 0 to NF3e.pag.Count - 1 do
            begin
              if (NF3e.pag[I].tPag = fpSemPagamento) then
              begin
                AdicionaErro('899-Rejei��o: Informado incorretamente o campo meio de pagamento');
                Break;
              end;
            end;

            GravaLog('Validar: 865-Total dos pagamentos NFCe');
            if (fsvTotPag < NF3e.Total.ICMSTot.vNF) then
              AdicionaErro('865-Rejei��o: Total dos pagamentos menor que o total da nota');
          end;

          GravaLog('Validar: 866-Aus�ncia de troco');
          if (NF3e.pag.vTroco = 0) and (fsvTotPag > NF3e.Total.ICMSTot.vNF) then
            AdicionaErro('866-Rejei��o: Aus�ncia de troco quando o valor dos pagamentos informados for maior que o total da nota');

          GravaLog('Validar: 869-Valor do troco');
          if (NF3e.pag.vTroco > 0) and (NF3e.Total.ICMSTot.vNF <> (fsvTotPag - NF3e.pag.vTroco)) then
            AdicionaErro('869-Rejei��o: Valor do troco incorreto');

        end;

        fnDevolucao:
        begin
          GravaLog('Validar: 871-Informa��es de Pagamento');
          for I := 0 to NF3e.pag.Count-1 do
          begin
            if (NF3e.pag[I].tPag <> fpSemPagamento) then
              AdicionaErro('871-Rejei��o: O campo Meio de Pagamento deve ser preenchido com a op��o Sem Pagamento');
          end;
        end;
      end;
    end;

    //TODO: Regrar W01. Total da NF-e / ISSQN
    }
  end;

  Result := EstaVazio(Erros);

  if not Result then
  begin
    Erros := ACBrStr('Erro(s) nas Regras de neg�cios da nota: '+
                     IntToStr(NF3e.Ide.nNF) + sLineBreak +
                     Erros);
  end;

  GravaLog('Fim da Valida��o. Tempo: '+FormatDateTime('hh:nn:ss:zzz', Now - Inicio)+sLineBreak+
           'Erros:' + Erros);

  //DEBUG
  //WriteToTXT('c:\temp\Notafiscal.txt', Log);

  FErroRegrasdeNegocios := Erros;
end;

function NotaFiscal.LerXML(const AXML: String): Boolean;
{$IfNDef DFE_ACBR_LIBXML2}
var
  XMLStr: String;
{$EndIf}
begin
  XMLOriginal := AXML;  // SetXMLOriginal() ir� verificar se AXML est� em UTF8

{$IfDef DFE_ACBR_LIBXML2}
  FNF3eR.Arquivo := XMLOriginal;
{$Else}
  { Verifica se precisa converter "AXML" de UTF8 para a String nativa da IDE.
    Isso � necess�rio, para que as propriedades fiquem com a acentua��o correta }
  XMLStr := ParseText(AXML, True, XmlEhUTF8(AXML));

  {
   ****** Remo��o do NameSpace do XML ******

   XML baixados dos sites de algumas SEFAZ constuma ter ocorr�ncias do
   NameSpace em grupos diversos n�o previstos no MOC.
   Essas ocorr�ncias acabam prejudicando a leitura correta do XML.
  }
  XMLStr := StringReplace(XMLStr, ' xmlns="http://www.portalfiscal.inf.br/NF3e"', '', [rfReplaceAll]);

  FNF3eR.Leitor.Arquivo := XMLStr;
{$EndIf}
  FNF3eR.LerXml;
  Result := True;
end;

function NotaFiscal.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  sSecao, sFim, sProdID: String;
  OK: boolean;
  i: Integer;
//  SL     : TStringList;
//  J, K : Integer;
//  , sDINumber, sADINumber, sQtdVol,
//  sDupNumber, sAdittionalField, sType, sDay, sDeduc, sNVE, sCNPJCPF : String;
begin
  Result := False;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with FNF3e do
    begin
      infNF3e.versao := StringToFloatDef( INIRec.ReadString('infNF3e','versao', VersaoNF3eToStr(FConfiguracoes.Geral.VersaoDF)), 0) ;

      sSecao      := IfThen( INIRec.SectionExists('Identificacao'), 'Identificacao', 'ide');
      Ide.cNF     := INIRec.ReadInteger( sSecao,'Codigo' ,INIRec.ReadInteger( sSecao,'cNF' ,0));
      Ide.modelo  := INIRec.ReadInteger( sSecao,'Modelo' ,INIRec.ReadInteger( sSecao,'mod' ,65));
      Ide.serie   := INIRec.ReadInteger( sSecao,'Serie'  ,1);
      Ide.nNF     := INIRec.ReadInteger( sSecao,'Numero' ,INIRec.ReadInteger( sSecao,'nNF' ,0));
      Ide.dhEmi   := StringToDateTime(INIRec.ReadString( sSecao,'Emissao',INIRec.ReadString( sSecao,'dhEmi',INIRec.ReadString( sSecao,'dhEmi','0'))));
      Ide.tpEmis  := StrToTpEmis( OK,INIRec.ReadString( sSecao,'tpEmis',IntToStr(FConfiguracoes.Geral.FormaEmissaoCodigo)));
      Ide.tpAmb   := StrToTpAmb(  OK, INIRec.ReadString( sSecao,'tpAmb', TpAmbToStr(FConfiguracoes.WebServices.Ambiente)));
      Ide.finNF3e := StrToFinNF3e( OK,INIRec.ReadString( sSecao,'Finalidade',INIRec.ReadString( sSecao,'finNF3e','0')));
      Ide.verProc := INIRec.ReadString(  sSecao, 'verProc' ,'ACBrNF3e');
      Ide.dhCont  := StringToDateTime(INIRec.ReadString( sSecao,'dhCont'  ,'0'));
      Ide.xJust   := INIRec.ReadString(  sSecao,'xJust' ,'' );

      {
      sSecao := IfThen( INIRec.SectionExists('Emitente'), 'Emitente', 'emit');
      Emit.CNPJCPF := INIRec.ReadString( sSecao,'CNPJ'    ,INIRec.ReadString( sSecao,'CNPJCPF', ''));
      Emit.xNome   := INIRec.ReadString( sSecao,'Razao'   ,INIRec.ReadString( sSecao,'xNome'  , ''));
      Emit.xFant   := INIRec.ReadString( sSecao,'Fantasia',INIRec.ReadString( sSecao,'xFant'  , ''));
      Emit.IE      := INIRec.ReadString( sSecao,'IE'  ,'');
      Emit.IEST    := INIRec.ReadString( sSecao,'IEST','');
      Emit.IM      := INIRec.ReadString( sSecao,'IM'  ,'');
      Emit.CNAE    := INIRec.ReadString( sSecao,'CNAE','');
      Emit.CRT     := StrToCRT(ok, INIRec.ReadString( sSecao,'CRT','3'));

      Emit.EnderEmit.xLgr := INIRec.ReadString( sSecao, 'Logradouro' ,INIRec.ReadString(  sSecao, 'xLgr', ''));
      if (INIRec.ReadString( sSecao,'Numero', '') <> '') or (INIRec.ReadString( sSecao, 'nro', '') <> '') then
        Emit.EnderEmit.nro := INIRec.ReadString( sSecao,'Numero', INIRec.ReadString( sSecao, 'nro', ''));

      if (INIRec.ReadString( sSecao, 'Complemento', '') <> '') or (INIRec.ReadString( sSecao, 'xCpl', '') <> '') then
        Emit.EnderEmit.xCpl := INIRec.ReadString( sSecao, 'Complemento', INIRec.ReadString( sSecao, 'xCpl', ''));

      Emit.EnderEmit.xBairro := INIRec.ReadString(  sSecao,'Bairro'     ,INIRec.ReadString(  sSecao,'xBairro',''));
      Emit.EnderEmit.cMun    := INIRec.ReadInteger( sSecao,'CidadeCod'  ,INIRec.ReadInteger( sSecao,'cMun'   ,0));
      Emit.EnderEmit.xMun    := INIRec.ReadString(  sSecao,'Cidade'     ,INIRec.ReadString(  sSecao,'xMun'   ,''));
      Emit.EnderEmit.UF      := INIRec.ReadString(  sSecao,'UF'         ,'');
      Emit.EnderEmit.CEP     := INIRec.ReadInteger( sSecao,'CEP'        ,0);
      Emit.EnderEmit.cPais   := INIRec.ReadInteger( sSecao,'PaisCod'    ,INIRec.ReadInteger( sSecao,'cPais'    ,1058));
      Emit.EnderEmit.xPais   := INIRec.ReadString(  sSecao,'Pais'       ,INIRec.ReadString(  sSecao,'xPais'    ,'BRASIL'));
      Emit.EnderEmit.fone    := INIRec.ReadString(  sSecao,'Fone'       ,'');

      Ide.cUF    := INIRec.ReadInteger( sSecao,'cUF'       ,UFparaCodigo(Emit.EnderEmit.UF));
      Ide.cMunFG := INIRec.ReadInteger( sSecao,'CidadeCod' ,INIRec.ReadInteger( sSecao,'cMunFG' ,Emit.EnderEmit.cMun));

      if INIRec.ReadString( 'Avulsa', 'CNPJ', '') <> '' then
      begin
        Avulsa.CNPJ    := INIRec.ReadString( 'Avulsa', 'CNPJ', '');
        Avulsa.xOrgao  := INIRec.ReadString( 'Avulsa', 'xOrgao', '');
        Avulsa.matr    := INIRec.ReadString( 'Avulsa', 'matr', '');
        Avulsa.xAgente := INIRec.ReadString( 'Avulsa', 'xAgente', '');
        Avulsa.fone    := INIRec.ReadString( 'Avulsa', 'fone', '');
        Avulsa.UF      := INIRec.ReadString( 'Avulsa', 'UF', '');
        Avulsa.nDAR    := INIRec.ReadString( 'Avulsa', 'nDAR', '');
        Avulsa.dEmi    := StringToDateTime(INIRec.ReadString( 'Avulsa', 'dEmi', '0'));
        Avulsa.vDAR    := StringToFloatDef(INIRec.ReadString( 'Avulsa', 'vDAR', ''), 0);
        Avulsa.repEmi  := INIRec.ReadString( 'Avulsa', 'repEmi','');
        Avulsa.dPag    := StringToDateTime(INIRec.ReadString( 'Avulsa', 'dPag', '0'));
      end;

      sSecao := IfThen( INIRec.SectionExists('Destinatario'),'Destinatario','dest');
      Dest.idEstrangeiro     := INIRec.ReadString(  sSecao,'idEstrangeiro','');
      Dest.CNPJCPF           := INIRec.ReadString(  sSecao,'CNPJ'       ,INIRec.ReadString(  sSecao,'CNPJCPF',INIRec.ReadString(  sSecao,'CPF','')));
      Dest.xNome             := INIRec.ReadString(  sSecao,'NomeRazao'  ,INIRec.ReadString(  sSecao,'xNome'  ,''));
      Dest.indIEDest         := StrToindIEDest(OK,INIRec.ReadString( sSecao,'indIEDest','1'));
      Dest.IE                := INIRec.ReadString(  sSecao,'IE'         ,'');
      Dest.ISUF              := INIRec.ReadString(  sSecao,'ISUF'       ,'');
      Dest.Email             := INIRec.ReadString(  sSecao,'Email'      ,'');

      Dest.EnderDest.xLgr := INIRec.ReadString(  sSecao, 'Logradouro' ,INIRec.ReadString( sSecao, 'xLgr', ''));
      if (INIRec.ReadString(sSecao, 'Numero', '') <> '') or (INIRec.ReadString(sSecao, 'nro', '') <> '') then
        Dest.EnderDest.nro := INIRec.ReadString(  sSecao, 'Numero', INIRec.ReadString(sSecao, 'nro', ''));

      if (INIRec.ReadString(sSecao, 'Complemento', '') <> '') or (INIRec.ReadString(sSecao, 'xCpl', '') <> '') then
        Dest.EnderDest.xCpl := INIRec.ReadString( sSecao, 'Complemento', INIRec.ReadString(sSecao,'xCpl',''));

      Dest.EnderDest.xBairro := INIRec.ReadString(  sSecao,'Bairro'     ,INIRec.ReadString(  sSecao,'xBairro',''));
      Dest.EnderDest.cMun    := INIRec.ReadInteger( sSecao,'CidadeCod'  ,INIRec.ReadInteger( sSecao,'cMun'   ,0));
      Dest.EnderDest.xMun    := INIRec.ReadString(  sSecao,'Cidade'     ,INIRec.ReadString(  sSecao,'xMun'   ,''));
      Dest.EnderDest.UF      := INIRec.ReadString(  sSecao,'UF'         ,'');
      Dest.EnderDest.CEP     := INIRec.ReadInteger( sSecao,'CEP'       ,0);
      Dest.EnderDest.cPais   := INIRec.ReadInteger( sSecao,'PaisCod'    ,INIRec.ReadInteger(sSecao,'cPais',1058));
      Dest.EnderDest.xPais   := INIRec.ReadString(  sSecao,'Pais'       ,INIRec.ReadString( sSecao,'xPais','BRASIL'));
      Dest.EnderDest.Fone    := INIRec.ReadString(  sSecao,'Fone'       ,'');

      sCNPJCPF := INIRec.ReadString( 'Retirada','CNPJ',INIRec.ReadString( 'Retirada','CPF',INIRec.ReadString( 'Retirada','CNPJCPF','')));
      if sCNPJCPF <> '' then
      begin
        Retirada.CNPJCPF := sCNPJCPF;
        Retirada.xNome   := INIRec.ReadString( 'Retirada','xNome','');
        Retirada.xLgr    := INIRec.ReadString( 'Retirada','xLgr','');
        Retirada.nro     := INIRec.ReadString( 'Retirada','nro' ,'');
        Retirada.xCpl    := INIRec.ReadString( 'Retirada','xCpl','');
        Retirada.xBairro := INIRec.ReadString( 'Retirada','xBairro','');
        Retirada.cMun    := INIRec.ReadInteger('Retirada','cMun',0);
        Retirada.xMun    := INIRec.ReadString( 'Retirada','xMun','');
        Retirada.UF      := INIRec.ReadString( 'Retirada','UF'  ,'');
        Retirada.CEP     := INIRec.ReadInteger('Retirada','CEP',0);
        Retirada.cPais   := INIRec.ReadInteger('Retirada','PaisCod',INIRec.ReadInteger('Retirada','cPais',1058));
        Retirada.xPais   := INIRec.ReadString( 'Retirada','Pais',INIRec.ReadString( 'Retirada','xPais','BRASIL'));
        Retirada.Fone    := INIRec.ReadString( 'Retirada','Fone','');
        Retirada.Email   := INIRec.ReadString( 'Retirada','Email','');
        Retirada.IE      := INIRec.ReadString( 'Retirada','IE'  ,'');
      end;

      sCNPJCPF := INIRec.ReadString(  'Entrega','CNPJ',INIRec.ReadString(  'Entrega','CPF',INIRec.ReadString(  'Entrega','CNPJCPF','')));
      if sCNPJCPF <> '' then
      begin
        Entrega.CNPJCPF := sCNPJCPF;
        Entrega.xNome   := INIRec.ReadString( 'Entrega','xNome','');
        Entrega.xLgr    := INIRec.ReadString(  'Entrega','xLgr','');
        Entrega.nro     := INIRec.ReadString(  'Entrega','nro' ,'');
        Entrega.xCpl    := INIRec.ReadString(  'Entrega','xCpl','');
        Entrega.xBairro := INIRec.ReadString(  'Entrega','xBairro','');
        Entrega.cMun    := INIRec.ReadInteger( 'Entrega','cMun',0);
        Entrega.xMun    := INIRec.ReadString(  'Entrega','xMun','');
        Entrega.UF      := INIRec.ReadString(  'Entrega','UF','');
        Entrega.CEP     := INIRec.ReadInteger('Entrega','CEP',0);
        Entrega.cPais   := INIRec.ReadInteger('Entrega','PaisCod',INIRec.ReadInteger('Entrega','cPais',1058));
        Entrega.xPais   := INIRec.ReadString( 'Entrega','Pais',INIRec.ReadString( 'Entrega','xPais','BRASIL'));
        Entrega.Fone    := INIRec.ReadString( 'Entrega','Fone','');
        Entrega.Email   := INIRec.ReadString( 'Entrega','Email','');
        Entrega.IE      := INIRec.ReadString( 'Entrega','IE'  ,'');
      end;
      }
      I := 1 ;
      while true do
      begin
        sSecao := 'autXML'+IntToStrZero(I,3) ;
        sFim     := OnlyNumber(INIRec.ReadString( sSecao ,'CNPJ',INIRec.ReadString(  sSecao,'CPF',INIRec.ReadString(  sSecao,'CNPJCPF','FIM'))));
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break ;

//        with autXML.New do
//          CNPJCPF := sFim;

        Inc(I);
      end;

      I := 1 ;
      while true do
      begin
        sSecao := IfThen( INIRec.SectionExists('Produto'+IntToStrZero(I,3)), 'Produto', 'det');
        sSecao := sSecao+IntToStrZero(I,3) ;
        sProdID  := INIRec.ReadString(sSecao,'Codigo',INIRec.ReadString( sSecao,'cProd','FIM')) ;
        if sProdID = 'FIM' then
          break ;
        {
        with Det.New do
        begin
          Prod.nItem := I;
          infAdProd  := INIRec.ReadString(sSecao,'infAdProd','');

          Prod.cProd := INIRec.ReadString( sSecao,'Codigo'   ,INIRec.ReadString( sSecao,'cProd'   ,''));
          if (Length(INIRec.ReadString( sSecao,'EAN','')) > 0) or (Length(INIRec.ReadString( sSecao,'cEAN','')) > 0)  then
            Prod.cEAN := INIRec.ReadString( sSecao,'EAN'      ,INIRec.ReadString( sSecao,'cEAN'      ,''));

          Prod.xProd    := INIRec.ReadString( sSecao,'Descricao',INIRec.ReadString( sSecao,'xProd',''));
          Prod.NCM      := INIRec.ReadString( sSecao,'NCM'      ,'');
          Prod.CEST     := INIRec.ReadString( sSecao,'CEST'     ,'');
          Prod.indEscala:= StrToIndEscala(OK, INIRec.ReadString( sSecao,'indEscala' ,'') );
          Prod.CNPJFab  := INIRec.ReadString( sSecao,'CNPJFab'   ,'');
          Prod.cBenef   := INIRec.ReadString( sSecao,'cBenef'    ,'');
          Prod.EXTIPI   := INIRec.ReadString( sSecao,'EXTIPI'      ,'');
          Prod.CFOP     := INIRec.ReadString( sSecao,'CFOP'     ,'');
          Prod.uCom     := INIRec.ReadString( sSecao,'Unidade'  ,INIRec.ReadString( sSecao,'uCom'  ,''));
          Prod.qCom     := StringToFloatDef( INIRec.ReadString(sSecao,'Quantidade'   ,INIRec.ReadString(sSecao,'qCom'  ,'')) ,0) ;
          Prod.vUnCom   := StringToFloatDef( INIRec.ReadString(sSecao,'ValorUnitario',INIRec.ReadString(sSecao,'vUnCom','')) ,0) ;
          Prod.vProd    := StringToFloatDef( INIRec.ReadString(sSecao,'ValorTotal'   ,INIRec.ReadString(sSecao,'vProd' ,'')) ,0) ;

          if Length(INIRec.ReadString( sSecao,'cEANTrib','')) > 0 then
            Prod.cEANTrib      := INIRec.ReadString( sSecao,'cEANTrib'      ,'');

          Prod.uTrib     := INIRec.ReadString( sSecao,'uTrib'  , Prod.uCom);
          Prod.qTrib     := StringToFloatDef( INIRec.ReadString(sSecao,'qTrib'  ,''), Prod.qCom);
          Prod.vUnTrib   := StringToFloatDef( INIRec.ReadString(sSecao,'vUnTrib','') ,Prod.vUnCom) ;
          Prod.vFrete    := StringToFloatDef( INIRec.ReadString(sSecao,'vFrete','') ,0) ;
          Prod.vSeg      := StringToFloatDef( INIRec.ReadString(sSecao,'vSeg','') ,0) ;
          Prod.vDesc     := StringToFloatDef( INIRec.ReadString(sSecao,'ValorDesconto',INIRec.ReadString(sSecao,'vDesc','')) ,0) ;
          Prod.vOutro    := StringToFloatDef( INIRec.ReadString(sSecao,'vOutro','') ,0) ;
          Prod.IndTot    := StrToindTot(OK,INIRec.ReadString(sSecao,'indTot','1'));
          Prod.xPed      := INIRec.ReadString( sSecao,'xPed'    ,'');
          Prod.nItemPed  := INIRec.ReadString( sSecao,'nItemPed','');
          Prod.nFCI      := INIRec.ReadString( sSecao,'nFCI','');  //NF3e3
          Prod.nRECOPI   := INIRec.ReadString( sSecao,'nRECOPI','');  //NF3e3

          pDevol    := StringToFloatDef( INIRec.ReadString(sSecao,'pDevol','') ,0);
          vIPIDevol := StringToFloatDef( INIRec.ReadString(sSecao,'vIPIDevol','') ,0);

          Imposto.vTotTrib := StringToFloatDef( INIRec.ReadString(sSecao,'vTotTrib','') ,0) ;

          J := 1 ;
          while true do
          begin
            sSecao := 'NVE'+IntToStrZero(I,3)+IntToStrZero(J,3) ;
            sNVE     := INIRec.ReadString(sSecao,'NVE','') ;
            if (sNVE <> '') then
              Prod.NVE.New.NVE := sNVE
            else
              Break;

            Inc(J);
          end;

          J := 1 ;
          while true do
          begin
            sSecao  := 'rastro'+IntToStrZero(I,3)+IntToStrZero(J,3) ;
            sFim    := INIRec.ReadString(sSecao,'nLote','') ;
            if (sFim <> '') then
               with Prod.rastro.New do
               begin
                 nLote    := sFim;
                 qLote    := StringToFloatDef( INIRec.ReadString( sSecao,'qLote',''), 0 );
                 dFab     := StringToDateTime( INIRec.ReadString( sSecao,'dFab','0') );
                 dVal     := StringToDateTime( INIRec.ReadString( sSecao,'dVal','0') );
                 cAgreg   := INIRec.ReadString( sSecao,'cAgreg','');
               end
            else
               Break;
            Inc(J);
          end;

          J := 1 ;
          while true do
          begin
            sSecao  := 'DI'+IntToStrZero(I,3)+IntToStrZero(J,3) ;
            sDINumber := INIRec.ReadString(sSecao,'NumeroDI',INIRec.ReadString(sSecao,'nDi','')) ;

            if sDINumber <> '' then
            begin
              with Prod.DI.New do
              begin
                nDi         := sDINumber;
                dDi         := StringToDateTime(INIRec.ReadString(sSecao,'DataRegistroDI'  ,INIRec.ReadString(sSecao,'dDi'  ,'0')));
                xLocDesemb  := INIRec.ReadString(sSecao,'LocalDesembaraco',INIRec.ReadString(sSecao,'xLocDesemb',''));
                UFDesemb    := INIRec.ReadString(sSecao,'UFDesembaraco'   ,INIRec.ReadString(sSecao,'UFDesemb'   ,''));
                dDesemb     := StringToDateTime(INIRec.ReadString(sSecao,'DataDesembaraco',INIRec.ReadString(sSecao,'dDesemb','0')));

                tpViaTransp  := StrToTipoViaTransp(OK,INIRec.ReadString(sSecao,'tpViaTransp',''));
                vAFRMM       := StringToFloatDef( INIRec.ReadString(sSecao,'vAFRMM','') ,0) ;
                tpIntermedio := StrToTipoIntermedio(OK,INIRec.ReadString(sSecao,'tpIntermedio',''));
                CNPJ         := INIRec.ReadString(sSecao,'CNPJ','');
                UFTerceiro   := INIRec.ReadString(sSecao,'UFTerceiro','');

                cExportador := INIRec.ReadString(sSecao,'CodigoExportador',INIRec.ReadString(sSecao,'cExportador',''));

                K := 1 ;
                while true do
                begin
                  sSecao   := IfThen( INIRec.SectionExists('LADI'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3)), 'LADI', 'adi');
                  sSecao   := sSecao+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3)  ;
                  sADINumber := INIRec.ReadString(sSecao,'NumeroAdicao',INIRec.ReadString(sSecao,'nAdicao','FIM')) ;
                  if (sADINumber = 'FIM') or (Length(sADINumber) <= 0) then
                    break;

                  with adi.New do
                  begin
                    nAdicao     := StrToInt(sADINumber);
                    nSeqAdi     := INIRec.ReadInteger( sSecao,'nSeqAdi',K);
                    cFabricante := INIRec.ReadString(  sSecao,'CodigoFabricante',INIRec.ReadString(  sSecao,'cFabricante',''));
                    vDescDI     := StringToFloatDef( INIRec.ReadString(sSecao,'DescontoADI',INIRec.ReadString(sSecao,'vDescDI','')) ,0);
                    nDraw       := INIRec.ReadString( sSecao,'nDraw','');
                  end;

                  Inc(K)
                end;
              end;
            end
            else
              Break;

            Inc(J);
          end;

          J := 1 ;
          while true do
          begin
            sSecao := 'detExport'+IntToStrZero(I,3)+IntToStrZero(J,3) ;
            sFim     := INIRec.ReadString(sSecao,'nRE','FIM');
            if (sFim = 'FIM') or (Length(sFim) <= 0) then
            begin
              sFim     := INIRec.ReadString(sSecao,'nDraw','FIM');
              if (sFim = 'FIM') or (Length(sFim) <= 0) then
                break ;
            end;

            with Prod.detExport.New do
            begin
              nDraw   := INIRec.ReadString( sSecao,'nDraw','');
              nRE     := INIRec.ReadString( sSecao,'nRE','');
              chNF3e   := INIRec.ReadString( sSecao,'chNF3e','');
              qExport := StringToFloatDef( INIRec.ReadString(sSecao,'qExport','') ,0);
            end;

            Inc(J);
          end;

          sSecao := 'impostoDevol'+IntToStrZero(I,3) ;
          sFim   := INIRec.ReadString( sSecao,'pDevol','FIM') ;
          if ((sFim <> 'FIM') and ( Length(sFim) > 0 ))  then
          begin
            pDevol    := StringToFloatDef( INIRec.ReadString(sSecao,'pDevol','') ,0);
            vIPIDevol := StringToFloatDef( INIRec.ReadString(sSecao,'vIPIDevol','') ,0);
          end;

          sSecao := IfThen( INIRec.SectionExists('Veiculo'+IntToStrZero(I,3)), 'Veiculo', 'veicProd');
          sSecao := sSecao+IntToStrZero(I,3) ;
          sFim     := INIRec.ReadString( sSecao,'Chassi','FIM') ;
          if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
          begin
            with Prod.veicProd do
            begin
              tpOP    := StrTotpOP(OK,INIRec.ReadString( sSecao,'tpOP','0'));
              chassi  := sFim;
              cCor    := INIRec.ReadString( sSecao,'cCor'   ,'');
              xCor    := INIRec.ReadString( sSecao,'xCor'   ,'');
              pot     := INIRec.ReadString( sSecao,'pot'    ,'');
              Cilin   := INIRec.ReadString( sSecao,'CM3'    ,INIRec.ReadString( sSecao,'Cilin'  ,''));
              pesoL   := INIRec.ReadString( sSecao,'pesoL'  ,'');
              pesoB   := INIRec.ReadString( sSecao,'pesoB'  ,'');
              nSerie  := INIRec.ReadString( sSecao,'nSerie' ,'');
              tpComb  := INIRec.ReadString( sSecao,'tpComb' ,'');
              nMotor  := INIRec.ReadString( sSecao,'nMotor' ,'');
              CMT     := INIRec.ReadString( sSecao,'CMKG'   ,INIRec.ReadString( sSecao,'CMT'    ,''));
              dist    := INIRec.ReadString( sSecao,'dist'   ,'');
//             RENAVAM := INIRec.ReadString( sSecao,'RENAVAM','');
              anoMod  := INIRec.ReadInteger(sSecao,'anoMod' ,0);
              anoFab  := INIRec.ReadInteger(sSecao,'anoFab' ,0);
              tpPint  := INIRec.ReadString( sSecao,'tpPint' ,'');
              tpVeic  := INIRec.ReadInteger(sSecao,'tpVeic' ,0);
              espVeic := INIRec.ReadInteger(sSecao,'espVeic',0);
              VIN     := INIRec.ReadString( sSecao,'VIN'    ,'');
              condVeic := StrTocondVeic(OK,INIRec.ReadString( sSecao,'condVeic','1'));
              cMod    := INIRec.ReadString( sSecao,'cMod'   ,'');
              cCorDENATRAN := INIRec.ReadString( sSecao,'cCorDENATRAN','');
              lota    := INIRec.ReadInteger(sSecao,'lota'   ,0);
              tpRest  := INIRec.ReadInteger(sSecao,'tpRest' ,0);
            end;
          end;

          J := 1 ;
          while true do
          begin
            sSecao := IfThen( INIRec.SectionExists('Medicamento'+IntToStrZero(I,3)+IntToStrZero(J,3)), 'Medicamento', 'med');
            sSecao := sSecao+IntToStrZero(I,3)+IntToStrZero(J,3) ;
            sFim     := INIRec.ReadString(sSecao,'cProdANVISA','FIM') ;
            if (sFim = 'FIM') or (Length(sFim) <= 0) then
              break;

            with Prod.med.New do
            begin
              nLote := INIRec.ReadString(sSecao,'nLote','') ;
              cProdANVISA:=  sFim;
              xMotivoIsencao := INIRec.ReadString(sSecao,'xMotivoIsencao','') ;
              qLote := StringToFloatDef(INIRec.ReadString( sSecao,'qLote',''),0) ;
              dFab  := StringToDateTime(INIRec.ReadString( sSecao,'dFab','0')) ;
              dVal  := StringToDateTime(INIRec.ReadString( sSecao,'dVal','0')) ;
              vPMC  := StringToFloatDef(INIRec.ReadString( sSecao,'vPMC',''),0) ;
            end;

            Inc(J)
          end;

          J := 1 ;
          while true do
          begin
            sSecao := 'Arma'+IntToStrZero(I,3)+IntToStrZero(J,3) ;
            sFim     := INIRec.ReadString(sSecao,'nSerie','FIM') ;
            if (sFim = 'FIM') or (Length(sFim) <= 0) then
              break;

            with Prod.arma.New do
            begin
              tpArma := StrTotpArma(OK,INIRec.ReadString( sSecao,'tpArma','0')) ;
              nSerie := sFim;
              nCano  := INIRec.ReadString( sSecao,'nCano','') ;
              descr  := INIRec.ReadString( sSecao,'descr','') ;
            end;

            Inc(J)
          end;

          sSecao := IfThen( INIRec.SectionExists('Combustivel'+IntToStrZero(I,3)), 'Combustivel', 'comb');
          sSecao := sSecao+IntToStrZero(I,3) ;
          sFim     := INIRec.ReadString( sSecao,'cProdANP','FIM') ;
          if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
          begin
            with Prod.comb do
            begin
              cProdANP := INIRec.ReadInteger( sSecao,'cProdANP',0) ;
              pMixGN   := StringToFloatDef(INIRec.ReadString( sSecao,'pMixGN',''),0) ;
              descANP  := INIRec.ReadString(  sSecao,'descANP'   ,'');
              pGLP     := StringToFloatDef( INIRec.ReadString( sSecao,'pGLP'   ,''), 0);
              pGNn     := StringToFloatDef( INIRec.ReadString( sSecao,'pGNn'   ,''), 0);
              pGNi     := StringToFloatDef( INIRec.ReadString( sSecao,'pGNi'   ,''), 0);
              vPart    := StringToFloatDef( INIRec.ReadString( sSecao,'vPart'  ,''), 0);
              CODIF    := INIRec.ReadString(  sSecao,'CODIF'   ,'') ;
              qTemp    := StringToFloatDef(INIRec.ReadString( sSecao,'qTemp',''),0) ;
              UFcons   := INIRec.ReadString( sSecao,'UFCons','') ;

              sSecao := 'CIDE'+IntToStrZero(I,3) ;
              CIDE.qBCprod   := StringToFloatDef(INIRec.ReadString( sSecao,'qBCprod'  ,''),0) ;
              CIDE.vAliqProd := StringToFloatDef(INIRec.ReadString( sSecao,'vAliqProd',''),0) ;
              CIDE.vCIDE     := StringToFloatDef(INIRec.ReadString( sSecao,'vCIDE'    ,''),0) ;

              sSecao := 'encerrante'+IntToStrZero(I,3) ;
              encerrante.nBico    := INIRec.ReadInteger( sSecao,'nBico'  ,0) ;
              encerrante.nBomba   := INIRec.ReadInteger( sSecao,'nBomba' ,0) ;
              encerrante.nTanque  := INIRec.ReadInteger( sSecao,'nTanque',0) ;
              encerrante.vEncIni  := StringToFloatDef(INIRec.ReadString( sSecao,'vEncIni',''),0) ;
              encerrante.vEncFin  := StringToFloatDef(INIRec.ReadString( sSecao,'vEncFin',''),0) ;

              sSecao := 'ICMSComb'+IntToStrZero(I,3) ;
              ICMS.vBCICMS   := StringToFloatDef(INIRec.ReadString( sSecao,'vBCICMS'  ,''),0) ;
              ICMS.vICMS     := StringToFloatDef(INIRec.ReadString( sSecao,'vICMS'    ,''),0) ;
              ICMS.vBCICMSST := StringToFloatDef(INIRec.ReadString( sSecao,'vBCICMSST',''),0) ;
              ICMS.vICMSST   := StringToFloatDef(INIRec.ReadString( sSecao,'vICMSST'  ,''),0) ;

              sSecao := 'ICMSInter'+IntToStrZero(I,3) ;
              sFim     := INIRec.ReadString( sSecao,'vBCICMSSTDest','FIM') ;
              if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
              begin
                ICMSInter.vBCICMSSTDest := StringToFloatDef(sFim,0) ;
                ICMSInter.vICMSSTDest   := StringToFloatDef(INIRec.ReadString( sSecao,'vICMSSTDest',''),0) ;
              end;

              sSecao := 'ICMSCons'+IntToStrZero(I,3) ;
              sFim   := INIRec.ReadString( sSecao,'vBCICMSSTCons','FIM') ;
              if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
              begin
                ICMSCons.vBCICMSSTCons := StringToFloatDef(sFim,0) ;
                ICMSCons.vICMSSTCons   := StringToFloatDef(INIRec.ReadString( sSecao,'vICMSSTCons',''),0) ;
                ICMSCons.UFcons        := INIRec.ReadString( sSecao,'UFCons','') ;
              end;
            end;
          end;

          with Imposto do
          begin
            sSecao := 'ICMS'+IntToStrZero(I,3) ;
            //sFim     := INIRec.ReadString( sSecao,'CST',INIRec.ReadString(sSecao,'CSOSN','FIM')) ;

            sFim     := INIRec.ReadString( sSecao,'CST','FIM') ;
            if (sFim = 'FIM') or ( Length(sFim) = 0 ) then
              sFim     := INIRec.ReadString(sSecao,'CSOSN','FIM');

            if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
            begin
              with ICMS do
              begin
                ICMS.orig       := StrToOrig(     OK, INIRec.ReadString(sSecao,'Origem'    ,INIRec.ReadString(sSecao,'orig'    ,'0' ) ));
                CST             := StrToCSTICMS(  OK, INIRec.ReadString(sSecao,'CST'       ,'00'));
                CSOSN           := StrToCSOSNIcms(OK, INIRec.ReadString(sSecao,'CSOSN'     ,''  ));
                ICMS.modBC      := StrTomodBC(    OK, INIRec.ReadString(sSecao,'Modalidade',INIRec.ReadString(sSecao,'modBC','0' ) ));
                ICMS.pRedBC     := StringToFloatDef( INIRec.ReadString(sSecao,'PercentualReducao',INIRec.ReadString(sSecao,'pRedBC','')) ,0);
                ICMS.vBC        := StringToFloatDef( INIRec.ReadString(sSecao,'ValorBase',INIRec.ReadString(sSecao,'vBC'  ,'')) ,0);
                ICMS.pICMS      := StringToFloatDef( INIRec.ReadString(sSecao,'Aliquota' ,INIRec.ReadString(sSecao,'pICMS','')) ,0);
                ICMS.vICMS      := StringToFloatDef( INIRec.ReadString(sSecao,'Valor'    ,INIRec.ReadString(sSecao,'vICMS','')) ,0);
                ICMS.vBCFCP     := StringToFloatDef( INIRec.ReadString( sSecao,'ValorBaseFCP', INIRec.ReadString(sSecao,'vBCFCP','')) ,0) ;
                ICMS.pFCP       := StringToFloatDef( INIRec.ReadString( sSecao,'PercentualFCP', INIRec.ReadString(sSecao,'pFCP','')) ,0) ;
                ICMS.vFCP       := StringToFloatDef( INIRec.ReadString( sSecao,'ValorFCP', INIRec.ReadString(sSecao,'vFCP','')) ,0) ;
                ICMS.modBCST    := StrTomodBCST(OK, INIRec.ReadString(sSecao,'ModalidadeST',INIRec.ReadString(sSecao,'modBCST','0')));
                ICMS.pMVAST     := StringToFloatDef( INIRec.ReadString(sSecao,'PercentualMargemST' ,INIRec.ReadString(sSecao,'pMVAST' ,'')) ,0);
                ICMS.pRedBCST   := StringToFloatDef( INIRec.ReadString(sSecao,'PercentualReducaoST',INIRec.ReadString(sSecao,'pRedBCST','')) ,0);
                ICMS.vBCST      := StringToFloatDef( INIRec.ReadString(sSecao,'ValorBaseST',INIRec.ReadString(sSecao,'vBCST','')) ,0);
                ICMS.pICMSST    := StringToFloatDef( INIRec.ReadString(sSecao,'AliquotaST' ,INIRec.ReadString(sSecao,'pICMSST' ,'')) ,0);
                ICMS.vICMSST    := StringToFloatDef( INIRec.ReadString(sSecao,'ValorST'    ,INIRec.ReadString(sSecao,'vICMSST'    ,'')) ,0);
                ICMS.vBCFCPST   := StringToFloatDef( INIRec.ReadString( sSecao,'ValorBaseFCPST', INIRec.ReadString(sSecao,'vBCFCPST','')) ,0) ;
                ICMS.pFCPST     := StringToFloatDef( INIRec.ReadString( sSecao,'PercentualFCPST', INIRec.ReadString(sSecao,'pFCPST','')) ,0) ;
                ICMS.vFCPST     := StringToFloatDef( INIRec.ReadString( sSecao,'ValorFCPST', INIRec.ReadString(sSecao,'vFCPST','')) ,0) ;
                ICMS.UFST       := INIRec.ReadString(sSecao,'UFST'    ,'');
                ICMS.pBCOp      := StringToFloatDef( INIRec.ReadString(sSecao,'pBCOp'    ,'') ,0);
                ICMS.vBCSTRet   := StringToFloatDef( INIRec.ReadString(sSecao,'vBCSTRet','') ,0);
                ICMS.pST        := StringToFloatDef( INIRec.ReadString(sSecao,'pST','') ,0);
                ICMS.vICMSSTRet := StringToFloatDef( INIRec.ReadString(sSecao,'vICMSSTRet','') ,0);
                ICMS.vBCFCPSTRet:= StringToFloatDef( INIRec.ReadString( sSecao,'ValorBaseFCPSTRes', INIRec.ReadString(sSecao,'vBCFCPSTRet','')) ,0) ;
                ICMS.pFCPSTRet  := StringToFloatDef( INIRec.ReadString( sSecao,'PercentualFCPSTRet', INIRec.ReadString(sSecao,'pFCPSTRet','')) ,0) ;
                ICMS.vFCPSTRet  := StringToFloatDef( INIRec.ReadString( sSecao,'ValorFCPSTRet', INIRec.ReadString(sSecao,'vFCPSTRet','')) ,0) ;
                ICMS.motDesICMS := StrTomotDesICMS(OK, INIRec.ReadString(sSecao,'motDesICMS','0'));
                ICMS.pCredSN    := StringToFloatDef( INIRec.ReadString(sSecao,'pCredSN','') ,0);
                ICMS.vCredICMSSN:= StringToFloatDef( INIRec.ReadString(sSecao,'vCredICMSSN','') ,0);
                ICMS.vBCSTDest  := StringToFloatDef( INIRec.ReadString(sSecao,'vBCSTDest','') ,0);
                ICMS.vICMSSTDest:= StringToFloatDef( INIRec.ReadString(sSecao,'vICMSSTDest','') ,0);
                ICMS.vICMSDeson := StringToFloatDef( INIRec.ReadString(sSecao,'vICMSDeson','') ,0);
                ICMS.vICMSOp    := StringToFloatDef( INIRec.ReadString(sSecao,'vICMSOp','') ,0);
                ICMS.pDif       := StringToFloatDef( INIRec.ReadString(sSecao,'pDif','') ,0);
                ICMS.vICMSDif   := StringToFloatDef( INIRec.ReadString(sSecao,'vICMSDif','') ,0);

                ICMS.pRedBCEfet := StringToFloatDef( INIRec.ReadString(sSecao,'pRedBCEfet','') ,0);
                ICMS.vBCEfet    := StringToFloatDef( INIRec.ReadString(sSecao,'vBCEfet','') ,0);
                ICMS.pICMSEfet  := StringToFloatDef( INIRec.ReadString(sSecao,'pICMSEfet','') ,0);
                ICMS.vICMSEfet  := StringToFloatDef( INIRec.ReadString(sSecao,'vICMSEfet','') ,0);

                ICMS.vICMSSubstituto := StringToFloatDef( INIRec.ReadString(sSecao,'vICMSSubstituto','') ,0);
              end;
            end;

            sSecao := 'ICMSUFDest'+IntToStrZero(I,3);
            sFim     := INIRec.ReadString(sSecao,'vBCUFDest','FIM');
            if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
            begin
              with ICMSUFDest do
              begin
                vBCUFDest      := StringToFloatDef(INIRec.ReadString(sSecao, 'vBCUFDest', ''), 0);
                vBCFCPUFDest   := StringToFloatDef( INIRec.ReadString(sSecao,'vBCFCPUFDest','') ,0);
                pFCPUFDest     := StringToFloatDef(INIRec.ReadString(sSecao, 'pFCPUFDest', ''), 0);
                pICMSUFDest    := StringToFloatDef(INIRec.ReadString(sSecao, 'pICMSUFDest', ''), 0);
                pICMSInter     := StringToFloatDef(INIRec.ReadString(sSecao, 'pICMSInter', ''), 0);
                pICMSInterPart := StringToFloatDef(INIRec.ReadString(sSecao, 'pICMSInterPart', ''), 0);
                vFCPUFDest     := StringToFloatDef(INIRec.ReadString(sSecao, 'vFCPUFDest', ''), 0);
                vICMSUFDest    := StringToFloatDef(INIRec.ReadString(sSecao, 'vICMSUFDest', ''), 0);
                vICMSUFRemet   := StringToFloatDef(INIRec.ReadString(sSecao, 'vICMSUFRemet', ''), 0);
              end;
            end;

            sSecao := 'IPI'+IntToStrZero(I,3) ;
            sFim   := INIRec.ReadString( sSecao,'CST','FIM') ;
            if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
            begin
              with IPI do
              begin
                CST      := StrToCSTIPI(OK, INIRec.ReadString( sSecao,'CST','')) ;
                if OK then
                begin
                  clEnq    := INIRec.ReadString(  sSecao,'ClasseEnquadramento',INIRec.ReadString(  sSecao,'clEnq'   ,''));
                  CNPJProd := INIRec.ReadString(  sSecao,'CNPJProdutor'       ,INIRec.ReadString(  sSecao,'CNPJProd',''));
                  cSelo    := INIRec.ReadString(  sSecao,'CodigoSeloIPI'      ,INIRec.ReadString(  sSecao,'cSelo'   ,''));
                  qSelo    := INIRec.ReadInteger( sSecao,'QuantidadeSelos'    ,INIRec.ReadInteger( sSecao,'qSelo'   ,0));
                  cEnq     := INIRec.ReadString(  sSecao,'CodigoEnquadramento',INIRec.ReadString(  sSecao,'cEnq'    ,''));
                  vBC      := StringToFloatDef( INIRec.ReadString(sSecao,'ValorBase'   ,INIRec.ReadString(sSecao,'vBC'   ,'')) ,0);
                  qUnid    := StringToFloatDef( INIRec.ReadString(sSecao,'Quantidade'  ,INIRec.ReadString(sSecao,'qUnid' ,'')) ,0);
                  vUnid    := StringToFloatDef( INIRec.ReadString(sSecao,'ValorUnidade',INIRec.ReadString(sSecao,'vUnid' ,'')) ,0);
                  pIPI     := StringToFloatDef( INIRec.ReadString(sSecao,'Aliquota'    ,INIRec.ReadString(sSecao,'pIPI'  ,'')) ,0);
                  vIPI     := StringToFloatDef( INIRec.ReadString(sSecao,'Valor'       ,INIRec.ReadString(sSecao,'vIPI'  ,'')) ,0);
                end;
              end;
            end;

            sSecao := 'II'+IntToStrZero(I,3) ;
            sFim     := INIRec.ReadString( sSecao,'ValorBase',INIRec.ReadString( sSecao,'vBC','FIM')) ;
            if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
            begin
              with II do
              begin
                vBc      := StringToFloatDef( INIRec.ReadString(sSecao,'ValorBase'          ,INIRec.ReadString(sSecao,'vBC'     ,'')) ,0);
                vDespAdu := StringToFloatDef( INIRec.ReadString(sSecao,'ValorDespAduaneiras',INIRec.ReadString(sSecao,'vDespAdu','')) ,0);
                vII      := StringToFloatDef( INIRec.ReadString(sSecao,'ValorII'            ,INIRec.ReadString(sSecao,'vII'     ,'')) ,0);
                vIOF     := StringToFloatDef( INIRec.ReadString(sSecao,'ValorIOF'           ,INIRec.ReadString(sSecao,'vIOF'    ,'')) ,0);
              end;
            end;

            sSecao := 'PIS'+IntToStrZero(I,3) ;
            sFim     := INIRec.ReadString( sSecao,'CST','FIM') ;
            if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
            begin
              with PIS do
              begin
                CST :=  StrToCSTPIS(OK, INIRec.ReadString( sSecao,'CST',''));
                if OK then
                begin
                  PIS.vBC       := StringToFloatDef( INIRec.ReadString(sSecao,'ValorBase'    ,INIRec.ReadString(sSecao,'vBC'      ,'')) ,0);
                  PIS.pPIS      := StringToFloatDef( INIRec.ReadString(sSecao,'Aliquota'     ,INIRec.ReadString(sSecao,'pPIS'     ,'')) ,0);
                  PIS.qBCProd   := StringToFloatDef( INIRec.ReadString(sSecao,'Quantidade'   ,INIRec.ReadString(sSecao,'qBCProd'  ,'')) ,0);
                  PIS.vAliqProd := StringToFloatDef( INIRec.ReadString(sSecao,'ValorAliquota',INIRec.ReadString(sSecao,'vAliqProd','')) ,0);
                  PIS.vPIS      := StringToFloatDef( INIRec.ReadString(sSecao,'Valor'        ,INIRec.ReadString(sSecao,'vPIS'     ,'')) ,0);
                end;
              end;
            end;

            sSecao := 'PISST'+IntToStrZero(I,3) ;
            sFim     := INIRec.ReadString( sSecao,'ValorBase','F')+ INIRec.ReadString( sSecao,'Quantidade','IM') ;
            if (sFim = 'FIM') then
              sFim   := INIRec.ReadString( sSecao,'vBC','F')+ INIRec.ReadString( sSecao,'qBCProd','IM') ;

            if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
            begin
              with PISST do
              begin
                vBc       := StringToFloatDef( INIRec.ReadString(sSecao,'ValorBase'    ,INIRec.ReadString(sSecao,'vBC'      ,'')) ,0);
                pPis      := StringToFloatDef( INIRec.ReadString(sSecao,'AliquotaPerc' ,INIRec.ReadString(sSecao,'pPis'     ,'')) ,0);
                qBCProd   := StringToFloatDef( INIRec.ReadString(sSecao,'Quantidade'   ,INIRec.ReadString(sSecao,'qBCProd'  ,'')) ,0);
                vAliqProd := StringToFloatDef( INIRec.ReadString(sSecao,'AliquotaValor',INIRec.ReadString(sSecao,'vAliqProd','')) ,0);
                vPIS      := StringToFloatDef( INIRec.ReadString(sSecao,'ValorPISST'   ,INIRec.ReadString(sSecao,'vPIS'     ,'')) ,0);
              end;
            end;

            sSecao := 'COFINS'+IntToStrZero(I,3) ;
            sFim     := INIRec.ReadString( sSecao,'CST','FIM') ;
            if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
            begin
              with COFINS do
              begin
                CST := StrToCSTCOFINS(OK, INIRec.ReadString( sSecao,'CST',''));
                if OK then
                begin
                  COFINS.vBC       := StringToFloatDef( INIRec.ReadString(sSecao,'ValorBase'    ,INIRec.ReadString(sSecao,'vBC'      ,'')) ,0);
                  COFINS.pCOFINS   := StringToFloatDef( INIRec.ReadString(sSecao,'Aliquota'     ,INIRec.ReadString(sSecao,'pCOFINS'  ,'')) ,0);
                  COFINS.qBCProd   := StringToFloatDef( INIRec.ReadString(sSecao,'Quantidade'   ,INIRec.ReadString(sSecao,'qBCProd'  ,'')) ,0);
                  COFINS.vAliqProd := StringToFloatDef( INIRec.ReadString(sSecao,'ValorAliquota',INIRec.ReadString(sSecao,'vAliqProd','')) ,0);
                  COFINS.vCOFINS   := StringToFloatDef( INIRec.ReadString(sSecao,'Valor'        ,INIRec.ReadString(sSecao,'vCOFINS'  ,'')) ,0);
                end;
              end;
            end;

            sSecao := 'COFINSST'+IntToStrZero(I,3) ;
            sFim     := INIRec.ReadString( sSecao,'ValorBase','F')+ INIRec.ReadString( sSecao,'Quantidade','IM');
            if (sFim = 'FIM') then
              sFim   := INIRec.ReadString( sSecao,'vBC','F')+ INIRec.ReadString( sSecao,'qBCProd','IM') ;

            if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
            begin
              with COFINSST do
              begin
                vBC       := StringToFloatDef( INIRec.ReadString(sSecao,'ValorBase'    ,INIRec.ReadString(sSecao,'vBC'      ,'')) ,0);
                pCOFINS   := StringToFloatDef( INIRec.ReadString(sSecao,'AliquotaPerc' ,INIRec.ReadString(sSecao,'pCOFINS'  ,'')) ,0);
                qBCProd   := StringToFloatDef( INIRec.ReadString(sSecao,'Quantidade'   ,INIRec.ReadString(sSecao,'qBCProd'  ,'')) ,0);
                vAliqProd := StringToFloatDef( INIRec.ReadString(sSecao,'AliquotaValor',INIRec.ReadString(sSecao,'vAliqProd','')) ,0);
                vCOFINS   := StringToFloatDef( INIRec.ReadString(sSecao,'ValorCOFINSST',INIRec.ReadString(sSecao,'vCOFINS'  ,'')) ,0);
              end;
            end;

            sSecao := 'ISSQN'+IntToStrZero(I,3) ;
            sFim     := INIRec.ReadString( sSecao,'ValorBase',INIRec.ReadString(sSecao,'vBC'   ,'FIM')) ;
            if (sFim = 'FIM') then
              sFim := INIRec.ReadString( sSecao,'vBC','FIM');

            if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
            begin
              with ISSQN do
              begin
                if StringToFloatDef( INIRec.ReadString(sSecao,'ValorBase',INIRec.ReadString(sSecao,'vBC','')) ,0) > 0 then
                begin
                  vBC       := StringToFloatDef( INIRec.ReadString(sSecao,'ValorBase'   ,INIRec.ReadString(sSecao,'vBC'   ,'')) ,0);
                  vAliq     := StringToFloatDef( INIRec.ReadString(sSecao,'Aliquota'    ,INIRec.ReadString(sSecao,'vAliq' ,'')) ,0);
                  vISSQN    := StringToFloatDef( INIRec.ReadString(sSecao,'ValorISSQN'  ,INIRec.ReadString(sSecao,'vISSQN','')) ,0);
                  cMunFG    := StrToInt( INIRec.ReadString(sSecao,'MunicipioFatoGerador',INIRec.ReadString(sSecao,'cMunFG','')));
                  cListServ := INIRec.ReadString(sSecao,'CodigoServico',INIRec.ReadString(sSecao,'cListServ',''));
                  cSitTrib  := StrToISSQNcSitTrib( OK,INIRec.ReadString(sSecao,'cSitTrib','')) ;
                  vDeducao    := StringToFloatDef( INIRec.ReadString(sSecao,'ValorDeducao'   ,INIRec.ReadString(sSecao,'vDeducao'   ,'')) ,0);
                  vOutro      := StringToFloatDef( INIRec.ReadString(sSecao,'ValorOutro'   ,INIRec.ReadString(sSecao,'vOutro'   ,'')) ,0);
                  vDescIncond := StringToFloatDef( INIRec.ReadString(sSecao,'ValorDescontoIncondicional'   ,INIRec.ReadString(sSecao,'vDescIncond'   ,'')) ,0);
                  vDescCond   := StringToFloatDef( INIRec.ReadString(sSecao,'vDescontoCondicional'   ,INIRec.ReadString(sSecao,'vDescCond'   ,'')) ,0);
                  vISSRet     := StringToFloatDef( INIRec.ReadString(sSecao,'ValorISSRetido'   ,INIRec.ReadString(sSecao,'vISSRet'   ,'')) ,0);
                  indISS      := StrToindISS( OK,INIRec.ReadString(sSecao,'indISS','')) ;
                  cServico    := INIRec.ReadString(sSecao,'cServico','');
                  cMun        := INIRec.ReadInteger(sSecao,'cMun',0);
                  cPais       := INIRec.ReadInteger(sSecao,'cPais',1058);
                  nProcesso   := INIRec.ReadString(sSecao,'nProcesso','');
                  indIncentivo := StrToindIncentivo( OK,INIRec.ReadString(sSecao,'indIncentivo','')) ;
                end;
              end;
            end;
          end;
        end;
        }
        Inc( I ) ;
      end ;
      {
      Total.ICMSTot.vBC     := StringToFloatDef( INIRec.ReadString('Total','BaseICMS'     ,INIRec.ReadString('Total','vBC'     ,'')) ,0) ;
      Total.ICMSTot.vICMS   := StringToFloatDef( INIRec.ReadString('Total','ValorICMS'    ,INIRec.ReadString('Total','vICMS'   ,'')) ,0) ;
      Total.ICMSTot.vICMSDeson := StringToFloatDef( INIRec.ReadString('Total','vICMSDeson',''),0) ;
      Total.ICMSTot.vFCP       := StringToFloatDef( INIRec.ReadString('Total','ValorFCP',  INIRec.ReadString('Total','vFCP','')) ,0) ;
      Total.ICMSTot.vBCST   := StringToFloatDef( INIRec.ReadString('Total','BaseICMSSubstituicao' ,INIRec.ReadString('Total','vBCST','')) ,0) ;
      Total.ICMSTot.vST     := StringToFloatDef( INIRec.ReadString('Total','ValorICMSSubstituicao',INIRec.ReadString('Total','vST'  ,'')) ,0) ;
      Total.ICMSTot.vFCPST  := StringToFloatDef( INIRec.ReadString('Total','ValorFCPST',INIRec.ReadString('Total','vFCPST'  ,'')) ,0) ;
      Total.ICMSTot.vFCPSTRet:= StringToFloatDef( INIRec.ReadString('Total','ValorFCPSTRet',INIRec.ReadString('Total','vFCPSTRet'  ,'')) ,0) ;
      Total.ICMSTot.vProd   := StringToFloatDef( INIRec.ReadString('Total','ValorProduto' ,INIRec.ReadString('Total','vProd'  ,'')) ,0) ;
      Total.ICMSTot.vFrete  := StringToFloatDef( INIRec.ReadString('Total','ValorFrete'   ,INIRec.ReadString('Total','vFrete' ,'')) ,0) ;
      Total.ICMSTot.vSeg    := StringToFloatDef( INIRec.ReadString('Total','ValorSeguro'  ,INIRec.ReadString('Total','vSeg'   ,'')) ,0) ;
      Total.ICMSTot.vDesc   := StringToFloatDef( INIRec.ReadString('Total','ValorDesconto',INIRec.ReadString('Total','vDesc'  ,'')) ,0) ;
      Total.ICMSTot.vII     := StringToFloatDef( INIRec.ReadString('Total','ValorII'      ,INIRec.ReadString('Total','vII'    ,'')) ,0) ;
      Total.ICMSTot.vIPI    := StringToFloatDef( INIRec.ReadString('Total','ValorIPI'     ,INIRec.ReadString('Total','vIPI'   ,'')) ,0) ;
      Total.ICMSTot.vIPIDevol:= StringToFloatDef( INIRec.ReadString('Total','ValorIPIDevol',INIRec.ReadString('Total','vIPIDevol'  ,'')) ,0) ;
      Total.ICMSTot.vPIS    := StringToFloatDef( INIRec.ReadString('Total','ValorPIS'     ,INIRec.ReadString('Total','vPIS'   ,'')) ,0) ;
      Total.ICMSTot.vCOFINS := StringToFloatDef( INIRec.ReadString('Total','ValorCOFINS'  ,INIRec.ReadString('Total','vCOFINS','')) ,0) ;
      Total.ICMSTot.vOutro  := StringToFloatDef( INIRec.ReadString('Total','ValorOutrasDespesas',INIRec.ReadString('Total','vOutro','')) ,0) ;
      Total.ICMSTot.vNF     := StringToFloatDef( INIRec.ReadString('Total','ValorNota'    ,INIRec.ReadString('Total','vNF'    ,'')) ,0) ;
      Total.ICMSTot.vTotTrib:= StringToFloatDef( INIRec.ReadString('Total','vTotTrib'     ,''),0) ;
      Total.ICMSTot.vFCPUFDest  := StringToFloatDef( INIRec.ReadString('Total','vFCPUFDest',''),0);
      Total.ICMSTot.vICMSUFDest := StringToFloatDef( INIRec.ReadString('Total','vICMSUFDest',''),0);
      Total.ICMSTot.vICMSUFRemet:= StringToFloatDef( INIRec.ReadString('Total','vICMSUFRemet',''),0);

      Total.ISSQNtot.vServ  := StringToFloatDef( INIRec.ReadString('Total','ValorServicos',INIRec.ReadString('ISSQNtot','vServ','')) ,0) ;
      Total.ISSQNTot.vBC    := StringToFloatDef( INIRec.ReadString('Total','ValorBaseISS' ,INIRec.ReadString('ISSQNtot','vBC'  ,'')) ,0) ;
      Total.ISSQNTot.vISS   := StringToFloatDef( INIRec.ReadString('Total','ValorISSQN'   ,INIRec.ReadString('ISSQNtot','vISS' ,'')) ,0) ;
      Total.ISSQNTot.vPIS   := StringToFloatDef( INIRec.ReadString('Total','ValorPISISS'  ,INIRec.ReadString('ISSQNtot','vPIS' ,'')) ,0) ;
      Total.ISSQNTot.vCOFINS := StringToFloatDef( INIRec.ReadString('Total','ValorCONFINSISS',INIRec.ReadString('ISSQNtot','vCOFINS','')) ,0) ;
      Total.ISSQNtot.dCompet     := StringToDateTime(INIRec.ReadString('ISSQNtot','dCompet','0'));
      Total.ISSQNtot.vDeducao    := StringToFloatDef( INIRec.ReadString('ISSQNtot','vDeducao'   ,'') ,0) ;
      Total.ISSQNtot.vOutro      := StringToFloatDef( INIRec.ReadString('ISSQNtot','vOutro'   ,'') ,0) ;
      Total.ISSQNtot.vDescIncond := StringToFloatDef( INIRec.ReadString('ISSQNtot','vDescIncond'   ,'') ,0) ;
      Total.ISSQNtot.vDescCond   := StringToFloatDef( INIRec.ReadString('ISSQNtot','vDescCond'   ,'') ,0) ;
      Total.ISSQNtot.vISSRet     := StringToFloatDef( INIRec.ReadString('ISSQNtot','vISSRet'   ,'') ,0) ;
      Total.ISSQNtot.cRegTrib    := StrToRegTribISSQN( OK,INIRec.ReadString('ISSQNtot','cRegTrib','1')) ;

      Total.retTrib.vRetPIS    := StringToFloatDef( INIRec.ReadString('retTrib','vRetPIS'   ,'') ,0) ;
      Total.retTrib.vRetCOFINS := StringToFloatDef( INIRec.ReadString('retTrib','vRetCOFINS','') ,0) ;
      Total.retTrib.vRetCSLL   := StringToFloatDef( INIRec.ReadString('retTrib','vRetCSLL'  ,'') ,0) ;
      Total.retTrib.vBCIRRF    := StringToFloatDef( INIRec.ReadString('retTrib','vBCIRRF'   ,'') ,0) ;
      Total.retTrib.vIRRF      := StringToFloatDef( INIRec.ReadString('retTrib','vIRRF'     ,'') ,0) ;
      Total.retTrib.vBCRetPrev := StringToFloatDef( INIRec.ReadString('retTrib','vBCRetPrev','') ,0) ;
      Total.retTrib.vRetPrev   := StringToFloatDef( INIRec.ReadString('retTrib','vRetPrev'  ,'') ,0) ;

      sSecao := IfThen( INIRec.SectionExists('Transportador'), 'Transportador', 'transp');
      Transp.modFrete := StrTomodFrete(OK, INIRec.ReadString(sSecao,'FretePorConta',INIRec.ReadString(sSecao,'modFrete','0')));
      Transp.Transporta.CNPJCPF  := INIRec.ReadString(sSecao,'CNPJCPF'  ,'');
      Transp.Transporta.xNome    := INIRec.ReadString(sSecao,'NomeRazao',INIRec.ReadString(sSecao,'xNome',''));
      Transp.Transporta.IE       := INIRec.ReadString(sSecao,'IE'       ,'');
      Transp.Transporta.xEnder   := INIRec.ReadString(sSecao,'Endereco' ,INIRec.ReadString(sSecao,'xEnder',''));
      Transp.Transporta.xMun     := INIRec.ReadString(sSecao,'Cidade'   ,INIRec.ReadString(sSecao,'xMun',''));
      Transp.Transporta.UF       := INIRec.ReadString(sSecao,'UF'       ,'');

      Transp.retTransp.vServ    := StringToFloatDef( INIRec.ReadString(sSecao,'ValorServico',INIRec.ReadString(sSecao,'vServ'   ,'')) ,0) ;
      Transp.retTransp.vBCRet   := StringToFloatDef( INIRec.ReadString(sSecao,'ValorBase'   ,INIRec.ReadString(sSecao,'vBCRet'  ,'')) ,0) ;
      Transp.retTransp.pICMSRet := StringToFloatDef( INIRec.ReadString(sSecao,'Aliquota'    ,INIRec.ReadString(sSecao,'pICMSRet','')) ,0) ;
      Transp.retTransp.vICMSRet := StringToFloatDef( INIRec.ReadString(sSecao,'Valor'       ,INIRec.ReadString(sSecao,'vICMSRet','')) ,0) ;
      Transp.retTransp.CFOP     := INIRec.ReadString(sSecao,'CFOP'     ,'');
      Transp.retTransp.cMunFG   := INIRec.ReadInteger(sSecao,'CidadeCod',INIRec.ReadInteger(sSecao,'cMunFG',0));

      Transp.veicTransp.placa := INIRec.ReadString(sSecao,'Placa'  ,'');
      Transp.veicTransp.UF    := INIRec.ReadString(sSecao,'UFPlaca','');
      Transp.veicTransp.RNTC  := INIRec.ReadString(sSecao,'RNTC'   ,'');

      Transp.vagao := INIRec.ReadString( sSecao,'vagao','') ;
      Transp.balsa := INIRec.ReadString( sSecao,'balsa','') ;

      J := 1 ;
      while true do
      begin
        sSecao := 'Reboque'+IntToStrZero(J,3) ;
        sFim     := INIRec.ReadString(sSecao,'placa','FIM') ;
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with Transp.Reboque.New do
        begin
          placa := sFim;
          UF    := INIRec.ReadString( sSecao,'UF'  ,'') ;
          RNTC  := INIRec.ReadString( sSecao,'RNTC','') ;
        end;

        Inc(J)
      end;

      I := 1 ;
      while true do
      begin
        sSecao := IfThen(INIRec.SectionExists('Volume'+IntToStrZero(I,3)), 'Volume', 'vol');
        sSecao := sSecao+IntToStrZero(I,3) ;
        sQtdVol  := INIRec.ReadString(sSecao,'Quantidade',INIRec.ReadString(sSecao,'qVol','FIM')) ;
        if (sQtdVol = 'FIM') or (Length(sQtdVol) <= 0)  then
          break ;

        with Transp.Vol.New do
        begin
          qVol  := StrToInt(sQtdVol);
          esp   := INIRec.ReadString( sSecao,'Especie'  ,INIRec.ReadString( sSecao,'esp'  ,''));
          marca := INIRec.ReadString( sSecao,'Marca'    ,'');
          nVol  := INIRec.ReadString( sSecao,'Numeracao',INIRec.ReadString( sSecao,'nVol'  ,''));
          pesoL := StringToFloatDef( INIRec.ReadString(sSecao,'PesoLiquido',INIRec.ReadString(sSecao,'pesoL','')) ,0) ;
          pesoB := StringToFloatDef( INIRec.ReadString(sSecao,'PesoBruto'  ,INIRec.ReadString(sSecao,'pesoB','')) ,0) ;

          J := 1;
          while true do
          begin
            sSecao := IfThen(INIRec.SectionExists('lacres'+IntToStrZero(I,3)+IntToStrZero(J,3)), 'lacres', 'Lacre');
            sSecao := sSecao+IntToStrZero(I,3)+IntToStrZero(J,3) ;
            sFim   := INIRec.ReadString(sSecao,'nLacre','FIM') ;
            if (sFim = 'FIM') or (Length(sFim) <= 0)  then
              break ;

            Lacres.New.nLacre := sFim;

            Inc(J);
          end;
        end;

        Inc(I);
      end;

      sSecao := IfThen(INIRec.SectionExists('Fatura'), 'Fatura', 'fat');
      Cobr.Fat.nFat  := INIRec.ReadString( sSecao,'Numero',INIRec.ReadString( sSecao,'nFat',''));
      Cobr.Fat.vOrig := StringToFloatDef( INIRec.ReadString(sSecao,'ValorOriginal',INIRec.ReadString(sSecao,'vOrig','')) ,0) ;
      Cobr.Fat.vDesc := StringToFloatDef( INIRec.ReadString(sSecao,'ValorDesconto',INIRec.ReadString(sSecao,'vDesc','')) ,0) ;
      Cobr.Fat.vLiq  := StringToFloatDef( INIRec.ReadString(sSecao,'ValorLiquido' ,INIRec.ReadString(sSecao,'vLiq' ,'')) ,0) ;

      I := 1 ;
      while true do
      begin
        sSecao   := IfThen(INIRec.SectionExists('Duplicata'+IntToStrZero(I,3)), 'Duplicata', 'dup');
        sSecao   := sSecao+IntToStrZero(I,3) ;
        sDupNumber := INIRec.ReadString(sSecao,'Numero',INIRec.ReadString(sSecao,'nDup','FIM')) ;
        if (sDupNumber = 'FIM') or (Length(sDupNumber) <= 0) then
          break ;

        with Cobr.Dup.New do
        begin
          nDup  := sDupNumber;
          dVenc := StringToDateTime(INIRec.ReadString( sSecao,'DataVencimento',INIRec.ReadString( sSecao,'dVenc','0')));
          vDup  := StringToFloatDef( INIRec.ReadString(sSecao,'Valor',INIRec.ReadString(sSecao,'vDup','')) ,0) ;
        end;

        Inc(I);
      end;

      I := 1 ;
      while true do
      begin
        sSecao := 'pag'+IntToStrZero(I,3) ;
        sFim     := INIRec.ReadString(sSecao,'tpag','FIM');
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break ;

        with pag.New do
        begin
          tPag  := StrToFormaPagamento(OK,sFim);
          vPag  := StringToFloatDef( INIRec.ReadString(sSecao,'vPag','') ,0) ;
          indPag:= StrToIndpag(OK,INIRec.ReadString( sSecao,'indPag','0'));

          tpIntegra  := StrTotpIntegra(OK,INIRec.ReadString(sSecao,'tpIntegra',''));
          CNPJ  := INIRec.ReadString(sSecao,'CNPJ','');
          tBand := StrToBandeiraCartao(OK,INIRec.ReadString(sSecao,'tBand','99'));
          cAut  := INIRec.ReadString(sSecao,'cAut','');
        end;
        pag.vTroco:= StringToFloatDef( INIRec.ReadString(sSecao,'vTroco','') ,0) ;

        Inc(I);
      end;

      sSecao := IfThen(INIRec.SectionExists('DadosAdicionais'), 'DadosAdicionais', 'infAdic');
      InfAdic.infAdFisco := INIRec.ReadString( sSecao,'Fisco'      ,INIRec.ReadString( sSecao,'infAdFisco',''));
      InfAdic.infCpl     := INIRec.ReadString( sSecao,'Complemento',INIRec.ReadString( sSecao,'infCpl'    ,''));

      I := 1 ;
      while true do
      begin
        sSecao := IfThen(INIRec.SectionExists('obsCont'+IntToStrZero(I,3)), 'obsCont', 'InfAdic');
        sSecao     := sSecao+IntToStrZero(I,3) ;
        sAdittionalField := INIRec.ReadString(sSecao,'Campo',INIRec.ReadString(sSecao,'xCampo','FIM')) ;
        if (sAdittionalField = 'FIM') or (Length(sAdittionalField) <= 0) then
          break ;

        with InfAdic.obsCont.New do
        begin
          xCampo := sAdittionalField;
          xTexto := INIRec.ReadString( sSecao,'Texto',INIRec.ReadString( sSecao,'xTexto',''));
        end;

        Inc(I);
      end;

      I := 1 ;
      while true do
      begin
        sSecao := 'obsFisco'+IntToStrZero(I,3) ;
        sAdittionalField := INIRec.ReadString(sSecao,'Campo',INIRec.ReadString(sSecao,'xCampo','FIM')) ;
        if (sAdittionalField = 'FIM') or (Length(sAdittionalField) <= 0) then
          break ;

        with InfAdic.obsFisco.New do
        begin
          xCampo := sAdittionalField;
          xTexto := INIRec.ReadString( sSecao,'Texto',INIRec.ReadString( sSecao,'xTexto',''));
        end;

        Inc(I);
      end;

      I := 1 ;
      while true do
      begin
        sSecao := 'procRef'+IntToStrZero(I,3) ;
        sAdittionalField := INIRec.ReadString(sSecao,'nProc','FIM') ;
        if (sAdittionalField = 'FIM') or (Length(sAdittionalField) <= 0) then
          break ;

        with InfAdic.procRef.New do
        begin
          nProc := sAdittionalField;
          indProc := StrToindProc(OK,INIRec.ReadString( sSecao,'indProc','0'));
        end;

        Inc(I);
      end;

      sFim   := INIRec.ReadString( 'exporta','UFembarq',INIRec.ReadString( 'exporta','UFSaidaPais','FIM')) ;
      if ((sFim <> 'FIM') and ( Length(sFim) > 0 )) then
      begin
        exporta.UFembarq     := INIRec.ReadString( 'exporta','UFembarq','') ;;
        exporta.xLocEmbarq   := INIRec.ReadString( 'exporta','xLocEmbarq','');
        exporta.UFSaidaPais  := INIRec.ReadString( 'exporta','UFSaidaPais','');
        exporta.xLocExporta  := INIRec.ReadString( 'exporta','xLocExporta','');
        exporta.xLocDespacho := INIRec.ReadString( 'exporta','xLocDespacho','');
      end;

      if (INIRec.ReadString( 'compra','xNEmp','') <> '') or
         (INIRec.ReadString( 'compra','xPed' ,'') <> '') or
         (INIRec.ReadString( 'compra','xCont','') <> '') then
      begin
        compra.xNEmp := INIRec.ReadString( 'compra','xNEmp','');
        compra.xPed  := INIRec.ReadString( 'compra','xPed','');
        compra.xCont := INIRec.ReadString( 'compra','xCont','');
      end;

      cana.safra   := INIRec.ReadString( 'cana','safra','');
      cana.ref     := INIRec.ReadString( 'cana','ref'  ,'');
      cana.qTotMes := StringToFloatDef( INIRec.ReadString('cana','qTotMes','') ,0) ;
      cana.qTotAnt := StringToFloatDef( INIRec.ReadString('cana','qTotAnt','') ,0) ;
      cana.qTotGer := StringToFloatDef( INIRec.ReadString('cana','qTotGer','') ,0) ;
      cana.vFor    := StringToFloatDef( INIRec.ReadString('cana','vFor'   ,'') ,0) ;
      cana.vTotDed := StringToFloatDef( INIRec.ReadString('cana','vTotDed','') ,0) ;
      cana.vLiqFor := StringToFloatDef( INIRec.ReadString('cana','vLiqFor','') ,0) ;

      I := 1 ;
      while true do
      begin
        sSecao := 'forDia'+IntToStrZero(I,3) ;
        sDay     := INIRec.ReadString(sSecao,'dia','FIM') ;
        if (sDay = 'FIM') or (Length(sDay) <= 0) then
          break ;

        with cana.fordia.New do
        begin
          dia  := StrToInt(sDay);
          qtde := StringToFloatDef( INIRec.ReadString(sSecao,'qtde'   ,'') ,0) ;
        end;

        Inc(I);
      end;

      I := 1 ;
      while true do
      begin
        sSecao := 'deduc'+IntToStrZero(I,3) ;
        sDeduc   := INIRec.ReadString(sSecao,'xDed','FIM') ;
        if (sDeduc = 'FIM') or (Length(sDeduc) <= 0) then
          break ;

        with cana.deduc.New do
        begin
          xDed := sDeduc;
          vDed := StringToFloatDef( INIRec.ReadString(sSecao,'vDed'   ,'') ,0) ;
        end;

        Inc(I);
      end;

      sSecao := 'infRespTec';
      if INIRec.SectionExists(sSecao) then
      begin
        with infRespTec do
        begin
          CNPJ     := INIRec.ReadString(sSecao, 'CNPJ', '');
          xContato := INIRec.ReadString(sSecao, 'xContato', '');
          email    := INIRec.ReadString(sSecao, 'email', '');
          fone     := INIRec.ReadString(sSecao, 'fone', '');
        end;
      end;
      }
    end;

    GerarXML;

    Result := True;
  finally
    INIRec.Free;
  end;
end;

function NotaFiscal.GerarNF3eIni: String;
var
  INIRec: TMemIniFile;
  IniNF3e: TStringList;
//  I, J, K: integer;
//  sSecao: string;
begin
  Result := '';

  if not ValidarChave(NF3e.infNF3e.ID) then
    raise EACBrNF3eException.Create('NF3e Inconsistente para gerar INI. Chave Inv�lida.');

  INIRec := TMemIniFile.Create('');
  try
    with FNF3e do
    begin
      INIRec.WriteString('infNF3e', 'ID', infNF3e.ID);
      INIRec.WriteString('infNF3e', 'Versao', FloatToStr(infNF3e.Versao));
      INIRec.WriteInteger('Identificacao', 'cUF', Ide.cUF);
      INIRec.WriteInteger('Identificacao', 'Codigo', Ide.cNF);
      INIRec.WriteInteger('Identificacao', 'Modelo', Ide.modelo);
      INIRec.WriteInteger('Identificacao', 'Serie', Ide.serie);
      INIRec.WriteInteger('Identificacao', 'nNF', Ide.nNF);
      INIRec.WriteString('Identificacao', 'dhEmi', DateTimeToStr(Ide.dhEmi));
      INIRec.WriteInteger('Identificacao', 'cMunFG', Ide.cMunFG);
      INIRec.WriteString('Identificacao', 'tpAmb', TpAmbToStr(Ide.tpAmb));
      INIRec.WriteString('Identificacao', 'tpemis', TpEmisToStr(Ide.tpemis));
      INIRec.WriteString('Identificacao', 'finNF3e', FinNF3eToStr(Ide.finNF3e));
      INIRec.WriteString('Identificacao', 'verProc', Ide.verProc);
      INIRec.WriteString('Identificacao', 'dhCont', DateToStr(Ide.dhCont));
      INIRec.WriteString('Identificacao', 'xJust', Ide.xJust);
      {
      for I := 0 to Ide.NFref.Count - 1 do
      begin
        with Ide.NFref.Items[i] do
        begin
          sSecao := 'NFRef' + IntToStrZero(I + 1, 3);
          if trim(refNF3e) <> '' then
          begin
            INIRec.WriteString(sSecao, 'Tipo', 'NF3e');
            INIRec.WriteString(sSecao, 'refNF3e', refNF3e);
          end
          else if trim(RefNF.CNPJ) <> '' then
          begin
            INIRec.WriteString(sSecao, 'Tipo', 'NF');
            INIRec.WriteInteger(sSecao, 'cUF', RefNF.cUF);
            INIRec.WriteString(sSecao, 'AAMM', RefNF.AAMM);
            INIRec.WriteString(sSecao, 'CNPJ', RefNF.CNPJ);
            INIRec.WriteInteger(sSecao, 'Modelo', RefNF.modelo);
            INIRec.WriteInteger(sSecao, 'Serie', RefNF.serie);
            INIRec.WriteInteger(sSecao, 'nNF', RefNF.nNF);
          end
          else if trim(RefNFP.CNPJCPF) <> '' then
          begin
            INIRec.WriteString(sSecao, 'Tipo', 'NFP');
            INIRec.WriteInteger(sSecao, 'cUF', RefNFP.cUF);
            INIRec.WriteString(sSecao, 'AAMM', RefNFP.AAMM);
            INIRec.WriteString(sSecao, 'CNPJ', RefNFP.CNPJCPF);
            INIRec.WriteString(sSecao, 'IE', RefNFP.IE);
            INIRec.WriteString(sSecao, 'Modelo', RefNFP.modelo);
            INIRec.WriteInteger(sSecao, 'Serie', RefNFP.serie);
            INIRec.WriteInteger(sSecao, 'nNF', RefNFP.nNF);
          end
          else if trim(refCTe) <> '' then
          begin
            INIRec.WriteString(sSecao, 'Tipo', 'CTe');
            INIRec.WriteString(sSecao, 'reCTe', refCTe);
          end
          else if trim(RefECF.nCOO) <> '' then
          begin
            INIRec.WriteString(sSecao, 'Tipo', 'ECF');
            INIRec.WriteString(sSecao, 'modelo', ECFModRefToStr(RefECF.modelo));
            INIRec.WriteString(sSecao, 'nECF', RefECF.nECF);
            INIRec.WriteString(sSecao, 'nCOO', RefECF.nCOO);
          end;
        end;
      end;

      INIRec.WriteString('Emitente', 'CNPJCPF', Emit.CNPJCPF);
      INIRec.WriteString('Emitente', 'xNome', Emit.xNome);
      INIRec.WriteString('Emitente', 'xFant', Emit.xFant);
      INIRec.WriteString('Emitente', 'IE', Emit.IE);
      INIRec.WriteString('Emitente', 'IEST', Emit.IEST);
      INIRec.WriteString('Emitente', 'IM', Emit.IM);
      INIRec.WriteString('Emitente', 'CNAE', Emit.CNAE);
      INIRec.WriteString('Emitente', 'CRT', CRTToStr(Emit.CRT));
      INIRec.WriteString('Emitente', 'xLgr', Emit.EnderEmit.xLgr);
      INIRec.WriteString('Emitente', 'nro', Emit.EnderEmit.nro);
      INIRec.WriteString('Emitente', 'xCpl', Emit.EnderEmit.xCpl);
      INIRec.WriteString('Emitente', 'xBairro', Emit.EnderEmit.xBairro);
      INIRec.WriteInteger('Emitente', 'cMun', Emit.EnderEmit.cMun);
      INIRec.WriteString('Emitente', 'xMun', Emit.EnderEmit.xMun);
      INIRec.WriteString('Emitente', 'UF', Emit.EnderEmit.UF);
      INIRec.WriteInteger('Emitente', 'CEP', Emit.EnderEmit.CEP);
      INIRec.WriteInteger('Emitente', 'cPais', Emit.EnderEmit.cPais);
      INIRec.WriteString('Emitente', 'xPais', Emit.EnderEmit.xPais);
      INIRec.WriteString('Emitente', 'Fone', Emit.EnderEmit.fone);
      if Avulsa.CNPJ <> '' then
      begin
        INIRec.WriteString('Avulsa', 'CNPJ', Avulsa.CNPJ);
        INIRec.WriteString('Avulsa', 'xOrgao', Avulsa.xOrgao);
        INIRec.WriteString('Avulsa', 'matr', Avulsa.matr);
        INIRec.WriteString('Avulsa', 'xAgente', Avulsa.xAgente);
        INIRec.WriteString('Avulsa', 'fone', Avulsa.fone);
        INIRec.WriteString('Avulsa', 'UF', Avulsa.UF);
        INIRec.WriteString('Avulsa', 'nDAR', Avulsa.nDAR);
        INIRec.WriteString('Avulsa', 'dEmi', DateToStr(Avulsa.dEmi));
        INIRec.WriteFloat('Avulsa', 'vDAR', Avulsa.vDAR);
        INIRec.WriteString('Avulsa', 'repEmi', Avulsa.repEmi);
        INIRec.WriteString('Avulsa', 'dPag', DateToStr(Avulsa.dPag));
      end;
      if (Dest.idEstrangeiro <> EmptyStr) then
        INIRec.WriteString('Destinatario', 'idEstrangeiro', Dest.idEstrangeiro);
      INIRec.WriteString('Destinatario', 'CNPJCPF', Dest.CNPJCPF);
      INIRec.WriteString('Destinatario', 'xNome', Dest.xNome);
      INIRec.WriteString('Destinatario', 'indIEDest', indIEDestToStr(Dest.indIEDest));
      INIRec.WriteString('Destinatario', 'IE', Dest.IE);
      INIRec.WriteString('Destinatario', 'ISUF', Dest.ISUF);
      INIRec.WriteString('Destinatario', 'IM', Dest.IM);
      INIRec.WriteString('Destinatario', 'Email', Dest.Email);
      INIRec.WriteString('Destinatario', 'xLgr', Dest.EnderDest.xLgr);
      INIRec.WriteString('Destinatario', 'nro', Dest.EnderDest.nro);
      INIRec.WriteString('Destinatario', 'xCpl', Dest.EnderDest.xCpl);
      INIRec.WriteString('Destinatario', 'xBairro', Dest.EnderDest.xBairro);
      INIRec.WriteInteger('Destinatario', 'cMun', Dest.EnderDest.cMun);
      INIRec.WriteString('Destinatario', 'xMun', Dest.EnderDest.xMun);
      INIRec.WriteString('Destinatario', 'UF', Dest.EnderDest.UF);
      INIRec.WriteInteger('Destinatario', 'CEP', Dest.EnderDest.CEP);
      INIRec.WriteInteger('Destinatario', 'cPais', Dest.EnderDest.cPais);
      INIRec.WriteString('Destinatario', 'xPais', Dest.EnderDest.xPais);
      INIRec.WriteString('Destinatario', 'Fone', Dest.EnderDest.Fone);
      if Retirada.CNPJCPF <> '' then
      begin
        INIRec.WriteString('Retirada', 'CNPJCPF', Retirada.CNPJCPF);
        INIRec.WriteString('Retirada', 'xLgr', Retirada.xLgr);
        INIRec.WriteString('Retirada', 'nro', Retirada.nro);
        INIRec.WriteString('Retirada', 'xCpl', Retirada.xCpl);
        INIRec.WriteString('Retirada', 'xBairro', Retirada.xBairro);
        INIRec.WriteInteger('Retirada', 'cMun', Retirada.cMun);
        INIRec.WriteString('Retirada', 'xMun', Retirada.xMun);
        INIRec.WriteString('Retirada', 'UF', Retirada.UF);
      end;
      if Entrega.CNPJCPF <> '' then
      begin
        INIRec.WriteString('Entrega', 'CNPJCPF', Entrega.CNPJCPF);
        INIRec.WriteString('Entrega', 'xLgr', Entrega.xLgr);
        INIRec.WriteString('Entrega', 'nro', Entrega.nro);
        INIRec.WriteString('Entrega', 'xCpl', Entrega.xCpl);
        INIRec.WriteString('Entrega', 'xBairro', Entrega.xBairro);
        INIRec.WriteInteger('Entrega', 'cMun', Entrega.cMun);
        INIRec.WriteString('Entrega', 'xMun', Entrega.xMun);
        INIRec.WriteString('Entrega', 'UF', Entrega.UF);
      end;

      for I := 0 to Det.Count - 1 do
      begin
        with Det.Items[I] do
        begin
          sSecao := 'Produto' + IntToStrZero(I + 1, 3);
          INIRec.WriteInteger(sSecao, 'nItem', Prod.nItem);
          INIRec.WriteString(sSecao, 'infAdProd', infAdProd);
          INIRec.WriteString(sSecao, 'cProd', Prod.cProd);
          INIRec.WriteString(sSecao, 'cEAN', Prod.cEAN);
          INIRec.WriteString(sSecao, 'xProd', Prod.xProd);
          INIRec.WriteString(sSecao, 'NCM', Prod.NCM);
          INIRec.WriteString(sSecao, 'CEST', Prod.CEST);
          INIRec.WriteString(sSecao, 'indEscala', IndEscalaToStr(Prod.indEscala));
          INIRec.WriteString(sSecao, 'CNPJFab', Prod.CNPJFab);
          INIRec.WriteString(sSecao, 'cBenef', Prod.cBenef);
          INIRec.WriteString(sSecao, 'EXTIPI', Prod.EXTIPI);
          INIRec.WriteString(sSecao, 'CFOP', Prod.CFOP);
          INIRec.WriteString(sSecao, 'uCom', Prod.uCom);
          INIRec.WriteFloat(sSecao, 'qCom', Prod.qCom);
          INIRec.WriteFloat(sSecao, 'vUnCom', Prod.vUnCom);
          INIRec.WriteFloat(sSecao, 'vProd', Prod.vProd);
          INIRec.WriteString(sSecao, 'cEANTrib', Prod.cEANTrib);
          INIRec.WriteString(sSecao, 'uTrib', Prod.uTrib);
          INIRec.WriteFloat(sSecao, 'qTrib', Prod.qTrib);
          INIRec.WriteFloat(sSecao, 'vUnTrib', Prod.vUnTrib);
          INIRec.WriteFloat(sSecao, 'vFrete', Prod.vFrete);
          INIRec.WriteFloat(sSecao, 'vSeg', Prod.vSeg);
          INIRec.WriteFloat(sSecao, 'vDesc', Prod.vDesc);
          INIRec.WriteFloat(sSecao, 'vOutro', Prod.vOutro);
          INIRec.WriteString(sSecao, 'IndTot', indTotToStr(Prod.IndTot));
          INIRec.WriteString(sSecao, 'xPed', Prod.xPed);
          INIRec.WriteString(sSecao, 'nItemPed', Prod.nItemPed);
          INIRec.WriteString(sSecao, 'nFCI', Prod.nFCI);
          INIRec.WriteString(sSecao, 'nRECOPI', Prod.nRECOPI);
          INIRec.WriteFloat(sSecao, 'pDevol', pDevol);
          INIRec.WriteFloat(sSecao, 'vIPIDevol', vIPIDevol);
          INIRec.WriteFloat(sSecao, 'vTotTrib', Imposto.vTotTrib);
          for J := 0 to Prod.NVE.Count - 1 do
          begin
            if Prod.NVE.Items[J].NVE <> '' then
            begin
              with Prod.NVE.Items[J] do
              begin
                sSecao := 'NVE' + IntToStrZero(I + 1, 3) + IntToStrZero(J + 1, 3);
                INIRec.WriteString(sSecao, 'NVE', NVE);
              end;
            end
            else
              Break;
          end;

          for J := 0 to Prod.rastro.Count - 1 do
          begin
            if Prod.rastro.Items[J].nLote <> '' then
            begin
              with Prod.rastro.Items[J] do
              begin
                sSecao := 'Rastro' + IntToStrZero(I + 1, 3) + IntToStrZero(J + 1, 3);
                INIRec.WriteString(sSecao, 'nLote', nLote);
                INIRec.WriteFloat(sSecao, 'qLote', qLote);
                INIRec.WriteDateTime(sSecao, 'dFab', dFab);
                INIRec.WriteDateTime(sSecao, 'dVal', dVal);
                INIRec.WriteString(sSecao, 'cAgreg', cAgreg);
              end;
            end
            else
              Break;
          end;

          for J := 0 to Prod.DI.Count - 1 do
          begin
            if Prod.DI.Items[j].nDi <> '' then
            begin
              with Prod.DI.Items[j] do
              begin
                sSecao := 'DI' + IntToStrZero(I + 1, 3) + IntToStrZero(J + 1, 3);
                INIRec.WriteString(sSecao, 'nDi', nDi);
                INIRec.WriteString(sSecao, 'dDi', DateToStr(dDi));
                INIRec.WriteString(sSecao, 'xLocDesemb', xLocDesemb);
                INIRec.WriteString(sSecao, 'UFDesemb', UFDesemb);
                INIRec.WriteString(sSecao, 'dDesemb', DateToStr(dDesemb));
                INIRec.WriteString(sSecao, 'cExportador', cExportador);
                if (TipoViaTranspToStr(tpViaTransp) <> '') then
                begin
                  INIRec.WriteString(sSecao, 'tpViaTransp',
                    TipoViaTranspToStr(tpViaTransp));
                  if (tpViaTransp = tvMaritima) then
                    INIRec.WriteFloat(sSecao, 'vAFRMM', vAFRMM);
                end;
                if (TipoIntermedioToStr(tpIntermedio) <> '') then
                begin
                  INIRec.WriteString(sSecao, 'tpIntermedio',
                    TipoIntermedioToStr(tpIntermedio));
                  if not (tpIntermedio = tiContaPropria) then
                  begin
                    INIRec.WriteString(sSecao, 'CNPJ', CNPJ);
                    INIRec.WriteString(sSecao, 'UFTerceiro', UFTerceiro);
                  end;
                end;
                for K := 0 to adi.Count - 1 do
                begin
                  with adi.Items[K] do
                  begin
                    sSecao :=
                      'LADI' + IntToStrZero(I + 1, 3) + IntToStrZero(J + 1, 3) + IntToStrZero(K + 1, 3);
                    INIRec.WriteInteger(sSecao, 'nAdicao', nAdicao);
                    INIRec.WriteInteger(sSecao, 'nSeqAdi', nSeqAdi);
                    INIRec.WriteString(sSecao, 'cFabricante', cFabricante);
                    INIRec.WriteFloat(sSecao, 'vDescDI', vDescDI);
                    INIRec.WriteString(sSecao, 'nDraw', nDraw);
                  end;
                end;
              end;
            end
            else
              Break;
          end;
          for J := 0 to Prod.detExport.Count - 1 do
          begin
            if Prod.detExport.Items[j].nDraw <> '' then
            begin
              with Prod.detExport.Items[j] do
              begin
                sSecao := 'detExport' + IntToStrZero(I + 1, 3) + IntToStrZero(J + 1, 3);
                INIRec.WriteString(sSecao, 'nDraw', nDraw);
                INIRec.WriteString(sSecao, 'nRe', nRE);
                INIRec.WriteString(sSecao, 'chNF3e', chNF3e);
                INIRec.WriteFloat(sSecao, 'qExport', qExport);
              end;
            end;
          end;

          if (pDevol > 0) then
          begin
            sSecao := 'impostoDevol' + IntToStrZero(I + 1, 3);
            INIRec.WriteFloat(sSecao, 'pDevol', pDevol);
            INIRec.WriteFloat(sSecao, 'vIPIDevol', vIPIDevol);
          end;

          if Prod.veicProd.chassi <> '' then
          begin
            sSecao := 'Veiculo' + IntToStrZero(I + 1, 3);
            with Prod.veicProd do
            begin
              INIRec.WriteString(sSecao, 'tpOP', tpOPToStr(tpOP));
              INIRec.WriteString(sSecao, 'Chassi', chassi);
              INIRec.WriteString(sSecao, 'cCor', cCor);
              INIRec.WriteString(sSecao, 'xCor', xCor);
              INIRec.WriteString(sSecao, 'pot', pot);
              INIRec.WriteString(sSecao, 'Cilin', Cilin);
              INIRec.WriteString(sSecao, 'pesoL', pesoL);
              INIRec.WriteString(sSecao, 'pesoB', pesoB);
              INIRec.WriteString(sSecao, 'nSerie', nSerie);
              INIRec.WriteString(sSecao, 'tpComb', tpComb);
              INIRec.WriteString(sSecao, 'nMotor', nMotor);
              INIRec.WriteString(sSecao, 'CMT', CMT);
              INIRec.WriteString(sSecao, 'dist', dist);
              INIRec.WriteInteger(sSecao, 'anoMod', anoMod);
              INIRec.WriteInteger(sSecao, 'anoFab', anoFab);
              INIRec.WriteString(sSecao, 'tpPint', tpPint);
              INIRec.WriteInteger(sSecao, 'tpVeic', tpVeic);
              INIRec.WriteInteger(sSecao, 'espVeic', espVeic);
              INIRec.WriteString(sSecao, 'VIN', VIN);
              INIRec.WriteString(sSecao, 'condVeic', condVeicToStr(condVeic));
              INIRec.WriteString(sSecao, 'cMod', cMod);
              INIRec.WriteString(sSecao, 'cCorDENATRAN', cCorDENATRAN);
              INIRec.WriteInteger(sSecao, 'lota', lota);
              INIRec.WriteInteger(sSecao, 'tpRest', tpRest);
            end;
          end;
          for J := 0 to Prod.med.Count - 1 do
          begin
            sSecao := 'Medicamento' + IntToStrZero(I + 1, 3) + IntToStrZero(J + 1, 3);
            with Prod.med.Items[J] do
            begin
              if NF3e.infNF3e.Versao >= 4 then
              begin
                INIRec.WriteString(sSecao, 'cProdANVISA', cProdANVISA);
                INIRec.WriteString(sSecao, 'xMotivoIsencao', xMotivoIsencao);
              end;

              if NF3e.infNF3e.Versao < 4 then
              begin
                INIRec.WriteString(sSecao, 'nLote', nLote);
                INIRec.WriteFloat(sSecao, 'qLote', qLote);
                INIRec.WriteString(sSecao, 'dFab', DateToStr(dFab));
                INIRec.WriteString(sSecao, 'dVal', DateToStr(dVal));
              end;

              INIRec.WriteFloat(sSecao, 'vPMC', vPMC);
            end;
          end;
          for J := 0 to Prod.arma.Count - 1 do
          begin
            sSecao := 'Arma' + IntToStrZero(I + 1, 3) + IntToStrZero(J + 1, 3);
            with Prod.arma.Items[J] do
            begin
              INIRec.WriteString(sSecao, 'tpArma', tpArmaToStr(tpArma));
              INIRec.WriteString(sSecao, 'nSerie', nSerie);
              INIRec.WriteString(sSecao, 'nCano', nCano);
              INIRec.WriteString(sSecao, 'descr', descr);
            end;
          end;
          if (Prod.comb.cProdANP > 0) then
          begin
            sSecao := 'Combustivel' + IntToStrZero(I + 1, 3);
            with Prod.comb do
            begin
              INIRec.WriteInteger(sSecao, 'cProdANP', cProdANP);
              INIRec.WriteFloat(sSecao, 'pMixGN', pMixGN);
              INIRec.WriteString(sSecao, 'descANP', descANP);
              INIRec.WriteFloat(sSecao, 'pGLP', pGLP);
              INIRec.WriteFloat(sSecao, 'pGNn', pGNn);
              INIRec.WriteFloat(sSecao, 'pGNi', pGNi);
              INIRec.WriteFloat(sSecao, 'vPart', vPart);
              INIRec.WriteString(sSecao, 'CODIF', CODIF);
              INIRec.WriteFloat(sSecao, 'qTemp', qTemp);
              INIRec.WriteString(sSecao, 'UFCons', UFcons);
              sSecao := 'CIDE' + IntToStrZero(I + 1, 3);
              INIRec.WriteFloat(sSecao, 'qBCprod', CIDE.qBCprod);
              INIRec.WriteFloat(sSecao, 'vAliqProd', CIDE.vAliqProd);
              INIRec.WriteFloat(sSecao, 'vCIDE', CIDE.vCIDE);
              sSecao := 'encerrante' + IntToStrZero(I, 3);
              INIRec.WriteInteger(sSecao, 'nBico', encerrante.nBico);
              INIRec.WriteInteger(sSecao, 'nBomba', encerrante.nBomba);
              INIRec.WriteInteger(sSecao, 'nTanque', encerrante.nTanque);
              INIRec.WriteFloat(sSecao, 'vEncIni', encerrante.vEncIni);
              INIRec.WriteFloat(sSecao, 'vEncFin', encerrante.vEncFin);
              sSecao := 'ICMSComb' + IntToStrZero(I + 1, 3);
              INIRec.WriteFloat(sSecao, 'vBCICMS', ICMS.vBCICMS);
              INIRec.WriteFloat(sSecao, 'vICMS', ICMS.vICMS);
              INIRec.WriteFloat(sSecao, 'vBCICMSST', ICMS.vBCICMSST);
              INIRec.WriteFloat(sSecao, 'vICMSST', ICMS.vICMSST);
              if (ICMSInter.vBCICMSSTDest > 0) then
              begin
                sSecao := 'ICMSInter' + IntToStrZero(I + 1, 3);
                INIRec.WriteFloat(sSecao, 'vBCICMSSTDest', ICMSInter.vBCICMSSTDest);
                INIRec.WriteFloat(sSecao, 'vICMSSTDest', ICMSInter.vICMSSTDest);
              end;
              if (ICMSCons.vBCICMSSTCons > 0) then
              begin
                sSecao := 'ICMSCons' + IntToStrZero(I + 1, 3);
                INIRec.WriteFloat(sSecao, 'vBCICMSSTCons', ICMSCons.vBCICMSSTCons);
                INIRec.WriteFloat(sSecao, 'vICMSSTCons', ICMSCons.vICMSSTCons);
                INIRec.WriteString(sSecao, 'UFCons', ICMSCons.UFcons);
              end;
            end;
          end;
          with Imposto do
          begin
            sSecao := 'ICMS' + IntToStrZero(I + 1, 3);
            with ICMS do
            begin
              INIRec.WriteString(sSecao, 'orig', OrigToStr(ICMS.orig));
              INIRec.WriteString(sSecao, 'CST', CSTICMSToStr(CST));
              INIRec.WriteString(sSecao, 'CSOSN', CSOSNIcmsToStr(CSOSN));
              INIRec.WriteString(sSecao, 'modBC', modBCToStr(ICMS.modBC));
              INIRec.WriteFloat(sSecao, 'pRedBC', ICMS.pRedBC);
              INIRec.WriteFloat(sSecao, 'vBC', ICMS.vBC);
              INIRec.WriteFloat(sSecao, 'pICMS', ICMS.pICMS);
              INIRec.WriteFloat(sSecao, 'vICMS', ICMS.vICMS);
              INIRec.WriteFloat(sSecao, 'vBCFCP', ICMS.vBCFCP);
              INIRec.WriteFloat(sSecao, 'pFCP', ICMS.pFCP);
              INIRec.WriteFloat(sSecao, 'vFCP', ICMS.vFCP);
              INIRec.WriteString(sSecao, 'modBCST', modBCSTToStr(ICMS.modBCST));
              INIRec.WriteFloat(sSecao, 'pMVAST', ICMS.pMVAST);
              INIRec.WriteFloat(sSecao, 'pRedBCST', ICMS.pRedBCST);
              INIRec.WriteFloat(sSecao, 'vBCST', ICMS.vBCST);
              INIRec.WriteFloat(sSecao, 'pICMSST', ICMS.pICMSST);
              INIRec.WriteFloat(sSecao, 'vICMSST', ICMS.vICMSST);
              INIRec.WriteFloat(sSecao, 'vBCFCPST', ICMS.vBCFCPST);
              INIRec.WriteFloat(sSecao, 'pFCPST', ICMS.pFCPST);
              INIRec.WriteFloat(sSecao, 'vFCPST', ICMS.vFCPST);
              INIRec.WriteString(sSecao, 'UFST', ICMS.UFST);
              INIRec.WriteFloat(sSecao, 'pBCOp', ICMS.pBCOp);
              INIRec.WriteFloat(sSecao, 'vBCSTRet', ICMS.vBCSTRet);
              INIRec.WriteFloat(sSecao, 'pST', ICMS.pST);
              INIRec.WriteFloat(sSecao, 'vICMSSTRet', ICMS.vICMSSTRet);
              INIRec.WriteFloat(sSecao, 'vBCFCPSTRet', ICMS.vBCFCPSTRet);
              INIRec.WriteFloat(sSecao, 'pFCPSTRet', ICMS.pFCPSTRet);
              INIRec.WriteFloat(sSecao, 'vFCPSTRet', ICMS.vFCPSTRet);
              INIRec.WriteString(sSecao, 'motDesICMS', motDesICMSToStr(
                ICMS.motDesICMS));
              INIRec.WriteFloat(sSecao, 'pCredSN', ICMS.pCredSN);
              INIRec.WriteFloat(sSecao, 'vCredICMSSN', ICMS.vCredICMSSN);
              INIRec.WriteFloat(sSecao, 'vBCSTDest', ICMS.vBCSTDest);
              INIRec.WriteFloat(sSecao, 'vICMSSTDest', ICMS.vICMSSTDest);
              INIRec.WriteFloat(sSecao, 'vICMSDeson', ICMS.vICMSDeson);
              INIRec.WriteFloat(sSecao, 'vICMSOp', ICMS.vICMSOp);
              INIRec.WriteFloat(sSecao, 'pDif', ICMS.pDif);
              INIRec.WriteFloat(sSecao, 'vICMSDif', ICMS.vICMSDif);

              INIRec.WriteFloat(sSecao, 'pRedBCEfet', ICMS.pRedBCEfet);
              INIRec.WriteFloat(sSecao, 'vBCEfet', ICMS.vBCEfet);
              INIRec.WriteFloat(sSecao, 'pICMSEfet', ICMS.pICMSEfet);
              INIRec.WriteFloat(sSecao, 'vICMSEfet', ICMS.vICMSEfet);

              INIRec.WriteFloat(sSecao, 'vICMSSubstituto', ICMS.vICMSSubstituto);
            end;
            sSecao := 'ICMSUFDEST' + IntToStrZero(I + 1, 3);
            with ICMSUFDest do
            begin
              INIRec.WriteFloat(sSecao, 'vBCUFDest', vBCUFDest);
              INIRec.WriteFloat(sSecao, 'vBCFCPUFDest', vBCFCPUFDest);
              INIRec.WriteFloat(sSecao, 'pICMSUFDest', pICMSUFDest);
              INIRec.WriteFloat(sSecao, 'pICMSInter', pICMSInter);
              INIRec.WriteFloat(sSecao, 'pICMSInterPart', pICMSInterPart);
              INIRec.WriteFloat(sSecao, 'vICMSUFDest', vICMSUFDest);
              INIRec.WriteFloat(sSecao, 'vICMSUFRemet', vICMSUFRemet);
              INIRec.WriteFloat(sSecao, 'pFCPUFDest', pFCPUFDest);
              INIRec.WriteFloat(sSecao, 'vFCPUFDest', vFCPUFDest);
            end;
            if (IPI.vBC > 0) or (IPI.qUnid > 0) or
              (IPI.vIPI > 0) or (IPI.cEnq = '999') then
            begin
              sSecao := 'IPI' + IntToStrZero(I + 1, 3);
              with IPI do
              begin
                INIRec.WriteString(sSecao, 'CST', CSTIPIToStr(CST));
                INIRec.WriteString(sSecao, 'cEnq', cEnq);
                INIRec.WriteString(sSecao, 'clEnq', clEnq);
                INIRec.WriteString(sSecao, 'CNPJProd', CNPJProd);
                INIRec.WriteString(sSecao, 'cSelo', cSelo);
                INIRec.WriteInteger(sSecao, 'qSelo', qSelo);
                INIRec.WriteFloat(sSecao, 'vBC', vBC);
                INIRec.WriteFloat(sSecao, 'qUnid', qUnid);
                INIRec.WriteFloat(sSecao, 'vUnid', vUnid);
                INIRec.WriteFloat(sSecao, 'pIPI', pIPI);
                INIRec.WriteFloat(sSecao, 'vIPI', vIPI);
              end;
            end;
            if (II.vBc > 0) then
            begin
              sSecao := 'II' + IntToStrZero(I + 1, 3);
              with II do
              begin
                INIRec.WriteFloat(sSecao, 'vBc', vBc);
                INIRec.WriteFloat(sSecao, 'vDespAdu', vDespAdu);
                INIRec.WriteFloat(sSecao, 'vII', vII);
                INIRec.WriteFloat(sSecao, 'vIOF', vIOF);
              end;
            end;
            sSecao := 'PIS' + IntToStrZero(I + 1, 3);
            with PIS do
            begin
              INIRec.WriteString(sSecao, 'CST', CSTPISToStr(CST));
              if (CST = pis01) or (CST = pis02) then
              begin
                INIRec.WriteFloat(sSecao, 'vBC', PIS.vBC);
                INIRec.WriteFloat(sSecao, 'pPIS', PIS.pPIS);
                INIRec.WriteFloat(sSecao, 'vPIS', PIS.vPIS);
              end
              else if CST = pis03 then
              begin
                INIRec.WriteFloat(sSecao, 'qBCProd', PIS.qBCProd);
                INIRec.WriteFloat(sSecao, 'vAliqProd', PIS.vAliqProd);
                INIRec.WriteFloat(sSecao, 'vPIS', PIS.vPIS);
              end
              else if CST = pis99 then
              begin
                INIRec.WriteFloat(sSecao, 'vBC', PIS.vBC);
                INIRec.WriteFloat(sSecao, 'pPIS', PIS.pPIS);
                INIRec.WriteFloat(sSecao, 'qBCProd', PIS.qBCProd);
                INIRec.WriteFloat(sSecao, 'vAliqProd', PIS.vAliqProd);
                INIRec.WriteFloat(sSecao, 'vPIS', PIS.vPIS);
              end;
            end;
            if (PISST.vBc > 0) then
            begin
              sSecao := 'PISST' + IntToStrZero(I + 1, 3);
              with PISST do
              begin
                INIRec.WriteFloat(sSecao, 'vBc', vBc);
                INIRec.WriteFloat(sSecao, 'pPis', pPis);
                INIRec.WriteFloat(sSecao, 'qBCProd', qBCProd);
                INIRec.WriteFloat(sSecao, 'vAliqProd', vAliqProd);
                INIRec.WriteFloat(sSecao, 'vPIS', vPIS);
              end;
            end;
            sSecao := 'COFINS' + IntToStrZero(I + 1, 3);
            with COFINS do
            begin
              INIRec.WriteString(sSecao, 'CST', CSTCOFINSToStr(CST));
              if (CST = cof01) or (CST = cof02) then
              begin
                INIRec.WriteFloat(sSecao, 'vBC', COFINS.vBC);
                INIRec.WriteFloat(sSecao, 'pCOFINS', COFINS.pCOFINS);
                INIRec.WriteFloat(sSecao, 'vCOFINS', COFINS.vCOFINS);
              end
              else if CST = cof03 then
              begin
                INIRec.WriteFloat(sSecao, 'qBCProd', COFINS.qBCProd);
                INIRec.WriteFloat(sSecao, 'vAliqProd', COFINS.vAliqProd);
                INIRec.WriteFloat(sSecao, 'vCOFINS', COFINS.vCOFINS);
              end
              else if CST = cof99 then
              begin
                INIRec.WriteFloat(sSecao, 'vBC', COFINS.vBC);
                INIRec.WriteFloat(sSecao, 'pCOFINS', COFINS.pCOFINS);
                INIRec.WriteFloat(sSecao, 'qBCProd', COFINS.qBCProd);
                INIRec.WriteFloat(sSecao, 'vAliqProd', COFINS.vAliqProd);
                INIRec.WriteFloat(sSecao, 'vCOFINS', COFINS.vCOFINS);
              end;
            end;
            if (COFINSST.vBC > 0) then
            begin
              sSecao := 'COFINSST' + IntToStrZero(I + 1, 3);
              with COFINSST do
              begin
                INIRec.WriteFloat(sSecao, 'vBC', vBC);
                INIRec.WriteFloat(sSecao, 'pCOFINS', pCOFINS);
                INIRec.WriteFloat(sSecao, 'qBCProd', qBCProd);
                INIRec.WriteFloat(sSecao, 'vAliqProd', vAliqProd);
                INIRec.WriteFloat(sSecao, 'vCOFINS', vCOFINS);
              end;
            end;
            if (ISSQN.vBC > 0) then
            begin
              sSecao := 'ISSQN' + IntToStrZero(I + 1, 3);
              with ISSQN do
              begin
                INIRec.WriteFloat(sSecao, 'vBC', vBC);
                INIRec.WriteFloat(sSecao, 'vAliq', vAliq);
                INIRec.WriteFloat(sSecao, 'vISSQN', vISSQN);
                INIRec.WriteInteger(sSecao, 'cMunFG', cMunFG);
                INIRec.WriteString(sSecao, 'cListServ', cListServ);
                INIRec.WriteString(sSecao, 'cSitTrib', ISSQNcSitTribToStr(cSitTrib));
                INIRec.WriteFloat(sSecao, 'vDeducao', vDeducao);
                INIRec.WriteFloat(sSecao, 'vOutro', vOutro);
                INIRec.WriteFloat(sSecao, 'vDescIncond', vDescIncond);
                INIRec.WriteFloat(sSecao, 'vDescCond', vDescCond);
                INIRec.WriteFloat(sSecao, 'vISSRet', vISSRet);
                INIRec.WriteString(sSecao, 'indISS', indISSToStr( indISS ));
                INIRec.Writestring(sSecao, 'cServico', cServico);
                INIRec.WriteInteger(sSecao, 'cMun', cMun);
                INIRec.WriteInteger(sSecao, 'cPais', cPais);
                INIRec.WriteString(sSecao, 'nProcesso', nProcesso);
                INIRec.WriteString(sSecao, 'indIncentivo', indIncentivoToStr( indIncentivo ));
              end;
            end;
          end;
        end;
      end;

      INIRec.WriteFloat('Total', 'vBC', Total.ICMSTot.vBC);
      INIRec.WriteFloat('Total', 'vICMS', Total.ICMSTot.vICMS);
      INIRec.WriteFloat('Total', 'vICMSDeson', Total.ICMSTot.vICMSDeson);
      INIRec.WriteFloat('Total', 'vFCP', Total.ICMSTot.vFCP);
      INIRec.WriteFloat('Total', 'vICMSUFDest', Total.ICMSTot.vICMSUFDest);
      INIRec.WriteFloat('Total', 'vICMSUFRemet', Total.ICMSTot.vICMSUFRemet);
      INIRec.WriteFloat('Total', 'vFCPUFDest', Total.ICMSTot.vFCPUFDest);
      INIRec.WriteFloat('Total', 'vBCST', Total.ICMSTot.vBCST);
      INIRec.WriteFloat('Total', 'vST', Total.ICMSTot.vST);
      INIRec.WriteFloat('Total', 'vFCPST', Total.ICMSTot.vFCPST);
      INIRec.WriteFloat('Total', 'vFCPSTRet', Total.ICMSTot.vFCPSTRet);
      INIRec.WriteFloat('Total', 'vProd', Total.ICMSTot.vProd);
      INIRec.WriteFloat('Total', 'vFrete', Total.ICMSTot.vFrete);
      INIRec.WriteFloat('Total', 'vSeg', Total.ICMSTot.vSeg);
      INIRec.WriteFloat('Total', 'vDesc', Total.ICMSTot.vDesc);
      INIRec.WriteFloat('Total', 'vII', Total.ICMSTot.vII);
      INIRec.WriteFloat('Total', 'vIPI', Total.ICMSTot.vIPI);
      INIRec.WriteFloat('Total', 'vIPIDevol', Total.ICMSTot.vIPIDevol);
      INIRec.WriteFloat('Total', 'vPIS', Total.ICMSTot.vPIS);
      INIRec.WriteFloat('Total', 'vCOFINS', Total.ICMSTot.vCOFINS);
      INIRec.WriteFloat('Total', 'vOutro', Total.ICMSTot.vOutro);
      INIRec.WriteFloat('Total', 'vNF', Total.ICMSTot.vNF);
      INIRec.WriteFloat('Total', 'vTotTrib', Total.ICMSTot.vTotTrib);

      INIRec.WriteFloat('ISSQNtot', 'vServ', Total.ISSQNtot.vServ);
      INIRec.WriteFloat('ISSQNtot', 'vBC', Total.ISSQNTot.vBC);
      INIRec.WriteFloat('ISSQNtot', 'vISS', Total.ISSQNTot.vISS);
      INIRec.WriteFloat('ISSQNtot', 'vPIS', Total.ISSQNTot.vPIS);
      INIRec.WriteFloat('ISSQNtot', 'vCOFINS', Total.ISSQNTot.vCOFINS);
      INIRec.WriteDateTime('ISSQNtot', 'dCompet', Total.ISSQNTot.dCompet);
      INIRec.WriteFloat('ISSQNtot', 'vDeducao', Total.ISSQNTot.vDeducao);
      INIRec.WriteFloat('ISSQNtot', 'vOutro', Total.ISSQNTot.vOutro);
      INIRec.WriteFloat('ISSQNtot', 'vDescIncond', Total.ISSQNTot.vDescIncond);
      INIRec.WriteFloat('ISSQNtot', 'vDescCond', Total.ISSQNTot.vDescCond);
      INIRec.WriteFloat('ISSQNtot', 'vISSRet', Total.ISSQNTot.vISSRet);
      INIRec.WriteString('ISSQNtot', 'cRegTrib', RegTribISSQNToStr(
        Total.ISSQNTot.cRegTrib));

      INIRec.WriteFloat('retTrib', 'vRetPIS', Total.retTrib.vRetPIS);
      INIRec.WriteFloat('retTrib', 'vRetCOFINS', Total.retTrib.vRetCOFINS);
      INIRec.WriteFloat('retTrib', 'vRetCSLL', Total.retTrib.vRetCSLL);
      INIRec.WriteFloat('retTrib', 'vBCIRRF', Total.retTrib.vBCIRRF);
      INIRec.WriteFloat('retTrib', 'vIRRF', Total.retTrib.vIRRF);
      INIRec.WriteFloat('retTrib', 'vBCRetPrev', Total.retTrib.vBCRetPrev);
      INIRec.WriteFloat('retTrib', 'vRetPrev', Total.retTrib.vRetPrev);

      INIRec.WriteString('Transportador', 'modFrete', modFreteToStr(Transp.modFrete));
      INIRec.WriteString('Transportador', 'CNPJCPF', Transp.Transporta.CNPJCPF);
      INIRec.WriteString('Transportador', 'xNome', Transp.Transporta.xNome);
      INIRec.WriteString('Transportador', 'IE', Transp.Transporta.IE);
      INIRec.WriteString('Transportador', 'xEnder', Transp.Transporta.xEnder);
      INIRec.WriteString('Transportador', 'xMun', Transp.Transporta.xMun);
      INIRec.WriteString('Transportador', 'UF', Transp.Transporta.UF);
      INIRec.WriteFloat('Transportador', 'vServ', Transp.retTransp.vServ);
      INIRec.WriteFloat('Transportador', 'vBCRet', Transp.retTransp.vBCRet);
      INIRec.WriteFloat('Transportador', 'pICMSRet', Transp.retTransp.pICMSRet);
      INIRec.WriteFloat('Transportador', 'vICMSRet',
        Transp.retTransp.vICMSRet);
      INIRec.WriteString('Transportador', 'CFOP', Transp.retTransp.CFOP);
      INIRec.WriteInteger('Transportador', 'cMunFG', Transp.retTransp.cMunFG);
      INIRec.WriteString('Transportador', 'Placa', Transp.veicTransp.placa);
      INIRec.WriteString('Transportador', 'UFPlaca', Transp.veicTransp.UF);
      INIRec.WriteString('Transportador', 'RNTC', Transp.veicTransp.RNTC);
      INIRec.WriteString('Transportador', 'vagao', Transp.vagao);
      INIRec.WriteString('Transportador', 'balsa', Transp.balsa);

      for J := 0 to Transp.Reboque.Count - 1 do
      begin
        sSecao := 'Reboque' + IntToStrZero(J + 1, 3);
        with Transp.Reboque.Items[J] do
        begin
          INIRec.WriteString(sSecao, 'placa', placa);
          INIRec.WriteString(sSecao, 'UF', UF);
          INIRec.WriteString(sSecao, 'RNTC', RNTC);
        end;
      end;

      for I := 0 to Transp.Vol.Count - 1 do
      begin
        sSecao := 'Volume' + IntToStrZero(I + 1, 3);
        with Transp.Vol.Items[I] do
        begin
          INIRec.WriteInteger(sSecao, 'qVol', qVol);
          INIRec.WriteString(sSecao, 'esp', esp);
          INIRec.WriteString(sSecao, 'marca', marca);
          INIRec.WriteString(sSecao, 'nVol', nVol);
          INIRec.WriteFloat(sSecao, 'pesoL', pesoL);
          INIRec.WriteFloat(sSecao, 'pesoB', pesoB);

          for J := 0 to Lacres.Count - 1 do
          begin
            sSecao := 'Lacre' + IntToStrZero(I + 1, 3) + IntToStrZero(J + 1, 3);
            INIRec.WriteString(sSecao, 'nLacre', Lacres.Items[J].nLacre);
          end;
        end;
      end;

      INIRec.WriteString('Fatura', 'nFat', Cobr.Fat.nFat);
      INIRec.WriteFloat('Fatura', 'vOrig', Cobr.Fat.vOrig);
      INIRec.WriteFloat('Fatura', 'vDesc', Cobr.Fat.vDesc);
      INIRec.WriteFloat('Fatura', 'vLiq', Cobr.Fat.vLiq);

      for I := 0 to Cobr.Dup.Count - 1 do
      begin
        sSecao := 'Duplicata' + IntToStrZero(I + 1, 3);
        with Cobr.Dup.Items[I] do
        begin
          INIRec.WriteString(sSecao, 'nDup', nDup);
          INIRec.WriteString(sSecao, 'dVenc', DateToStr(dVenc));
          INIRec.WriteFloat(sSecao, 'vDup', vDup);
        end;
      end;

      for I := 0 to pag.Count - 1 do
      begin
        sSecao := 'pag' + IntToStrZero(I + 1, 3);
        with pag.Items[I] do
        begin
          INIRec.WriteString(sSecao, 'tPag', FormaPagamentoToStr(tPag));
          INIRec.WriteFloat(sSecao, 'vPag', vPag);
          INIRec.WriteString(sSecao, 'indPag', IndpagToStr(indPag));
          INIRec.WriteString(sSecao, 'tpIntegra', tpIntegraToStr(tpIntegra));
          INIRec.WriteString(sSecao, 'CNPJ', CNPJ);
          INIRec.WriteString(sSecao, 'tBand', BandeiraCartaoToStr(tBand));
          INIRec.WriteString(sSecao, 'cAut', cAut);
        end;
      end;
      INIRec.WriteFloat(sSecao, 'vTroco', pag.vTroco);

      INIRec.WriteString('DadosAdicionais', 'infAdFisco', InfAdic.infAdFisco);
      INIRec.WriteString('DadosAdicionais', 'infCpl', InfAdic.infCpl);

      for I := 0 to InfAdic.obsCont.Count - 1 do
      begin
        sSecao := 'InfAdic' + IntToStrZero(I + 1, 3);
        with InfAdic.obsCont.Items[I] do
        begin
          INIRec.WriteString(sSecao, 'xCampo', xCampo);
          INIRec.WriteString(sSecao, 'xTexto', xTexto);
        end;
      end;

      for I := 0 to InfAdic.obsFisco.Count - 1 do
      begin
        sSecao := 'ObsFisco' + IntToStrZero(I + 1, 3);
        with InfAdic.obsFisco.Items[I] do
        begin
          INIRec.WriteString(sSecao, 'xCampo', xCampo);
          INIRec.WriteString(sSecao, 'xTexto', xTexto);
        end;
      end;

      for I := 0 to InfAdic.procRef.Count - 1 do
      begin
        sSecao := 'procRef' + IntToStrZero(I + 1, 3);
        with InfAdic.procRef.Items[I] do
        begin
          INIRec.WriteString(sSecao, 'nProc', nProc);
          INIRec.WriteString(sSecao, 'indProc', indProcToStr(indProc));
        end;
      end;

      if (exporta.UFembarq <> '') or (exporta.UFSaidaPais <> '') then
      begin
        INIRec.WriteString('Exporta', 'UFembarq', exporta.UFembarq);
        INIRec.WriteString('Exporta', 'xLocEmbarq', exporta.xLocEmbarq);

        INIRec.WriteString('Exporta', 'UFSaidaPais', exporta.UFSaidaPais);
        INIRec.WriteString('Exporta', 'xLocExporta', exporta.xLocExporta);
        INIRec.WriteString('Exporta', 'xLocDespacho', exporta.xLocDespacho);
      end;

      if (compra.xNEmp <> '') then
      begin
        INIRec.WriteString('Compra', 'xNEmp', compra.xNEmp);
        INIRec.WriteString('Compra', 'xPed', compra.xPed);
        INIRec.WriteString('Compra', 'xCont', compra.xCont);
      end;

      INIRec.WriteString('cana', 'safra', cana.safra);
      INIRec.WriteString('cana', 'ref', cana.ref);
      INIRec.WriteFloat('cana', 'qTotMes', cana.qTotMes);
      INIRec.WriteFloat('cana', 'qTotAnt', cana.qTotAnt);
      INIRec.WriteFloat('cana', 'qTotGer', cana.qTotGer);
      INIRec.WriteFloat('cana', 'vFor', cana.vFor);
      INIRec.WriteFloat('cana', 'vTotDed', cana.vTotDed);
      INIRec.WriteFloat('cana', 'vLiqFor', cana.vLiqFor);

      for I := 0 to cana.fordia.Count - 1 do
      begin
        sSecao := 'forDia' + IntToStrZero(I + 1, 3);
        with cana.fordia.Items[I] do
        begin
          INIRec.WriteInteger(sSecao, 'dia', dia);
          INIRec.WriteFloat(sSecao, 'qtde', qtde);
        end;
      end;

      for I := 0 to cana.deduc.Count - 1 do
      begin
        sSecao := 'deduc' + IntToStrZero(I + 1, 3);
        with cana.deduc.Items[I] do
        begin
          INIRec.WriteString(sSecao, 'xDed', xDed);
          INIRec.WriteFloat(sSecao, 'vDed', vDed);
        end;
      end;

      INIRec.WriteString('procNF3e', 'tpAmb', TpAmbToStr(procNF3e.tpAmb));
      INIRec.WriteString('procNF3e', 'verAplic', procNF3e.verAplic);
      INIRec.WriteString('procNF3e', 'chNF3e', procNF3e.chNF3e);
      INIRec.WriteString('procNF3e', 'dhRecbto', DateTimeToStr(procNF3e.dhRecbto));
      INIRec.WriteString('procNF3e', 'nProt', procNF3e.nProt);
      INIRec.WriteString('procNF3e', 'digVal', procNF3e.digVal);
      INIRec.WriteString('procNF3e', 'cStat', IntToStr(procNF3e.cStat));
      INIRec.WriteString('procNF3e', 'xMotivo', procNF3e.xMotivo);
      }
    end;

  finally
    IniNF3e := TStringList.Create;
    try
      INIRec.GetStrings(IniNF3e);
      INIRec.Free;
      Result := StringReplace(IniNF3e.Text, sLineBreak + sLineBreak, sLineBreak, [rfReplaceAll]);
    finally
      IniNF3e.Free;
    end;
  end;

end;

function NotaFiscal.GravarXML(const NomeArquivo: String; const PathArquivo: String): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  FNomeArq := CalcularNomeArquivoCompleto(NomeArquivo, PathArquivo);

  Result := TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e).Gravar(FNomeArq, FXMLOriginal);
end;

function NotaFiscal.GravarTXT(const NomeArquivo: String; const PathArquivo: String): Boolean;
var
  ATXT: String;
begin
  FNomeArq := CalcularNomeArquivoCompleto(NomeArquivo, PathArquivo);
  ATXT := GerarTXT;

  Result := TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e).Gravar(
    ChangeFileExt(FNomeArq, '.txt'), ATXT);
end;

function NotaFiscal.GravarStream(AStream: TStream): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  AStream.Size := 0;
  WriteStrToStream(AStream, AnsiString(FXMLOriginal));

  Result := True;
end;

procedure NotaFiscal.EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings;
  EnviaPDF: Boolean; sCC: TStrings; Anexos: TStrings; sReplyTo: TStrings);
var
  NomeArq_temp : String;
  AnexosEmail:TStrings;
  StreamNF3e : TMemoryStream;
begin
  if not Assigned(TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e).MAIL) then
    raise EACBrNF3eException.Create('Componente ACBrMail n�o associado');

  AnexosEmail := TStringList.Create;
  StreamNF3e := TMemoryStream.Create;
  try
    AnexosEmail.Clear;

    if Assigned(Anexos) then
      AnexosEmail.Assign(Anexos);

    with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
    begin
      Self.GravarStream(StreamNF3e);

      if (EnviaPDF) then
      begin
        if Assigned(DANF3e) then
        begin
          DANF3e.ImprimirDANF3ePDF(FNF3e);
          NomeArq_temp := PathWithDelim(DANF3e.PathPDF) + NumID + '-NF3e.pdf';
          AnexosEmail.Add(NomeArq_temp);
        end;
      end;

      EnviarEmail( sPara, sAssunto, sMensagem, sCC, AnexosEmail, StreamNF3e,
                   NumID +'-NF3e.xml', sReplyTo);
    end;
  finally
    AnexosEmail.Free;
    StreamNF3e.Free;
  end;
end;

function NotaFiscal.GerarXML: String;
var
  IdAnterior : String;
begin
  with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
  begin
    IdAnterior := NF3e.infNF3e.ID;
{$IfDef DFE_ACBR_LIBXML2}
    FNF3eW.Opcoes.FormatoAlerta  := Configuracoes.Geral.FormatoAlerta;
    FNF3eW.Opcoes.RetirarAcentos := Configuracoes.Geral.RetirarAcentos;
    FNF3eW.Opcoes.RetirarEspacos := Configuracoes.Geral.RetirarEspacos;
    FNF3eW.Opcoes.IdentarXML := Configuracoes.Geral.IdentarXML;
    FNF3eW.Opcoes.NormatizarMunicipios  := Configuracoes.Arquivos.NormatizarMunicipios;
    FNF3eW.Opcoes.PathArquivoMunicipios := Configuracoes.Arquivos.PathArquivoMunicipios;
{$Else}
    FNF3eW.Gerador.Opcoes.FormatoAlerta  := Configuracoes.Geral.FormatoAlerta;
    FNF3eW.Gerador.Opcoes.RetirarAcentos := Configuracoes.Geral.RetirarAcentos;
    FNF3eW.Gerador.Opcoes.RetirarEspacos := Configuracoes.Geral.RetirarEspacos;
    FNF3eW.Gerador.Opcoes.IdentarXML := Configuracoes.Geral.IdentarXML;
    FNF3eW.Opcoes.NormatizarMunicipios  := Configuracoes.Arquivos.NormatizarMunicipios;
    FNF3eW.Opcoes.PathArquivoMunicipios := Configuracoes.Arquivos.PathArquivoMunicipios;
{$EndIf}

    pcnAuxiliar.TimeZoneConf.Assign( Configuracoes.WebServices.TimeZoneConf );

    FNF3eW.idCSRT := Configuracoes.RespTec.IdCSRT;
    FNF3eW.CSRT   := Configuracoes.RespTec.CSRT;
  end;

{$IfNDef DFE_ACBR_LIBXML2}
  FNF3eW.Opcoes.GerarTXTSimultaneamente := False;
{$EndIf}

  FNF3eW.GerarXml;
  //DEBUG
  //WriteToTXT('c:\temp\Notafiscal.xml', FNF3eW.Document.Xml, False, False);
  //WriteToTXT('c:\temp\Notafiscal.xml', FNF3eW.Gerador.ArquivoFormatoXML, False, False);

{$IfDef DFE_ACBR_LIBXML2}
  XMLOriginal := FNF3eW.Document.Xml;  // SetXMLOriginal() ir� converter para UTF8
{$Else}
  XMLOriginal := FNF3eW.Gerador.ArquivoFormatoXML;  // SetXMLOriginal() ir� converter para UTF8
{$EndIf}

  { XML gerado pode ter nova Chave e ID, ent�o devemos calcular novamente o
    nome do arquivo, mantendo o PATH do arquivo carregado }
  if (NaoEstaVazio(FNomeArq) and (IdAnterior <> FNF3e.infNF3e.ID)) then
    FNomeArq := CalcularNomeArquivoCompleto('', ExtractFilePath(FNomeArq));

{$IfDef DFE_ACBR_LIBXML2}
  FAlertas := ACBrStr( FNF3eW.ListaDeAlertas.Text );
{$Else}
  FAlertas := ACBrStr( FNF3eW.Gerador.ListaDeAlertas.Text );
{$EndIf}
  Result := FXMLOriginal;
end;

function NotaFiscal.GerarTXT: String;
var
  IdAnterior : String;
begin
  Result := '';
{$IfNDef DFE_ACBR_LIBXML2}
  with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
  begin
    IdAnterior                           := NF3e.infNF3e.ID;
    FNF3eW.Gerador.Opcoes.FormatoAlerta  := Configuracoes.Geral.FormatoAlerta;
    FNF3eW.Gerador.Opcoes.RetirarAcentos := Configuracoes.Geral.RetirarAcentos;
    FNF3eW.Gerador.Opcoes.RetirarEspacos := Configuracoes.Geral.RetirarEspacos;
    FNF3eW.Gerador.Opcoes.IdentarXML     := Configuracoes.Geral.IdentarXML;
    FNF3eW.Opcoes.NormatizarMunicipios   := Configuracoes.Arquivos.NormatizarMunicipios;
    FNF3eW.Opcoes.PathArquivoMunicipios  := Configuracoes.Arquivos.PathArquivoMunicipios;
  end;

  FNF3eW.Opcoes.GerarTXTSimultaneamente := True;

  FNF3eW.GerarXml;
  XMLOriginal := FNF3eW.Gerador.ArquivoFormatoXML;

  if (NaoEstaVazio(FNomeArq) and (IdAnterior <> FNF3e.infNF3e.ID)) then// XML gerado pode ter nova Chave e ID, ent�o devemos calcular novamente o nome do arquivo, mantendo o PATH do arquivo carregado
    FNomeArq := CalcularNomeArquivoCompleto('', ExtractFilePath(FNomeArq));

  FAlertas := FNF3eW.Gerador.ListaDeAlertas.Text;
  Result   := FNF3eW.Gerador.ArquivoFormatoTXT;
{$EndIf}
end;

function NotaFiscal.CalcularNomeArquivo: String;
var
  xID: String;
  NomeXML: String;
begin
  xID := Self.NumID;

  if EstaVazio(xID) then
    raise EACBrNF3eException.Create('ID Inv�lido. Imposs�vel Salvar XML');

  NomeXML := '-NF3e.xml';

  Result := xID + NomeXML;
end;

function NotaFiscal.CalcularPathArquivo: String;
var
  Data: TDateTime;
begin
  with TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e) do
  begin
    if Configuracoes.Arquivos.EmissaoPathNF3e then
      Data := FNF3e.Ide.dhEmi
    else
      Data := Now;

    Result := PathWithDelim(Configuracoes.Arquivos.GetPathNF3e(Data, FNF3e.Emit.CNPJ));
  end;
end;

function NotaFiscal.CalcularNomeArquivoCompleto(NomeArquivo: String;
  PathArquivo: String): String;
var
  PathNoArquivo: String;
begin
  if EstaVazio(NomeArquivo) then
    NomeArquivo := CalcularNomeArquivo;

  PathNoArquivo := ExtractFilePath(NomeArquivo);

  if EstaVazio(PathNoArquivo) then
  begin
    if EstaVazio(PathArquivo) then
      PathArquivo := CalcularPathArquivo
    else
      PathArquivo := PathWithDelim(PathArquivo);
  end
  else
    PathArquivo := '';

  Result := PathArquivo + NomeArquivo;
end;

function NotaFiscal.ValidarConcatChave: Boolean;
var
  wAno, wMes, wDia: word;
  chaveNF3e : String;
begin
  DecodeDate(NF3e.ide.dhEmi, wAno, wMes, wDia);

  chaveNF3e := 'NF3e' + OnlyNumber(NF3e.infNF3e.ID);
  {(*}
  Result := not
    ((Copy(chaveNF3e, 4, 2) <> IntToStrZero(NF3e.Ide.cUF, 2)) or
    (Copy(chaveNF3e, 6, 2)  <> Copy(FormatFloat('0000', wAno), 3, 2)) or
    (Copy(chaveNF3e, 8, 2)  <> FormatFloat('00', wMes)) or
    (Copy(chaveNF3e, 10, 14)<> PadLeft(OnlyNumber(NF3e.Emit.CNPJ), 14, '0')) or
    (Copy(chaveNF3e, 24, 2) <> IntToStrZero(NF3e.Ide.modelo, 2)) or
    (Copy(chaveNF3e, 26, 3) <> IntToStrZero(NF3e.Ide.serie, 3)) or
    (Copy(chaveNF3e, 29, 9) <> IntToStrZero(NF3e.Ide.nNF, 9)) or
    (Copy(chaveNF3e, 38, 1) <> TpEmisToStr(NF3e.Ide.tpEmis)) or
    (Copy(chaveNF3e, 39, 8) <> IntToStrZero(NF3e.Ide.cNF, 8)));
  {*)}
end;

function NotaFiscal.GetConfirmada: Boolean;
begin
  Result := TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e).CstatConfirmada(
    FNF3e.procNF3e.cStat);
end;

function NotaFiscal.GetcStat: Integer;
begin
  Result := FNF3e.procNF3e.cStat;
end;

function NotaFiscal.GetProcessada: Boolean;
begin
  Result := TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e).CstatProcessado(
    FNF3e.procNF3e.cStat);
end;

function NotaFiscal.GetCancelada: Boolean;
begin
  Result := TACBrNF3e(TNotasFiscais(Collection).ACBrNF3e).CstatCancelada(
    FNF3e.procNF3e.cStat);
end;

function NotaFiscal.GetMsg: String;
begin
  Result := FNF3e.procNF3e.xMotivo;
end;

function NotaFiscal.GetNumID: String;
begin
  Result := OnlyNumber(NF3e.infNF3e.ID);
end;

function NotaFiscal.GetXMLAssinado: String;
begin
  if EstaVazio(FXMLAssinado) then
    Assinar;

  Result := FXMLAssinado;
end;

procedure NotaFiscal.SetXML(const AValue: String);
begin
  LerXML(AValue);
end;

procedure NotaFiscal.SetXMLOriginal(const AValue: String);
var
  XMLUTF8: String;
begin
  { Garante que o XML informado est� em UTF8, se ele realmente estiver, nada
    ser� modificado por "ConverteXMLtoUTF8"  (mantendo-o "original") }
  XMLUTF8 := ConverteXMLtoUTF8(AValue);

  FXMLOriginal := XMLUTF8;

  if XmlEstaAssinado(FXMLOriginal) then
    FXMLAssinado := FXMLOriginal
  else
    FXMLAssinado := '';
end;

{ TNotasFiscais }

constructor TNotasFiscais.Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
begin
  if not (AOwner is TACBrNF3e) then
    raise EACBrNF3eException.Create('AOwner deve ser do tipo TACBrNF3e');

  inherited Create(AOwner, ItemClass);

  FACBrNF3e := TACBrNF3e(AOwner);
  FConfiguracoes := TACBrNF3e(FACBrNF3e).Configuracoes;
end;

function TNotasFiscais.Add: NotaFiscal;
begin
  Result := NotaFiscal(inherited Add);
end;

procedure TNotasFiscais.Assinar;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].Assinar;
end;

procedure TNotasFiscais.GerarNF3e;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].GerarXML;
end;

function TNotasFiscais.GetItem(Index: integer): NotaFiscal;
begin
  Result := NotaFiscal(inherited Items[Index]);
end;

function TNotasFiscais.GetNamePath: String;
begin
  Result := 'NotaFiscal';
end;

procedure TNotasFiscais.VerificarDANF3e;
begin
  if not Assigned(TACBrNF3e(FACBrNF3e).DANF3e) then
    raise EACBrNF3eException.Create('Componente DANF3e n�o associado.');
end;

procedure TNotasFiscais.Imprimir;
begin
  VerificarDANF3e;
  TACBrNF3e(FACBrNF3e).DANF3e.ImprimirDANF3e(nil);
end;

procedure TNotasFiscais.ImprimirCancelado;
begin
  VerificarDANF3e;
  TACBrNF3e(FACBrNF3e).DANF3e.ImprimirDANF3eCancelado(nil);
end;

procedure TNotasFiscais.ImprimirResumido;
begin
  VerificarDANF3e;
  TACBrNF3e(FACBrNF3e).DANF3e.ImprimirDANF3eResumido(nil);
end;

procedure TNotasFiscais.ImprimirPDF;
begin
  VerificarDANF3e;
  TACBrNF3e(FACBrNF3e).DANF3e.ImprimirDANF3ePDF(nil);
end;

procedure TNotasFiscais.ImprimirResumidoPDF;
begin
  VerificarDANF3e;
  TACBrNF3e(FACBrNF3e).DANF3e.ImprimirDANF3eResumidoPDF(nil);
end;

function TNotasFiscais.Insert(Index: integer): NotaFiscal;
begin
  Result := NotaFiscal(inherited Insert(Index));
end;

procedure TNotasFiscais.SetItem(Index: integer; const Value: NotaFiscal);
begin
  Items[Index].Assign(Value);
end;

procedure TNotasFiscais.Validar;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].Validar;   // Dispara exception em caso de erro
end;

function TNotasFiscais.VerificarAssinatura(out Erros: String): Boolean;
var
  i: integer;
begin
  Result := True;
  Erros := '';

  if Self.Count < 1 then
  begin
    Erros := 'Nenhuma NF3e carregada';
    Result := False;
    Exit;
  end;

  for i := 0 to Self.Count - 1 do
  begin
    if not Self.Items[i].VerificarAssinatura then
    begin
      Result := False;
      Erros := Erros + Self.Items[i].ErroValidacao + sLineBreak;
    end;
  end;
end;

function TNotasFiscais.ValidarRegrasdeNegocios(out Erros: String): Boolean;
var
  i: integer;
begin
  Result := True;
  Erros := '';

  for i := 0 to Self.Count - 1 do
  begin
    if not Self.Items[i].ValidarRegrasdeNegocios then
    begin
      Result := False;
      Erros := Erros + Self.Items[i].ErroRegrasdeNegocios + sLineBreak;
    end;
  end;
end;

function TNotasFiscais.LoadFromFile(const CaminhoArquivo: String;
  AGerarNF3e: Boolean): Boolean;
var
  XMLUTF8: AnsiString;
  i, l: integer;
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    MS.LoadFromFile(CaminhoArquivo);
    XMLUTF8 := ReadStrFromStream(MS, MS.Size);
  finally
    MS.Free;
  end;

  l := Self.Count; // Indice da �ltima nota j� existente
  Result := LoadFromString(String(XMLUTF8), AGerarNF3e);

  if Result then
  begin
    // Atribui Nome do arquivo a novas notas inseridas //
    for i := l to Self.Count - 1 do
      Self.Items[i].NomeArq := CaminhoArquivo;
  end;
end;

function TNotasFiscais.LoadFromStream(AStream: TStringStream;
  AGerarNF3e: Boolean): Boolean;
var
  AXML: AnsiString;
begin
  AStream.Position := 0;
  AXML := ReadStrFromStream(AStream, AStream.Size);

  Result := Self.LoadFromString(String(AXML), AGerarNF3e);
end;

function TNotasFiscais.LoadFromString(const AXMLString: String;
  AGerarNF3e: Boolean): Boolean;
var
  ANF3eXML, XMLStr: AnsiString;
  P, N: integer;

  function PosNF3e: integer;
  begin
    Result := pos('</NF3e>', XMLStr);
  end;

begin
  // Verifica se precisa Converter de UTF8 para a String nativa da IDE //
  XMLStr := ConverteXMLtoNativeString(AXMLString);

  N := PosNF3e;
  while N > 0 do
  begin
    P := pos('</NF3eProc>', XMLStr);

    if P <= 0 then
      P := pos('</procNF3e>', XMLStr);  // NF3e obtida pelo Portal da Receita

    if P > 0 then
    begin
      ANF3eXML := copy(XMLStr, 1, P + 10);
      XMLStr := Trim(copy(XMLStr, P + 10, length(XMLStr)));
    end
    else
    begin
      ANF3eXML := copy(XMLStr, 1, N + 6);
      XMLStr := Trim(copy(XMLStr, N + 6, length(XMLStr)));
    end;

    with Self.Add do
    begin
      LerXML(ANF3eXML);

      if AGerarNF3e then // Recalcula o XML
        GerarXML;
    end;

    N := PosNF3e;
  end;

  Result := Self.Count > 0;
end;

function TNotasFiscais.LoadFromIni(const AIniString: String): Boolean;
begin
  with Self.Add do
    LerArqIni(AIniString);

  Result := Self.Count > 0;
end;

function TNotasFiscais.GerarIni: String;
begin
  Result := '';

  if (Self.Count > 0) then
    Result := Self.Items[0].GerarNF3eIni;
end;

function TNotasFiscais.GravarXML(const APathNomeArquivo: String): Boolean;
var
  i: integer;
  NomeArq, PathArq : String;
begin
  Result := True;
  i := 0;

  while Result and (i < Self.Count) do
  begin
    PathArq := ExtractFilePath(APathNomeArquivo);
    NomeArq := ExtractFileName(APathNomeArquivo);
    Result := Self.Items[i].GravarXML(NomeArq, PathArq);
    Inc(i);
  end;
end;

function TNotasFiscais.GravarTXT(const APathNomeArquivo: String): Boolean;
var
  SL: TStringList;
  ArqTXT: String;
  PathArq : string;
  I: integer;
begin
  Result := False;
  SL := TStringList.Create;
  try
    SL.Clear;

    for I := 0 to Self.Count - 1 do
    begin
      ArqTXT := Self.Items[I].GerarTXT;
      SL.Add(ArqTXT);
    end;

    if SL.Count > 0 then
    begin
      // Inserindo cabe�alho //
      SL.Insert(0, 'NOTA FISCAL|' + IntToStr(Self.Count));

      // Apagando as linhas em branco //
      i := 0;
      while (i <= SL.Count - 1) do
      begin
        if SL[I] = '' then
          SL.Delete(I)
        else
          Inc(i);
      end;

      PathArq := APathNomeArquivo;

      if EstaVazio(PathArq) then
        PathArq := PathWithDelim(
          TACBrNF3e(FACBrNF3e).Configuracoes.Arquivos.PathSalvar) + 'NF3e.TXT';

      SL.SaveToFile(PathArq);
      Result := True;
    end;
  finally
    SL.Free;
  end;
end;

end.
