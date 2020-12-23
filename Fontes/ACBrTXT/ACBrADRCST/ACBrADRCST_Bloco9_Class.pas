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

unit ACBrADRCST_Bloco9_Class;

interface

Uses
  SysUtils, Classes, DateUtils, ACBrADRCST_Bloco9, ACBrTXTClass;

type
  { TBloco_9}
  TBloco_9 = class(TACBrTXTClass)
  private
    FRegistro9000: TRegistro9000;
    FRegistro9999: TRegistro9999;

  public
    constructor Create;
    destructor Destroy;override;
    property Registro9000 : TRegistro9000 read FRegistro9000 write FRegistro9000;

    property Registro9999 : TRegistro9999 read FRegistro9999 write FRegistro9999;

    procedure WriteRegistro9000;
    procedure WriteRegistro9999(const AQTD_LIN : integer);
  end;



implementation

{ TBloco_9 }

constructor TBloco_9.Create;
begin
  inherited Create;
  FRegistro9999 := TRegistro9999.Create;
  FRegistro9999.Incrementa;
  FRegistro9000 := TRegistro9000.Create;
  FRegistro9999.Incrementa;

end;

destructor TBloco_9.Destroy;
begin
  FRegistro9999.Destroy;
  FRegistro9000.Destroy;
  inherited Destroy;
end;

procedure TBloco_9.WriteRegistro9000;
begin
  with Registro9000 do
  begin
    Add(
        REG +
        lFill(REG1200_ICMSST_RECUPERAR_RESSARCIR, 9, 2) +
        lFill(REG1200_ICMSST_COMPLEMENTAR, 9, 2) +
        lFill(REG1300_ICMSST_RECUPERAR_RESSARCIR, 9, 2) +
        lFill(REG1400_ICMSST_RECUPERAR_RESSARCIR, 9, 2) +
        lFill(REG1500_ICMSST_RECUPERAR_RESSARCIR, 9, 2) +
        lFill(REG9000_FECOP_RESSARCIR, 9, 2) +
        lFill(REG9000_FECOP_COMPLEMENTAR, 9, 2),
        False
    );
  end;
end;

procedure TBloco_9.WriteRegistro9999(const AQTD_LIN: integer);
var
   LQTD_LIN : integer;
begin
  with Registro9999 do
  begin
    LQTD_LIN := QTD_LIN + AQTD_LIN;
    Add(
        REG +
        LFill(LQTD_LIN,4),
        False);
  end;
end;

end.
