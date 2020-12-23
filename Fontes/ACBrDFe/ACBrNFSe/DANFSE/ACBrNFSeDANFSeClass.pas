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

unit ACBrNFSeDANFSeClass;

interface

uses
  SysUtils, Classes,
  ACBrBase, ACBrDFeReport,
  pnfsNFSe, pnfsConversao;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
 TACBrNFSeDANFSeClass = class(TACBrDFeReport)
  private
    procedure SetACBrNFSe(const Value: TComponent);
    procedure ErroAbstract( const NomeProcedure: String );
  protected
    FACBrNFSe: TComponent;
    FPrestLogo: String;
    FPrefeitura: String;
    FRazaoSocial: String;
    FEndereco : String;
    FComplemento : String;
    FFone : String;
    FMunicipio : String;
    FOutrasInformacaoesImp : String;
    FInscMunicipal : String;
    FT_InscEstadual : String;
    FT_InscMunicipal : String;
    FT_Fone          : String;
    FT_Endereco      : String;
    FT_Complemento   : String;
    FT_Email         : String;
    FEMail_Prestador : String;
    FCNPJ_Prestador  : String;
    FFormatarNumeroDocumentoNFSe  : Boolean;
    FUF : String;
    FAtividade : String;
    FNFSeCancelada: boolean;
    FImprimeCanhoto: Boolean;
    FTipoDANFSE: TTipoDANFSE;
    FProvedor: TNFSeProvedor;
    FTamanhoFonte: Integer;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetSeparadorPathPDF(const aInitialPath: String): String; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure VisualizarDANFSe(NFSe: TNFSe = nil); virtual;
    procedure ImprimirDANFSe(NFSe: TNFSe = nil); virtual;
    procedure ImprimirDANFSePDF(NFSe: TNFSe = nil); virtual;

  published
    property ACBrNFSe: TComponent  read FACBrNFSe write SetACBrNFSe;
    property PrestLogo: String read FPrestLogo write FPrestLogo;
    property Prefeitura: String read FPrefeitura write FPrefeitura;

    property RazaoSocial: String read FRazaoSocial write FRazaoSocial;
    property UF: String read FUF write FUF;
    property Endereco: String read FEndereco write FEndereco;
    property Complemento: String read FComplemento write FComplemento;
    property Fone: String read FFone write FFone;
    property Municipio: String read FMunicipio write FMunicipio;
    property OutrasInformacaoesImp: String read FOutrasInformacaoesImp write FOutrasInformacaoesImp;
    property InscMunicipal: String read FInscMunicipal write FInscMunicipal;
    property EMail_Prestador: String read FEMail_Prestador write FEMail_Prestador;
    property CNPJ_Prestador: String read FCNPJ_Prestador write FCNPJ_Prestador;

    property T_InscEstadual: String read FT_InscEstadual write FT_InscEstadual;
    property T_InscMunicipal: String read FT_InscMunicipal write FT_InscMunicipal;
    property T_Fone: String read FT_Fone write FT_Fone;

    property T_Endereco: String read FT_Endereco write FT_Endereco;
    property T_Complemento: String read FT_Complemento write FT_Complemento;
    property T_Email: String read FT_Email write FT_Email;

    property Atividade: String read FAtividade write FAtividade;
    property Cancelada: Boolean read FNFSeCancelada write FNFSeCancelada;
    property ImprimeCanhoto: Boolean read FImprimeCanhoto write FImprimeCanhoto default False;

    property TipoDANFSE: TTipoDANFSE read FTipoDANFSE   write FTipoDANFSE default tpPadrao;
    property Provedor: TNFSeProvedor read FProvedor     write FProvedor;
    property TamanhoFonte: Integer   read FTamanhoFonte write FTamanhoFonte;
    property FormatarNumeroDocumentoNFSe : Boolean read FFormatarNumeroDocumentoNFSe write FFormatarNumeroDocumentoNFSe;
  end;

implementation

uses
  ACBrNFSe, ACBrUtil;

{ TACBrNFSeDANFSeClass }

constructor TACBrNFSeDANFSeClass.Create(AOwner: TComponent);
begin
 inherited create( AOwner );

 FACBrNFSe       := nil;
 FPrestLogo      := '';
 FPrefeitura     := '';
 FRazaoSocial    := '';
 FEndereco       := '';
 FComplemento    := '';
 FFone           := '';
 FMunicipio      := '';
 FTamanhoFonte   := 6;

 FOutrasInformacaoesImp := '';
 FInscMunicipal         := '';
 FEMail_Prestador       := '';
 FUF                    := '';
 FT_InscEstadual        := '';
 FT_InscMunicipal       := '';
 FAtividade             := '';
 FT_Fone                := '';
 FT_Endereco            := '';
 FT_Complemento         := '';
 FT_Email               := '';
 FFormatarNumeroDocumentoNFSe := True;
 FNFSeCancelada := False;

 FProvedor := proNenhum;
end;

destructor TACBrNFSeDANFSeClass.Destroy;
begin

 inherited Destroy;
end;

procedure TACBrNFSeDANFSeClass.ErroAbstract(const NomeProcedure: String);
begin
 raise Exception.Create( NomeProcedure );
end;

procedure TACBrNFSeDANFSeClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
 inherited Notification(AComponent, Operation);

 if (Operation = opRemove) and (FACBrNFSe <> nil) and (AComponent is TACBrNFSe)
  then FACBrNFSe := nil;
end;

procedure TACBrNFSeDANFSeClass.SetACBrNFSe(const Value: TComponent);
var
 OldValue: TACBrNFSe;
begin
 if Value <> FACBrNFSe then
  begin
   if Value <> nil
    then if not (Value is TACBrNFSe)
          then raise Exception.Create('ACBrDANFSe.NFSe deve ser do tipo TACBrNFSe');

   if Assigned(FACBrNFSe)
    then FACBrNFSe.RemoveFreeNotification(Self);

   OldValue  := TACBrNFSe(FACBrNFSe);  // Usa outra variavel para evitar Loop Infinito
   FACBrNFSe := Value;                 // na remo��o da associa��o dos componentes

   if Assigned(OldValue)
    then if Assigned(OldValue.DANFSe)
          then OldValue.DANFSe := nil;

   if Value <> nil then
   begin
     Value.FreeNotification(self);
     TACBrNFSe(Value).DANFSe := self;
   end;
  end;
end;

function TACBrNFSeDANFSeClass.GetSeparadorPathPDF(const aInitialPath: String): String;
var
   dhEmissao: TDateTime;
   DescricaoModelo: String;
   ANFSe: TNFSe;
begin
  Result := aInitialPath;

  if Assigned(ACBrNFSe) then  // Se tem o componente ACBrNFSe
  begin
    if TACBrNFSe(ACBrNFSe).NotasFiscais.Count > 0 then  // Se tem alguma Nota carregada
    begin
      ANFSe := TACBrNFSe(ACBrNFSe).NotasFiscais.Items[0].NFSe;
      if TACBrNFSe(ACBrNFSe).Configuracoes.Arquivos.EmissaoPathNFSe then
        dhEmissao := ANFSe.DataEmissao
      else
        dhEmissao := Now;

      DescricaoModelo := '';
      if TACBrNFSe(ACBrNFSe).Configuracoes.Arquivos.AdicionarLiteral then
      begin
        DescricaoModelo := TACBrNFSe(ACBrNFSe).GetNomeModeloDFe;
      end;

      Result := TACBrNFSe(ACBrNFSe).Configuracoes.Arquivos.GetPath(
                Result, DescricaoModelo,
                OnlyNumber(ANFSe.PrestadorServico.IdentificacaoPrestador.CNPJ),
                OnlyNumber(ANFSe.PrestadorServico.IdentificacaoPrestador.InscricaoEstadual),
                dhEmissao);
    end;
  end;
end;

procedure TACBrNFSeDANFSeClass.VisualizarDANFSe(NFSe: TNFSe);
begin
 ErroAbstract('VisualizarDANFSe');
end;

procedure TACBrNFSeDANFSeClass.ImprimirDANFSe(NFSe: TNFSe);
begin
 ErroAbstract('ImprimirDANFSe');
end;

procedure TACBrNFSeDANFSeClass.ImprimirDANFSePDF(NFSe: TNFSe);
begin
 ErroAbstract('ImprimirDANFSePDF');
end;

end.
