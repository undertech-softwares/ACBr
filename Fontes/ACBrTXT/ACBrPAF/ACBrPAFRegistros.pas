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

unit ACBrPAFRegistros;

interface

uses
  SysUtils, Classes, DateUtils;

type
  TLayoutPAF = (lpPAFECF, lpPAFNFCe);


  /// REGISTRO TIPO X1 - IDENTIFICA��O DO ESTABELECIMENTO USU�RIO DO PAF-ECF:

  TRegistroX1 = class
  private
    FUF: String;           /// UF do estabelecimento usu�rio do PAF-ECF
    FCNPJ: String;         /// CNPJ do estabelecimento usu�rio do PAF-ECF
    FIE: String;           /// Inscri��o Estadual do estabelecimento
    FIM: String;           /// Inscri��o Municipal do estabelecimento
    FRAZAOSOCIAL: String;  /// Raz�o Social do estabelecimento
    fInclusaoExclusao: Boolean; /// Valida��o dos registros colocando ??? nos espa�os em branco da razao social
  public
    constructor Create; virtual; /// Create
    property UF: String read FUF write FUF;
    property CNPJ: String read FCNPJ write FCNPJ;
    property IE: String read FIE write FIE;
    property IM: String read FIM write FIM;
    property RAZAOSOCIAL: String read FRAZAOSOCIAL write FRAZAOSOCIAL;

    property InclusaoExclusao: Boolean read fInclusaoExclusao write fInclusaoExclusao default False;
  end;

  // REGISTRO TIPO Z3 - IDENTIFICA��O DO PAF-ECF
  TRegistroX3 = Class
  private
    fLAUDO:  string;         /// N�mero do Laudo de An�lise Funcional
    fNOME:   string;         /// Nome do aplicativo indicado no Laudo de An�lise T�cnica
    fVERSAO: string;         /// Vers�o atual do aplicativo indicado no Laudo de An�lise T�cnica
  public
    property LAUDO: string read fLAUDO write fLAUDO;
    property NOME: string read fNOME write fNOME;
    property VERSAO: string read fVERSAO write fVERSAO;
  end;

  /// REGISTRO TIPO X9 - TOTALIZA��O DO ARQUIVO

  TRegistroX9 = class
  private
    FTOT_REG: integer;  /// Total de registros
  public
    property TOT_REG: integer read FTOT_REG write FTOT_REG;
  end;

implementation

{ TRegistroX1 }

constructor TRegistroX1.Create;
begin
  fInclusaoExclusao := False;
end;

end.
