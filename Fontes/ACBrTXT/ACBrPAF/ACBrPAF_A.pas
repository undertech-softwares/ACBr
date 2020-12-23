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
unit ACBrPAF_A;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils;

type
  //A2 - Total di�rio de meios de pagamento
  TRegistroA2 = class
  private
    FRegistroValido: Boolean;
    FDT: TDateTime;           //Data do movimento
    FMEIO_PGTO: string;       //Meio de pagamento registrado nos documentos emitidos
    FTIPO_DOC: string;        //C�digo do tipo de documento a que se refere o pagamento, conforme tabela descrita no item 6.2.1.2
    FVL: Currency;            //Valor total, com duas casas decimais
    FCNPJ: String;
    FNUMDOCUMENTO: String;
  public
    constructor Create; virtual;

    property RegistroValido: Boolean read FRegistroValido write FRegistroValido;
    property DT: TDateTime           read FDT             write FDT;
    property MEIO_PGTO: string       read FMEIO_PGTO      write FMEIO_PGTO;
    property TIPO_DOC: string        read FTIPO_DOC       write FTIPO_DOC;
    property VL: Currency            read FVL             write FVL;
    property CNPJ: String            read FCNPJ           write FCNPJ;
    property NUMDOCUMENTO: String    read FNUMDOCUMENTO   write FNUMDOCUMENTO;
  end;

  TRegistroA2List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroA2;
    procedure SetItem(Index: Integer; const Value: TRegistroA2);
  public
    function New: TRegistroA2;
    property Items[Index: Integer]: TRegistroA2 read GetItem write SetItem; default;
  end;

  
implementation

{ TRegistroA2 }  
constructor TRegistroA2.Create;
begin
  fRegistroValido := True;
end;

{ TRegistroA2List }
function TRegistroA2List.GetItem(Index: Integer): TRegistroA2;
begin
  Result := TRegistroA2(inherited Items[Index]);
end;

function TRegistroA2List.New: TRegistroA2;
begin
  Result := TRegistroA2.Create;
  Add(Result);
end;

procedure TRegistroA2List.SetItem(Index: Integer;
  const Value: TRegistroA2);
begin
  Put(Index, Value);
end;

end.
