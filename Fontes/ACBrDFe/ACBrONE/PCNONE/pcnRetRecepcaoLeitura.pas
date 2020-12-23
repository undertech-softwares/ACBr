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

unit pcnRetRecepcaoLeitura;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  pcnConversao, pcnLeitor;

type
  { TRetRecepcaoLeitura }

  TRetRecepcaoLeitura = class(TObject)
  private
    FLeitor: TLeitor;

    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FdhResp: TDateTime;
    FNSU: String;
    FindMDFeAberto: Integer;
    FXML: AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;

    property Leitor: TLeitor         read FLeitor        write FLeitor;
    property versao: String          read Fversao        write Fversao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb         write FtpAmb;
    property verAplic: String        read FverAplic      write FverAplic;
    property cStat: Integer          read FcStat         write FcStat;
    property xMotivo: String         read FxMotivo       write FxMotivo;
    property dhResp: TDateTime       read FdhResp        write FdhResp;
    property NSU: String             read FNSU           write FNSU;
    property indMDFeAberto: Integer  read FindMDFeAberto write FindMDFeAberto;
    property XML: AnsiString         read FXML           write FXML;
  end;

implementation

uses
  pcnConversaoONE;

{ TRetRecepcaoLeitura }

constructor TRetRecepcaoLeitura.Create;
begin
  inherited;

  FLeitor := TLeitor.Create;
end;

destructor TRetRecepcaoLeitura.Destroy;
begin
  FLeitor.Free;

  inherited;
end;

function TRetRecepcaoLeitura.LerXml: Boolean;
var
  ok: Boolean;
begin
  Result := False;

  try
    if (Leitor.rExtrai(1, 'retOneRecepLeitura') <> '') then
    begin
      Fversao        := Leitor.rAtributo('versao');
      FtpAmb         := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
      FverAplic      := Leitor.rCampo(tcStr, 'verAplic');
      FcStat         := Leitor.rCampo(tcInt, 'cStat');
      FxMotivo       := Leitor.rCampo(tcStr, 'xMotivo');
      FdhResp        := Leitor.rCampo(tcDatHor, 'dhResp');
      FNSU           := Leitor.rCampo(tcStr, 'NSU');
      FindMDFeAberto := Leitor.rCampo(tcInt, 'indMDFeAberto');

      Result := True;
    end;

    if (Leitor.rExtrai(1, 'oneRecepLeitura') <> '') then
    begin
      {
      i := 0;
      while Leitor.rExtrai(2, 'infEvento', '', i + 1) <> '' do
       begin
         FretEvento.New;

         FretEvento.Items[i].FRetInfEvento.XML := Leitor.Grupo;

         FretEvento.Items[i].FRetInfEvento.Id         := Leitor.rAtributo('Id');
         FretEvento.Items[i].FRetInfEvento.tpAmb      := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
         FretEvento.Items[i].FRetInfEvento.verAplic   := Leitor.rCampo(tcStr, 'verAplic');
         FretEvento.Items[i].FRetInfEvento.cOrgao     := Leitor.rCampo(tcInt, 'cOrgao');
         FretEvento.Items[i].FRetInfEvento.cStat      := Leitor.rCampo(tcInt, 'cStat');
         FretEvento.Items[i].FRetInfEvento.xMotivo    := Leitor.rCampo(tcStr, 'xMotivo');

         FretEvento.Items[i].FRetInfEvento.chONE      := Leitor.rCampo(tcStr, 'chONE');
         // Alterado a fun��o de conversao
         FretEvento.Items[i].FRetInfEvento.tpEvento   := StrToTpEventoONE(ok, Leitor.rCampo(tcStr, 'tpEvento'));
         FretEvento.Items[i].FRetInfEvento.xEvento    := Leitor.rCampo(tcStr, 'xEvento');
         FretEvento.Items[i].FRetInfEvento.nSeqEvento := Leitor.rCampo(tcInt, 'nSeqEvento');
         FretEvento.Items[i].FRetInfEvento.dhRegEvento := Leitor.rCampo(tcDatHor, 'dhRegEvento');
         FretEvento.Items[i].FRetInfEvento.nProt       := Leitor.rCampo(tcStr, 'nProt');

         FretEvento.Items[i].FRetInfEvento.CNPJDest   := Leitor.rCampo(tcStr, 'CNPJDest');

         if FretEvento.Items[i].FRetInfEvento.CNPJDest = '' then
           FretEvento.Items[i].FRetInfEvento.CNPJDest  := Leitor.rCampo(tcStr, 'CPFDest');

         FretEvento.Items[i].FRetInfEvento.emailDest   := Leitor.rCampo(tcStr, 'emailDest');
         FretEvento.Items[i].FRetInfEvento.cOrgaoAutor := Leitor.rCampo(tcInt, 'cOrgaoAutor');

         j := 0;
         while  Leitor.rExtrai(3, 'chONEPend', '', j + 1) <> '' do
          begin
            FretEvento.Items[i].FRetInfEvento.chONEPend.New;

            FretEvento.Items[i].FRetInfEvento.chONEPend[j].ChavePend := Leitor.rCampo(tcStr, 'chONEPend');

            inc(j);
          end;

         inc(i);
       end;
      }
      Result := True;
    end;
  except
    Result := False;
  end;
end;

end.
