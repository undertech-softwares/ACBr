{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020   Daniel Simoes de Almeida             }
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

unit UACBrPlataformaInstalacaoAlvo;

interface

uses SysUtils, StrUtils, Windows, Messages, Classes, Forms, Generics.Collections,
  JclIDEUtils, JclCompilerUtils;


const
  PlataformasSuportadasFull = [bpWin32, bpWin64];
  PlataformasSuportadasBeta = [bpAndroid32, bpAndroid64, bpOSX32, bpOSX64, bpLinux64];
  PlataformasSuportadas = PlataformasSuportadasFull + PlataformasSuportadasBeta;

type

  TACBrPlataformaInstalacaoAlvo = class(TObject)
  private
    { private declarations }
  public
    InstalacaoAtual: TJclBorRADToolInstallation;
    tPlatformAtual: TJclBDSPlatform;
    sPlatform: string;
    sDirLibrary: string;
    function GetDirLibrary: string;
    function EhSuportadaPeloACBr: Boolean;
    function EhSuportadaPeloACBrBeta: Boolean;
    constructor CreateNew(AInstalacao: TJclBorRADToolInstallation; UmaPlatform: TJclBDSPlatform;
          const UmasPlatform: string);
  end;

  TPlataformaDestino = TACBrPlataformaInstalacaoAlvo;

  TListaPlataformasAlvosBase = TList<TACBrPlataformaInstalacaoAlvo>;

  TListaPlataformasAlvos = class(TListaPlataformasAlvosBase)
  private
  public
    FoACBr: TJclBorRADToolInstallations;
    constructor Create;
    destructor Destroy; override;
  end;

  function GeraListaPlataformasAlvos: TListaPlataformasAlvos;


implementation

function PossuiOutrasPlataformas(UmaInstalacao: TJclBorRADToolInstallation): Boolean;
begin
  Result := (UmaInstalacao is TJclBDSInstallation) and (UmaInstalacao.IDEVersionNumber >= 9) and
            (not UmaInstalacao.IsTurboExplorer);
end;

function GeraListaPlataformasAlvos: TListaPlataformasAlvos;
var
  InstalacaoAlvo: TJclBorRADToolInstallation;
  i: Integer;
begin
  Result := TListaPlataformasAlvos.Create;
  for i := 0 to Result.FoACBr.Count - 1 do
  begin
    InstalacaoAlvo := Result.FoACBr.Installations[i];
    Result.Add(TACBrPlataformaInstalacaoAlvo.CreateNew(InstalacaoAlvo, bpWin32, BDSPlatformWin32));

    if PossuiOutrasPlataformas(InstalacaoAlvo) then
    begin
      if (bpDelphi64 in InstalacaoAlvo.Personalities) then
      begin
        InstalacaoAlvo := Result.FoACBr.Installations[i];
        Result.Add(TACBrPlataformaInstalacaoAlvo.CreateNew(InstalacaoAlvo, bpWin64, BDSPlatformWin64));
      end;

      if (bpDelphiOSX32 in InstalacaoAlvo.Personalities) then
      begin
        InstalacaoAlvo := Result.FoACBr.Installations[i];
        Result.Add(TACBrPlataformaInstalacaoAlvo.CreateNew(InstalacaoAlvo, bpOSX32, BDSPlatformOSX32));
      end;

      if (bpDelphiOSX64 in InstalacaoAlvo.Personalities) then
      begin
        InstalacaoAlvo := Result.FoACBr.Installations[i];
        Result.Add(TACBrPlataformaInstalacaoAlvo.CreateNew(InstalacaoAlvo, bpOSX64, BDSPlatformOSX64));
      end;

      if (bpDelphiAndroid32 in InstalacaoAlvo.Personalities) then
      begin
        InstalacaoAlvo := Result.FoACBr.Installations[i];
        Result.Add(TACBrPlataformaInstalacaoAlvo.CreateNew(InstalacaoAlvo, bpAndroid32, BDSPlatformAndroid32));
      end;

      if (bpDelphiAndroid64 in InstalacaoAlvo.Personalities) then
      begin
        InstalacaoAlvo := Result.FoACBr.Installations[i];
        Result.Add(TACBrPlataformaInstalacaoAlvo.CreateNew(InstalacaoAlvo, bpAndroid64, BDSPlatformAndroid64));
      end;

      if (bpDelphiLinux64 in InstalacaoAlvo.Personalities) then
      begin
        InstalacaoAlvo := Result.FoACBr.Installations[i];
        Result.Add(TACBrPlataformaInstalacaoAlvo.CreateNew(InstalacaoAlvo, bpLinux64, BDSPlatformLinux64));
      end;

    end;
  end;

end;

{ TListaPlataformasAlvos }

constructor TListaPlataformasAlvos.Create;
begin
  inherited;
  FoACBr:= TJclBorRADToolInstallations.Create;
end;

destructor TListaPlataformasAlvos.Destroy;
begin
  FoACBr.Free;
  inherited;
end;

{ TACBrPlataformaInstalacaoAlvo }

function TACBrPlataformaInstalacaoAlvo.EhSuportadaPeloACBr: Boolean;
begin
  Result := (not MatchText(InstalacaoAtual.VersionNumberStr, ['d3', 'd4', 'd5', 'd6'])) and
            (tPlatformAtual in PlataformasSuportadas);
end;

function TACBrPlataformaInstalacaoAlvo.EhSuportadaPeloACBrBeta: Boolean;
begin
  Result := (not MatchText(InstalacaoAtual.VersionNumberStr, ['d3', 'd4', 'd5', 'd6'])) and
            (tPlatformAtual in PlataformasSuportadasBeta);
end;

function TACBrPlataformaInstalacaoAlvo.GetDirLibrary: string;
begin
  Result := {OpcoesInstall.DiretorioRaizACBr + }
            'Lib\Delphi\Lib' + AnsiUpperCase(InstalacaoAtual.VersionNumberStr)+ '\' + sPlatform;
end;

constructor TACBrPlataformaInstalacaoAlvo.CreateNew(AInstalacao: TJclBorRADToolInstallation;
  UmaPlatform: TJclBDSPlatform; const UmasPlatform: string);
begin
  inherited Create;

  InstalacaoAtual := AInstalacao;
  tPlatformAtual  := UmaPlatform;
  sPlatform       := UmasPlatform;
end;

end.
