{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro                                 }
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

unit ACBrPAF_A_Class;

interface

uses
  SysUtils, Classes, DateUtils, ACBrTXTClass, ACBrTXTUtils, ACBrPAFRegistros,
  ACBrPAF_A;

type
  TPAF_A = class(TACBrTXTClass)
  private
    FRegistroA2: TRegistroA2List;
    procedure CriaRegistros;
    procedure LiberaRegistros;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LimpaRegistros;
    procedure WriteRegistroA2(Layout: TLayoutPAF);
    property RegistroA2: TRegistroA2List read FRegistroA2 write FRegistroA2;
  end;

implementation

{ TPAF_A }

constructor TPAF_A.Create;
begin
  inherited;
  CriaRegistros;
end;

procedure TPAF_A.CriaRegistros;
begin
  FRegistroA2 := TRegistroA2List.Create;
end;

destructor TPAF_A.Destroy;
begin
  LiberaRegistros;
  inherited;
end;

procedure TPAF_A.LiberaRegistros;
begin
  FRegistroA2.Free;
end;

procedure TPAF_A.LimpaRegistros;
begin
  //Limpa os Registros
  LiberaRegistros;
  //Recriar os Registros Limpos
  CriaRegistros;
end;

function OrdenarA2(const ARegistro1, ARegistro2: Pointer): Integer;
var
  Reg1, Reg2: string;
begin
  Reg1 := FormatDateTime('YYYYMMDD', TRegistroA2(ARegistro1).DT) + Format('%-25s', [TRegistroA2(ARegistro1).MEIO_PGTO]) + Format('%-1s', [TRegistroA2(ARegistro1).TIPO_DOC]);

  Reg2 := FormatDateTime('YYYYMMDD', TRegistroA2(ARegistro2).DT) + Format('%-25s', [TRegistroA2(ARegistro2).MEIO_PGTO]) + Format('%-1s', [TRegistroA2(ARegistro2).TIPO_DOC]);

  Result := AnsiCompareText(Reg1, Reg2);
end;

procedure TPAF_A.WriteRegistroA2(Layout: TLayoutPAF);
var
  intFor: integer;
  RegistroA2: TRegistroA2;
begin
  if Assigned(FRegistroA2) then
  begin
    FRegistroA2.Sort(@OrdenarA2);

    for intFor := 0 to FRegistroA2.Count - 1 do
    begin
      RegistroA2 := FRegistroA2.Items[intFor];
      if Layout = lpPAFECF then
      begin
        Add(LFill('A2') + LFill(RegistroA2.DT, 'yyyymmdd') + RFill(RegistroA2.MEIO_PGTO, 25, IfThen(RegistroA2.RegistroValido, ' ', '?')) + RFill(RegistroA2.TIPO_DOC, 1) + LFill(RegistroA2.VL, 12, 2));
      end
      else
      begin
        Add(LFill('A2') + LFill(RegistroA2.DT, 'yyyymmdd') + RFill(RegistroA2.MEIO_PGTO, 25, IfThen(RegistroA2.RegistroValido, ' ', '?')) + RFill(RegistroA2.TIPO_DOC, 1) + LFill(RegistroA2.VL, 12, 2) + RFill(RegistroA2.CNPJ, 14) + LFill(RegistroA2.NUMDOCUMENTO, 10));
      end;
    end;
  end;
end;

end.

