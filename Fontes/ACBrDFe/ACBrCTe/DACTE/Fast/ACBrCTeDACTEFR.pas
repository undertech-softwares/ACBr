{******************************************************************************}
{ Projeto: Componente ACBrCTe                                                  }
{ Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimento}
{ Transporte eletr�nica - CTe - http://www.cte.fazenda.gov.br                  }
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

{ *******************************************************************************
  |* Historico
  |*
  |* 30/03/2011: Jeickson Gobeti
  |*  - Inicio do desenvolvimento Dacte FastReport
  ******************************************************************************* }
{$I ACBr.inc}

unit ACBrCTeDACTEFR;

interface

uses
  SysUtils, Classes, Graphics, ACBrCTeDACTEClass,
  pcteCTe, pcnConversao, frxClass, DBClient, frxDBSet, frxBarcode, frxExportPDF,
  pcteEnvEventoCTe, ACBrCTe, ACBrUtil, StrUtils, DB, MaskUtils;

type
  EACBrCTeDACTEFR = class(Exception);

  TACBrCTeDACTEFR = class(TACBrCTeDACTEClass)
  private
    FDACTEClassOwner: TACBrCTeDACTEClass;
    FCTe            : TCTe;
    FEvento         : TEventoCTe;
    FFastFile       : String;
    FEspessuraBorda : Integer;
    FFastFileEvento : string;

    procedure CriarDataSetsFrx;
    function GetPreparedReport: TfrxReport;
    function GetPreparedReportEvento: TfrxReport;

    procedure SetDataSetsToFrxReport;
    procedure frxReportBeforePrint(Sender: TfrxReportComponent);

    procedure CarregaIdentificacao;
    procedure CarregaTomador;
    procedure CarregaEmitente;
    procedure CarregaRemetente;
    procedure CarregaDestinatario;
    procedure CarregaExpedidor;
    procedure CarregaRecebedor;
    procedure CarregaDadosNotasFiscais;
    procedure CarregaCalculoImposto;
    procedure CarregaParametros;
    procedure CarregaVolumes;
    procedure CarregaComponentesPrestacao;
    procedure CarregaSeguro;
    procedure CarregaModalRodoviario;
    procedure CarregaModalAquaviario;
    procedure CarregaModalAereo;
    procedure CarregaMultiModal;
    procedure CarregaInformacoesAdicionais;
    procedure CarregaDocumentoAnterior;
    procedure CarregaCTeAnuladoComplementado;
    procedure LimpaDados;
  protected
    procedure CarregaDados;
    procedure CarregaDadosEventos;
    function PrepareReport(ACTE: TCTe = nil): Boolean; virtual;
    function PrepareReportEvento: Boolean; virtual;
  public
    frxReport   : TfrxReport;
    frxPDFExport: TfrxPDFExport;
    // CDS
    cdsIdentificacao        : TClientDataSet;
    cdsEmitente             : TClientDataSet;
    cdsDestinatario         : TClientDataSet;
    cdsDadosNotasFiscais    : TClientDataSet;
    cdsParametros           : TClientDataSet;
    cdsInformacoesAdicionais: TClientDataSet;
    cdsVolumes              : TClientDataSet;
    cdsTomador              : TClientDataSet;
    cdsExpedidor            : TClientDataSet;
    cdsRecebedor            : TClientDataSet;
    cdsRemetente            : TClientDataSet;
    cdsCalculoImposto       : TClientDataSet;
    cdsComponentesPrestacao : TClientDataSet;
    cdsSeguro               : TClientDataSet;
    cdsModalRodoviario      : TClientDataSet;
    cdsModalAereo           : TClientDataSet;
    cdsMultiModal           : TClientDataSet;
    cdsModalAquaviario      : TClientDataSet;
    cdsRodoVeiculos         : TClientDataSet;
    cdsRodoValePedagio      : TClientDataSet;
    cdsRodoMotorista        : TClientDataSet;
    cdsDocAnterior          : TClientDataSet;
    cdsAnuladoComple        : TClientDataSet;
    cdsEventos              : TClientDataSet;

    // frxDB
    frxIdentificacao        : TfrxDBDataset;
    frxEmitente             : TfrxDBDataset;
    frxDestinatario         : TfrxDBDataset;
    frxDadosNotasFiscais    : TfrxDBDataset;
    frxParametros           : TfrxDBDataset;
    frxVolumes              : TfrxDBDataset;
    frxInformacoesAdicionais: TfrxDBDataset;
    frxTomador              : TfrxDBDataset;
    frxExpedidor            : TfrxDBDataset;
    frxRecebedor            : TfrxDBDataset;
    frxRemetente            : TfrxDBDataset;
    frxCalculoImposto       : TfrxDBDataset;
    frxComponentesPrestacao : TfrxDBDataset;
    frxSeguro               : TfrxDBDataset;
    frxModalRodoviario      : TfrxDBDataset;
    frxModalAereo           : TfrxDBDataset;
    frxMultiModal           : TfrxDBDataset;
    frxModalAquaviario      : TfrxDBDataset;
    frxRodoVeiculos         : TfrxDBDataset;
    frxRodoValePedagio      : TfrxDBDataset;
    frxRodoMotorista        : TfrxDBDataset;
    frxDocAnterior          : TfrxDBDataset;
    frxAnuladoComple        : TfrxDBDataset;
    frxEventos              : TfrxDBDataset;

    frxBarCodeObject: TfrxBarCodeObject;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDACTE(ACTE: TCTe = nil); override;
    procedure ImprimirDACTEPDF(ACTE: TCTe = nil); override;
    procedure ImprimirEVENTO(ACTE: TCTe = nil); override;
    procedure ImprimirEVENTOPDF(ACTE: TCTe = nil); override;
    property CTE: TCTe read FCTe write FCTe;
    property Evento: TEventoCTe read FEvento write FEvento;
    property DACTEClassOwner: TACBrCTeDACTEClass read FDACTEClassOwner;

  published
    property FastFile            : String read FFastFile write FFastFile;
    property FastFileEvento      : string read FFastFileEvento write FFastFileEvento;
    property EspessuraBorda      : Integer read FEspessuraBorda write FEspessuraBorda;
    property PreparedReport      : TfrxReport read GetPreparedReport;
    property PreparedReportEvento: TfrxReport read GetPreparedReportEvento;
  end;

var
  TipoEvento: TpcnTpEvento;

implementation

uses
  pcteConversaoCTe, ACBrDFeUtil, ACBrValidador;

type
  ArrOfStr     = array of string;
  TSplitResult = array of string;

function SubstrCount(const ASubString, AString: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  i      := 0;
  repeat
    Inc(Result);
    i := PosEx(ASubString, AString, i + 1);
  until i = 0;
end;

function Split(const ADelimiter, AString: string): TSplitResult;
var
  Step                         : ^string;
  Chr                          : PChar;
  iPos, iLast, iDelLen, iLen, x: Integer;
label
  EndLoop;
begin
  SetLength(Result, SubstrCount(ADelimiter, AString) + 1);
  if High(Result) = 0 then
    Result[0] := AString
  else
  begin
    iDelLen := PCardinal(Cardinal(ADelimiter) - SizeOf(Cardinal))^;
    iLen    := PCardinal(Cardinal(AString) - SizeOf(Cardinal))^;
    Step    := @Result[0];
    iLast   := 0;
    iPos    := 0;
    repeat
      if iPos + iDelLen > iLen then
      begin
        if iLast <> iPos then
          iPos := iLen;
      end
      else
        for x := 1 to iDelLen do
          if AString[iPos + x] <> ADelimiter[x] then
            goto EndLoop;

      if iPos - iLast > 0 then
      begin
        SetLength(Step^, iPos - iLast);
        Chr   := PChar(Step^);
        for x := 1 to PCardinal(Cardinal(Step^) - SizeOf(Cardinal))^ do
        begin
          Chr^ := AString[iLast + x];
          Inc(Chr);
        end;
      end
      else
        Step^ := '';

      Cardinal(Step) := Cardinal(Step) + SizeOf(Cardinal);
      iLast          := iPos + iDelLen;

    EndLoop:
      Inc(iPos);
    until iLast >= iLen;
  end;
end;

function Explode(sPart, sInput: string): ArrOfStr;
begin
  while Pos(sPart, sInput) <> 0 do
  begin
    SetLength(Result, Length(Result) + 1);
    Result[Length(Result) - 1] := Copy(sInput, 0, Pos(sPart, sInput) - 1);
    Delete(sInput, 1, Pos(sPart, sInput));
  end;

  SetLength(Result, Length(Result) + 1);
  Result[Length(Result) - 1] := sInput;
end;

function CollateBr(Str: string): string;
var
  Resultado, Temp: string;
  vChar          : Char;
  Tamanho, i     : Integer;
begin
  Result  := '';
  Tamanho := Length(Str);
  i       := 1;
  while i <= Tamanho do
  begin
    Temp  := Copy(Str, i, 1);
    vChar := Temp[1];
    case vChar of
      '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�': Resultado := 'A';
      '�', '�', '�', '�', '�', '�', '�', '�': Resultado                     := 'E';
      '�', '�', '�', '�', '�', '�', '�', '�': Resultado                     := 'I';
      '�', '�', '�', '�', '�', '�', '�', '�', '�', '�': Resultado           := 'O';
      '�', '�', '�', '�', '�', '�', '�', '�': Resultado                     := 'U';
      '�', '�': Resultado                                                   := 'C';
      '�', '�': Resultado                                                   := 'N';
      '�', '�', '�', 'Y': Resultado                                         := 'Y';
    else
      if vChar > #127 then
        Resultado := #32
{$IFDEF DELPHI12_UP}
      else if CharInset(vChar, ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '-', ' ']) then
{$ELSE}
      else if vChar in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '-', ' '] then
{$ENDIF}
        Resultado := UpperCase(vChar);
    end;
    Result := Result + Resultado;
    i      := i + 1;
  end;
end;

constructor TACBrCTeDACTEFR.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDACTEClassOwner := TACBrCTeDACTEClass(Self);
  FFastFile        := '';
  FEspessuraBorda  := 1;
  CriarDataSetsFrx;
  SetDataSetsToFrxReport;
end;

procedure TACBrCTeDACTEFR.CriarDataSetsFrx;
begin
  frxReport := TfrxReport.Create(nil);
  frxReport.EngineOptions.UseGlobalDataSetList := False;
  with frxReport do
  begin
    ScriptLanguage := 'PascalScript';
    StoreInDFM     := False;
    OnBeforePrint  := frxReportBeforePrint;
    OnReportPrint  := 'frxReportOnReportPrint';
  end;

  frxPDFExport := TfrxPDFExport.Create(nil);
  with frxPDFExport do
  begin
    Background     := True;
    PrintOptimized := True;
    Subject        := 'Exportando DACTe para PDF';
  end;
  // CDS
  cdsIdentificacao := TClientDataSet.Create(nil);
  with cdsIdentificacao, FieldDefs do
  begin
    Close;
    Clear;
    Add('Versao', ftString, 4);
    Add('Id', ftString, 44);
    Add('Chave', ftString, 60);
    Add('CUF', ftString, 2);
    Add('CCT', ftString, 9);
    Add('CFOP', ftString, 4);
    Add('NatOp', ftString, 60);
    Add('forPag', ftString, 50);
    Add('Mod_', ftString, 2);
    Add('Serie', ftString, 3);
    Add('NCT', ftString, 11);
    Add('dhEmi', ftDateTime);
    Add('TpImp', ftString, 1);
    Add('TpEmis', ftString, 50);
    Add('CDV', ftString, 1);
    Add('TpAmb', ftString, 1);
    Add('TpCT', ftString, 50);
    Add('ProcEmi', ftString, 1);
    Add('VerProc', ftString, 20);
    Add('cMunEmi', ftString, 7);
    Add('xMunEmi', ftString, 60);
    Add('UFEmi', ftString, 2);
    Add('modal', ftString, 2);
    Add('tpServ', ftString, 50);
    Add('cMunIni', ftString, 7);
    Add('xMunIni', ftString, 60);
    Add('UFIni', ftString, 2);
    Add('cMunFim', ftString, 7);
    Add('xMunFim', ftString, 60);
    Add('UFFim', ftString, 2);
    Add('retira', ftString, 1);
    Add('xDetRetira', ftString, 160);
    Add('toma', ftString, 50);
    CreateDataSet;
  end;

  cdsEmitente := TClientDataSet.Create(nil);
  with cdsEmitente, FieldDefs do
  begin
    Close;
    Clear;
    Add('CNPJ', ftString, 18);
    Add('XNome', ftString, 60);
    Add('XFant', ftString, 60);
    Add('XLgr', ftString, 60);
    Add('Nro', ftString, 60);
    Add('XCpl', ftString, 60);
    Add('XBairro', ftString, 60);
    Add('CMun', ftString, 7);
    Add('XMun', ftString, 60);
    Add('UF', ftString, 2);
    Add('CEP', ftString, 9);
    Add('CPais', ftString, 4);
    Add('XPais', ftString, 60);
    Add('Fone', ftString, 15);
    Add('IE', ftString, 20);
    Add('IM', ftString, 15);
    Add('IEST', ftString, 20);
    Add('CRT', ftString, 1);

    CreateDataSet;
  end;

  cdsDestinatario := TClientDataSet.Create(nil);
  with cdsDestinatario, FieldDefs do
  begin
    Close;
    Clear;
    Add('CNPJCPF', ftString, 18);
    Add('XNome', ftString, 60);
    Add('XLgr', ftString, 60);
    Add('Nro', ftString, 60);
    Add('XCpl', ftString, 60);
    Add('XBairro', ftString, 60);
    Add('CMun', ftString, 7);
    Add('XMun', ftString, 60);
    Add('UF', ftString, 2);
    Add('CEP', ftString, 9);
    Add('CPais', ftString, 4);
    Add('XPais', ftString, 60);
    Add('Fone', ftString, 15);
    Add('IE', ftString, 20);
    Add('ISUF', ftString, 9);

    CreateDataSet;
  end;

  cdsDadosNotasFiscais := TClientDataSet.Create(nil);
  with cdsDadosNotasFiscais, FieldDefs do
  begin
    Close;
    Clear;
    Add('tpDoc'         , ftString,   5); // Tipo Documento
    Add('CNPJCPF'       , ftString,  18); // CNPJCPF
    Add('Serie'         , ftString,   3); // Serie
    Add('ChaveAcesso'   , ftString,  44); // Chave Acesso
    Add('NotaFiscal'    , ftString,   9); // Numero Nota Fiscal
    Add('TextoImpressao', ftString, 100); // Texto Impressao no Relatorio
    CreateDataSet;
  end;

  cdsParametros := TClientDataSet.Create(nil);
  with cdsParametros, FieldDefs do
  begin
    Close;
    Clear;
    Add('ResumoCanhoto', ftString, 200);
    Add('Mensagem0', ftString, 60);
    Add('Versao', ftString, 5);
    Add('Imagem', ftString, 256);
    Add('Sistema', ftString, 60);
    Add('Usuario', ftString, 60);
    Add('Fax', ftString, 60);
    Add('Site', ftString, 60);
    Add('Email', ftString, 60);
    Add('Desconto', ftString, 60);
    Add('ChaveAcesso_Descricao', ftString, 90);
    Add('Contingencia_ID', ftString, 36);
    Add('Contingencia_Descricao', ftString, 60);
    Add('Contingencia_Valor', ftString, 60);
    Add('PrintCanhoto',ftString,1);
    Add('LinhasPorPagina', ftInteger);
    Add('LogoCarregado', ftBlob);

    CreateDataSet;
  end;

  cdsInformacoesAdicionais := TClientDataSet.Create(nil);
  with cdsInformacoesAdicionais, FieldDefs do
  begin
    Close;
    FieldDefs.Clear;
    FieldDefs.Add('OBS', ftString, 2000);
    FieldDefs.Add('infAdFisco', ftString, 2000);
    FieldDefs.Add('ObsCont', ftString, 1800);
    FieldDefs.Add('Fluxo_xOrig', ftString, 15);
    FieldDefs.Add('Fluxo_xDest', ftString, 15);
    FieldDefs.Add('Fluxo_xRota', ftString, 15);

    CreateDataSet;
  end;

  cdsVolumes := TClientDataSet.Create(nil);
  with cdsVolumes, FieldDefs do
  begin
    Close;
    Clear;

    Add('Produto', ftString, 100);
    Add('CaracteristicaCarga', ftString, 100);
    Add('ValorServico', ftFloat);

    Add('DescTipo', ftString, 60);
    Add('UnMedida', ftString, 6);
    Add('QMedida', ftFloat);
    Add('MCub', ftFloat);
    Add('QVol', ftFloat);

    CreateDataSet;
  end;

  cdsTomador := TClientDataSet.Create(nil);
  with cdsTomador, FieldDefs do
  begin
    Close;
    Clear;
    Add('CNPJ', ftString, 18);
    Add('IE', ftString, 20);
    Add('XNome', ftString, 60);
    Add('XFant', ftString, 60);
    Add('Fone', ftString, 15);
    Add('XLgr', ftString, 255);
    Add('Nro', ftString, 60);
    Add('XCpl', ftString, 60);
    Add('XBairro', ftString, 60);
    Add('CMun', ftString, 7);
    Add('XMun', ftString, 60);
    Add('UF', ftString, 2);
    Add('CEP', ftString, 9);
    Add('CPais', ftString, 4);
    Add('XPais', ftString, 60);
    CreateDataSet;
  end;

  cdsExpedidor := TClientDataSet.Create(nil);
  with cdsExpedidor, FieldDefs do
  begin
    Close;
    Clear;
    Add('CNPJ', ftString, 18);
    Add('XNome', ftString, 60);
    Add('XFant', ftString, 60);
    Add('XLgr', ftString, 60);
    Add('Nro', ftString, 60);
    Add('XCpl', ftString, 60);
    Add('XBairro', ftString, 60);
    Add('CMun', ftString, 7);
    Add('XMun', ftString, 60);
    Add('UF', ftString, 2);
    Add('CEP', ftString, 9);
    Add('CPais', ftString, 4);
    Add('XPais', ftString, 60);
    Add('Fone', ftString, 15);
    Add('IE', ftString, 20);
    Add('IM', ftString, 15);
    Add('IEST', ftString, 20);
    Add('CRT', ftString, 1);

    CreateDataSet;
  end;

  cdsRecebedor := TClientDataSet.Create(nil);
  with cdsRecebedor, FieldDefs do
  begin
    Close;
    Clear;
    Add('CNPJ', ftString, 18);
    Add('XNome', ftString, 60);
    Add('XFant', ftString, 60);
    Add('XLgr', ftString, 60);
    Add('Nro', ftString, 60);
    Add('XCpl', ftString, 60);
    Add('XBairro', ftString, 60);
    Add('CMun', ftString, 7);
    Add('XMun', ftString, 60);
    Add('UF', ftString, 2);
    Add('CEP', ftString, 9);
    Add('CPais', ftString, 4);
    Add('XPais', ftString, 60);
    Add('Fone', ftString, 15);
    Add('IE', ftString, 20);
    Add('IM', ftString, 15);
    Add('IEST', ftString, 20);
    Add('CRT', ftString, 1);

    CreateDataSet;

  end;

  cdsRemetente := TClientDataSet.Create(nil);
  with cdsRemetente, FieldDefs do
  begin
    Close;
    Clear;
    Add('CNPJ', ftString, 18);
    Add('XNome', ftString, 60);
    Add('XFant', ftString, 60);
    Add('XLgr', ftString, 60);
    Add('Nro', ftString, 60);
    Add('XCpl', ftString, 60);
    Add('XBairro', ftString, 60);
    Add('CMun', ftString, 7);
    Add('XMun', ftString, 60);
    Add('UF', ftString, 2);
    Add('CEP', ftString, 9);
    Add('CPais', ftString, 4);
    Add('XPais', ftString, 60);
    Add('Fone', ftString, 15);
    Add('IE', ftString, 20);
    Add('IM', ftString, 15);
    Add('IEST', ftString, 20);
    Add('CRT', ftString, 1);

    CreateDataSet;
  end;

  cdsCalculoImposto := TClientDataSet.Create(nil);
  with cdsCalculoImposto, FieldDefs do
  begin
    Close;
    Clear;
    Add('TXTSITTRIB', ftString, 60);
    Add('VBC', ftFloat);
    Add('PICMS', ftFloat);
    Add('VICMS', ftFloat);
    Add('pRedBC', ftFloat);
    Add('VICMSST', ftFloat);
    Add('VCREDITO', ftFloat);
    Add('vIndSN', ftInteger);

    CreateDataSet;
  end;

  cdsComponentesPrestacao := TClientDataSet.Create(nil);
  with cdsComponentesPrestacao, FieldDefs do
  begin
    Close;
    Clear;
    Add('Nome', ftString, 60);
    Add('Valor', ftFloat);
    Add('TotalServico', ftFloat);
    Add('TotalReceber', ftFloat);
    CreateDataSet;
  end;

  cdsSeguro := TClientDataSet.Create(nil);
  with cdsSeguro, FieldDefs do
  begin
    Close;
    Clear;
    Add('RESPONSAVEL', ftString, 60);
    Add('NOMESEGURADORA', ftString, 60);
    Add('NUMEROAPOLICE', ftString, 60);
    Add('NUMEROAVERBACAO', ftString, 60);
    CreateDataSet;
  end;

  cdsModalRodoviario := TClientDataSet.Create(nil);
  with cdsModalRodoviario, FieldDefs do
  begin
    Close;
    Clear;
    Add('RNTRC', ftString, 60);
    Add('DATAPREVISTA', ftString, 60);
    Add('LOTACAO', ftString, 60);
    Add('CIOT', ftString, 12);
    Add('LACRES', ftString, 255);
    CreateDataSet;
  end;

  cdsRodoVeiculos := TClientDataSet.Create(nil);
  with cdsRodoVeiculos, FieldDefs do
  begin
    Close;
    Clear;
    Add('tpVeic', ftString, 10);
    Add('placa', ftString, 7);
    Add('UF', ftString, 2);
    Add('RNTRC', ftString, 8);
    CreateDataSet;
  end;

  cdsRodoValePedagio := TClientDataSet.Create(nil);
  with cdsRodoValePedagio, FieldDefs do
  begin
    Close;
    Clear;
    Add('CNPJPg', ftString, 18);
    Add('CNPJForn', ftString, 18);
    Add('nCompra', ftString, 14);
    Add('vValePed', ftFloat);
    CreateDataSet;
  end;

  cdsRodoMotorista := TClientDataSet.Create(nil);
  with cdsRodoMotorista, FieldDefs do
  begin
    Close;
    Clear;
    Add('xNome', ftString, 60);
    Add('CPF', ftString, 11);
    CreateDataSet;
  end;

  cdsModalAquaviario := TClientDataSet.Create(nil);
  with cdsModalAquaviario, FieldDefs do
  begin
    Close;
    Clear;
    Add('vPrest', ftFloat);
    Add('vAFRMM', ftFloat);
    Add('nBooking', ftString, 10);
    Add('nCtrl', ftString, 10);
    Add('xNavio', ftString, 60);
    Add('nViag', ftInteger);
    Add('direc', ftString, 8);
    Add('prtEmb', ftString, 60);
    Add('prtTrans', ftString, 60);
    Add('prtDest', ftString, 60);
    Add('tpNav', ftString, 10);
    Add('irin', ftString, 10);
    Add('xBalsa', ftString, 190);
    CreateDataSet;
  end;


  cdsModalAereo := TClientDataSet.Create(nil);
  with cdsModalAereo, FieldDefs do
  begin
    Close;
    Clear;
    Add('nMinu', ftInteger);
    Add('nOCA', ftString, 11);
    Add('dPrevAereo', ftDateTime);
    Add('xLAgEmi', ftString, 20);
    Add('IdT', ftString, 14);
    Add('CL', ftString, 1);
    Add('cTar', ftString, 4);
    Add('vTar', ftCurrency);
    Add('xDime', ftString, 14);
    Add('cInfManu', ftInteger);
    Add('cIMP', ftString, 3);
    Add('xOrig',ftString,15);
    Add('xDest',ftString,15);
    Add('xRota',ftString,15);
    CreateDataSet;
  end;

  cdsMultiModal := TClientDataSet.Create(nil);
  with cdsMultiModal, FieldDefs do
  begin
    Close;
    Clear;
    Add('COTM', ftString, 20);
    Add('indNegociavel', ftString, 1);
    CreateDataSet;
  end;

  cdsDocAnterior := TClientDataSet.Create(nil);
  with cdsDocAnterior, FieldDefs do
  begin
    Close;
    Clear;
    Add('CNPJCPF', ftString, 18);
    Add('xNome', ftString, 60);
    Add('UF', ftString, 2);
    Add('IE', ftString, 20);

    Add('Tipo', ftString, 33);
    Add('Serie', ftString, 3);
    Add('nDoc', ftString, 20);
    Add('dEmi', ftString, 10);
    Add('Chave', ftString, 44);
    CreateDataSet;
  end;

  cdsAnuladoComple := TClientDataSet.Create(nil);
  with cdsAnuladoComple, FieldDefs do
  begin
    Close;
    Clear;
    Add('Chave', ftString, 44);
    CreateDataSet;
  end;

  cdsEventos := TClientDataSet.Create(nil);
  with cdsEventos, FieldDefs do
  begin
    Close;
    Clear;
    Add('DescricaoTipoEvento', ftString, 150);
    Add('Modelo', ftString, 2);
    Add('Serie', ftString, 3);
    Add('Numero', ftString, 9);
    Add('MesAno', ftString, 5);
    Add('Barras', ftString, 44);
    Add('ChaveAcesso', ftString, 60);
    Add('cOrgao', ftInteger);
    Add('tpAmb', ftString, 100);
    Add('dhEvento', ftDateTime);
    Add('TipoEvento', ftString, 6);
    Add('DescEvento', ftString, 100);
    Add('nSeqEvento', ftInteger);
    Add('versaoEvento', ftString, 10);
    Add('cStat', ftInteger);
    Add('xMotivo', ftString, 100);
    Add('nProt', ftString, 20);
    Add('dhRegEvento', ftDateTime);
    Add('xJust', ftBlob);
    Add('xCondUso', ftBlob);
    Add('grupoAlterado', ftBlob);
    Add('campoAlterado', ftBlob);
    Add('valorAlterado', ftBlob);
    Add('nroItemAlterado', ftInteger);

    CreateDataSet;
  end;

  // frxDB
  frxIdentificacao := TfrxDBDataset.Create(nil);
  with frxIdentificacao do
  begin
    UserName       := 'Identificacao';
    OpenDataSource := False;
    DataSet        := cdsIdentificacao;
  end;

  frxEmitente := TfrxDBDataset.Create(nil);
  with frxEmitente do
  begin
    UserName       := 'Emitente';
    OpenDataSource := False;
    DataSet        := cdsEmitente;
  end;

  frxDestinatario := TfrxDBDataset.Create(nil);
  with frxDestinatario do
  begin
    UserName       := 'Destinatario';
    OpenDataSource := False;
    DataSet        := cdsDestinatario;
  end;

  frxDadosNotasFiscais := TfrxDBDataset.Create(nil);
  with frxDadosNotasFiscais do
  begin
    UserName       := 'DadosNotasFiscais';
    OpenDataSource := False;
    DataSet        := cdsDadosNotasFiscais;
  end;

  frxParametros := TfrxDBDataset.Create(nil);
  with frxParametros do
  begin
    UserName       := 'Parametros';
    OpenDataSource := False;
    DataSet        := cdsParametros;
  end;

  frxVolumes := TfrxDBDataset.Create(nil);
  with frxVolumes do
  begin
    UserName       := 'Volumes';
    OpenDataSource := False;
    DataSet        := cdsVolumes;
  end;

  frxInformacoesAdicionais := TfrxDBDataset.Create(nil);
  with frxInformacoesAdicionais do
  begin
    UserName       := 'InformacoesAdicionais';
    OpenDataSource := False;
    DataSet        := cdsInformacoesAdicionais;
  end;

  frxTomador := TfrxDBDataset.Create(nil);
  with frxTomador do
  begin
    UserName       := 'Tomador';
    OpenDataSource := False;
    DataSet        := cdsTomador;
  end;

  frxExpedidor := TfrxDBDataset.Create(nil);
  with frxExpedidor do
  begin
    UserName       := 'Expedidor';
    OpenDataSource := False;
    DataSet        := cdsExpedidor;
  end;

  frxRecebedor := TfrxDBDataset.Create(nil);
  with frxRecebedor do
  begin
    UserName       := 'Recebedor';
    OpenDataSource := False;
    DataSet        := cdsRecebedor;
  end;

  frxRemetente := TfrxDBDataset.Create(nil);
  with frxRemetente do
  begin
    UserName       := 'Remetente';
    OpenDataSource := False;
    DataSet        := cdsRemetente;
  end;

  frxCalculoImposto := TfrxDBDataset.Create(nil);
  with frxCalculoImposto do
  begin
    UserName       := 'CalculoImposto';
    OpenDataSource := False;
    DataSet        := cdsCalculoImposto;
  end;

  frxComponentesPrestacao := TfrxDBDataset.Create(nil);
  with frxComponentesPrestacao do
  begin
    UserName       := 'ComponentesPrestacao';
    OpenDataSource := False;
    DataSet        := cdsComponentesPrestacao;
  end;

  frxSeguro := TfrxDBDataset.Create(nil);
  with frxSeguro do
  begin
    UserName       := 'Seguro';
    OpenDataSource := False;
    DataSet        := cdsSeguro;
  end;

  frxModalRodoviario := TfrxDBDataset.Create(nil);
  with frxModalRodoviario do
  begin
    UserName       := 'ModalRodoviario';
    OpenDataSource := False;
    DataSet        := cdsModalRodoviario;
  end;

  frxModalAquaviario := TfrxDBDataset.Create(nil);
  with frxModalAquaviario do
  begin
    UserName       := 'ModalAquaviario';
    OpenDataSource := False;
    DataSet        := cdsModalAquaviario;
  end;

  frxModalAereo := TfrxDBDataset.Create(nil);
  with frxModalAereo do
  begin
    UserName       := 'ModalAereo';
    OpenDataSource := False;
    DataSet := cdsModalAereo;
  end;

  frxMultiModal := TfrxDBDataset.Create(nil);
  with frxMultiModal do
  begin
    UserName       := 'MultiModal';
    OpenDataSource := False;
    DataSet := cdsMultiModal;
  end;

  frxRodoVeiculos := TfrxDBDataset.Create(nil);
  with frxRodoVeiculos do
  begin
    UserName       := 'Veiculos';
    OpenDataSource := False;
    DataSet        := cdsRodoVeiculos;
  end;

  frxRodoValePedagio := TfrxDBDataset.Create(nil);
  with frxRodoValePedagio do
  begin
    UserName       := 'ValePedagio';
    OpenDataSource := False;
    DataSet        := cdsRodoValePedagio;
  end;

  frxRodoMotorista := TfrxDBDataset.Create(nil);
  with frxRodoMotorista do
  begin
    UserName       := 'Motorista';
    OpenDataSource := False;
    DataSet        := cdsRodoMotorista;
  end;

  frxDocAnterior := TfrxDBDataset.Create(nil);
  with frxDocAnterior do
  begin
    UserName       := 'DocAnterior';
    OpenDataSource := False;
    DataSet        := cdsDocAnterior;
  end;

  frxAnuladoComple := TfrxDBDataset.Create(nil);
  with frxAnuladoComple do
  begin
    UserName       := 'AnuladoComple';
    OpenDataSource := False;
    DataSet        := cdsAnuladoComple;
  end;

  frxEventos := TfrxDBDataset.Create(nil);
  with frxEventos do
  begin
    UserName       := 'Eventos';
    OpenDataSource := False;
    DataSet        := cdsEventos;
  end;

  frxBarCodeObject := TfrxBarCodeObject.Create(nil);
end;

destructor TACBrCTeDACTEFR.Destroy;
begin
  frxReport.Free;
  frxPDFExport.Free;
  // CDS
  cdsIdentificacao.Free;
  cdsEmitente.Free;
  cdsDestinatario.Free;
  cdsDadosNotasFiscais.Free;
  cdsParametros.Free;
  cdsInformacoesAdicionais.Free;
  cdsVolumes.Free;
  cdsTomador.Free;
  cdsExpedidor.Free;
  cdsRecebedor.Free;
  cdsRemetente.Free;
  cdsCalculoImposto.Free;
  cdsComponentesPrestacao.Free;
  cdsSeguro.Free;
  cdsModalRodoviario.Free;
  cdsRodoVeiculos.Free;
  cdsRodoValePedagio.Free;
  cdsRodoMotorista.Free;
  cdsModalAquaviario.Free;
  cdsModalAereo.Free;
  cdsMultiModal.Free;
  cdsDocAnterior.Free;
  cdsAnuladoComple.Free;
  cdsEventos.Free;

  // frxDB
  frxIdentificacao.Free;
  frxEmitente.Free;
  frxDestinatario.Free;
  frxDadosNotasFiscais.Free;
  frxParametros.Free;
  frxVolumes.Free;
  frxInformacoesAdicionais.Free;
  frxTomador.Free;
  frxExpedidor.Free;
  frxRecebedor.Free;
  frxRemetente.Free;
  frxCalculoImposto.Free;
  frxComponentesPrestacao.Free;
  frxSeguro.Free;
  frxModalRodoviario.Free;
  frxModalAquaviario.Free;
  frxModalAereo.Free;
  frxMultiModal.Free;
  frxRodoVeiculos.Free;
  frxRodoValePedagio.Free;
  frxRodoMotorista.Free;
  frxDocAnterior.Free;
  frxAnuladoComple.Free;
  frxEventos.Free;
  frxBarCodeObject.Free;

  inherited Destroy;
end;

procedure TACBrCTeDACTEFR.frxReportBeforePrint(Sender: TfrxReportComponent);
var
  Child     : TfrxChild;
  DetailData: TfrxDetailData;
  Memo      : TfrxMemoView;
  Shape     : TfrxShapeView;
begin
  case TipoEvento of
    teCCe:
      begin
        // Esconde ChildJustificativa
        Memo := frxReport.FindObject('JustTit') as TfrxMemoView;
        if Memo <> nil then
        begin
          Memo.Visible := False;
        end;
        Memo := frxReport.FindObject('JustDesc') as TfrxMemoView;
        if Memo <> nil then
        begin
          Memo.Visible := False;
        end;
        Shape := frxReport.FindObject('ShapeJust') as TfrxShapeView;
        if Shape <> nil then
        begin
          Shape.Visible := False;
        end;
        Child := frxReport.FindObject('ChildJustificativa') as TfrxChild;
        if Child <> nil then
        begin
          Child.Height := 0;
        end;
      end;
    teCancelamento:
      begin
        // Esconde ChildCondUso
        Child := frxReport.FindObject('ChildCondUso') as TfrxChild;
        if Child <> nil then
        begin
          Child.Visible := False;
        end;

        // Esconde ChildCorrecao
        Child := frxReport.FindObject('ChildCorrecao') as TfrxChild;
        if Child <> nil then
        begin
          Child.Visible := False;
        end;

        // Esconde DetailData1
        DetailData := frxReport.FindObject('DetailData1') as TfrxDetailData;
        if DetailData <> nil then
        begin
          DetailData.Visible := False;
        end;
      end;
  end;
end;

function TACBrCTeDACTEFR.GetPreparedReport: TfrxReport;
begin
  if Trim(FFastFile) = '' then
    Result := nil
  else
  begin
    if PrepareReport(nil) then
      Result := frxReport
    else
      Result := nil;
  end;
end;

function TACBrCTeDACTEFR.GetPreparedReportEvento: TfrxReport;
begin
  if Trim(FFastFileEvento) = '' then
    Result := nil
  else
  begin
    if PrepareReportEvento then
      Result := frxReport
    else
      Result := nil;
  end;
end;

procedure TACBrCTeDACTEFR.ImprimirDACTE(ACTE: TCTe);
begin
  if PrepareReport(ACTE) then
  begin
    frxReport.PrintOptions.Copies := NumCopias;
    if MostrarPreview then
      frxReport.ShowPreparedReport
    else
    begin
      // frxReport.PrepareReport(false);
      if MostrarStatus then
        frxReport.PrintOptions.ShowDialog := True
      else
        frxReport.PrintOptions.ShowDialog := False;
      frxReport.PrintOptions.Printer      := Impressora;
      frxReport.Print;
    end;
  end;
end;

procedure TACBrCTeDACTEFR.ImprimirDACTEPDF(ACTE: TCTe);
const
  TITULO_PDF = 'Conhecimento de Transporte Eletr�nico';
var
  i            : Integer;
  OldShowDialog: Boolean;
begin
  if PrepareReport(ACTE) then
  begin
    frxPDFExport.Author   := Sistema;
    frxPDFExport.Creator  := Sistema;
    frxPDFExport.Producer := Sistema;
    frxPDFExport.Title    := TITULO_PDF;
    frxPDFExport.Subject  := TITULO_PDF;
    frxPDFExport.Keywords := TITULO_PDF;
    OldShowDialog         := frxPDFExport.ShowDialog;
    try
      frxPDFExport.ShowDialog := False;

      for i := 0 to TACBrCTe(ACBrCTe).Conhecimentos.Count - 1 do
      begin
        frxPDFExport.FileName := IncludeTrailingPathDelimiter(PathPDF) + OnlyNumber(CTE.infCTe.Id) + '-cte.pdf';

        if not DirectoryExists(ExtractFileDir(frxPDFExport.FileName)) then
          ForceDirectories(ExtractFileDir(frxPDFExport.FileName));
        frxReport.Export(frxPDFExport);
      end;
    finally
      frxPDFExport.ShowDialog := OldShowDialog;
    end;
  end;
end;

procedure TACBrCTeDACTEFR.ImprimirEVENTO(ACTE: TCTe);
begin
  if PrepareReportEvento then
  begin
    if MostrarPreview then
      frxReport.ShowPreparedReport
    else
      frxReport.Print;
  end;
end;

procedure TACBrCTeDACTEFR.ImprimirEVENTOPDF(ACTE: TCTe);
const
  TITULO_PDF = 'Conhecimento de Transporte Eletr�nico - Evento';
var
  NomeArq      : String;
  OldShowDialog: Boolean;
begin
  if PrepareReportEvento then
  begin
    frxPDFExport.Author   := Sistema;
    frxPDFExport.Creator  := Sistema;
    frxPDFExport.Producer := Sistema;
    frxPDFExport.Title    := TITULO_PDF;
    frxPDFExport.Subject  := TITULO_PDF;
    frxPDFExport.Keywords := TITULO_PDF;
    OldShowDialog         := frxPDFExport.ShowDialog;
    try
      frxPDFExport.ShowDialog := False;
      NomeArq                 := StringReplace(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[0].InfEvento.Id, 'ID', '', [rfIgnoreCase]);
      frxPDFExport.FileName   := IncludeTrailingPathDelimiter(PathPDF) + NomeArq + '-procEventoCTe.pdf';

      if not DirectoryExists(ExtractFileDir(frxPDFExport.FileName)) then
        ForceDirectories(ExtractFileDir(frxPDFExport.FileName));

      frxReport.Export(frxPDFExport);
    finally
      frxPDFExport.ShowDialog := OldShowDialog;
    end;
  end;
end;

procedure TACBrCTeDACTEFR.LimpaDados;
begin
  cdsIdentificacao.EmptyDataSet;
  cdsEmitente.EmptyDataSet;
  cdsDestinatario.EmptyDataSet;
  cdsDadosNotasFiscais.EmptyDataSet;
  cdsParametros.EmptyDataSet;
  cdsInformacoesAdicionais.EmptyDataSet;
  cdsVolumes.EmptyDataSet;
  cdsTomador.EmptyDataSet;
  cdsExpedidor.EmptyDataSet;
  cdsRecebedor.EmptyDataSet;
  cdsRemetente.EmptyDataSet;
  cdsCalculoImposto.EmptyDataSet;
  cdsComponentesPrestacao.EmptyDataSet;
  cdsSeguro.EmptyDataSet;
  cdsModalRodoviario.EmptyDataSet;
  cdsRodoVeiculos.EmptyDataSet;
  cdsRodoValePedagio.EmptyDataSet;
  cdsRodoMotorista.EmptyDataSet;
  cdsModalAereo.EmptyDataSet;
  cdsMultiModal.EmptyDataSet;
  cdsModalAquaviario.EmptyDataSet;
  cdsDocAnterior.EmptyDataSet;
  cdsAnuladoComple.EmptyDataSet;
  cdsEventos.EmptyDataSet;
end;

function TACBrCTeDACTEFR.PrepareReport(ACTE: TCTe): Boolean;
var
  i: Integer;
begin
  Result := False;

  if Trim(FastFile) <> '' then
  begin
    if FileExists(FastFile) then
      frxReport.LoadFromFile(FastFile)
    else
      raise EACBrCTeDACTEFR.CreateFmt('Caminho do arquivo de impress�o do DACTE "%s" inv�lido.', [FastFile]);
  end
  else
    raise EACBrCTeDACTEFR.Create('Caminho do arquivo de impress�o do DACTE n�o assinalado.');

  if Assigned(ACTE) then
  begin
    FCTe := ACTE;
    CarregaDados;
    Result := frxReport.PrepareReport;
  end
  else
  begin
    if Assigned(ACBrCTe) then
    begin
      for i := 0 to TACBrCTe(ACBrCTe).Conhecimentos.Count - 1 do
      begin
        FCTe := TACBrCTe(ACBrCTe).Conhecimentos.Items[i].CTE;
        CarregaDados;

        if (i > 0) then
          Result := frxReport.PrepareReport(False)
        else
          Result := frxReport.PrepareReport;
      end;
    end
    else
      raise EACBrCTeDACTEFR.Create('Propriedade ACBrCTe n�o assinalada.');
  end;
end;

function TACBrCTeDACTEFR.PrepareReportEvento: Boolean;
begin
  if Trim(FastFileEvento) <> '' then
  begin
    if FileExists(FastFileEvento) then
      frxReport.LoadFromFile(FastFileEvento)
    else
      raise EACBrCTeDACTEFR.CreateFmt('Caminho do arquivo de impress�o do EVENTO "%s" inv�lido.', [FastFileEvento]);
  end
  else
    raise EACBrCTeDACTEFR.Create('Caminho do arquivo de impress�o do EVENTO n�o assinalado.');

  frxReport.PrintOptions.Copies := NumCopias;

  // preparar relatorio
  if Assigned(ACBrCTe) then
  begin
    if TACBrCTe(ACBrCTe).Conhecimentos.Count > 0 then
    begin
      FCTe := TACBrCTe(ACBrCTe).Conhecimentos.Items[0].CTE;
      CarregaDados;
    end;
    if Assigned(TACBrCTe(ACBrCTe).EventoCTe) then
    begin
      Evento := TACBrCTe(ACBrCTe).EventoCTe;
      CarregaDadosEventos;
    end
    else
      raise EACBrCTeDACTEFR.Create('Evento n�o foi assinalado.');


    Result := frxReport.PrepareReport;
  end
  else
    raise EACBrCTeDACTEFR.Create('Propriedade ACBrNFe n�o assinalada.');
end;

procedure TACBrCTeDACTEFR.SetDataSetsToFrxReport;
begin
  frxReport.DataSets.Clear;
  with frxReport.EnabledDataSets do
  begin
    Clear;
    Add(frxIdentificacao);
    Add(frxEmitente);
    Add(frxDestinatario);
    Add(frxDadosNotasFiscais);
    Add(frxParametros);
    Add(frxVolumes);
    Add(frxInformacoesAdicionais);
    Add(frxTomador);
    Add(frxExpedidor);
    Add(frxRecebedor);
    Add(frxRemetente);
    Add(frxCalculoImposto);
    Add(frxComponentesPrestacao);
    Add(frxSeguro);
    Add(frxModalRodoviario);
    Add(frxModalAquaviario);
    Add(frxModalAereo);
    Add(frxMultiModal);
    Add(frxRodoVeiculos);
    Add(frxRodoValePedagio);
    Add(frxRodoMotorista);
    Add(frxDocAnterior);
    Add(frxAnuladoComple);
    Add(frxEventos);
  end;
end;

procedure TACBrCTeDACTEFR.CarregaCalculoImposto;
begin
  with cdsCalculoImposto do
  begin

    Append;

{$IFDEF PL_103}
    case FCTe.Imp.ICMS.SituTrib of
      cst00:
        begin
          FieldByName('TXTSITTRIB').AsString := CSTICMSToStrTagPosText(cst00);
          FieldByName('vBC').AsFloat         := FCTe.Imp.ICMS.cst00.vBC;
          FieldByName('pICMS').AsFloat       := FCTe.Imp.ICMS.cst00.pICMS;
          FieldByName('vICMS').AsFloat       := FCTe.Imp.ICMS.cst00.VICMS;
        end;
      cst45:
        begin
          FieldByName('TXTSITTRIB').AsString := CSTICMSToStrTagPosText(cst45);
        end;
    end;
    // {$ENDIF}
    // {$IFDEF PL_104}
{$ELSE}
    case FCTe.Imp.ICMS.SituTrib of
      cst00:
        begin
          FieldByName('TXTSITTRIB').AsString := CSTICMSToStrTagPosText(cst00);
          FieldByName('vBC').AsFloat         := FCTe.Imp.ICMS.ICMS00.vBC;
          FieldByName('pICMS').AsFloat       := FCTe.Imp.ICMS.ICMS00.pICMS;
          FieldByName('vICMS').AsFloat       := FCTe.Imp.ICMS.ICMS00.VICMS;
        end;
      cst20:
        begin
          FieldByName('TXTSITTRIB').AsString := CSTICMSToStrTagPosText(cst20);
          FieldByName('pRedBC').AsFloat      := FCTe.Imp.ICMS.ICMS20.pRedBC;
          FieldByName('vBC').AsFloat         := FCTe.Imp.ICMS.ICMS20.vBC;
          FieldByName('pICMS').AsFloat       := FCTe.Imp.ICMS.ICMS20.pICMS;
          FieldByName('vICMS').AsFloat       := FCTe.Imp.ICMS.ICMS20.VICMS;
        end;
      cst40:
        begin
          FieldByName('TXTSITTRIB').AsString := CSTICMSToStrTagPosText(cst40);
        end;
      cst41:
        begin
          FieldByName('TXTSITTRIB').AsString := CSTICMSToStrTagPosText(cst41);
        end;

      cst45:
        begin
          FieldByName('TXTSITTRIB').AsString := CSTICMSToStrTagPosText(cst45);
        end;

      cst51:
        begin
          FieldByName('TXTSITTRIB').AsString := CSTICMSToStrTagPosText(cst51);
        end;

      cst60:
        begin
          FieldByName('TXTSITTRIB').AsString := CSTICMSToStrTagPosText(cst60);
          FieldByName('vBC').AsFloat         := FCTe.Imp.ICMS.ICMS60.vBCSTRet;
          FieldByName('pICMS').AsFloat       := FCTe.Imp.ICMS.ICMS60.pICMSSTRet;
          FieldByName('vICMS').AsFloat       := FCTe.Imp.ICMS.ICMS60.vICMSSTRet;
          FieldByName('vCredito').AsFloat    := FCTe.Imp.ICMS.ICMS60.vCred;
        end;
      cst90:
        begin
          FieldByName('TXTSITTRIB').AsString := CSTICMSToStrTagPosText(cst90);
          FieldByName('pRedBC').AsFloat      := FCTe.Imp.ICMS.ICMS90.pRedBC;
          FieldByName('vBC').AsFloat         := FCTe.Imp.ICMS.ICMS90.vBC;
          FieldByName('pICMS').AsFloat    := FCTe.Imp.ICMS.ICMS90.pICMS;
          FieldByName('vICMS').AsFloat    := FCTe.Imp.ICMS.ICMS90.VICMS;
          FieldByName('vCredito').AsFloat := FCTe.Imp.ICMS.ICMS90.vCred;
        end;
      cstICMSOutraUF:
        begin
          FieldByName('TXTSITTRIB').AsString := CSTICMSToStrTagPosText(cstICMSOutraUF);
          FieldByName('pRedBC').AsFloat      := FCTe.Imp.ICMS.ICMSOutraUF.pRedBCOutraUF;
          FieldByName('vBC').AsFloat         := FCTe.Imp.ICMS.ICMSOutraUF.vBCOutraUF;
          FieldByName('pICMS').AsFloat       := FCTe.Imp.ICMS.ICMSOutraUF.pICMSOutraUF; // pRedBCOutraUF;
          FieldByName('vICMS').AsFloat       := FCTe.Imp.ICMS.ICMSOutraUF.vICMSOutraUF;
        end;
      cstICMSSN:
        begin
          FieldByName('TXTSITTRIB').AsString := CSTICMSToStrTagPosText(cstICMSSN);
          FieldByName('vIndSN').AsFloat      := FCTe.Imp.ICMS.ICMSSN.indSN;
        end;
    end;
{$ENDIF}
    Post;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaComponentesPrestacao;
var
  i: Integer;
begin
  with cdsComponentesPrestacao do
  begin

    if CTE.vPrest.comp.Count > 0 then
    begin
      for i := 0 to CTE.vPrest.comp.Count - 1 do
      begin
        Append;
        FieldByName('Nome').AsString        := CTE.vPrest.comp.Items[i].xNome;
        FieldByName('Valor').AsFloat        := CTE.vPrest.comp.Items[i].vComp;
        FieldByName('TotalServico').AsFloat := CTE.vPrest.vTPrest;
        FieldByName('TotalReceber').AsFloat := CTE.vPrest.vRec;
        Post;
      end;
    end
    else
    begin
      Append;
      FieldByName('Nome').AsString        := '';
      FieldByName('Valor').AsFloat        := 0;
      FieldByName('TotalServico').AsFloat := CTE.vPrest.vTPrest;
      FieldByName('TotalReceber').AsFloat := CTE.vPrest.vRec;
      Post;
    end;
  end;

end;

procedure TACBrCTeDACTEFR.CarregaCTeAnuladoComplementado;
begin
  with cdsAnuladoComple do
  begin

    Append;
{$IFDEF PL_200}
    if CTE.ide.tpCTe = tcComplemento then
      FieldByName('Chave').AsString := CTE.infCteComp.chave
    else if CTE.ide.tpCTe = tcAnulacao then
      FieldByName('Chave').AsString := CTE.infCteAnu.chCTe;
{$ELSE}
    if CTE.ide.tpCTe = tcComplemento then
    begin
      if CTE.infCteComp.Count >= 1 then
        FieldByName('Chave').AsString := CTE.infCteComp.Items[0].chave;
    end
    else
      if CTE.ide.tpCTe = tcAnulacao then
      FieldByName('Chave').AsString := CTE.InfCTeAnuEnt.chCTe;
{$ENDIF}
    Post;
  end;

end;

procedure TACBrCTeDACTEFR.CarregaDados;
begin
  LimpaDados;

  CarregaIdentificacao;
  CarregaTomador;
  CarregaEmitente;
  CarregaRemetente;
  CarregaDestinatario;
  CarregaExpedidor;
  CarregaRecebedor;
  CarregaDadosNotasFiscais;
  CarregaParametros;
  CarregaCalculoImposto;
  CarregaVolumes;
  CarregaComponentesPrestacao;
  CarregaInformacoesAdicionais;
  CarregaSeguro;
  CarregaModalRodoviario;
  CarregaModalAereo;
  CarregaMultiModal;
  CarregaModalAquaviario;
  CarregaDocumentoAnterior;
  CarregaCTeAnuladoComplementado;
end;

procedure TACBrCTeDACTEFR.CarregaDadosEventos;
  Function MantertpAmb( s : TpcnTipoAmbiente ) : String;
  begin
    case s of
      taProducao    : Result := 'PRODU��O';
      taHomologacao : Result := 'HOMOLOGA��O - SEM VALOR FISCAL';
    end;
  end;
var
  i: Integer;
  J: Integer;
begin
  with cdsEventos do
  begin
    EmptyDataSet;
    for i := 0 to FEvento.Evento.Count - 1 do
    begin
      with Evento.Evento[i] do
      begin
        case Evento.Evento[i].InfEvento.tpEvento of
          teCancelamento:
            begin
              TipoEvento := teCancelamento;
              Append;
              FieldByName('DescricaoTipoEvento').AsString := InfEvento.DescricaoTipoEvento(InfEvento.tpEvento);
              FieldByName('Modelo').AsString              := Copy(InfEvento.chCTe, 21, 2);
              FieldByName('Serie').AsString               := Copy(InfEvento.chCTe, 23, 3);
              FieldByName('Numero').AsString              := Copy(InfEvento.chCTe, 26, 9);
              FieldByName('MesAno').AsString              := Copy(InfEvento.chCTe, 05, 2) + '/' + Copy(InfEvento.chCTe, 03, 2);
              FieldByName('Barras').AsString              := InfEvento.chCTe;
              FieldByName('ChaveAcesso').AsString         := FormatarChaveAcesso(InfEvento.chCTe);
              FieldByName('cOrgao').AsInteger             := InfEvento.cOrgao;
              FieldByName('nSeqEvento').AsInteger         := InfEvento.nSeqEvento;
              FieldByName('tpAmb').AsString               := MantertpAmb( InfEvento.tpAmb );
              FieldByName('dhEvento').AsDateTime          := InfEvento.dhEvento;
              FieldByName('TipoEvento').AsString          := InfEvento.TipoEvento;
              FieldByName('DescEvento').AsString          := InfEvento.DescEvento;
              FieldByName('versaoEvento').AsString        := InfEvento.versaoEvento;
              FieldByName('cStat').AsInteger              := RetInfEvento.cStat;
              FieldByName('xMotivo').AsString             := RetInfEvento.xMotivo;
              FieldByName('nProt').AsString               := RetInfEvento.nProt;
              FieldByName('dhRegEvento').AsDateTime       := RetInfEvento.dhRegEvento;
              FieldByName('xJust').AsString               := 'Protocolo do CTe Cancelado:' + InfEvento.detEvento.nProt +sLineBreak+InfEvento.detEvento.xJust;
              FieldByName('xCondUso').AsString            := InfEvento.detEvento.xCondUso;
              frxReport.Variables['HOMOLOGACAO']          := ( InfEvento.tpAmb = taHomologacao);
              Post;
            end;
          teCCe:
            begin
              TipoEvento := teCCe;
              for J := 0 to InfEvento.detEvento.infCorrecao.Count - 1 do
              begin
                Append;
                FieldByName('DescricaoTipoEvento').AsString := InfEvento.DescricaoTipoEvento(InfEvento.tpEvento);
                FieldByName('Modelo').AsString              := Copy(InfEvento.chCTe, 21, 2);
                FieldByName('Serie').AsString               := Copy(InfEvento.chCTe, 23, 3);
                FieldByName('Numero').AsString              := Copy(InfEvento.chCTe, 26, 9);
                FieldByName('MesAno').AsString              := Copy(InfEvento.chCTe, 05, 2) + '/' + Copy(InfEvento.chCTe, 03, 2);
                FieldByName('Barras').AsString              := InfEvento.chCTe;
                FieldByName('ChaveAcesso').AsString         := FormatarChaveAcesso(InfEvento.chCTe);
                FieldByName('cOrgao').AsInteger             := InfEvento.cOrgao;
                FieldByName('nSeqEvento').AsInteger         := InfEvento.nSeqEvento;
                FieldByName('tpAmb').AsString               := MantertpAmb( InfEvento.tpAmb );
                FieldByName('dhEvento').AsDateTime          := InfEvento.dhEvento;
                FieldByName('TipoEvento').AsString          := InfEvento.TipoEvento;
                FieldByName('DescEvento').AsString          := InfEvento.DescEvento;
                FieldByName('versaoEvento').AsString        := InfEvento.versaoEvento;
                FieldByName('cStat').AsInteger              := RetInfEvento.cStat;
                FieldByName('xMotivo').AsString             := RetInfEvento.xMotivo;
                FieldByName('nProt').AsString               := RetInfEvento.nProt;
                FieldByName('dhRegEvento').AsDateTime       := RetInfEvento.dhRegEvento;
                FieldByName('xJust').AsString               := InfEvento.detEvento.xJust;
                FieldByName('xCondUso').AsString            := InfEvento.detEvento.xCondUso;
                frxReport.Variables['HOMOLOGACAO']          := ( InfEvento.tpAmb = taHomologacao);

                with InfEvento.detEvento.infCorrecao.Items[J] do
                begin
                  FieldByName('grupoAlterado').AsString    := grupoAlterado;
                  FieldByName('campoAlterado').AsString    := campoAlterado;
                  FieldByName('valorAlterado').AsString    := valorAlterado;
                  FieldByName('nroItemAlterado').AsInteger := nroItemAlterado;
                end;

                Post;
              end;
            end;
        end;
      end;
    end;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaDadosNotasFiscais;
var
  i       : Integer;
  DoctoRem: string;
  NroNota : Integer;
begin
  { dados das Notas Fiscais }
  DoctoRem := FCTe.Rem.CNPJCPF;
  if Length(DoctoRem) > 11 then
    DoctoRem := FormatMaskText('##.###.###\/####-##;0;_', DoctoRem)
  else
    DoctoRem := FormatMaskText('###.###.###-##;0;_', DoctoRem);

  with cdsDadosNotasFiscais do
  begin

{$IFDEF PL_200}
    for i := 0 to CTE.infCTeNorm.infDoc.infNF.Count - 1 do
    begin
      with FCTe.infCTeNorm.infDoc.infNF.Items[i] do
{$ELSE}
    for i := 0 to CTE.Rem.infNF.Count - 1 do
    begin
      with FCTe.Rem.infNF.Items[i] do
{$ENDIF}
      begin
        Append;
        FieldByName('tpDoc').AsString       := 'NF';
        FieldByName('CNPJCPF').AsString     := FCTe.Rem.CNPJCPF;
        FieldByName('Serie').AsString       := serie;
        FieldByName('ChaveAcesso').AsString := '';
        FieldByName('NotaFiscal').AsString  := nDoc;
        FieldByName('TextoImpressao').AsString := 'NF                  ' + DoctoRem + '                                        ' +
          serie + '  /  ' + FormatFloat('000000000', StrToInt(nDoc));
      end;
      Post;
    end;

{$IFDEF PL_200}
    for i := 0 to CTE.infCTeNorm.infDoc.InfNFE.Count - 1 do
    begin
      with FCTe.infCTeNorm.infDoc.InfNFE.Items[i] do
{$ELSE}
    for i := 0 to CTE.Rem.InfNFE.Count - 1 do
    begin
      with FCTe.Rem.InfNFE.Items[i] do
{$ENDIF}
      begin
        Append;
        FieldByName('tpDoc').AsString       := 'NFe';
        FieldByName('CNPJCPF').AsString     := FCTe.Rem.CNPJCPF;
        FieldByName('Serie').AsString       := Copy(chave, 23, 3);
        FieldByName('ChaveAcesso').AsString := chave;
        FieldByName('NotaFiscal').AsString  := Copy(chave, 26, 9);
        NroNota                             := StrToInt(Copy(chave, 26, 9));
        FieldByName('TextoImpressao').AsString := 'NF-e ' + FormatFloat('000000000', NroNota) + '      ' + chave;
      end;
      Post;
    end;

{$IFDEF PL_200}
    for i := 0 to CTE.infCTeNorm.infDoc.infOutros.Count - 1 do
    begin
      with FCTe.infCTeNorm.infDoc.infOutros.Items[i] do
{$ELSE}
    for i := 0 to CTE.Rem.infOutros.Count - 1 do
    begin
      with FCTe.Rem.infOutros.Items[i] do
{$ENDIF}
      begin
        Append;
        FieldByName('tpDoc').AsString       := 'Outros';
        FieldByName('CNPJCPF').AsString     := FCTe.Rem.CNPJCPF;
        FieldByName('Serie').AsString       := '';
        FieldByName('ChaveAcesso').AsString := '';
        FieldByName('NotaFiscal').AsString  := '';

        case tpDoc of
          tdDeclaracao: FieldByName('TextoImpressao').AsString := 'Declara��o          ' + DoctoRem + '                                        ' + nDoc;
          tdOutros    : FieldByName('TextoImpressao').AsString := 'Outros              ' + DoctoRem + '                                        ' + nDoc;
          tdDutoviario: FieldByName('TextoImpressao').AsString := 'Dutovi�rio          ' + DoctoRem + '                                        ' + nDoc;
        else
          FieldByName('TextoImpressao').AsString := 'N�o informado       ' + DoctoRem + '                                        ' + nDoc;
        end;
      end;
      Post;
    end;

    //
    cdsDadosNotasFiscais.RecordCount;
  end;

end;

procedure TACBrCTeDACTEFR.CarregaDestinatario;
begin
  { destinat�rio }
  with cdsDestinatario do
  begin

    Append;

    with FCTe.Dest do
    begin
      FieldByName('CNPJCPF').AsString := FormatarCNPJouCPF(CNPJCPF);
      FieldByName('XNome').AsString   := xNome;
      with EnderDest do
      begin
        FieldByName('XLgr').AsString    := XLgr;
        FieldByName('Nro').AsString     := Nro;
        FieldByName('XCpl').AsString    := XCpl;
        FieldByName('XBairro').AsString := XBairro;
        FieldByName('CMun').AsString    := IntToStr(CMun);
        FieldByName('XMun').AsString    := CollateBr(XMun);
        FieldByName('UF').AsString      := UF;
        FieldByName('CEP').AsString     := FormatarCEP(Poem_Zeros(CEP, 8));
        FieldByName('CPais').AsString   := IntToStr(CPais);
        FieldByName('XPais').AsString   := XPais;
        FieldByName('Fone').AsString    := FormatarFone(Fone);
      end;
      FieldByName('IE').AsString   := IE;
      FieldByName('ISUF').AsString := ISUF;
    end;
    Post;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaDocumentoAnterior;
var
  i, ii, iii: Integer;
begin
  with cdsDocAnterior do
  begin

{$IFDEF PL_200}
    for i := 0 to CTE.infCTeNorm.docAnt.emiDocAnt.Count - 1 do
    begin
      with CTE.infCTeNorm.docAnt.emiDocAnt.Items[i] do
      begin
{$ELSE}
    for i := 0 to CTE.infCTeNorm.emiDocAnt.Count - 1 do
    begin
      with CTE.infCTeNorm.emiDocAnt.Items[i] do
      begin
{$ENDIF}
        for ii := 0 to idDocAnt.Count - 1 do
        begin
          for iii := 0 to idDocAnt.Items[ii].idDocAntPap.Count - 1 do
          begin
            with idDocAnt.Items[ii].idDocAntPap.Items[iii] do
            begin
              Append;
              FieldByName('CNPJCPF').AsString := CNPJCPF;
              FieldByName('IE').AsString      := IE;
              FieldByName('xNome').AsString   := xNome;
              FieldByName('UF').AsString      := UF;
              case tpDoc of
                daCTRC  : FieldByName('Tipo').AsString  := 'CTRC';
                daCTAC  : FieldByName('Tipo').AsString  := 'CTAC';
                daACT   : FieldByName('Tipo').AsString  := 'ACT';
                daNF7   : FieldByName('Tipo').AsString  := 'NF 7';
                daNF27  : FieldByName('Tipo').AsString  := 'NF 27';
                daCAN   : FieldByName('Tipo').AsString  := 'CAN';
                daCTMC  : FieldByName('Tipo').AsString  := 'CTMC';
                daATRE  : FieldByName('Tipo').AsString  := 'ATRE';
                daDTA   : FieldByName('Tipo').AsString  := 'DTA';
                daCAI   : FieldByName('Tipo').AsString  := 'CAI';
                daCCPI  : FieldByName('Tipo').AsString  := 'CCPI';
                daCA    : FieldByName('Tipo').AsString  := 'CA';
                daTIF   : FieldByName('Tipo').AsString  := 'TIF';
                daOutros: FieldByName('Tipo').AsString  := 'OUTROS';
              end;
              FieldByName('Serie').AsString := idDocAnt.Items[ii].idDocAntPap.Items[iii].serie;
              FieldByName('nDoc').AsString  := IntToStr(idDocAnt.Items[ii].idDocAntPap.Items[iii].nDoc);
              FieldByName('dEmi').AsString  := FormatDateTime('dd/mm/yyyy', idDocAnt.Items[ii].idDocAntPap.Items[iii].dEmi);
            end;
            Post;
          end;
          for iii := 0 to idDocAnt.Items[ii].idDocAntEle.Count - 1 do
          begin
            Append;
            FieldByName('CNPJCPF').AsString := CNPJCPF;
            FieldByName('xNome').AsString   := xNome;
            FieldByName('UF').AsString      := UF;
            with idDocAnt.Items[ii].idDocAntEle.Items[iii] do
            begin
              FieldByName('Tipo').AsString  := 'CT-e';
              FieldByName('Chave').AsString := chave;
              FieldByName('Serie').AsString := Copy(chave, 23, 3);
              FieldByName('nDoc').AsString  := Copy(chave, 26, 9);
              FieldByName('dEmi').AsString  := Copy(chave, 5, 2) + '/' + Copy(chave, 3, 2);
            end;
            Post;
          end;
        end;
      end;
    end;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaEmitente;
begin
  { emitente }
  with cdsEmitente do
  begin
    Append;
    with FCTe.Emit do
    begin
      FieldByName('CNPJ').AsString  := FormatarCNPJouCPF(CNPJ);
      FieldByName('XNome').AsString := xNome;
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
        FieldByName('CEP').AsString     := FormatarCEP(Poem_Zeros(CEP, 8));
        FieldByName('Fone').AsString    := FormatarFone(Fone);
      end;
      FieldByName('IE').AsString := IE;
    end;

    Post;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaExpedidor;
begin
  { Expedidor }
  with cdsExpedidor do
  begin
    Append;
    with FCTe.Exped do
    begin
      FieldByName('CNPJ').AsString  := FormatarCNPJouCPF(CNPJCPF);
      FieldByName('XNome').AsString := xNome;
      with EnderExped do
      begin
        FieldByName('Xlgr').AsString    := XLgr;
        FieldByName('Nro').AsString     := Nro;
        FieldByName('XCpl').AsString    := XCpl;
        FieldByName('XBairro').AsString := XBairro;
        FieldByName('CMun').AsString    := IntToStr(CMun);
        FieldByName('XMun').AsString    := CollateBr(XMun);
        FieldByName('UF').AsString      := UF;
        FieldByName('CEP').AsString     := FormatarCEP(Poem_Zeros(CEP, 8));
        FieldByName('CPais').AsString   := IntToStr(CPais);
        FieldByName('XPais').AsString   := XPais;
        FieldByName('Fone').AsString    := FormatarFone(Fone);
      end;
      FieldByName('IE').AsString := IE;
    end;
    Post;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaIdentificacao;
begin
  with cdsIdentificacao do
  begin

    Append;
    with FCTe.infCTe do
    begin
      FieldByName('Id').AsString    := OnlyNumber(Id);
      FieldByName('Chave').AsString := FormatarChaveAcesso(Id);
    end;

    with FCTe.ide do
    begin
      FieldByName('CUF').AsString   := IntToStr(CUF);
      FieldByName('CCT').AsString   := IntToStr(CCT);
      FieldByName('CFOP').AsString  := IntToStr(CFOP);
      FieldByName('NatOp').AsString := NatOp;

      case forPag of
        fpPago  : FieldByName('forPag').AsString  := 'Pago';
        fpAPagar: FieldByName('forPag').AsString  := 'A Pagar';
        fpOutros: FieldByName('forPag').AsString  := 'Outros';
      end;

      FieldByName('Mod_').AsString    := modelo;
      FieldByName('Serie').AsString   := IntToStr(serie);
      FieldByName('NCT').AsString     := FormatarNumeroDocumentoFiscal(IntToStr(nCT));
      FieldByName('dhEmi').AsDateTime := dhEmi;

      case tpCTe of
        tcNormal: FieldByName('TpCT').AsString      := 'Normal';
        tcComplemento: FieldByName('TpCT').AsString := 'Complemento';
        tcAnulacao: FieldByName('TpCT').AsString    := 'Anula��o';
        tcSubstituto: FieldByName('TpCT').AsString  := 'Substituto';
      end;
{$IFDEF PL_103}
      FieldByName('cMunEmi').AsString := IntToStr(cMunEmi);
      FieldByName('xMunEmi').AsString := xMunEmi;
      FieldByName('UFEmi').AsString   := UFEmi;
      // {$ENDIF}
      // {$IFDEF PL_104}
{$ELSE}
      FieldByName('cMunEmi').AsString := IntToStr(cMunEnv);
      FieldByName('xMunEmi').AsString := xMunEnv;
      FieldByName('UFEmi').AsString   := UFEnv;
{$ENDIF}
      FieldByName('modal').AsString := TpModalToStr(CTe.ide.modal);

      case tpServ of
        tsNormal: FieldByName('tpServ').AsString         := 'Normal';
        tsSubcontratacao: FieldByName('tpServ').AsString := 'Subcontrata��o';
        tsRedespacho: FieldByName('tpServ').AsString     := 'Redespacho';
        tsIntermediario: FieldByName('tpServ').AsString  := 'Intermedi�rio';
      end;

      FieldByName('cMunIni').AsString := IntToStr(cMunIni);
      FieldByName('xMunIni').AsString := xMunIni;
      FieldByName('UFIni').AsString   := UFIni;
      FieldByName('cMunFim').AsString := IntToStr(cMunFim);
      FieldByName('xMunFim').AsString := xMunFim;
      FieldByName('UFFim').AsString   := UFFim;
      FieldByName('TpImp').AsString   := IfThen(TpImp = tiRetrato, '1', '2');
      FieldByName('TpEmis').AsString  := IfThen(TpEmis = teNormal, '1', '5');
      FieldByName('CDV').AsString     := IntToStr(CDV);
      FieldByName('TpAmb').AsString   := IfThen(tpAmb = taHomologacao, '2', '1');
      FieldByName('ProcEmi').AsString := IfThen(ProcEmi = peAplicativoContribuinte, '0', '');
      FieldByName('VerProc').AsString := VerProc;

      case Toma03.Toma of
        tmRemetente: FieldByName('Toma').AsString    := 'Remetente';
        tmDestinatario: FieldByName('Toma').AsString := 'Destinat�rio';
        tmExpedidor: FieldByName('Toma').AsString    := 'Expedidor';
        tmRecebedor: FieldByName('Toma').AsString    := 'Recebedor';
      end;

      case Toma4.Toma of
        tmOutros: FieldByName('Toma').AsString := 'Outros';
      end;
    end;
    Post;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaInformacoesAdicionais;
var
  vTemp        : TStringList;
  IndexCampo   : Integer;
  Campos       : TSplitResult;
  BufferObs    : string;
  TmpStr       : string;
  wContingencia: string;
  wObs         : string;
  wSubstituto  : string;
  i            : Integer;
begin
  with cdsInformacoesAdicionais do
  begin
    Append;
    with FCTe.compl do
    begin
      wObs := xObs;

{$IFDEF PL_200}
      if CTE.ide.tpCTe = tcSubstituto then
      begin
        wSubstituto := 'Chave do CT-e a ser substituido (Original): ' + CTE.infCTeNorm.infCteSub.chCTe + ';';
        if Length(CTE.infCTeNorm.infCteSub.tomaICMS.refNFe) > 0 then
          wSubstituto := wSubstituto + 'Chave da NF-e emitida pelo tomador: ' + CTE.infCTeNorm.infCteSub.tomaICMS.refNFe + ';'
        else if Length(CTE.infCTeNorm.infCteSub.tomaICMS.refCte) > 0 then
          wSubstituto := wSubstituto + 'Chave do CT-e emitido pelo tomador: ' + CTE.infCTeNorm.infCteSub.tomaICMS.refCte + ';'
        else if CTE.infCTeNorm.infCteSub.tomaICMS.refNF.Nro > 0 then
          wSubstituto := wSubstituto + 'N�mero/S�rie da nota emitida pelo tomador: ' + IntToStr(CTE.infCTeNorm.infCteSub.tomaICMS.refNF.Nro) + ' / ' +
            IntToStr(CTE.infCTeNorm.infCteSub.tomaICMS.refNF.serie) + ';'
        else if Length(CTE.infCTeNorm.infCteSub.tomaNaoICMS.refCteAnu) > 0 then
          wSubstituto := wSubstituto + 'Chave do CT-e de anula��o: ' + CTE.infCTeNorm.infCteSub.tomaNaoICMS.refCteAnu + ';';

        if Length(wObs) > 0 then
          wObs := wObs + ';';
        wObs   := wObs + wSubstituto;

      end;
{$ENDIF}
      // Contingencia
      if FCTe.ide.TpEmis = teNormal then
        wContingencia := ''
      else
      begin
        if (FCTe.ide.TpEmis = teContingencia) or (FCTe.ide.TpEmis = teFSDA) or (FCTe.ide.TpEmis = teSCAN) then
          wContingencia := 'DACTE EM CONTING�NCIA, IMPRESSO EM DECORR�NCIA DE PROBLEMAS T�CNICOS'
        else if FCTe.ide.TpEmis = teDPEC then
          wContingencia := 'DACTE IMPRESSO EM CONTING�NCIA - DPEC REGULARMENTE RECEBIDA PELA RECEITA FEDERAL DO BRASIL';
      end;
      if Length(wObs) > 0 then
        wObs := wObs + ';';
      wObs   := wObs + wContingencia;

      vTemp := TStringList.Create;
      try
        if Trim(wObs) <> '' then
        begin
          Campos         := Split(';', wObs);
          for IndexCampo := 0 to Length(Campos) - 1 do
            vTemp.Add(Campos[IndexCampo]);

          TmpStr    := vTemp.Text;
          BufferObs := TmpStr;
        end
        else
          BufferObs := '';

      finally
        vTemp.Free;
      end;

      FieldByName('Fluxo_xOrig').AsString := fluxo.xOrig;
      FieldByName('Fluxo_xDest').AsString := fluxo.xDest;
      FieldByName('Fluxo_xRota').AsString := fluxo.xRota;

    end;
    FieldByName('OBS').AsString := BufferObs;

    BufferObs := '';
    if Trim(FCTe.Imp.infAdFisco) <> '' then
    begin
      wObs  := FCTe.Imp.infAdFisco;
      vTemp := TStringList.Create;
      try
        if Trim(wObs) <> '' then
        begin
          Campos         := Split(';', wObs);
          for IndexCampo := 0 to Length(Campos) - 1 do
            vTemp.Add(Campos[IndexCampo]);

          TmpStr    := vTemp.Text;
          BufferObs := TmpStr;
        end
        else
          BufferObs := '';

      finally
        vTemp.Free;
      end;
    end;
    FieldByName('ObsCont').AsString := BufferObs;

    BufferObs := '';
    if FCTe.compl.ObsCont.Count > 0 then
    begin
      wObs   := '';
      for i  := 0 to FCTe.compl.ObsCont.Count - 1 do
        wObs := wObs + FCTe.compl.ObsCont[i].xCampo + ' : ' + FCTe.compl.ObsCont[i].xTexto + ';';

      vTemp := TStringList.Create;
      try
        if Trim(wObs) <> '' then
        begin
          Campos := Split(';', wObs);
          for IndexCampo := 0 to Length(Campos) - 1 do
            vTemp.Add(Campos[IndexCampo]);

          TmpStr    := vTemp.Text;
          BufferObs := TmpStr;
        end
        else
          BufferObs := '';

      finally
        vTemp.Free;
      end;

    end;
    FieldByName('infAdFisco').AsString := BufferObs;
    Post;
  end;

end;

procedure TACBrCTeDACTEFR.CarregaModalAereo;
begin
  if FCTe.ide.modal <> mdAereo then
    Exit;

  with cdsModalAereo, CTE.infCTeNorm do
  begin
    Append;
    FieldByName('nMinu').AsInteger := aereo.nMinu;
    FieldByName('nOCA').AsString := aereo.nOCA;
    FieldByName('dPrevAereo').AsDateTime := aereo.dPrevAereo;
    FieldByName('xLAgEmi').AsString := aereo.xLAgEmi;
    FieldByName('IdT').AsString := aereo.IdT;
    FieldByName('CL').AsString := aereo.tarifa.CL;
    FieldByName('cTar').AsString := aereo.tarifa.cTar;
    FieldByName('vTar').AsCurrency := aereo.tarifa.vTar;
    FieldByName('xDime').AsString := aereo.natCarga.xDime;
    FieldByName('cInfManu').AsInteger := aereo.natCarga.cinfManu;
    FieldByName('cIMP').AsString := aereo.natCarga.cIMP;
    FieldByName('xOrig').AsString := CTe.compl.fluxo.xOrig;
    FieldByName('xDest').AsString := CTe.compl.fluxo.xDest;
    FieldByName('xRota').AsString := CTe.compl.fluxo.xRota;
    Post;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaMultiModal;
begin
  if FCTe.ide.modal <> mdMultimodal then
    Exit;

  with cdsMultiModal, CTE.infCTeNorm do
  begin
    Append;
    FieldByName('COTM').AsString := multimodal.COTM;
    FieldByName('indNegociavel').AsString := indNegociavelToStr(multimodal.indNegociavel);
    Post;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaModalAquaviario;
var
   i: Integer;
   xBalsa: String;
begin
  if FCTe.ide.modal <> mdAquaviario then
    Exit;

  with cdsModalAquaviario, CTe.infCTeNorm.aquav do
  begin
    Append;

    FieldByName('vPrest').AsFloat    := vPrest;
    FieldByName('vAFRMM').AsFloat    := vAFRMM;
    FieldByName('nBooking').AsString := nBooking;
    FieldByName('nCtrl').AsString    := nCtrl;
    FieldByName('xNavio').AsString   := xNavio;
    FieldByName('nViag').AsString    := nViag;

    case direc of
      drNorte: FieldByName('direc').AsString := 'NORTE';
      drLeste: FieldByName('direc').AsString := 'LESTE';
      drSul:   FieldByName('direc').AsString := 'SUL';
      drOeste: FieldByName('direc').AsString := 'OESTE';
    end;

    FieldByName('prtEmb').AsString := prtEmb;
    FieldByName('prtTrans').AsString := prtTrans;
    FieldByName('prtDest').AsString := prtDest;

    case tpNav of
      tnInterior:  FieldByName('tpNav').AsString := 'INTERIOR';
      tnCabotagem: FieldByName('tpNav').AsString := 'CABOTAGEM';
    end;

    FieldByName('irin').AsString := irin;
    FieldByName('xNavio').AsString := FieldByName('xNavio').AsString;

    for i := 0 to balsa.Count-1 do
      xBalsa := xBalsa + balsa.Items[i].xBalsa +',';

    FieldByName('xBalsa').AsString := Copy(xBalsa,1,Length(xBalsa)-1);

    Post;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaModalRodoviario;
var
  i: Integer;
begin
  if FCTe.ide.modal <> mdRodoviario then
    Exit;

  with cdsModalRodoviario do
  begin
    Append;
    //
{$IFDEF PL_200}
    case CTE.infCTeNorm.rodo.lota of
{$ELSE}
    case CTE.rodo.lota of
{$ENDIF}
      ltNao: FieldByName('LOTACAO').AsString := 'N�o';
      ltSim: FieldByName('LOTACAO').AsString := 'Sim';
    end;

{$IFDEF PL_200}
    with CTE.infCTeNorm.rodo do
{$ELSE}
    with CTE.rodo do
{$ENDIF}
    begin
      FieldByName('RNTRC').AsString := RNTRC;
      if DateToStr(dPrev) <> '30/12/1899' then
         FieldByName('DATAPREVISTA').AsString := DateToStr(dPrev);
      FieldByName('CIOT').AsString           := CIOT;
    end;

{$IFDEF PL_200}
    for i := 0 to CTE.infCTeNorm.rodo.lacRodo.Count - 1 do
    begin
      with CTE.infCTeNorm.rodo.lacRodo.Items[i] do
{$ELSE}
    for i := 0 to CTE.rodo.Lacres.Count - 1 do
    begin
      with CTE.rodo.Lacres.Items[i] do
{$ENDIF}
      begin
        if Trim(FieldByName('LACRES').AsString) <> '' then
           FieldByName('LACRES').AsString := FieldByName('LACRES').AsString + '/';
        FieldByName('LACRES').AsString   := FieldByName('LACRES').AsString + nLacre;
      end;
    end;

    Post;
  end;

  with cdsRodoVeiculos do
  begin

{$IFDEF PL_200}
    for i := 0 to CTE.infCTeNorm.rodo.veic.Count - 1 do
    begin
      with CTE.infCTeNorm.rodo.veic.Items[i] do
      begin
{$ELSE}
    for i := 0 to CTE.rodo.veic.Count - 1 do
    begin
      with CTE.rodo.veic.Items[i] do
      begin
{$ENDIF}
        Append;
        case tpVeic of
          tvTracao: FieldByName('tpVeic').AsString  := 'Tra��o';
          tvReboque: FieldByName('tpVeic').AsString := 'Reboque';
        end;
        FieldByName('placa').AsString := placa;
        FieldByName('UF').AsString    := UF;
        if tpProp = tpProprio then
           FieldByName('RNTRC').AsString := CTe.infCTeNorm.rodo.RNTRC
        else
           FieldByName('RNTRC').AsString := Prop.RNTRC;
        Post;
      end;
    end;
  end;

  with cdsRodoValePedagio do
  begin

{$IFDEF PL_104}
    for i := 0 to CTE.rodo.valePed.Count - 1 do
    begin
      Append;
      FieldByName('CNPJForn').AsString := FormatarCNPJouCPF(CTE.rodo.valePed.Items[i].CNPJForn);
      FieldByName('CNPJPg').AsString   := FormatarCNPJouCPF(CTE.rodo.valePed.Items[i].CNPJPg);
      FieldByName('nCompra').AsString  := CTE.rodo.valePed.Items[i].nCompra;
      Post;
    end;
{$ENDIF}
{$IFDEF PL_200}
    for i := 0 to CTE.infCTeNorm.rodo.valePed.Count - 1 do
    begin
      Append;
      FieldByName('CNPJForn').AsString := FormatarCNPJouCPF(CTE.infCTeNorm.rodo.valePed.Items[i].CNPJForn);
      FieldByName('CNPJPg').AsString   := FormatarCNPJouCPF(CTE.infCTeNorm.rodo.valePed.Items[i].CNPJPg);
      FieldByName('nCompra').AsString  := CTE.infCTeNorm.rodo.valePed.Items[i].nCompra;
      FieldByName('vValePed').AsFloat := CTe.infCTeNorm.rodo.valePed.Items[i].vValePed;
      Post;
    end;
{$ENDIF}
  end;

  with cdsRodoMotorista do
  begin

{$IFDEF PL_200}
    for i := 0 to CTE.infCTeNorm.rodo.moto.Count - 1 do
    begin
      with CTE.infCTeNorm.rodo.moto.Items[i] do
      begin
{$ELSE}
    for i := 0 to CTE.rodo.moto.Count - 1 do
    begin
      with CTE.rodo.moto.Items[i] do
      begin
{$ENDIF}
        Append;
        FieldByName('xNome').AsString := xNome;
        FieldByName('CPF').AsString   := CPF;
        Post;
      end;
    end;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaParametros;
var
  vChave_Contingencia: string;
  vResumo            : string;
  vStream            : TMemoryStream;
  vStringStream      : TStringStream;
begin
  { par�metros }
  with cdsParametros do
  begin

    Append;

    vResumo := '';
    if DACTEClassOwner.ExibirResumoCanhoto then
       begin
          vResumo := 'EMIT: '+ FCTe.Emit.xNome + ' - ' +
                     'EMISS�O: ' + FormatDateTime('DD/MM/YYYY',FCTe.Ide.dhEmi) + '  - '+
                     'TOMADOR: ';
          if FCTe.Ide.Toma4.xNome = '' then
             begin
                case FCTe.Ide.Toma03.Toma of
                   tmRemetente:    vResumo := vResumo + FCTe.Rem.xNome;
    	              tmExpedidor:    vResumo := vResumo + FCTe.Exped.xNome;
                   tmRecebedor:    vResumo := vResumo + FCTe.Receb.xNome;
    	              tmDestinatario: vResumo := vResumo + FCTe.Dest.xNome;
                end
             end
          else
             vResumo := vResumo + FCTe.Ide.Toma4.xNome;

          vResumo := vResumo + ' - VALOR A RECEBER: R$ ' + FormatFloat('###,###,###,##0.00',FCTe.vPrest.vRec);
       end;
    FieldByName('ResumoCanhoto').AsString := vResumo;

    if DACTEClassOwner.PosCanhoto = prCabecalho then
       FieldByName('PrintCanhoto').AsString := '0'
    else
       FieldByName('PrintCanhoto').AsString := '1';
{$IFDEF PL_103}
    FieldByName('Versao').AsString := '1.03';
{$ENDIF}
{$IFDEF PL_104}
    FieldByName('Versao').AsString := '1.04';
{$ENDIF}
{$IFDEF PL_200}
    FieldByName('Versao').AsString := '2.00';
{$ENDIF}
    if (FCTe.ide.tpAmb = taHomologacao) then
      FieldByName('Mensagem0').AsString := 'CTe sem Valor Fiscal - HOMOLOGA��O'
    else
    begin
      if not(FCTe.ide.TpEmis in [teContingencia, teFSDA]) then
      begin
        if ((EstaVazio(ProtocoloCTE)) and
          (EstaVazio(FCTe.procCTe.nProt))) then
          FieldByName('Mensagem0').AsString := 'CTe sem Autoriza��o de Uso da SEFAZ'
        else
          if (not((EstaVazio(ProtocoloCTE)) and
          (EstaVazio(FCTe.procCTe.nProt)))) and
          (FCTe.procCTe.cStat = 101) then
          FieldByName('Mensagem0').AsString := 'CTe Cancelado'
        else
        begin
          if CTeCancelada then
            FieldByName('Mensagem0').AsString := 'CTe Cancelado'
          else
            FieldByName('Mensagem0').AsString := '';
        end;
      end
      else
        FieldByName('Mensagem0').AsString := '';
    end;

    // Carregamento da imagem
    if DACTEClassOwner.Logo <> '' then
    begin
      FieldByName('Imagem').AsString := DACTEClassOwner.Logo;
      vStream                        := TMemoryStream.Create;
      try
        if FileExists(DACTEClassOwner.Logo) then
          vStream.LoadFromFile(DACTEClassOwner.Logo)
        else
        begin
          vStringStream := TStringStream.Create(DACTEClassOwner.Logo);
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

    if Sistema <> '' then
      FieldByName('Sistema').AsString := Sistema
    else
      FieldByName('Sistema').AsString := 'Projeto ACBr - http://acbr.sf.net';

    if Usuario <> '' then
      FieldByName('Usuario').AsString := ' - ' + Usuario
    else
      FieldByName('Usuario').AsString := '';

    if Fax <> '' then
      FieldByName('Fax').AsString := ' - FAX ' + Fax
    else
      FieldByName('Fax').AsString := '';

    FieldByName('Site').AsString  := Site;
    FieldByName('Email').AsString := Email;

    if ImprimirDescPorc then
      FieldByName('Desconto').AsString := 'DESC %'
    else
      FieldByName('Desconto').AsString := 'V.DESC.';

    if ((FCTe.ide.TpEmis = teNormal) or (FCTe.ide.TpEmis = teSCAN)) then
    begin
      FieldByName('ChaveAcesso_Descricao').AsString := 'CHAVE DE ACESSO';
      FieldByName('Contingencia_ID').AsString       := '';

      if ((CTeCancelada) or (FCTe.procCTe.cStat = 101)) then
        FieldByName('Contingencia_Descricao').AsString := 'PROTOCOLO DE HOMOLOGA��O DO CANCELAMENTO'
      else
        FieldByName('Contingencia_Descricao').AsString := 'PROTOCOLO DE AUTORIZA��O DE USO';

      if EstaVazio(ProtocoloCTE) then
      begin
        if not(FCTe.ide.TpEmis in [teContingencia, teFSDA]) and EstaVazio(FCTe.procCTe.nProt) then
          FieldByName('Contingencia_Valor').AsString := 'CTe sem Autoriza��o de Uso da SEFAZ'
        else
          FieldByName('Contingencia_Valor').AsString := FCTe.procCTe.nProt + ' ' + IfThen(FCTe.procCTe.dhRecbto <> 0,
            DateTimeToStr(FCTe.procCTe.dhRecbto), '');
      end
      else
        FieldByName('Contingencia_Valor').AsString := ProtocoloCTE;
    end
    else
    begin
      vChave_Contingencia                           := TACBrCTe(DACTEClassOwner.ACBrCTe).GerarChaveContingencia(FCTe);
      FieldByName('ChaveAcesso_Descricao').AsString := 'CHAVE DE ACESSO';
      FieldByName('Contingencia_ID').AsString       := vChave_Contingencia;

      if ((FCTe.ide.TpEmis = teContingencia) or (FCTe.ide.TpEmis = teFSDA)) then
      begin
        FieldByName('Contingencia_Descricao').AsString := 'DADOS DA CT-E';
        FieldByName('Contingencia_Valor').AsString     := FormatarChaveAcesso(vChave_Contingencia);
      end
      else
        if (FCTe.ide.TpEmis = teDPEC) then
      begin
        FieldByName('Contingencia_Descricao').AsString := 'N�MERO DE REGISTRO DPEC';

        // precisa testar
        // if EstaVazio(ProtocoloCTE) then
        // raise EACBrCTeException.Create('Protocolo de Registro no DPEC n�o informado.')
        // else
        // FieldByName('Contingencia_Valor').AsString := ProtocoloCTe;
      end
      else
        if (FCTe.ide.TpEmis = teSVCSP) or (FCTe.ide.TpEmis = teSVCRS) then
        begin
          FieldByName('Contingencia_Descricao').AsString := 'PROTOCOLO DE AUTORIZA��O DE USO';
          FieldByName('Contingencia_Valor').AsString     := FCTe.procCTe.nProt + ' ' + IfThen(FCTe.procCTe.dhRecbto <> 0,
            DateTimeToStr(FCTe.procCTe.dhRecbto), '');
        end;
    end;
    Post;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaRecebedor;
begin
  { Recebedor }
  with cdsRecebedor do
  begin

    Append;

    with FCTe.Receb do
    begin
      FieldByName('CNPJ').AsString  := FormatarCNPJouCPF(CNPJCPF);
      FieldByName('XNome').AsString := xNome;
      with EnderReceb do
      begin
        FieldByName('Xlgr').AsString    := XLgr;
        FieldByName('Nro').AsString     := Nro;
        FieldByName('XCpl').AsString    := XCpl;
        FieldByName('XBairro').AsString := XBairro;
        FieldByName('CMun').AsString    := IntToStr(CMun);
        FieldByName('XMun').AsString    := CollateBr(XMun);
        FieldByName('UF').AsString      := UF;
        FieldByName('CEP').AsString     := FormatarCEP(Poem_Zeros(CEP, 8));
        FieldByName('CPais').AsString   := IntToStr(CPais);
        FieldByName('XPais').AsString   := XPais;
        FieldByName('Fone').AsString    := FormatarFone(Fone);
      end;
      FieldByName('IE').AsString := IE;
    end;

    Post;
  end;

end;

procedure TACBrCTeDACTEFR.CarregaRemetente;
begin
  { Remetente }
  with cdsRemetente do
  begin

    Append;
    with FCTe.Rem do
    begin
      FieldByName('CNPJ').AsString  := FormatarCNPJouCPF(CNPJCPF);
      FieldByName('XNome').AsString := xNome;
      FieldByName('XFant').AsString := XFant;
      with EnderReme do
      begin
        FieldByName('Xlgr').AsString    := XLgr;
        FieldByName('Nro').AsString     := Nro;
        FieldByName('XCpl').AsString    := XCpl;
        FieldByName('XBairro').AsString := XBairro;
        FieldByName('CMun').AsString    := IntToStr(CMun);
        FieldByName('XMun').AsString    := CollateBr(XMun);
        FieldByName('UF').AsString      := UF;
        FieldByName('CEP').AsString     := FormatarCEP(Poem_Zeros(CEP, 8));
        FieldByName('CPais').AsString   := IntToStr(CPais);
        FieldByName('XPais').AsString   := XPais;
        FieldByName('Fone').AsString    := FormatarFone(Fone);
      end;
      FieldByName('IE').AsString := IE;
    end;
    Post;
  end;
end;

procedure TACBrCTeDACTEFR.CarregaSeguro;
var
  i: Integer;
begin
  with cdsSeguro do
  begin
    //
{$IFDEF PL_200}
    if CTE.infCTeNorm.seg.Count > 0 then
    begin
      for i := 0 to CTE.infCTeNorm.seg.Count - 1 do
      begin
        with CTE.infCTeNorm.seg.Items[i] do
        begin
{$ELSE}
    if CTE.InfSeg.Count > 0 then
    begin
      for i := 0 to CTE.InfSeg.Count - 1 do
      begin
        with CTE.InfSeg.Items[i] do
        begin
{$ENDIF}
          Append;
          case respSeg of
            rsRemetente     : FieldByName('RESPONSAVEL').AsString := 'Remetente';
            rsExpedidor     : FieldByName('RESPONSAVEL').AsString := 'Expedidor';
            rsRecebedor     : FieldByName('RESPONSAVEL').AsString := 'Recebedor';
            rsDestinatario  : FieldByName('RESPONSAVEL').AsString := 'Destinat�rio';
            rsEmitenteCTe   : FieldByName('RESPONSAVEL').AsString := 'Emitente';
            rsTomadorServico: FieldByName('RESPONSAVEL').AsString := 'Tomador';
          end;
          FieldByName('NOMESEGURADORA').AsString  := xSeg;
          FieldByName('NUMEROAPOLICE').AsString   := nApol;
          FieldByName('NUMEROAVERBACAO').AsString := nAver;
          Post;
        end;
      end;
    end
    else
    begin
      Append;
      FieldByName('RESPONSAVEL').AsString     := '';
      FieldByName('NOMESEGURADORA').AsString  := '';
      FieldByName('NUMEROAPOLICE').AsString   := '';
      FieldByName('NUMEROAVERBACAO').AsString := '';
      Post;
    end;

  end;

end;

procedure TACBrCTeDACTEFR.CarregaTomador;
begin
  { Tomador Outros }
  with cdsTomador do
  begin

    Append;

    case FCTe.ide.Toma03.Toma of
      tmRemetente:
        begin
          FieldByName('CNPJ').AsString    := FormatarCNPJouCPF(FCTe.Rem.CNPJCPF);
          FieldByName('XNome').AsString   := FCTe.Rem.xNome;
          FieldByName('XFant').AsString   := FCTe.Rem.XFant;
          FieldByName('IE').AsString      := FCTe.Rem.IE;
          FieldByName('Xlgr').AsString    := FCTe.Rem.EnderReme.XLgr;
          FieldByName('Nro').AsString     := FCTe.Rem.EnderReme.Nro;
          FieldByName('XCpl').AsString    := FCTe.Rem.EnderReme.XCpl;
          FieldByName('XBairro').AsString := FCTe.Rem.EnderReme.XBairro;
          FieldByName('CMun').AsString    := IntToStr(FCTe.Rem.EnderReme.CMun);
          FieldByName('XMun').AsString    := FCTe.Rem.EnderReme.XMun;
          FieldByName('UF').AsString      := FCTe.Rem.EnderReme.UF;
          FieldByName('CEP').AsString     := FormatarCEP(Poem_Zeros(FCTe.Rem.EnderReme.CEP, 8));
          FieldByName('CPais').AsString   := IntToStr(FCTe.Rem.EnderReme.CPais);
          FieldByName('XPais').AsString   := FCTe.Rem.EnderReme.XPais;
          FieldByName('Fone').AsString    := FormatarFone(FCTe.Rem.Fone);
        end;

      tmDestinatario:
        begin
          FieldByName('CNPJ').AsString    := FormatarCNPJouCPF(FCTe.Dest.CNPJCPF);
          FieldByName('XNome').AsString   := FCTe.Dest.xNome;
          FieldByName('IE').AsString      := FCTe.Dest.IE;
          FieldByName('Xlgr').AsString    := FCTe.Dest.EnderDest.XLgr;
          FieldByName('Nro').AsString     := FCTe.Dest.EnderDest.Nro;
          FieldByName('XCpl').AsString    := FCTe.Dest.EnderDest.XCpl;
          FieldByName('XBairro').AsString := FCTe.Dest.EnderDest.XBairro;
          FieldByName('CMun').AsString    := IntToStr(FCTe.Dest.EnderDest.CMun);
          FieldByName('XMun').AsString    := FCTe.Dest.EnderDest.XMun;
          FieldByName('UF').AsString      := FCTe.Dest.EnderDest.UF;
          FieldByName('CEP').AsString     := FormatarCEP(Poem_Zeros(FCTe.Dest.EnderDest.CEP, 8));
          FieldByName('CPais').AsString   := IntToStr(FCTe.Dest.EnderDest.CPais);
          FieldByName('XPais').AsString   := FCTe.Dest.EnderDest.XPais;
          FieldByName('Fone').AsString    := FormatarFone(FCTe.Dest.Fone);
        end;

      tmExpedidor:
        begin
          FieldByName('CNPJ').AsString    := FormatarCNPJouCPF(FCTe.Exped.CNPJCPF);
          FieldByName('XNome').AsString   := FCTe.Exped.xNome;
          FieldByName('IE').AsString      := FCTe.Exped.IE;
          FieldByName('Xlgr').AsString    := FCTe.Exped.EnderExped.XLgr;
          FieldByName('Nro').AsString     := FCTe.Exped.EnderExped.Nro;
          FieldByName('XCpl').AsString    := FCTe.Exped.EnderExped.XCpl;
          FieldByName('XBairro').AsString := FCTe.Exped.EnderExped.XBairro;
          FieldByName('CMun').AsString    := IntToStr(FCTe.Exped.EnderExped.CMun);
          FieldByName('XMun').AsString    := FCTe.Exped.EnderExped.XMun;
          FieldByName('UF').AsString      := FCTe.Exped.EnderExped.UF;
          FieldByName('CEP').AsString     := FormatarCEP(Poem_Zeros(FCTe.Exped.EnderExped.CEP, 8));
          FieldByName('CPais').AsString   := IntToStr(FCTe.Exped.EnderExped.CPais);
          FieldByName('XPais').AsString   := FCTe.Exped.EnderExped.XPais;
          FieldByName('Fone').AsString    := FormatarFone(FCTe.Exped.Fone);
        end;

      tmRecebedor:
        begin
          FieldByName('CNPJ').AsString    := FormatarCNPJouCPF(FCTe.Receb.CNPJCPF);
          FieldByName('XNome').AsString   := FCTe.Receb.xNome;
          FieldByName('IE').AsString      := FCTe.Receb.IE;
          FieldByName('Xlgr').AsString    := FCTe.Receb.EnderReceb.XLgr;
          FieldByName('Nro').AsString     := FCTe.Receb.EnderReceb.Nro;
          FieldByName('XCpl').AsString    := FCTe.Receb.EnderReceb.XCpl;
          FieldByName('XBairro').AsString := FCTe.Receb.EnderReceb.XBairro;
          FieldByName('CMun').AsString    := IntToStr(FCTe.Receb.EnderReceb.CMun);
          FieldByName('XMun').AsString    := FCTe.Receb.EnderReceb.XMun;
          FieldByName('UF').AsString      := FCTe.Receb.EnderReceb.UF;
          FieldByName('CEP').AsString     := FormatarCEP(Poem_Zeros(FCTe.Receb.EnderReceb.CEP, 8));
          FieldByName('CPais').AsString   := IntToStr(FCTe.Receb.EnderReceb.CPais);
          FieldByName('XPais').AsString   := FCTe.Receb.EnderReceb.XPais;
          FieldByName('Fone').AsString    := FormatarFone(FCTe.Receb.Fone);
        end;
    end;

    case FCTe.ide.Toma4.Toma of
      tmOutros:
        begin
          FieldByName('CNPJ').AsString    := FormatarCNPJouCPF(FCTe.ide.Toma4.CNPJCPF);
          FieldByName('XNome').AsString   := FCTe.ide.Toma4.xNome;
          FieldByName('IE').AsString      := FCTe.ide.Toma4.IE;
          FieldByName('Xlgr').AsString    := FCTe.ide.Toma4.EnderToma.XLgr;
          FieldByName('Nro').AsString     := FCTe.ide.Toma4.EnderToma.Nro;
          FieldByName('XCpl').AsString    := FCTe.ide.Toma4.EnderToma.XCpl;
          FieldByName('XBairro').AsString := FCTe.ide.Toma4.EnderToma.XBairro;
          FieldByName('CMun').AsString    := IntToStr(FCTe.ide.Toma4.EnderToma.CMun);
          FieldByName('XMun').AsString    := FCTe.ide.Toma4.EnderToma.XMun;
          FieldByName('UF').AsString      := FCTe.ide.Toma4.EnderToma.UF;
          FieldByName('CEP').AsString     := FormatarCEP(Poem_Zeros(FCTe.ide.Toma4.EnderToma.CEP, 8));
          FieldByName('CPais').AsString   := IntToStr(FCTe.ide.Toma4.EnderToma.CPais);
          FieldByName('XPais').AsString   := FCTe.ide.Toma4.EnderToma.XPais;
          FieldByName('Fone').AsString    := FormatarFone(FCTe.ide.Toma4.Fone);
        end;
    end;
    Post;
  end;

end;

procedure TACBrCTeDACTEFR.CarregaVolumes;
var
  i, J                     : Integer;
  MCub, Volumes, VlrServico: Currency;
  ProdutoPred, OutrasCaract: string;
  TipoMedida               : array of string;
  UnidMedida               : array of string;
  QdtMedida                : array of Currency;
begin
  with cdsVolumes do
  begin

    J          := 0;
    VlrServico := 0;
    MCub       := 0;
    Volumes    := 0;

{$IFDEF PL_200}
    for i := 0 to CTE.infCTeNorm.infCarga.infQ.Count - 1 do
    begin
      with CTE.infCTeNorm.infCarga do
      begin
{$ELSE}
    for i := 0 to CTE.infCarga.infQ.Count - 1 do
    begin
      with CTE.infCarga do
      begin
{$ENDIF}
        ProdutoPred  := proPred;
        OutrasCaract := xOutCat;

{$IFDEF PL_103}
        VlrServico := CTE.infCarga.vMerc;
{$ELSE}
        VlrServico := vCarga;
{$ENDIF}
        case infQ.Items[i].cUnid of
          uM3: MCub         := MCub + infQ.Items[i].qCarga;
          uUNIDADE: Volumes := Volumes + infQ.Items[i].qCarga;
        end;
        begin
          Inc(J);
          SetLength(TipoMedida, J);
          SetLength(UnidMedida, J);
          SetLength(QdtMedida, J);
          TipoMedida[J - 1] := infQ.Items[i].tpMed;
          QdtMedida[J - 1]  := infQ.Items[i].qCarga;

          case infQ.Items[i].cUnid of
            uKG     : UnidMedida[J - 1] := 'KG';
            uTON    : UnidMedida[J - 1] := 'TON';
            uLITROS : UnidMedida[J - 1] := 'LT';
            uMMBTU  : UnidMedida[J - 1] := 'MMBTU';
            uUNIDADE: UnidMedida[J - 1] := 'UND';
            uM3     : UnidMedida[J - 1] := 'M3';
          end;
        end;
      end;
    end;

    if J = 0 then
    begin
      Append;
      FieldByName('Produto').AsString             := ProdutoPred;
      FieldByName('CaracteristicaCarga').AsString := OutrasCaract;
      FieldByName('ValorServico').AsFloat         := VlrServico;
      FieldByName('MCub').AsFloat                 := MCub;
      FieldByName('QVol').AsFloat                 := Volumes;
      Post;
    end
    else
      for i := 0 to J - 1 do
      begin
        Append;
        FieldByName('Produto').AsString             := ProdutoPred;
        FieldByName('CaracteristicaCarga').AsString := OutrasCaract;
        FieldByName('ValorServico').AsFloat         := VlrServico;
        FieldByName('MCub').AsFloat                 := MCub;
        FieldByName('QVol').AsFloat                 := Volumes;
        FieldByName('UnMedida').AsString            := UnidMedida[i];
        FieldByName('DescTipo').AsString            := TipoMedida[i];
        FieldByName('QMedida').AsFloat              := QdtMedida[i];
        Post;
      end;
  end;
end;

end.
