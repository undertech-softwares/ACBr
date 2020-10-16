{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrPOSPGWebPrinter;

interface

uses
  Classes, SysUtils,
  ACBrPosPrinter, ACBrPOS, ACBrPOSPGWebAPI, ACBrConsts;

const
  // Essas Tags ser�o interpretadas no momento da Impress�o, pois usam comandos espec�ficos
  CTAGS_POST_PROCESS: array[0..2] of string =
    ( cTagFonteAlinhadaEsquerda, cTagfonteAlinhadaCentro, cTagFonteAlinhadaDireita );
  CTAGS_AVANCO: array[0..3] of string =
    (cTagCorte, cTagCorteParcial, cTagCorteTotal, cTagPulodePagina);

type

  { TACBrPOSPGWebPrinter }

  TACBrPOSPGWebPrinter = class(TACBrPosPrinterClass)
  private
    FACBrPOS: TACBrPOS;
    FTerminalId: String;
  protected
    procedure Imprimir(const LinhasImpressao: String; var Tratado: Boolean);
  public
    constructor Create(AOwner: TACBrPosPrinter; AACBrPOS: TACBrPOS);

    procedure Configurar; override;
    function TraduzirTag(const ATag: AnsiString; var TagTraduzida: AnsiString): Boolean;
      override;
    function TraduzirTagBloco(const ATag, ConteudoBloco: AnsiString;
      var BlocoTraduzido: AnsiString): Boolean; override;

    property TerminalId: String read FTerminalId write FTerminalId;
  end;

implementation

uses
  StrUtils,
  ACBrUtil;

constructor TACBrPOSPGWebPrinter.Create(AOwner: TACBrPosPrinter;
  AACBrPOS: TACBrPOS);
begin
  inherited Create(AOwner);

  FACBrPOS := AACBrPOS;
  FTerminalId := '';

  fpModeloStr := 'POSPGWebPrinter';
  RazaoColunaFonte.Condensada := 1;
  RazaoColunaFonte.Expandida := 2;

  {(*}
    with Cmd  do
    begin
      LigaExpandido := #11;
    end;
  {*)}

  TagsNaoSuportadas.Add( cTagBarraCode128c );
end;

procedure TACBrPOSPGWebPrinter.Configurar;
begin
  fpPosPrinter.ColunasFonteNormal := CACBrPOSPGWebColunasImpressora;
  fpPosPrinter.PaginaDeCodigo := pcNone;
  fpPosPrinter.Porta := 'NULL';
  fpPosPrinter.OnEnviarStringDevice := Imprimir;
end;

procedure TACBrPOSPGWebPrinter.Imprimir(const LinhasImpressao: String;
  var Tratado: Boolean);
var
  BufferImpressao, ATag: AnsiString;
  AlinhamentoImpressao: TAlignment;
  SL: TStringList;
  i, PosTag: Integer;
  Linha: String;
  TipoCod: TACBrPOSPGWebCodBarras;

  function AjustarAlinhamentoLinha(const ALinha: String): String;
  var
    l: Integer;
  begin
    Result := ALinha;

    if Length(ALinha) < CACBrPOSPGWebColunasImpressora then
    begin
      if AlinhamentoImpressao = taRightJustify then
        Result := PadLeft(ALinha, CACBrPOSPGWebColunasImpressora)
      else if AlinhamentoImpressao = taCenter then
        Result := PadCenter(ALinha, CACBrPOSPGWebColunasImpressora)
    end
    else
    begin
      l := Length(Result);
      // Remove espa�os em branco, do final da String, para evitar pulo de linhas desenecess�rios
      while (l > CACBrPOSPGWebColunasImpressora) and (Result[l] = ' ') do
      begin
        Delete(Result, l, 1);
        Dec(l);
      end
    end;
  end;

  procedure ImprimirBuffer;
  begin
    if (BufferImpressao <> '') then
      FACBrPOS.ImprimirTexto(TerminalId, BufferImpressao);

    BufferImpressao := '';
  end;

  function AcharConteudoBloco(const ATag, ALinha: String): String;
  var
    TagFim, LLinha: String;
    PosTagIni, PosTagFim: Integer;
    LenTag: Integer;
  begin
    LLinha := LowerCase(ALinha);
    LenTag := Length(ATag);
    PosTagIni := pos(ATag, LLinha);
    if PosTagIni = 0 then
      PosTagIni := 1;

    TagFim := '</'+ copy(ATag, 2, LenTag);
    PosTagFim := PosEx(TagFim, LLinha, PosTag+LenTag );
    if (PosTagFim = 0) then
      PosTagFim := Length(ALinha);

    Result := copy(ALinha, PosTagIni+LenTag, PosTagFim-PosTagIni-LenTag);
  end;

begin
  // DEBUG
  //WriteToFile('c:\temp\relat1.txt', LinhasImpressao);

  if not Assigned(FACBrPOS) then
    raise EPosPrinterException.Create(ACBrStr('ACBrPOS n�o atribuido a TACBrPOSPGWebPrinter'));

  if (TerminalId = '') then
    raise EPosPrinterException.Create(ACBrStr('TerminalId n�o atribuido a TACBrPOSPGWebPrinter'));

  Tratado := True;
  BufferImpressao := '';
  AlinhamentoImpressao := taLeftJustify;

  SL := TStringList.Create;
  try
    SL.Text := LinhasImpressao;
    for i := 0 to SL.Count-1 do
    begin
      Linha := SL[i];
      PosTag := 0;
      ATag := '';
      AcharProximaTag(Linha, 1, ATag, PosTag);
      if (PosTag > 0) then
      begin
        if (PosTag = 1) then  // � Tag p�s processada ?
        begin
          if (ATag = cTagFonteAlinhadaEsquerda) then
            AlinhamentoImpressao := taLeftJustify
          else if (ATag = cTagfonteAlinhadaCentro) then
            AlinhamentoImpressao := taCenter
          else if (ATag = cTagFonteAlinhadaDireita) then
            AlinhamentoImpressao := taRightJustify

          else if (ATag = cTagPuloDeLinhas) then
          begin
            ImprimirBuffer;
            FACBrPOS.AvancarPapel(TerminalId);
            Continue;
          end

          else if (ATag = cTagQRCode) or (ATag = cTagBarraCode128) or (ATag = cTagBarraInter)  then
          begin
            ImprimirBuffer;
            if (ATag = cTagBarraInter) then
              TipoCod := codeITF
            else if (ATag = cTagBarraCode128) then
              TipoCod := code128
            else
              TipoCod := codeQRCODE;

            Linha := AcharConteudoBloco(ATag, Linha);
            FACBrPOS.ImprimirCodBarras(TerminalId, Linha, TipoCod);
            Continue;
          end;
        end;

        Linha := StringReplace(Linha, ATag, '', [rfReplaceAll]);
      end;

      if (pos(#11, Linha) > 1) then    // Expandido s� funciona no inicio da Linha (coluna 1)
        Linha := StringReplace(Linha, #11, '', [rfReplaceAll]);

      BufferImpressao := BufferImpressao +
                         AjustarAlinhamentoLinha(Linha) + LF;
    end;
  finally
    SL.Free;
  end;

  ImprimirBuffer;
end;

function TACBrPOSPGWebPrinter.TraduzirTag(const ATag: AnsiString;
  var TagTraduzida: AnsiString): Boolean;
begin
  TagTraduzida := '';
  Result := True;
  if MatchText(ATag, CTAGS_POST_PROCESS) then
    TagTraduzida := ATag
  else if MatchText(ATag, CTAGS_AVANCO) then
    TagTraduzida := cTagPuloDeLinhas
  else
    Result := False;  // Deixa ACBrPosPrinter traduzir...
end;

function TACBrPOSPGWebPrinter.TraduzirTagBloco(const ATag,
  ConteudoBloco: AnsiString; var BlocoTraduzido: AnsiString): Boolean;
const
  // Essas Tags ser�o interpretadas no momento da Impress�o, pois usam comandos espec�ficos
  CTAGS_POST_PROCESS: array[0..2] of string = ( cTagQRCode, cTagBarraCode128, cTagBarraInter );
begin
  BlocoTraduzido := '';
  Result := True;
  if MatchText(ATag, CTAGS_POST_PROCESS) then
    BlocoTraduzido := ATag + ConteudoBloco + '</'+ copy(ATag, 2, Length(ATag))
  else
    Result := False;  // Deixa ACBrPosPrinter traduzir...
end;

end.
