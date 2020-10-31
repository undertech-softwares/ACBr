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

unit pnfsCancNfseResposta;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase, ACBrUtil,
  pcnAuxiliar, pcnConversao, pcnLeitor, pnfsConversao, pnfsNFSe;

type

 TMsgRetornoCancCollection = class;
 TMsgRetornoCancCollectionItem = class;
 TNotasCanceladasCollection = class;
 TNotasCanceladasCollectionItem = class;

 TInfCanc = class(TObject)
  private
    FPedido: TPedidoCancelamento;
    FDataHora: TDateTime;
    FConfirmacao: String;
    FSucesso: String;
    FProtocolo: String;
    FMsgCanc: String;
    FMsgRetorno: TMsgRetornoCancCollection;
    FNotasCanceladas: TNotasCanceladasCollection;
    FInformacoesLote: TInformacoesLote;

    procedure SetMsgRetorno(Value: TMsgRetornoCancCollection);
    procedure SetNotasCanceladas(const Value: TNotasCanceladasCollection);
  public
    constructor Create;
    destructor Destroy; override;
    property Pedido: TPedidocancelamento           read FPedido      write FPedido;
    property DataHora: TDateTime                   read FDataHora    write FDataHora;  
    property Confirmacao: String                   read FConfirmacao write FConfirmacao;
    property Sucesso: String                       read FSucesso     write FSucesso;
    property Protocolo: String                     read FProtocolo   write FProtocolo;
    property MsgCanc: String                       read FMsgCanc     write FMsgCanc;
    property MsgRetorno: TMsgRetornoCancCollection read FMsgRetorno  write SetMsgRetorno;

    property NotasCanceladas: TNotasCanceladasCollection read FNotasCanceladas write SetNotasCanceladas;
    property InformacoesLote: TInformacoesLote    read FInformacoesLote write FInformacoesLote;
  end;

 TMsgRetornoCancCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TMsgRetornoCancCollectionItem;
    procedure SetItem(Index: Integer; Value: TMsgRetornoCancCollectionItem);
  public
    function Add: TMsgRetornoCancCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TMsgRetornoCancCollectionItem;
    property Items[Index: Integer]: TMsgRetornoCancCollectionItem read GetItem write SetItem; default;
  end;

 TMsgRetornoCancCollectionItem = class(TObject)
  private
    FCodigo: String;
    FMensagem: String;
    FCorrecao: String;
    FIdentificacaoRps: TMsgRetornoIdentificacaoRps;
    FChaveNFeRPS: TChaveNFeRPS;
  public
    constructor Create;
    destructor Destroy; override;

    property Codigo: String   read FCodigo   write FCodigo;
    property Mensagem: String read FMensagem write FMensagem;
    property Correcao: String read FCorrecao write FCorrecao;
    property IdentificacaoRps: TMsgRetornoIdentificacaoRps read FIdentificacaoRps write FIdentificacaoRps;
    property ChaveNFeRPS: TChaveNFeRPS read FChaveNFeRPS write FChaveNFeRPS;
  end;

 TNotasCanceladasCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TNotasCanceladasCollectionItem;
    procedure SetItem(Index: Integer; Value: TNotasCanceladasCollectionItem);
  public
    function Add: TNotasCanceladasCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TNotasCanceladasCollectionItem;
    property Items[Index: Integer]: TNotasCanceladasCollectionItem read GetItem write SetItem; default;
  end;

 TNotasCanceladasCollectionItem = class(TObject)
  private
    FNumeroNota: String;
    FCodigoVerficacao: String;
    FInscricaoMunicipalPrestador: String;
  public
    property NumeroNota: String       read FNumeroNota       write FNumeroNota;
    property CodigoVerficacao: String read FCodigoVerficacao write FCodigoVerficacao;
    property InscricaoMunicipalPrestador: String read FInscricaoMunicipalPrestador write FInscricaoMunicipalPrestador;
  end;

 { TretCancNFSe }

 TretCancNFSe = class(TObject)
  private
    FLeitor: TLeitor;
    FInfCanc: TInfCanc;
    FProvedor: TnfseProvedor;
    FVersaoXML: String;
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: Boolean;

    function LerXml_ABRASF: Boolean;

    function LerXml_proCONAM: Boolean;
    function LerXML_proEGoverneISS: Boolean;
    function LerXml_proEL: Boolean;
    function LerXML_proEquiplano: Boolean;
    function LerXml_proInfisc: Boolean;
    function LerXml_proISSDSF: Boolean;
    function LerXml_proNFSeBrasil: Boolean;
    function LerXml_proSP: Boolean;
    function LerXml_proGoverna: Boolean;
    function LerXml_proSMARAPD: Boolean;
    function LerXml_proGIAP: Boolean;
    function LerXml_proIPM: Boolean;
    function LerXml_proAssessorPublico: Boolean;
    function LerXml_proSiat: Boolean;
    function LerXml_proSigISS: Boolean;
    function LerXml_proGeisWeb: Boolean;

    property Leitor: TLeitor         read FLeitor   write FLeitor;
    property InfCanc: TInfCanc       read FInfCanc  write FInfCanc;
    property Provedor: TnfseProvedor read FProvedor write FProvedor;
    property VersaoXML: String       read FVersaoXML write FVersaoXML;
  end;

implementation

{ TInfCanc }

constructor TInfCanc.Create;
begin
  inherited Create;
  FPedido          := TPedidoCancelamento.Create;
  FMsgRetorno      := TMsgRetornoCancCollection.Create;
  FNotasCanceladas := TNotasCanceladasCollection.Create;
  FInformacoesLote := TInformacoesLote.Create;
end;

destructor TInfCanc.Destroy;
begin
  FPedido.Free;
  FMsgRetorno.Free;
  FNotasCanceladas.Free;
  FInformacoesLote.Free;

  inherited;
end;

procedure TInfCanc.SetMsgRetorno(Value: TMsgRetornoCancCollection);
begin
  FMsgRetorno.Assign(Value);
end;

procedure TInfCanc.SetNotasCanceladas(const Value: TNotasCanceladasCollection);
begin
  FNotasCanceladas.Assign(Value);
end;

{ TMsgRetornoCancCollection }

function TMsgRetornoCancCollection.Add: TMsgRetornoCancCollectionItem;
begin
  Result := Self.New;
end;

function TMsgRetornoCancCollection.GetItem(
  Index: Integer): TMsgRetornoCancCollectionItem;
begin
  Result := TMsgRetornoCancCollectionItem(inherited Items[Index]);
end;

procedure TMsgRetornoCancCollection.SetItem(Index: Integer;
  Value: TMsgRetornoCancCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TMsgRetornoCancCollection.New: TMsgRetornoCancCollectionItem;
begin
  Result := TMsgRetornoCancCollectionItem.Create;
  Self.Add(Result);
end;

{ TMsgRetornoCancCollectionItem }

constructor TMsgRetornoCancCollectionItem.Create;
begin
  inherited Create;
  FIdentificacaoRps      := TMsgRetornoIdentificacaoRps.Create;
  FIdentificacaoRps.Tipo := trRPS;
  FChaveNFeRPS           := TChaveNFeRPS.Create;
end;

destructor TMsgRetornoCancCollectionItem.Destroy;
begin
  FIdentificacaoRps.Free;
  FChaveNFeRPS.Free;
  inherited;
end;

{ TNotasCanceladasCollection }

function TNotasCanceladasCollection.Add: TNotasCanceladasCollectionItem;
begin
  Result := Self.New
end;

function TNotasCanceladasCollection.GetItem(
  Index: Integer): TNotasCanceladasCollectionItem;
begin
  Result := TNotasCanceladasCollectionItem(inherited Items[Index]);
end;

procedure TNotasCanceladasCollection.SetItem(Index: Integer;
  Value: TNotasCanceladasCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TNotasCanceladasCollection.New: TNotasCanceladasCollectionItem;
begin
  Result := TNotasCanceladasCollectionItem.Create;
  Self.Add(Result);
end;

{ TretCancNFSe }

constructor TretCancNFSe.Create;
begin
  inherited Create;
  FLeitor  := TLeitor.Create;
  FInfCanc := TInfCanc.Create;
end;

destructor TretCancNFSe.Destroy;
begin
  FLeitor.Free;
  FInfCanc.Free;
  inherited;
end;

function TretCancNFSe.LerXml: Boolean;
begin
  if Provedor = proISSCuritiba then
    Leitor.Arquivo := RemoverNameSpace(Leitor.Arquivo)
  else
    Leitor.Arquivo := RemoverNameSpace(RemoverAtributos(RetirarPrefixos(Leitor.Arquivo, Provedor), Provedor));

  Leitor.Grupo   := Leitor.Arquivo;

  case Provedor of
    proCONAM:       Result := LerXml_proCONAM;
    proEGoverneISS: Result := LerXML_proEGoverneISS;
    proEL:          Result := LerXml_proEL;
    proEquiplano:   Result := LerXML_proEquiplano;
    proInfisc,
    proInfiscv11:   Result := LerXml_proInfisc;
    proISSDSF,
    proCTA:         Result := LerXml_proISSDSF;
    proNFSeBrasil:  Result := LerXml_proNFSeBrasil;
    proSP, 
    proNotaBlu:     Result := LerXml_proSP;
    proGoverna:     Result := LerXml_proGoverna;
    proSMARAPD:     Result := LerXml_proSMARAPD;
    proGiap:        Result := LerXml_proGIAP;
    proIPM:         Result := LerXml_proIPM;
    proAssessorPublico:  Result := LerXml_proAssessorPublico;
    proSiat:        Result := LerXml_proSiat; 
    proSigIss:      Result := LerXml_proSigIss;
    proGeisWeb:     Result := LerXml_proGeisWeb;
  else
    Result := LerXml_ABRASF;
  end;
end;

function TretCancNFSe.LerXml_ABRASF: Boolean;
var
  i, iNivel: Integer;
begin
  Result := True;

  try
    case Provedor of
      proGinfes: begin
                   if (leitor.rExtrai(1, 'CancelarNfseResposta') <> '') then
                   begin
                     if AnsiLowerCase(Leitor.rCampo(tcStr, 'Sucesso')) = 'true' then
                     begin
                       infCanc.DataHora := Leitor.rCampo(tcDatHor, 'DataHora');
                       InfCanc.Sucesso  := Leitor.rCampo(tcStr,    'Sucesso');
                       InfCanc.MsgCanc  := Leitor.rCampo(tcStr,    'Mensagem');
                     end
                     else
                       infCanc.DataHora := 0;

                     InfCanc.FPedido.InfID.ID           := '';
                     InfCanc.FPedido.CodigoCancelamento := '';

                     if Leitor.rExtrai(1, 'MensagemRetorno') <> '' then
                     begin
                       if Pos('cancelada com sucesso', AnsiLowerCase(Leitor.rCampo(tcStr, 'Mensagem'))) = 0 then
                       begin
                         InfCanc.FMsgRetorno.New;
                         InfCanc.FMsgRetorno[0].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
                         InfCanc.FMsgRetorno[0].FMensagem := Leitor.rCampo(tcStr, 'Mensagem');
                         InfCanc.FMsgRetorno[0].FCorrecao := Leitor.rCampo(tcStr, 'Correcao');
                       end;
                     end;
                   end;
                 end;
      proDSFSJC: begin
                   if (Leitor.rExtrai(1, 'CancelarNfseResposta') <> '') then
                   begin
                     if (Leitor.rExtrai(2, 'RetCancelamento') <> '') then
                     begin
                       if (Leitor.rExtrai(3, 'NfseCancelamento') <> '') then
                       begin
                         if (Leitor.rExtrai(4, 'Confirmacao') <> '') then
                         begin
                           if (Leitor.rExtrai(5, 'Pedido') <> '') then
                           begin
                             if (Leitor.rExtrai(6, 'InfPedidoCancelamento') <> '') then
                             begin
                               if (Leitor.rExtrai(7, 'IdentificacaoNfse') <> '') then
                               begin
                                 InfCanc.FPedido.IdentificacaoNfse.Numero             := Leitor.rCampo(tcStr, 'Numero');
                                 InfCanc.FPedido.IdentificacaoNfse.Cnpj               := Leitor.rCampo(tcStr, 'Cnpj');
                                 InfCanc.FPedido.IdentificacaoNfse.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
                                 InfCanc.FPedido.IdentificacaoNfse.CodigoMunicipio    := Leitor.rCampo(tcStr, 'CodigoMunicipio');                               end;
                             end;
                           end;
                         end;
                       end;
                       if (Leitor.rExtrai(4, 'Confirmacao') <> '') then
                       begin
                         infCanc.DataHora := Leitor.rCampo(tcDatHor, 'DataHoraCancelamento');
                         if infCanc.DataHora > 0 then
                           InfCanc.Sucesso  := 'S';
                       end;
                     end;
                   end;

                   if (Leitor.rExtrai(1, 'CancelarNfseResposta') <> '') then
                   begin
                     if (Leitor.rExtrai(2, 'ListaMensagemRetorno') <> '') then
                     begin
                       i := 0;
                       while Leitor.rExtrai(3, 'MensagemRetorno', '', i + 1) <> '' do
                       begin
                         InfCanc.FMsgRetorno.New;
                         InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
                         InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Mensagem');
                         InfCanc.FMsgRetorno[i].FCorrecao := Leitor.rCampo(tcStr, 'Correcao');

                         Inc(i);
                       end;
                     end;
                   end;
                 end;
      proISSNET: begin
                   if (Leitor.rExtrai(1, 'CancelarNfseResposta') <> '') then
                   begin
                     if (Leitor.rExtrai(2, 'Confirmacao') <> '') then
                     begin
                       if (Leitor.rExtrai(3, 'Pedido') <> '') then
                       begin
                         if (Leitor.rExtrai(4, 'InfPedidoCancelamento') <> '') then
                         begin
                           if (Leitor.rExtrai(5, 'IdentificacaoNfse') <> '') then
                           begin
                             InfCanc.FPedido.IdentificacaoNfse.Numero             := Leitor.rCampo(tcStr, 'Numero');
                             InfCanc.FPedido.IdentificacaoNfse.Cnpj               := Leitor.rCampo(tcStr, 'CpfCnpj');
                             InfCanc.FPedido.IdentificacaoNfse.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
                           end;
                         end;
                       end;
                       if (Leitor.rExtrai(3, 'InfConfirmacaoCancelamento') <> '') then
                       begin
                         InfCanc.Sucesso  := Leitor.rCampo(tcStr, 'Sucesso');
                         infCanc.DataHora := Leitor.rCampo(tcDatHor, 'DataHora');
                       end;
                     end;
                   end;

                   if (Leitor.rExtrai(1, 'CancelarNfseResposta') <> '') then
                   begin
                     if (Leitor.rExtrai(2, 'ListaMensagemRetorno') <> '') then
                     begin
                       i := 0;
                       while Leitor.rExtrai(3, 'MensagemRetorno', '', i + 1) <> '' do
                       begin
                         InfCanc.FMsgRetorno.New;
                         InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
                         InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Mensagem');
                         InfCanc.FMsgRetorno[i].FCorrecao := Leitor.rCampo(tcStr, 'Correcao');

                         Inc(i);
                       end;
                     end;
                   end;
                 end;
     proElotech: begin
                   if (Leitor.rExtrai(1, 'CancelarNfseResposta') <> '') then
                   begin
                     if (Leitor.rExtrai(2, 'tcRetCancelamento') <> '') then
                     begin
                       if (Leitor.rExtrai(3, 'NfseCancelamento') <> '') then
                       begin
                         if (Leitor.rExtrai(4, 'ConfirmacaoCancelamento') <> '') then
                         begin
                           if (Leitor.rExtrai(5, 'Pedido') <> '') then
                           begin
                             if (Leitor.rExtrai(6, 'InfPedidoCancelamento') <> '') then
                             begin
                               if (Leitor.rExtrai(7, 'IdentificacaoNfse') <> '') then
                               begin
                                 InfCanc.FPedido.IdentificacaoNfse.Numero             := Leitor.rCampo(tcStr, 'Numero');
                                 InfCanc.FPedido.IdentificacaoNfse.Cnpj               := Leitor.rCampo(tcStr, 'Cnpj');
                                 InfCanc.FPedido.IdentificacaoNfse.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
                                 InfCanc.FPedido.IdentificacaoNfse.CodigoMunicipio    := Leitor.rCampo(tcStr, 'CodigoMunicipio');                               end;
                             end;
                           end;
                           infCanc.DataHora := Leitor.rCampo(tcDatHorCFe, 'DataHora');
                           if infCanc.DataHora > 0 then
                            InfCanc.Sucesso  := 'S';
                         end;
                       end;
                     end;
                     iNivel := 1;
                     if (leitor.rExtrai(2, 'ListaMensagemRetorno') <> '') or
                         (leitor.rExtrai(2, 'ListaMensagemRetornoLote') <> '') then
                        iNivel := 3
                     else
                     if (leitor.rExtrai(1, 'ListaMensagemRetorno') <> '') or
                           (leitor.rExtrai(1, 'ListaMensagemRetornoLote') <> '') then
                          iNivel := 2;

                     i := 0;
                     while Leitor.rExtrai(iNivel, 'MensagemRetorno', '', i + 1) <> '' do
                     begin
                        InfCanc.FMsgRetorno.New;
                        InfCanc.FMsgRetorno[i].FIdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'Numero');
                        InfCanc.FMsgRetorno[i].FIdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'Serie');
                        InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
                        InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Mensagem');
                        InfCanc.FMsgRetorno[i].FCorrecao := Leitor.rCampo(tcStr, 'Correcao');

                        inc(i);
                     end;
                   end
                 end;
      proSpeedGov: begin
                     if (leitor.rExtrai(1, 'CancelarNfseResposta') <> '') then
                     begin
                       if AnsiLowerCase(Leitor.rCampo(tcStr, 'Sucesso')) = 'true' then
                       begin
                         infCanc.DataHora := Leitor.rCampo(tcDatHor, 'DataHora');
                         InfCanc.Sucesso  := Leitor.rCampo(tcStr,    'Sucesso');
                       end
                       else
                         infCanc.DataHora := 0;

                       InfCanc.FPedido.InfID.ID           := '';
                       InfCanc.FPedido.CodigoCancelamento := '';

                       if Leitor.rExtrai(1, 'MensagemRetorno') <> '' then
                       begin
                         if Pos('cancelada com sucesso', AnsiLowerCase(Leitor.rCampo(tcStr, 'Mensagem'))) = 0 then
                         begin
                           InfCanc.FMsgRetorno.New;
                           InfCanc.FMsgRetorno[0].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
                           InfCanc.FMsgRetorno[0].FMensagem := Leitor.rCampo(tcStr, 'Mensagem');
                           InfCanc.FMsgRetorno[0].FCorrecao := Leitor.rCampo(tcStr, 'Correcao');
                         end;
                       end;
                     end;
                   end;
    else
      begin
        if (leitor.rExtrai(1, 'CancelarNfseResposta') <> '') or
           (leitor.rExtrai(1, 'Cancelarnfseresposta') <> '') or
           (leitor.rExtrai(1, 'CancelarNfseReposta') <> '') or
           (leitor.rExtrai(1, 'CancelarNfseResult') <> '') or
           (leitor.rExtrai(1, 'GerarNfseResposta') <> '') then
        begin
          infCanc.DataHora := Leitor.rCampo(tcDatHor, 'DataHora');
          if infCanc.DataHora = 0 then
            if Provedor = proSigCorp then
              infCanc.DataHora := StringToDateTime(Leitor.rCampo(tcStr, 'DataHoraCancelamento') , 'MM/DD/YYYY hh:nn:ss')
            else
              infCanc.DataHora := Leitor.rCampo(tcDatHor, 'DataHoraCancelamento');

          InfCanc.FConfirmacao := Leitor.rAtributo('Confirmacao Id=');

          if Provedor = proCenti then
          begin
            if Leitor.rCampo(tcStr, 'Status') = '3' then
              InfCanc.Sucesso := 'S';
          end
          else
            InfCanc.Sucesso := Leitor.rCampo(tcStr, 'Sucesso');

          if Provedor = proAgili then
            InfCanc.Protocolo := Leitor.rCampo(tcStr, 'ProtocoloRequerimentoCancelamento');

          InfCanc.FPedido.InfID.ID := Leitor.rAtributo('InfPedidoCancelamento Id=');
          if InfCanc.FPedido.InfID.ID = '' then
            InfCanc.FPedido.InfID.ID := Leitor.rAtributo('InfPedidoCancelamento id=');

          InfCanc.FPedido.CodigoCancelamento := Leitor.rCampo(tcStr, 'CodigoCancelamento');

          If (Provedor in [proSimpliss, proTcheInfov2]) then
            InfCanc.Sucesso := InfCanc.FPedido.CodigoCancelamento;

          if Leitor.rExtrai(2, 'IdentificacaoNfse') <> '' then
          begin
            InfCanc.FPedido.IdentificacaoNfse.Numero             := Leitor.rCampo(tcStr, 'Numero');
            InfCanc.FPedido.IdentificacaoNfse.Cnpj               := Leitor.rCampo(tcStr, 'Cnpj');
            InfCanc.FPedido.IdentificacaoNfse.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
            InfCanc.FPedido.IdentificacaoNfse.CodigoMunicipio    := Leitor.rCampo(tcStr, 'CodigoMunicipio');
          end;
          {
          Leitor.Grupo := Leitor.Arquivo;

          InfCanc.FPedido.signature.URI             := Leitor.rAtributo('Reference URI=');
          InfCanc.FPedido.signature.DigestValue     := Leitor.rCampo(tcStr, 'DigestValue');
          InfCanc.FPedido.signature.SignatureValue  := Leitor.rCampo(tcStr, 'SignatureValue');
          InfCanc.FPedido.signature.X509Certificate := Leitor.rCampo(tcStr, 'X509Certificate');
          }
          if (leitor.rExtrai(2, 'ListaMensagemRetorno') <> '') or
             (leitor.rExtrai(2, 'MensagemRetorno') <> '') then
          begin
            i := 0;
            while Leitor.rExtrai(3, 'MensagemRetorno', '', i + 1) <> '' do
            begin
              InfCanc.FMsgRetorno.New;
              InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
              InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Mensagem');
              InfCanc.FMsgRetorno[i].FCorrecao := Leitor.rCampo(tcStr, 'Correcao');

              inc(i);
            end;
          end;

          if (leitor.rExtrai(1, 'ListaMensagemRetorno') <> '') then
          begin
             InfCanc.FMsgRetorno.New;
             InfCanc.FMsgRetorno[0].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
             InfCanc.FMsgRetorno[0].FMensagem := Leitor.rCampo(tcStr, 'Mensagem');
             InfCanc.FMsgRetorno[0].FCorrecao := Leitor.rCampo(tcStr, 'Correcao');
          end;
        end;
      end;
    end;

    i := 0;
    while (Leitor.rExtrai(1, 'Fault', '', i + 1) <> '') do
    begin
      InfCanc.FMsgRetorno.New;
      InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'faultcode');
      InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'faultstring');
      InfCanc.FMsgRetorno[i].FCorrecao := '';

      inc(i);
    end;

  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXml_proISSDSF: Boolean; //falta homologar
var
  i: Integer;
begin
  Result := False;

  try
    if leitor.rExtrai(1, 'RetornoCancelamentoNFSe') <> '' then
    begin
      if (leitor.rExtrai(2, 'Cabecalho') <> '') then
      begin
        FInfCanc.FSucesso := Leitor.rCampo(tcStr, 'Sucesso');

        if FInfCanc.FSucesso = 'S' then // provedor CTA
          FInfCanc.DataHora := Date
        else if FInfCanc.FSucesso = 'true' then // provedor ISSDSF
          FInfCanc.DataHora := Date;
      end;

      i := 0;
      if (leitor.rExtrai(2, 'NotasCanceladas') <> '') then
      begin
        while (Leitor.rExtrai(2, 'Nota', '', i + 1) <> '') do
        begin
          FInfCanc.FNotasCanceladas.New;
          FInfCanc.FNotasCanceladas[i].InscricaoMunicipalPrestador := Leitor.rCampo(tcStr, 'InscricaoMunicipalPrestador');
          FInfCanc.FNotasCanceladas[i].NumeroNota                  := Leitor.rCampo(tcStr, 'NumeroNota');
          FInfCanc.FNotasCanceladas[i].CodigoVerficacao            := Leitor.rCampo(tcStr,'CodigoVerificacao');
          inc(i);
        end;
      end;

      i := 0;
      if (leitor.rExtrai(2, 'Alertas') <> '') then
      begin
        while (Leitor.rExtrai(2, 'Alerta', '', i + 1) <> '') do
        begin
          InfCanc.FMsgRetorno.New;
          InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
          InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Descricao');
          InfCanc.FMsgRetorno[i].FCorrecao := '';
          inc(i);
        end;
      end;

      i := 0;
      if (leitor.rExtrai(2, 'Erros') <> '') then
      begin
        while (Leitor.rExtrai(2, 'Erro', '', i + 1) <> '') do
        begin
          InfCanc.FMsgRetorno.New;
          InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
          InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Descricao');
          InfCanc.FMsgRetorno[i].FCorrecao := '';
          inc(i);
        end;
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXML_proEquiplano: Boolean;
var
  i: Integer;
begin
  try
    InfCanc.FSucesso  := Leitor.rCampo(tcStr, 'Sucesso');
    InfCanc.FDataHora := Leitor.rCampo(tcDatHor, 'dtCancelamento');

    if leitor.rExtrai(1, 'mensagemRetorno') <> '' then
    begin
      i := 0;
      if (leitor.rExtrai(2, 'listaErros') <> '') then
      begin
        while Leitor.rExtrai(3, 'erro', '', i + 1) <> '' do
        begin
          InfCanc.FMsgRetorno.New;
          InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'cdMensagem');
          InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'dsMensagem');
          InfCanc.FMsgRetorno[i].FCorrecao := Leitor.rCampo(tcStr, 'dsCorrecao');
          inc(i);
        end;
      end;

      if (leitor.rExtrai(2, 'listaAlertas') <> '') then
      begin
        while Leitor.rExtrai(3, 'alerta', '', i + 1) <> '' do
        begin
          InfCanc.FMsgRetorno.New;
          InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'cdMensagem');
          InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'dsMensagem');
          InfCanc.FMsgRetorno[i].FCorrecao := Leitor.rCampo(tcStr, 'dsCorrecao');
          inc(i);
        end;
      end;
    end;

    Result := True;
  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXml_proInfisc: Boolean;
var
  sMotCod, sMotDes: String;
begin
  Result := False;
  try
    if leitor.rExtrai(1, 'resCancelaNFSe') <> '' then
    begin
      InfCanc.FSucesso := Leitor.rCampo(tcStr, 'sit');
      if (InfCanc.FSucesso = '100') then // 100-Aceito
      begin
         InfCanc.FPedido.IdentificacaoNfse.Cnpj   := Leitor.rCampo(tcStr, 'CNPJ');
         InfCanc.FPedido.IdentificacaoNfse.Numero := Leitor.rCampo(tcStr, 'chvAcessoNFS-e');
         InfCanc.FDataHora                        := Leitor.rCampo(tcDatHor, 'dhRecbto');
         InfCanc.Protocolo                        := Leitor.rCampo(tcStr, 'nProt');
      end
      else if (InfCanc.FSucesso = '200') then // 200-Rejeitado
      begin
        InfCanc.Protocolo := Leitor.rCampo(tcStr, 'nProt');
        sMotDes := Leitor.rCampo(tcStr, 'mot');
        if Pos('Error', sMotDes) > 0 then
          sMotCod := OnlyNumber(copy(sMotDes, 1, Pos(' ', sMotDes)))
        else
          sMotCod := '';
        InfCanc.MsgRetorno.New;
        InfCanc.MsgRetorno[0].FCodigo   := sMotCod;
        InfCanc.MsgRetorno[0].FMensagem := sMotDes + ' ' +
                                          'CNPJ ' + Leitor.rCampo(tcStr, 'CNPJ') + ' ' +
                                          'DATA ' + Leitor.rCampo(tcStr, 'dhRecbto');
        InfCanc.MsgRetorno[0].FCorrecao := '';
      end;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXml_proEL: Boolean;
var
  i: Integer;
begin
  Result := False;
  try
    InfCanc.FSucesso := Leitor.rCampo(tcStr, 'situacao');
    if InfCanc.FSucesso = 'C' then
      InfCanc.FDataHora:= Now;

    i := 0;
    while Leitor.rExtrai(1, 'mensagens', '', i + 1) <> '' do
    begin
      InfCanc.FMsgRetorno.New;
      InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'mensagens');
      Inc(i);
    end;
  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXml_proNFSeBrasil: Boolean;
//var
  //ok: Boolean;
  //i, Item, posI, count: Integer;
  //VersaoXML: String;
  //strAux,strAux2, strItem: AnsiString;
  //leitorAux, leitorItem:TLeitor;
begin
  Result := False;
  (*
   // Luiz Bai�o 2014.12.03 
  try
    VersaoXML      := '1';

    strAux := leitor.rExtrai_NFSEBrasil(1, 'RespostaLoteRps');

    strAux := leitor.rExtrai_NFSEBrasil(1, 'erros');
    if ( strAux <> emptystr) then begin
    
        posI := 1;
        i := 0 ;
        while ( posI > 0 ) do begin
             count := pos('</erro>', strAux) + 7;

             LeitorAux := TLeitor.Create;
             leitorAux.Arquivo := copy(strAux, PosI, count);
             leitorAux.Grupo   := leitorAux.Arquivo;
             strAux2 := leitorAux.rExtrai_NFSEBrasil(1,'erro');
             strAux2 := Leitor.rCampo(tcStr, 'erro');
             InfCanc.FMsgRetorno.Add;
             InfCanc.FMsgRetorno.Items[i].Mensagem := Leitor.rCampo(tcStr, 'erro')+#13;
             inc(i);
             LeitorAux.free;
             Delete(strAux, PosI, count);
             posI := pos('<erro>', strAux);
        end;
    end;

    strAux := leitor.rExtrai_NFSEBrasil(1, 'confirmacoes');
    if ( strAux <> emptystr) then begin

        posI := 1;
        // i := 0 ;
        while ( posI > 0 ) do begin
        
           count := pos('</confirmacao>', strAux) + 7;
           LeitorAux := TLeitor.Create;
           leitorAux.Arquivo := copy(strAux, PosI, count);
           leitorAux.Grupo   := leitorAux.Arquivo;
           strAux2 := leitorAux.rExtrai_NFSEBrasil(1,'confirmacao');
           strAux2 := Leitor.rCampo(tcStr, 'confirmacao');
           InfCanc.FMsgRetorno.Add;
           InfCanc.FMsgRetorno.Items[i].Mensagem := Leitor.rCampo(tcStr, 'confirmacao')+#13;
           inc(i);
           LeitorAux.free;
           Delete(strAux, PosI, count);
           posI := pos('<confirmacao>', strAux);
        end;
    end;

    Result := True;
  except
    result := False;
  end;
  *)
end;

function TretCancNFSe.LerXml_proSMARAPD: Boolean;
begin
  try
    if pos('sucesso', leitor.Arquivo) > 0 then
    begin
       InfCanc.Sucesso  := 'S';
       InfCanc.MsgCanc  := leitor.Arquivo;
    end
    else
      infCanc.DataHora := 0;
    FInfCanc.MsgRetorno.New;
    FInfCanc.FMsgRetorno[0].FCodigo   := '';
    FInfCanc.FMsgRetorno[0].FMensagem := leitor.Arquivo;
    FInfCanc.FMsgRetorno[0].FCorrecao := '';
    Result := True;
  except
    result := False;
  end;
end;

function TretCancNFSe.LerXml_proGeisWeb: Boolean;
var
  i: Integer;
begin
  try
    Result := True;

//    infRec.FNumeroLote      := Leitor.rCampo(tcStr, 'nrLote');
//    infRec.FDataRecebimento := Leitor.rCampo(tcDatHor, 'dtRecebimento');
//    infRec.FProtocolo       := Leitor.rCampo(tcStr, 'nrProtocolo');

    if leitor.rExtrai(1, 'CancelaNfseResposta') <> '' then
    begin
      if leitor.rExtrai(2, 'CancelaNfseResposta') <> '' then
      begin
        i := 0;
        while Leitor.rExtrai(3, 'Msg', '', i + 1) <> '' do
        begin
          FInfCanc.FMsgRetorno.New;
          FInfCanc.FMsgRetorno[i].FCodigo  := Leitor.rCampo(tcStr, 'Erro');
          FInfCanc.FMsgRetorno[i].FMensagem:= Leitor.rCampo(tcStr, 'Status');
          FInfCanc.FMsgRetorno[i].FCorrecao:= Leitor.rCampo(tcStr, '');

          inc(i);
        end;
      end;
    end;
  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXml_proGIAP: Boolean;
var
  i, j : Smallint;
  s : String;
  sMessage, sValue : TStringList;
begin
  Result   := False;
  sMessage := TStringList.Create;
  sValue   := TStringList.Create;
  try
    if Leitor.rExtrai(1, 'nfeResposta') <> '' then
    begin
      i := 0;

      while Leitor.rExtrai(2, 'notaFiscal', '', i + 1) <> '' do
      begin
        s := Leitor.rExtrai(2, 'notaFiscal', '', i + 1);
        Result := Leitor.rCampo(tcStr, 'statusEmissao') = '200';

        if Result then
        begin
          FInfCanc.DataHora        := Now;
          FInfCanc.Protocolo       := Leitor.rCampo(tcStr, 'statusEmissao');
          FInfCanc.Sucesso         := BoolToStr(Result, True);
          FInfCanc.MsgCanc         := Leitor.rAtributo('message', 'messages');
          if FInfCanc.MsgCanc = EmptyStr then
            FInfCanc.MsgCanc := 'Nota Fiscal Cancelada com Sucesso!';

          with FInfCanc.NotasCanceladas.New do
          begin
            NumeroNota        := Leitor.rCampo(tcStr, 'numeroNota');
          end;
        end
        else
        begin
          sMessage.Text:= StringReplace(s, '<messages', #13+'<messages', [rfReplaceAll]);
          sMessage.Text:= StringReplace(sMessage.Text, '</notaFiscal>', '', [rfReplaceAll]);
          for j := 0 to sMessage.Count -1 do
          begin
            if pos('messages', sMessage[j]) > 0 then
            begin
              sValue.Text := StringReplace(sMessage[j], '<messages ', '', [rfReplaceAll]);
              sValue.Text := StringReplace(sValue.Text, '/>', '', [rfReplaceAll]);
              sValue.Text := StringReplace(sValue.Text, 'message', #13+'message', [rfReplaceAll]);
              sValue.Text := StringReplace(sValue.Text, '"', '', [rfReplaceAll]);

              s := sValue.Text;

              if sValue.Count > 1 then
              begin
                with FInfCanc.MsgRetorno.New do
                begin
                  FCodigo   := sValue.Values['code'];

                  s := sValue.Values['message'];
                  s := Copy(s, 1, LastDelimiter(':', s) - 1);

                  FMensagem := s;

                  s := sValue.Values['message'];
                  Delete(s, 1, LastDelimiter(':', s));
                  FCorrecao := s;
                end;
              end;
            end;
          end;
        end;

        Inc(i);
      end;
    end;
  finally
    FreeAndNil(sMessage);
    FreeAndNil(sValue);
  end;
end;

function TretCancNFSe.LerXml_proSP: Boolean;
var
  i: Integer;
begin
  Result := False;

  try
    if leitor.rExtrai(1, 'RetornoCancelamentoNFe') <> '' then
    begin
      if (leitor.rExtrai(2, 'Cabecalho') <> '') then
      begin
        FInfCanc.FSucesso := Leitor.rCampo(tcStr, 'Sucesso');

        // Provedor n�o retorna nada mais do que o sucesso, quando cancela...��
        if (FInfCanc.FSucesso = 'true') then
          FinfCanc.FDataHora := Now;
          
        if (leitor.rExtrai(3, 'InformacoesLote') <> '') then
        begin
          FInfCanc.InformacoesLote.NumeroLote := Leitor.rCampo(tcStr, 'NumeroLote');
          FInfCanc.InformacoesLote.InscricaoPrestador := Leitor.rCampo(tcStr, 'InscricaoPrestador');
          FInfCanc.InformacoesLote.CPFCNPJRemetente := Leitor.rCampo(tcStr, 'CNPJ');
          if FInfCanc.InformacoesLote.CPFCNPJRemetente = '' then
            FInfCanc.InformacoesLote.CPFCNPJRemetente := Leitor.rCampo(tcStr, 'CPF');
          FInfCanc.InformacoesLote.DataEnvioLote := Leitor.rCampo(tcDatHor, 'DataEnvioLote');
          FInfCanc.InformacoesLote.QtdNotasProcessadas := Leitor.rCampo(tcInt, 'QtdeNotasProcessadas');
          FInfCanc.InformacoesLote.TempoProcessamento := Leitor.rCampo(tcInt, 'TempoProcessamento');
          FInfCanc.InformacoesLote.ValorTotalServico := Leitor.rCampo(tcDe2, 'ValorTotalServicos');
        end;
      end;

      i := 0;
      while Leitor.rExtrai(2, 'Alerta', '', i + 1) <> '' do
      begin
        FInfCanc.MsgRetorno.New;
        FInfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
        FInfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Descricao');
        FInfCanc.FMsgRetorno[i].FCorrecao := '';

        if (leitor.rExtrai(3, 'ChaveNFe') <> '') then
        begin
          FInfCanc.FMsgRetorno[i].FChaveNFeRPS.InscricaoPrestador := Leitor.rCampo(tcStr, 'InscricaoPrestador');
          FInfCanc.FMsgRetorno[i].FChaveNFeRPS.Numero := Leitor.rCampo(tcStr, 'Numero');
          FInfCanc.FMsgRetorno[i].FChaveNFeRPS.CodigoVerificacao := Leitor.rCampo(tcStr, 'CodigoVerificacao');
        end;

        if (leitor.rExtrai(3, 'ChaveRPS') <> '') then
        begin
          FInfCanc.FMsgRetorno[i].FChaveNFeRPS.InscricaoPrestador := Leitor.rCampo(tcStr, 'InscricaoPrestador');
          FInfCanc.FMsgRetorno[i].FChaveNFeRPS.SerieRPS := Leitor.rCampo(tcStr, 'SerieRPS');
          FInfCanc.FMsgRetorno[i].FChaveNFeRPS.NumeroRPS := Leitor.rCampo(tcStr, 'NumeroRPS');
        end;

        Inc(i);
      end;

      i := 0;
      while Leitor.rExtrai(2, 'Erro', '', i + 1) <> '' do
      begin
        FInfCanc.MsgRetorno.New;
        FInfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
        FInfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Descricao');
        FInfCanc.FMsgRetorno[i].FCorrecao := '';

        if (leitor.rExtrai(3, 'ChaveNFe') <> '') then
        begin
          FInfCanc.FMsgRetorno[i].FChaveNFeRPS.InscricaoPrestador := Leitor.rCampo(tcStr, 'InscricaoPrestador');
          FInfCanc.FMsgRetorno[i].FChaveNFeRPS.Numero := Leitor.rCampo(tcStr, 'Numero');
          FInfCanc.FMsgRetorno[i].FChaveNFeRPS.CodigoVerificacao := Leitor.rCampo(tcStr, 'CodigoVerificacao');
        end;

        if (leitor.rExtrai(3, 'ChaveRPS') <> '') then
        begin
          FInfCanc.FMsgRetorno[i].FChaveNFeRPS.InscricaoPrestador := Leitor.rCampo(tcStr, 'InscricaoPrestador');
          FInfCanc.FMsgRetorno[i].FChaveNFeRPS.SerieRPS := Leitor.rCampo(tcStr, 'SerieRPS');
          FInfCanc.FMsgRetorno[i].FChaveNFeRPS.NumeroRPS := Leitor.rCampo(tcStr, 'NumeroRPS');
        end;

        Inc(i);
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXml_proCONAM: Boolean;
var
  i: Integer;
begin
  try
    if leitor.rExtrai(1, 'Sdt_retornocancelanfe') <> '' then
    begin
      FInfCanc.FSucesso := Leitor.rCampo(tcStr, 'Retorno');
      FInfCanc.DataHora := Now;
      if leitor.rExtrai(2, 'Messages') <> '' then
      begin
        i := 0;
        while Leitor.rExtrai(3, 'Message', '', i + 1) <> '' do
        begin
          FInfCanc.MsgRetorno.New;
          FInfCanc.MsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Id');
          FInfCanc.MsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Description');
          Inc(i);
        end;
      end;
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXML_proEGoverneISS: Boolean;
var
  i: Integer;
begin
  i := 0;
  
  if (Leitor.rExtrai(1, 'CancelarResponse') <> '') then
  begin
    if Leitor.rCampo(tcStr, 'Erro') <> 'false' then
    begin
      FInfCanc.FMsgRetorno.New;
      FInfCanc.FMsgRetorno[i].FCodigo   := 'Erro';
      FInfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'MensagemErro');
    end
    else
      FInfCanc.FSucesso := 'true';
  end;

  Result := True;
end;

function TretCancNFSe.LerXml_proGoverna: Boolean;
var
  i, j, MsgErro: Integer;
  Msg: String;
begin
  try
    if (Leitor.rExtrai(1, 'RetornoLoteCancelamento') <> '') then
    begin
      j := 0;
      i := 0;
      MsgErro := 0;
      
      while Leitor.rExtrai(1, 'InfRetNotCan', '', i + 1) <> '' do
      begin
        InfCanc.FSucesso := Leitor.rCampo(tcStr, 'FlgRet'); //Valida a estrutura: V = Verdadeiro, F = Falso // LEANDROLEDO
        if (InfCanc.FSucesso = 'V') then
          infCanc.DataHora := Now;

        while Leitor.rExtrai(2, 'DesOco', '', j + 1) <> '' do
        begin
          Msg  := Leitor.rCampo(tcStr, 'DesOco');
          if (Pos('ja cancelada', Msg) > 0) then
          begin
            infCanc.DataHora := Now;
            InfCanc.FMsgRetorno.New;
            InfCanc.FMsgRetorno[MsgErro].FMensagem := Msg;
            Inc(MsgErro);
          end;
          if (Pos('OK!', Msg) = 0) and (Pos('cancelada', Msg) = 0) then
          begin
            InfCanc.FMsgRetorno.New;
            InfCanc.FMsgRetorno[MsgErro].FMensagem := Msg;
            Inc(MsgErro);
          end;
          inc(j);
        end;
        inc(i);
      end;
    end;
    {i := 0;
    while Leitor.rExtrai(2, 'InfRetRps', '', i + 1) <> '' do
    begin
      if (Leitor.rCampo(tcStr,'FlgRet') = 'V') then //V = Verdadeiro | F = Falso
      begin
        InfCanc. FListaChaveNFeRPS.Add;
        InfCanc.ListaChaveNFeRPS[i].ChaveNFeRPS.Numero := Leitor.rCampo(tcStr, 'NumNot');
        InfCanc.ListaChaveNFeRPS[i].ChaveNFeRPS.CodigoVerificacao := Leitor.rCampo(tcStr, 'CodVer');
        InfCanc.ListaChaveNFeRPS[i].ChaveNFeRPS.NumeroRPS := Leitor.rCampo(tcStr, 'NumRPS');
      end;
      Inc(i);
    end;}
    Result := True;

  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXml_proAssessorPublico: Boolean;
begin
  try
    if pos('Sucesso', leitor.Arquivo) > 0 then
    begin
       InfCanc.Sucesso  := 'S';
       InfCanc.MsgCanc  := leitor.Arquivo;
    end
    else
      infCanc.DataHora := 0;
    FInfCanc.MsgRetorno.New;
    FInfCanc.FMsgRetorno[0].FCodigo   := '';
    FInfCanc.FMsgRetorno[0].FMensagem := leitor.Arquivo;
    FInfCanc.FMsgRetorno[0].FCorrecao := '';
    Result := True;
  except
    result := False;
  end;
end;

function TretCancNFSe.LerXml_proIPM: Boolean;
var
  sRetorno, sCodigo, sMensagem: String;
begin
  Result := False;

  try
    if (Leitor.rExtrai(1, 'retorno') <> '') and (Leitor.rExtrai(1, 'mensagem') <> '') then
    begin
      sRetorno  := Leitor.rCampo(tcStr, 'codigo');
      sCodigo   := Trim(Copy(sRetorno, 1, PosAt('-', sRetorno, 1) - 1));
      sMensagem := Trim(Copy(sRetorno, PosAt('-', sRetorno, 1) + 1, Length(sRetorno)));

      if StrToIntDef(sCodigo, 0) = 1 then
      begin
        InfCanc.Sucesso  := 'True';
        InfCanc.DataHora := Now;
        InfCanc.MsgCanc  := sMensagem;

        Result := True;
      end
      else
      begin
        InfCanc.Sucesso := 'False';

        InfCanc.MsgRetorno.New;
        InfCanc.MsgRetorno[0].FCodigo   := sCodigo;
        InfCanc.MsgRetorno[0].FMensagem := sMensagem;
        InfCanc.MsgRetorno[0].FCorrecao := '';
      end;
    end;
  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXml_proSiat: Boolean;
var
  i: Integer;
begin
  Result := False;

  try
    if leitor.rExtrai(1, 'RetornoCancelamentoNFSe') <> '' then
    begin
      if (leitor.rExtrai(2, 'Cabecalho') <> '') then
      begin
        FInfCanc.FSucesso := Leitor.rCampo(tcStr, 'Sucesso');

        if FInfCanc.FSucesso = 'S' then
          FInfCanc.DataHora := Date
        else if FInfCanc.FSucesso = 'true' then
          FInfCanc.DataHora := Date;
      end;

      i := 0;
      if (leitor.rExtrai(2, 'NotasCanceladas') <> '') then
      begin
        while (Leitor.rExtrai(2, 'Nota', '', i + 1) <> '') do
        begin
          FInfCanc.FNotasCanceladas.New;
          FInfCanc.FNotasCanceladas[i].InscricaoMunicipalPrestador := Leitor.rCampo(tcStr, 'InscricaoMunicipalPrestador');
          FInfCanc.FNotasCanceladas[i].NumeroNota                  := Leitor.rCampo(tcStr, 'NumeroNota');
          FInfCanc.FNotasCanceladas[i].CodigoVerficacao            := Leitor.rCampo(tcStr,'CodigoVerificacao');
          inc(i);
        end;
      end;

      i := 0;
      if (leitor.rExtrai(2, 'Alertas') <> '') then
      begin
        while (Leitor.rExtrai(2, 'Alerta', '', i + 1) <> '') do
        begin
          InfCanc.FMsgRetorno.New;
          InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
          InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Descricao');
          InfCanc.FMsgRetorno[i].FCorrecao := '';
          inc(i);
        end;
      end;

      i := 0;
      if (leitor.rExtrai(2, 'Erros') <> '') then
      begin
        while (Leitor.rExtrai(2, 'Erro', '', i + 1) <> '') do
        begin
          InfCanc.FMsgRetorno.New;
          InfCanc.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
          InfCanc.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Descricao');
          InfCanc.FMsgRetorno[i].FCorrecao := '';
          inc(i);
        end;
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TretCancNFSe.LerXml_proSigISS: Boolean;
begin
  Result := False;
  try
    if Leitor.rExtrai(1, 'RetornoNota') <> EmptyStr then
    begin
      if Leitor.rCampo(tcStr, 'Resultado') = '1' then
      begin
        with FInfCanc.FNotasCanceladas.New do
        begin
          InfCanc.Sucesso  := 'True';
          InfCanc.DataHora := Now;
          InfCanc.MsgCanc  := Leitor.rCampo(tcStr, 'DescricaoProcesso')+ ': '+Leitor.rCampo(tcStr, 'DescricaoErro');
          Result := True;
        end;
      end
      else if Leitor.rExtrai(1, 'DescricaoErros') <> EmptyStr then
      begin
        InfCanc.MsgRetorno.New;
        InfCanc.MsgRetorno[0].FCodigo   := Leitor.rCampo(tcStr, 'id');;
        InfCanc.MsgRetorno[0].FMensagem := Leitor.rCampo(tcStr, 'DescricaoProcesso')+ ': '+Leitor.rCampo(tcStr, 'DescricaoErro');
        InfCanc.MsgRetorno[0].FCorrecao := '';
        Result := False;
      end
      else
      begin
        with InfCanc.MsgRetorno.New do
        begin
          Codigo := '0';
          Mensagem:= 'Nota N�o Existe';
        end;
        Result := False;
      end;
    end;
  except
    Result := False;
  end;
end;

end.

