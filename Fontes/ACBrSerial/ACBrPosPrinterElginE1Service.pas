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

unit ACBrPosPrinterElginE1Service;

interface

uses
  Classes, SysUtils, Types,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$Else}
   Contnrs,
  {$IfEnd}
  ACBrDevice, ACBrPosPrinter, ACBrBase;

const
  CnModulo = 'Modulo';
  CnComando = 'Comando';
  CnFuncao = 'Funcao';
  CnParametros = 'Parametros';
  CmodImpressor = 'Impressor';

  CColunasImpressoraSmartPosElgin = 40;

type

  { TE1Funcao }

  TE1Funcao = class
  private
    FFuncao: String;
    FParametros: TACBrInformacoes;
  public
    constructor Create(NomeFuncao: String);
    destructor Destroy; override;

    property Funcao: String read FFuncao;
    property Parametros: TACBrInformacoes read FParametros;
  end;

  { TE1Comandos }

  TE1Comandos = class(TObjectList{$IfDef HAS_SYSTEM_GENERICS}<TE1Funcao>{$EndIf})
  private
    function GetItem(Index: Integer): TE1Funcao;
    procedure SetItem(Index: Integer; const Value: TE1Funcao);
  public
    function Add (Obj: TE1Funcao): Integer;
    procedure Insert (Index: Integer; Obj: TE1Funcao);
    function New(NomeFuncao: String): TE1Funcao;

    property Items[Index: Integer]: TE1Funcao read GetItem write SetItem; default;
  end;

  { TE1Json }

  TE1Json = class
  private
    FComandos: TE1Comandos;
    FModulo: String;
    function GetJSON: String;
    procedure SetJSON(AValue: String);
  public
    constructor Create(NomeModulo: String);
    destructor Destroy; override;
    procedure Clear;

    property Modulo: String read FModulo;
    property Comandos: TE1Comandos read FComandos;

    property JSON: String read GetJSON write SetJSON;
  end;

  TElginE1Printers = (prnI9, prnSmartPOS, prnM8);

  { TACBrPosPrinterElginE1Service }

  TACBrPosPrinterElginE1Service = class(TACBrPosPrinterClass)
  private
    fE1JSon: TE1Json;
    fModelo: TElginE1Printers;
    fPastaEntradaE1: String;
    fSeqArqE1: Integer;

  protected
    procedure Imprimir(const LinhasImpressao: String; var Tratado: Boolean);

    procedure AddCmdImprimirTexto(const ConteudoBloco: String);
    procedure AddCmdPuloDeLinhas(const Linhas: Integer);
  public
    constructor Create(AOwner: TACBrPosPrinter);
    destructor Destroy; override;

    procedure Configurar; override;

    procedure AntesDecodificar(var ABinaryString: AnsiString); override;
    procedure AdicionarBlocoResposta(const ConteudoBloco: AnsiString); override;
    procedure DepoisDecodificar(var ABinaryString: AnsiString); override;
    function TraduzirTag(const ATag: AnsiString; var TagTraduzida: AnsiString): Boolean;
      override;
    function TraduzirTagBloco(const ATag, ConteudoBloco: AnsiString;
      var BlocoTraduzido: AnsiString): Boolean; override;

    function ComandoFonte(TipoFonte: TACBrPosTipoFonte; Ligar: Boolean): AnsiString;
      override;
    function ComandoConfiguraModoPagina: AnsiString; override;
    function ComandoPosicionaModoPagina(APoint: TPoint): AnsiString; override;

    property E1JSon: TE1Json read fE1JSon;
    property Modelo: TElginE1Printers read fModelo write fModelo;
    property PastaEntradaE1: String read fPastaEntradaE1 write fPastaEntradaE1;
  end;

implementation

uses
  StrUtils, Math,
  {$IfDef ANDROID}
  System.Messaging, System.IOUtils,
  Androidapi.Helpers,  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes, Androidapi.JNI.App,
  FMX.Platform.Android,
  {$EndIf}
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
    JsonDataObjects_ACBr,
  {$Else}
    Jsons,
  {$EndIf}
  ACBrUtil, ACBrConsts;

{ TE1Funcao }

constructor TE1Funcao.Create(NomeFuncao: String);
begin
  inherited Create;
  FFuncao := NomeFuncao;
  FParametros := TACBrInformacoes.Create;
end;

destructor TE1Funcao.Destroy;
begin
  FParametros.Free;
end;

{ TE1Comandos }

function TE1Comandos.GetItem(Index: Integer): TE1Funcao;
begin
  Result := TE1Funcao(inherited Items[Index]);
end;

procedure TE1Comandos.SetItem(Index: Integer; const Value: TE1Funcao);
begin
  inherited Items[Index] := Value;
end;

function TE1Comandos.Add(Obj: TE1Funcao): Integer;
begin
  Result := inherited Add(Obj);
end;

procedure TE1Comandos.Insert(Index: Integer; Obj: TE1Funcao);
begin
  inherited Insert(Index, Obj);
end;

function TE1Comandos.New(NomeFuncao: String): TE1Funcao;
begin
  Result := TE1Funcao.Create(NomeFuncao);
  inherited Add(Result);
end;

{ TE1Json }

constructor TE1Json.Create(NomeModulo: String);
begin
  inherited Create;
  FModulo := NomeModulo;
  FComandos := TE1Comandos.Create;
end;

destructor TE1Json.Destroy;
begin
  FComandos.Free;
  inherited Destroy;
end;

procedure TE1Json.Clear;
begin
  FComandos.Clear;
end;

function TE1Json.GetJSON: String;
var
  i, j: Integer;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon: TJsonObject;
   JSParametro: TJsonObject;
  {$Else}
   AJSon: TJson;
   JSComandos, JSParametros: TJsonArray;
   JSParamPair: TJsonPair;
   JSParametro: TJsonValue;
  {$EndIf}
   JSComando: TJsonObject;
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon := TJsonObject.Create;
   try
     AJSon[CnModulo] := FModulo;
     for i := 0 to FComandos.Count-1 do
     begin
       JSComando := AJSon.A[CnComando].AddObject;

       JSComando[CnFuncao] := FComandos[i].Funcao;
       if FComandos[i].Parametros.Count > 0 then
       begin
         JSParametro := JSComando.A[CnParametros].AddObject;

         for j := 0 to FComandos[i].Parametros.Count-1 do
         begin
           case FComandos[i].Parametros.Items[j].Tipo of
             tiBoolean:
               JSParametro[ FComandos[i].Parametros.Items[j].Nome ] := FComandos[i].Parametros.Items[j].AsBoolean;
             tiFloat:
               JSParametro[ FComandos[i].Parametros.Items[j].Nome ] := FComandos[i].Parametros.Items[j].AsFloat;
           else
              JSParametro[ FComandos[i].Parametros.Items[j].Nome ] := FComandos[i].Parametros.Items[j].AsString;
           end;
         end;
       end;
     end;

     Result := AJSon.ToString;
   finally
     AJSon.Free;
   end;
  {$Else}
   AJSon := TJson.Create;
   try
     AJSon[CnModulo].AsString := FModulo;
     JSComandos := AJSon[CnComando].AsArray;

     for i := 0 to FComandos.Count-1 do
     begin
       JSComando := JSComandos.Add.AsObject;
       JSComando[CnFuncao].AsString := FComandos[i].Funcao;
       if FComandos[i].Parametros.Count > 0 then
       begin
         JSParametros := JSComando[CnParametros].AsArray;
         JSParametro := JSParametros.Add;

         for j := 0 to FComandos[i].Parametros.Count-1 do
         begin
           JSParamPair := JSParametro.AsObject.Add( FComandos[i].Parametros.Items[j].Nome);

           case FComandos[i].Parametros.Items[j].Tipo of
             tiBoolean: JSParamPair.Value.AsBoolean := FComandos[i].Parametros.Items[j].AsBoolean;
             tiFloat: JSParamPair.Value.AsNumber := FComandos[i].Parametros.Items[j].AsFloat;
             tiInteger, tiInt64: JSParamPair.Value.AsInteger := FComandos[i].Parametros.Items[j].AsInteger;
           else
              JSParamPair.Value.AsString := FComandos[i].Parametros.Items[j].AsString;
           end;
         end;
       end;
     end;

     Result := AJSon.Stringify;
   finally
     AJSon.Free;
   end;
  {$EndIf}
end;

procedure TE1Json.SetJSON(AValue: String);
var
  i, j, k: Integer;
  AInfo: TACBrInformacao;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon: TJsonObject;
  {$Else}
   AJSon: TJson;
   JSParamPair: TJsonPair;
  {$EndIf}
   JSComandos, JSParametros: TJsonArray;
   JSComando, JSParametro: TJsonObject;
begin
  Clear;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon := TJsonBaseObject.Parse(AValue) as TJsonObject;
   try
     FModulo := AJSon[CnModulo];
     JSComandos := AJSon.A[CnComando];

     For i := 0 to JSComandos.Count-1 do
     begin
       JSComando := JSComandos[i];
       JSParametros := JSComando.A[CnParametros];

       with FComandos.New(JSComando[CnFuncao]) do
       begin
         for j := 0 to JSParametros.Count-1 do
         begin
           JSParametro := JSParametros[j];

           for k := 0 to JSParametro.Count-1 do
           begin
             AInfo := Parametros.AddField(JSParametro.Names[k], '');
             case JSParametro.Items[k]^.Typ of
               jdtBool: AInfo.AsBoolean := JSParametro.Items[k]^.BoolValue;
               jdtInt, jdtLong, jdtULong, jdtFloat: AInfo.AsFloat := JSParametro.Items[k]^.FloatValue;
             else
               AInfo.AsString := JSParametro.Items[k]^.Value;
             end;
           end;
         end;
       end;
     end;
   finally
     AJSon.Free;
   end;
  {$Else}
   AJSon := TJson.Create;
   try
     AJSon.Parse(AValue);
     FModulo := AJSon.Values[CnModulo].AsString;
     JSComandos := AJSon.Values[CnComando].AsArray;

     For i := 0 to JSComandos.Count-1 do
     begin
       JSComando := JSComandos[i].AsObject;
       JSParametros := JSComando.Values[CnParametros].AsArray;

       with FComandos.New(JSComando.Values[CnFuncao].AsString) do
       begin
         for j := 0 to JSParametros.Count-1 do
         begin
           JSParametro := JSParametros[j].AsObject;

           for k := 0 to JSParametro.Count-1 do
           begin
             JSParamPair := JSParametro.Items[k];
             AInfo := Parametros.AddField(JSParamPair.Name, '');
             case JSParamPair.Value.ValueType of
               jvBoolean: AInfo.AsBoolean := JSParamPair.Value.AsBoolean;
               jvNumber: AInfo.AsFloat := JSParamPair.Value.AsNumber;
             else
               AInfo.AsString := JSParamPair.Value.AsString;
             end;
           end;
         end;
       end;
     end;
   finally
     AJSon.Free;
   end;
  {$EndIf}
end;

{ TACBrPosPrinterElginE1Service }

constructor TACBrPosPrinterElginE1Service.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create(AOwner);

  fE1JSon := TE1Json.Create(CmodImpressor);
  fpModeloStr := 'PosPrinterElginE1Service';
  fModelo := prnSmartPOS;
  fPastaEntradaE1 := '';
  fSeqArqE1 := 0;

  TagsNaoSuportadas.Add( cTagBarraMSI );
  TagsNaoSuportadas.Add( cTagLigaItalico );
  TagsNaoSuportadas.Add( cTagDesligaItalico );
end;

destructor TACBrPosPrinterElginE1Service.Destroy;
begin
  fE1JSon.Free;
  inherited Destroy;
end;

procedure TACBrPosPrinterElginE1Service.Configurar;
begin
  //fpPosPrinter.PaginaDeCodigo := pcNone;
  fpPosPrinter.Porta := 'NULL';
  Cmd.Clear;
  fpPosPrinter.OnEnviarStringDevice := Imprimir;
end;

procedure TACBrPosPrinterElginE1Service.AntesDecodificar(
  var ABinaryString: AnsiString);
begin
  // Troca todos Pulo de Linha, por Tag, para conseguir pegar os Blocos de impress�o em TagProcessos
  ABinaryString := StringReplace(ABinaryString, Cmd.PuloDeLinha, cTagPulodeLinha, [rfReplaceAll]);

  // Limpa o objeto com o E1JSON
  fE1JSon.Clear;

  with fE1JSon.Comandos.New('AbreConexaoImpressora') do
  begin
    Parametros.AddField('tipo').AsInteger := IfThen(fModelo=prnSmartPOS, 5, IfThen(fModelo=prnM8, 6, 1));
    Parametros.AddField('modelo').AsString := IfThen(fModelo=prnSmartPOS, 'SmartPOS', IfThen(fModelo=prnM8, 'M8', 'i9'));
    Parametros.AddField('conexao').AsString := 'USB';
    Parametros.AddField('parametro').AsInteger := 0;
  end;
end;

procedure TACBrPosPrinterElginE1Service.AdicionarBlocoResposta(
  const ConteudoBloco: AnsiString);
begin
  AddCmdImprimirTexto(ConteudoBloco);
end;

procedure TACBrPosPrinterElginE1Service.DepoisDecodificar(
  var ABinaryString: AnsiString);
begin
  fE1JSon.Comandos.New('FechaConexaoImpressora');
  ABinaryString := fE1JSon.JSON;
end;

function TACBrPosPrinterElginE1Service.TraduzirTag(const ATag: AnsiString;
  var TagTraduzida: AnsiString): Boolean;
begin
  TagTraduzida := '';

  if (ATag = cTagZera) or (ATag = cTagReset) then
    fE1JSon.Comandos.New('InicializaImpressora')

  else if ATag = cTagPuloDeLinhas then
  begin
    AddCmdPuloDeLinhas(fpPosPrinter.LinhasEntreCupons);
    Result := True;
  end

  else if ((ATag = cTagCorteParcial) or ( (ATag = cTagCorte) and (fpPosPrinter.TipoCorte = ctParcial) )) or
          ((ATag = cTagCorteTotal) or ( (ATag = cTagCorte) and (fpPosPrinter.TipoCorte = ctTotal) ) ) then
  begin
    AddCmdPuloDeLinhas(fpPosPrinter.LinhasEntreCupons);
    if fpPosPrinter.CortaPapel then
      fE1JSon.Comandos.New('Corte').Parametros.AddField('avanco').AsInteger := 0;
    Result := True;
  end

  else if ATag = cTagAbreGaveta then
  begin
    fE1JSon.Comandos.New('Corte').Parametros.AddField('avanco').AsInteger := 0;
    Result := True;
  end

  else if ATag = cTagBeep then
  begin
    with fE1JSon.Comandos.New('SinalSonoro') do
    begin
      Parametros.AddField('qtd').AsInteger := 1;
      Parametros.AddField('tempoInicio').AsInteger := 5; // seg
      Parametros.AddField('tempoFim').AsInteger := 0;
    end;
    Result := True;
  end

  else if ATag = cTagLogotipo then
  begin
    if not fpPosPrinter.ConfigLogo.IgnorarLogo then
    begin
      with fE1JSon.Comandos.New('ImprimeImagemMemoria') do
      begin
        Parametros.AddField('key').AsInteger := fpPosPrinter.ConfigLogo.KeyCode1;
        Parametros.AddField('scala').AsInteger := fpPosPrinter.ConfigLogo.FatorX;
      end;
    end;
    Result := True;
  end

  else if ATag = cTagPulodeLinha then
  begin
    AddCmdPuloDeLinhas(1);
    Result := True;
  end

  else if ATag = cTagModoPaginaLiga then
    fE1JSon.Comandos.New('ModoPagina')

  else if ATag = cTagModoPaginaDesliga then
  begin
    fE1JSon.Comandos.New('ImprimeModoPagina');
    fE1JSon.Comandos.New('ModoPadrao');
  end

  else if ATag = cTagModoPaginaImprimir then
  begin
    fE1JSon.Comandos.New('ImprimeModoPagina');
    Result := True;
  end

  else
    Result := False;
end;

function TACBrPosPrinterElginE1Service.TraduzirTagBloco(const ATag,
  ConteudoBloco: AnsiString; var BlocoTraduzido: AnsiString): Boolean;
var
  tipoCodBarras: Integer;
  ACodBar: AnsiString;
begin
  if ATag = cTagAbreGavetaEsp then
  begin
    with fE1JSon.Comandos.New('AbreGaveta') do
    begin
      Parametros.AddField('pino').AsInteger := max(min(StrToIntDef(ConteudoBloco,1),1),0);
      Parametros.AddField('ti').AsInteger := 50;
      Parametros.AddField('tf').AsInteger := 50;
    end;
    Result := True;
  end

  else if ATag = cTagQRCode then
  begin
    with fE1JSon.Comandos.New('ImpressaoQRCode') do
    begin
      Parametros.AddField('dados').AsString := ConteudoBloco;
      Parametros.AddField('tamanho').AsInteger := max(min(fpPosPrinter.ConfigQRCode.LarguraModulo, 6), 1);
      Parametros.AddField('nivelCorrecao').AsInteger := max(min(fpPosPrinter.ConfigQRCode.ErrorLevel, 4), 1);
    end;
    Result := True;
  end

  else if ATag = cTagBMP then
  begin
    if FileExists(ConteudoBloco) then
    begin
      with fE1JSon.Comandos.New('ImprimeImagemMemoria') do
      begin
        Parametros.AddField('key').AsString := ConteudoBloco;
        Parametros.AddField('scala').AsInteger := fpPosPrinter.ConfigLogo.FatorX;
      end;
    end
    else
      AddCmdImprimirTexto('Arquivo n�o encontrado: '+ConteudoBloco);

    Result := True;
  end

  else if (AnsiIndexText(ATag, cTAGS_BARRAS) >= 0) then
  begin
    tipoCodBarras := -1;
    ACodBar := ConteudoBloco;
    if (ATag = cTagBarraUPCA) then
    begin
      ACodBar := AnsiString(OnlyNumber(ConteudoBloco));
      if (Length(ACodBar) < 11) then
        ACodBar := PadLeftA(ACodBar, 11, '0');
      tipoCodBarras := 0;
    end
    else if (ATag = cTagBarraUPCE) then
    begin
      ACodBar := OnlyNumber(ConteudoBloco);
      tipoCodBarras := 1;
    end
    else if ATag = cTagBarraEAN13 then
    begin
      ACodBar := AnsiString(OnlyNumber(ConteudoBloco));
      if (Length(ACodBar) < 12) then
        ACodBar := PadLeftA(ACodBar, 12, '0');
      tipoCodBarras := 2;
    end
    else if ATag = cTagBarraEAN8 then
    begin
      ACodBar := AnsiString(OnlyNumber(ConteudoBloco));
      if (Length(ACodBar) < 7) then
        ACodBar := PadLeftA(ACodBar, 7, '0');
      tipoCodBarras := 3;
    end
    else if ATag = cTagBarraCode39 then
    begin
      ACodBar := AnsiString(OnlyCharsInSet(ConteudoBloco,
        ['0'..'9', 'A'..'Z', ' ', '$', '%', '*', '+', '-', '.', '/']));
      tipoCodBarras := 4;
    end
    else if ATag = cTagBarraInter then
    begin
      // Interleaved 2of5. Somente n�meros, Tamanho deve ser PAR
      ACodBar := AnsiString(OnlyNumber(ConteudoBloco));
      if (Length(ACodBar) mod 2) <> 0 then  // Tamanho � Par ?
        ACodBar := '0' + ACodBar;
      tipoCodBarras := 5;
    end
    else if ATag = cTagBarraCodaBar then
    begin
      // Qualquer tamanho.. Aceita: 0~9, A~D, a~d, $, +, -, ., /, :
      ACodBar := AnsiString(OnlyCharsInSet(ConteudoBloco,
        ['0'..'9', 'A'..'D', 'a'..'d', '$', '+', '-', '.', '/', ':']));
      tipoCodBarras := 6;
    end
    else if ATag = cTagBarraCode93 then
    begin
      ACodBar := AnsiString(OnlyCharsInSet(ConteudoBloco, [#0..#127]));
      tipoCodBarras := 7;
    end
    else if (ATag = cTagBarraCode128) or (ATag = cTagBarraCode128b)  then
    begin
      ACodBar := AnsiString(OnlyCharsInSet(ConteudoBloco, [#0..#127]));
      ACodBar := '{B'+ACodBar;
      tipoCodBarras := 8;
    end
    else if (ATag = cTagBarraCode128a) then
    begin
      ACodBar := AnsiString(OnlyCharsInSet(ConteudoBloco, [#0..#127]));
      ACodBar := '{A'+ACodBar;
      tipoCodBarras := 8;
    end
    else if (ATag = cTagBarraCode128c) then
    begin
      ACodBar := AnsiString(OnlyNumber(ConteudoBloco));
      if (Length(ACodBar) mod 2) <> 0 then  // Tamanho deve ser Par
        ACodBar := '0' + ACodBar;

      ACodBar := '{C'+ACodBar;
      tipoCodBarras := 8;
    end;

    if tipoCodBarras >= 0 then
    begin
      with fE1JSon.Comandos.New('ImpressaoCodigoBarras') do
      begin
        Parametros.AddField('tipo').AsInteger := tipoCodBarras;
        Parametros.AddField('dados').AsString := ACodBar;
        Parametros.AddField('altura').AsInteger := IfThen(fpPosPrinter.ConfigBarras.Altura<=0, 50, max(min(fpPosPrinter.ConfigBarras.Altura, 255), 1));
        Parametros.AddField('largura').AsInteger := IfThen(fpPosPrinter.ConfigBarras.LarguraLinha<=0, 2, max(min(fpPosPrinter.ConfigBarras.LarguraLinha, 6), 1));
        Parametros.AddField('HRI').AsInteger := IfThen(fpPosPrinter.ConfigBarras.MostrarCodigo, 2, 4);
      end;
    end
    else
      AddCmdImprimirTexto(ConteudoBloco);

    Result := True;
  end

  else
    Result := False;

  if Result then
    BlocoTraduzido := '';
end;

function TACBrPosPrinterElginE1Service.ComandoFonte(
  TipoFonte: TACBrPosTipoFonte; Ligar: Boolean): AnsiString;
begin
  Result := '';
end;

function TACBrPosPrinterElginE1Service.ComandoConfiguraModoPagina: AnsiString;
var
  direcao: Integer;
begin
  with fE1JSon.Comandos.New('DefineAreaImpressao') do
  begin
    Parametros.AddField('oHorizontal').AsInteger := fpPosPrinter.ConfigModoPagina.Esquerda;
    Parametros.AddField('oVertical').AsInteger := fpPosPrinter.ConfigModoPagina.Topo;
    Parametros.AddField('dHorizontal').AsInteger := fpPosPrinter.ConfigModoPagina.Largura;
    Parametros.AddField('dVertical').AsInteger := fpPosPrinter.ConfigModoPagina.Altura;
  end;

  case fpPosPrinter.ConfigModoPagina.Direcao of
    dirTopoParaBaixo: direcao := 3;
    dirDireitaParaEsquerda: direcao := 2;
    dirBaixoParaTopo: direcao := 1;
  else
    direcao := 0;
  end;
  fE1JSon.Comandos.New('DirecaoImpressao').Parametros.AddField('direcao').AsInteger := direcao;
  Result := '';
end;

function TACBrPosPrinterElginE1Service.ComandoPosicionaModoPagina(APoint: TPoint
  ): AnsiString;
begin
  fE1JSon.Comandos.New('PosicaoImpressaoHorizontal').Parametros.AddField('nLnH').AsInteger := APoint.X;
  fE1JSon.Comandos.New('PosicaoImpressaoVertical').Parametros.AddField('nLnH').AsInteger := APoint.Y;
  Result := '';
end;

procedure TACBrPosPrinterElginE1Service.AddCmdImprimirTexto(
  const ConteudoBloco: String);
var
  stilo, tamanho: Integer;
begin
  if (ConteudoBloco <> '') then
  begin
    with fE1JSon.Comandos.New('ImpressaoTexto') do
    begin
      Parametros.AddField('dados').AsString := ConteudoBloco;
      Parametros.AddField('posicao').AsInteger := IfThen(fpPosPrinter.Alinhamento = alDireita, 2,
                                                  IfThen(fpPosPrinter.Alinhamento = alCentro, 1, 0));

      stilo := 0;
      if (ftCondensado in fpPosPrinter.FonteStatus) or
         (ftFonteB in fpPosPrinter.FonteStatus) then
        stilo := stilo + 1;
      if ftSublinhado in fpPosPrinter.FonteStatus then
        stilo := stilo + 2;
      if ftInvertido in fpPosPrinter.FonteStatus then
        stilo := stilo + 4;
      if ftNegrito in fpPosPrinter.FonteStatus then
        stilo := stilo + 8;
      Parametros.AddField('stilo').AsInteger := stilo;

      tamanho := 0;
      if ftExpandido in fpPosPrinter.FonteStatus then
        tamanho := tamanho + 16;
      if ftAlturaDupla in fpPosPrinter.FonteStatus then
        tamanho := tamanho + 1;
      Parametros.AddField('tamanho').AsInteger := tamanho;
    end;
  end;
end;

procedure TACBrPosPrinterElginE1Service.AddCmdPuloDeLinhas(const Linhas: Integer
  );
begin
  fE1JSon.Comandos.New('AvancaPapel').
    Parametros.AddField('linhas').AsInteger := Linhas;
end;

procedure TACBrPosPrinterElginE1Service.Imprimir(const LinhasImpressao: String;
  var Tratado: Boolean);
var
  {$IfDef ANDROID}
   intentPrint: JIntent;
  {$Else}
   ArqJSON: String;
  {$EndIf}
begin
  {$IfDef ANDROID}
   FMessageSubscriptionID := TMessageManager.DefaultManager.SubscribeToMessage(TMessageResultNotification, HandleActivityMessage);

   intentPrint := TJIntent.JavaClass.init(StringToJString('com.elgin.e1.intentservice.IMPRESSAO'));
   intentPrint.putExtra(StringToJString('direta'), StringToJString(LinhasImpressao));
   TAndroidHelper.Activity.startActivityForResult(intentPrint, requestCodeImpressora);
  {$Else}
   inc(fSeqArqE1);
   if fSeqArqE1 > 999 then
     fSeqArqE1 := 1;

   if (fPastaEntradaE1 = '') then
      ArqJSON := ApplicationPath + 'in'
    else
      ArqJSON := fPastaEntradaE1;

   if not DirectoryExists(ArqJSON) then
     ForceDirectories(ArqJSON);

   ArqJSON := PathWithDelim(ArqJSON) + 'Comando' + IntToStrZero(fSeqArqE1, 3) + '.txt';
   WriteToFile(ArqJSON, LinhasImpressao);
  {$EndIf}
end;

end.

