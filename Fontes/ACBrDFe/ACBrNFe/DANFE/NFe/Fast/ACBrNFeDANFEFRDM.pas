{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                          }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 11/08/2010: Itamar Luiz Bermond
|*  - Inicio do desenvolvimento
|* 24/08/2010: R�gys Silveira
|*  - Acerto nas diretivas de compila��o para Delphi 2009 e superior
|*  - Acertos gerais no DANFE
|        . Layout
|        . Exibi��o da logomarca
|        . Tamanho das colunas para conter valores grandes
|        . marca d'agua para ambiente de homologa��o
|        . Adicionado o complemento a descri��o da mercadoria
|        . Adicionado a origem no CST
|        . Acerto para mostrar o CST corretamente quando for Simples Nacional
|*  - Padroniza��o da logomarca para utilizar o caminho como nos outros DANFEs
|*  - Acerto no CST para o Simples Nacional
|*  - Acertos no DANFE para o Simples Nacional
|* 25/08/2010: R�gys Silveira
|*  - Configura��o do preview do DANFE.
|* 26/08/2010: R�gys Silveira, Itamar Bermond
|*  - Desmarcada a propriedade StoreInDFM do FastReport para n�o gravar
|*    o relat�rio no DFM e evitar o erro de compila��o em vers�o menores
|*    do delphi, favor utilizar o arquivo externo.
|* 26/02/2013: Jo�o Henrique de Souza
|*  - Foi realizado in�meras modifica��es para Normalizar o Danfe com o Manual
|*    e ter uma vers�o que fosse poss�vel imprimir com o FR que vem com o Delphi
|* 02/04/2015: Isaque Pinheiro
|*  - Cria��o de uma class, removendo o datamodule e os componentes n�o visuais
|*    dele, sendo criado todos em tempo de execu��o.
******************************************************************************}
{$I ACBr.inc}

unit ACBrNFeDANFEFRDM;

interface

uses
  SysUtils, Classes, Forms, DB, DBClient, Graphics,
  pcnEnvEventoNFe, pcnRetInutNFe, pcnNFe, pcnConversao,
  ACBrDFeReport, ACBrDFeDANFeReport, ACBrNFeDANFEClass,
  ACBrUtil, ACBrDelphiZXingQrCode,
  frxClass, frxExportPDF, frxDBSet, frxBarcode;

type

  TACBrNFeFRClass = class
  private
    FDANFEClassOwner: TACBrDFeDANFeReport;
    FNFe: TNFe;
    FEvento: TEventoNFe;
    FfrxReport: TfrxReport;
    FfrxPDFExport: TfrxPDFExport;
    FfrxBarCodeObject: TfrxBarCodeObject;
    cdsIdentificacao: TClientDataSet;
    FfrxIdentificacao: TfrxDBDataset;
    cdsEmitente: TClientDataSet;
    FfrxEmitente: TfrxDBDataset;
    cdsDestinatario: TClientDataSet;
    FfrxDestinatario: TfrxDBDataset;
    cdsDadosProdutos: TClientDataSet;
    FfrxDadosProdutos: TfrxDBDataset;
    cdsParametros: TClientDataSet;
    FfrxParametros: TfrxDBDataset;
    cdsDuplicatas: TClientDataSet;
    FfrxDuplicatas: TfrxDBDataset;
    cdsCalculoImposto: TClientDataSet;
    FfrxCalculoImposto: TfrxDBDataset;
    cdsTransportador: TClientDataSet;
    FfrxTransportador: TfrxDBDataset;
    cdsVeiculo: TClientDataSet;
    FfrxVeiculo: TfrxDBDataset;
    cdsVolumes: TClientDataSet;
    FfrxVolumes: TfrxDBDataset;
    cdsEventos: TClientDataSet;
    FfrxEventos: TfrxDBDataset;
    cdsISSQN: TClientDataSet;
    FfrxISSQN: TfrxDBDataset;
    cdsFatura: TClientDataSet;
    FfrxFatura: TfrxDBDataset;
    cdsLocalRetirada: TClientDataSet;
    FfrxLocalRetirada: TfrxDBDataset;
    cdsLocalEntrega: TClientDataSet;
    FfrxLocalEntrega: TfrxDBDataset;
    cdsInformacoesAdicionais: TClientDataSet;
    FfrxInformacoesAdicionais: TfrxDBDataset;
    cdsPagamento: TClientDataSet;
    FfrxPagamento: TfrxDBDataset;
    FInutilizacao: TRetInutNFe;
    FfrxInutilizacao: TfrxDBDataset;
    cdsInutilizacao: TClientDataSet;

    FFastFile: String;
    FFastFileEvento: String;
    FFastFileInutilizacao: String;
    FPrintMode: TfrxPrintMode;
    FPrintOnSheet: Integer;
    FExibeCaptionButton: Boolean;
    FBorderIcon : TBorderIcons;
    FIncorporarFontesPdf: Boolean;
    FIncorporarBackgroundPdf: Boolean;

    procedure frxReportBeforePrint(Sender: TfrxReportComponent);
    procedure frxReportPreview(Sender: TObject);

    procedure CarregaIdentificacao;
    procedure CarregaEmitente;
    procedure CarregaDestinatario;
    procedure CarregaDadosProdutos;
    procedure CarregaParametros;
    procedure CarregaCalculoImposto;
    procedure CarregaTransportador;
    procedure CarregaVeiculo;
    procedure CarregaVolumes;
    procedure CarregaDuplicatas;
    procedure CarregaISSQN;
    procedure CarregaLocalRetirada;
    procedure CarregaLocalEntrega;
    procedure CarregaFatura;
    procedure CarregaPagamento;
    procedure CarregaInformacoesAdicionais;

    function CollateBr(Str: String): String;

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    property NFe: TNFe read FNFe write FNFe;
    property Evento: TEventoNFe read FEvento write FEvento;
    property Inutilizacao: TRetInutNFe read FInutilizacao write FInutilizacao;
    property DANFEClassOwner: TACBrDFeDANFeReport read FDANFEClassOwner;
    property frxReport: TfrxReport read FfrxReport;
    property frxPDFExport: TfrxPDFExport read FfrxPDFExport;

    procedure SetDataSetsToFrxReport;
    procedure CarregaDadosNFe;
    procedure CarregaDadosEventos;
    procedure CarregaDadosInutilizacao;
    procedure PintarQRCode(QRCodeData: String; APict: TPicture);

    property FastFile: String read FFastFile write FFastFile;
    property FastFileEvento: String read FFastFileEvento write FFastFileEvento;
    property FastFileInutilizacao: String read FFastFileInutilizacao write FFastFileInutilizacao;

    property PrintMode: TfrxPrintMode read FPrintMode write FPrintMode default pmDefault;
    property PrintOnSheet: Integer read FPrintOnSheet write FPrintOnSheet default 0;
    property ExibeCaptionButton: Boolean read FExibeCaptionButton write FExibeCaptionButton default False;
    property BorderIcon: TBorderIcons read FBorderIcon write FBorderIcon;
    property IncorporarBackgroundPdf: Boolean read FIncorporarBackgroundPdf write FIncorporarBackgroundPdf;
    property IncorporarFontesPdf: Boolean read FIncorporarFontesPdf write FIncorporarFontesPdf;

    function PrepareReport(ANFE: TNFe = nil): Boolean;
    function PrepareReportEvento: Boolean;
    function PrepareReportInutilizacao: Boolean;

    function GetPreparedReport: TfrxReport;
    function GetPreparedReportEvento: TfrxReport;
    function GetPreparedReportInutilizacao: TfrxReport;

    procedure ImprimirDANFE(ANFE: TNFe = nil);
    procedure ImprimirDANFEResumido(ANFE: TNFe = nil);
    procedure ImprimirDANFEPDF(ANFE: TNFe = nil);
    procedure ImprimirEVENTO(ANFE: TNFe = nil);
    procedure ImprimirEVENTOPDF(ANFE: TNFe = nil);
    procedure ImprimirINUTILIZACAO(ANFE: TNFe = nil);
    procedure ImprimirINUTILIZACAOPDF(ANFE: TNFe = nil);

  end;


implementation

uses
  StrUtils, Math, DateUtils,
  ACBrNFe, ACBrNFeDANFEFR, ACBrDFeUtil, ACBrValidador,
  pcnConversaoNFe;

{ TACBrNFeFRClass }

constructor TACBrNFeFRClass.Create(AOwner: TComponent);
begin
  if not (AOwner is TACBrDFeDANFeReport) then
    raise EACBrNFeException.Create('AOwner deve ser do tipo TACBrDFeDANFeReport');

  FFastFile := '';
  FExibeCaptionButton := False;
  FBorderIcon := [biSystemMenu,biMaximize,biMinimize];
  FIncorporarFontesPdf := True;
  FIncorporarBackgroundPdf := True;

  FDANFEClassOwner := TACBrDFeDANFeReport(AOwner);

  FfrxReport := TfrxReport.Create( nil);
  FfrxReport.EngineOptions.UseGlobalDataSetList := False;
  FfrxReport.PreviewOptions.Buttons := [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind,
    pbOutline, pbPageSetup, pbTools, pbNavigator, pbExportQuick];

  with FfrxReport do
  begin
     EngineOptions.DoublePass := True;
     StoreInDFM := False;
     OnBeforePrint := frxReportBeforePrint;
     OnReportPrint := 'frxReportOnReportPrint';
  end;

  FfrxPDFExport := TfrxPDFExport.Create(nil);
  with FfrxPDFExport do
  begin
     Background    := FIncorporarBackgroundPdf;
     EmbeddedFonts := FIncorporarFontesPdf;
     Subject       := 'Exportando DANFE para PDF';
     ShowProgress  := False;
  end;

  // cdsIdentificacao
  if not Assigned(cdsIdentificacao) then
  begin
     cdsIdentificacao := TClientDataSet.Create(nil);
     FfrxIdentificacao := TfrxDBDataset.Create(nil);
     with FfrxIdentificacao do
     begin
        DataSet := cdsIdentificacao;
        OpenDataSource := False;
        Enabled := False;
        UserName := 'Identificacao';
     end;

     with cdsIdentificacao do
     begin
        FieldDefs.Add('Id', ftString, 44);
        FieldDefs.Add('Versao', ftFloat);
        FieldDefs.Add('Chave', ftString, 60);
        FieldDefs.Add('cUF', ftString, 2);
        FieldDefs.Add('cNF', ftString, 9);
        FieldDefs.Add('NatOp', ftString, 60);
        FieldDefs.Add('IndPag', ftString, 1);
        FieldDefs.Add('Mod_', ftString, 2);
        FieldDefs.Add('Serie', ftString, 3);
        FieldDefs.Add('NNF', ftString, 11);
        FieldDefs.Add('DEmi', ftString, 19);
        FieldDefs.Add('DSaiEnt', ftString, 10);
        FieldDefs.Add('TpNF', ftString, 1);
        FieldDefs.Add('CMunFG', ftString, 7);
        FieldDefs.Add('TpImp', ftString, 1);
        FieldDefs.Add('TpEmis', ftString, 1);
        FieldDefs.Add('CDV', ftString, 1);
        FieldDefs.Add('TpAmb', ftString, 1);
        FieldDefs.Add('FinNFe', ftString, 1);
        FieldDefs.Add('ProcEmi', ftString, 1);
        FieldDefs.Add('VerProc', ftString, 6);
        FieldDefs.Add('HoraSaida', ftString, 10);
        FieldDefs.Add('MensagemFiscal', ftString, 200);
        FieldDefs.Add('URL', ftString, 1000);
        CreateDataSet;
     end;
   end;

   // cdsEmitente
   if not Assigned(cdsEmitente) then
   begin
     cdsEmitente := TClientDataSet.Create(nil);
     FfrxEmitente := TfrxDBDataset.Create(nil);
     with FfrxEmitente do
     begin
        DataSet := cdsEmitente;
        OpenDataSource := False;
        Enabled := False;
        UserName := 'Emitente';
     end;

     with cdsEmitente do
     begin
        FieldDefs.Add('CNPJ', ftString, 18);
        FieldDefs.Add('XNome', ftString, 60);
        FieldDefs.Add('XFant', ftString, 60);
        FieldDefs.Add('XLgr', ftString, 60);
        FieldDefs.Add('Nro', ftString, 60);
        FieldDefs.Add('XCpl', ftString, 60);
        FieldDefs.Add('XBairro', ftString, 60);
        FieldDefs.Add('CMun', ftString, 7);
        FieldDefs.Add('XMun', ftString, 60);
        FieldDefs.Add('UF', ftString, 2);
        FieldDefs.Add('CEP', ftString, 9);
        FieldDefs.Add('CPais', ftString, 4);
        FieldDefs.Add('XPais', ftString, 60);
        FieldDefs.Add('Fone', ftString, 15);
        FieldDefs.Add('IE', ftString, 15);
        FieldDefs.Add('IM', ftString, 15);
        FieldDefs.Add('IEST', ftString, 15);
        FieldDefs.Add('CRT', ftString, 1);
        FieldDefs.Add('DESCR_CST', ftString, 30);
        FieldDefs.Add('DADOS_ENDERECO', ftString, 1000);
        CreateDataSet;
     end;
   end;

   // cdsDestinatario
   if not Assigned(cdsDestinatario) then
   begin
     cdsDestinatario := TClientDataSet.Create(nil);
     FfrxDestinatario := TfrxDBDataset.Create(nil);
     with FfrxDestinatario do
     begin
        DataSet := cdsDestinatario;
        OpenDataSource := False;
        Enabled := False;
        UserName := 'Destinatario';
     end;

     with cdsDestinatario do
     begin
        FieldDefs.Add('CNPJCPF', ftString, 18);
        FieldDefs.Add('XNome', ftString, 60);
        FieldDefs.Add('XLgr', ftString, 60);
        FieldDefs.Add('Nro', ftString, 60);
        FieldDefs.Add('XCpl', ftString, 60);
        FieldDefs.Add('XBairro', ftString, 60);
        FieldDefs.Add('CMun', ftString, 7);
        FieldDefs.Add('XMun', ftString, 60);
        FieldDefs.Add('UF', ftString, 2);
        FieldDefs.Add('CEP', ftString, 9);
        FieldDefs.Add('CPais', ftString, 4);
        FieldDefs.Add('XPais', ftString, 60);
        FieldDefs.Add('Fone', ftString, 15);
        FieldDefs.Add('IE', ftString, 18);
        FieldDefs.Add('Consumidor', ftString, 150);
        CreateDataSet;
     end;
   end;

   // cdsDadosProdutos
   if not Assigned(cdsDadosProdutos) then
   begin
     cdsDadosProdutos   := TClientDataSet.Create(nil);
     FfrxDadosProdutos  := TfrxDBDataset.Create(nil);
     with FfrxDadosProdutos do
     begin
        DataSet := cdsDadosProdutos;
        OpenDataSource := False;
        Enabled := False;
        UserName := 'DadosProdutos';
     end;

     with cdsDadosProdutos do
     begin
        FieldDefs.Add('CProd'     , ftString, 60);
        FieldDefs.Add('cEAN'      , ftString, 60);
        FieldDefs.Add('XProd'     , ftString, 120);
        FieldDefs.Add('infAdProd' , ftString, 1000);
        FieldDefs.Add('NCM'       , ftString, 9);
        FieldDefs.Add('EXTIPI'    , ftString, 8);
        FieldDefs.Add('genero'    , ftString, 8);
        FieldDefs.Add('CFOP'      , ftString, 4);
        FieldDefs.Add('UCom'      , ftString, 6);
        FieldDefs.Add('QCom'      , ftFloat);
        FieldDefs.Add('VUnCom'    , ftFloat);
        FieldDefs.Add('VProd'     , ftString, 18);
        FieldDefs.Add('cEANTrib'  , ftString, 60);
        FieldDefs.Add('UTrib'     , ftString, 6);
        FieldDefs.Add('QTrib'     , ftFloat);
        FieldDefs.Add('vUnTrib'   , ftFloat);
        FieldDefs.Add('vFrete'    , ftString, 18);
        FieldDefs.Add('vOutro'    , ftString, 18);
        FieldDefs.Add('vSeg'      , ftString, 18);
        FieldDefs.Add('vDesc'     , ftString, 18);
        FieldDefs.Add('ORIGEM'    , ftString, 1);
        FieldDefs.Add('CST'       , ftString, 3);
        FieldDefs.Add('vBC'       , ftString, 18);
        FieldDefs.Add('pICMS'     , ftString, 18);
        FieldDefs.Add('vICMS'     , ftString, 18);
        FieldDefs.Add('vIPI'      , ftString, 18);
        FieldDefs.Add('pIPI'      , ftString, 18);
        FieldDefs.Add('VTotTrib'  , ftString, 18);
        FieldDefs.Add('ChaveNFe'  , ftString, 50);
        FieldDefs.Add('vISSQN'    , ftString, 18);
        FieldDefs.Add('vBcISSQN'  , ftString, 18);
        FieldDefs.Add('vBcST'     , ftString, 18);
        FieldDefs.Add('vICMSST'   , ftString, 18);
        FieldDefs.Add('nLote'     , ftString, 20);
        FieldDefs.Add('qLote'     , ftFloat);
        FieldDefs.Add('dFab'      , ftDateTime);
        FieldDefs.Add('dVal'      , ftDateTime);
        FieldDefs.Add('DescricaoProduto', ftString, 2000);
        FieldDefs.Add('Unidade'   , ftString, 14);
        FieldDefs.Add('Quantidade', ftString, 18);
        FieldDefs.Add('ValorUnitario'   , ftString, 50);
        FieldDefs.Add('Valorliquido'    , ftString, 18);
        FieldDefs.Add('ValorAcrescimos' , ftString, 18);
        CreateDataSet;
     end;
   end;

   // cdsParametros
   if not Assigned(cdsParametros) then
   begin
     cdsParametros  := TClientDataSet.Create(nil);
     FfrxParametros := TfrxDBDataset.Create(nil);
     with FfrxParametros do
     begin
        DataSet         := cdsParametros;
        OpenDataSource  := False;
        Enabled := False;
        UserName        := 'Parametros';
     end;

     with cdsParametros do
     begin
        FieldDefs.Add('poscanhoto', ftString, 1);
        FieldDefs.Add('ResumoCanhoto', ftString, 200);
        FieldDefs.Add('Mensagem0', ftString, 60);
        FieldDefs.Add('Imagem', ftString, 256);
        FieldDefs.Add('Sistema', ftString, 300);
        FieldDefs.Add('Usuario', ftString, 60);
        FieldDefs.Add('Fax', ftString, 60);
        FieldDefs.Add('Site', ftString, 60);
        FieldDefs.Add('Email', ftString, 60);
        FieldDefs.Add('Desconto', ftString, 60);
        FieldDefs.Add('TotalLiquido', ftString, 60);
        FieldDefs.Add('ChaveAcesso_Descricao', ftString, 90);
        FieldDefs.Add('Contingencia_ID', ftString, 36);
        FieldDefs.Add('Contingencia_Descricao', ftString, 60);
        FieldDefs.Add('Contingencia_Valor', ftString, 60);
        FieldDefs.Add('LinhasPorPagina', ftInteger);
        FieldDefs.Add('LogoExpandido', ftString, 1);
        FieldDefs.Add('DESCR_CST', ftString, 30);
        FieldDefs.Add('ConsultaAutenticidade', ftString, 300);
        FieldDefs.Add('sDisplayFormat', ftString, 25);
        FieldDefs.Add('iFormato', ftInteger);
        FieldDefs.Add('Casas_qCom', ftInteger);
        FieldDefs.Add('Casas_vUnCom', ftInteger);
        FieldDefs.Add('Mask_qCom', ftString, 30);
        FieldDefs.Add('Mask_vUnCom', ftString, 30);
        FieldDefs.Add('LogoCarregado', ftBlob);
        FieldDefs.Add('QrCodeCarregado', ftGraphic, 1000);
        FieldDefs.Add('DescricaoViaEstabelec', ftString, 30);
        FieldDefs.Add('QtdeItens', ftInteger);
        FieldDefs.Add('ExpandirDadosAdicionaisAuto', ftString, 1);
        FieldDefs.Add('ImprimeDescAcrescItem', ftInteger);
        FieldDefs.Add('nProt', ftString, 30);
        FieldDefs.Add('dhRecbto', ftDateTime);
        CreateDataSet;
     end;
   end;

   // cdsDuplicatas
   if not Assigned(cdsDuplicatas) then
   begin
     cdsDuplicatas := TClientDataSet.Create(nil);
     FfrxDuplicatas := TfrxDBDataset.Create(nil);
     with FfrxDuplicatas do
     begin
        DataSet := cdsDuplicatas;
        OpenDataSource := False;
        Enabled := False;
        UserName := 'Duplicatas';
     end;

     with cdsDuplicatas do
     begin
        FieldDefs.Add('NDup', ftString, 60);
        FieldDefs.Add('DVenc', ftString, 10);
        FieldDefs.Add('VDup', ftFloat);
        FieldDefs.Add('ChaveNFe', ftString, 50);
        CreateDataSet;
     end;
   end;

   // cdsCalculoImposto
   if not Assigned(cdsCalculoImposto) then
   begin
     cdsCalculoImposto := TClientDataSet.Create(nil);
     FfrxCalculoImposto := TfrxDBDataset.Create(nil);
     with FfrxCalculoImposto do
     begin
        DataSet := cdsCalculoImposto;
        OpenDataSource := False;
        Enabled := False;
        UserName := 'CalculoImposto';
     end;

     with cdsCalculoImposto do
     begin
        FieldDefs.Add('VBC'         , ftFloat);
        FieldDefs.Add('VICMS'       , ftFloat);
        FieldDefs.Add('VBCST'       , ftFloat);
        FieldDefs.Add('VST'         , ftFloat);
        FieldDefs.Add('VProd'       , ftFloat);
        FieldDefs.Add('VFrete'      , ftFloat);
        FieldDefs.Add('VSeg'        , ftFloat);
        FieldDefs.Add('VDesc'       , ftFloat);
        FieldDefs.Add('vICMSDeson'  , ftFloat);
        FieldDefs.Add('VII'         , ftFloat);
        FieldDefs.Add('VIPI'        , ftFloat);
        FieldDefs.Add('VPIS'        , ftFloat);
        FieldDefs.Add('VCOFINS'     , ftFloat);
        FieldDefs.Add('VOutro'      , ftFloat);
        FieldDefs.Add('VNF'         , ftFloat);
        FieldDefs.Add('VTotTrib'    , ftFloat);
        FieldDefs.Add('VTribPerc'   , ftFloat);
        FieldDefs.Add('VTribFonte'  , ftString, 100);
        FieldDefs.Add('vTotPago'    , ftFloat);
        FieldDefs.Add('vTroco'      , ftFloat);
        FieldDefs.Add('ValorApagar' , ftFloat);
        CreateDataSet;
     end;
   end;

   // cdsTransportador
   if not Assigned(cdsTransportador) then
   begin
     cdsTransportador := TClientDataSet.Create(nil);
     FfrxTransportador := TfrxDBDataset.Create(nil);
     with FfrxTransportador do
     begin
        DataSet := cdsTransportador;
        OpenDataSource := False;
        Enabled := False;
        UserName := 'Transportador';
     end;

     with cdsTransportador do
     begin
        FieldDefs.Add('ModFrete', ftString, 20);
        FieldDefs.Add('CNPJCPF', ftString, 18);
        FieldDefs.Add('XNome', ftString, 60);
        FieldDefs.Add('IE', ftString, 15);
        FieldDefs.Add('XEnder', ftString, 60);
        FieldDefs.Add('XMun', ftString, 60);
        FieldDefs.Add('UF', ftString, 2);
        CreateDataSet;
     end;
   end;

   // cdsVeiculo
   if not Assigned(cdsVeiculo) then
   begin
     cdsVeiculo := TClientDataSet.Create(nil);
     FfrxVeiculo := TfrxDBDataset.Create(nil);
     with FfrxVeiculo do
     begin
        DataSet := cdsVeiculo;
        OpenDataSource := False;
        Enabled := False;
        UserName := 'Veiculo';
     end;

     with cdsVeiculo do
     begin
        FieldDefs.Add('PLACA', ftString, 8);
        FieldDefs.Add('UF', ftString, 2);
        FieldDefs.Add('RNTC', ftString, 20);
        CreateDataSet;
     end;
   end;

   // cdsVolumes
   if not Assigned(cdsVolumes) then
   begin
     cdsVolumes := TClientDataSet.Create(nil);
     FfrxVolumes := TfrxDBDataset.Create(nil);
     with FfrxVolumes do
     begin
        DataSet := cdsVolumes;
        OpenDataSource := False;
        Enabled := False;
        UserName := 'Volumes';
     end;

     with cdsVolumes do
     begin
        FieldDefs.Add('QVol', ftFloat);
        FieldDefs.Add('Esp', ftString, 60);
        FieldDefs.Add('Marca', ftString, 60);
        FieldDefs.Add('NVol', ftString, 60);
        FieldDefs.Add('PesoL', ftFloat);
        FieldDefs.Add('PesoB', ftFloat);
        CreateDataSet;
     end;
   end;

   // csdEvento
   if not Assigned(cdsEventos) then
   begin
      cdsEventos := TClientDataSet.Create(nil);
      FfrxEventos := TfrxDBDataset.Create(nil);
      with FfrxEventos do
      begin
         DataSet := cdsEventos;
         OpenDataSource := False;
         Enabled := False;
         UserName := 'Eventos';
      end;
   end;

   // cdsISSQN
   if not Assigned(cdsISSQN) then
   begin
      cdsISSQN := TClientDataSet.Create(nil);
      FfrxISSQN := TfrxDBDataset.Create(nil);
      with FfrxISSQN do
      begin
         DataSet := cdsISSQN;
         OpenDataSource := False;
         Enabled := False;
         UserName := 'ISSQN';
      end;

      with cdsISSQN do
      begin
         FieldDefs.Add('vSERV', ftFloat);
         FieldDefs.Add('vBC', ftFloat);
         FieldDefs.Add('vISS', ftFloat);
         FieldDefs.Add('vDescIncond', ftFloat);
         FieldDefs.Add('vISSRet', ftFloat);
         CreateDataSet;
      end;
   end;

   // cdsFatura
   if not Assigned(cdsFatura) then
   begin
      cdsFatura   := TClientDataSet.Create(nil);
      FfrxFatura  := TfrxDBDataset.Create(nil);
      with FfrxFatura do
      begin
         DataSet        := cdsFatura;
         OpenDataSource := False;
         Enabled := False;
         UserName       := 'Fatura';
      end;

      with cdsFatura do
      begin
         FieldDefs.Add('iForma'   , ftInteger);
         FieldDefs.Add('Pagamento', ftString, 20);
         FieldDefs.Add('nFat'     , ftString, 60);
         FieldDefs.Add('vOrig'    , ftFloat);
         FieldDefs.Add('vDesc'    , ftFloat);
         FieldDefs.Add('vLiq'     , ftFloat);
         CreateDataSet;
      end;
   end;

   // cdsLocalRetirada
   if not Assigned(cdsLocalRetirada) then
   begin
      cdsLocalRetirada := TClientDataSet.Create(nil);
      FfrxLocalRetirada := TfrxDBDataset.Create(nil);
      with FfrxLocalRetirada do
      begin
         DataSet := cdsLocalRetirada;
         OpenDataSource := False;
         Enabled := False;
         UserName := 'LocalRetirada';
      end;

      with cdsLocalRetirada do
      begin
         FieldDefs.Add('CNPJ', ftString, 18);
         FieldDefs.Add('XLgr', ftString, 60);
         FieldDefs.Add('Nro', ftString, 60);
         FieldDefs.Add('XCpl', ftString, 60);
         FieldDefs.Add('XBairro', ftString, 60);
         FieldDefs.Add('CMun', ftString, 7);
         FieldDefs.Add('XMun', ftString, 60);
         FieldDefs.Add('UF', ftString, 2);
         CreateDataSet;
      end;
   end;

   // cdsLocalEntrega
   if not Assigned(cdsLocalEntrega) then
   begin
      cdsLocalEntrega := TClientDataSet.Create(nil);
      FfrxLocalEntrega := TfrxDBDataset.Create(nil);
      with FfrxLocalEntrega do
      begin
         DataSet := cdsLocalEntrega;
         OpenDataSource := False;
         Enabled := False;
         UserName := 'LocalEntrega';
      end;

      with cdsLocalEntrega do
      begin
         FieldDefs.Add('CNPJ', ftString, 18);
         FieldDefs.Add('XLgr', ftString, 60);
         FieldDefs.Add('Nro', ftString, 60);
         FieldDefs.Add('XCpl', ftString, 60);
         FieldDefs.Add('XBairro', ftString, 60);
         FieldDefs.Add('CMun', ftString, 7);
         FieldDefs.Add('XMun', ftString, 60);
         FieldDefs.Add('UF', ftString, 2);
         CreateDataSet;
      end;
   end;

   // cdsInformacoesAdicionais
   if not Assigned(cdsInformacoesAdicionais) then
   begin
      cdsInformacoesAdicionais := TClientDataSet.Create(nil);
      FfrxInformacoesAdicionais := TfrxDBDataset.Create(nil);
      with FfrxInformacoesAdicionais do
      begin
         DataSet := cdsInformacoesAdicionais;
         OpenDataSource := False;
         Enabled := False;
         UserName := 'InformacoesAdicionais';
      end;

      with cdsInformacoesAdicionais do
      begin
         FieldDefs.Add('OBS', ftString, 6900);
         FieldDefs.Add('LinhasOBS', ftInteger);
         CreateDataSet;
      end;
   end;

   // cdsPagamento
   if not Assigned(cdsPagamento) then
   begin
      cdsPagamento := TClientDataSet.Create(nil);
      FfrxPagamento := TfrxDBDataset.Create(nil);
      with FfrxPagamento do
      begin
         DataSet := cdsPagamento;
         OpenDataSource := False;
         Enabled := False;
         UserName := 'Pagamento';
      end;

      with cdsPagamento do
      begin
         FieldDefs.Add('tPag', ftString, 50);
         FieldDefs.Add('vPag', ftFloat);
         FieldDefs.Add('vTroco', ftFloat);
         FieldDefs.Add('CNPJ', ftString, 50);
         FieldDefs.Add('tBand', ftString, 50);
         FieldDefs.Add('cAut', ftString, 20);
         CreateDataSet;
      end;
   end;

   //cdsInutiliza��o
   if not Assigned(cdsInutilizacao) then
   begin
      cdsInutilizacao := TClientDataSet.Create(nil);
      FfrxInutilizacao := TfrxDBDataset.Create(nil);
      with FfrxInutilizacao do
      begin
         DataSet := cdsInutilizacao;
         OpenDataSource := False;
         Enabled := False;
         UserName := 'Inutilizacao';
      end;
   end;
end;

destructor TACBrNFeFRClass.Destroy;
begin
  FfrxReport.Free;
  FfrxPDFExport.Free;
  FfrxBarCodeObject.Free;
  cdsIdentificacao.Free;
  FfrxIdentificacao.Free;
  cdsEmitente.Free;
  FfrxEmitente.Free;
  cdsDestinatario.Free;
  FfrxDestinatario.Free;
  cdsDadosProdutos.Free;
  FfrxDadosProdutos.Free;
  cdsParametros.Free;
  FfrxParametros.Free;
  cdsDuplicatas.Free;
  FfrxDuplicatas.Free;
  cdsCalculoImposto.Free;
  FfrxCalculoImposto.Free;
  cdsTransportador.Free;
  FfrxTransportador.Free;
  cdsVeiculo.Free;
  FfrxVeiculo.Free;
  cdsVolumes.Free;
  FfrxVolumes.Free;
  cdsEventos.Free;
  FfrxEventos.Free;
  cdsISSQN.Free;
  FfrxISSQN.Free;
  cdsFatura.Free;
  FfrxFatura.Free;
  cdsLocalRetirada.Free;
  FfrxLocalRetirada.Free;
  cdsLocalEntrega.Free;
  FfrxLocalEntrega.Free;
  cdsInformacoesAdicionais.Free;
  FfrxInformacoesAdicionais.Free;
  cdsPagamento.Free;
  FfrxPagamento.Free;
  cdsInutilizacao.Free;
  FfrxInutilizacao.Free;

  inherited Destroy;
end;

procedure TACBrNFeFRClass.SetDataSetsToFrxReport;
begin
  frxReport.EnabledDataSets.Clear;
  frxReport.EnabledDataSets.Add(FfrxIdentificacao);
  frxReport.EnabledDataSets.Add(FfrxEmitente);
  frxReport.EnabledDataSets.Add(FfrxDestinatario);
  frxReport.EnabledDataSets.Add(FfrxDadosProdutos);
  frxReport.EnabledDataSets.Add(FfrxCalculoImposto);
  frxReport.EnabledDataSets.Add(FfrxTransportador);
  frxReport.EnabledDataSets.Add(FfrxVeiculo);
  frxReport.EnabledDataSets.Add(FfrxVolumes);
  frxReport.EnabledDataSets.Add(FfrxEventos);
  frxReport.EnabledDataSets.Add(FfrxISSQN);
  frxReport.EnabledDataSets.Add(FfrxFatura);
  frxReport.EnabledDataSets.Add(FfrxLocalRetirada);
  frxReport.EnabledDataSets.Add(FfrxLocalEntrega);
  frxReport.EnabledDataSets.Add(FfrxInformacoesAdicionais);
  frxReport.EnabledDataSets.Add(FfrxPagamento);
  frxReport.EnabledDataSets.Add(FfrxParametros);
  frxReport.EnabledDataSets.Add(FfrxDuplicatas);
  frxReport.EnabledDataSets.Add(FfrxInutilizacao);
end;

function TACBrNFeFRClass.CollateBr(Str: String): String;
var
  Resultado,Temp: string;
  vChar: Char;
  Tamanho, i: integer;
begin
  Result := '';
  Tamanho := Length(str);
  i := 1;
  while (i <= Tamanho) do
  begin
    Temp := Copy(str,i,1);
    vChar := Temp[1];
    case vChar of
      '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�': Resultado := 'A';
      '�', '�', '�', '�', '�', '�', '�', '�': Resultado := 'E';
      '�', '�', '�', '�', '�', '�', '�', '�': Resultado := 'I';
      '�', '�', '�', '�', '�', '�', '�', '�', '�', '�': Resultado := 'O';
      '�', '�', '�', '�', '�', '�', '�', '�': Resultado := 'U';
      '�', '�': Resultado := 'C';
      '�', '�': Resultado := 'N';
      '�', '�', '�', 'Y': Resultado := 'Y';
    else
      if vChar > #127 then Resultado := #32
      {$IFDEF DELPHI12_UP}
      else if CharInset(vChar, ['a'..'z','A'..'Z','0'..'9','-',' ',Chr(39)]) then
      {$ELSE}
      else if vChar in ['a'..'z','A'..'Z','0'..'9','-',' ',Chr(39)] then
      {$ENDIF}
        Resultado := UpperCase(vCHAR);
    end;

    Result := Result + Resultado;
    i := i + 1;
  end;
end;

procedure TACBrNFeFRClass.CarregaCalculoImposto;
begin
  with cdsCalculoImposto do
  begin
    Close;
    CreateDataSet;
    Append;

    with FNFe.Total.ICMSTot do
    begin
      FieldByName('VBC').AsFloat          := VBC;
      FieldByName('VICMS').AsFloat        := VICMS;
      FieldByName('VBCST').AsFloat        := VBCST;
      FieldByName('VST').AsFloat          := VST;
      FieldByName('VProd').AsFloat        := VProd;
      FieldByName('VFrete').AsFloat       := VFrete;
      FieldByName('VSeg').AsFloat         := VSeg;
      FieldByName('VDesc').AsFloat        := VDesc;
      FieldByName('vICMSDeson').AsFloat   := vICMSDeson;
      FieldByName('VII').AsFloat          := VII;
      FieldByName('VIPI').AsFloat         := VIPI;
      FieldByName('VPIS').AsFloat         := VPIS;
      FieldByName('VCOFINS').AsFloat      := VCOFINS;
      FieldByName('VOutro').AsFloat       := VOutro;
      FieldByName('VNF').AsFloat          := VNF;
      FieldByName('VTotTrib').AsFloat     := VTotTrib;
      FieldByName('ValorApagar').AsFloat  := VProd - VDesc - vICMSDeson + VOutro;

      if (FDANFEClassOwner is TACBrNFeDANFEClass) then
        FieldByName('VTribPerc').AsFloat := TACBrNFeDANFEClass(FDANFEClassOwner).ManterVTribPerc(VTotTrib, VProd, VNF);

      if NaoEstaVazio(FDANFEClassOwner.FonteTributos) then
        FieldByName('VTribFonte').AsString := '(Fonte: '+FDANFEClassOwner.FonteTributos+')';
    end;

    if FNFe.pag.vTroco > 0 then
    begin
      FieldByName('vTroco').AsCurrency    := FNFe.pag.vTroco;
      FieldByName('vTotPago').AsCurrency  := FNFe.pag.vTroco+FieldByName('VProd').AsFloat;
    end
    else if (FDANFEClassOwner is TACBrNFeDANFCEClass) then
    begin
      FieldByName('vTroco').AsCurrency    := TACBrNFeDANFCEClass(DANFEClassOwner).vTroco;
      FieldByName('vTotPago').AsCurrency  := TACBrNFeDANFCEClass(DANFEClassOwner).vTroco + FieldByName('VProd').AsFloat;
    end;

    Post;
  end;
end;

procedure TACBrNFeFRClass.CarregaDadosNFe;
begin
  CarregaParametros;
  CarregaIdentificacao;
  CarregaEmitente;
  CarregaDestinatario;
  CarregaDadosProdutos;
  CarregaCalculoImposto;
  CarregaTransportador;
  CarregaVeiculo;
  CarregaVolumes;
  CarregaDuplicatas;
  CarregaISSQN;
  CarregaLocalRetirada;
  CarregaLocalEntrega;
  CarregaFatura;
  CarregaPagamento;
  CarregaInformacoesAdicionais;
end;

procedure TACBrNFeFRClass.CarregaDadosProdutos;
var
  inItem : Integer;
begin
  if not cdsParametros.Active then
    CarregaParametros;

  cdsParametros.First;

  // verificar se e DANFE detalhado
  // dados dos produtos
  with cdsDadosProdutos do
  begin
    Close;
    CreateDataSet;
    if (NFe.Ide.modelo <> 65) or
      ((FDANFEClassOwner is TACBrNFeDANFCEClass) and TACBrNFeDANFCEClass(FDANFEClassOwner).ImprimeItens) then
    begin
      for inItem := 0 to (NFe.Det.Count - 1) do
      begin
        Append;
        with FNFe.Det.Items[inItem] do
        begin
          FieldByName('ChaveNFe').AsString          := FNFe.infNFe.ID;
          FieldByName('cProd').AsString             := FDANFEClassOwner.ManterCodigo(Prod.cEAN,Prod.cProd);
          FieldByName('cEAN').AsString              := Prod.cEAN;
          FieldByName('XProd').AsString             := StringReplace( Prod.xProd, ';', #13, [rfReplaceAll]);
          FieldByName('VProd').AsString             := FDANFEClassOwner.ManterVprod(Prod.VProd , Prod.vDesc );
          FieldByName('vTotTrib').AsString          := FDANFEClassOwner.ManterdvTotTrib(Imposto.vTotTrib );

          if FDANFEClassOwner is TACBrNFeDANFEClass then
          begin
            FieldByName('infAdProd').AsString := TACBrNFeDANFEClass(FDANFEClassOwner).ManterinfAdProd(FNFe, inItem);
            FieldByName('DescricaoProduto').AsString := TACBrNFeDANFEClass(FDANFEClassOwner).ManterXProd(FNFe, inItem);
          end
          else
          begin
            FieldByName('infAdProd').AsString := FNFe.Det[inItem].infAdProd;
            FieldByName('DescricaoProduto').AsString := FieldByName('XProd').AsString;
          end;

          FieldByName('NCM').AsString               := Prod.NCM;
          FieldByName('EXTIPI').AsString            := Prod.EXTIPI;
          FieldByName('genero').AsString            := '';
          FieldByName('CFOP').AsString              := Prod.CFOP;
          FieldByName('Ucom').AsString              := Prod.UCom;
          FieldByName('QCom').AsFloat               := Prod.QCom;
          FieldByName('VUnCom').AsFloat             := Prod.VUnCom;
          FieldByName('cEANTrib').AsString          := Prod.cEANTrib;
          FieldByName('UTrib').AsString             := Prod.uTrib;
          FieldByName('QTrib').AsFloat              := Prod.qTrib;
          FieldByName('VUnTrib').AsFloat            := Prod.vUnTrib;
          FieldByName('vFrete').AsString            := FormatFloatBr( Prod.vFrete ,'###,###,##0.00');
          FieldByName('vSeg').AsString              := FormatFloatBr( Prod.vSeg   ,'###,###,##0.00');
          FieldByName('vOutro').AsString            := FormatFloatBr( Prod.vOutro ,'###,###,##0.00');

          if FDANFEClassOwner is TACBrNFeDANFEClass then
            FieldByName('vDesc').AsString           := FormatFloatBr( TACBrNFeDANFEClass(FDANFEClassOwner).ManterVDesc( Prod.vDesc , Prod.VUnCom , Prod.QCom),'###,###,##0.00')
          else
            FieldByName('vDesc').AsString           := FormatFloatBr( Prod.vDesc,'###,###,##0.00');

          FieldByName('ORIGEM').AsString            := OrigToStr( Imposto.ICMS.orig);
          FieldByName('CST').AsString               := FDANFEClassOwner.ManterCst( FNFe.Emit.CRT , Imposto.ICMS.CSOSN , Imposto.ICMS.CST );
          FieldByName('VBC').AsString               := FormatFloatBr( Imposto.ICMS.vBC        ,'###,###,##0.00');
          FieldByName('PICMS').AsString             := FormatFloatBr( Imposto.ICMS.pICMS      ,'###,###,##0.00');
          FieldByName('VICMS').AsString             := FormatFloatBr( Imposto.ICMS.vICMS      ,'###,###,##0.00');
          FieldByName('VBCST').AsString             := FormatFloatBr( Imposto.ICMS.vBcST      ,'###,###,##0.00');
          FieldByName('VICMSST').AsString           := FormatFloatBr( Imposto.ICMS.vICMSST    ,'###,###,##0.00');
          FieldByName('VIPI').AsString              := FormatFloatBr( Imposto.IPI.VIPI        ,'###,###,##0.00');
          FieldByName('PIPI').AsString              := FormatFloatBr( Imposto.IPI.PIPI        ,'###,###,##0.00');
          FieldByName('vISSQN').AsString            := FormatFloatBr( Imposto.ISSQN.vISSQN    ,'###,###,##0.00');
          FieldByName('vBcISSQN').AsString          := FormatFloatBr( Imposto.ISSQN.vBC       ,'###,###,##0.00');
          FieldByName('Valorliquido').AsString      := FormatFloatBr( Prod.vProd - Prod.vDesc ,'###,###,##0.00');
          FieldByName('ValorAcrescimos').AsString   := FormatFloatBr( Prod.vProd + Prod.vOutro,'###,###,##0.00');

          case FDANFEClassOwner.ImprimeValor of
          iuComercial:
            begin
              FieldByName('Unidade').AsString       := FieldByName('Ucom').AsString;
              FieldByName('Quantidade').AsString    := FDANFEClassOwner.FormatarQuantidade( FieldByName('QCom').AsFloat );
              FieldByName('ValorUnitario').AsString := FDANFEClassOwner.FormatarValorUnitario( FieldByName('VUnCom').AsFloat );
            end;
          iuTributavel:
            begin
              FieldByName('Unidade').AsString       := FieldByName('UTrib').AsString;
              FieldByName('Quantidade').AsString    := FDANFEClassOwner.FormatarQuantidade( FieldByName('QTrib').AsFloat );
              FieldByName('ValorUnitario').AsString := FDANFEClassOwner.FormatarValorUnitario( FieldByName('VUnTrib').AsFloat);
            end;
          iuComercialETributavel:
            begin
              if FieldByName('Ucom').AsString = FieldByName('UTrib').AsString then
              begin
                FieldByName('Unidade').AsString       := FieldByName('Ucom').AsString;
                FieldByName('Quantidade').AsString    := FDANFEClassOwner.FormatarQuantidade( FieldByName('QCom').AsFloat );
                FieldByName('ValorUnitario').AsString := FDANFEClassOwner.FormatarValorUnitario( FieldByName('VUnCom').AsFloat );
              end
              else
              begin
                FieldByName('Unidade').AsString       := FDANFEClassOwner.ManterUnidades(FieldByName('Ucom').AsString, FieldByName('UTrib').AsString);
                FieldByName('Quantidade').AsString    := FDANFEClassOwner.ManterQuantidades(FieldByName('QCom').AsFloat, FieldByName('QTrib').AsFloat);
                FieldByName('ValorUnitario').AsString := FDANFEClassOwner.ManterValoresUnitarios(FieldByName('VUnCom').AsFloat, FieldByName('VUnTrib').AsFloat);
              end;
            end;
          end;
          Post;
        end;
      end;
    end;
  end;
end;

procedure TACBrNFeFRClass.CarregaDestinatario;
begin
  { destinat�rio }
  with cdsDestinatario do
  begin
    Close;
    CreateDataSet;
    Append;

    with FNFe.Dest do
    begin
      if NaoEstaVazio(idEstrangeiro) then
        FieldByName('CNPJCPF').AsString := idEstrangeiro
      else
        FieldByName('CNPJCPF').AsString := FormatarCNPJouCPF(CNPJCPF);

      FieldByName('IE').AsString        := IE;
      FieldByName('XNome').AsString     := XNome;
      with EnderDest do
      begin
        FieldByName('XLgr').AsString    := XLgr;
        FieldByName('Nro').AsString     := Nro;
        FieldByName('XCpl').AsString    := XCpl;
        FieldByName('XBairro').AsString := XBairro;
        FieldByName('CMun').AsString    := IntToStr(CMun);
        FieldByName('XMun').AsString    := CollateBr(XMun);
        FieldByName('UF').AsString      := UF;
        FieldByName('CEP').AsString     := FormatarCEP(CEP);
        FieldByName('CPais').AsString   := IntToStr(CPais);
        FieldByName('XPais').AsString   := XPais;
        FieldByName('Fone').AsString    := FormatarFone(Fone);
      end;

      FieldByName('Consumidor').AsString := '';

      if (cdsIdentificacao.FieldByName('Mod_').AsString = '65') then
      begin
        if NaoEstaVazio(idEstrangeiro) then
          FieldByName('Consumidor').AsString := 'ESTRANGEIRO: ' + Trim(FieldByName('CNPJCPF').AsString) + ' ' + trim(FieldByName('XNome').AsString)
        else
        begin
          if EstaVazio(FieldByName('CNPJCPF').AsString) then
            FieldByName('Consumidor').AsString := ACBrStr('CONSUMIDOR N�O IDENTIFICADO')
          else
            FieldByName('Consumidor').AsString :=
              IfThen(Length(CNPJCPF) = 11, 'CPF: ', 'CNPJ: ') + Trim(FieldByName('CNPJCPF').AsString) + ' ' + trim(FieldByName('XNome').AsString);
        end;

        if NaoEstaVazio(Trim(FieldByName('XLgr').AsString)) then
          FieldByName('Consumidor').AsString := FieldByName('Consumidor').AsString + #13 +
            Trim(FieldByName('XLgr').AsString) + ', ' + Trim(FieldByName('Nro').AsString);
        if NaoEstaVazio(Trim(FieldByName('XCpl').AsString)) then
          FieldByName('Consumidor').AsString := FieldByName('Consumidor').AsString + #13 +
            Trim(FieldByName('XCpl').AsString);

        if NaoEstaVazio(Trim(FieldByName('XMun').AsString)) then
          FieldByName('Consumidor').AsString := FieldByName('Consumidor').AsString + #13 +
            Trim(FieldByName('XBairro').AsString) + ' - ' +
            Trim(FieldByName('XMun').AsString) + '/' +
            Trim(FieldByName('UF').AsString);
      end;
    end;
    Post;
  end;
end;

procedure TACBrNFeFRClass.CarregaDuplicatas;
var
  i: Integer;
begin
  cdsDuplicatas.Close;
  cdsDuplicatas.CreateDataSet;
  if (FDANFEClassOwner is TACBrNFeDANFEClass) and
     Not ((TACBrNFeDANFEClass(FDANFEClassOwner).ExibeCampoFatura) and
          (FNFe.Ide.indPag = ipVista) and (FNFe.infNFe.Versao <= 3.10)) then
  begin

    with cdsDuplicatas do
    begin
      for i := 0 to (NFe.Cobr.Dup.Count - 1) do
      begin
        Append;
        with FNFe.Cobr.Dup[i] do
        begin
          FieldByName('ChaveNFe').AsString  := FNFe.infNFe.ID;
          FieldByName('NDup').AsString      := NDup;
          FieldByName('DVenc').AsString     := FormatDateBr(DVenc);
          FieldByName('VDup').AsFloat       := VDup;
        end;
        Post;
      end;
    end;
  end;
end;

procedure TACBrNFeFRClass.CarregaEmitente;
begin
  { emitente }
  with cdsEmitente do
  begin
    Close;
    CreateDataSet;
    Append;

    with FNFe.Emit do
    begin
      FieldByName('CNPJ').AsString  := FormatarCNPJ(CNPJCPF);
      FieldByName('XNome').AsString := DANFEClassOwner.ManterNomeImpresso( XNome , XFant );
      FieldByName('XFant').AsString := XFant;
      with EnderEmit do
      begin
        FieldByName('Xlgr').AsString    := XLgr;
        FieldByName('Nro').AsString     := Nro;
        FieldByName('XCpl').AsString    := XCpl;
        FieldByName('XBairro').AsString := XBairro;
        FieldByName('CMun').AsString    := IntToStr(CMun);
        FieldByName('XMun').AsString    := CollateBr(XMun);
        FieldByName('UF').AsString      := UF;
        FieldByName('CEP').AsString     := FormatarCEP(CEP);
        FieldByName('CPais').AsString   := IntToStr(CPais);
        FieldByName('XPais').AsString   := XPais;
        FieldByName('Fone').AsString    := FormatarFone(Fone);
      end;
      FieldByName('IE').AsString        := IE;
      FieldByName('IM').AsString        := IM;
      FieldByName('IEST').AsString      := IEST;
      FieldByName('CRT').AsString       := CRTToStr(CRT);

      if (Trim(FieldByName('CRT').AsString) = '1') then
        FieldByName('DESCR_CST').AsString := 'CSOSN'
      else
        FieldByName('DESCR_CST').AsString := 'CST';

      cdsEmitente.FieldByName('DADOS_ENDERECO').AsString    := Trim(FieldByName('XLgr').AsString) + ', ' +
                                                                Trim(FieldByName('Nro').AsString);
	    if NaoEstaVazio(trim(FieldByName('XCpl').AsString)) then
        cdsEmitente.FieldByName('DADOS_ENDERECO').AsString  := cdsEmitente.FieldByName('DADOS_ENDERECO').AsString + ', ' +
                                                                Trim(FieldByName('XCpl').AsString);

      cdsEmitente.FieldByName('DADOS_ENDERECO').AsString    := cdsEmitente.FieldByName('DADOS_ENDERECO').AsString + ' - ' +
  										  	                                      Trim(FieldByName('XBairro').AsString) + ' - ' +
                                                                Trim(FieldByName('XMun').AsString) + ' - ' +
                                                                Trim(FieldByName('UF').AsString) +
                                                                ' - CEP: ' + Trim(FieldByName('CEP').AsString) + #13 +
		  	  				  				                                    ' Fone: ' + Trim(FieldByName('Fone').AsString) +
                                                                IfThen(trim(FDANFEClassOwner.Fax) <> '', ' - FAX: ' + FormatarFone(Trim(FDANFEClassOwner.Fax)),'');
      if NaoEstaVazio(Trim(FDANFEClassOwner.Site)) then
        cdsEmitente.FieldByName('DADOS_ENDERECO').AsString  := cdsEmitente.FieldByName('DADOS_ENDERECO').AsString + #13 +
                                                                trim(FDANFEClassOwner.Site);
      if NaoEstaVazio(Trim(FDANFEClassOwner.Email)) then
        cdsEmitente.FieldByName('DADOS_ENDERECO').AsString  := cdsEmitente.FieldByName('DADOS_ENDERECO').AsString + #13 +
                                                                Trim(FDANFEClassOwner.Email);
    end;

    Post;
  end;
end;

procedure TACBrNFeFRClass.CarregaFatura;
begin
  with cdsFatura do
  begin
    Close;
    CreateDataSet;

    if (FDANFEClassOwner is TACBrNFeDANFEClass) and TACBrNFeDANFEClass(FDANFEClassOwner).ExibeCampoFatura then
    begin
      Append;

      FieldByName('iForma').asInteger := Integer( FNFe.Ide.indPag);

      if FNFe.infNFe.Versao >= 4 then
        FieldByName('Pagamento').AsString := ACBrStr('DADOS DA FATURA')
      else
      begin
        case FNFe.Ide.indPag of
          ipVista : FieldByName('Pagamento').AsString := ACBrStr('PAGAMENTO � VISTA');
          ipPrazo : FieldByName('Pagamento').AsString := ACBrStr('PAGAMENTO A PRAZO');
          ipOutras: FieldByName('Pagamento').AsString := ACBrStr('OUTROS');
        end;
      end;

      if NaoEstaVazio(FNFe.Cobr.Fat.nFat) then
      begin
        with FNFe.Cobr.Fat do
        begin
          FieldByName('nfat').AsString  := nFat;
          FieldByName('vOrig').AsFloat  := vOrig;
          FieldByName('vDesc').AsFloat  := vDesc;
          FieldByName('vLiq').AsFloat   := vLiq;
        end;
      end;

      if ((FNFe.infNFe.Versao >= 4) or (FNFe.Ide.indPag = ipOutras)) and EstaVazio(FNFe.Cobr.Fat.nFat) then
        Cancel
      else
        Post;

    end;
  end;
end;

procedure TACBrNFeFRClass.CarregaPagamento;
var
  i: Integer;
begin
  with cdsPagamento do
  begin
    Close;
    CreateDataSet;
    for i := 0 to NFe.Pag.Count - 1 do
    begin
      Append;
      with FNFe.Pag[i] do
      begin
        FieldByName('tPag').AsString  := FormaPagamentoToDescricao( tPag );
        FieldByName('vPag').AsFloat   := vPag;
        // ver tpIntegra
        FieldByName('CNPJ').AsString  := FormatarCNPJ(CNPJ);
        FieldByName('tBand').AsString := BandeiraCartaoToDescStr( tBand );
        FieldByName('cAut').AsString  := cAut;
      end;
      Post;
    end;

    // acrescenta o troco
    if (FDANFEClassOwner is TACBrNFeDANFCEClass) and (TACBrNFeDANFCEClass(FDANFEClassOwner).vTroco > 0) then
    begin
      Append;
      FieldByName('tPag').AsString  := 'Troco R$';
      FieldByName('vPag').AsFloat   := TACBrNFeDANFCEClass(FDANFEClassOwner).vTroco;
      Post;
    end;
  end;
end;

procedure TACBrNFeFRClass.CarregaIdentificacao;
begin
  with cdsIdentificacao do
  begin
    Close;
    CreateDataSet;
    Append;

    FieldByName('Id').AsString      := OnlyNumber(FNFe.infNFe.Id);
    FieldByName('Versao').AsFloat   := FNFe.infNFe.versao;
    FieldByName('Chave').AsString   := FormatarChaveAcesso(FNFe.infNFe.Id);
    FieldByName('CUF').AsString     := IntToStr(FNFe.Ide.CUF);
    FieldByName('CNF').AsString     := IntToStr(FNFe.Ide.CNF);
    FieldByName('NatOp').AsString   := FNFe.Ide.NatOp;
    FieldByName('IndPag').AsString  := IndpagToStr(FNFe.Ide.IndPag );
    FieldByName('Mod_').AsString    := IntToStr(FNFe.Ide.Modelo);
    FieldByName('Serie').AsString   := IntToStr(FNFe.Ide.Serie);
    FieldByName('NNF').AsString     := FormatarNumeroDocumentoFiscal(IntToStr(FNFe.Ide.NNF));
    FieldByName('DEmi').AsString    := FormatDateBr(FNFe.Ide.DEmi);
    FieldByName('DSaiEnt').AsString := IfThen(FNFe.Ide.DSaiEnt <> 0, FormatDateBr(FNFe.Ide.DSaiEnt));
    FieldByName('TpNF').AsString    := tpNFToStr( FNFe.Ide.TpNF );
    FieldByName('CMunFG').AsString  := IntToStr(FNFe.Ide.CMunFG);
    FieldByName('TpImp').AsString   := TpImpToStr( FNFe.Ide.TpImp );
    FieldByName('TpEmis').AsString  := TpEmisToStr( FNFe.Ide.TpEmis );
    FieldByName('CDV').AsString     := IntToStr(FNFe.Ide.CDV);
    FieldByName('TpAmb').AsString   := TpAmbToStr( FNFe.Ide.TpAmb );
    FieldByName('FinNFe').AsString  := FinNFeToStr( FNFe.Ide.FinNFe );
    FieldByName('ProcEmi').AsString := procEmiToStr( FNFe.Ide.ProcEmi );
    FieldByName('VerProc').AsString := FNFe.Ide.VerProc;
    if FNFe.infNFe.versao = 2.00 then
      FieldByName('HoraSaida').AsString := ifthen(FNFe.ide.hSaiEnt = 0, '', TimeToStr(FNFe.ide.hSaiEnt))
    else
      FieldByName('HoraSaida').AsString := ifthen(TimeOf(FNFe.ide.dSaiEnt)=0, '', TimeToStr(FNFe.ide.dSaiEnt));

    if (FNFe.Ide.Modelo = 65) then
    begin
      FieldByName('DEmi').AsString := FormatDateTimeBr(FNFe.Ide.DEmi);
      if FNFe.Ide.TpAmb = taHomologacao then
          FieldByName('MensagemFiscal').AsString := ACBrStr('EMITIDA EM AMBIENTE DE HOMOLOGA��O - SEM VALOR FISCAL')
      else
      begin
        if (FNFe.Ide.tpEmis <> teNormal) and EstaVazio(FNFe.procNFe.nProt) then
          FieldByName('MensagemFiscal').AsString := ACBrStr('EMITIDA EM CONTING�NCIA'+LineBreak+'Pendente de autoriza��o')
        else
          FieldByName('MensagemFiscal').AsString := ACBrStr('�REA DE MENSAGEM FISCAL');
      end;

      if EstaVazio(FNFe.infNFeSupl.urlChave) then
        FieldByName('URL').AsString := TACBrNFe(DANFEClassOwner.ACBrNFe).GetURLConsultaNFCe(FNFe.Ide.cUF, FNFe.Ide.tpAmb, FNFe.infNFe.Versao)
      else
        FieldByName('URL').AsString := FNFe.infNFeSupl.urlChave;
    end
    else
    begin
      FieldByName('MensagemFiscal').AsString := '';
      FieldByName('URL').AsString            := '';
    end;
    Post;
  end;
end;

procedure TACBrNFeFRClass.CarregaInformacoesAdicionais;
var
  vTemp         : TStringList;
  IndexCampo    : Integer;
  Campos        : TSplitResult;
  BufferInfCpl  : String;
  wObs          : string;
  wLinhasObs    : integer;
begin
  wLinhasObs  := 0;
  BufferInfCpl:= '';
  vTemp       := TStringList.Create;
  
  try
    if (FDANFEClassOwner is TACBrNFeDANFEClass) then
    begin
      wObs := TACBrNFeDANFEClass(FDANFEClassOwner).ManterDocreferenciados(FNFe) +
              FDANFEClassOwner.ManterInfAdFisco(FNFe) +
              FDANFEClassOwner.ManterObsFisco(FNFe) +
              FDANFEClassOwner.ManterProcreferenciado(FNFe) +
              FDANFEClassOwner.ManterInfContr(FNFe) +
              FDANFEClassOwner.ManterInfCompl(FNFe) +
              TACBrNFeDANFEClass(FDANFEClassOwner).ManterContingencia(FNFe);
    end
    else
    begin
      wObs := FDANFEClassOwner.ManterInfAdFisco(FNFe) +
              FDANFEClassOwner.ManterObsFisco(FNFe) +
              FDANFEClassOwner.ManterProcreferenciado(FNFe) +
              FDANFEClassOwner.ManterInfContr(FNFe) +
              FDANFEClassOwner.ManterInfCompl(FNFe);
    end;
	
    if Trim(wObs) <> '' then
    begin
      Campos := Split(';', wObs);
      for IndexCampo := 0 to Length(Campos) - 1 do
        vTemp.Add(Campos[IndexCampo]);

      wLinhasObs    := 1; //TotalObS(vTemp.Text);
      BufferInfCpl  := vTemp.Text;
    end;
	
    with cdsInformacoesAdicionais do
    begin
      Close;
      CreateDataSet;
      Append;
      FieldByName('OBS').AsString        := BufferInfCpl;
      FieldByName('LinhasOBS').AsInteger := wLinhasObs;
      Post;
    end;
	
  finally
    vTemp.Free;
  end;
end;

procedure TACBrNFeFRClass.CarregaISSQN;
begin
  with cdsISSQN do
  begin
    Close;
    CreateDataSet;
    Append;
    with FNFe.Total.ISSQNtot do
    begin
      FieldByName('vSERV').AsFloat        := VServ;
      FieldByName('vBC').AsFloat          := VBC;
      FieldByName('vISS').AsFloat         := VISS;
      FieldByName('vDescIncond').AsFloat  := vDescIncond;
      FieldByName('vISSRet').AsFloat      := vISSRet;
    end;
    Post;
  end;
end;

procedure TACBrNFeFRClass.CarregaLocalEntrega;
begin
  { local de entrega }
  with cdsLocalEntrega do
  begin
    Close;
    CreateDataSet;

    if NaoEstaVazio(FNFe.Entrega.CNPJCPF) then
    begin
      Append;

      with FNFe.Entrega do
      begin
        FieldByName('CNPJ').AsString    := FormatarCNPJouCPF(CNPJCPF);;
        FieldByName('Xlgr').AsString    := XLgr;
        FieldByName('Nro').AsString     := Nro;
        FieldByName('XCpl').AsString    := XCpl;
        FieldByName('XBairro').AsString := XBairro;
        FieldByName('CMun').AsString    := inttostr(CMun);
        FieldByName('XMun').AsString    := CollateBr(XMun);
        FieldByName('UF').AsString      := UF;
      end;
      Post;
    end;
  end;
end;

procedure TACBrNFeFRClass.CarregaLocalRetirada;
begin
  { local de retirada }
  with cdsLocalRetirada do
  begin
    Close;
    CreateDataSet;

    if NaoEstaVazio(FNFe.Retirada.CNPJCPF) then
    begin
      Append;

      with FNFe.Retirada do
      begin
        FieldByName('CNPJ').AsString    := FormatarCNPJouCPF(CNPJCPF);
        FieldByName('Xlgr').AsString    := XLgr;
        FieldByName('Nro').AsString     := Nro;
        FieldByName('XCpl').AsString    := XCpl;
        FieldByName('XBairro').AsString := XBairro;
        FieldByName('CMun').AsString    := inttostr(CMun);
        FieldByName('XMun').AsString    := CollateBr(XMun);
        FieldByName('UF').AsString      := UF;
      end;
      Post;
    end;
  end;
end;

procedure TACBrNFeFRClass.CarregaParametros;
var
  vChave_Contingencia : String;
  vStream             : TMemoryStream;
  vStringStream       : TStringStream;
  P: Integer;
begin
  { par�metros }
  with cdsParametros do
  begin
    Close;
    CreateDataSet;
    Append;

    FieldByName('poscanhoto').AsString            := '';
    FieldByName('ResumoCanhoto').AsString         := '';
    FieldByName('Mensagem0').AsString             := '';
    FieldByName('Contingencia_ID').AsString       := '';
    FieldByName('ConsultaAutenticidade').AsString := 'Consulta de autenticidade no portal nacional da NF-e'+#13+
                                                     'www.nfe.fazenda.gov.br/portal ou no site da Sefaz autorizadora';

    if DANFEClassOwner is TACBrNFeDANFEClass then
      FieldByName('poscanhoto').AsString := IntToStr( Ord(TACBrNFeDANFEClass(DANFEClassOwner).PosCanhoto))
    else if DANFEClassOwner is TACBrNFeDANFCEClass then
    begin
      if TACBrNFeDANFCEClass(DANFEClassOwner).ViaConsumidor then
        FieldByName('DescricaoViaEstabelec').AsString := 'Via Consumidor'
      else
        FieldByName('DescricaoViaEstabelec').AsString := 'Via Estabelecimento';
    end;

    if Assigned(FNFe) then
    begin
      if (DANFEClassOwner is TACBrNFeDANFEClass) and TACBrNFeDANFEClass(DANFEClassOwner).ExibeResumoCanhoto then
      begin
         if EstaVazio(TACBrNFeDANFEClass(DANFEClassOwner).TextoResumoCanhoto) then
          FieldByName('ResumoCanhoto').AsString := ACBrStr('Emiss�o: ' )+ FormatDateBr(FNFe.Ide.DEmi) + '  Dest/Reme: ' + FNFe.Dest.XNome + '  Valor Total: ' + FormatFloatBr(FNFe.Total.ICMSTot.VNF)
        else
          FieldByName('ResumoCanhoto').AsString := TACBrNFeDANFEClass(DANFEClassOwner).TextoResumoCanhoto;
      end;

      if (FNFe.Ide.TpAmb = taHomologacao) then
      begin
        if (FNFe.Ide.tpEmis in [teContingencia, teFSDA, teSCAN, teDPEC, teSVCAN, teSVCRS, teSVCSP]) then
        begin
          if (FNFe.procNFe.cStat in [101,135, 151, 155]) then
            FieldByName('Mensagem0').AsString := ACBrStr('NFe sem Valor Fiscal - HOMOLOGA��O ' +
                                                        #10#13+'NFe em Conting�ncia - CANCELADA')
          else
            FieldByName('Mensagem0').AsString := ACBrStr('NFe sem Valor Fiscal - HOMOLOGA��O'+
                                                        #10#13+'NFe em Conting�ncia');
        end
        else
          FieldByName('Mensagem0').AsString :=ACBrStr( 'NFe sem Valor Fiscal - HOMOLOGA��O')
      end
      else
      begin
        if not (FNFe.Ide.tpEmis in [teContingencia, teFSDA, teSVCAN, teSVCRS, teSVCSP]) then
        begin
          //prioridade para op��o Cancelada
          if (FDANFEClassOwner.Cancelada) or
             ((NaoEstaVazio(FNFe.procNFe.nProt)) and
              (FNFe.procNFe.cStat in [101,135,151,155])) then
            FieldByName('Mensagem0').AsString := 'NFe Cancelada'
          else if ( FNFe.procNFe.cStat = 110 ) or
                  ( FNFe.procNFe.cStat = 301 ) or
                  ( FNFe.procNFe.cStat = 302 ) or
                  ( FNFe.procNFe.cStat = 303 ) then
            FieldByName('Mensagem0').AsString := 'NFe denegada pelo Fisco'
          else if ((EstaVazio(FDANFEClassOwner.Protocolo)) and
                   (EstaVazio(FNFe.procNFe.nProt))) then
            FieldByName('Mensagem0').AsString := ACBrStr( 'NFe sem Autoriza��o de Uso da SEFAZ')
          else if (FNFe.Ide.tpImp = tiSimplificado) then
            FieldByName('Mensagem0').AsString := ACBrStr( 'EMISS�O NORMAL' );
        end;
      end;

      case FNFe.Ide.tpEmis of
        teNormal,
        teSVCAN,
        teSCAN,
        teSVCRS,
        teSVCSP :   begin
                      FieldByName('ChaveAcesso_Descricao').AsString := 'CHAVE DE ACESSO';
                      FieldByName('Contingencia_ID').AsString := '';

                      if ((FDANFEClassOwner.Cancelada) or (FNFe.procNFe.cStat in [101,151,155])) then
                        FieldByName('Contingencia_Descricao').AsString := ACBrStr('PROTOCOLO DE HOMOLOGA��O DO CANCELAMENTO' )
                      else if ( FNFe.procNFe.cStat = 110 ) or
                              ( FNFe.procNFe.cStat = 301 ) or
                              ( FNFe.procNFe.cStat = 302 ) or
                              ( FNFe.procNFe.cStat = 303 ) then
                        FieldByName('Contingencia_Descricao').AsString := ACBrStr('PROTOCOLO DE DENEGA��O DE USO')
                      else
                        FieldByName('Contingencia_Descricao').AsString := ACBrStr('PROTOCOLO DE AUTORIZA��O DE USO');

                      if EstaVazio(FDANFEClassOwner.Protocolo) then
                      begin
                        if EstaVazio(FNFe.procNFe.nProt) then
                          FieldByName('Contingencia_Valor').AsString := ACBrStr('NFe sem Autoriza��o de Uso da SEFAZ')
                        else
                        begin
                          FieldByName('Contingencia_Valor').AsString := FNFe.procNFe.nProt + ' ' + IfThen(FNFe.procNFe.dhRecbto <> 0, FormatDateTimeBr(FNFe.procNFe.dhRecbto), '');
                          FieldByName('nProt').AsString := FNFe.procNfe.nProt;
                          FieldByName('dhRecbto').AsDateTime := FNFe.procNFe.dhRecbto;
                        end;
                      end
                      else
                      begin
                        FieldByName('Contingencia_Valor').AsString := FDANFEClassOwner.Protocolo;
                        P := Pos('-', FDANFEClassOwner.Protocolo);
                        if P = 0 then
                        begin
                          FieldByName('nProt').AsString := Trim(FDANFEClassOwner.Protocolo);
                          FieldByName('dhRecbto').AsDateTime := 0;
                        end
                        else
                        begin
                          FieldByName('nProt').AsString := Trim(Copy(FDANFEClassOwner.Protocolo, 1, P - 1));
                          FieldByName('dhRecbto').AsDateTime := StringToDateTimeDef(Trim(
                            Copy(FDANFEClassOwner.Protocolo, P + 1, Length(FDANFEClassOwner.Protocolo) - P)
                            ), 0, 'dd/mm/yyyy hh:nn:ss');
                        end;
                      end;
                    end;

        teContingencia ,
        teFSDA :    begin
                      vChave_Contingencia := TACBrNFe(DANFEClassOwner.ACBrNFe).GerarChaveContingencia(FNFe);
                      FieldByName('ChaveAcesso_Descricao').AsString  := 'CHAVE DE ACESSO';
                      FieldByName('Contingencia_ID').AsString        := vChave_Contingencia;
                      FieldByName('Contingencia_Descricao').AsString := 'DADOS DA NF-E';
                      FieldByName('Contingencia_Valor').AsString     := FormatarChaveAcesso(vChave_Contingencia);
                      FieldByName('ConsultaAutenticidade').AsString  := '';
                    end;

         teDPEC  :  begin
                      if NaoEstaVazio(FNFe.procNFe.nProt) then // DPEC TRANSMITIDO
                      begin
                        FieldByName('Contingencia_Descricao').AsString := ACBrStr( 'PROTOCOLO DE AUTORIZA��O DE USO');
                        FieldByName('Contingencia_Valor').AsString     := FNFe.procNFe.nProt + ' ' + IfThen(FNFe.procNFe.dhRecbto <> 0, FormatDateTimeBr(FNFe.procNFe.dhRecbto), '');
                      end
                      else
                      begin
                        FieldByName('Contingencia_Descricao').AsString := ACBrStr('N�MERO DE REGISTRO DPEC');
                        if NaoEstaVazio(FDANFEClassOwner.Protocolo) then
                          FieldByName('Contingencia_Valor').AsString := FDANFEClassOwner.Protocolo;
                      end;
                    end;

         teOffLine: begin
                      FieldByName('Contingencia_Valor').AsString := FNFe.procNFe.nProt + ' ' + IfThen(FNFe.procNFe.dhRecbto <> 0, FormatDateTimeBr(FNFe.procNFe.dhRecbto), '');
                      FieldByName('nProt').AsString := FNFe.procNfe.nProt;
                      FieldByName('dhRecbto').AsDateTime := FNFe.procNFe.dhRecbto;
                    end;
      end;

      FieldByName('QtdeItens').AsInteger := NFe.Det.Count;

    end;

    if NaoEstaVazio(FieldByName('Mensagem0').AsString) then
      FieldByName('Mensagem0').AsString  := FieldByName('Mensagem0').AsString+#10#13;

    FieldByName('Mensagem0').AsString                   := FieldByName('Mensagem0').AsString + IfThen(FDANFEClassOwner is TACBrNFeDANFEFR, TACBrNFeDANFEFR(FDANFEClassOwner).MarcaDaguaMSG, '');
    FieldByName('LogoExpandido').AsString               := IfThen( FDANFEClassOwner.ExpandeLogoMarca, '1' , '0' );
    FieldByName('Sistema').AsString                     := IfThen( FDANFEClassOwner.Sistema <> '' , FDANFEClassOwner.Sistema, 'Projeto ACBr - http://acbr.sf.net');
    FieldByName('Usuario').AsString                     := IfThen( FDANFEClassOwner.Usuario <> '' , ' - ' + FDANFEClassOwner.Usuario , '' );
    FieldByName('Fax').AsString                         := IfThen( FDANFEClassOwner.Fax     <> '' , ' - FAX ' + FDANFEClassOwner.Fax , '');
    FieldByName('Site').AsString                        := FDANFEClassOwner.Site;
    FieldByName('Email').AsString                       := FDANFEClassOwner.Email;
    FieldByName('Desconto').AsString                    := IfThen( (FDANFEClassOwner is TACBrNFeDANFEClass) and TACBrNFeDANFEClass(FDANFEClassOwner).ImprimeDescPorPercentual , '%' , 'VALOR');
    FieldByName('TotalLiquido').AsString                := IfThen( FDANFEClassOwner.ImprimeTotalLiquido ,ACBrStr('L�QUIDO') ,'TOTAL');
    FieldByName('LinhasPorPagina').AsInteger            := 0;
    FieldByName('ExpandirDadosAdicionaisAuto').AsString := IfThen(TACBrNFeDANFEFR(FDANFEClassOwner).ExpandirDadosAdicionaisAuto , 'S' , 'N');
    FieldByName('sDisplayFormat').AsString              := '###,###,###,##0.%.*d';
    FieldByName('iFormato').AsInteger                   := integer( FDANFEClassOwner.CasasDecimais.Formato );
    FieldByName('Mask_qCom').AsString                   := FDANFEClassOwner.CasasDecimais.MaskqCom;
    FieldByName('Mask_vUnCom').AsString                 := FDANFEClassOwner.CasasDecimais.MaskvUnCom;
    FieldByName('Casas_qCom').AsInteger                 := FDANFEClassOwner.CasasDecimais.qCom;
    FieldByName('Casas_vUnCom').AsInteger               := FDANFEClassOwner.CasasDecimais.vUnCom;

    // Carregamento da imagem
    if NaoEstaVazio(DANFEClassOwner.Logo) then
    begin
      FieldByName('Imagem').AsString := DANFEClassOwner.Logo;
      vStream := TMemoryStream.Create;
      try
        if FileExists(DANFEClassOwner.Logo) then
          vStream.LoadFromFile(DANFEClassOwner.Logo)
        else
        begin
          vStringStream:= TStringStream.Create(DANFEClassOwner.Logo);
          try
            vStream.LoadFromStream(vStringStream);
          finally
            vStringStream.Free;
          end;
        end;
        vStream.Position := 0;
        TBlobField(cdsParametros.FieldByName('LogoCarregado')).LoadFromStream(vStream);
      finally
        vStream.Free;
      end;
    end;

    Post;
  end;
end;

procedure TACBrNFeFRClass.CarregaTransportador;
var
  ok: Boolean;
begin
  with cdsTransportador do
  begin
    Close;
    CreateDataSet;
    Append;

    with FNFe.Transp do
    begin
      FieldByName('ModFrete').AsString := modFreteToDesStr( modFrete, StrToVersaoDF(ok, FNFe.infNFe.VersaoStr));
      with Transporta do
      begin
        FieldByName('CNPJCPF').AsString := FormatarCNPJouCPF(CNPJCPF);
        FieldByName('XNome').AsString   := XNome;
        FieldByName('IE').AsString      := IE;
        FieldByName('XEnder').AsString  := XEnder;
        FieldByName('XMun').AsString    := CollateBr(XMun);
        FieldByName('UF').AsString      := UF;
      end;
    end;
    Post;
  end;
end;

procedure TACBrNFeFRClass.CarregaVeiculo;
begin
  with cdsVeiculo do
  begin
    Close;
    CreateDataSet;
    Append;
    with FNFe.Transp.VeicTransp do
    begin
      FieldByName('PLACA').AsString := Placa;
      FieldByName('UF').AsString    := UF;
      FieldByName('RNTC').AsString  := RNTC;
    end;

    Post;
  end;
end;

procedure TACBrNFeFRClass.CarregaVolumes;
var
  i: Integer;
begin
  with cdsVolumes do
  begin
    Close;
    CreateDataSet;
    for i := 0 to NFe.Transp.Vol.Count - 1 do
    begin
      Append;
      with FNFe.Transp.Vol[i] do
      begin
        FieldByName('QVol').AsFloat   := QVol;
        FieldByName('Esp').AsString   := Esp;
        FieldByName('Marca').AsString := Marca;
        FieldByName('NVol').AsString  := NVol;
        FieldByName('PesoL').AsFloat  := PesoL;
        FieldByName('PesoB').AsFloat  := PesoB;
      end;
      Post;
    end;
  end;
end;

procedure TACBrNFeFRClass.CarregaDadosEventos;
var
  i: Integer;
  CondicoesUso, Correcao: String;
begin
  with cdsEventos do
  begin
    Close;

    FieldDefs.Clear;
    FieldDefs.Add('DescricaoTipoEvento', ftString, 150);
    FieldDefs.Add('Modelo', ftString, 2);
    FieldDefs.Add('Serie', ftString, 3);
    FieldDefs.Add('Numero', ftString, 9);
    FieldDefs.Add('MesAno', ftString, 5);
    FieldDefs.Add('Barras', ftString, 44);
    FieldDefs.Add('ChaveAcesso', ftString, 60);
    FieldDefs.Add('cOrgao', ftInteger);
    FieldDefs.Add('tpAmb', ftString, 100);
    FieldDefs.Add('dhEvento', ftDateTime);
    FieldDefs.Add('TipoEvento', ftString, 6);
    FieldDefs.Add('DescEvento', ftString, 100);
    FieldDefs.Add('nSeqEvento', ftInteger);
    FieldDefs.Add('versaoEvento', ftString, 10);
    FieldDefs.Add('cStat', ftInteger);
    FieldDefs.Add('xMotivo', ftString, 100);
    FieldDefs.Add('nProt', ftString, 20);
    FieldDefs.Add('dhRegEvento', ftDateTime);
    FieldDefs.Add('xJust', ftBlob);
    FieldDefs.Add('xCondUso', ftBlob);
    FieldDefs.Add('xCorrecao', ftBlob);

    CreateDataSet;

    for i := 0 to FEvento.Evento.Count - 1 do
    begin
      Append;

      with Evento.Evento[i] do
      begin
        FieldByName('DescricaoTipoEvento').AsString := InfEvento.DescricaoTipoEvento(InfEvento.tpEvento);

        // nota fiscal eletronica
        FieldByName('Modelo').AsString      := Copy(InfEvento.chNFe, 21, 2);
        FieldByName('Serie').AsString       := Copy(InfEvento.chNFe, 23, 3);
        FieldByName('Numero').AsString      := Copy(InfEvento.chNFe, 26, 9);
        FieldByName('MesAno').AsString      := Copy(InfEvento.chNFe, 05, 2) + '/' + copy(InfEvento.chNFe, 03, 2);
        FieldByName('Barras').AsString      := InfEvento.chNFe;
        FieldByName('ChaveAcesso').AsString := FormatarChaveAcesso(InfEvento.chNFe);

        // Carta de corre��o eletr�nica
        FieldByName('cOrgao').AsInteger := InfEvento.cOrgao;

        case InfEvento.tpAmb of
          taProducao:    FieldByName('tpAmb').AsString := ACBrStr('PRODU��O');
          taHomologacao: FieldByName('tpAmb').AsString := ACBrStr('HOMOLOGA��O - SEM VALOR FISCAL');
        end;

        FieldByName('dhEvento').AsDateTime    := InfEvento.dhEvento;
        FieldByName('TipoEvento').AsString    := InfEvento.TipoEvento;
        FieldByName('DescEvento').AsString    := InfEvento.DescEvento;
        FieldByName('nSeqEvento').AsInteger   := InfEvento.nSeqEvento;
        FieldByName('versaoEvento').AsString  := InfEvento.versaoEvento;
        FieldByName('cStat').AsInteger        := RetInfEvento.cStat;
        FieldByName('xMotivo').AsString       := RetInfEvento.xMotivo;
        FieldByName('nProt').AsString         := RetInfEvento.nProt;
        FieldByName('dhRegEvento').AsDateTime := RetInfEvento.dhRegEvento;

        if InfEvento.tpEvento <> teCCe then
        begin
          FieldByName('xJust').AsString := InfEvento.detEvento.xJust;
        end
        else
        begin
          CondicoesUso := InfEvento.detEvento.xCondUso;
          CondicoesUso := StringReplace(CondicoesUso, 'com: I', 'com:'+#13+' I', [rfReplaceAll]);
          CondicoesUso := StringReplace(CondicoesUso, ';', ';' + #13, [rfReplaceAll]);

          Correcao := InfEvento.detEvento.xCorrecao;
          Correcao := StringReplace(InfEvento.detEvento.xCorrecao, ';', #13, [rfReplaceAll]);

          FieldByName('xCondUso').AsString  := CondicoesUso;
          FieldByName('xCorrecao').AsString := Correcao;
        end;
      end;
      Post;
    end;
  end;
end;

procedure TACBrNFeFRClass.CarregaDadosInutilizacao;
begin
   CarregaParametros;

   with cdsInutilizacao do
   begin
      Close;
      FieldDefs.Clear;
      FieldDefs.Add('ID', ftString, 44);
      FieldDefs.Add('CNPJ', ftString, 20);
      FieldDefs.Add('nProt', ftString, 20);
      FieldDefs.Add('Modelo', ftInteger);
      FieldDefs.Add('Serie', ftInteger);
      FieldDefs.Add('Ano', ftInteger);
      FieldDefs.Add('nNFIni', ftInteger);
      FieldDefs.Add('nNFFin', ftInteger);
      FieldDefs.Add('xJust', ftString, 50);
      FieldDefs.Add('versao', ftString, 20);
      FieldDefs.Add('TpAmb', ftString, 32);
      FieldDefs.Add('verAplic', ftString, 20);
      FieldDefs.Add('cStat', ftInteger);
      FieldDefs.Add('xMotivo', ftString, 50);
      FieldDefs.Add('cUF', ftString, 2);
      FieldDefs.Add('dhRecbto', ftDateTime);
      CreateDataSet;

      Append;

      with FInutilizacao do
      begin
         FieldByName('ID').AsString         := OnlyNumber(ID);
         FieldByName('CNPJ').AsString       := FormatarCNPJ(CNPJ);
         FieldByName('nProt').AsString      := nProt;
         FieldByName('Modelo').AsInteger    := Modelo;
         FieldByName('Serie').AsInteger     := Serie;
         FieldByName('Ano').AsInteger       := Ano;
         FieldByName('nNFIni').AsInteger    := nNFIni;
         FieldByName('nNFFin').AsInteger    := nNFFin;
         FieldByName('xJust').AsString      := xJust;
         FieldByName('versao').AsString     := versao;
         FieldByName('verAplic').AsString   := verAplic;
         FieldByName('cStat').AsInteger     := cStat;
         FieldByName('xMotivo').AsString    := xMotivo;
         FieldByName('dhRecbto').AsDateTime := dhRecbto;
         FieldByName('cUF').AsString        := CUFtoUF(cUF);

         case tpAmb of
            taProducao:    FieldByName('tpAmb').AsString := ACBrStr('PRODU��O');
            taHomologacao: FieldByName('tpAmb').AsString := ACBrStr('HOMOLOGA��O - SEM VALOR FISCAL');
         end;

         Post;
      end;
   end;
end;

procedure TACBrNFeFRClass.PintarQRCode(QRCodeData: String; APict: TPicture);
var
  QRCode: TDelphiZXingQRCode;
  QRCodeBitmap: TBitmap;
  Row, Column: Integer;
begin
  QRCode       := TDelphiZXingQRCode.Create;
  QRCodeBitmap := TBitmap.Create;
  try
    QRCode.Encoding  := qrUTF8NoBOM;
    QRCode.QuietZone := 1;
    QRCode.Data      := widestring(QRCodeData);

    //QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);
    QRCodeBitmap.Width  := QRCode.Columns;
    QRCodeBitmap.Height := QRCode.Rows;

    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack
        else
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
      end;
    end;

    APict.Assign(QRCodeBitmap);
  finally
    QRCode.Free;
    QRCodeBitmap.Free;
  end;
end;

function TACBrNFeFRClass.PrepareReport(ANFE: TNFe): Boolean;
var
  I: Integer;
  wProjectStream: TStringStream;
  Page: TfrxReportPage;
begin
  Result := False;

  SetDataSetsToFrxReport;

  if NaoEstaVazio(Trim(FastFile)) then
  begin
    if not (uppercase(copy(FastFile,length(FastFile)-3,4))='.FR3') then
    begin
      wProjectStream := TStringStream.Create(FastFile);
      frxReport.FileName := '';
      frxReport.LoadFromStream(wProjectStream);
      wProjectStream.Free;
    end
    else
    begin
      if FileExists(FastFile) then
        frxReport.LoadFromFile(FastFile)
      else
        raise EACBrNFeDANFEFR.CreateFmt('Caminho do arquivo de impress�o do DANFE "%s" inv�lido.', [FastFile]);
    end;
  end
  else
    raise EACBrNFeDANFEFR.Create('Caminho do arquivo de impress�o do DANFE n�o assinalado.');

  frxReport.PrintOptions.Copies := DANFEClassOwner.NumCopias;
  frxReport.PrintOptions.ShowDialog := DANFEClassOwner.MostraSetup;
  frxReport.PrintOptions.PrintMode := FPrintMode; //Precisamos dessa propriedade porque impressoras n�o fiscais cortam o papel quando h� muitos itens. O ajuste dela deve ser necessariamente ap�s a carga do arquivo FR3 pois, antes da carga o componente � inicializado
  frxReport.PrintOptions.PrintOnSheet := FPrintOnSheet; //Essa propriedade pode trabalhar em conjunto com a printmode
  frxReport.ShowProgress := DANFEClassOwner.MostraStatus;
  frxReport.PreviewOptions.AllowEdit := False;
  frxReport.PreviewOptions.ShowCaptions := FExibeCaptionButton;
  frxReport.OnPreview := frxReportPreview;

  // Define a impressora
  if NaoEstaVazio(DANFEClassOwner.Impressora) then
    frxReport.PrintOptions.Printer := DANFEClassOwner.Impressora;

  // preparar relatorio
  if Assigned(ANFE) then
  begin
    NFe := ANFE;
    CarregaDadosNFe;

    Result := frxReport.PrepareReport;
  end
  else
  begin
    if Assigned(DANFEClassOwner.ACBrNFe) then
    begin
      for i := 0 to (TACBrNFe(DANFEClassOwner.ACBrNFe).NotasFiscais.Count - 1) do
      begin
        NFe := TACBrNFe(DANFEClassOwner.ACBrNFe).NotasFiscais.Items[i].NFe;
        CarregaDadosNFe;

        if (i > 0) then
          Result := frxReport.PrepareReport(False)
        else
          Result := frxReport.PrepareReport;
      end;
    end
    else
      raise EACBrNFeDANFEFR.Create('Propriedade ACBrNFe n�o assinalada.');
  end;

  if Assigned(NFe) and (NFe.Ide.modelo = 55) then
    for i := 0 to (frxReport.PreviewPages.Count - 1) do
    begin
      Page := frxReport.PreviewPages.Page[i];
      if (DANFEClassOwner.MargemSuperior > 0) then
        Page.TopMargin    := DANFEClassOwner.MargemSuperior * 10;
      if (DANFEClassOwner.MargemInferior > 0) then
        Page.BottomMargin := DANFEClassOwner.MargemInferior * 10;
      if (DANFEClassOwner.MargemEsquerda > 0) then
        Page.LeftMargin   := DANFEClassOwner.MargemEsquerda * 10;
      if (DANFEClassOwner.MargemDireita > 0) then
        Page.RightMargin  := DANFEClassOwner.MargemDireita * 10;
      frxReport.PreviewPages.ModifyPage(i, Page);
    end;

end;

function TACBrNFeFRClass.PrepareReportEvento: Boolean;
var
 wProjectStream: TStringStream;
begin
  SetDataSetsToFrxReport;
  if NaoEstaVazio(Trim(FastFileEvento)) then
  begin
    if not (uppercase(copy(FastFileEvento,length(FastFileEvento)-3,4))='.FR3') then
    begin
      wProjectStream:=TStringStream.Create(FastFileEvento);
      frxReport.FileName := '';
      frxReport.LoadFromStream(wProjectStream);
      wProjectStream.Free;
    end
    else
    begin
      if FileExists(FastFileEvento) then
        frxReport.LoadFromFile(FastFileEvento)
      else
        raise EACBrNFeDANFEFR.CreateFmt('Caminho do arquivo de impress�o do EVENTO "%s" inv�lido.', [FastFileEvento]);
    end
  end
  else
    raise EACBrNFeDANFEFR.Create('Caminho do arquivo de impress�o do EVENTO n�o assinalado.');

  frxReport.PrintOptions.Copies := DANFEClassOwner.NumCopias;
  frxReport.PrintOptions.ShowDialog := DANFEClassOwner.MostraSetup;
  frxReport.ShowProgress := DANFEClassOwner.MostraStatus;
  frxReport.PreviewOptions.ShowCaptions := ExibeCaptionButton;
  frxReport.OnPreview := frxReportPreview;

  // Define a impressora
  if NaoEstaVazio(DANFEClassOwner.Impressora) then
    frxReport.PrintOptions.Printer := DANFEClassOwner.Impressora;

  // preparar relatorio
  if Assigned(DANFEClassOwner.ACBrNFe) then
  begin
    if Assigned(TACBrNFe(DANFEClassOwner.ACBrNFe).EventoNFe) then
    begin
      Evento := TACBrNFe(DANFEClassOwner.ACBrNFe).EventoNFe;
      CarregaDadosEventos;
    end
    else
      raise EACBrNFeDANFEFR.Create('Evento n�o foi assinalado.');

    if (TACBrNFe(DANFEClassOwner.ACBrNFe).NotasFiscais.Count > 0) then
    begin
      frxReport.Variables['PossuiNFe'] := QuotedStr('S');
      NFe := TACBrNFe(DANFEClassOwner.ACBrNFe).NotasFiscais.Items[0].NFe;
      CarregaDadosNFe;
    end;

    Result := frxReport.PrepareReport;
  end
  else
    raise EACBrNFeDANFEFR.Create('Propriedade ACBrNFe n�o assinalada.');

end;

function TACBrNFeFRClass.PrepareReportInutilizacao: Boolean;
var
 wProjectStream: TStringStream;
begin
  SetDataSetsToFrxReport;
  if NaoEstaVazio(Trim(FastFileInutilizacao)) then
  begin
    if not (uppercase(copy(FastFileInutilizacao,length(FastFileInutilizacao)-3,4))='.FR3') then
    begin
      wProjectStream:=TStringStream.Create(FastFileInutilizacao);
      frxReport.FileName := '';
      frxReport.LoadFromStream(wProjectStream);
      wProjectStream.Free;
    end
    else
    begin
      if FileExists(FastFileInutilizacao) then
        frxReport.LoadFromFile(FastFileInutilizacao)
      else
        raise EACBrNFeDANFEFR.CreateFmt('Caminho do arquivo de impress�o de INUTILIZA��O "%s" inv�lido.', [FastFileInutilizacao]);
    end
  end
  else
    raise EACBrNFeDANFEFR.Create('Caminho do arquivo de impress�o de INUTILIZA��O n�o assinalado.');

  frxReport.PrintOptions.Copies := DANFEClassOwner.NumCopias;
  frxReport.PrintOptions.ShowDialog := DANFEClassOwner.MostraSetup;
  frxReport.ShowProgress := DANFEClassOwner.MostraStatus;
  frxReport.PreviewOptions.ShowCaptions := ExibeCaptionButton;
  frxReport.OnPreview := frxReportPreview;

  // Define a impressora
  if NaoEstaVazio(DANFEClassOwner.Impressora) then
    frxReport.PrintOptions.Printer := DANFEClassOwner.Impressora;

  // preparar relatorio
  if Assigned(DANFEClassOwner.ACBrNFe) then
  begin
    if Assigned(TACBrNFe(DANFEClassOwner.ACBrNFe).InutNFe) then
    begin
      Inutilizacao := TACBrNFe(DANFEClassOwner.ACBrNFe).InutNFe.RetInutNFe;
      CarregaDadosInutilizacao;
    end
    else
      raise EACBrNFeDANFEFR.Create('INUTILIZA��O n�o foi assinalada.');

    Result := frxReport.PrepareReport;
  end
  else
    raise EACBrNFeDANFEFR.Create('Propriedade ACBrNFe n�o assinalada.');

end;

procedure TACBrNFeFRClass.frxReportBeforePrint(Sender: TfrxReportComponent);
var
  qrcode: String;
  CpTituloReport, CpLogomarca, CpDescrProtocolo, CpTotTrib, CpContingencia1, CpContingencia2 : TfrxComponent;
begin

  qrCode := '';
  if Assigned(NFe) then
  begin
    case NFe.Ide.modelo of
      55 :  case FNFe.Ide.tpImp of
              tiSimplificado :
                begin
                  CpTituloReport := frxReport.FindObject('PageHeader1');
                  if Assigned(CpTituloReport) then
                    CpTituloReport.Visible  := ( cdsParametros.FieldByName('Imagem').AsString <> '' );

                  CpLogomarca := frxReport.FindObject('ImgLogo');
                  if Assigned(CpLogomarca) and Assigned(CpTituloReport) then
                    CpLogomarca.Visible := CpTituloReport.Visible;
                end;
            end;

      65 :  begin
              CpTituloReport := frxReport.FindObject('ReportTitle1');
              if Assigned(CpTituloReport) then
                CpTituloReport.Visible := cdsParametros.FieldByName('Imagem').AsString <> '';

              CpLogomarca := frxReport.FindObject('ImgLogo');
              if Assigned(CpLogomarca) and Assigned(CpTituloReport) then
                CpLogomarca.Visible := CpTituloReport.Visible;

              if EstaVazio(Trim(NFe.infNFeSupl.qrCode)) then
                qrcode := TACBrNFe(DANFEClassOwner.ACBrNFe).GetURLQRCode(
                       NFe.ide.cUF,
                       NFe.ide.tpAmb,
                       OnlyNumber(NFe.InfNFe.ID),
                       IfThen(NFe.Dest.idEstrangeiro <> '',NFe.Dest.idEstrangeiro, NFe.Dest.CNPJCPF),
                       NFe.ide.dEmi,
                       NFe.Total.ICMSTot.vNF,
                       NFe.Total.ICMSTot.vICMS,
                       NFe.signature.DigestValue,
                       NFe.infNFe.Versao)
              else
                qrcode := NFe.infNFeSupl.qrCode;

              if Assigned(Sender) and (Sender.Name = 'ImgQrCode') then
                PintarQRCode(qrcode, TfrxPictureView(Sender).Picture);

              CpDescrProtocolo := frxReport.FindObject('Memo25');
              if Assigned(CpDescrProtocolo) then
                CpDescrProtocolo.Visible := cdsParametros.FieldByName('Contingencia_Valor').AsString <> '';

              CpTotTrib := frxReport.FindObject('ValorTributos');
              if Assigned(CpTotTrib) then
                CpTotTrib.Visible := cdsCalculoImposto.FieldByName('VTotTrib').AsFloat > 0;

              // ajusta Informa��o de conting�ncia no NFCe
              CpContingencia1 := frxReport.FindObject('ChildContingenciaCabecalho');
              if Assigned(CpContingencia1) then
                CpContingencia1.Visible := FNFe.Ide.tpEmis <> teNormal;

              CpContingencia2 := frxReport.FindObject('ChildContingenciaIdentificacao');
              if Assigned(CpContingencia2) then
                CpContingencia2.Visible := FNFe.Ide.tpEmis <> teNormal;
            end;
    end;
  end;
end;

procedure TACBrNFeFRClass.frxReportPreview(Sender: TObject);
begin
 frxReport.PreviewForm.BorderIcons := FBorderIcon;
end;

function TACBrNFeFRClass.GetPreparedReport: TfrxReport;
begin

  if EstaVazio(Trim(FFastFile)) then
    Result := nil
  else
  begin
    if PrepareReport(nil) then
      Result := frxReport
    else
      Result := nil;
  end;

end;

function TACBrNFeFRClass.GetPreparedReportEvento: TfrxReport;
begin

  if EstaVazio(Trim(FFastFileEvento)) then
    Result := nil
  else
  begin
    if PrepareReportEvento then
      Result := frxReport
    else
      Result := nil;
  end;

end;

function TACBrNFeFRClass.GetPreparedReportInutilizacao: TfrxReport;
begin

  if EstaVazio(Trim(FFastFileInutilizacao)) then
    Result := nil
  else
  begin
    if PrepareReportInutilizacao then
      Result := frxReport
    else
      Result := nil;
  end;

end;

procedure TACBrNFeFRClass.ImprimirDANFE(ANFE: TNFe);
begin
  if PrepareReport(ANFE) then
  begin
    if DANFEClassOwner.MostraPreview then
      frxReport.ShowPreparedReport
    else
      frxReport.Print;
  end;
end;

procedure TACBrNFeFRClass.ImprimirDANFEPDF(ANFE: TNFe);
const
  TITULO_PDF = 'Nota Fiscal Eletr�nica';
var
	fsShowDialog : Boolean;
begin
  if PrepareReport(ANFE) then
  begin
    frxPDFExport.Author        := DANFEClassOwner.Sistema;
    frxPDFExport.Creator       := DANFEClassOwner.Sistema;
    frxPDFExport.Producer      := DANFEClassOwner.Sistema;
    frxPDFExport.Title         := TITULO_PDF;
    frxPDFExport.Subject       := TITULO_PDF;
    frxPDFExport.Keywords      := TITULO_PDF;
    frxPDFExport.EmbeddedFonts := False;
    frxPDFExport.Background    := False;

    fsShowDialog := frxPDFExport.ShowDialog;
    try
      frxPDFExport.ShowDialog := False;
      frxPDFExport.FileName := PathWithDelim(DANFEClassOwner.PathPDF) +	OnlyNumber(NFe.infNFe.ID) + '-nfe.pdf';

      if not DirectoryExists(ExtractFileDir(frxPDFExport.FileName)) then
        ForceDirectories(ExtractFileDir(frxPDFExport.FileName));

      frxReport.Export(frxPDFExport);
    finally
      frxPDFExport.ShowDialog := fsShowDialog;
    end;
  end
  else
    frxPDFExport.FileName := '';

end;

procedure TACBrNFeFRClass.ImprimirDANFEResumido(ANFE: TNFe);
begin
  if PrepareReport(ANFE) then
  begin
    if DANFEClassOwner.MostraPreview then
      frxReport.ShowPreparedReport
    else
      frxReport.Print;
  end;
end;

procedure TACBrNFeFRClass.ImprimirEVENTO(ANFE: TNFe);
begin
  if PrepareReportEvento then
  begin
    if DANFEClassOwner.MostraPreview then
      frxReport.ShowPreparedReport
    else
      frxReport.Print;
  end;
end;

procedure TACBrNFeFRClass.ImprimirEVENTOPDF(ANFE: TNFe);
const
  TITULO_PDF = 'Eventos Nota Fiscal Eletr�nica';
var
  NomeArq: String;
  fsShowDialog: Boolean;
begin
  if PrepareReportEvento then
  begin
    frxPDFExport.Author   := DANFEClassOwner.Sistema;
    frxPDFExport.Creator  := DANFEClassOwner.Sistema;
    frxPDFExport.Producer := DANFEClassOwner.Sistema;
    frxPDFExport.Title    := TITULO_PDF;
    frxPDFExport.Subject  := TITULO_PDF;
    frxPDFExport.Keywords := TITULO_PDF;

    fsShowDialog := frxPDFExport.ShowDialog;
    try
      frxPDFExport.ShowDialog := False;
      NomeArq := StringReplace(TACBrNFe(DANFEClassOwner.ACBrNFe).EventoNFe.Evento.Items[0].InfEvento.id, 'ID', '', [rfIgnoreCase]);
      frxPDFExport.FileName := PathWithDelim(DANFEClassOwner.PathPDF) + NomeArq + '-procEventoNFe.pdf';

      if not DirectoryExists(ExtractFileDir(frxPDFExport.FileName)) then
        ForceDirectories(ExtractFileDir(frxPDFExport.FileName));

      frxReport.Export(frxPDFExport);
    finally
      frxPDFExport.ShowDialog := fsShowDialog;
    end;
  end
  else
    frxPDFExport.Filename := '';

end;

procedure TACBrNFeFRClass.ImprimirINUTILIZACAO(ANFE: TNFe);
begin
  if PrepareReportInutilizacao then
  begin
    if DANFEClassOwner.MostraPreview then
      frxReport.ShowPreparedReport
    else
      frxReport.Print;
  end;
end;

procedure TACBrNFeFRClass.ImprimirINUTILIZACAOPDF(ANFE: TNFe);
const
  TITULO_PDF = 'Inutiliza��o de Numera��o';
var
  NomeArq: String;
  fsShowDialog: Boolean;
begin
  if PrepareReportInutilizacao then
  begin
    frxPDFExport.Author   := DANFEClassOwner.Sistema;
    frxPDFExport.Creator  := DANFEClassOwner.Sistema;
    frxPDFExport.Producer := DANFEClassOwner.Sistema;
    frxPDFExport.Title    := TITULO_PDF;
    frxPDFExport.Subject  := TITULO_PDF;
    frxPDFExport.Keywords := TITULO_PDF;

    fsShowDialog := frxPDFExport.ShowDialog;
    try
      frxPDFExport.ShowDialog := False;
      NomeArq := OnlyNumber(TACBrNFe(DANFEClassOwner.ACBrNFe).InutNFe.RetInutNFe.Id);
      frxPDFExport.FileName := PathWithDelim(DANFEClassOwner.PathPDF) + NomeArq + '-procInutNFe.pdf';

      if not DirectoryExists(ExtractFileDir(frxPDFExport.FileName)) then
        ForceDirectories(ExtractFileDir(frxPDFExport.FileName));

      frxReport.Export(frxPDFExport);
    finally
      frxPDFExport.ShowDialog := fsShowDialog;
    end;
  end
  else
    frxPDFExport.FileName := '';

end;

end.
