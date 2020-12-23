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

unit pcnConversaoONE;

interface

uses
  SysUtils, StrUtils, Classes,
  pcnConversao;

type
  TVersaoONE = (ve200);

  TStatusACBrONE = (stIdleONE, stManutencao, stRecepcaoLeitura,
                    stDistLeitura, stConsFoto);

  TLayOutONE = (LayManutencao, LayRecepcaoLeitura, LayDistLeitura, LayConsFoto);

  TSchemaONE = (schErro, schONEManutencaoEQP, schONERecepcaoLeitura,
                schONEDistLeitura, schONEConsFoto);

  TtpMan = (tmCadastramento, tmAlteracao, tmDesativacao, tmReativacao);

  TtpSentido = (tsEntrada, tsSaida, tsIndeterminado);

  TtpEQP = (teSLD, teOCR);

  TtpTransm = (ttNormal, ttRetransmissao, ttAtrasoProcessamento);

  TtpVeiculo = (tvCarga, tvPassageiro, tvPasseio);

  TtpDist = (tdUFMDFe, tdEquipamento, tdOperador, tdUFCaptura);

  TtpLeitura = (tlSLD, tlOCR);

function StrToVersaoONE(out ok: Boolean; const s: String): TVersaoONE;
function VersaoONEToStr(const t: TVersaoONE): String;

function DblToVersaoONE(out ok: Boolean; const d: Real): TVersaoONE;
function VersaoONEToDbl(const t: TVersaoONE): Real;

function LayOutToSchema(const t: TLayOutONE): TSchemaONE;

function SchemaONEToStr(const t: TSchemaONE): String;
function StrToSchemaONE(const s: String): TSchemaONE;

function LayOutONEToServico(const t: TLayOutONE): String;
function ServicoToLayOutONE(out ok: Boolean; const s: String): TLayOutONE;

function StrToTpEventoONE(out ok: boolean; const s: string): TpcnTpEvento;

function tpManToStr(const t: TtpMan): String;
function StrTotpMan(out ok: Boolean; const s: String): TtpMan;

function tpSentidoToStr(const t: TtpSentido): String;
function StrTotpSentido(out ok: Boolean; const s: String): TtpSentido;

function tpEQPToStr(const t: TtpEQP): String;
function StrTotpEQP(out ok: Boolean; const s: String): TtpEQP;

function tpTransmToStr(const t: TtpTransm): String;
function StrTotpTransm(out ok: Boolean; const s: String): TtpTransm;

function tpVeiculoToStr(const t: TtpVeiculo): String;
function StrTotpVeiculo(out ok: Boolean; const s: String): TtpVeiculo;

function tpDistToStr(const t: TtpDist): String;
function StrTotpDist(out ok: Boolean; const s: String): TtpDist;

function tpLeituraToStr(const t: TtpLeitura): String;
function StrTotpLeitura(out ok: Boolean; const s: String): TtpLeitura;

implementation

uses
  typinfo;

function StrToVersaoONE(out ok: Boolean; const s: String): TVersaoONE;
begin
  Result := StrToEnumerado(ok, s, ['2.00'], [ve200]);
end;

function VersaoONEToStr(const t: TVersaoONE): String;
begin
  Result := EnumeradoToStr(t, ['2.00'], [ve200]);
end;

function DblToVersaoONE(out ok: Boolean; const d: Real): TVersaoONE;
begin
  ok := True;

  if (d = 2.0)  then
    Result := ve200
  else
  begin
    Result := ve200;
    ok := False;
  end;
end;

function VersaoONEToDbl(const t: TVersaoONE): Real;
begin
  case t of
    ve200: Result := 2.00;
  else
    Result := 0;
  end;
end;

function LayOutToSchema(const t: TLayOutONE): TSchemaONE;
begin
  case t of
    LayManutencao:       Result := schONEManutencaoEQP;
    LayRecepcaoLeitura:  Result := schONERecepcaoLeitura;
    LayDistLeitura:      Result := schONEDistLeitura;
    LayConsFoto:         Result := schONEConsFoto;
  else
    Result := schErro;
  end;
end;

function SchemaONEToStr(const t: TSchemaONE): String;
begin
  Result := GetEnumName(TypeInfo(TSchemaONE), Integer( t ) );
  Result := copy(Result, 4, Length(Result)); // Remove prefixo "sch"
end;

function StrToSchemaONE(const s: String): TSchemaONE;
var
  P: Integer;
  SchemaStr: String;
  CodSchema: Integer;
begin
  P := pos('_', s);
  if p > 0 then
    SchemaStr := copy(s, 1, P-1)
  else
    SchemaStr := s;

  if LeftStr(SchemaStr, 3) <> 'sch' then
    SchemaStr := 'sch' + SchemaStr;

  CodSchema := GetEnumValue(TypeInfo(TSchemaONE), SchemaStr );

  if CodSchema = -1 then
  begin
    raise Exception.Create(Format('"%s" n�o � um valor TSchemaANe v�lido.',[SchemaStr]));
  end;

  Result := TSchemaONE( CodSchema );
end;

function LayOutONEToServico(const t: TLayOutONE): String;
begin
  Result := EnumeradoToStr(t,
    ['ONEManutencaoEQP', 'ONERecepcaoLeitura', 'ONEDistLeitura', 'ONEConsFoto'],
    [LayManutencao, LayRecepcaoLeitura, LayDistLeitura, LayConsFoto] );
end;

function ServicoToLayOutONE(out ok: Boolean; const s: String): TLayOutONE;
begin
  Result := StrToEnumerado(ok, s,
    ['ONEManutencaoEQP', 'ONERecepcaoLeitura', 'ONEDistLeitura', 'ONEConsFoto'],
    [LayManutencao, LayRecepcaoLeitura, LayDistLeitura, LayConsFoto] );
end;

function StrToTpEventoONE(out ok: boolean; const s: string): TpcnTpEvento;
begin
  Result := StrToEnumerado(ok, s,
            ['-99999'],
            [teNaoMapeado]);
end;

function tpManToStr(const t: TtpMan): String;
begin
  result := EnumeradoToStr(t,
                           ['1', '2', '3', '4'],
                           [tmCadastramento, tmAlteracao, tmDesativacao, tmReativacao]);
end;

function StrTotpMan(out ok: Boolean; const s: String): TtpMan;
begin
  result := StrToEnumerado(ok, s,
                           ['1', '2', '3', '4'],
                           [tmCadastramento, tmAlteracao, tmDesativacao, tmReativacao]);
end;

function tpSentidoToStr(const t: TtpSentido): String;
begin
  result := EnumeradoToStr(t,
                           ['E', 'S', 'I'],
                           [tsEntrada, tsSaida, tsIndeterminado]);
end;

function StrTotpSentido(out ok: Boolean; const s: String): TtpSentido;
begin
  result := StrToEnumerado(ok, s,
                           ['E', 'S', 'I'],
                           [tsEntrada, tsSaida, tsIndeterminado]);
end;

function tpEQPToStr(const t: TtpEQP): String;
begin
  result := EnumeradoToStr(t,
                           ['1', '2'],
                           [teSLD, teOCR]);
end;

function StrTotpEQP(out ok: Boolean; const s: String): TtpEQP;
begin
  result := StrToEnumerado(ok, s,
                           ['1', '2'],
                           [teSLD, teOCR]);
end;

function tpTransmToStr(const t: TtpTransm): String;
begin
  result := EnumeradoToStr(t,
                           ['N', 'R', 'A'],
                           [ttNormal, ttRetransmissao, ttAtrasoProcessamento]);
end;

function StrTotpTransm(out ok: Boolean; const s: String): TtpTransm;
begin
  result := StrToEnumerado(ok, s,
                           ['N', 'R', 'A'],
                           [ttNormal, ttRetransmissao, ttAtrasoProcessamento]);
end;

function tpVeiculoToStr(const t: TtpVeiculo): String;
begin
  result := EnumeradoToStr(t,
                           ['1', '2', '3'],
                           [tvCarga, tvPassageiro, tvPasseio]);
end;

function StrTotpVeiculo(out ok: Boolean; const s: String): TtpVeiculo;
begin
  result := StrToEnumerado(ok, s,
                           ['1', '2', '3'],
                           [tvCarga, tvPassageiro, tvPasseio]);
end;

function tpDistToStr(const t: TtpDist): String;
begin
  result := EnumeradoToStr(t,
                           ['1', '2', '3', '4'],
                           [tdUFMDFe, tdEquipamento, tdOperador, tdUFCaptura]);
end;

function StrTotpDist(out ok: Boolean; const s: String): TtpDist;
begin
  result := StrToEnumerado(ok, s,
                           ['1', '2', '3', '4'],
                           [tdUFMDFe, tdEquipamento, tdOperador, tdUFCaptura]);
end;

function tpLeituraToStr(const t: TtpLeitura): String;
begin
  result := EnumeradoToStr(t,
                           ['1', '2'],
                           [tlSLD, tlOCR]);
end;

function StrTotpLeitura(out ok: Boolean; const s: String): TtpLeitura;
begin
  result := StrToEnumerado(ok, s,
                           ['1', '2'],
                           [tlSLD, tlOCR]);
end;

initialization

  RegisterStrToTpEventoDFe(StrToTpEventoONE, 'ONE');

end.

