{******************************************************************************}
{ Projeto: Componente ACBrReinf                                                }
{  Biblioteca multiplataforma de componentes Delphi para envio de eventos do   }
{ Reinf                                                                        }

{ Direitos Autorais Reservados (c) 2017 Leivio Ramos de Fontenele              }
{                                                                              }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }


{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Leivio Ramos de Fontenele  -  leivio@yahoo.com.br                            }
{******************************************************************************}

{$I ACBr.inc}

unit pcnReinfConsulta;

interface

uses
  SysUtils, Classes, pcnConversao, pcnConversaoReinf, pcnGerador, pcnConsts;

type

  TReinfConsulta = class(TObject)
  private
    FGerador: TGerador;
    FSoapEnvelope: String;

    FTipoEvento: TTipoEvento;
    FtpInscContrib: String;
    FnrInscContrib: String;
    FtpInscEstab: String;
    FnrInscEstab: String;
    FperApur: String;
    FcnpjPrestador: String;
    FtpInscTomador: String;
    FnrInscTomador: String;
    FdtApur: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;

    property Gerador: TGerador       read FGerador       write FGerador;
    property SoapEnvelope: String    read FSoapEnvelope  write FSoapEnvelope;

    property TipoEvento: TTipoEvento read FTipoEvento    write FTipoEvento;
    property nrInscContrib: String   read FnrInscContrib write FnrInscContrib;
    property nrInscEstab: String     read FnrInscEstab   write FnrInscEstab;
    property perApur: String         read FperApur       write FperApur;
    property cnpjPrestador: String   read FcnpjPrestador write FcnpjPrestador;
    property nrInscTomador: String   read FnrInscTomador write FnrInscTomador;
    property dtApur: TDateTime       read FdtApur        write FdtApur;
  end;

implementation

Uses pcnAuxiliar;

{ TReinfConsulta }

constructor TReinfConsulta.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TReinfConsulta.Destroy;
begin
  FGerador.Free;

  inherited;
end;

function TReinfConsulta.GerarXML: Boolean;
var
  tpEvento: string;
begin
  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo           := 'v1:';
  tpEvento := Copy(TipoEventoToStr(TipoEvento), 3, 4);

  if Length(nrInscContrib) = 14 then
  begin
    nrInscContrib := Copy( nrInscContrib, 1, 8 );
    FtpInscContrib := '1';
  end
  else
    FtpInscContrib := '2';

  if Length(nrInscEstab) = 14 then
  begin
    FtpInscEstab := '1';
  end
  else
    FtpInscEstab := '2';

  if Length(nrInscTomador) = 14 then
  begin
    FtpInscTomador := '1';
  end
  else
    FtpInscTomador := '2';

  Gerador.wGrupo('consultar ' + SoapEnvelope);
  {
  Esta sendo usado o wCampoNFSe pois as tags devem ser geradas com prefixo.
  }
  // Os 3 campos abaixos atende os Eventos: R-1000, R-1070

  Gerador.wCampoNFSe(tcStr, 'C02', 'tipoEvento', 04, 04, 1, tpEvento, 'XXX');
  // tpInsc e nrInsc � do Contribuinte
  Gerador.wCampoNFSe(tcInt, 'C03', 'tpInsc    ', 01, 01, 1, FtpInscContrib, 'XXX');
  Gerador.wCampoNFSe(tcStr, 'C05', 'nrInsc    ', 11, 14, 1, nrInscContrib, 'XXX');

  case TipoEvento of
    teR2010:
      begin
        Gerador.wCampoNFSe(tcStr, 'C06', 'perApur      ', 07, 07, 1, perApur, 'XXX');
        // tpInscEstab e nrInscEstab � do Estabelecimento
        Gerador.wCampoNFSe(tcStr, 'C07', 'tpInscEstab  ', 01, 01, 1, FtpInscEstab, 'XXX');
        Gerador.wCampoNFSe(tcStr, 'C08', 'nrInscEstab  ', 11, 14, 1, nrInscEstab, 'XXX');
        // cnpjPrestador � do Prestador de Servi�o
        Gerador.wCampoNFSe(tcStr, 'C09', 'cnpjPrestador', 11, 14, 1, cnpjPrestador, 'XXX');
      end;

    teR2020:
      begin
        Gerador.wCampoNFSe(tcStr, 'C06', 'perApur         ', 07, 07, 1, perApur, 'XXX');
        // nrInscEstabPrest � do Estabelecimento
        Gerador.wCampoNFSe(tcStr, 'C07', 'nrInscEstabPrest', 11, 14, 1, nrInscEstab, 'XXX');
        // tpInscTomador e nrInscTomador � do Tomador
        Gerador.wCampoNFSe(tcStr, 'C07', 'tpInscTomador   ', 01, 01, 1, FtpInscTomador, 'XXX');
        Gerador.wCampoNFSe(tcStr, 'C09', 'nrInscTomador   ', 11, 14, 1, nrInscTomador, 'XXX');
      end;

    teR2030,
    teR2040,
    teR2050:
      begin
        Gerador.wCampoNFSe(tcStr, 'C06', 'perApur    ', 07, 07, 1, perApur, 'XXX');
        // nrInscEstabPrest � do Estabelecimento
        Gerador.wCampoNFSe(tcStr, 'C07', 'nrInscEstab', 11, 14, 1, nrInscEstab, 'XXX');
      end;

    teR2060:
      begin
        Gerador.wCampoNFSe(tcStr, 'C06', 'perApur      ', 07, 07, 1, perApur, 'XXX');
        // tpInscEstab e nrInscEstab � do Estabelecimento
        Gerador.wCampoNFSe(tcStr, 'C07', 'tpInscEstab  ', 01, 01, 1, FtpInscEstab, 'XXX');
        Gerador.wCampoNFSe(tcStr, 'C08', 'nrInscEstab  ', 11, 14, 1, nrInscEstab, 'XXX');
      end;

    teR2098,
    teR2099:
      begin
        Gerador.wCampoNFSe(tcStr, 'C06', 'perApur', 07, 07, 1, perApur, 'XXX');
      end;

    teR3010:
      begin
        Gerador.wCampoNFSe(tcDat, 'C06', 'dtApur     ', 10, 10, 1, dtApur, 'XXX');
        // nrInscEstab � do Estabelecimento
        Gerador.wCampoNFSe(tcStr, 'C08', 'nrInscEstab', 11, 14, 1, nrInscEstab, 'XXX');
      end;
  end;

  Gerador.wGrupo('/consultar');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

