{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
{                              Wemerson Souto                                  }
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

unit ACBrCTeConhecimentos;

interface

uses
  Classes, Sysutils, Dialogs, Forms, StrUtils,
  ACBrCTeConfiguracoes,
  pcteCTe, pcteCTeR, pcteCTeW, pcnConversao, pcnAuxiliar, pcnLeitor;

type

  { Conhecimento }

  Conhecimento = class(TCollectionItem)
  private
    FCTe: TCTe;
    FCTeW: TCTeW;
    FCTeR: TCTeR;

    FXMLAssinado: String;
    FXMLOriginal: String;

    FConfiguracoes: TConfiguracoesCTe;
    FAlertas: String;
    FErroValidacao: String;
    FErroValidacaoCompleto: String;
    FErroRegrasdeNegocios: String;
    FNomeArq: String;
    FNomeArqPDF: String;

    function GetConfirmado: Boolean;
    function GetProcessado: Boolean;
    function GetCancelado: Boolean;

    function GetMsg: String;
    function GetNumID: String;
    function GetXMLAssinado: String;
    procedure SetXML(const AValue: String);
    procedure SetXMLOriginal(const AValue: String);
    function ValidarConcatChave: Boolean;
    function CalcularNomeArquivo: String;
    function CalcularPathArquivo: String;
    function GetcStat: Integer;
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
    function GerarCTeIni: String;

    function GerarXML: String;
    function GravarXML(const NomeArquivo: String = ''; const PathArquivo: String = ''): Boolean;

    function GravarStream(AStream: TStream): Boolean;

    procedure EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings = nil;
      EnviaPDF: Boolean = True; sCC: TStrings = nil; Anexos: TStrings = nil;
      sReplyTo: TStrings = nil);

    function CalcularNomeArquivoCompleto(NomeArquivo: String = '';
      PathArquivo: String = ''): String;

    property NomeArq: String read FNomeArq write FNomeArq;
    property NomeArqPDF: String read FNomeArqPDF write FNomeArqPDF;

    property CTe: TCTe read FCTe;

    // Atribuir a "XML", faz o componente transferir os dados lido para as propriedades internas e "XMLAssinado"
    property XML: String         read FXMLOriginal   write SetXML;
    // Atribuir a "XMLOriginal", reflete em XMLAssinado, se existir a tag de assinatura
    property XMLOriginal: String read FXMLOriginal   write SetXMLOriginal;
    property XMLAssinado: String read GetXMLAssinado write FXMLAssinado;

    property Confirmado: Boolean read GetConfirmado;
    property Processado: Boolean read GetProcessado;
    property Cancelado: Boolean  read GetCancelado;
    property cStat: Integer      read GetcStat;
    property Msg: String         read GetMsg;
    property NumID: String       read GetNumID;

    property Alertas: String               read FAlertas;
    property ErroValidacao: String         read FErroValidacao;
    property ErroValidacaoCompleto: String read FErroValidacaoCompleto;
    property ErroRegrasdeNegocios: String  read FErroRegrasdeNegocios;
  end;

  { TConhecimentos }

  TConhecimentos = class(TOwnedCollection)
  private
    FACBrCTe: TComponent;
    FConfiguracoes: TConfiguracoesCTe;

    function GetItem(Index: Integer): Conhecimento;
    procedure SetItem(Index: Integer; const Value: Conhecimento);
    procedure VerificarDACTE;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);

    procedure GerarCTe;
    procedure Assinar;
    procedure Validar;
    function VerificarAssinatura(out Erros: String): Boolean;
    function ValidarRegrasdeNegocios(out Erros: String): Boolean;
    procedure Imprimir;
    procedure ImprimirPDF;

    function  Add: Conhecimento;
    function Insert(Index: Integer): Conhecimento;

    property Items[Index: Integer]: Conhecimento read GetItem write SetItem; default;

    function GetNamePath: String; override;
    // Incluido o Parametro AGerarCTe que determina se ap�s carregar os dados do CTe
    // para o componente, ser� gerado ou n�o novamente o XML do CTe.
    function LoadFromFile(const CaminhoArquivo: String; AGerarCTe: Boolean = False): Boolean;
    function LoadFromStream(AStream: TStringStream; AGerarCTe: Boolean = False): Boolean;
    function LoadFromString(const AXMLString: String; AGerarCTe: Boolean = False): Boolean;
    function LoadFromIni(const AIniString: String): Boolean;

    function GerarIni: String;
    function GravarXML(const PathNomeArquivo: String = ''): Boolean;

    property ACBrCTe: TComponent read FACBrCTe;
  end;

implementation

uses
  dateutils, IniFiles,
  synautil,
  ACBrCTe, ACBrUtil, ACBrDFeUtil, pcteConversaoCTe;

{ Conhecimento }

constructor Conhecimento.Create(Collection2: TCollection);
begin
  inherited Create(Collection2);

  FCTe := TCTe.Create;
  FCTeW := TCTeW.Create(FCTe);
  FCTeR := TCTeR.Create(FCTe);
  FConfiguracoes := TACBrCTe(TConhecimentos(Collection).ACBrCTe).Configuracoes;

  with TACBrCTe(TConhecimentos(Collection).ACBrCTe) do
  begin
    FCTe.Ide.modelo := StrToInt(ModeloCTeToStr(Configuracoes.Geral.ModeloDF));
    FCTe.infCTe.Versao := VersaoCTeToDbl(Configuracoes.Geral.VersaoDF);

    FCTe.Ide.tpCTe := tcNormal;
    FCTe.Ide.verProc := 'ACBrCTe';
    FCTe.Ide.tpAmb := Configuracoes.WebServices.Ambiente;
    FCTe.Ide.tpEmis := Configuracoes.Geral.FormaEmissao;
    FCTe.ide.indGlobalizado := tiNao;
    
    FCTe.infCTeNorm.infCteSub.indAlteraToma := tiNao;

    if Assigned(DACTE) then
      FCTe.Ide.tpImp := DACTE.TipoDACTE;
  end;
end;

destructor Conhecimento.Destroy;
begin
  FCTe.Free;
  FCTeW.Free;
  FCTeR.Free;

  inherited Destroy;
end;

procedure Conhecimento.Imprimir;
begin
  with TACBrCTe(TConhecimentos(Collection).ACBrCTe) do
  begin
    if not Assigned(DACTE) then
      raise EACBrCTeException.Create('Componente DACTE n�o associado.')
    else
      DACTE.ImprimirDACTE(CTe);
  end;
end;

procedure Conhecimento.ImprimirPDF;
begin
  with TACBrCTe(TConhecimentos(Collection).ACBrCTe) do
  begin
    if not Assigned(DACTE) then
      raise EACBrCTeException.Create('Componente DACTE n�o associado.')
    else
      DACTE.ImprimirDACTEPDF(CTe);
  end;
end;

procedure Conhecimento.Assinar;
var
  XMLStr: String;
  XMLUTF8: AnsiString;
  Leitor: TLeitor;
begin
  with TACBrCTe(TConhecimentos(Collection).ACBrCTe) do
  begin
    if not Assigned(SSL.AntesDeAssinar) then
      SSL.ValidarCNPJCertificado( CTe.Emit.CNPJ );
  end;

  // Gera novamente, para processar propriedades que podem ter sido modificadas
  XMLStr := GerarXML;

  // XML j� deve estar em UTF8, para poder ser assinado //
  XMLUTF8 := ConverteXMLtoUTF8(XMLStr);

  with TACBrCTe(TConhecimentos(Collection).ACBrCTe) do
  begin
    case Configuracoes.Geral.ModeloDF of
      moCTeOS: FXMLAssinado := SSL.Assinar(String(XMLUTF8), 'CTeOS', 'infCte');
      moGTVe: FXMLAssinado := SSL.Assinar(String(XMLUTF8), 'GTVe', 'infCte');
    else
      FXMLAssinado := SSL.Assinar(String(XMLUTF8), 'CTe', 'infCte')
    end;

    // SSL.Assinar() sempre responde em UTF8...
    FXMLOriginal := FXMLAssinado;

    Leitor := TLeitor.Create;
    try
      leitor.Grupo := FXMLAssinado;
      CTe.signature.URI := Leitor.rAtributo('Reference URI=');
      CTe.signature.DigestValue := Leitor.rCampo(tcStr, 'DigestValue');
      CTe.signature.SignatureValue := Leitor.rCampo(tcStr, 'SignatureValue');
      CTe.signature.X509Certificate := Leitor.rCampo(tcStr, 'X509Certificate');
    finally
      Leitor.Free;
    end;

    with TACBrCTe(TConhecimentos(Collection).ACBrCTe) do
    begin
      CTe.infCTeSupl.qrCodCTe := GetURLQRCode(CTe.Ide.cUF, CTe.Ide.tpAmb,
                CTe.ide.tpEmis, CTe.infCTe.ID, CTe.infCTe.Versao);

      GerarXML;
    end;

    if Configuracoes.Arquivos.Salvar and
      (not Configuracoes.Arquivos.SalvarApenasCTeProcessados) then
    begin
      if NaoEstaVazio(NomeArq) then
        Gravar(NomeArq, FXMLAssinado)
      else
        Gravar(CalcularNomeArquivoCompleto(), FXMLAssinado);
    end;
  end;
end;

procedure Conhecimento.Validar;
var
  Erro, AXML, AXMLModal, Grupo: String;
  CTeEhValido, ModalEhValido, ok: Boolean;
  ALayout: TLayOutCTe;
  Modelo: TModeloCTe;
begin
  AXML := FXMLAssinado;
  if AXML = '' then
    AXML := XMLOriginal;

  // Obtem o grupo referente ao Modal
  AXMLModal := Trim(RetornarConteudoEntre(AXML, '<infModal', '</infModal>'));
  // Remove NameSpace indevido incluido por alguns sistemas
  AXMLModal := StringReplace(AXMLModal, ' xmlns="' + ACBRCTE_NAMESPACE + '"', '',
                                     [rfReplaceAll, rfIgnoreCase]);

  case TACBrCTe(TConhecimentos(Collection).ACBrCTe).IdentificaSchemaModal(AXML) of
   schcteModalAereo:
     begin
       AXMLModal := '<aereo xmlns="' + ACBRCTE_NAMESPACE + '">' +
                      Trim(RetornarConteudoEntre(AXMLModal, '<aereo>', '</aereo>')) +
                    '</aereo>';
     end;
   schcteModalAquaviario:
     begin
       AXMLModal := '<aquav xmlns="' + ACBRCTE_NAMESPACE + '">' +
                      Trim(RetornarConteudoEntre(AXMLModal, '<aquav>', '</aquav>')) +
                    '</aquav>';
     end;
   schcteModalDutoviario:
     begin
       AXMLModal := '<duto xmlns="' + ACBRCTE_NAMESPACE + '">' +
                      Trim(RetornarConteudoEntre(AXMLModal, '<duto>', '</duto>')) +
                    '</duto>';
     end;
   schcteModalFerroviario:
     begin
       AXMLModal := '<ferrov xmlns="' + ACBRCTE_NAMESPACE + '">' +
                      Trim(RetornarConteudoEntre(AXMLModal, '<ferrov>', '</ferrov>')) +
                    '</ferrov>';
     end;
   schcteModalRodoviario:
     begin
       AXMLModal := '<rodo xmlns="' + ACBRCTE_NAMESPACE + '">' +
                      Trim(RetornarConteudoEntre(AXMLModal, '<rodo>', '</rodo>')) +
                    '</rodo>';
     end;
   schcteModalRodoviarioOS:
     begin
       AXMLModal := '<rodoOS xmlns="' + ACBRCTE_NAMESPACE + '">' +
                      Trim(RetornarConteudoEntre(AXMLModal, '<rodoOS>', '</rodoOS>')) +
                    '</rodoOS>';
     end;
   schcteMultiModal:
     begin
       AXMLModal := '<multimodal xmlns="' + ACBRCTE_NAMESPACE + '">' +
                      Trim(RetornarConteudoEntre(AXMLModal, '<multimodal>', '</multimodal>')) +
                    '</multimodal>';
     end;
  end;

  AXMLModal := '<?xml version="1.0" encoding="UTF-8" ?>' + AXMLModal;

  with TACBrCTe(TConhecimentos(Collection).ACBrCTe) do
  begin
    Modelo  := StrToModeloCTe(ok, IntToStr(FCTe.Ide.modelo));

    case Modelo of
      moCTeOS:
        begin
          ALayout := LayCTeRecepcaoOS;
          Grupo := 'CTeOS';
        end;
      moGTVe:
        begin
          ALayout := LayCTeRecepcaoGTVe;
          Grupo := 'GTVe';
        end;
    else
      begin
        ALayout := LayCTeRecepcao;
        Grupo := 'CTe';
      end;
    end;

    // Extraindo apenas os dados da CTe (sem cteProc)
    AXML := ObterDFeXML(AXML, Grupo, ACBRCTE_NAMESPACE);

    if EstaVazio(AXML) then
    begin
      Erro := ACBrStr(Grupo + ' n�o encontrada no XML');
      CTeEhValido := False;
    end
    else
    begin
      if ((FCTe.ide.tpCTe = tcNormal) or (FCTe.ide.tpCTe = tcSubstituto)) and
         ((FCTe.ide.modelo = 57) or ((FCTe.ide.modelo = 67) and
          (FCTe.ide.modal = mdRodoviario) and (FCTe.ide.tpServ <> tsTranspValores))) then
      begin
        ModalEhValido := SSL.Validar(AXMLModal, GerarNomeArqSchemaModal(AXML, FCTe.infCTe.Versao), Erro);

        if not ModalEhValido then
        begin
          FErroValidacao := ACBrStr('Falha na valida��o do Modal do Conhecimento: ') +
            IntToStr(CTe.Ide.nCT) + sLineBreak + FAlertas ;
          FErroValidacaoCompleto := FErroValidacao + sLineBreak + Erro;

          raise EACBrCTeException.CreateDef(
            IfThen(Configuracoes.Geral.ExibirErroSchema, ErroValidacaoCompleto,
            ErroValidacao));
        end;

        CTeEhValido := SSL.Validar(AXML, GerarNomeArqSchema(ALayout, FCTe.infCTe.Versao), Erro);
      end
      else
        CTeEhValido := SSL.Validar(AXML, GerarNomeArqSchema(ALayout, FCTe.infCTe.Versao), Erro);
    end;

    if not CTeEhValido then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o dos dados do Conhecimento: ') +
        IntToStr(CTe.Ide.nCT) + sLineBreak + FAlertas ;
      FErroValidacaoCompleto := FErroValidacao + sLineBreak + Erro;

      raise EACBrCTeException.CreateDef(
        IfThen(Configuracoes.Geral.ExibirErroSchema, ErroValidacaoCompleto,
        ErroValidacao));
    end;
  end;
end;

function Conhecimento.VerificarAssinatura: Boolean;
var
  Erro, AXML, Grupo: String;
  AssEhValida, Ok: Boolean;
  Modelo: TModeloCTe;
begin
  AXML := XMLAssinado;

  with TACBrCTe(TConhecimentos(Collection).ACBrCTe) do
  begin
    Modelo := StrToModeloCTe(ok, IntToStr(FCTe.Ide.modelo));

    case Modelo of
      moCTeOS:
        Grupo := 'CTeOS';
      moGTVe:
        Grupo := 'GTVe';
    else
      Grupo := 'CTe';
    end;

    // Extraindo apenas os dados da CTe (sem cteProc)
    AXML := ObterDFeXML(AXML, Grupo, ACBRCTE_NAMESPACE);

    if EstaVazio(AXML) then
    begin
      Erro := ACBrStr(Grupo + ' n�o encontrada no XML');
      AssEhValida := False;
    end
    else
      AssEhValida := SSL.VerificarAssinatura(AXML, Erro, 'infCte');

    if not AssEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o da assinatura do Conhecimento: ') +
        IntToStr(CTe.Ide.nCT) + sLineBreak + Erro;
    end;
  end;

  Result := AssEhValida;
end;

function Conhecimento.ValidarRegrasdeNegocios: Boolean;
var
  Erros{, Log}: String;
  Agora: TDateTime;

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
  Agora := Now;
  GravaLog('Inicio da Valida��o');

  with TACBrCTe(TConhecimentos(Collection).ACBrCTe) do
  begin
    Erros := '';

    GravaLog('Validar: 502-Chave de acesso');
    if not ValidarConcatChave then
      AdicionaErro(
        '502-Rejei��o: Erro na Chave de Acesso - Campo Id n�o corresponde � concatena��o dos campos correspondentes');

    GravaLog('Validar: 897-C�digo do documento: ' + IntToStr(CTe.Ide.nCT));
    if not ValidarCodigoDFe(CTe.Ide.cCT, CTe.Ide.nCT) then
      AdicionaErro('897-Rejei��o: C�digo num�rico em formato inv�lido ');

    GravaLog('Validar: 252-Ambiente');
    if (CTe.Ide.tpAmb <> Configuracoes.WebServices.Ambiente) then
      AdicionaErro('252-Rejei��o: Ambiente informado diverge do Ambiente de recebimento '
        + '(Tipo do ambiente do CT-e difere do ambiente do Web Service)');

    GravaLog('Validar: 503-Serie');
    if (CTe.Ide.serie > 889) then
      AdicionaErro('503-Rejei��o: S�rie utilizada fora da faixa permitida no Web Service (0-889)');

    GravaLog('Validar: 226-UF');
    if copy(IntToStr(CTe.Emit.EnderEmit.cMun), 1, 2) <> IntToStr(Configuracoes.WebServices.UFCodigo) then
      AdicionaErro('226-Rejei��o: C�digo da UF do Emitente diverge da UF autorizadora');

  end;

  Result := EstaVazio(Erros);

  if not Result then
  begin
    Erros := ACBrStr('Erro(s) nas Regras de neg�cios do Conhecimento: '+
                     IntToStr(CTe.Ide.nCT) + sLineBreak + Erros);
  end;

  GravaLog('Fim da Valida��o. Tempo: ' +
           FormatDateTime('hh:nn:ss:zzz', Now - Agora) + sLineBreak +
           'Erros:' + Erros);

  FErroRegrasdeNegocios := Erros;
end;

function Conhecimento.LerXML(const AXML: String): Boolean;
var
  XMLStr: String;
begin
  XMLOriginal := AXML;  // SetXMLOriginal() ir� verificar se AXML est� em UTF8

  { Verifica se precisa converter "AXML" de UTF8 para a String nativa da IDE.
    Isso � necess�rio, para que as propriedades fiquem com a acentua��o correta }
  XMLStr := ParseText(AXML, True, XmlEhUTF8(AXML));

  FCTeR.Leitor.Arquivo := XMLStr;
  FCTeR.LerXml;

  Result := True;
end;

function Conhecimento.GravarXML(const NomeArquivo: String; const PathArquivo: String): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  FNomeArq := CalcularNomeArquivoCompleto(NomeArquivo, PathArquivo);

  Result := TACBrCTe(TConhecimentos(Collection).ACBrCTe).Gravar(FNomeArq, FXMLOriginal);
end;

function Conhecimento.GravarStream(AStream: TStream): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  AStream.Size := 0;
  WriteStrToStream(AStream, AnsiString(FXMLOriginal));
  Result := True;
end;

procedure Conhecimento.EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings;
  EnviaPDF: Boolean; sCC: TStrings; Anexos: TStrings; sReplyTo: TStrings);
var
  NomeArqTemp: String;
  AnexosEmail: TStrings;
  StreamCTe: TMemoryStream;
begin
  if not Assigned(TACBrCTe(TConhecimentos(Collection).ACBrCTe).MAIL) then
    raise EACBrCTeException.Create('Componente ACBrMail n�o associado');

  AnexosEmail := TStringList.Create;
  StreamCTe := TMemoryStream.Create;
  try
    AnexosEmail.Clear;
    if Assigned(Anexos) then
      AnexosEmail.Assign(Anexos);

    with TACBrCTe(TConhecimentos(Collection).ACBrCTe) do
    begin
      Self.GravarStream(StreamCTe);

      if (EnviaPDF) then
      begin
        if Assigned(DACTE) then
        begin
          DACTE.ImprimirDACTEPDF(CTe);
          NomeArqTemp := PathWithDelim(DACTE.PathPDF) + NumID + '-cte.pdf';
          AnexosEmail.Add(NomeArqTemp);
        end;
      end;

      EnviarEmail( sPara, sAssunto, sMensagem, sCC, AnexosEmail, StreamCTe,
                   NumID + '-cte.xml', sReplyTo);
    end;
  finally
    AnexosEmail.Free;
    StreamCTe.Free;
  end;
end;

function Conhecimento.GerarCTeIni: String;
var
  I{, J, K}: integer;
  sSecao: string;
  INIRec: TMemIniFile;
  IniCTe: TStringList;
begin
  Result := '';

  if not ValidarChave(CTe.infCTe.ID) then
    raise EACBrCTeException.Create('CTe Inconsistente para gerar INI. Chave Inv�lida.');

  INIRec := TMemIniFile.Create('');
  try
    with FCTe do
    begin
      INIRec.WriteInteger('ide', 'cCT', Ide.cCT);
      INIRec.WriteInteger('ide', 'CFOP', Ide.CFOP);
      INIRec.WriteString('ide', 'natOp', Ide.natOp);
      INIRec.WriteString('ide', 'forPag', tpforPagToStr(Ide.forPag));
      INIRec.WriteInteger('ide', 'mod', Ide.modelo);
      INIRec.WriteInteger('ide', 'serie', Ide.serie);
      INIRec.WriteInteger('ide', 'nCT', Ide.nCT);
      INIRec.WriteString('ide', 'dhEmi', DateToStr(Ide.dhEmi));
      INIRec.WriteString('ide', 'tpImp', TpImpToStr(Ide.tpImp));
      INIRec.WriteString('ide', 'tpemis', TpEmisToStr(Ide.tpEmis));
      INIRec.WriteString('ide', 'procEmi', procEmiToStr(Ide.procEmi));
      INIRec.WriteString('ide', 'verProc', Ide.verProc);
      INIRec.WriteString('ide', 'dhCont', DateToStr(Ide.dhCont));
      INIRec.WriteString('ide', 'xJust', Ide.xJust);
      INIRec.WriteString('ide', 'tpCTe', tpCTePagToStr(Ide.tpCTe));
      INIRec.WriteString('ide', 'refCTe', Ide.refCTe);
      INIRec.WriteInteger('ide', 'cMunEnv', Ide.cMunEnv);
      INIRec.WriteString('ide', 'xMunEnv', Ide.xMunEnv);
      INIRec.WriteString('ide', 'UFEnv', Ide.UFEnv);
      INIRec.WriteString('ide', 'modal', TpModalToStr(Ide.modal));
      INIRec.WriteString('ide', 'tpServ', TpServPagToStr(Ide.tpServ));
      INIRec.WriteInteger('ide', 'cMunIni', Ide.cMunIni);
      INIRec.WriteString('ide', 'xMunIni', Ide.xMunIni);
      INIRec.WriteString('ide', 'UFIni', Ide.UFIni);
      INIRec.WriteInteger('ide', 'cMunFim', Ide.cMunFim);
      INIRec.WriteString('ide', 'xMunFim', Ide.xMunFim);
      INIRec.WriteString('ide', 'UFFim', Ide.UFFim);
      INIRec.WriteString('ide', 'retira', TpRetiraPagToStr(Ide.retira));
      INIRec.WriteString('ide', 'xDetRetira', Ide.xDetRetira);
      INIRec.WriteString('ide','indGlobalizado', TIndicadorToStr(Ide.indGlobalizado));
      INIRec.WriteString('ide','indIEToma', indIEDestToStr(Ide.indIEToma));
      INIRec.WriteInteger('ide', 'cUF', ide.cUF);

      INIRec.WriteString('toma3', 'toma', TpTomadorToStr(Ide.toma03.Toma));

      INIRec.WriteString('toma4', 'CNPJCPF', Ide.toma4.CNPJCPF);
      INIRec.WriteString('toma4', 'IE', Ide.toma4.IE);
      INIRec.WriteString('toma4', 'xNome', Ide.toma4.xNome);
      INIRec.WriteString('toma4', 'xFant', Ide.toma4.xFant);
      INIRec.WriteString('toma4', 'fone', Ide.toma4.fone );

      with Ide.toma4.enderToma do
      begin
        INIRec.WriteString('toma4', 'xLgr', xLgr);
        INIRec.WriteString('toma4', 'nro', nro);
        INIRec.WriteString('toma4', 'xCpl', xCpl);
        INIRec.WriteString('toma4', 'xBairro', xBairro);
        INIRec.WriteInteger('toma4' ,'cMun', cMun);
        INIRec.WriteString('toma4', 'xMun', xMun);
        INIRec.WriteInteger('toma4', 'CEP', CEP);
        INIRec.WriteString('toma4', 'UF', UF);
        INIRec.WriteInteger('toma4', 'cPais', cPais);
        INIRec.WriteString('toma4', 'xPais', xPais);
      end;

      INIRec.WriteString('toma4', 'email', Ide.toma4.email);

      INIRec.WriteString('ide', 'dhCont', DateToStr(Ide.dhCont));
      INIRec.WriteString('ide', 'xJust', Ide.xJust);

      INIRec.WriteString('compl', 'xCaracAd', compl.xCaracAd);
      INIRec.WriteString('compl', 'xCaracSer', compl.xCaracSer);
      INIRec.WriteString('compl', 'xEmi', compl.xEmi);

      INIRec.WriteString('compl', 'tpPer', TpDataPeriodoToStr(compl.Entrega.TipoData));
      INIRec.WriteString('compl', 'tpHor', TpHorarioIntervaloToStr(compl.Entrega.TipoHora));
      {ainda tem mais dados aqui}

      {...}
      INIRec.WriteString('compl', 'origCalc', compl.origCalc);
      INIRec.WriteString('compl', 'destCalc', compl.destCalc);
      INIRec.WriteString('compl', 'xObs', compl.xObs);

      INIRec.WriteString('emit', 'CNPJ', Emit.CNPJ);
      INIRec.WriteString('emit', 'IE', Emit.IE);
      INIRec.WriteString('emit', 'xNome', Emit.xNome);
      INIRec.WriteString('emit', 'xFant', Emit.xFant);

      INIRec.WriteString('emit', 'xLgr', Emit.enderEmit.xLgr);
      INIRec.WriteString('emit', 'nro', Emit.enderEmit.nro);
      INIRec.WriteString('emit', 'xCpl', Emit.enderEmit.xCpl);
      INIRec.WriteString('emit', 'xBairro', Emit.enderEmit.xBairro);
      INIRec.WriteInteger('emit', 'cMun', Emit.enderEmit.cMun);
      INIRec.WriteString('emit', 'xMun', Emit.enderEmit.xMun);
      INIRec.WriteInteger('emit', 'CEP', Emit.enderEmit.CEP);
      INIRec.WriteString('emit', 'UF', Emit.enderEmit.UF);
      INIRec.WriteString('emit', 'fone', Emit.enderEmit.fone);

      INIRec.WriteString('rem', 'CNPJCPF', Rem.CNPJCPF);
      INIRec.WriteString('rem', 'IE', Rem.IE);
      INIRec.WriteString('rem', 'xNome', Rem.xNome);
      INIRec.WriteString('rem', 'xFant', Rem.xFant);
      INIRec.WriteString('rem', 'fone', Rem.fone);

      INIRec.WriteString('rem', 'xLgr', Rem.enderReme.xLgr);
      INIRec.WriteString('rem', 'nro', Rem.enderReme.nro);
      INIRec.WriteString('rem', 'xCpl', Rem.enderReme.xCpl);
      INIRec.WriteString('rem', 'xBairro', Rem.enderReme.xBairro);
      INIRec.WriteInteger('rem', 'cMun', Rem.enderReme.cMun);
      INIRec.WriteString('rem', 'xMun', Rem.enderReme.xMun);
      INIRec.WriteInteger('rem', 'CEP', Rem.enderReme.CEP);
      INIRec.WriteString('rem', 'UF', Rem.enderReme.UF);
      INIRec.WriteInteger('rem', 'PaisCod', Rem.enderReme.cPais);
      INIRec.WriteString('rem', 'Pais', Rem.enderReme.xPais);
      INIRec.WriteString('rem', 'Email', Rem.email);

      {$IFNDEF PL_200}
      for i := 0 to Rem.infNF.Count -1 do
      begin
        sSecao := 'infNF' + IntToStrZero(I+1, 3);

        with Rem.infNF.Items[i] do
        begin
          INIRec.WriteString(sSecao, 'nRoma', nRoma);
          INIRec.WriteString(sSecao, 'nPed', nPed);
          INIRec.WriteString(sSecao, 'mod', ModeloNFToStr(modelo));
          INIRec.WriteString(sSecao, 'serie', serie);
          INIRec.WriteString(sSecao, 'nDoc', nDoc);
          INIRec.WriteString(sSecao, 'dEmi', DateToStr(dEmi));
          INIRec.WriteString(sSecao, 'vBC', CurrToStr(vBC));
          INIRec.WriteString(sSecao, 'vICMS', CurrToStr(vICMS));
          INIRec.WriteString(sSecao, 'vBCST', CurrToStr(vBCST));
          INIRec.WriteString(sSecao, 'vST', CurrToStr(vST));
          INIRec.WriteString(sSecao, 'vProd', CurrToStr(vProd));
          INIRec.WriteString(sSecao, 'vNF', CurrToStr(vNF));
          INIRec.WriteInteger(sSecao, 'nCFOP', nCFOP);
          INIRec.WriteString(sSecao, 'nPeso', CurrToStr(nPeso));
          INIRec.WriteString(sSecao, 'PIN', PIN);
        end;
      end;

      for i := 0 to Rem.infNFe.Count -1 do
      begin
        sSecao := 'infNFe' + IntToStrZero(I+1, 3);

        with Rem.infNFe.Items[i] do
        begin
          INIRec.WriteString(sSecao, 'chave', chave);
          INIRec.WriteString(sSecao, 'PIN', PIN);
        end;
      end;
      {$ENDIF}

      INIRec.WriteString('Dest', 'CNPJCPF', Dest.CNPJCPF);
      INIRec.WriteString('Dest', 'IE', Dest.IE);
      INIRec.WriteString('Dest', 'xNome', Dest.xNome);
      INIRec.WriteString('Dest', 'fone', Dest.fone);

      INIRec.WriteString('Dest', 'xLgr', Dest.enderDest.xLgr);
      INIRec.WriteString('Dest', 'nro', Dest.enderDest.nro);
      INIRec.WriteString('Dest', 'xCpl', Dest.enderDest.xCpl);
      INIRec.WriteString('Dest', 'xBairro', Dest.enderDest.xBairro);
      INIRec.WriteInteger('Dest', 'cMun', Dest.enderDest.cMun);
      INIRec.WriteString('Dest', 'xMun', Dest.enderDest.xMun);
      INIRec.WriteInteger('Dest', 'CEP', Dest.enderDest.CEP);
      INIRec.WriteString('Dest', 'UF', Dest.enderDest.UF);

      INIRec.WriteInteger('Dest', 'cPais', Dest.enderDest.cPais);
      INIRec.WriteString('Dest', 'xPais', Dest.enderDest.xPais);

      INIRec.WriteString('vPrest', 'vTPrest', CurrToStr(vPrest.vTPrest));
      INIRec.WriteString('vPrest', 'vRec', CurrToStr(vPrest.vRec));

      for i := 0 to vPrest.comp.Count - 1 do
      begin
        sSecao    := 'Comp' + IntToStrZero(I+1, 3);
        with vPrest.comp.Items[i] do
        begin
          INIRec.WriteString(sSecao, 'xNome', xNome);
          INIRec.WriteString(sSecao, 'vComp', CurrToStr(vComp));
        end;
      end;

      if Imp.ICMS.ICMS00.CST = cst00 then
      begin
        INIRec.WriteString('ICMS00', 'CST', CSTICMSToStr(Imp.ICMS.ICMS00.CST));
        INIRec.WriteString('ICMS00', 'vBC', CurrToStr(Imp.ICMS.ICMS00.vBC));
        INIRec.WriteString('ICMS00', 'pICMS', CurrToStr(Imp.ICMS.ICMS00.pICMS));
        INIRec.WriteString('ICMS00', 'vICMS', CurrToStr(Imp.ICMS.ICMS00.vICMS));
      end;

      if Imp.ICMS.ICMS20.CST = cst20 then
      begin
        INIRec.WriteString('ICMS20', 'CST', CSTICMSToStr(Imp.ICMS.ICMS20.CST ));
        INIRec.WriteString('ICMS20', 'pRedBC', CurrToStr(Imp.ICMS.ICMS20.pRedBC));
        INIRec.WriteString('ICMS20', 'vBC', CurrToStr(Imp.ICMS.ICMS20.vBC));
        INIRec.WriteString('ICMS20', 'pICMS', CurrToStr(Imp.ICMS.ICMS20.pICMS));
        INIRec.WriteString('ICMS20', 'vICMS', CurrToStr(Imp.ICMS.ICMS20.vICMS));
      end;

      if Imp.ICMS.ICMS45.CST = cst45 then
        INIRec.WriteString('ICMS45', 'CST', CSTICMSToStr(Imp.ICMS.ICMS45.CST));

      if Imp.ICMS.ICMS60.CST = cst60 then
      begin
        INIRec.WriteString('ICMS60', 'CST', CSTICMSToStr(Imp.ICMS.ICMS60.CST));
        INIRec.WriteString('ICMS60', 'vBCSTRet', CurrToStr(Imp.ICMS.ICMS60.vBCSTRet));
        INIRec.WriteString('ICMS60', 'vICMSSTRet', CurrToStr(Imp.ICMS.ICMS60.vICMSSTRet));
        INIRec.WriteString('ICMS60', 'pICMSSTRet', CurrToStr(Imp.ICMS.ICMS60.pICMSSTRet));
        INIRec.WriteString('ICMS60', 'vCred', CurrToStr(Imp.ICMS.ICMS60.vCred));
      end;

      if Imp.ICMS.ICMS90.CST = cst90 then
      begin
        INIRec.WriteString('ICMS90', 'CST', CSTICMSToStr(Imp.ICMS.ICMS90.CST));
        INIRec.WriteString('ICMS90', 'pRedBC', CurrToStr(Imp.ICMS.ICMS90.pRedBC));
        INIRec.WriteString('ICMS90', 'vBC', CurrToStr(Imp.ICMS.ICMS90.vBC));
        INIRec.WriteString('ICMS90', 'pICMS', CurrToStr(Imp.ICMS.ICMS90.pICMS));
        INIRec.WriteString('ICMS90', 'vICMS', CurrToStr(Imp.ICMS.ICMS90.vICMS));
        INIRec.WriteString('ICMS90', 'vCred', CurrToStr(Imp.ICMS.ICMS90.vCred));
      end;

      if Imp.ICMS.ICMSOutraUF.CST = cstICMSOutraUF then
      begin
        INIRec.WriteString('ICMSOutraUF', 'CST', CSTICMSToStr(Imp.ICMS.ICMSOutraUF.CST));
        INIRec.WriteString('ICMSOutraUF', 'pRedBCOutraUF', CurrToStr(Imp.ICMS.ICMSOutraUF.pRedBCOutraUF));
        INIRec.WriteString('ICMSOutraUF', 'vBCOutraUF', CurrToStr(Imp.ICMS.ICMSOutraUF.vBCOutraUF));
        INIRec.WriteString('ICMSOutraUF', 'pICMSOutraUF', CurrToStr(Imp.ICMS.ICMSOutraUF.pICMSOutraUF));
        INIRec.WriteString('ICMSOutraUF', 'vICMSOutraUF', CurrToStr(Imp.ICMS.ICMSOutraUF.vICMSOutraUF));
      end;

      {indica se � simples}
      if (Imp.ICMS.ICMSSN.indSN = 1) and (Imp.ICMS.SituTrib = cstICMSSN) then
        INIRec.WriteInteger('ICMSSN', 'indSN', Imp.ICMS.ICMSSN.indSN);

      INIRec.WriteFloat('ICMSUFFim', 'vBCUFFim', Imp.ICMSUFFim.vBCUFFim);
      INIRec.WriteFloat('ICMSUFFim', 'pFCPUFFim', Imp.ICMSUFFim.pFCPUFFim);
      INIRec.WriteFloat('ICMSUFFim', 'pICMSUFFim', Imp.ICMSUFFim.pICMSUFFim);
      INIRec.WriteFloat('ICMSUFFim', 'pICMSInter', Imp.ICMSUFFim.pICMSInter);
      INIRec.WriteFloat('ICMSUFFim', 'pICMSInterPart', Imp.ICMSUFFim.pICMSInterPart);
      INIRec.WriteFloat('ICMSUFFim', 'vFCPUFFim', Imp.ICMSUFFim.vFCPUFFim);
      INIRec.WriteFloat('ICMSUFFim', 'vICMSUFFim', Imp.ICMSUFFim.vICMSUFFim);
      INIRec.WriteFloat('ICMSUFFim', 'vICMSUFIni', Imp.ICMSUFFim.vICMSUFIni);

      {$IFDEF PL_200}
      INIRec.WriteString('infCarga', 'vCarga', CurrToStr(infCTeNorm.infCarga.vCarga));
      INIRec.WriteString('infCarga', 'proPred', infCTeNorm.infCarga.proPred);
      INIRec.WriteString('infCarga', 'xOutCat', infCTeNorm.infCarga.xOutCat);
      {$ELSE}
      INIRec.WriteString('infCarga', 'vCarga', CurrToStr(infCarga.vCarga));
      INIRec.WriteString('infCarga', 'proPred', infCarga.proPred);
      INIRec.WriteString('infCarga', 'xOutCat', infCarga.xOutCat);
      {$ENDIF}

      {$IFDEF PL_200}
      for i := 0 to infCTeNorm.infCarga.infQ.Count -1 do
      {$ELSE}
      for i := 0 to infCarga.infQ.Count -1 do
      {$ENDIF}
      begin
        sSecao := 'infQ' + IntToStrZero(I+1, 3);

        {$IFDEF PL_200}
        with infCTeNorm.infCarga.infQ.Items[i] do
        {$ELSE}
        with infCarga.infQ.Items[i] do
        {$ENDIF}
        begin
          INIRec.WriteString(sSecao, 'cUnid', UnidMedToStr(cUnid));
          INIRec.WriteString(sSecao, 'tpMed', tpMed);
          INIRec.WriteString(sSecao, 'qCarga', CurrToStr(qCarga));
        end;
      end;

      {$IFDEF PL_200}
      for i := 0 to infCTeNorm.infDoc.infNF.Count -1 do
      begin
        sSecao := 'infNF' + IntToStrZero(I+1, 3);

        with infCTeNorm.infDoc.infNF.Items[i] do
        begin
          INIRec.WriteString(sSecao, 'nRoma', nRoma);
          INIRec.WriteString(sSecao, 'nPed', nPed);
          INIRec.WriteString(sSecao, 'mod', ModeloNFToStr(modelo));
          INIRec.WriteString(sSecao, 'serie', serie);
          INIRec.WriteString(sSecao, 'nDoc', nDoc);
          INIRec.WriteString(sSecao, 'dEmi', DateToStr(dEmi));
          INIRec.WriteString(sSecao, 'vBC', CurrToStr(vBC));
          INIRec.WriteString(sSecao, 'vICMS', CurrToStr(vICMS));
          INIRec.WriteString(sSecao, 'vBCST', CurrToStr(vBCST));
          INIRec.WriteString(sSecao, 'vST', CurrToStr(vST));
          INIRec.WriteString(sSecao, 'vProd', CurrToStr(vProd));
          INIRec.WriteString(sSecao, 'vNF', CurrToStr(vNF));
          INIRec.WriteInteger(sSecao, 'nCFOP', nCFOP);
          INIRec.WriteString(sSecao, 'nPeso', CurrToStr(nPeso));
          INIRec.WriteString(sSecao, 'PIN', PIN);
        end;
      end;

      for i := 0 to infCTeNorm.infDoc.infNFe.Count -1 do
      begin
        sSecao := 'infNFe' + IntToStrZero(I+1, 3);

        with infCTeNorm.infDoc.infNFe.Items[i] do
        begin
          INIRec.WriteString(sSecao, 'chave', chave);
          INIRec.WriteString(sSecao, 'PIN', PIN);
        end;
      end;
      {$ENDIF}

      {$IFDEF PL_200}
      for i:= 0 to infCTeNorm.seg.Count - 1 do
      {$ELSE}
      for i:= 0 to infSeg.Count - 1 do
      {$ENDIF}
      begin
        sSecao := 'infSeg' + IntToStrZero(I+1, 3);

        {$IFDEF PL_200}
        with infCTeNorm.seg.Items[i] do
        {$ELSE}
        with infSeg.Items[i] do
        {$ENDIF}
        begin
          INIRec.WriteString(sSecao, 'respSeg', TpRspSeguroToStr(respSeg));
          INIRec.WriteString(sSecao, 'xSeg', xSeg);
          INIRec.WriteString(sSecao, 'nApol', nApol);
          INIRec.WriteString(sSecao, 'nAver', nAver);
          INIRec.WriteString(sSecao, 'vCarga', CurrToStr(vCarga));
        end;
      end;

      {$IFDEF PL_200}
      if infCTeNorm.Rodo.RNTRC <> '' then
      begin
        INIRec.WriteString('Rodo', 'RNTRC', infCTeNorm.Rodo.RNTRC);
        INIRec.WriteString('Rodo', 'dPrev', DateToStr(infCTeNorm.Rodo.dPrev));
        INIRec.WriteString('Rodo', 'lota', TpLotacaoToStr(infCTeNorm.Rodo.Lota));
      end;
      {$ELSE}
      if Rodo.RNTRC <> '' then
      begin
        INIRec.WriteString('Rodo', 'RNTRC', Rodo.RNTRC);
        INIRec.WriteString('Rodo', 'dPrev', DateToStr(Rodo.dPrev));
        INIRec.WriteString('Rodo', 'lota', TpLotacaoToStr(Rodo.Lota));
      end;
      {$ENDIF}

      {$IFDEF PL_200}
      for i := 0 to autXML.Count - 1 do
      begin
        sSecao := 'autXML' + IntToStrZero(I+1, 2);

        with autXML.Items[i] do
        begin
          INIRec.WriteString(sSecao, 'CNPJCPF', CNPJCPF);
        end;
      end;
      {$ENDIF}
    end;

  finally
    IniCTe := TStringList.Create;
    try
      INIRec.GetStrings(IniCTe);
      INIRec.Free;
      Result := StringReplace(IniCTe.Text, sLineBreak + sLineBreak, sLineBreak, [rfReplaceAll]);
    finally
      IniCTe.Free;
    end;
  end;
end;

function Conhecimento.GerarXML: String;
var
  IdAnterior : String;
begin
  with TACBrCTe(TConhecimentos(Collection).ACBrCTe) do
  begin
    IdAnterior := CTe.infCTe.ID;
    FCTeW.Gerador.Opcoes.FormatoAlerta  := Configuracoes.Geral.FormatoAlerta;
    FCTeW.Gerador.Opcoes.RetirarAcentos := Configuracoes.Geral.RetirarAcentos;
    FCTeW.Gerador.Opcoes.RetirarEspacos := Configuracoes.Geral.RetirarEspacos;
    FCTeW.Gerador.Opcoes.IdentarXML     := Configuracoes.Geral.IdentarXML;
    FCTeW.Opcoes.NormatizarMunicipios   := Configuracoes.Arquivos.NormatizarMunicipios;
    FCTeW.Opcoes.PathArquivoMunicipios  := Configuracoes.Arquivos.PathArquivoMunicipios;

    pcnAuxiliar.TimeZoneConf.Assign( Configuracoes.WebServices.TimeZoneConf );

    FCTeW.idCSRT := Configuracoes.RespTec.IdCSRT;
    FCTeW.CSRT   := Configuracoes.RespTec.CSRT;
  end;

  FCTeW.GerarXml;

  XMLOriginal := FCTeW.Gerador.ArquivoFormatoXML;  // SetXMLOriginal() ir� converter para UTF8

  { XML gerado pode ter nova Chave e ID, ent�o devemos calcular novamente o
    nome do arquivo, mantendo o PATH do arquivo carregado }
  if (NaoEstaVazio(FNomeArq) and (IdAnterior <> FCTe.infCTe.ID)) then
    FNomeArq := CalcularNomeArquivoCompleto('', ExtractFilePath(FNomeArq));

  FAlertas := FCTeW.Gerador.ListaDeAlertas.Text;
  Result := FXMLOriginal;
end;

function Conhecimento.CalcularNomeArquivo: String;
var
  xID: String;
begin
  xID := Self.NumID;

  if EstaVazio(xID) then
    raise EACBrCTeException.Create('ID Inv�lido. Imposs�vel Salvar XML');

  Result := xID + '-cte.xml';
end;

function Conhecimento.CalcularPathArquivo: String;
var
  Data: TDateTime;
begin
  with TACBrCTe(TConhecimentos(Collection).ACBrCTe) do
  begin
    if Configuracoes.Arquivos.EmissaoPathCTe then
      Data := FCTe.Ide.dhEmi
    else
      Data := Now;

    Result := PathWithDelim(Configuracoes.Arquivos.GetPathCTe(Data, FCTe.Emit.CNPJ, FCTe.emit.IE));
  end;
end;

function Conhecimento.CalcularNomeArquivoCompleto(NomeArquivo: String;
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

function Conhecimento.ValidarConcatChave: Boolean;
var
  wAno, wMes, wDia: Word;
begin
  DecodeDate(CTe.ide.dhEmi, wAno, wMes, wDia);
  Result := not
     ((Copy(CTe.infCTe.ID,  4,  2) <> IntToStrZero(CTe.ide.cUF, 2)) or
     (Copy(CTe.infCTe.ID,  6,  2) <> Copy(FormatFloat('0000', wAno), 3, 2)) or
     (Copy(CTe.infCTe.ID,  8,  2) <> FormatFloat('00', wMes)) or
     (Copy(CTe.infCTe.ID, 10, 14) <> copy(OnlyNumber(CTe.Emit.CNPJ) + '00000000000000', 1, 14)) or
     (Copy(CTe.infCTe.ID, 24,  2) <> IntToStr(CTe.ide.modelo)) or
     (Copy(CTe.infCTe.ID, 26,  3) <> IntToStrZero(CTe.ide.serie, 3)) or
     (Copy(CTe.infCTe.ID, 29,  9) <> IntToStrZero(CTe.ide.nCT, 9)) or
     (Copy(CTe.infCTe.ID, 38,  1) <> TpEmisToStr(CTe.ide.tpEmis)) or
     (Copy(CTe.infCTe.ID, 39,  8) <> IntToStrZero(CTe.ide.cCT, 8)));
end;

function Conhecimento.GetConfirmado: Boolean;
begin
  Result := TACBrCTe(TConhecimentos(Collection).ACBrCTe).cStatConfirmado(
    FCTe.procCTe.cStat);
end;

function Conhecimento.GetcStat: Integer;
begin
  Result := FCTe.procCTe.cStat;
end;

function Conhecimento.GetProcessado: Boolean;
begin
  Result := TACBrCTe(TConhecimentos(Collection).ACBrCTe).cStatProcessado(
    FCTe.procCTe.cStat);
end;

function Conhecimento.GetCancelado: Boolean;
begin
  Result := TACBrCTe(TConhecimentos(Collection).ACBrCTe).cStatCancelado(
    FCTe.procCTe.cStat);
end;

function Conhecimento.GetMsg: String;
begin
  Result := FCTe.procCTe.xMotivo;
end;

function Conhecimento.GetNumID: String;
begin
  Result := Trim(OnlyNumber(CTe.infCTe.ID));
end;

function Conhecimento.GetXMLAssinado: String;
begin
  if EstaVazio(FXMLAssinado) then
    Assinar;

  Result := FXMLAssinado;
end;

procedure Conhecimento.SetXML(const AValue: String);
begin
  LerXML(AValue);
end;

procedure Conhecimento.SetXMLOriginal(const AValue: String);
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

function Conhecimento.LerArqIni(const AIniString: String): Boolean;
var
  I, J, K, L: Integer;
  sSecao, versao, sFim, sCampoAdic, sKey: String;
  OK: boolean;
  INIRec: TMemIniFile;
begin
  Result := False;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with FCTe do
    begin
      infCTe.versao := StringToFloatDef( INIRec.ReadString('infCTe','versao', VersaoCTeToStr(FConfiguracoes.Geral.VersaoDF)),0) ;
//      versao        := FloatToString(infCTe.versao, '.', '#0.00');
      versao        := infCTe.VersaoStr;
      versao        := StringReplace(versao,'versao="','',[rfReplaceAll,rfIgnoreCase]);
      versao        := StringReplace(versao,'"','',[rfReplaceAll,rfIgnoreCase]);

      Ide.cCT    := INIRec.ReadInteger('ide','cCT', 0);
      Ide.cUF    := INIRec.ReadInteger('ide','cUF', 0);
      Ide.CFOP   := INIRec.ReadInteger('ide','CFOP',0);
      Ide.natOp  := INIRec.ReadString('ide','natOp',EmptyStr);
      Ide.forPag := StrTotpforPag(OK,INIRec.ReadString('ide','forPag','0'));
      Ide.modelo := INIRec.ReadInteger( 'ide','mod' ,55);

      FConfiguracoes.Geral.ModeloDF := StrToModeloCTe(OK, IntToStr(Ide.modelo));
      FConfiguracoes.Geral.VersaoDF := StrToVersaoCTe(OK, versao);

      Ide.serie   := INIRec.ReadInteger( 'ide','serie'  ,1);
      Ide.nCT     := INIRec.ReadInteger( 'ide','nCT' ,0);
      Ide.dhEmi   := StringToDateTime(INIRec.ReadString( 'ide','dhEmi','0'));
      Ide.tpImp   := StrToTpImp(  OK, INIRec.ReadString( 'ide','tpImp', '1'));
      Ide.tpEmis  := StrToTpEmis( OK,INIRec.ReadString( 'ide','tpemis',IntToStr(FConfiguracoes.Geral.FormaEmissaoCodigo)));
      Ide.tpAmb   := StrToTpAmb(  OK, INIRec.ReadString( 'ide','tpAmb', TpAmbToStr(FConfiguracoes.WebServices.Ambiente)));
      Ide.tpCTe   := StrTotpCTe(OK,INIRec.ReadString('ide','tpCTe','0'));
      Ide.procEmi := StrToProcEmi(OK,INIRec.ReadString( 'ide','procEmi','0'));
      Ide.verProc := INIRec.ReadString(  'ide','verProc' ,'ACBrCTe' );
      Ide.refCTe  := INIRec.ReadString('ide','refCTe','');
      Ide.cMunEnv := INIRec.ReadInteger('ide','cMunEnv',0);
      Ide.xMunEnv := INIRec.ReadString('ide','xMunEnv','');
      Ide.UFEnv   := INIRec.ReadString('ide','UFEnv','');
      Ide.modal   := StrToTpModal(OK, INIRec.ReadString('ide','modal','01'));
      Ide.tpServ  := StrToTpServ(OK,INIRec.ReadString('ide','tpServ','0'));
      Ide.cMunIni := INIRec.ReadInteger('ide','cMunIni',0);
      Ide.xMunIni := INIRec.ReadString('ide','xMunIni','');
      Ide.UFIni   := INIRec.ReadString('ide','UFIni','');
      Ide.cMunFim := INIRec.ReadInteger('ide','cMunFim',0);
      Ide.xMunFim := INIRec.ReadString('ide','xMunFim','');
      Ide.UFFim   := INIRec.ReadString('ide','UFFim','');
      Ide.retira  := StrToTpRetira(OK,INIRec.ReadString('ide','retira','0'));

      if INIRec.ReadString('ide','xDetRetira','') <> '' then
        Ide.xDetRetira := INIRec.ReadString('ide','xDetRetira','');

      Ide.dhCont := StringToDateTime(INIRec.ReadString( 'ide','dhCont'  ,'0'));
      Ide.xJust  := INIRec.ReadString(  'ide','xJust' ,'' );

      Ide.toma03.Toma    := StrToTpTomador(OK,INIRec.ReadString('toma3','toma','0'));
      Ide.indGlobalizado := StrToTIndicador(OK, INIRec.ReadString('ide','indGlobalizado','0'));
      Ide.indIEToma      := StrToindIEDest(OK, INIRec.ReadString('ide','indIEToma','1'));

      //CT-e OS
      I := 1;
      while true do
      begin
        sSecao := 'infPercurso'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'UFPer','FIM');
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;
        with Ide.infPercurso.New do
        begin
          UFPer := sFim;
        end;
        Inc(I);
      end;

      if INIRec.ReadString('toma4','xNome','') <> '' then
      begin
        Ide.toma4.toma    := StrToTpTomador(OK,INIRec.ReadString('toma4','toma','0'));
        Ide.toma4.CNPJCPF := INIRec.ReadString('toma4','CNPJCPF','');
        Ide.toma4.IE      := INIRec.ReadString('toma4','IE','');
        Ide.toma4.xNome   := INIRec.ReadString('toma4','xNome','');
        Ide.toma4.xFant   := INIRec.ReadString('toma4','xFant','');
        Ide.toma4.fone    := INIRec.ReadString('toma4','fone','');

        with Ide.toma4.enderToma do
        begin
          xLgr    := INIRec.ReadString('toma4','xLgr','');
          nro     := INIRec.ReadString('toma4','nro','');
          xCpl    := INIRec.ReadString('toma4','xCpl','');
          xBairro := INIRec.ReadString('toma4','xBairro','');
          cMun    := INIRec.ReadInteger('toma4','cMun',0);
          xMun    := INIRec.ReadString('toma4','xMun','');
          CEP     := INIRec.ReadInteger('toma4','CEP',0);
          UF      := INIRec.ReadString('toma4','UF','');
          cPais   := INIRec.ReadInteger('toma4','cPais',0);
          xPais   := INIRec.ReadString('toma4','xPais','');
        end;

        Ide.toma4.email := INIRec.ReadString('toma4','email','');
      end;

      Compl.xCaracAd  := INIRec.ReadString('compl','xCaracAd', '' );
      Compl.xCaracSer := INIRec.ReadString('compl','xCaracSer',''  );
      Compl.xEmi      := INIRec.ReadString('compl','xEmi','');

      Compl.fluxo.xOrig := INIRec.ReadString('compl','xOrig','');
      Compl.fluxo.xDest := INIRec.ReadString('compl','xDest','');
      Compl.fluxo.xRota := INIRec.ReadString('compl','xRota','');

      I := 1;
      while true do
      begin
        sSecao := 'PASS'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'xPass','FIM');
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;
        with compl.fluxo.pass.New do
        begin
          xPass := INIRec.ReadString(sSecao,'xPass','');
        end;
        Inc(I);
      end;

      Compl.Entrega.TipoData := StrToTpDataPeriodo(ok,INIRec.ReadString('compl','TipoData','0'));
      case Compl.Entrega.TipoData of
       tdSemData:
          begin
            Compl.Entrega.semData.tpPer := StrToTpDataPeriodo(ok,INIRec.ReadString('compl','tpPer','0'));
          end;
       tdNaData,tdAteData,tdApartirData:
          begin
            Compl.Entrega.comData.tpPer := StrToTpDataPeriodo(ok,INIRec.ReadString('compl','tpPer','0'));
            Compl.Entrega.comData.dProg := StringToDateTime(INIRec.ReadString('compl','dProg','0'));
          end;
       tdNoPeriodo:
          begin
            Compl.Entrega.noPeriodo.tpPer := StrToTpDataPeriodo(ok,INIRec.ReadString('compl','tpPer','0'));
            Compl.Entrega.noPeriodo.dIni  := StringToDateTime(INIRec.ReadString('compl','dIni','0'));
            Compl.Entrega.noPeriodo.dFim  := StringToDateTime(INIRec.ReadString('compl','dFim','0'));
          end;
      end;

      Compl.Entrega.TipoHora := StrToTpHorarioIntervalo(ok,INIRec.ReadString('compl','TipoHora','0'));
      case Compl.Entrega.TipoHora of
       thSemHorario:
          begin
            Compl.Entrega.semHora.tpHor := StrToTpHorarioIntervalo(ok,INIRec.ReadString('compl','tpHor','0'));
          end;
       thNoHorario,thAteHorario,thApartirHorario:
          begin
            Compl.Entrega.comHora.tpHor := StrToTpHorarioIntervalo(ok,INIRec.ReadString('compl','tpHor','0'));
            Compl.Entrega.comHora.hProg := StrToTime(INIRec.ReadString('compl','hProg','0'));
          end;
       thNoIntervalo:
          begin
            Compl.Entrega.noInter.tpHor := StrToTpHorarioIntervalo(ok,INIRec.ReadString('compl','tpHor','0'));
            Compl.Entrega.noInter.hIni  := StrToTime(INIRec.ReadString('compl','hIni','0'));
            Compl.Entrega.noInter.hFim  := StrToTime(INIRec.ReadString('compl','hFim','0'));
          end;
      end;

      Compl.origCalc := INIRec.ReadString('compl','origCalc','');
      Compl.destCalc := INIRec.ReadString('compl','destCalc','');
      Compl.xObs     := INIRec.ReadString('compl','xObs','');

      I := 1;
      while true do
      begin
        sSecao     := 'ObsCont'+IntToStrZero(I,3);
        sCampoAdic := INIRec.ReadString(sSecao,'Campo',INIRec.ReadString(sSecao,'xCampo','FIM'));
        if (sCampoAdic = 'FIM') or (Length(sCampoAdic) <= 0) then
          break;

        with Compl.ObsCont.New do
        begin
          xCampo := sCampoAdic;
          xTexto := INIRec.ReadString( sSecao,'Texto',INIRec.ReadString( sSecao,'xTexto',''));
        end;
        Inc(I);
      end;

      I := 1;
      while true do
      begin
        sSecao     := 'ObsFisco'+IntToStrZero(I,3);
        sCampoAdic := INIRec.ReadString(sSecao,'Campo',INIRec.ReadString(sSecao,'xCampo','FIM'));
        if (sCampoAdic = 'FIM') or (Length(sCampoAdic) <= 0) then
          break;

        with Compl.ObsFisco.New do
        begin
          xCampo := sCampoAdic;
          xTexto := INIRec.ReadString( sSecao,'Texto',INIRec.ReadString( sSecao,'xTexto',''));
        end;
        Inc(I);
      end;

      Emit.CNPJ  := INIRec.ReadString('emit','CNPJ','');
      Emit.IE    := INIRec.ReadString('emit','IE','');
      Emit.xNome := INIRec.ReadString('emit','xNome','');
      Emit.xFant := INIRec.ReadString('emit','xFant','');

      Emit.enderEmit.xLgr    := INIRec.ReadString('emit','xLgr','');
      Emit.enderEmit.nro     := INIRec.ReadString('emit','nro','');
      Emit.enderEmit.xCpl    := INIRec.ReadString('emit', 'xCpl','');
      Emit.enderEmit.xBairro := INIRec.ReadString('emit','xBairro','');
      Emit.enderEmit.cMun    := INIRec.ReadInteger('emit','cMun',0);
      Emit.enderEmit.xMun    := INIRec.ReadString('emit','xMun','');
      Emit.enderEmit.CEP     := INIRec.ReadInteger('emit','CEP',0);
      Emit.enderEmit.UF      := INIRec.ReadString('emit','UF','');
      Emit.enderEmit.fone    := INIRec.ReadString('emit','fone','');

      ide.cUF := INIRec.ReadInteger('ide','cUF', UFparaCodigo(Emit.enderEmit.UF));

      Rem.CNPJCPF := INIRec.ReadString('rem','CNPJCPF','');
      Rem.IE      := INIRec.ReadString('rem','IE','');
      Rem.xNome   := INIRec.ReadString('rem','xNome','');
      Rem.xFant   := INIRec.ReadString('rem','xFant','');
      Rem.fone    := INIRec.ReadString('rem','fone','');

      Rem.enderReme.xLgr    := INIRec.ReadString('rem','xLgr','');
      Rem.enderReme.nro     := INIRec.ReadString('rem','nro','');
      Rem.enderReme.xCpl    := INIRec.ReadString('rem','xCpl','');
      Rem.enderReme.xBairro := INIRec.ReadString('rem','xBairro','');
      Rem.enderReme.cMun    := INIRec.ReadInteger('rem','cMun',0);
      Rem.enderReme.xMun    := INIRec.ReadString('rem','xMun','');
      Rem.enderReme.CEP     := INIRec.ReadInteger('rem','CEP',0);
      Rem.enderReme.UF      := INIRec.ReadString('rem','UF','');
      Rem.enderReme.cPais   := INIRec.ReadInteger( 'rem','cPais'    ,1058);
      Rem.enderReme.xPais   := INIRec.ReadString(  'rem','xPais'    ,'BRASIL');
      Rem.email             := INIRec.ReadString(  'rem','email' ,'');

      {$IFDEF PL_200}
      Rem.locColeta.CNPJCPF := INIRec.ReadString('locColeta','CNPJCPF','');
      Rem.locColeta.xNome   := INIRec.ReadString('locColeta','xNome','');
      Rem.locColeta.xLgr    := INIRec.ReadString('locColeta','xLgr','');
      Rem.locColeta.nro     := INIRec.ReadString('locColeta','nro','');
      Rem.locColeta.xCpl    := INIRec.ReadString('locColeta','xCpl','');
      Rem.locColeta.xBairro := INIRec.ReadString('locColeta','xBairro','');
      Rem.locColeta.cMun    := INIRec.ReadInteger('locColeta','cMun',0);
      Rem.locColeta.xMun    := INIRec.ReadString('locColeta','xMun','');
      Rem.locColeta.uf      := INIRec.ReadString('locColeta','UF','');
     {$ENDIF}

      //CT-e OS
      if INIRec.ReadString('toma','CNPJCPF','') <> '' then
      begin
        toma.CNPJCPF := INIRec.ReadString('toma','CNPJCPF','');
        toma.IE      := INIRec.ReadString('toma','IE','');
        toma.xNome   := INIRec.ReadString('toma','xNome','');
        toma.xFant   := INIRec.ReadString('toma','xFant','');
        toma.email   := INIRec.ReadString('toma','email','');
        toma.fone    := INIRec.ReadString('toma','fone','');

        toma.endertoma.xLgr    := INIRec.ReadString('toma','xLgr','');
        toma.endertoma.nro     := INIRec.ReadString('toma','nro','');
        toma.endertoma.xCpl    := INIRec.ReadString('toma', 'xCpl','');
        toma.endertoma.xBairro := INIRec.ReadString('toma','xBairro','');
        toma.endertoma.cMun    := INIRec.ReadInteger('toma','cMun',0);
        toma.endertoma.xMun    := INIRec.ReadString('toma','xMun','');
        toma.endertoma.CEP     := INIRec.ReadInteger('toma','CEP',0);
        toma.endertoma.UF      := INIRec.ReadString('toma','UF','');
        toma.endertoma.cPais   := INIRec.ReadInteger('toma','cPais',1058);
        toma.endertoma.xPais   := INIRec.ReadString('toma','xPais','');
      end;

      I := 1;
      while true do
      begin
        sSecao := 'infNF'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'mod','FIM');
        if sFim = 'FIM' then
          break;

        {$IFDEF PL_200}
        with infCTeNorm.infDoc.infNF.New do
        {$ELSE}
        with Rem.InfNF.Add do
        {$ENDIF}
        begin
          nRoma  := INIRec.ReadString(sSecao,'nRoma','');
          nPed   := INIRec.ReadString(sSecao,'nPed','');
          modelo := StrToModeloNF(OK,INIRec.ReadString(sSecao,'mod','01'));
          serie  := INIRec.ReadString(sSecao,'serie','');
          nDoc   := INIRec.ReadString(sSecao,'nDoc','');
          dEmi   := StringToDateTime(INIRec.ReadString( sSecao,'dEmi','0'));
          vBC    := StringToFloatDef( INIRec.ReadString(sSecao,'vBC','') ,0);
          vICMS  := StringToFloatDef( INIRec.ReadString(sSecao,'vICMS','') ,0);
          vBCST  := StringToFloatDef( INIRec.ReadString(sSecao,'vBCST','') ,0);
          vST    := StringToFloatDef( INIRec.ReadString(sSecao,'vST','') ,0);
          vProd  := StringToFloatDef( INIRec.ReadString(sSecao,'vProd','') ,0);
          vNF    := StringToFloatDef( INIRec.ReadString(sSecao,'vNF','') ,0);
          nCFOP  := INIRec.ReadInteger(sSecao,'nCFOP',0);
          nPeso  := StringToFloatDef( INIRec.ReadString(sSecao,'nPeso','') ,0);
          PIN    := INIRec.ReadString(sSecao,'PIN','');
          dPrev  := StringToDateTime(INIRec.ReadString( sSecao,'dPrev','0'));

          {$IFNDEF PL_200}
          locRet.CNPJCPF := INIRec.ReadString(sSecao,'CNPJCPF','');
          locRet.xNome   := INIRec.ReadString(sSecao,'xNome','');
          locRet.xLgr    := INIRec.ReadString(sSecao,'xLgr','');
          locRet.nro     := INIRec.ReadString(sSecao,'nro','');
          locRet.xCpl    := INIRec.ReadString(sSecao,'xCpl','');
          locRet.xBairro := INIRec.ReadString(sSecao,'xBairro','');
          locRet.cMun    := INIRec.ReadInteger(sSecao,'cMun',0);
          locRet.xMun    := INIRec.ReadString(sSecao,'xMun','');
          locRet.uf      := INIRec.ReadString(sSecao,'UF','');
          {$ENDIF}

          {$IFDEF PL_200}
          J := 1;
          while true do
          begin
            sSecao := 'infUnidTransp'+IntToStrZero(I,3)+IntToStrZero(J,3);
            sFim   := INIRec.ReadString(sSecao,'idUnidTransp','FIM');

            if sFim = 'FIM' then
              break;

            with infUnidTransp.New do
            begin
              tpUnidTransp := StrToUnidTransp(OK,INIRec.ReadString(sSecao,'tpUnidTransp','1'));
              idUnidTransp := INIRec.ReadString(sSecao,'idUnidTransp','');
              qtdRat       := StringToFloatDef( INIRec.ReadString(sSecao,'qtdRat',''),0);

              K := 1;
              while true do
              begin
                sSecao := 'lacUnidTransp'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3);
                sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');

                if sFim = 'FIM' then
                  break;

                with lacUnidTransp.New do
                begin
                  nLacre := INIRec.ReadString(sSecao,'nLacre','');
                end;

                inc(K);
              end;

              K := 1;
              while true do
              begin
                sSecao := 'infUnidCarga'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3);
                sFim   := INIRec.ReadString(sSecao,'idUnidCarga','FIM');

                if sFim = 'FIM' then
                  break;

                with infUnidCarga.New do
                begin
                  tpUnidCarga := StrToUnidCarga(OK,INIRec.ReadString(sSecao,'tpUnidCarga','1'));
                  idUnidCarga := INIRec.ReadString(sSecao,'idUnidCarga','');
                  qtdRat      := StringToFloatDef( INIRec.ReadString(sSecao,'qtdRat',''),0);

                  L := 1;
                  while true do
                  begin
                    sSecao := 'lacUnidCarga'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3)+IntToStrZero(L,3);
                    sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');

                    if sFim = 'FIM' then
                      break;

                    with lacUnidCarga.New do
                    begin
                      nLacre := INIRec.ReadString(sSecao,'nLacre','');
                    end;

                    inc(L);
                  end;
                end;
                inc(K);
              end;
              inc(J);
            end;
          end;

          J := 1;
          while true do
          begin
            sSecao := 'infUnidCarga'+IntToStrZero(I,3)+IntToStrZero(J,3);
            sFim   := INIRec.ReadString(sSecao,'idUnidCarga','FIM');

            if sFim = 'FIM' then
              break;

            with infUnidCarga.New do
            begin
              tpUnidCarga := StrToUnidCarga(OK,INIRec.ReadString(sSecao,'tpUnidCarga','1'));
              idUnidCarga := INIRec.ReadString(sSecao,'idUnidCarga','');
              qtdRat      := StringToFloatDef( INIRec.ReadString(sSecao,'qtdRat',''),0);

              K := 1;
              while true do
              begin
                sSecao := 'lacUnidCarga'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3);
                sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');

                if sFim = 'FIM' then
                  break;

                with lacUnidCarga.New do
                begin
                  nLacre := INIRec.ReadString(sSecao,'nLacre','');
                end;

                inc(K);
              end;
            end;
            inc(J);
          end;
          {$ENDIF}

        end;
        inc(I);
      end;

      I := 1;
      while true do
      begin
        sSecao := 'infNFe'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'chave','FIM');
        if sFim = 'FIM' then
          break;

        {$IFDEF PL_200}
        with infCTeNorm.infDoc.infNFe.New do
        {$ELSE}
        with Rem.InfNFe.Add do
        {$ENDIF}
        begin
          chave := INIRec.ReadString(sSecao,'chave','');
          PIN   := INIRec.ReadString(sSecao,'PIN','');
          dPrev := StringToDateTime(INIRec.ReadString( sSecao,'dPrev','0'));

          {$IFDEF PL_200}
          J := 1;
          while true do
          begin
            sSecao := 'infUnidTransp'+IntToStrZero(I,3)+IntToStrZero(J,3);
            sFim   := INIRec.ReadString(sSecao,'idUnidTransp','FIM');
            if sFim = 'FIM' then
              break;
            with infUnidTransp.New do
            begin
              tpUnidTransp := StrToUnidTransp(OK,INIRec.ReadString(sSecao,'tpUnidTransp','1'));
              idUnidTransp := INIRec.ReadString(sSecao,'idUnidTransp','');
              qtdRat       := StringToFloatDef( INIRec.ReadString(sSecao,'qtdRat',''),0);

              K := 1;
              while true do
              begin
                sSecao := 'lacUnidTransp'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3);
                sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');
                if sFim = 'FIM' then
                  break;
                with lacUnidTransp.New do
                begin
                  nLacre := INIRec.ReadString(sSecao,'nLacre','');
                end;
                inc(K);
              end;

              K := 1;
              while true do
              begin
                sSecao := 'infUnidCarga'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3);
                sFim   := INIRec.ReadString(sSecao,'idUnidCarga','FIM');
                if sFim = 'FIM' then
                  break;
                with infUnidCarga.New do
                begin
                  tpUnidCarga := StrToUnidCarga(OK,INIRec.ReadString(sSecao,'tpUnidCarga','1'));
                  idUnidCarga := INIRec.ReadString(sSecao,'idUnidCarga','');
                  qtdRat      := StringToFloatDef( INIRec.ReadString(sSecao,'qtdRat',''),0);

                  L := 1;
                  while true do
                  begin
                    sSecao := 'lacUnidCarga'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3)+IntToStrZero(L,3);
                    sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');
                    if sFim = 'FIM' then
                      break;
                    with lacUnidCarga.New do
                    begin
                      nLacre := INIRec.ReadString(sSecao,'nLacre','');
                    end;
                    inc(L);
                  end;
                  inc(K);
                end;
              end;
            end;
            inc(J);
          end;

          J := 1;
          while true do
          begin
            sSecao := 'infUnidCarga'+IntToStrZero(I,3)+IntToStrZero(J,3);
            sFim   := INIRec.ReadString(sSecao,'idUnidCarga','FIM');
            if sFim = 'FIM' then
              break;
            with infUnidCarga.New do
            begin
              tpUnidCarga := StrToUnidCarga(OK,INIRec.ReadString(sSecao,'tpUnidCarga','1'));
              idUnidCarga := INIRec.ReadString(sSecao,'idUnidCarga','');
              qtdRat      := StringToFloatDef( INIRec.ReadString(sSecao,'qtdRat',''),0);

              K := 1;
              while true do
              begin
                sSecao := 'lacUnidCarga'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3);
                sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');
                if sFim = 'FIM' then
                  break;
                with lacUnidCarga.New do
                begin
                  nLacre := INIRec.ReadString(sSecao,'nLacre','');
                end;
                inc(K);
              end;
            end;
            inc(J);
          end;
          {$ENDIF}

        end;
        Inc(I);
      end;

      I := 1;
      while true do
      begin
        sSecao := 'infOutros'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'nDoc','FIM');
        if sFim = 'FIM' then
          break;

        {$IFDEF PL_200}
        with infCTeNorm.infDoc.infOutros.New do
        {$ELSE}
        with Rem.InfOutros.Add do
        {$ENDIF}
        begin
          tpDoc      := StrToTpDocumento(OK,INIRec.ReadString(sSecao,'tpDoc','01'));
          descOutros := INIRec.ReadString(sSecao,'descOutros','');
          nDoc       := INIRec.ReadString(sSecao,'nDoc','');
          dEmi       := StringToDateTime(INIRec.ReadString( sSecao,'dEmi','0'));
          vDocFisc   := StringToFloatDef( INIRec.ReadString(sSecao,'vDocFisc','') ,0);
          dPrev      := StringToDateTime(INIRec.ReadString( sSecao,'dPrev','0'));

          {$IFDEF PL_200}
          J := 1;
          while true do
          begin
            sSecao := 'infUnidTransp'+IntToStrZero(I,3)+IntToStrZero(J,3);
            sFim   := INIRec.ReadString(sSecao,'idUnidTransp','FIM');
            if sFim = 'FIM' then
              break;
            with infUnidTransp.New do
            begin
              tpUnidTransp := StrToUnidTransp(OK,INIRec.ReadString(sSecao,'tpUnidTransp','1'));
              idUnidTransp := INIRec.ReadString(sSecao,'idUnidTransp','');
              qtdRat       := StringToFloatDef( INIRec.ReadString(sSecao,'qtdRat',''),0);

              K := 1;
              while true do
              begin
                sSecao := 'lacUnidTransp'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3);
                sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');
                if sFim = 'FIM' then
                  break;
                with lacUnidTransp.New do
                begin
                  nLacre := INIRec.ReadString(sSecao,'nLacre','');
                end;
                inc(K);
              end;

              K := 1;
              while true do
              begin
                sSecao := 'infUnidCarga'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3);
                sFim   := INIRec.ReadString(sSecao,'idUnidCarga','FIM');
                if sFim = 'FIM' then
                  break;
                with infUnidCarga.New do
                begin
                  tpUnidCarga := StrToUnidCarga(OK,INIRec.ReadString(sSecao,'tpUnidCarga','1'));
                  idUnidCarga := INIRec.ReadString(sSecao,'idUnidCarga','');
                  qtdRat      := StringToFloatDef( INIRec.ReadString(sSecao,'qtdRat',''),0);

                  L := 1;
                  while true do
                  begin
                    sSecao := 'lacUnidCarga'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3)+IntToStrZero(L,3);
                    sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');
                    if sFim = 'FIM' then
                      break;
                    with lacUnidCarga.New do
                    begin
                      nLacre := INIRec.ReadString(sSecao,'nLacre','');
                    end;
                    inc(L);
                  end;
                end;
                inc(K);
              end;
            end;
            inc(J);
          end;

          J := 1;
          while true do
          begin
            sSecao := 'infUnidCarga'+IntToStrZero(I,3)+IntToStrZero(J,3);
            sFim   := INIRec.ReadString(sSecao,'idUnidCarga','FIM');
            if sFim = 'FIM' then
              break;
            with infUnidCarga.New do
            begin
              tpUnidCarga := StrToUnidCarga(OK,INIRec.ReadString(sSecao,'tpUnidCarga','1'));
              idUnidCarga := INIRec.ReadString(sSecao,'idUnidCarga','');
              qtdRat      := StringToFloatDef( INIRec.ReadString(sSecao,'qtdRat',''),0);

              K := 1;
              while true do
              begin
                sSecao := 'lacUnidCarga'+IntToStrZero(I,3)+IntToStrZero(J,3)+IntToStrZero(K,3);
                sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');
                if sFim = 'FIM' then
                  break;
                with lacUnidCarga.New do
                begin
                  nLacre := INIRec.ReadString(sSecao,'nLacre','');
                end;
                inc(K);
              end;
            end;
            inc(J);
          end;
          {$ENDIF}
        end;
        Inc(I);
      end;

      Exped.CNPJCPF := INIRec.ReadString('Exped','CNPJCPF','');
      Exped.IE      := INIRec.ReadString('Exped','IE','');
      Exped.xNome   := INIRec.ReadString('Exped','xNome','');
      Exped.fone    := INIRec.ReadString('Exped','fone','');
      Exped.email   := INIRec.ReadString('Exped','email','');

      Exped.enderExped.xLgr    := INIRec.ReadString('Exped','xLgr','');
      Exped.enderExped.nro     := INIRec.ReadString('Exped','nro','');
      Exped.enderExped.xCpl    := INIRec.ReadString('Exped','xCpl','');
      Exped.enderExped.xBairro := INIRec.ReadString('Exped','xBairro','');
      Exped.enderExped.cMun    := INIRec.ReadInteger('Exped','cMun',0);
      Exped.enderExped.xMun    := INIRec.ReadString('Exped','xMun','');
      Exped.enderExped.CEP     := INIRec.ReadInteger('Exped', 'CEP',0);
      Exped.enderExped.UF      := INIRec.ReadString('Exped','UF','');
      Exped.enderExped.cPais   := INIRec.ReadInteger('Exped','cPais',1058);
      Exped.enderExped.xPais   := INIRec.ReadString('Exped', 'xPais', 'BRASIL');

      Receb.CNPJCPF := INIRec.ReadString('Receb','CNPJCPF','');
      Receb.IE      := INIRec.ReadString('Receb','IE','');
      Receb.xNome   := INIRec.ReadString('Receb','xNome','');
      Receb.fone    := INIRec.ReadString('Receb','fone','');
      Receb.email   := INIRec.ReadString('Receb','email','');

      Receb.enderReceb.xLgr    := INIRec.ReadString('Receb','xLgr','');
      Receb.enderReceb.nro     := INIRec.ReadString('Receb','nro','');
      Receb.enderReceb.xCpl    := INIRec.ReadString('Receb','xCpl','');
      Receb.enderReceb.xBairro := INIRec.ReadString('Receb','xBairro','');
      Receb.enderReceb.cMun    := INIRec.ReadInteger('Receb','cMun',0);
      Receb.enderReceb.xMun    := INIRec.ReadString('Receb','xMun','');
      Receb.enderReceb.CEP     := INIRec.ReadInteger('Receb', 'CEP',0);
      Receb.enderReceb.UF      := INIRec.ReadString('Receb','UF','');
      Receb.enderReceb.cPais   := INIRec.ReadInteger('Receb','cPais',1058);
      Receb.enderReceb.xPais   := INIRec.ReadString('Receb', 'xPais', 'BRASIL');

      Dest.CNPJCPF := INIRec.ReadString('Dest','CNPJCPF','');
      Dest.IE      := INIRec.ReadString('Dest','IE','');
      Dest.xNome   := INIRec.ReadString('Dest','xNome','');
      Dest.fone    := INIRec.ReadString('Dest','fone','');
      Dest.email   := INIRec.ReadString('Dest','email','');
      Dest.ISUF    := INIRec.ReadString('Dest','ISUF','');

      Dest.enderDest.xLgr    := INIRec.ReadString('Dest','xLgr','');
      Dest.enderDest.nro     := INIRec.ReadString('Dest','nro','');
      Dest.enderDest.xBairro := INIRec.ReadString('Dest','xBairro','');
      Dest.enderDest.cMun    := INIRec.ReadInteger('Dest','cMun',0);
      Dest.enderDest.xMun    := INIRec.ReadString('Dest','xMun','');
      Dest.enderDest.CEP     := INIRec.ReadInteger('Dest', 'CEP',0);
      Dest.enderDest.UF      := INIRec.ReadString('Dest','UF','');
      Dest.enderDest.cPais   := INIRec.ReadInteger('Dest','cPais',1058);
      Dest.enderDest.xPais   := INIRec.ReadString('Dest', 'xPais', 'BRASIL');

      Dest.locEnt.CNPJCPF := INIRec.ReadString('locEnt','CNPJCPF','');
      Dest.locEnt.xNome   := INIRec.ReadString('locEnt','xNome','');
      Dest.locEnt.xLgr    := INIRec.ReadString('locEnt','xLgr','');
      Dest.locEnt.nro     := INIRec.ReadString('locEnt','nro','');
      Dest.locEnt.xCpl    := INIRec.ReadString('locEnt','xCpl','');
      Dest.locEnt.xBairro := INIRec.ReadString('locEnt','xBairro','');
      Dest.locEnt.cMun    := INIRec.ReadInteger('locEnt','cMun',0);
      Dest.locEnt.xMun    := INIRec.ReadString('locEnt','xMun','');
      Dest.locEnt.uf      := INIRec.ReadString('locEnt','UF','');

      vPrest.vTPrest := StringToFloatDef( INIRec.ReadString('vPrest','vTPrest','') ,0);
      vPrest.vRec    := StringToFloatDef( INIRec.ReadString('vPrest','vRec','') ,0);

      I := 1;
      while true do
      begin
        sSecao := 'Comp'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'xNome','FIM');
        if sFim = 'FIM' then
          break;

        with vPrest.comp.New do
        begin
          xNome := INIRec.ReadString(sSecao,'xNome','');
          vComp := StringToFloatDef( INIRec.ReadString(sSecao,'vComp','') ,0);
        end;
        Inc(I);
      end;

      Imp.vTotTrib   := StringToFloatDef( INIRec.ReadString('Imp','vTotTrib',INIRec.ReadString('ICMS','vTotTrib','')) ,0);
      Imp.infAdFisco := INIRec.ReadString('Imp','infAdFisco',INIRec.ReadString('ICMS','infAdFisco',''));

      if INIRec.ReadString('ICMS00', 'CST','') <> '' then
      begin
        Imp.ICMS.ICMS00.CST   := StrToCSTICMS(OK,INIRec.ReadString('ICMS00','CST','00'));
        imp.ICMS.SituTrib     := Imp.ICMS.ICMS00.CST;
        Imp.ICMS.ICMS00.vBC   := StringToFloatDef( INIRec.ReadString('ICMS00','vBC','') ,0);
        Imp.ICMS.ICMS00.pICMS := StringToFloatDef( INIRec.ReadString('ICMS00','pICMS','') ,0);
        Imp.ICMS.ICMS00.vICMS := StringToFloatDef( INIRec.ReadString('ICMS00','vICMS','') ,0);
      end;

      if INIRec.ReadString('ICMS20', 'CST','') <> '' then
      begin
        Imp.ICMS.ICMS20.CST    := StrToCSTICMS(OK,INIRec.ReadString('ICMS20','CST','00'));
        imp.ICMS.SituTrib      := Imp.ICMS.ICMS20.CST;
        Imp.ICMS.ICMS20.pRedBC := StringToFloatDef( INIRec.ReadString('ICMS20','pRedBC','') ,0);
        Imp.ICMS.ICMS20.vBC    := StringToFloatDef( INIRec.ReadString('ICMS20','vBC','') ,0);
        Imp.ICMS.ICMS20.pICMS  := StringToFloatDef( INIRec.ReadString('ICMS20','pICMS','') ,0);
        Imp.ICMS.ICMS20.vICMS  := StringToFloatDef( INIRec.ReadString('ICMS20','vICMS','') ,0);
      end;

      if INIRec.ReadString('ICMS45','CST','') <> '' then
      begin
        Imp.ICMS.ICMS45.CST := StrToCSTICMS(OK,INIRec.ReadString('ICMS45','CST','40'));
        imp.ICMS.SituTrib   := Imp.ICMS.ICMS45.CST;
       end;

      if INIRec.ReadString('ICMS60', 'CST','') <> '' then
      begin
        Imp.ICMS.ICMS60.CST        := StrToCSTICMS(OK,INIRec.ReadString('ICMS60','CST','60'));
        imp.ICMS.SituTrib          := Imp.ICMS.ICMS60.CST;
        Imp.ICMS.ICMS60.vBCSTRet   := StringToFloatDef( INIRec.ReadString('ICMS60','vBCSTRet','') ,0);
        Imp.ICMS.ICMS60.vICMSSTRet := StringToFloatDef( INIRec.ReadString('ICMS60','vICMSSTRet','') ,0);
        Imp.ICMS.ICMS60.pICMSSTRet := StringToFloatDef( INIRec.ReadString('ICMS60','pICMSSTRet','') ,0);
        Imp.ICMS.ICMS60.vCred      := StringToFloatDef( INIRec.ReadString('ICMS60','vCred','') ,0);
      end;

      if INIRec.ReadString('ICMS90', 'CST','') <> '' then
      begin
        Imp.ICMS.ICMS90.CST    := StrToCSTICMS(OK,INIRec.ReadString('ICMS90','CST','90'));
        imp.ICMS.SituTrib      := Imp.ICMS.ICMS90.CST;
        Imp.ICMS.ICMS90.pRedBC := StringToFloatDef( INIRec.ReadString('ICMS90','pRedBC','') ,0);
        Imp.ICMS.ICMS90.vBC    := StringToFloatDef( INIRec.ReadString('ICMS90','vBC','') ,0);
        Imp.ICMS.ICMS90.pICMS  := StringToFloatDef( INIRec.ReadString('ICMS90','pICMS','') ,0);
        Imp.ICMS.ICMS90.vICMS  := StringToFloatDef( INIRec.ReadString('ICMS90','vICMS','') ,0);
        Imp.ICMS.ICMS90.vCred  := StringToFloatDef( INIRec.ReadString('ICMS90','vCred','') ,0);
      end;

      if INIRec.ReadString('ICMSOutraUF', 'CST','') <> '' then
      begin
        Imp.ICMS.ICMSOutraUF.CST           := StrToCSTICMS(OK,INIRec.ReadString('ICMSOutraUF','CST','90'));
        imp.ICMS.SituTrib                  := cstICMSOutraUF;
        Imp.ICMS.ICMSOutraUF.pRedBCOutraUF := StringToFloatDef( INIRec.ReadString('ICMSOutraUF','pRedBCOutraUF','') ,0);
        Imp.ICMS.ICMSOutraUF.vBCOutraUF    := StringToFloatDef( INIRec.ReadString('ICMSOutraUF','vBCOutraUF','') ,0);
        Imp.ICMS.ICMSOutraUF.pICMSOutraUF  := StringToFloatDef( INIRec.ReadString('ICMSOutraUF','pICMSOutraUF','') ,0);
        Imp.ICMS.ICMSOutraUF.vICMSOutraUF  := StringToFloatDef( INIRec.ReadString('ICMSOutraUF','vICMSOutraUF','') ,0);
      end;

      if INIRec.ReadInteger('ICMSSN', 'indSN',0) = 1 then
      begin
        imp.ICMS.SituTrib     := cstICMSSN;
        Imp.ICMS.ICMSSN.indSN := INIRec.ReadInteger('ICMSSN', 'indSN',1);
      end;

      if (StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'pICMSInterPart', ''), 0) <> 0) or
         (StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'vBCUFFim', ''), 0) <> 0) or
         (StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'pFCPUFFim', ''), 0) <> 0) or
         (StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'pICMSUFFim', ''), 0) <> 0) or
         (StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'pICMSInter', ''), 0) <> 0) or
         (StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'vFCPUFFim', ''), 0) <> 0) or
         (StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'vICMSUFFim', ''), 0) <> 0) or
         (StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'vICMSUFIni', ''), 0) <> 0) then
      begin
        Imp.ICMSUFFim.vBCUFFim       := StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'vBCUFFim', ''), 0 );
        Imp.ICMSUFFim.pFCPUFFim      := StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'pFCPUFFim', ''), 0 );
        Imp.ICMSUFFim.pICMSUFFim     := StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'pICMSUFFim', ''), 0 );
        Imp.ICMSUFFim.pICMSInter     := StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'pICMSInter', ''), 0 );
        Imp.ICMSUFFim.pICMSInterPart := StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'pICMSInterPart', ''), 0 );
        Imp.ICMSUFFim.vFCPUFFim      := StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'vFCPUFFim', ''), 0 );
        Imp.ICMSUFFim.vICMSUFFim     := StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'vICMSUFFim', ''), 0 );
        Imp.ICMSUFFim.vICMSUFIni     := StringToFloatDef( INIRec.ReadString('ICMSUFFim', 'vICMSUFIni', ''), 0 );
      end;

      //CT-e OS
      Imp.infTribFed.vPIS    := StringToFloatDef( INIRec.ReadString('infTribFed', 'vPIS', ''), 0);
      Imp.infTribFed.vCOFINS := StringToFloatDef( INIRec.ReadString('infTribFed', 'vCOFINS', ''), 0);
      Imp.infTribFed.vIR     := StringToFloatDef( INIRec.ReadString('infTribFed', 'vIR', ''), 0);
      Imp.infTribFed.vINSS   := StringToFloatDef( INIRec.ReadString('infTribFed', 'vINSS', ''), 0);
      Imp.infTribFed.vCSLL   := StringToFloatDef( INIRec.ReadString('infTribFed', 'vCSLL', ''), 0);

      //CT-e OS
      infCTeNorm.infServico.xDescServ := INIRec.ReadString('infServico','xDescServ','');
      infCTeNorm.infServico.qCarga    := StringToFloatDef(INIRec.ReadString('infServico','qCarga',''), 0);

      //CT-e OS
      I := 1;
      while true do
      begin
        sSecao := 'infDocRef'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'nDoc', INIRec.ReadString(sSecao,'chBPe','FIM'));
        if sFim = 'FIM' then
          break;
        with infCTeNorm.infDocRef.New do
        begin
          if INIRec.ReadString(sSecao,'chBPe','') = '' then
          begin
            nDoc     := sFim;
            serie    := INIRec.ReadString(sSecao,'serie','');
            subserie := INIRec.ReadString(sSecao,'subserie','');
            dEmi     := StringToDateTime(INIRec.ReadString(sSecao,'dEmi','0') );
            vDoc     := StringToFloatDef(INIRec.ReadString(sSecao,'vDoc','') ,0);
          end
          else
            chBPe := sFim;
        end;
        Inc(I);
      end;

      //CT-e OS
      I := 1;
      while true do
      begin
        sSecao := 'seg'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'respSeg','FIM');
        if sFim = 'FIM' then
          break;
        with infCTeNorm.seg.New do
        begin
          respSeg := StrToTpRspSeguro(OK, sFim);
          xSeg    := INIRec.ReadString(sSecao,'xSeg','');
          nApol   := INIRec.ReadString(sSecao,'nApol','');
        end;
        Inc(I);
      end;

      {$IFDEF PL_200}
      infCTeNorm.infCarga.vCarga      := StringToFloatDef( INIRec.ReadString('infCarga','vCarga','') ,0);
      infCTeNorm.infCarga.proPred     := INIRec.ReadString('infCarga','proPred','');
      infCTeNorm.infCarga.xOutCat     := INIRec.ReadString('infCarga','xOutCat','');
      infCTeNorm.infCarga.vCargaAverb := StringToFloatDef( INIRec.ReadString('infCarga','vCargaAverb','') ,0);

      I := 1;
      while true do
      begin
        sSecao := 'infQ'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'cUnid','FIM');
        if sFim = 'FIM' then
          break;
        with infCTeNorm.infCarga.infQ.New do
        begin
          cUnid  := StrToUnidMed(OK, sFim);
          tpMed  := INIRec.ReadString(sSecao,'tpMed','');
          qCarga := StringToFloatDef( INIRec.ReadString(sSecao,'qCarga','') ,0);
        end;
        Inc(I);
      end;
      {$ELSE}
      infCarga.vCarga  := StringToFloatDef( INIRec.ReadString('infCarga','vCarga','') ,0);
      infCarga.proPred := INIRec.ReadString('infCarga','proPred','');
      infCarga.xOutCat := INIRec.ReadString('infCarga','xOutCat','');

      I := 1;
      while true do
      begin
        sSecao := 'infQ'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'cUnid','FIM');
        if sFim = 'FIM' then
          break;
        with infCarga.infQ.Add do
        begin
          cUnid  := StrToUnidMed(OK, sFim);
          tpMed  := INIRec.ReadString(sSecao,'tpMed','');
          qCarga := StringToFloatDef( INIRec.ReadString(sSecao,'qCarga','') ,0);
        end;
        Inc(I);
      end;
      {$ENDIF}

      {$IFNDEF PL_200}
      I := 1;
      while true do
      begin
        sSecao := 'contQt'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'nCont','FIM');
        if sFim = 'FIM' then
          break;
        with infCTeNorm.contQt.Add do
        begin
          nCont := sFim;
          dPrev := StringToDateTime(INIRec.ReadString( sSecao,'dPrev','0'));

          J := 1;
          while true do
          begin
            sSecao := 'lacContQt'+IntToStrZero(I,3)+IntToStrZero(J,3);
            sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');
            if sFim = 'FIM' then
              break;
            with lacContQt.Add do
            begin
              nLacre := sFim;
            end;
            Inc(J);
          end;
        end;
        Inc(I);
      end;
      {$ENDIF}

      I := 1;
      while true do
      begin
        sSecao := IfThen( INIRec.SectionExists('emiDocAnt'+ IntToStrZero(I, 3) )
                          , 'emiDocAnt'
                          , 'DocAnt') + IntToStrZero(I, 3);
        sFim   := INIRec.ReadString(sSecao, 'xNome', 'FIM');
        if sFim = 'FIM' then
          break;

        {$IFDEF PL_200}
        with infCTeNorm.docAnt.emiDocAnt.New do
        {$ELSE}
        with infCTeNorm.emiDocAnt.Add do
        {$ENDIF}
        begin
          CNPJCPF := INIRec.ReadString(sSecao,'CNPJCPF','');
          IE      := INIRec.ReadString(sSecao,'IE','');
          UF      := INIRec.ReadString(sSecao,'UF','');
          xNome   := INIRec.ReadString(sSecao,'xNome','');

          sSecao := IfThen( INIRec.SectionExists('idDocAntPap'+ IntToStrZero(I, 3) + '001')
                            , 'idDocAntPap'
                            , 'idDocAnt') + IntToStrZero(I, 3) + '001';
          sFim   := INIRec.ReadString(sSecao, 'nDoc', 'FIM');

          if sFim <> 'FIM' then
          begin
            with idDocAnt.New do
            begin
              J := 1;
              while true do
              begin
                sSecao := IfThen( INIRec.SectionExists('idDocAntPap'+IntToStrZero(I, 3) + IntToStrZero(J, 3) )
                                  , 'idDocAntPap'
                                  , 'idDocAnt') + IntToStrZero(I, 3) + IntToStrZero(J, 3);
                sFim   := INIRec.ReadString(sSecao, 'nDoc', 'FIM');
                if sFim = 'FIM' then
                  break;

                with idDocAntPap.New do
                begin
                  tpDoc  := StrToTpDocumentoAnterior(OK, INIRec.ReadString(sSecao,'tpDoc',''));
                  serie  := INIRec.ReadString(sSecao,'serie','');
                  subser := INIRec.ReadString(sSecao,'subser','');
                  nDoc   := INIRec.ReadString(sSecao,'nDoc','');
                  dEmi   := StringToDateTime(INIRec.ReadString( sSecao,'dEmi','0'));
                end;
                Inc(J);
              end;
            end;
          end;

          sSecao := 'idDocAntEle' + IntToStrZero(I, 3) + '001';
          sFim   := INIRec.ReadString(sSecao, 'chCTe', 'FIM');

          if sFim <> 'FIM' then
          begin
            with idDocAnt.New do
            begin
              J := 1;
              while true do
              begin
                sSecao := 'idDocAntEle' + IntToStrZero(I, 3) + IntToStrZero(J, 3);
                sFim   := INIRec.ReadString(sSecao, 'chCTe', 'FIM');
                if sFim = 'FIM' then
                  break;

                idDocAntEle.New.chCTe := sFim;

                Inc(J);
              end;
            end;
          end;
        end;

        Inc(I);
      end;

      I := 1;
      while true do
      begin
        sSecao := 'infSeg'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'respSeg','FIM');
        if sFim = 'FIM' then
          break;

        {$IFDEF PL_200}
        with infCTeNorm.seg.New do
        {$ELSE}
        with infseg.Add do
        {$ENDIF}
        begin
          respSeg := StrToTpRspSeguro(OK, INIRec.ReadString(sSecao,'respSeg',''));
          xSeg    := INIRec.ReadString(sSecao,'xSeg','');
          nApol   := INIRec.ReadString(sSecao,'nApol','');
          nAver   := INIRec.ReadString(sSecao,'nAver','');
          vCarga  := StringToFloatDef( INIRec.ReadString(sSecao,'vCarga','') ,0);
        end;
        Inc(I);
      end;

      if INIRec.ReadString('Rodo','RNTRC','') <> '' then
      begin
        {$IFDEF PL_200}
        infCTeNorm.Rodo.RNTRC := INIRec.ReadString('Rodo','RNTRC','');
        infCTeNorm.Rodo.dPrev := StringToDateTime(INIRec.ReadString( 'Rodo','dPrev','0'));
        infCTeNorm.Rodo.Lota  := StrToTpLotacao(OK,INIRec.ReadString('Rodo','lota',''));
        infCTeNorm.Rodo.CIOT  := INIRec.ReadString('Rodo','CIOT','');
        {$ELSE}
        Rodo.RNTRC := INIRec.ReadString('Rodo','RNTRC','');
        Rodo.dPrev := StringToDateTime(INIRec.ReadString( 'Rodo','dPrev','0'));
        Rodo.Lota  := StrToTpLotacao(OK,INIRec.ReadString('Rodo','lota',''));
        Rodo.CIOT  := INIRec.ReadString('Rodo','CIOT','');
        {$ENDIF}

        I := 1;
        while true do
        begin
          sSecao := 'Occ'+IntToStrZero(I,3);
          sFim   := INIRec.ReadString(sSecao,'nOcc','FIM');
          if sFim = 'FIM' then
            break;

          {$IFDEF PL_200}
          with infCTeNorm.Rodo.Occ.New do
          {$ELSE}
          with Rodo.Occ.Add do
          {$ENDIF}
          begin
            serie := INIRec.ReadString(sSecao,'serie','');
            nOcc  := INIRec.ReadInteger(sSecao,'nOcc',0);
            dEmi  := StringToDateTime(INIRec.ReadString( sSecao,'dEmi','0'));

            EmiOCC.CNPJ := INIRec.ReadString(sSecao,'CNPJ','');
            EmiOCC.cInt := INIRec.ReadString(sSecao,'cInt','');
            EmiOCC.IE   := INIRec.ReadString(sSecao,'IE','');
            EmiOCC.UF   := INIRec.ReadString(sSecao,'UF','');
            EmiOCC.fone := INIRec.ReadString(sSecao,'fone','');
          end;
          Inc(I);
        end;

        I := 1;
        while true do
        begin
          sSecao := 'valePed'+IntToStrZero(I,3);
          sFim   := INIRec.ReadString(sSecao,'CNPJForn','FIM');
          if sFim = 'FIM' then
            break;

          {$IFDEF PL_200}
          with infCTeNorm.Rodo.valePed.New do
          {$ELSE}
          with Rodo.valePed.Add do
          {$ENDIF}
          begin
            CNPJForn := INIRec.ReadString(sSecao,'CNPJForn','');
            nCompra  := INIRec.ReadString(sSecao,'nCompra','');
            CNPJPg   := INIRec.ReadString(sSecao,'CNPJPg','');
          end;
          Inc(I);
        end;

        I := 1;
        while true do
        begin
          sSecao := 'veic'+IntToStrZero(I,3);
          sFim   := INIRec.ReadString(sSecao,'RENAVAM','FIM');
          if sFim = 'FIM' then
            break;

          {$IFDEF PL_200}
          with infCTeNorm.Rodo.veic.New do
          {$ELSE}
          with Rodo.veic.Add do
          {$ENDIF}
          begin
            cInt    := INIRec.ReadString(sSecao,'cInt','');
            RENAVAM := INIRec.ReadString(sSecao,'RENAVAM','');
            placa   := INIRec.ReadString(sSecao,'placa','');
            tara    := INIRec.ReadInteger(sSecao,'tara',0);
            capKG   := INIRec.ReadInteger(sSecao,'capKG',0);
            capM3   := INIRec.ReadInteger(sSecao,'capM3',0);
            tpProp  := StrToTpPropriedade(OK,INIRec.ReadString(sSecao,'tpProp',''));
            tpVeic  := StrToTpVeiculo(OK,INIRec.ReadString(sSecao,'tpVeic',''));
            tpRod   := StrToTpRodado(OK,INIRec.ReadString(sSecao,'tpRod',''));
            tpCar   := StrToTpCarroceria(OK,INIRec.ReadString(sSecao,'tpCar',''));
            UF      := INIRec.ReadString(sSecao,'UF','');

            Prop.CNPJCPF := INIRec.ReadString(sSecao,'CNPJ','');
            Prop.RNTRC   := INIRec.ReadString(sSecao,'RNTRC','');
            Prop.xNome   := INIRec.ReadString(sSecao,'xNome','');
            Prop.IE      := INIRec.ReadString(sSecao,'IE','');
            Prop.UF      := INIRec.ReadString(sSecao,'PropUF',UF);
            Prop.tpProp  := StrToTpProp(OK,INIRec.ReadString(sSecao,'ProptpProp',INIRec.ReadString(sSecao,'tpProp','')));
          end;
          Inc(I);
        end;

        I := 1;
        while true do
        begin
          sSecao := 'lacre'+IntToStrZero(I,3);
          sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');
          if sFim = 'FIM' then
            break;

          {$IFDEF PL_200}
          with infCTeNorm.Rodo.lacRodo.New do
          {$ELSE}
          with Rodo.Lacres.Add do
          {$ENDIF}
          begin
            nLacre := sFim;
          end;
          Inc(I);
        end;

        I := 1;
        while true do
        begin
          sSecao := 'moto'+IntToStrZero(I,3);
          sFim   := INIRec.ReadString(sSecao,'xNome','FIM');
          if sFim = 'FIM' then
            break;

          {$IFDEF PL_200}
          with infCTeNorm.Rodo.moto.New do
          {$ELSE}
          with Rodo.moto.Add do
          {$ENDIF}
          begin
            xNome := sFim;
            CPF   := INIRec.ReadString(sSecao,'CPF','');
          end;
          Inc(I);
        end;
      end;

      //Rodovi�rio CT-e OS
      sSecao := 'RodoOS';
      if INIRec.ReadString(sSecao,'TAF', INIRec.ReadString(sSecao,'NroRegEstadual','') ) <> ''  then
      begin
        infCTeNorm.rodoOS.TAF            := INIRec.ReadString(sSecao,'TAF','');
        infCTeNorm.rodoOS.NroRegEstadual := INIRec.ReadString(sSecao,'NroRegEstadual','');

        I := 1;
        while true do
        begin
          sSecao := 'veic'+IntToStrZero(I,3);
          sFim   := INIRec.ReadString(sSecao,'placa','FIM');
          if sFim = 'FIM' then
            break;

          with infCTeNorm.rodoOS.veic do
          begin
            placa   := sFim;
            RENAVAM := INIRec.ReadString(sSecao,'RENAVAM','');
            UF      := INIRec.ReadString(sSecao,'UF','');

            prop.CNPJCPF        := INIRec.ReadString(sSecao,'CNPJCPF','');
            prop.TAF            := INIRec.ReadString(sSecao,'TAF','');
            prop.NroRegEstadual := INIRec.ReadString(sSecao,'NroRegEstadual','');
            prop.xNome          := INIRec.ReadString(sSecao,'xNome','');
            prop.IE             := INIRec.ReadString(sSecao,'IE','');
            prop.UF             := INIRec.ReadString(sSecao,'propUF','');
            prop.tpProp         := StrToTpProp(OK,INIRec.ReadString(sSecao,'ProptpProp',INIRec.ReadString(sSecao,'tpProp','')));
          end;
          Inc(I);
        end;

        sSecao := 'infFretamento';
        if INIRec.SectionExists(sSecao) then
        begin
          with infCTeNorm.rodoOS.infFretamento do
          begin
            tpFretamento := StrToTpFretamento(OK, INIRec.ReadString(sSecao, 'tpFretamento', '1'));
            dhViagem     := StringToDateTime(INIRec.ReadString(sSecao, 'dhViagem','0'));
          end;
        end;
      end;

      if INIRec.ReadString('aereo','CL','') <> '' then
      begin
        sSecao := 'aereo';
        {$IFDEF PL_200}
        with infCTeNorm do
        begin
        {$ENDIF}
          Aereo.nMinu := INIRec.ReadInteger(sSecao,'nMinu',0);
          Aereo.nOCA  := INIRec.ReadString(sSecao,'nOCA','');

          {$IFDEF PL_200}
          Aereo.dPrevAereo := StringToDateTime(INIRec.ReadString( sSecao,'dPrevAereo','0'));
          {$ELSE}
          Aereo.dPrev := StringToDateTime(INIRec.ReadString( sSecao,'dPrev','0'));
          {$ENDIF}

           Aereo.xLAgEmi := INIRec.ReadString(sSecao,'xLAgEmi','');
           Aereo.IdT     := INIRec.ReadString(sSecao,'IdT','');

           Aereo.tarifa.CL   := INIRec.ReadString(sSecao,'nMinu','');
           Aereo.tarifa.cTar := INIRec.ReadString(sSecao,'cTar','');
           Aereo.tarifa.vTar := StringToFloatDef( INIRec.ReadString(sSecao,'vTar','') ,0);

           Aereo.natCarga.xDime := INIRec.ReadString(sSecao,'xDime','');
           Aereo.natCarga.cIMP  := INIRec.ReadString(sSecao,'cIMP','');

           I := 1;
           while true do
           begin
             sKey := 'cInfManu'+IntToStrZero(I,3);
             sFim := INIRec.ReadString(sSecao,sKey,'FIM');
             if sFim = 'FIM' then
               break;

             with Aereo.natCarga.cinfManu.New do
               nInfManu := StrToTpInfManu(Ok, sFim);

             Inc(I);
           end;

        {$IFDEF PL_200}
        end;
        {$ENDIF}
      end;

      if INIRec.ReadString('aquav','xNavio','') <> '' then
      begin
        sSecao := 'aquav';
        {$IFDEF PL_200}
        with infCTeNorm do
        begin
        {$ENDIF}
          Aquav.vPrest   := StringToFloatDef( INIRec.ReadString(sSecao,'vPrest','') ,0);
          Aquav.vAFRMM   := StringToFloatDef( INIRec.ReadString(sSecao,'vAFRMM','') ,0);
          Aquav.nBooking := INIRec.ReadString( sSecao,'nBooking','0');
          Aquav.nCtrl    := INIRec.ReadString(sSecao,'nCtrl','');
          Aquav.xNavio   := INIRec.ReadString(sSecao,'xNavio','');

          Aquav.nViag    := INIRec.ReadString(sSecao,'nViag','');
          Aquav.direc    := StrToTpDirecao(OK,INIRec.ReadString(sSecao,'direc',''));
          Aquav.prtEmb   := INIRec.ReadString(sSecao,'prtEmb','');
          Aquav.prtTrans := INIRec.ReadString(sSecao,'prtTrans','');
          Aquav.prtDest  := INIRec.ReadString(sSecao,'prtDest','');
          Aquav.tpNav    := StrToTpNavegacao(OK,INIRec.ReadString(sSecao,'tpNav',''));
          Aquav.irin     := INIRec.ReadString(sSecao,'irin','');

          I := 1;
          while true do
          begin
            sSecao := 'balsa'+IntToStrZero(I,3);
            sFim   := INIRec.ReadString(sSecao,'xBalsa','FIM');
            if sFim = 'FIM' then
              break;
            with Aquav.balsa.New do
            begin
              xBalsa := sFim;
            end;
            Inc(I);
          end;

          {$IFNDEF PL_200}
          I := 1;
          while true do
          begin
            sSecao := 'detCont'+IntToStrZero(I,3);
            sFim   := INIRec.ReadString(sSecao,'nCont','FIM');
            if sFim = 'FIM' then
              break;
            with Aquav.detCont.Add do
            begin
              nCont := sFim;
              J := 1;
              while true do
              begin
                sSecao := 'Lacre'+IntToStrZero(I,3)+IntToStrZero(J,3);
                sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');
                if (sFim = 'FIM') or (Length(sFim) <= 0)  then
                  break;

                Lacre.Add.nLacre := sFim;
                Inc(J);
              end;

              J := 1;
              while true do
              begin
                sSecao := 'infNF'+IntToStrZero(I,3)+IntToStrZero(J,3);
                sFim   := INIRec.ReadString(sSecao,'nDoc','FIM');
                if (sFim = 'FIM') or (Length(sFim) <= 0)  then
                  break;

                with infNFCont.Add do
                begin
                  nDoc    := sFim;
                  serie   := INIRec.ReadString(sSecao,'serie','FIM');
                  unidRat := StringToFloatDef( INIRec.ReadString(sSecao,'unidRat','') ,0);
                end;
                Inc(J);
              end;

              J := 1;
              while true do
              begin
                sSecao := 'infNFe'+IntToStrZero(I,3)+IntToStrZero(J,3);
                sFim   := INIRec.ReadString(sSecao,'chave','FIM');
                if (sFim = 'FIM') or (Length(sFim) <= 0)  then
                  break;

                with infNFeCont.Add do
                begin
                  chave   := sFim;
                  unidRat := StringToFloatDef( INIRec.ReadString(sSecao,'unidRat','') ,0);
                end;
                Inc(J);
              end;
            end;
            Inc(I);
          end;
          {$ENDIF}

        {$IFDEF PL_200}
        end;
        {$ENDIF}
      end;

      if INIRec.ReadString('ferrov','tpTraf','') <> '' then
      begin
        sSecao := 'ferrov';

        if FConfiguracoes.Geral.VersaoDF >= ve300 then
        begin
          with infCTeNorm do
          begin
            Ferrov.tpTraf := StrToTpTrafego(OK,INIRec.ReadString(sSecao,'tpTraf',''));
            Ferrov.fluxo  := INIRec.ReadString( sSecao,'fluxo','0');

            Ferrov.trafMut.respFat := StrToTrafegoMutuo(OK,INIRec.ReadString(sSecao,'respFat',''));
            Ferrov.trafMut.ferrEmi := StrToTrafegoMutuo(OK,INIRec.ReadString(sSecao,'ferrEmi',''));
            Ferrov.vFrete          := StringToFloatDef( INIRec.ReadString(sSecao,'vFrete','') ,0);

            Ferrov.trafMut.chCTeFerroOrigem := INIRec.ReadString(sSecao,'chCTeFerroOrigem', '');

            I := 1;
            while true do
            begin
              sSecao := 'ferroEnv'+IntToStrZero(I,3);
              sFim   := INIRec.ReadString(sSecao,'CNPJ','FIM');
              if sFim = 'FIM' then
                break;

              with Ferrov.ferroEnv.New do
              begin
                CNPJ  := sFim;
                IE    := INIRec.ReadString(sSecao,'IE','');
                xNome := INIRec.ReadString(sSecao,'xNome','');

                EnderFerro.xLgr    := INIRec.ReadString(sSecao,'xLgr','');
                EnderFerro.nro     := INIRec.ReadString(sSecao,'nro','');
                EnderFerro.xCpl    := INIRec.ReadString(sSecao, 'xCpl','');
                EnderFerro.xBairro := INIRec.ReadString(sSecao,'xBairro','');
                EnderFerro.cMun    := INIRec.ReadInteger(sSecao,'cMun',0);
                EnderFerro.xMun    := INIRec.ReadString(sSecao,'xMun','');
                EnderFerro.CEP     := INIRec.ReadInteger(sSecao,'CEP',0);
                EnderFerro.UF      := INIRec.ReadString(sSecao,'UF','');
              end;
              Inc(I);
            end;
          end;
        end
        else
        begin
          {$IFDEF PL_200}
          with infCTeNorm do
          begin
          {$ENDIF}
            Ferrov.tpTraf := StrToTpTrafego(OK,INIRec.ReadString(sSecao,'tpTraf',''));
            Ferrov.fluxo  := INIRec.ReadString( sSecao,'fluxo','0');
            Ferrov.idTrem := INIRec.ReadString( sSecao,'idTrem','0');
            Ferrov.vFrete := StringToFloatDef( INIRec.ReadString(sSecao,'vFrete','') ,0);

            Ferrov.trafMut.respFat := StrToTrafegoMutuo(OK,INIRec.ReadString(sSecao,'respFat',''));
            Ferrov.trafMut.ferrEmi := StrToTrafegoMutuo(OK,INIRec.ReadString(sSecao,'ferrEmi',''));

            {$IFDEF PL_200}
            I := 1;
            while true do
            begin
              sSecao := 'ferroEnv'+IntToStrZero(I,3);
              sFim   := INIRec.ReadString(sSecao,'CNPJ','FIM');
              if sFim = 'FIM' then
                break;

              with Ferrov.ferroEnv.New do
              begin
                CNPJ  := sFim;
                IE    := INIRec.ReadString(sSecao,'IE','');
                xNome := INIRec.ReadString(sSecao,'xNome','');

                EnderFerro.xLgr    := INIRec.ReadString(sSecao,'xLgr','');
                EnderFerro.nro     := INIRec.ReadString(sSecao,'nro','');
                EnderFerro.xCpl    := INIRec.ReadString(sSecao, 'xCpl','');
                EnderFerro.xBairro := INIRec.ReadString(sSecao,'xBairro','');
                EnderFerro.cMun    := INIRec.ReadInteger(sSecao,'cMun',0);
                EnderFerro.xMun    := INIRec.ReadString(sSecao,'xMun','');
                EnderFerro.CEP     := INIRec.ReadInteger(sSecao,'CEP',0);
                EnderFerro.UF      := INIRec.ReadString(sSecao,'UF','');
              end;
              Inc(I);
            end;
            {$ELSE}
            sSecao := 'ferroEnv';

            Ferrov.ferroEnv.CNPJ  := INIRec.ReadString(sSecao,'CNPJ','');
            Ferrov.ferroEnv.IE    := INIRec.ReadString(sSecao,'IE','');
            Ferrov.ferroEnv.xNome := INIRec.ReadString(sSecao,'xNome','');

            Ferrov.ferroEnv.EnderFerro.xLgr    := INIRec.ReadString(sSecao,'xLgr','');
            Ferrov.ferroEnv.EnderFerro.nro     := INIRec.ReadString(sSecao,'nro','');
            Ferrov.ferroEnv.EnderFerro.xCpl    := INIRec.ReadString(sSecao, 'xCpl','');
            Ferrov.ferroEnv.EnderFerro.xBairro := INIRec.ReadString(sSecao,'xBairro','');
            Ferrov.ferroEnv.EnderFerro.cMun    := INIRec.ReadInteger(sSecao,'cMun',0);
            Ferrov.ferroEnv.EnderFerro.xMun    := INIRec.ReadString(sSecao,'xMun','');
            Ferrov.ferroEnv.EnderFerro.CEP     := INIRec.ReadInteger(sSecao,'CEP',0);
            Ferrov.ferroEnv.EnderFerro.UF      := INIRec.ReadString(sSecao,'UF','');
            {$ENDIF}

            I := 1;
            while true do
            begin
              sSecao := 'detVag'+IntToStrZero(I,3);
              sFim   := INIRec.ReadString(sSecao,'nVag','FIM');
              if sFim = 'FIM' then
                break;

              with Ferrov.detVag.New do
              begin
                nVag   := StrToInt(sFim);
                cap    := StringToFloatDef( INIRec.ReadString(sSecao,'cap','') ,0);
                tpVag  := INIRec.ReadString(sSecao,'tpVag','');
                pesoR  := StringToFloatDef( INIRec.ReadString(sSecao,'pesoR','') ,0);
                pesoBC := StringToFloatDef( INIRec.ReadString(sSecao,'pesoBC','') ,0);

                {$IFNDEF PL_200}
                J := 1;
                while true do
                begin
                  sSecao := 'lacDetVag'+IntToStrZero(I,3)+IntToStrZero(J,3);
                  sFim   := INIRec.ReadString(sSecao,'nLacre','FIM');
                  if (sFim = 'FIM') or (Length(sFim) <= 0)  then
                    break;

                  lacDetVag.Add.nLacre := sFim;
                  Inc(J);
                end;

                J := 1;
                while true do
                begin
                  sSecao := 'contVag'+IntToStrZero(I,3)+IntToStrZero(J,3);
                  sFim   := INIRec.ReadString(sSecao,'nCont','FIM');
                  if (sFim = 'FIM') or (Length(sFim) <= 0)  then
                    break;

                  with contVag.Add do
                  begin
                    nCont := sFim;
                    dPrev := StringToDateTime(INIRec.ReadString( sSecao,'dPrev','0'));
                  end;
                  Inc(J);
                end;

                J := 1;
                while true do
                begin
                  sSecao := 'ratNF'+IntToStrZero(I,3)+IntToStrZero(J,3);
                  sFim   := INIRec.ReadString(sSecao,'nDoc','FIM');
                  if (sFim = 'FIM') or (Length(sFim) <= 0)  then
                    break;

                  with ratNF.Add do
                  begin
                    nDoc    := sFim;
                    serie   := INIRec.ReadString(sSecao,'serie','FIM');
                    pesoRat := StringToFloatDef( INIRec.ReadString(sSecao,'pesoRat','') ,0);
                  end;
                  Inc(J);
                end;

                J := 1;
                while true do
                begin
                  sSecao := 'ratNFe'+IntToStrZero(I,3)+IntToStrZero(J,3);
                  sFim   := INIRec.ReadString(sSecao,'chave','FIM');
                  if (sFim = 'FIM') or (Length(sFim) <= 0)  then
                    break;

                  with ratNFe.Add do
                  begin
                    chave   := sFim;
                    pesoRat := StringToFloatDef( INIRec.ReadString(sSecao,'pesoRat','') ,0);
                  end;
                  Inc(J);
                end;
                {$ENDIF}
               end;
               Inc(I);
            end;
            {$IFDEF PL_200}
          end;
          {$ENDIF}
        end;
      end;

      if INIRec.ReadString('duto','dIni','') <> '' then
      begin
        sSecao := 'duto';
        {$IFDEF PL_200}
        with infCTeNorm do
        begin
        {$ENDIF}
          duto.vTar := StringToFloatDef( INIRec.ReadString(sSecao,'pesoRat','') ,0);
          duto.dIni := StringToDateTime(INIRec.ReadString( sSecao,'dIni','0'));
          duto.dFim := StringToDateTime(INIRec.ReadString( sSecao,'dFim','0'));
        {$IFDEF PL_200}
        end;
        {$ENDIF}
      end;

      I := 1;
      while true do
      begin
        sSecao := 'peri'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'nONU','FIM');
        if sFim = 'FIM' then
          break;

        {$IFDEF PL_200}
        with infCTeNorm.peri.New do
        {$ELSE}
        with peri.Add do
        {$ENDIF}
        begin
          nONU        := sFim;
          xNomeAE     := INIRec.ReadString( sSecao,'xNomeAE','');
          xClaRisco   := INIRec.ReadString( sSecao,'xClaRisco','');
          grEmb       := INIRec.ReadString( sSecao,'grEmb','');
          qTotProd    := INIRec.ReadString( sSecao,'qTotProd','');
          qVolTipo    := INIRec.ReadString( sSecao,'qVolTipo','');
          pontoFulgor := INIRec.ReadString( sSecao,'pontoFulgor','');
        end;
        Inc(I);
      end;

      I := 1;
      while true do
      begin
        sSecao := 'veicNovos'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'chassi','FIM');
        if sFim = 'FIM' then
          break;

        {$IFDEF PL_200}
        with infCTeNorm.veicNovos.New do
        {$ELSE}
        with veicNovos.Add do
        {$ENDIF}
        begin
          chassi := sFim;
          cCor   := INIRec.ReadString( sSecao,'cCor','');
          xCor   := INIRec.ReadString( sSecao,'xCor','');
          cMod   := INIRec.ReadString( sSecao,'cMod','');
          vUnit  := StringToFloatDef( INIRec.ReadString(sSecao,'vUnit','') ,0);
          vFrete := StringToFloatDef( INIRec.ReadString(sSecao,'vFrete','') ,0);
        end;
        Inc(I);
      end;

      {$IFDEF PL_200}
      with infCTeNorm do
      begin
      {$ENDIF}
        cobr.Fat.nFat  := INIRec.ReadString( 'cobr','nFat','');
        cobr.Fat.vOrig := StringToFloatDef( INIRec.ReadString('cobr','vOrig','') ,0);
        cobr.Fat.vDesc := StringToFloatDef( INIRec.ReadString('cobr','vDesc','') ,0);
        cobr.Fat.vLiq  := StringToFloatDef( INIRec.ReadString('cobr','vLiq' ,'') ,0);
      {$IFDEF PL_200}
      end;
      {$ENDIF}

      I := 1;
      while true do
      begin
        sSecao := 'dup'+IntToStrZero(I,3);
        sFim   := INIRec.ReadString(sSecao,'nDup','FIM');
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        {$IFDEF PL_200}
        with infCTeNorm.Cobr.Dup.New do
        {$ELSE}
        with Cobr.Dup.Add do
        {$ENDIF}
        begin
          nDup  := sFim;
          dVenc := StringToDateTime(INIRec.ReadString( sSecao,'dVenc','0'));
          vDup  := StringToFloatDef(INIRec.ReadString(sSecao,'vDup','') ,0);
        end;
        Inc(I);
      end;

      if INIRec.ReadString( 'infCteSub','chCte','') <> '' then
      begin
        {$IFDEF PL_200}
        with infCTeNorm.infCteSub do
        {$ELSE}
        with infCTeSub do
        {$ENDIF}
        begin
          chCte         := INIRec.ReadString( 'infCteSub','chCte','');
          indAlteraToma := StrToTIndicador(Ok, INIRec.ReadString( 'infCteSub','indAlteraToma','0'));

          tomaICMS.refNFe := INIRec.ReadString( 'infCteSub','refNFe','');

          {$IFDEF PL_200}
          tomaICMS.refNF.CNPJCPF := INIRec.ReadString( 'infCteSub','CNPJ','');
          {$ELSE}
          tomaICMS.refNF.CNPJ := INIRec.ReadString( 'infCteSub','CNPJ','');
          {$ENDIF}
          tomaICMS.refNF.modelo   := INIRec.ReadString( 'infCteSub','mod','');
          tomaICMS.refNF.serie    := INIRec.ReadInteger( 'infCteSub','serie',0);
          tomaICMS.refNF.subserie := INIRec.ReadInteger( 'infCteSub','subserie',0);
          tomaICMS.refNF.nro      := INIRec.ReadInteger( 'infCteSub','nro',0);
          tomaICMS.refNF.valor    :=  StringToFloatDef(INIRec.ReadString('infCteSub','valor','') ,0);
          tomaICMS.refNF.dEmi     := StringToDateTime(INIRec.ReadString( 'infCteSub','dEmi','0'));
          tomaICMS.refCte         := INIRec.ReadString( 'infCteSub','refCte','');

          // Usado pela vers�o 2.00
          tomaNaoICMS.refCteAnu := INIRec.ReadString( 'infCteSub','refCteAnu','');
          // Usado pela vers�o 3.00
          refCteAnu := tomaNaoICMS.refCteAnu;
        end;
      end;

      if INIRec.ReadString('infCteComp', 'chCte', INIRec.ReadString('infCteComp', 'chave', '') ) <> '' then
      begin
        {$IFDEF PL_200}
        infCTeComp.chave := INIRec.ReadString('infCteComp', 'chCte', INIRec.ReadString('infCteComp', 'chave', '') );
        {$ENDIF}
      end;

      if INIRec.ReadString( 'infCteAnu','chCte','') <> '' then
      begin
        {$IFDEF PL_200}
        InfCTeAnu.chCTe := INIRec.ReadString( 'infCteAnu','chCte','');
        InfCTeAnu.dEmi  := StringToDateTime(INIRec.ReadString( 'infCteAnu','dEmi','0'));
        {$ELSE}
        InfCTeAnuEnt.chCTe := INIRec.ReadString( 'infCteAnu','chCte','');
        InfCTeAnuEnt.dEmi  := StringToDateTime(INIRec.ReadString( 'infCteAnu','dEmi','0'));
        {$ENDIF}
      end;

      {$IFDEF PL_200}
      I := 1;
      while true do
      begin
        sSecao := 'autXML' + IntToStrZero(I, 2);
        sFim   := INIRec.ReadString(sSecao, 'CNPJCPF', 'FIM');
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
        begin
          sSecao := 'autXML' + IntToStrZero(I, 3);
          sFim   := INIRec.ReadString(sSecao, 'CNPJCPF', 'FIM');
        end;
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with autXML.New do
        begin
          CNPJCPF := sFim;
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
     {$ENDIF}
    end;

    GerarXML;

    Result := True;
  finally
     INIRec.Free;
  end;
end;

{ TConhecimentos }

constructor TConhecimentos.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  if not (AOwner is TACBrCTe) then
     raise EACBrCTeException.Create('AOwner deve ser do tipo TACBrCTe');

  inherited Create(AOwner, ItemClass);

  FACBrCTe := TACBrCTe(AOwner);
  FConfiguracoes := TACBrCTe(FACBrCTe).Configuracoes;
end;

function TConhecimentos.Add: Conhecimento;
begin
  Result := Conhecimento(inherited Add);
end;

procedure TConhecimentos.Assinar;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].Assinar;
end;

procedure TConhecimentos.GerarCTe;
var
 i: Integer;
begin
 for i:= 0 to Self.Count-1 do
   Self.Items[i].GerarXML;
end;

function TConhecimentos.GerarIni: String;
begin
  Result := '';
  if (Self.Count > 0) then
    Result := Self.Items[0].GerarCTeIni;
end;

function TConhecimentos.GetItem(Index: Integer): Conhecimento;
begin
  Result := Conhecimento(inherited Items[Index]);
end;

function TConhecimentos.GetNamePath: String;
begin
  Result := 'Conhecimento';
end;

procedure TConhecimentos.VerificarDACTE;
begin
  if not Assigned(TACBrCTe(FACBrCTe).DACTE) then
    raise EACBrCTeException.Create('Componente DACTE n�o associado.');
end;

procedure TConhecimentos.Imprimir;
begin
  VerificarDACTE;
  TACBrCTe(FACBrCTe).DACTe.ImprimirDACTe(nil);
end;

procedure TConhecimentos.ImprimirPDF;
begin
  VerificarDACTE;
  TACBrCTe(FACBrCTe).DACTe.ImprimirDACTePDF(nil);
end;

function TConhecimentos.Insert(Index: Integer): Conhecimento;
begin
  Result := Conhecimento(inherited Insert(Index));
end;

procedure TConhecimentos.SetItem(Index: Integer; const Value: Conhecimento);
begin
  Items[Index].Assign(Value);
end;

procedure TConhecimentos.Validar;
var
  i: Integer;
begin
  for i:= 0 to Self.Count-1 do
    Self.Items[i].Validar;
end;

function TConhecimentos.VerificarAssinatura(out Erros: String): Boolean;
var
  i: integer;
begin
  Result := True;
  Erros := '';

  if Self.Count < 1 then
  begin
    Erros := 'Nenhum CTe carregado';
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

function TConhecimentos.ValidarRegrasdeNegocios(out Erros: String): Boolean;
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

function TConhecimentos.LoadFromFile(const CaminhoArquivo: String;
  AGerarCTe: Boolean): Boolean;
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

  l := Self.Count; // Indice do �ltimo conhecimento j� existente
  Result := LoadFromString(String(XMLUTF8), AGerarCTe);

  if Result then
  begin
    // Atribui Nome do arquivo a novos Conhecimentos inseridos //
    for i := l to Self.Count - 1 do
      Self.Items[i].NomeArq := CaminhoArquivo;
  end;
end;

function TConhecimentos.LoadFromStream(AStream: TStringStream;
  AGerarCTe: Boolean): Boolean;
var
  AXML: AnsiString;
begin
  AStream.Position := 0;
  AXML := ReadStrFromStream(AStream, AStream.Size);

  Result := Self.LoadFromString(String(AXML), AGerarCTe);
end;

function TConhecimentos.LoadFromString(const AXMLString: String;
  AGerarCTe: Boolean): Boolean;
var
  ACTeXML, XMLStr: AnsiString;
  P, N: integer;
  Modelo: TModeloCTe;

  function PosCTe: integer;
  begin
    case Modelo of
      moCTeOS: Result := Pos('</CTeOS>', XMLStr);
      moGTVe: Result := Pos('</GTVe>', XMLStr);
    else
      Result := pos('</CTe>', XMLStr);
    end;
  end;

begin
  // Verifica se precisa Converter de UTF8 para a String nativa da IDE //
  XMLStr := ConverteXMLtoNativeString(AXMLString);

  if Pos('</CTeOS>', XMLStr) > 0 then
    Modelo := moCTeOS
  else
  begin
    if Pos('</GTVe>', XMLStr) > 0 then
      Modelo := moGTVe
    else
      Modelo := moCTe;
  end;

  N := PosCTe;
  while N > 0 do
  begin
    case Modelo of
      moCTeOS:
        begin
          P := pos('</cteOSProc>', XMLStr);

          if P <= 0 then
            P := pos('</procCTeOS>', XMLStr);  // CTe obtido pelo Portal da Receita

          if P > 0 then
          begin
            ACTeXML := copy(XMLStr, 1, P + 12);
            XMLStr := Trim(copy(XMLStr, P + 12, length(XMLStr)));
          end
          else
          begin
            ACTeXML := copy(XMLStr, 1, N + 8);
            XMLStr := Trim(copy(XMLStr, N + 8, length(XMLStr)));
          end;
        end;
      moGTVe:
        begin
          P := pos('</GTVeProc>', XMLStr);

          if P <= 0 then
            P := pos('</procGTVe>', XMLStr);  // CTe obtido pelo Portal da Receita

          if P > 0 then
          begin
            ACTeXML := copy(XMLStr, 1, P + 12);
            XMLStr := Trim(copy(XMLStr, P + 12, length(XMLStr)));
          end
          else
          begin
            ACTeXML := copy(XMLStr, 1, N + 8);
            XMLStr := Trim(copy(XMLStr, N + 8, length(XMLStr)));
          end;
        end;
    else
      begin
        P := pos('</cteProc>', XMLStr);

        if P <= 0 then
          P := pos('</procCTe>', XMLStr);  // CTe obtido pelo Portal da Receita

        if P > 0 then
        begin
          ACTeXML := copy(XMLStr, 1, P + 10);
          XMLStr := Trim(copy(XMLStr, P + 10, length(XMLStr)));
        end
        else
        begin
          ACTeXML := copy(XMLStr, 1, N + 6);
          XMLStr := Trim(copy(XMLStr, N + 6, length(XMLStr)));
        end;
      end;
    end;

    with Self.Add do
    begin
      LerXML(ACTeXML);

      if AGerarCTe then // Recalcula o XML
        GerarXML;
    end;

    N := PosCTe;
  end;

  Result := Self.Count > 0;
end;

function TConhecimentos.LoadFromIni(const AIniString: String): Boolean;
begin
  with Self.Add do
    LerArqIni(AIniString);

  Result := Self.Count > 0;
end;

function TConhecimentos.GravarXML(const PathNomeArquivo: String): Boolean;
var
  i: integer;
  NomeArq, PathArq : String;
begin
  Result := True;
  i := 0;
  while Result and (i < Self.Count) do
  begin
    PathArq := ExtractFilePath(PathNomeArquivo);
    NomeArq := ExtractFileName(PathNomeArquivo);
    Result := Self.Items[i].GravarXML(NomeArq, PathArq);
    Inc(i);
  end;
end;

end.
