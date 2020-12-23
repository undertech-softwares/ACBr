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

unit pcnEnvManutencaoEQP;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  pcnConversao, pcnGerador, pcnConsts, 
  pcnConversaoONE, pcnONEConsts;

type
  { TManutencaoEQP }

  TManutencaoEQP = class(TObject)
  private
    FGerador: TGerador;

    FVersao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FtpMan: TtpMan;
    FdhReg: TDateTime;
    FCNPJOper: String;
    FcEQP: String;
    FxEQP: String;
    FcUF: Integer;
    FtpSentido: TtpSentido;
    Flatitude: Double;
    Flongitude: Double;
    FtpEQP: TtpEQP;
    FxRefCompl: String;

  public
    constructor Create;
    destructor Destroy; override;

    function GerarXML: Boolean;
    function LerXML(const CaminhoArquivo: String): Boolean;
    function LerXMLFromString(const AXML: String): Boolean;
    function LerFromIni(const AIniString: String): Boolean;
    function ObterNomeArquivo: String;

    property Gerador: TGerador       read FGerador   write FGerador;
    property Versao: String          read FVersao    write FVersao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb     write FtpAmb;
    property verAplic: String        read FverAplic  write FverAplic;
    property tpMan: TtpMan           read FtpMan     write FtpMan;
    property dhReg: TDateTime        read FdhReg     write FdhReg;
    property CNPJOper: String        read FCNPJOper  write FCNPJOper;
    property cEQP: String            read FcEQP      write FcEQP;
    property xEQP: String            read FxEQP      write FxEQP;
    property cUF: Integer            read FcUF       write FcUF;
    property tpSentido: TtpSentido   read FtpSentido write FtpSentido;
    property latitude: Double        read Flatitude  write Flatitude;
    property longitude: Double       read Flongitude write Flongitude;
    property tpEQP: TtpEQP           read FtpEQP     write FtpEQP;
    property xRefCompl: String       read FxRefCompl write FxRefCompl;
  end;

implementation

uses
  IniFiles,
  pcnAuxiliar, pcnRetManutencaoEQP,
  ACBrUtil, ACBrDFeUtil;

{ TManutencaoEQP }

constructor TManutencaoEQP.Create;
begin
  inherited Create;

  FGerador := TGerador.Create;
end;

destructor TManutencaoEQP.Destroy;
begin
  FGerador.Free;

  inherited;
end;

function TManutencaoEQP.GerarXML: Boolean;
var
 sEQP: string;
begin
  Gerador.ArquivoFormatoXML := '';

  sEQP := IntToStrZero(StrToInt64Def(FcEQP, 0), 15);

  Gerador.wGrupo('oneManEQP ' + NAME_SPACE_ONE + ' versao="' + Versao + '"');

  Gerador.wCampo(tcStr, 'AP03', 'tpAmb    ', 01, 001, 1, TpAmbToStr(FtpAmb), DSC_TPAMB);
  Gerador.wCampo(tcStr, 'AP04', 'verAplic ', 01, 020, 1, FverAplic, DSC_verAplic);
  Gerador.wCampo(tcStr, 'AP05', 'tpMan    ', 01, 001, 1, TpManToStr(FtpMan), DSC_tpMan);
  Gerador.wCampo(tcStr, 'AP06', 'dhReg    ', 01, 050, 1, FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', FdhReg) +
                                                           GetUTC(CodigoParaUF(FcUF), FdhReg));
  Gerador.wCampo(tcStr, 'AP07', 'CNPJOper ', 01, 014, 1, FCNPJOper, DSC_CNPJOper);
  Gerador.wCampo(tcStr, 'AP08', 'cEQP     ', 01, 015, 1, sEQP, DSC_cEQP);
  Gerador.wCampo(tcStr, 'AP09', 'xEQP     ', 01, 050, 1, FxEQP, DSC_xEQP);
  Gerador.wCampo(tcInt, 'AP10', 'cUF      ', 01, 002, 1, FcUF, DSC_cUF);
  Gerador.wCampo(tcStr, 'AP11', 'tpSentido', 01, 001, 1, TpSentidoToStr(FtpSentido), DSC_tpSentido);
  Gerador.wCampo(tcDe6, 'AP12', 'latitude ', 01, 010, 1, Flatitude, DSC_latitude);
  Gerador.wCampo(tcDe6, 'AP13', 'longitude', 01, 010, 1, Flongitude, DSC_longitude);
  Gerador.wCampo(tcStr, 'AP14', 'tpEQP    ', 01, 001, 1, TpEQPToStr(FtpEQP), DSC_tpEQP);
  Gerador.wCampo(tcStr, 'AP15', 'xRefCompl', 02, 200, 0, xRefCompl, DSC_xREFCOMPL);

  Gerador.wGrupo('/oneManEQP');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

function TManutencaoEQP.LerFromIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  sSecao: String;
  ok: Boolean;
begin
  Result := True;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    sSecao := 'MANUTENCAO';
    if INIRec.SectionExists(sSecao) then
    begin
      verAplic  := INIRec.ReadString(sSecao, 'verAplic', '');
      tpMan     := StrToTpMan(ok, INIRec.ReadString(sSecao, 'tpMan', '1'));
      dhReg     := StringToDateTime(INIRec.ReadString(sSecao, 'dhReg', ''));
      CNPJOper  := INIRec.ReadString(sSecao, 'CNPJOper', '');
      cEQP      := INIRec.ReadString(sSecao, 'cEQP', '');
      xEQP      := INIRec.ReadString(sSecao, 'xEQP', '');
      cUF       := INIRec.ReadInteger(sSecao, 'cUF', 0);
      tpSentido := StrTotpSentido(ok,INIRec.ReadString(sSecao, 'tpSentido', 'E'));
      latitude  := INIRec.ReadFloat(sSecao, 'latitude', 0);
      longitude := INIRec.ReadFloat(sSecao, 'longitude', 0);
      tpEQP     := StrTotpEQP(ok,INIRec.ReadString(sSecao, 'tpEQP', '1'));
    end;
  finally
    INIRec.Free;
  end;
end;

function TManutencaoEQP.LerXML(const CaminhoArquivo: String): Boolean;
var
  ArqXML: TStringList;
begin
  ArqXML := TStringList.Create;
  try
     ArqXML.LoadFromFile(CaminhoArquivo);
     Result := LerXMLFromString(ArqXML.Text);
  finally
     ArqXML.Free;
  end;
end;

function TManutencaoEQP.LerXMLFromString(const AXML: String): Boolean;
var
  RetManutencaoEQP : TRetManutencaoEQP;
begin
  RetManutencaoEQP := TRetManutencaoEQP.Create;

  try
    RetManutencaoEQP.Leitor.Arquivo := AXML;
    Result := RetManutencaoEQP.LerXml;
    {
    verAplic  := RetManutencaoEQP.verAplic;
    tpMan     := RetManutencaoEQP.tpMan;
    dhReg     := RetManutencaoEQP.dhReg;
    CNPJOper  := RetManutencaoEQP.CNPJOper;
    cEQP      := RetManutencaoEQP.cEQP;
    xEQP      := RetManutencaoEQP.xEQP;
    cUF       := RetManutencaoEQP.cUF;
    tpSentido := RetManutencaoEQP.tpSentido;
    latitude  := RetManutencaoEQP.latitude;
    longitude := RetManutencaoEQP.longitude;
    tpEQP     := RetManutencaoEQP.tpEQP;
    }
  finally
    RetManutencaoEQP.Free;
  end;
end;

function TManutencaoEQP.ObterNomeArquivo: String;
begin
  Result := FormatDateTime('yyyymmddhhnnss', dhReg) + '-man.xml';
end;

end.
