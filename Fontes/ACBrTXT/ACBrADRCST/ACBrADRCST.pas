{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Ribamar M. Santos                               }
{                              Juliomar Marchetti                              }
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

unit ACBrADRCST;

interface

uses
  SysUtils,
  Classes,
  ACBrBase,
     {$IFNDEF NOGUI}
      {$IFDEF FPC}
       LResources,
      {$ENDIF}
     {$ENDIF}
  ACBrTXTClass,
  ACBrADRCST_Bloco0_Class,
  ACBrADRCST_Bloco1_Class,
  ACBrADRCST_Bloco9_Class,

  ACBrADRCSTConversao;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}

  { TACBrADRCST }

  TACBrADRCST = class(TACBrComponent)
  private
    FLayout : TADRCSTLayout;
    FACBrTXT: TACBrTXTClass;
    FArquivo: ansistring;
    FInicializado: boolean;
    FOnError: TErrorEvent;

    FPath: ansistring;
    FDelimitador: ansistring;
    FTrimString: boolean;          // Retorna a string sem espa�os em branco iniciais e finais
    FCurMascara: ansistring;       // Mascara para valores tipo currency

    fBloco_0: TBloco_0;
    fBloco_1: TBloco_1;
    fBloco_9: TBloco_9;

    function GetConteudo: TStringList;
    function GetDelimitador: ansistring;
    function GetLinhasBuffer: integer;
    function GetTrimString: boolean;
    function GetCurMascara: ansistring;
    procedure InicializaBloco(Bloco: TACBrTXTClass);
    procedure SetArquivo(const Value: ansistring);
    procedure SetDelimitador(const Value: ansistring);
    procedure SetLinhasBuffer(const Value: integer);
    procedure SetPath(const Value: ansistring);
    procedure SetTrimString(const Value: boolean);
    procedure SetCurMascara(const Value: ansistring);

    function GetOnError: TErrorEvent;
    procedure SetOnError(const Value: TErrorEvent);

  protected
    /// BLOCO 0
    procedure WriteRegistro0000;

    /// BLOCO 1
    procedure WriteRegistro1000;

    /// BLOCO 9
    procedure WriteRegistro9000;
    procedure WriteRegistro9999;

  public
    constructor Create(AOwner: TComponent); override; /// Create
    destructor Destroy; override;

    procedure SaveFileTXT;

    procedure IniciaGeracao;
    procedure WriteBloco_0;
    procedure WriteBloco_1;
    procedure WriteBloco_9;

    property Conteudo: TStringList read GetConteudo;

    property Bloco_0: TBloco_0 read fBloco_0 write fBloco_0;
    property Bloco_1: TBloco_1 read fBloco_1 write fBloco_1;
    property Bloco_9: TBloco_9 read fBloco_9 write fBloco_9;
  published

    property Layout : TADRCSTLayout read FLayout write FLayout default lyADRCST;
    property Path: ansistring read fPath write SetPath;
    property Arquivo: ansistring read FArquivo write SetArquivo;
    property LinhasBuffer: integer read GetLinhasBuffer write SetLinhasBuffer default 1000;
    property Delimitador: ansistring read GetDelimitador write SetDelimitador;
    property TrimString: boolean read GetTrimString write SetTrimString;
    property CurMascara: ansistring read GetCurMascara write SetCurMascara;

    property OnError: TErrorEvent read GetOnError write SetOnError;

  end;

implementation

Uses
  DateUtils, ACBrUtil;

{$IFNDEF FPC}
 {$R ACBrADRCST.dcr}
{$ENDIF}

{ TACBrADRCST }

constructor TACBrADRCST.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FLayout := lyADRCST;

  fACBrTXT := TACBrTXTClass.Create;
  fACBrTXT.LinhasBuffer := 1000;

  fInicializado := False;

  fBloco_0 := TBloco_0.Create;
  fBloco_1 := TBloco_1.Create;
  fBloco_9 := TBloco_9.Create;

  FPath := ExtractFilePath(ParamStr(0));
  FDelimitador := '|';
  FCurMascara := '#0.00';
  FTrimString := True;
end;

destructor TACBrADRCST.Destroy;
begin
  fACBrTXT.Free;

  fBloco_0.Free;
  fBloco_1.Free;
  fBloco_9.Free;

  inherited;
end;

function TACBrADRCST.GetConteudo: TStringList;
begin
  Result := FACBrTXT.Conteudo;
end;

function TACBrADRCST.GetCurMascara: ansistring;
begin
  Result := FCurMascara;
end;

function TACBrADRCST.GetDelimitador: ansistring;
begin
  Result := fDelimitador;
end;

function TACBrADRCST.GetLinhasBuffer: integer;
begin
  Result := fACBrTXT.LinhasBuffer;
end;

function TACBrADRCST.GetOnError: TErrorEvent;
begin
  Result := FOnError;
end;

function TACBrADRCST.GetTrimString: boolean;
begin
  Result := FTrimString;
end;

procedure TACBrADRCST.IniciaGeracao;
begin
  if fInicializado then
    exit;

  if (Trim(fArquivo) = '') or (Trim(fPath) = '') then
    raise Exception.Create(ACBrStr('Caminho ou nome do arquivo n�o informado!'));

  fACBrTXT.NomeArquivo := FPath + FArquivo;
  {Apaga o Arquivo existente e limpa mem�ria}
  fACBrTXT.Reset;
  if Layout = lyADRCST  then
  begin
    InicializaBloco(Bloco_0);
    InicializaBloco(Bloco_1);
    InicializaBloco(Bloco_9);
  end;
  fInicializado := True;
end;

procedure TACBrADRCST.InicializaBloco(Bloco: TACBrTXTClass);
begin
  Bloco.NomeArquivo := FACBrTXT.NomeArquivo;
  Bloco.LinhasBuffer := FACBrTXT.LinhasBuffer;
  //Bloco.Gravado := False;
  Bloco.Conteudo.Clear;
end;

procedure TACBrADRCST.SaveFileTXT;
begin
  try
    IniciaGeracao;
    if Layout = lyADRCST  then
    begin
      WriteBloco_0;
      WriteBloco_1;
      WriteBloco_9;
    end;
  finally
    fACBrTXT.Conteudo.Clear;
    fInicializado := False;
  end;
end;

procedure TACBrADRCST.SetArquivo(const Value: ansistring);
var
  aPath: ansistring;
begin
  if fArquivo = Value then
    exit;

  fArquivo := ExtractFileName(Value);
  aPath := ExtractFilePath(Value);

  if aPath <> '' then
    Path := aPath;
end;

procedure TACBrADRCST.SetCurMascara(const Value: ansistring);
begin
  fCurMascara := Value;

  fBloco_0.CurMascara := Value;
  fBloco_1.CurMascara := Value;
  fBloco_9.CurMascara := Value;
end;

procedure TACBrADRCST.SetDelimitador(const Value: ansistring);
begin
  fDelimitador := Value;

  fBloco_0.Delimitador := Value;
  fBloco_1.Delimitador := Value;
  fBloco_9.Delimitador := Value;
end;

procedure TACBrADRCST.SetLinhasBuffer(const Value: integer);
begin
  fACBrTXT.LinhasBuffer := Value;
end;

procedure TACBrADRCST.SetOnError(const Value: TErrorEvent);
begin
  fOnError := Value;

  fBloco_0.OnError := Value;
  fBloco_1.OnError := Value;
  fBloco_9.OnError := Value;
end;

procedure TACBrADRCST.SetPath(const Value: ansistring);
begin
  fPath := PathWithDelim(Value);
end;

procedure TACBrADRCST.SetTrimString(const Value: boolean);
begin
  fTrimString := Value;

  fBloco_0.TrimString := Value;
  fBloco_1.TrimString := Value;
  fBloco_9.TrimString := Value;
end;

procedure TACBrADRCST.WriteBloco_0;
begin
  //if Bloco_0.Gravado then
    //Exit;

  if not FInicializado then
    raise Exception.Create('M�todos "IniciaGeracao" n�o foi executado');

  /// BLOCO 0
  WriteRegistro0000;

  Bloco_0.WriteBuffer;
  Bloco_0.Conteudo.Clear;
  //Bloco_0.Gravado := True;
end;

procedure TACBrADRCST.WriteBloco_1;
begin
  WriteRegistro1000;

  Bloco_1.WriteBuffer;
  Bloco_1.Conteudo.Clear;
end;

procedure TACBrADRCST.WriteBloco_9;
begin
  //if Bloco_9.Gravado then
    //exit;


  /// BLOCO 9
  WriteRegistro9000;
  WriteRegistro9999;

  Bloco_9.WriteBuffer;
  Bloco_9.Conteudo.Clear;
  //Bloco_9.Gravado := True;
end;

procedure TACBrADRCST.WriteRegistro0000;
begin
  Bloco_0.WriteRegistro0000;
end;

procedure TACBrADRCST.WriteRegistro9000;
begin
  Bloco_9.WriteRegistro9000;
end;

procedure TACBrADRCST.WriteRegistro9999;
begin
  Bloco_9.WriteRegistro9999(Bloco_1.Registro1999.QTD_LIN);
end;

procedure TACBrADRCST.WriteRegistro1000;
begin
  Bloco_1.WriteRegistro1000;
end;

{$IFNDEF NOGUI}
 {$IFDEF FPC}
initialization
	{$i ACBrADRCST.lrs}
 {$ENDIF}
{$ENDIF}

end.
