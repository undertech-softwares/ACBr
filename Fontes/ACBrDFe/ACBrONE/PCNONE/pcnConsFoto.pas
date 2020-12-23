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

unit pcnConsFoto;

interface

uses
  SysUtils, Classes, pcnAuxiliar, pcnConversao, pcnGerador, ACBrUtil,
  pcnConsts, pcnONEConsts;

type

  TConsFoto = class
  private
    FGerador: TGerador;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FNSULeitura: String;
    FVersao: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;

    property Gerador: TGerador       read FGerador    write FGerador;
    property tpAmb: TpcnTipoAmbiente read FtpAmb      write FtpAmb;
    property verAplic: String        read FverAplic   write FverAplic;
    property NSULeitura: String      read FNSULeitura write FNSULeitura;
    property Versao: String          read FVersao     write FVersao;
  end;

implementation

{ TConsFoto }

constructor TConsFoto.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TConsFoto.Destroy;
begin
  FGerador.Free;

  inherited;
end;

function TConsFoto.GerarXML: Boolean;
var
  sNSULei: string;
begin
  Gerador.ArquivoFormatoXML := '';

  sNSULei := IntToStrZero(StrToInt64Def(NSULeitura, 0), 15);

  Gerador.wGrupo('oneConsFoto ' + NAME_SPACE_ONE + ' versao="' + Versao + '"');

  Gerador.wCampo(tcStr, 'EP03', 'tpAmb     ', 01, 01, 1, tpAmbToStr(tpAmb), DSC_TPAMB);
  Gerador.wCampo(tcStr, 'EP04', 'verAplic  ', 01, 20, 1, verAplic, DSC_verAplic);
  Gerador.wCampo(tcStr, 'EP05', 'NSULeitura', 15, 15, 1, sNSULei, DSC_NSULeitura);

  Gerador.wGrupo('/oneConsFoto');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

