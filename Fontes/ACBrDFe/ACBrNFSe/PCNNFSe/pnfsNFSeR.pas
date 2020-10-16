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

unit pnfsNFSeR;

interface

uses
  SysUtils, Classes, Variants, IniFiles,
  pcnAuxiliar, pcnConversao, pcnLeitor, pnfsNFSe, pnfsConversao;

type

 TLeitorOpcoes   = class;

 { TNFSeR }

 TNFSeR = class(TPersistent)
  private
    FNivel: Integer;

    FLeitor: TLeitor;
    FNFSe: TNFSe;
    FOpcoes: TLeitorOpcoes;
    FVersaoXML: String;
    FProvedor: TnfseProvedor;
    FTabServicosExt: Boolean;
    FProvedorConf: TnfseProvedor;
    FPathIniCidades: String;
    FVersaoNFSe: TVersaoNFSe;
    FLayoutXML: TLayoutXML;
    FProducao: TnfseSimNao;

    function LerRPS_ABRASF_V1: Boolean;
    function LerRPS_ABRASF_V2: Boolean;

    function LerRPS_ISSDSF: Boolean;
    function LerRPS_Equiplano: Boolean;
    function LerRps_EL: Boolean;
    function LerRps_Governa: Boolean;
    function LerRPS_Agili: Boolean;
    function LerRPS_SP: Boolean;
    function LerRPS_AssessorPublico : boolean;
    function LerRPS_Siat: Boolean; 

    function LerNFSe_ABRASF_V1: Boolean;
    function LerNFSe_ABRASF_V2: Boolean;

    function LerNFSe_ISSDSF: Boolean;
    function LerNFSe_Equiplano: Boolean;
    function LerNFSe_Infisc: Boolean;
    function LerNFSe_EL: Boolean;
    function LerNFSe_Governa: Boolean;
    function LerNFSe_CONAM: Boolean;
    function LerNFSe_Agili: Boolean;
    function LerNFSe_Siat: Boolean; 

    function LerNFSe_Infisc_V10: Boolean;
    function LerNFSe_Infisc_V11: Boolean;

    function LerNFSe_SP: Boolean;
    function LerNFSe_Smarapd: Boolean;
    function LerNFSe_Giap: Boolean;
    function LerNFSe_IPM: Boolean;
    function LerNFSe_SigIss: Boolean;
    function LerNFSe_Elotech: Boolean;

    function LerRPS: Boolean;
    function LerNFSe: Boolean;

    function CodCidadeToProvedor(const CodCidade: String): TNFSeProvedor;
    procedure SetxItemListaServico;
  public
    constructor Create(AOwner: TNFSe);
    destructor Destroy; override;
    function LerXml: Boolean;
  published
    property Leitor: TLeitor             read FLeitor         write FLeitor;
    property NFSe: TNFSe                 read FNFSe           write FNFSe;
    property Opcoes: TLeitorOpcoes       read FOpcoes         write FOpcoes;
    property VersaoXML: String           read FVersaoXML      write FVersaoXML;
    property Provedor: TnfseProvedor     read FProvedor       write FProvedor;
    property ProvedorConf: TnfseProvedor read FProvedorConf   write FProvedorConf;
    property TabServicosExt: Boolean     read FTabServicosExt write FTabServicosExt;
    property PathIniCidades: String      read FPathIniCidades write FPathIniCidades;
    property VersaoNFSe: TVersaoNFSe     read FVersaoNFSe     write FVersaoNFSe;
    property LayoutXML: TLayoutXML       read FLayoutXML      write FLayoutXML;
    property Producao: TnfseSimNao       read FProducao       write FProducao;
  end;

 TLeitorOpcoes = class(TPersistent)
  private
    FPathArquivoMunicipios: String;
    FPathArquivoTabServicos: String;
  published
    property PathArquivoMunicipios: String  read FPathArquivoMunicipios  write FPathArquivoMunicipios;
    property PathArquivoTabServicos: String read FPathArquivoTabServicos write FPathArquivoTabServicos;
  end;

implementation

uses
  Math, StrUtils, DateUtils, ACBrUtil;

{ TNFSeR }

constructor TNFSeR.Create(AOwner: TNFSe);
begin
  inherited Create;
  FLeitor := TLeitor.Create;
  FNFSe   := AOwner;
  FOpcoes := TLeitorOpcoes.Create;
  FOpcoes.FPathArquivoMunicipios  := '';
  FOpcoes.FPathArquivoTabServicos := '';
end;

destructor TNFSeR.Destroy;
begin
  FLeitor.Free;
  FOpcoes.Free;

  inherited Destroy;
end;

function TNFSeR.CodCidadeToProvedor(const CodCidade: String): TNFSeProvedor;
var
  Ok: Boolean;
  NomeArqParams: String;
  IniParams: TMemIniFile;
begin
  NomeArqParams := PathIniCidades + '\Cidades.ini';

  if not FileExists(NomeArqParams) then
    raise Exception.Create('Arquivo de Par�metro n�o encontrado: ' +
      NomeArqParams);

  IniParams := TMemIniFile.Create(NomeArqParams);

  Result := StrToProvedor(Ok, IniParams.ReadString(CodCidade, 'Provedor', ''));

  IniParams.Free;
end;

procedure TNFSeR.SetxItemListaServico;
var
  Item: Integer;
  ItemServico: string;
begin
  NFSe.Servico.ItemListaServico := OnlyNumber(Leitor.rCampo(tcStr, 'ItemListaServico'));

  if NFSe.Servico.ItemListaServico = '' then
    NFSe.Servico.ItemListaServico := OnlyNumber(Leitor.rCampo(tcStr, 'CodigoServico'));

  if FProvedor = proMegaSoft then
    NFSe.Servico.ItemListaServico := OnlyNumber(Leitor.rCampo(tcStr, 'CodigoTributacaoMunicipio'));

  Item := StrToIntDef(OnlyNumber(Nfse.Servico.ItemListaServico), 0);
  if Item < 100 then
    Item := Item * 100 + 1;

  ItemServico := FormatFloat('0000', Item);

  case FProvedor of
    proAbaco:
      NFSe.Servico.ItemListaServico := IntToStr(Item);

    ProRJ, ProSisPMJP:
      NFSe.Servico.ItemListaServico := ItemServico;

    ProTecnos:
      NFSe.Servico.ItemListaServico := RemoveZerosEsquerda(Copy(ItemServico, 1, 2)) + '.' + Copy(ItemServico, 3, 2);
  else
    NFSe.Servico.ItemListaServico := Copy(ItemServico, 1, 2) + '.' +
                                     Copy(ItemServico, 3, 2);
  end;

  if TabServicosExt then
    NFSe.Servico.xItemListaServico := ObterDescricaoServico(OnlyNumber(NFSe.Servico.ItemListaServico))
  else
    NFSe.Servico.xItemListaServico := CodigoToDesc(OnlyNumber(NFSe.Servico.ItemListaServico));
end;

function TNFSeR.LerXml: Boolean;
begin
  if (Pos('<Nfse', Leitor.Arquivo) > 0)          or (Pos('<Notas>', Leitor.Arquivo) > 0) or
     (Pos('<Nota>', Leitor.Arquivo) > 0)         or (Pos('<NFS-e>', Leitor.Arquivo) > 0) or
     (Pos('<nfse', Leitor.Arquivo) > 0)          or (Pos('NumNot', Leitor.Arquivo) > 0) or
     (Pos('<ConsultaNFSe>', Leitor.Arquivo) > 0) or (Pos('<Reg20Item>', Leitor.Arquivo) > 0) or
     (Pos('<CompNfse', Leitor.Arquivo) > 0)      or (Pos('<NFe', Leitor.Arquivo) > 0) or
     (Pos('<notasFiscais>', Leitor.Arquivo) > 0) or (Pos('<nfeRpsNotaFiscal>', Leitor.Arquivo) > 0) or
     (Pos('<infNFSe ', Leitor.Arquivo) > 0)      or (Pos('<nfs', Leitor.Arquivo) > 0) or
     (Pos('<nota>', Leitor.Arquivo) > 0)         or (Pos('<nota_recebida>', Leitor.Arquivo) > 0) or
     (Pos('NotaFiscalRelatorioDTO', Leitor.Arquivo) > 0) or (Pos('</autenticidade>', Leitor.Arquivo) > 0)  then
    Result := LerNFSe
  else
    if (Pos('<Rps', Leitor.Arquivo) > 0) or (Pos('<rps', Leitor.Arquivo) > 0) or
       (Pos('<RPS', Leitor.Arquivo) > 0) then
      Result := LerRPS
  else
    if (Pos('<nfdok', Leitor.Arquivo) > 0) then
      Result := LerNFSe_Smarapd
  else 
    if (Pos('<notaFiscal', Leitor.Arquivo) > 0) then
      Result := LerNFSe_Giap
    else
      Result := False;
end;

////////////////////////////////////////////////////////////////////////////////
//  Fun��es especificas para ler o XML de um RPS                              //
////////////////////////////////////////////////////////////////////////////////

function TNFSeR.LerRPS: Boolean;
var
  CM: String;
begin
  Result := False;

  if FProvedor = proNenhum then
  begin
    if (Leitor.rExtrai(1, 'OrgaoGerador') <> '') then
    begin
      CM := Leitor.rCampo(tcStr, 'CodigoMunicipio');
      FProvedor := CodCidadeToProvedor(CM);
    end;

    if FProvedor = proNenhum then
    begin
      if (Leitor.rExtrai(1, 'Servico') <> '') then
      begin
        CM := Leitor.rCampo(tcStr, 'CodigoMunicipio');
        FProvedor := CodCidadeToProvedor(CM);
      end;
    end;

    if FProvedor = proNenhum then
    begin
      if (Leitor.rExtrai(1, 'PrestadorServico') <> '') then
      begin
        CM := OnlyNumber(Leitor.rCampo(tcStr, 'CodigoMunicipio'));
        if CM = '' then
          CM := Leitor.rCampo(tcStr, 'Cidade');
        FProvedor := CodCidadeToProvedor(CM);
      end;
    end;

    // ISSDSF
    if FProvedor = proNenhum then
    begin
      if (Leitor.rExtrai(1, 'Cabecalho') <> '') then
      begin
        CM := CodSiafiToCodCidade( Leitor.rCampo(tcStr, 'CodCidade') );
        FProvedor := CodCidadeToProvedor(CM);
      end
    end;

    if FProvedor = proNenhum then
      FProvedor := FProvedorConf;
  end;

  VersaoNFSe := ProvedorToVersaoNFSe(FProvedor);
  LayoutXML := ProvedorToLayoutXML(FProvedor);

  if (Leitor.rExtrai(1, 'Rps') <> '') or (Leitor.rExtrai(1, 'RPS') <> '') or (Leitor.rExtrai(1, 'rps') <> '') or
     (Leitor.rExtrai(1, 'LoteRps') <> '') then
  begin
    case LayoutXML of
      loABRASFv1:    Result := LerRPS_ABRASF_V1;
      loABRASFv2:    Result := LerRPS_ABRASF_V2;
      loEGoverneISS: Result := False; // Falta implementar
      loEL:          Result := LerRps_EL;
      loEquiplano:   Result := LerRPS_Equiplano;
      loGoverna:     Result := LerRps_Governa;
      loInfisc:      Result := False; // Falta implementar
      loISSDSF:      Result := LerRPS_ISSDSF;
      loAgili:       Result := LerRPS_Agili;
      loSP:          Result := LerRPS_SP;
      loSMARAPD:     Result := LerNFSe_Smarapd;
      loAssessorPublico: Result := LerRPS_AssessorPublico;
      loSiat:        Result := LerRPS_Siat;     
    else
      Result := False;
    end;
  end;
end;

function TNFSeR.LerRPS_ABRASF_V1: Boolean;
var
  i: Integer;
  ok: Boolean;
begin
  if (Leitor.rExtrai(2, 'InfRps') <> '') or (Leitor.rExtrai(1, 'Rps') <> '') then
  begin
    NFSe.DataEmissaoRps := Leitor.rCampo(tcDat, 'DataEmissao');

    if (Leitor.rExtrai(1, 'InfRps') <> '') then
      NFSe.DataEmissao := Leitor.rCampo(tcDatHor, 'DataEmissao');

    NFSe.NaturezaOperacao         := StrToNaturezaOperacao(ok, Leitor.rCampo(tcStr, 'NaturezaOperacao'));
    NFSe.RegimeEspecialTributacao := StrToRegimeEspecialTributacao(ok, Leitor.rCampo(tcStr, 'RegimeEspecialTributacao'));
    NFSe.OptanteSimplesNacional   := StrToSimNao(ok, Leitor.rCampo(tcStr, 'OptanteSimplesNacional'));
    NFSe.IncentivadorCultural     := StrToSimNao(ok, Leitor.rCampo(tcStr, 'IncentivadorCultural'));
    NFSe.Status                   := StrToStatusRPS(ok, Leitor.rCampo(tcStr, 'Status'));
    NFSe.OutrasInformacoes        := Leitor.rCampo(tcStr, 'OutrasInformacoes');

    if (Leitor.rExtrai(3, 'IdentificacaoRps') <> '') or
       (Leitor.rExtrai(2, 'IdentificacaoRps') <> '') then
    begin
      NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'Numero');
      NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'Serie');
      NFSe.IdentificacaoRps.Tipo   := StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));
      NFSe.InfID.ID                := OnlyNumber(NFSe.IdentificacaoRps.Numero) + NFSe.IdentificacaoRps.Serie;
    end;

    if (Leitor.rExtrai(3, 'RpsSubstituido') <> '') or
       (Leitor.rExtrai(2, 'RpsSubstituido') <> '') then
    begin
      NFSe.RpsSubstituido.Numero := Leitor.rCampo(tcStr, 'Numero');
      NFSe.RpsSubstituido.Serie  := Leitor.rCampo(tcStr, 'Serie');
      NFSe.RpsSubstituido.Tipo   := StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));
    end;

    if (Leitor.rExtrai(3, 'Servico') <> '') or
       (Leitor.rExtrai(2, 'Servico') <> '') then
    begin
      NFSe.Servico.CodigoCnae                := Leitor.rCampo(tcStr, 'CodigoCnae');
      NFSe.Servico.CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'CodigoTributacaoMunicipio');
      NFSe.Servico.Discriminacao             := Leitor.rCampo(tcStr, 'Discriminacao');
      NFSe.Servico.Descricao                 := '';

      NFSe.Servico.CodigoMunicipio := Leitor.rCampo(tcStr, 'MunicipioPrestacaoServico');
      if NFSe.Servico.CodigoMunicipio = '' then
        NFSe.Servico.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');

      SetxItemListaServico;

      if length(NFSe.Servico.CodigoMunicipio) < 7 then
        NFSe.Servico.CodigoMunicipio := Copy(NFSe.Servico.CodigoMunicipio, 1, 2) +
            FormatFloat('00000', StrToIntDef(Copy(NFSe.Servico.CodigoMunicipio, 3, 5), 0));

      if (Leitor.rExtrai(4, 'Valores') <> '') or
         (Leitor.rExtrai(3, 'Valores') <> '') then
      begin
        NFSe.Servico.Valores.ValorServicos          := Leitor.rCampo(tcDe2, 'ValorServicos');
        NFSe.Servico.Valores.ValorDeducoes          := Leitor.rCampo(tcDe2, 'ValorDeducoes');
        NFSe.Servico.Valores.ValorTotalRecebido     := Leitor.rCampo(tcDe2, 'ValorTotalRecebido');
        NFSe.Servico.Valores.ValorPis               := Leitor.rCampo(tcDe2, 'ValorPis');
        NFSe.Servico.Valores.ValorCofins            := Leitor.rCampo(tcDe2, 'ValorCofins');
        NFSe.Servico.Valores.ValorInss              := Leitor.rCampo(tcDe2, 'ValorInss');
        NFSe.Servico.Valores.ValorIr                := Leitor.rCampo(tcDe2, 'ValorIr');
        NFSe.Servico.Valores.ValorCsll              := Leitor.rCampo(tcDe2, 'ValorCsll');
        NFSe.Servico.Valores.IssRetido              := StrToSituacaoTributaria(ok, Leitor.rCampo(tcStr, 'IssRetido'));
        NFSe.Servico.Valores.ValorIss               := Leitor.rCampo(tcDe2, 'ValorIss');
        NFSe.Servico.Valores.OutrasRetencoes        := Leitor.rCampo(tcDe2, 'OutrasRetencoes');
        NFSe.Servico.Valores.BaseCalculo            := Leitor.rCampo(tcDe2, 'BaseCalculo');
        NFSe.Servico.Valores.Aliquota               := Leitor.rCampo(tcDe3, 'Aliquota');

        if (FProvedor in [proThema, proGinfes, proRJ, proPublica, proBHISS,
            proAbaco]) then
          NFSe.Servico.Valores.Aliquota := (NFSe.Servico.Valores.Aliquota * 100);

        NFSe.Servico.Valores.ValorLiquidoNfse       := Leitor.rCampo(tcDe2, 'ValorLiquidoNfse');
        NFSe.Servico.Valores.ValorIssRetido         := Leitor.rCampo(tcDe2, 'ValorIssRetido');
        NFSe.Servico.Valores.DescontoCondicionado   := Leitor.rCampo(tcDe2, 'DescontoCondicionado');
        NFSe.Servico.Valores.DescontoIncondicionado := Leitor.rCampo(tcDe2, 'DescontoIncondicionado');
      end;

      //Provedor SimplISS permite varios itens servico
      if FProvedor = proSimplISS then
      begin
        i := 1;
        while (Leitor.rExtrai(4, 'ItensServico', 'ItensServico', i) <> '') do
        begin
          with NFSe.Servico.ItemServico.New do
          begin
            Descricao     := Leitor.rCampo(tcStr, 'Descricao');
            Quantidade    := Leitor.rCampo(tcDe2, 'Quantidade');
            ValorUnitario := Leitor.rCampo(tcDe2, 'ValorUnitario');
            ValorTotal    := Leitor.rCampo(tcDe2, 'ValorTotal');

            if ValorTotal = 0 then
              ValorTotal := Quantidade * ValorUnitario;
          end;
          inc(i);
        end;
      end;
    end; // fim Servico

    if (Leitor.rExtrai(3, 'Prestador') <> '') or
       (Leitor.rExtrai(2, 'Prestador') <> '') then
    begin
      NFSe.Prestador.Cnpj               := Leitor.rCampo(tcStr, 'Cnpj');
      NFSe.Prestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
      NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cnpj');
    end; // fim Prestador

    if (Leitor.rExtrai(3, 'Tomador') <> '') or (Leitor.rExtrai(3, 'TomadorServico') <> '') or
       (Leitor.rExtrai(2, 'Tomador') <> '') or (Leitor.rExtrai(2, 'TomadorServico') <> '') then
    begin
      NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'RazaoSocial');
      NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual := Leitor.rCampo(tcStr, 'InscricaoEstadual');

      NFSe.Tomador.Endereco.Endereco := Leitor.rCampo(tcStr, 'Endereco');
      if Copy(NFSe.Tomador.Endereco.Endereco, 1, 10) = '<Endereco>' then
        NFSe.Tomador.Endereco.Endereco := Copy(NFSe.Tomador.Endereco.Endereco, 11, 125);

      NFSe.Tomador.Endereco.Numero      := Leitor.rCampo(tcStr, 'Numero');
      NFSe.Tomador.Endereco.Complemento := Leitor.rCampo(tcStr, 'Complemento');
      NFSe.Tomador.Endereco.Bairro      := Leitor.rCampo(tcStr, 'Bairro');

      NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
      if NFSe.Tomador.Endereco.CodigoMunicipio = '' then
        NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'Cidade');

      NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'Uf');
      if NFSe.Tomador.Endereco.UF = '' then
        NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'Estado');

      NFSe.Tomador.Endereco.CEP := Leitor.rCampo(tcStr, 'Cep');

      if length(NFSe.Tomador.Endereco.CodigoMunicipio) < 7 then
        NFSe.Tomador.Endereco.CodigoMunicipio := Copy(NFSe.Tomador.Endereco.CodigoMunicipio, 1, 2) +
             FormatFloat('00000', StrToIntDef(Copy(NFSe.Tomador.Endereco.CodigoMunicipio, 3, 5), 0));

      if NFSe.Tomador.Endereco.UF = '' then
        NFSe.Tomador.Endereco.UF := NFSe.PrestadorServico.Endereco.UF;

      NFSe.Tomador.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0));

      if (Leitor.rExtrai(4, 'IdentificacaoTomador') <> '') or
         (Leitor.rExtrai(3, 'IdentificacaoTomador') <> '') then
      begin
        NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');

        if Leitor.rExtrai(5, 'CpfCnpj') <> '' then
        begin
          if Leitor.rCampo(tcStr, 'Cpf') <> '' then
            NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'Cpf')
          else
            NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'Cnpj');
        end;
      end;

      if Leitor.rExtrai(4, 'Contato') <> '' then
      begin
        NFSe.Tomador.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
        NFSe.Tomador.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
      end;

    end; // fim Tomador

    if Leitor.rExtrai(3, 'IntermediarioServico') <> '' then
    begin
      NFSe.IntermediarioServico.RazaoSocial        := Leitor.rCampo(tcStr, 'RazaoSocial');
      NFSe.IntermediarioServico.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
      if Leitor.rExtrai(4, 'CpfCnpj') <> '' then
      begin
        if Leitor.rCampo(tcStr, 'Cpf')<>'' then
          NFSe.IntermediarioServico.CpfCnpj := Leitor.rCampo(tcStr, 'Cpf')
        else
          NFSe.IntermediarioServico.CpfCnpj := Leitor.rCampo(tcStr, 'Cnpj');
      end;
    end;

    if Leitor.rExtrai(3, 'ConstrucaoCivil') <> '' then
    begin
      NFSe.ConstrucaoCivil.CodigoObra := Leitor.rCampo(tcStr, 'CodigoObra');
      NFSe.ConstrucaoCivil.Art        := Leitor.rCampo(tcStr, 'Art');
    end;
  end; // fim InfRps

  Result := True;
end;

function TNFSeR.LerRPS_ABRASF_V2: Boolean;
var
  i: Integer;
  ok: Boolean;
begin
  // Para o provedor ISSDigital
  if (Leitor.rExtrai(2, 'ValoresServico') <> '') then
  begin
    NFSe.Servico.Valores.ValorServicos    := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.Servico.Valores.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'ValorLiquidoNfse');
    NFSe.Servico.Valores.ValorIss         := Leitor.rCampo(tcDe2, 'ValorIss');
  end;

  // Para o provedor ISSDigital
  if (Leitor.rExtrai(2, 'ListaServicos') <> '') then
  begin
    NFSe.Servico.Valores.IssRetido   := StrToSituacaoTributaria(ok, Leitor.rCampo(tcStr, 'IssRetido'));
    NFSe.Servico.ResponsavelRetencao := StrToResponsavelRetencao(ok, Leitor.rCampo(tcStr, 'ResponsavelRetencao'));

    SetxItemListaServico;

    //NFSe.Servico.Discriminacao       := Leitor.rCampo(tcStr, 'Discriminacao');
    NFSe.Servico.CodigoMunicipio     := Leitor.rCampo(tcStr, 'CodigoMunicipio');
    NFSe.Servico.CodigoPais          := Leitor.rCampo(tcInt, 'CodigoPais');
    NFSe.Servico.ExigibilidadeISS    := StrToExigibilidadeISS(ok, Leitor.rCampo(tcStr, 'ExigibilidadeISS'));
    NFSe.Servico.MunicipioIncidencia := Leitor.rCampo(tcInt, 'MunicipioIncidencia');

    NFSe.Servico.Valores.Aliquota    := Leitor.rCampo(tcDe3, 'Aliquota');

    //Se n�o me engano o maximo de servicos � 10...n�o?
    for I := 1 to 10 do
    begin
      if (Leitor.rExtrai(2, 'Servico', 'Servico', i) <> '') then
      begin
        with NFSe.Servico.ItemServico.New do
        begin
          Descricao := Leitor.rCampo(tcStr, 'Discriminacao');

          if (Leitor.rExtrai(3, 'Valores') <> '') then
          begin
            ValorServicos := Leitor.rCampo(tcDe2, 'ValorServicos');
            ValorDeducoes := Leitor.rCampo(tcDe2, 'ValorDeducoes');
            ValorIss      := Leitor.rCampo(tcDe2, 'ValorIss');
            Aliquota      := Leitor.rCampo(tcDe3, 'Aliquota');
            BaseCalculo   := Leitor.rCampo(tcDe2, 'BaseCalculo');
          end;
        end;
      end
      else
        Break;
    end;
  end; // fim lista servi�o

  if (Leitor.rExtrai(2, 'InfDeclaracaoPrestacaoServico') <> '') or
     (Leitor.rExtrai(1, 'InfDeclaracaoPrestacaoServico') <> '') then
  begin
    case FProvedor of
      proTecnos:
        NFSe.Competencia := DateTimeToStr(StrToFloatDef(Leitor.rCampo(tcDatHor, 'Competencia'), 0));

      proSigCorp,
      proSimplISSv2:
        NFSe.Competencia := DateToStr(Leitor.rCampo(tcDat, 'Competencia'));
    else
      NFSe.Competencia := Leitor.rCampo(tcStr, 'Competencia');
    end;

    NFSe.RegimeEspecialTributacao := StrToRegimeEspecialTributacao(ok, Leitor.rCampo(tcStr, 'RegimeEspecialTributacao'));
    NFSe.OptanteSimplesNacional   := StrToSimNao(ok, Leitor.rCampo(tcStr, 'OptanteSimplesNacional'));
    NFSe.IncentivadorCultural     := StrToSimNao(ok, Leitor.rCampo(tcStr, 'IncentivoFiscal'));

    if FProvedor = proCONAM then
      NFSe.Producao := StrToSimNao(ok, Leitor.rCampo(tcStr, 'Producao'));

    if (Leitor.rExtrai(3, 'Rps') <> '') or (Leitor.rExtrai(2, 'Rps') <> '') then
    begin
      NFSe.DataEmissaoRps := Leitor.rCampo(tcDat, 'DataEmissao');
      NFSe.DataEmissao := Leitor.rCampo(tcDat, 'DataEmissao');
      NFSe.Status         := StrToStatusRPS(ok, Leitor.rCampo(tcStr, 'Status'));

      if (Leitor.rExtrai(3, 'IdentificacaoRps') <> '') then
      begin
        NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'Numero');
        NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'Serie');
        NFSe.IdentificacaoRps.Tipo   := StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));
        NFSe.InfID.ID                := OnlyNumber(NFSe.IdentificacaoRps.Numero) + NFSe.IdentificacaoRps.Serie;
      end;
    end;

    if (Leitor.rExtrai(3, 'Servico') <> '') or (Leitor.rExtrai(2, 'Servico') <> '') then
    begin
      NFSe.Servico.Valores.IssRetido   := StrToSituacaoTributaria(ok, Leitor.rCampo(tcStr, 'IssRetido'));
      NFSe.Servico.ResponsavelRetencao := StrToResponsavelRetencao(ok, Leitor.rCampo(tcStr, 'ResponsavelRetencao'));
      NFSe.Servico.CodigoCnae          := Leitor.rCampo(tcStr, 'CodigoCnae');

      SetxItemListaServico;

      NFSe.Servico.Discriminacao       := Leitor.rCampo(tcStr, 'Discriminacao');
      NFSe.Servico.Descricao           := '';
      NFSe.Servico.CodigoMunicipio     := Leitor.rCampo(tcStr, 'CodigoMunicipio');
      NFSe.Servico.CodigoPais          := Leitor.rCampo(tcInt, 'CodigoPais');
      if (FProvedor = proABAse) then
        NFSe.Servico.ExigibilidadeISS          :=  StrToExigibilidadeISS(ok, Leitor.rCampo(tcStr, 'Exigibilidade'))
      else
        NFSe.Servico.ExigibilidadeISS          := StrToExigibilidadeISS(ok, Leitor.rCampo(tcStr, 'ExigibilidadeISS'));
      //NFSe.Servico.ExigibilidadeISS    := StrToExigibilidadeISS(ok, Leitor.rCampo(tcStr, 'ExigibilidadeISS'));
      NFSe.Servico.MunicipioIncidencia := Leitor.rCampo(tcInt, 'MunicipioIncidencia');

      // Provedor Goiania
      NFSe.Servico.CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'CodigoTributacaoMunicipio');

      if (Leitor.rExtrai(4, 'Valores') <> '') or (Leitor.rExtrai(3, 'Valores') <> '') then
      begin
        NFSe.Servico.Valores.ValorServicos          := Leitor.rCampo(tcDe2, 'ValorServicos');
        NFSe.Servico.Valores.ValorDeducoes          := Leitor.rCampo(tcDe2, 'ValorDeducoes');
        NFSe.Servico.Valores.ValorPis               := Leitor.rCampo(tcDe2, 'ValorPis');
        NFSe.Servico.Valores.ValorIss               := Leitor.rCampo(tcDe2, 'ValorIss');
        NFSe.Servico.Valores.Aliquota               := Leitor.rCampo(tcDe3, 'Aliquota');
        NFSe.Servico.Valores.OutrasRetencoes        := Leitor.rCampo(tcDe2, 'OutrasRetencoes');

        // Provedor Goiania
        NFSe.Servico.Valores.ValorCofins            := Leitor.rCampo(tcDe2, 'ValorCofins');
        NFSe.Servico.Valores.ValorInss              := Leitor.rCampo(tcDe2, 'ValorInss');
        NFSe.Servico.Valores.ValorIr                := Leitor.rCampo(tcDe2, 'ValorIr');
        NFSe.Servico.Valores.ValorCsll              := Leitor.rCampo(tcDe2, 'ValorCsll');
        NFSe.Servico.Valores.DescontoIncondicionado := Leitor.rCampo(tcDe3, 'DescontoIncondicionado');
        NFSe.Servico.Valores.DescontoCondicionado   := Leitor.rCampo(tcDe2, 'DescontoCondicionado');

        if (FProvedor in [proISSe, proVersaTecnologia, proNEAInformatica, proFiorilli, proPronimv2, proEReceita, proSigCorp]) then
        begin
          if NFSe.Servico.Valores.IssRetido = stRetencao then
            NFSe.Servico.Valores.ValorIssRetido := Leitor.rCampo(tcDe2, 'ValorIss')
          else
            NFSe.Servico.Valores.ValorIssRetido := 0;
        end
        else
          NFSe.Servico.Valores.ValorIssRetido := Leitor.rCampo(tcDe2, 'ValorIssRetido');

        if NFSe.Servico.Valores.ValorLiquidoNfse = 0 then
          NFSe.Servico.Valores.ValorLiquidoNfse := NFSe.Servico.Valores.ValorServicos -
                                                   NFSe.Servico.Valores.DescontoIncondicionado -
                                                   NFSe.Servico.Valores.DescontoCondicionado -
                                                   // Reten��es Federais
                                                   NFSe.Servico.Valores.ValorPis -
                                                   NFSe.Servico.Valores.ValorCofins -
                                                   NFSe.Servico.Valores.ValorIr -
                                                   NFSe.Servico.Valores.ValorInss -
                                                   NFSe.Servico.Valores.ValorCsll -

                                                   NFSe.Servico.Valores.OutrasRetencoes -
                                                   NFSe.Servico.Valores.ValorIssRetido;

        if NFSe.Servico.Valores.BaseCalculo = 0 then
          NFSe.Servico.Valores.BaseCalculo := NFSe.Servico.Valores.ValorServicos -
                                              NFSe.Servico.Valores.ValorDeducoes -
                                              NFSe.Servico.Valores.DescontoIncondicionado;

//        if NFSe.Servico.Valores.ValorIss = 0 then
//          NFSe.Servico.Valores.ValorIss := (NFSe.Servico.Valores.BaseCalculo * NFSe.Servico.Valores.Aliquota)/100;

      end;
    end; // fim servi�o

    if (Leitor.rExtrai(3, 'Prestador') <> '') or (Leitor.rExtrai(2, 'Prestador') <> '') then
    begin
      NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
      NFSe.Prestador.InscricaoMunicipal := NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal;

      if (VersaoNFSe = ve100) or (FProvedor = proDigifred) then
      begin
        if (Leitor.rExtrai(4, 'CpfCnpj') <> '') or (Leitor.rExtrai(3, 'CpfCnpj') <> '') then
        begin
          NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cpf');
          if NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj = '' then
            NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cnpj');
        end;
      end
      else
      begin
        NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cnpj');
      end;

      NFSe.Prestador.Cnpj := NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj;
    end; // fim Prestador

   if (Leitor.rExtrai(3, 'Tomador') <> '') or (Leitor.rExtrai(3, 'TomadorServico') <> '') or
      (Leitor.rExtrai(2, 'Tomador') <> '') or (Leitor.rExtrai(2, 'TomadorServico') <> '')
    then
    begin
      NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'RazaoSocial');
      NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual  := Leitor.rCampo(tcStr, 'InscricaoEstadual');

      NFSe.Tomador.Endereco.Endereco := Leitor.rCampo(tcStr, 'Endereco');
      if Copy(NFSe.Tomador.Endereco.Endereco, 1, 10) = '<Endereco>' then
        NFSe.Tomador.Endereco.Endereco := Copy(NFSe.Tomador.Endereco.Endereco, 11, 125);

      NFSe.Tomador.Endereco.Numero      := Leitor.rCampo(tcStr, 'Numero');
      NFSe.Tomador.Endereco.Complemento := Leitor.rCampo(tcStr, 'Complemento');
      NFSe.Tomador.Endereco.Bairro      := Leitor.rCampo(tcStr, 'Bairro');

      NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
      if NFSe.Tomador.Endereco.CodigoMunicipio = '' then
        NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'Cidade');
      if NFSe.Tomador.Endereco.CodigoMunicipio = '' then
        NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipioIBGE');

      NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'Uf');
      if NFSe.Tomador.Endereco.UF = '' then
        NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'Estado');

      NFSe.Tomador.Endereco.CEP := Leitor.rCampo(tcStr, 'Cep');

      if length(NFSe.Tomador.Endereco.CodigoMunicipio) < 7 then
        NFSe.Tomador.Endereco.CodigoMunicipio := Copy(NFSe.Tomador.Endereco.CodigoMunicipio, 1, 2) +
          FormatFloat('00000', StrToIntDef(Copy(NFSe.Tomador.Endereco.CodigoMunicipio, 3, 5), 0));

      if NFSe.Tomador.Endereco.UF = '' then
        NFSe.Tomador.Endereco.UF := NFSe.PrestadorServico.Endereco.UF;

      NFSe.Tomador.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0));

      NFSe.Tomador.Endereco.CodigoPais := Leitor.rCampo(tcInt, 'CodigoPais');

      if (Leitor.rExtrai(4, 'IdentificacaoTomador') <> '') or (Leitor.rExtrai(3, 'IdentificacaoTomador') <> '') then
      begin
        NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');

        if (Leitor.rExtrai(5, 'CpfCnpj') <> '') or (Leitor.rExtrai(4, 'CpfCnpj') <> '') then
        begin
          if Leitor.rCampo(tcStr, 'Cpf')<>'' then
            NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'Cpf')
          else
            NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'Cnpj');
        end;
      end;

      if (Leitor.rExtrai(4, 'Contato') <> '') or (Leitor.rExtrai(3, 'Contato') <> '') then
      begin
        NFSe.Tomador.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
        NFSe.Tomador.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
      end;

    end; // fim Tomador
  end; // fim InfDeclaracaoPrestacaoServico

  Result := True;
end;

function TNFSeR.LerRPS_Agili: Boolean;
var
  item, i: Integer;
  ok: Boolean;
  codCNAE: String;
  codLCServ: String;

  function _StrToSimNao(out ok: boolean; const s: String): TnfseSimNao;
  begin
    result := StrToEnumerado(ok, s,
                             ['1','0'],
                             [snSim, snNao]);
  end;

  function _StrToResponsavelRetencao(out ok: boolean; const s: String): TnfseResponsavelRetencao;
  begin
    result := StrToEnumerado(ok, s,
                             ['-1', '-2', '-3'],
                             [ptTomador, rtPrestador, rtPrestador]);
  end;

  function _StrToRegimeEspecialTributacao(out ok: boolean; const s: String): TnfseRegimeEspecialTributacao;
  begin
    // -7 Microempresario individual MEI optante pelo SIMEI
    result := StrToEnumerado(ok, s,
                            ['-1','-2','-4','-5','-6'],
                            [retNenhum, retEstimativa, retCooperativa,
                             retMicroempresarioIndividual, retMicroempresarioEmpresaPP
                            ]);
  end;

  function _StrToExigibilidadeISS(out ok: boolean; const s: String): TnfseExigibilidadeISS;
  begin
    // -8 Fixo
    result := StrToEnumerado(ok, s,
                            ['-1','-2','-3','-4','-5','-6','-7'],
                             [exiExigivel, exiNaoIncidencia, exiIsencao, exiExportacao, exiImunidade,
                              exiSuspensaDecisaoJudicial, exiSuspensaProcessoAdministrativo]);
  end;

  function _StrToTipoRPS(out ok: boolean; const s: String): TnfseTipoRPS;
  begin
    result := StrToEnumerado(ok, s,
                             ['-2','-4','-5'],
                             [trRPS, trNFConjugada, trCupom]);
  end;

begin
  codLCServ := '';
  CodCNAE := '';

  if (Leitor.rExtrai(1, 'ListaServico') <> '') then
  begin
    i := 1;
    while (Leitor.rExtrai(2, 'DadosServico', '', i) <> '') do
    begin
      with NFSe.Servico.ItemServico.New do
      begin
        Descricao := Leitor.rCampo(tcStr, 'Discriminacao');
        Discriminacao := Descricao;
        ValorServicos := Leitor.rCampo(tcDe2, 'ValorServico');
        DescontoIncondicionado := Leitor.rCampo(tcDe2, 'ValorDesconto');
        Quantidade := Leitor.rCampo(tcDe6, 'Quantidade');

        if VersaoNFSe = ve100 then
          codCNAE := Leitor.rCampo(tcStr, 'CodigoCnae');

        CodLCServ := Leitor.rCampo(tcStr, 'ItemLei116');

        Item := StrToIntDef(OnlyNumber(CodLCServ), 0);
        if Item < 100 then
          Item := Item * 100 + 1;

        CodLCServ := FormatFloat('0000', Item);
        CodLCServ := Copy(CodLCServ, 1, 2) + '.' + Copy(CodLCServ, 3, 2);

//        if codLCServ = '' then
//          codLCServ := CodLCServ;
      end;

      Inc(i);
    end;
  end; // fim lista servi�o

  if VersaoNFSe = ve100 then
  begin
    if Leitor.rExtrai(1, 'ResponsavelISSQN') <> '' then
      NFSe.Servico.ResponsavelRetencao := _StrToResponsavelRetencao(ok, Leitor.rCampo(tcStr, 'Codigo'));

    if Leitor.rExtrai(1, 'RegimeEspecialTributacao') <> '' then
      NFSe.RegimeEspecialTributacao := _StrToRegimeEspecialTributacao(ok, Leitor.rCampo(tcStr, 'Codigo'));

    if Leitor.rExtrai(1, 'ExigibilidadeISSQN') <> '' then
      NFSe.Servico.ExigibilidadeISS := _StrToExigibilidadeISS(ok, Leitor.rCampo(tcStr, 'Codigo'));

    if Leitor.rExtrai(1, 'MunicipioIncidencia') <> '' then
    begin
      NFSe.Servico.CodigoMunicipio     := Leitor.rCampo(tcInt, 'CodigoMunicipioIBGE');
      NFSe.Servico.CodigoPais          := 1058;
      NFSe.Servico.MunicipioIncidencia := Leitor.rCampo(tcInt, 'CodigoMunicipioIBGE');
    end;
  end;

  if (Leitor.rExtrai(2, 'InfDeclaracaoPrestacaoServico') <> '') or
     (Leitor.rExtrai(1, 'InfDeclaracaoPrestacaoServico') <> '') then
  begin
    //NFSe.Competencia := Leitor.rCampo(tcStr, 'Competencia');
    NFSe.OptanteSimplesNacional := _StrToSimNao(ok, Leitor.rCampo(tcStr, 'OptanteSimplesNacional'));

    if VersaoNFSe = ve100 then
    begin
      NFSe.NfseSubstituida := Leitor.rCampo(tcStr, 'NfseSubstituida');
      // OptanteMEISimei
      NFSe.IncentivadorCultural := _StrToSimNao(ok, Leitor.rCampo(tcStr, 'IncentivoFiscal'));
    end
    else
    begin
      NFSe.RegimeEspecialTributacao    := StrToRegimeEspecialTributacao(ok, Leitor.rCampo(tcStr, 'RegimeEspecialTributacao'));
      NFSe.Servico.ResponsavelRetencao := StrToResponsavelRetencao(ok, Leitor.rCampo(tcStr, 'ResponsavelRetencao'));
      NFSe.Servico.ExigibilidadeISS    := StrToExigibilidadeISS(ok, Leitor.rCampo(tcStr, 'ExigibilidadeIss'));
      NFSe.Servico.CodigoMunicipio     := Leitor.rCampo(tcInt, 'MunicipioIncidencia');
      NFSe.Servico.MunicipioIncidencia := Leitor.rCampo(tcInt, 'MunicipioIncidencia');
    end;

    NFSe.Producao := _StrToSimNao(ok, Leitor.rCampo(tcStr, 'Producao'));
    NFSe.Servico.CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'CodigoAtividadeEconomica');
    NFSe.Servico.CodigoCnae := codCNAE;
    NFSe.Servico.ItemListaServico := codLCServ;

    if TabServicosExt then
      NFSe.Servico.xItemListaServico := ObterDescricaoServico(OnlyNumber(NFSe.Servico.ItemListaServico))
    else
      NFSe.Servico.xItemListaServico := CodigoToDesc(OnlyNumber(NFSe.Servico.ItemListaServico));

    if VersaoNFSe = ve100 then
    begin
      NFSe.Servico.NumeroProcesso := Leitor.rCampo(tcStr, 'BeneficioProcesso');
      NFSe.Servico.Valores.ValorServicos := Leitor.rCampo(tcDe2, 'ValorServicos');
      NFSe.Servico.Valores.DescontoIncondicionado := Leitor.rCampo(tcDe2, 'ValorDescontos');
      NFSe.Servico.Valores.ValorPis := Leitor.rCampo(tcDe2, 'ValorPis');
      NFSe.Servico.Valores.ValorCofins := Leitor.rCampo(tcDe2, 'ValorCofins');
      NFSe.Servico.Valores.ValorInss := Leitor.rCampo(tcDe2, 'ValorInss');
      NFSe.Servico.Valores.ValorIr := Leitor.rCampo(tcDe2, 'ValorIrrf');
      NFSe.Servico.Valores.ValorCsll := Leitor.rCampo(tcDe2, 'ValorCsll');
      NFSe.Servico.Valores.valorOutrasRetencoes := Leitor.rCampo(tcDe2, 'ValorOutrasRetencoes');
      NFSe.Servico.Valores.BaseCalculo := Leitor.rCampo(tcDe2, 'ValorBaseCalculoISSQN');
      NFSe.Servico.Valores.Aliquota := Leitor.rCampo(tcDe3, 'AliquotaISSQN');
      NFSe.Servico.Valores.ValorIss := Leitor.rCampo(tcDe3, 'ValorISSQNCalculado');
      case _StrToSimNao(ok, Leitor.rCampo(tcStr, 'ISSQNRetido')) of
        snSim: NFSe.Servico.Valores.ValorIssRetido := NFSe.Servico.Valores.ValorIss;
        snNao: NFSe.Servico.Valores.ValorIssRetido := 0;
      end;
      NFSe.Servico.Valores.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'ValorLiquido');
      NFSe.OutrasInformacoes := Leitor.rCampo(tcStr, 'Observacao');
    end
    else
    begin
      NFSe.Servico.NumeroProcesso := Leitor.rCampo(tcStr, 'NumeroProcesso');
      NFSe.Servico.Valores.ValorServicos := Leitor.rCampo(tcDe2, 'ValorServicos');
      NFSe.Servico.Valores.DescontoIncondicionado := Leitor.rCampo(tcDe2, 'ValorDescontos');
      NFSe.Servico.Valores.ValorPis := Leitor.rCampo(tcDe2, 'ValorPis');
      NFSe.Servico.Valores.ValorCofins := Leitor.rCampo(tcDe2, 'ValorCofins');
      NFSe.Servico.Valores.ValorInss := Leitor.rCampo(tcDe2, 'ValorInss');
      NFSe.Servico.Valores.ValorIr := Leitor.rCampo(tcDe2, 'ValorIr');
      NFSe.Servico.Valores.ValorCsll := Leitor.rCampo(tcDe2, 'ValorCsll');
      NFSe.Servico.Valores.valorOutrasRetencoes := Leitor.rCampo(tcDe2, 'ValorOutrasRetencoes');
      NFSe.Servico.Valores.BaseCalculo := Leitor.rCampo(tcDe2, 'ValorBaseCalculoIss');
      NFSe.Servico.Valores.Aliquota := Leitor.rCampo(tcDe3, 'Aliquota');
      NFSe.Servico.Valores.ValorIss := Leitor.rCampo(tcDe3, 'ValorIss');
      case _StrToSimNao(ok, Leitor.rCampo(tcStr, 'IssRetido')) of
        snSim: NFSe.Servico.Valores.ValorIssRetido := NFSe.Servico.Valores.ValorIss;
        snNao: NFSe.Servico.Valores.ValorIssRetido := 0;
      end;
      NFSe.Servico.Valores.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'ValorLiquido');
    end;

    if (Leitor.rExtrai(3, 'Rps') <> '') or (Leitor.rExtrai(2, 'Rps') <> '') then
    begin
      NFSe.DataEmissaoRps := Leitor.rCampo(tcDat, 'DataEmissao');
      NFSe.DataEmissao := Leitor.rCampo(tcDat, 'DataEmissao');

      if (Leitor.rExtrai(3, 'IdentificacaoRps') <> '') then
      begin
        NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'Numero');
        NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'Serie');

        if VersaoNFSe = ve100 then
          NFSe.IdentificacaoRps.Tipo := _StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'))
        else
          NFSe.IdentificacaoRps.Tipo := StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));

        NFSe.InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero) + NFSe.IdentificacaoRps.Serie;
      end;
    end;

    if (Leitor.rExtrai(3, 'IdentificacaoPrestador') <> '') or (Leitor.rExtrai(2, 'IdentificacaoPrestador') <> '') then
    begin
      NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
      NFSe.Prestador.InscricaoMunicipal := NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal;
      NFSe.PrestadorServico.IdentificacaoPrestador.ChaveAcesso := Leitor.rCampo(tcStr, 'ChaveDigital');
      NFSe.Prestador.ChaveAcesso := NFSe.PrestadorServico.IdentificacaoPrestador.ChaveAcesso;
      NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cnpj');
      NFSe.Prestador.Cnpj := NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj;
    end; // fim Prestador

   if (Leitor.rExtrai(3, 'DadosTomador') <> '') or (Leitor.rExtrai(2, 'DadosTomador') <> '') then
   begin
     NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'RazaoSocial');
     NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual  := Leitor.rCampo(tcStr, 'InscricaoEstadual');

     NFSe.Tomador.Endereco.TipoLogradouro := Leitor.rCampo(tcStr, 'TipoLogradouro');
     NFSe.Tomador.Endereco.Endereco := Leitor.rCampo(tcStr, 'Logradouro');
     NFSe.Tomador.Endereco.Numero := Leitor.rCampo(tcStr, 'Numero');
     NFSe.Tomador.Endereco.Complemento := Leitor.rCampo(tcStr, 'Complemento');
     NFSe.Tomador.Endereco.Bairro := Leitor.rCampo(tcStr, 'Bairro');
     NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipioIBGE');
     NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'Uf');
     NFSe.Tomador.Endereco.CEP := Leitor.rCampo(tcStr, 'Cep');

     if length(NFSe.Tomador.Endereco.CodigoMunicipio) < 7
      then NFSe.Tomador.Endereco.CodigoMunicipio := Copy(NFSe.Tomador.Endereco.CodigoMunicipio, 1, 2) +
        FormatFloat('00000', StrToIntDef(Copy(NFSe.Tomador.Endereco.CodigoMunicipio, 3, 5), 0));

     if NFSe.Tomador.Endereco.UF = ''
      then NFSe.Tomador.Endereco.UF := NFSe.PrestadorServico.Endereco.UF;

     NFSe.Tomador.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0));

     if (Leitor.rExtrai(4, 'IdentificacaoTomador') <> '') or (Leitor.rExtrai(3, 'IdentificacaoTomador') <> '') then
     begin
       NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');

       if (Leitor.rExtrai(5, 'CpfCnpj') <> '') or (Leitor.rExtrai(4, 'CpfCnpj') <> '') then
       begin
         if Leitor.rCampo(tcStr, 'Cpf')<>''
          then NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'Cpf')
          else NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'Cnpj');
       end;
     end;

     if (Leitor.rExtrai(4, 'Contato') <> '') or (Leitor.rExtrai(3, 'Contato') <> '') then
     begin
       NFSe.Tomador.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
       NFSe.Tomador.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
     end;

    end; // fim Tomador
  end; // fim InfDeclaracaoPrestacaoServico

  Result := True;
end;

function TNFSeR.LerRPS_AssessorPublico: boolean;
var
  serv: integer;
  DataHorBR: String;
begin
  Leitor.rExtrai(1,'NOTA');
  NFSe.Link := Leitor.rCampo(tcStr, 'LINK');
  NFSe.NumeroLote := Leitor.rCampo(tcStr, 'LOTE');
  NFSe.Numero :=  Leitor.rCampo(tcStr, 'COD');
  NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'RPS');
  NFSe.IdentificacaoRps.Serie := Leitor.rCampo(tcStr, 'SEQUENCIA');
  NFSe.Competencia := Leitor.rCampo(tcStr, 'MESCOMP')+'/'+Leitor.rCampo(tcStr, 'ANOCOMP');
  NFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'RPS');

  DataHorBR := Leitor.rCampo(tcStr, 'DATA')+Leitor.rCampo(tcStr, 'HORA');
  NFSe.DataEmissao := StringToDateTime(DataHorBr, 'DD/MM/YYYY hh:nn:ss');

  NFSe.Servico.Discriminacao := Leitor.rCampo(tcStr, 'OBSSERVICO');

  if Leitor.rCampo(tcStr, 'RETIDO') = 'N' then
    NFSe.Servico.Valores.IssRetido := stNormal;

  NFSe.Servico.ItemListaServico := Leitor.rCampo(tcStr, 'ATIVCOD');
  NFSe.Servico.xItemListaServico := Leitor.rCampo(tcStr, 'ATIVDESC');
  NFSe.Servico.Valores.BaseCalculo := Leitor.rCampo(tcDe2, 'BASECALC');
  NFSe.Servico.Valores.ValorServicos := Leitor.rCampo(tcDe2, 'VALORTOTALSERVICOS');
  NFSe.Servico.Valores.ValorIss := Leitor.rCampo(tcDe2, 'IMPOSTO');
  NFSe.Servico.Valores.ValorDeducoes := Leitor.rCampo(tcDe2, 'DEDUCAO');
  NFSe.Servico.Valores.ValorOutrasRetencoes := Leitor.rCampo(tcDe2, 'RETENCAO');
  NFSe.Servico.Valores.ValorPis := Leitor.rCampo(tcDe2, 'PIS');
  NFSe.Servico.Valores.ValorCofins := Leitor.rCampo(tcDe2, 'COFINS');
  NFSe.Servico.Valores.ValorInss := Leitor.rCampo(tcDe2, 'INSS');
  NFSe.Servico.Valores.ValorIr := Leitor.rCampo(tcDe2, 'IR');
  NFSe.Servico.Valores.ValorCsll := Leitor.rCampo(tcDe2, 'CSLL');
  NFSe.Servico.Valores.OutrasRetencoes := NFSe.Servico.Valores.OutrasRetencoes +
                                          Leitor.rCampo(tcDe2, 'ICMS')+
                                          Leitor.rCampo(tcDe2, 'IOF')+
                                          Leitor.rCampo(tcDe2, 'CIDE')+
                                          Leitor.rCampo(tcDe2, 'OUTROSTRIBUTOS')+
                                          Leitor.rCampo(tcDe2, 'OUTRASRETENCOES')+
                                          Leitor.rCampo(tcDe2, 'IPI');
  NFSe.Servico.Valores.Aliquota := Leitor.rCampo(tcDe4, 'ALIQUOTA');

  NFSe.Servico.CodigoMunicipio := Leitor.rCampo(tcStr, 'TOMMUNICIPIOCOD');
  NFSe.Servico.MunicipioIncidencia := Leitor.rCampo(tcInt, 'TOMMUNICIPIOCOD');

  NFSe.Prestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'PRESTCODMOBILIARIO');
  NFSe.Prestador.Cnpj := Leitor.rCampo(tcStr, 'PRESTCPFCNPJ');

  NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'PRESTCODMOBILIARIO');
  NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'PRESTCPFCNPJ');
  NFSe.PrestadorServico.RazaoSocial := Leitor.rCampo(tcStr, 'PRESTNOMERAZAO');
  NFSe.PrestadorServico.NomeFantasia := Leitor.rCampo(tcStr, 'PRESTNOMERAZAO');
  NFSe.PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'PRESTPREFIXODESC')+' '+
                                             Leitor.rCampo(tcStr, 'PRESTLOGDESC')+', '+
                                             Leitor.rCampo(tcStr, 'PRESTNUMERO');
  NFSe.PrestadorServico.Endereco.Bairro := Leitor.rCampo(tcStr, 'PRESTBAIRRODESC');
  NFSe.PrestadorServico.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'PRESTMUNICIPIOCOD');
  NFSe.PrestadorServico.Endereco.xMunicipio := Leitor.rCampo(tcStr, 'PRESTMUNICIPIODESC');
  NFSe.PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'PRESTMUNICIPIOUF');
  NFSe.PrestadorServico.Endereco.CEP := Leitor.rCampo(tcStr, 'PRESTCEP');

  NFSe.OptanteSimplesNacional := snNao;
  if Leitor.rCampo(tcStr, 'PRESTSUPERSIMP') = 'S' then
    NFSe.OptanteSimplesNacional := snSim;

  NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'TOMCPFCNPJ');
  NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'TOMINSCRICAOMUN');

  NFSe.Tomador.RazaoSocial              := Leitor.rCampo(tcStr, 'TOMNOMERAZAO');
  NFSe.Tomador.Endereco.Endereco        := Leitor.rCampo(tcStr, 'TOMLOGDESC');
  NFSe.Tomador.Endereco.Numero          := Leitor.rCampo(tcStr, 'TOMNUMERO');
  NFSe.Tomador.Endereco.Complemento     := '';
  NFSe.Tomador.Endereco.Bairro          := Leitor.rCampo(tcStr, 'TOMBAIRRODESC');
  NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'TOMMUNICIPIOCOD');
  NFSe.Tomador.Endereco.UF              := Leitor.rCampo(tcStr, 'TOMMUNICIPIOUF');
  NFSe.Tomador.Endereco.CEP             := Leitor.rCampo(tcStr, 'TOMCEP');
  NFSe.Tomador.Contato.Telefone         := '';
  NFSe.Tomador.Contato.Email            := '';

  if (Leitor.rExtrai(1, 'SERVICOS') <> '') then
  begin
    serv := 0;
    while (Leitor.rExtrai(1, 'SERVICO', '', serv + 1) <> '') do
    begin
      NFSe.Servico.ItemServico.New;
      NFSe.Servico.ItemServico[serv].Codigo        := Leitor.rCampo(tcStr, 'CODIGO');
      NFSe.Servico.ItemServico[serv].Descricao     := Leitor.rCampo(tcStr, 'DESCRICAO');
      NFSe.Servico.ItemServico[serv].Quantidade    := Leitor.rCampo(tcDe2, 'QUANTIDADE');
      NFSe.Servico.ItemServico[serv].ValorUnitario := Leitor.rCampo(tcDe2, 'VALOR');
      NFSe.Servico.ItemServico[serv].ValorTotal    := NFSe.Servico.ItemServico[serv].Quantidade*NFSe.Servico.ItemServico[serv].ValorUnitario;
      NFSe.Servico.ItemServico[serv].Tributavel    := snSim;
      Inc(serv);
    end;
  end;

  FNFSe.Servico.Valores.ValorLiquidoNfse := (FNfse.Servico.Valores.ValorServicos -
                                            (FNfse.Servico.Valores.ValorDeducoes +
                                             FNfse.Servico.Valores.DescontoCondicionado+
                                             FNfse.Servico.Valores.DescontoIncondicionado+
                                             FNFSe.Servico.Valores.ValorIssRetido));
  Result := True;
end;

function TNFSeR.LerRPS_ISSDSF: Boolean;
var
  item: Integer;
  ok  : Boolean;
  sOperacao, sTributacao: String;
begin
  VersaoNFSe := ve100; // para este provedor usar padr�o "1".
  if (Leitor.rExtrai(1, 'Cabecalho') <> '') then
  begin
   	NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'CPFCNPJRemetente');
   	NFSe.Prestador.Cnpj                               := Leitor.rCampo(tcStr, 'CPFCNPJRemetente');
   	NFSe.PrestadorServico.RazaoSocial                 := Leitor.rCampo(tcStr, 'RazaoSocialRemetente');
   	NFSe.PrestadorServico.Endereco.CodigoMunicipio    := CodSiafiToCodCidade( Leitor.rCampo(tcStr, 'CodCidade') );
  end;

  if (Leitor.rExtrai(1, 'RPS') <> '') then
  begin
    NFSe.DataEmissaoRPS := Leitor.rCampo(tcDatHor, 'DataEmissaoRPS');
    NFSe.Status         := StrToEnumerado(ok, Leitor.rCampo(tcStr, 'Status'),['N','C'],[srNormal, srCancelado]);

    NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'NumeroRPS');
    NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'SerieRPS');
    NFSe.IdentificacaoRps.Tipo   := trRPS;//StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));
    NFSe.InfID.ID                := OnlyNumber(NFSe.IdentificacaoRps.Numero);// + NFSe.IdentificacaoRps.Serie;
    NFSe.SeriePrestacao          := Leitor.rCampo(tcStr, 'SeriePrestacao');

   	NFSe.Prestador.InscricaoMunicipal     := Leitor.rCampo(tcStr, 'InscricaoMunicipalPrestador');
    NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'DDDPrestador') + Leitor.rCampo(tcStr, 'TelefonePrestador');

   	NFSe.Tomador.RazaoSocial              := Leitor.rCampo(tcStr, 'RazaoSocialTomador');
    NFSe.Tomador.Endereco.TipoLogradouro  := Leitor.rCampo(tcStr, 'TipoLogradouroTomador');
    NFSe.Tomador.Endereco.Endereco        := Leitor.rCampo(tcStr, 'LogradouroTomador');
    NFSe.Tomador.Endereco.Numero          := Leitor.rCampo(tcStr, 'NumeroEnderecoTomador');
    NFSe.Tomador.Endereco.Complemento     := Leitor.rCampo(tcStr, 'ComplementoEnderecoTomador');
    NFSe.Tomador.Endereco.TipoBairro      := Leitor.rCampo(tcStr, 'TipoBairroTomador');
    NFSe.Tomador.Endereco.Bairro          := Leitor.rCampo(tcStr, 'BairroTomador');
    NFSe.Tomador.Endereco.CEP             := Leitor.rCampo(tcStr, 'CEPTomador');
   	NFSe.Tomador.Endereco.CodigoMunicipio := CodSiafiToCodCidade( Leitor.rCampo(tcStr, 'CidadeTomador'));
    NFSe.Tomador.Endereco.xMunicipio      := Leitor.rCampo(tcStr, 'CidadeTomadorDescricao');
   	NFSe.Tomador.Endereco.UF              := Leitor.rCampo(tcStr, 'Uf');
   	NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipalTomador');
   	NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'CPFCNPJTomador');
    NFSe.Tomador.IdentificacaoTomador.DocTomadorEstrangeiro := Leitor.rCampo(tcStr, 'DocTomadorEstrangeiro');
    NFSe.Tomador.Contato.Email := Leitor.rCampo(tcStr, 'EmailTomador');
    NFSe.Tomador.Contato.Telefone          := Leitor.rCampo(tcStr, 'DDDTomador') + Leitor.rCampo(tcStr, 'TelefoneTomador');
    NFSe.Servico.CodigoCnae := Leitor.rCampo(tcStr, 'CodigoAtividade');
    NFSe.Servico.Valores.Aliquota := Leitor.rCampo(tcDe3, 'AliquotaAtividade');

    NFSe.Servico.Valores.IssRetido := StrToEnumerado( ok, Leitor.rCampo(tcStr, 'TipoRecolhimento'),
                                                      ['A','R'], [ stNormal, stRetencao{, stSubstituicao}]);

    NFSe.Servico.CodigoMunicipio := CodSiafiToCodCidade( Leitor.rCampo(tcStr, 'MunicipioPrestacao'));

    sOperacao   := AnsiUpperCase(Leitor.rCampo(tcStr, 'Operacao'));
    sTributacao := AnsiUpperCase(Leitor.rCampo(tcStr, 'Tributacao'));
    NFSe.TipoRecolhimento := AnsiUpperCase(Leitor.rCampo(tcStr, 'TipoRecolhimento')); 

    if (sOperacao = 'A') or (sOperacao = 'B') then
    begin
      if (sOperacao = 'A') and (sTributacao = 'N') then
        NFSe.NaturezaOperacao := no7
      else
        if sTributacao = 'G' then
          NFSe.NaturezaOperacao := no2
        else
          if sTributacao = 'T' then
            NFSe.NaturezaOperacao := no1;
    end
    else
      if (sOperacao = 'C') and (sTributacao = 'C') then
      begin
        NFSe.NaturezaOperacao := no3;
      end
      else
        if (sOperacao = 'C') and (sTributacao = 'F') then
        begin
          NFSe.NaturezaOperacao := no4;
        end;

    NFSe.Servico.Operacao := StrToOperacao(Ok, sOperacao);
    NFSe.Servico.Tributacao := StrToTributacao(Ok, sTributacao);

    NFSe.NaturezaOperacao := StrToEnumerado( ok,sTributacao, ['T','K'], [ NFSe.NaturezaOperacao, no5 ]);

    NFSe.OptanteSimplesNacional := StrToEnumerado( ok,sTributacao, ['T','H'], [ snNao, snSim ]);

    NFSe.DeducaoMateriais := StrToEnumerado( ok,sOperacao, ['A','B'], [ snNao, snSim ]);

    NFse.RegimeEspecialTributacao := StrToEnumerado( ok,sTributacao, ['T','M'], [ retNenhum, retMicroempresarioIndividual ]);

    //NFSe.Servico.Valores.ValorDeducoes          :=
    NFSe.Servico.Valores.ValorPis               := Leitor.rCampo(tcDe2, 'ValorPIS');
    NFSe.Servico.Valores.ValorCofins            := Leitor.rCampo(tcDe2, 'ValorCOFINS');
    NFSe.Servico.Valores.ValorInss              := Leitor.rCampo(tcDe2, 'ValorINSS');
    NFSe.Servico.Valores.ValorIr                := Leitor.rCampo(tcDe2, 'ValorIR');
    NFSe.Servico.Valores.ValorCsll              := Leitor.rCampo(tcDe2, 'ValorCSLL');
    NFSe.Servico.Valores.AliquotaPIS            := Leitor.rCampo(tcDe2, 'AliquotaPIS');
    NFSe.Servico.Valores.AliquotaCOFINS         := Leitor.rCampo(tcDe2, 'AliquotaCOFINS');
    NFSe.Servico.Valores.AliquotaINSS           := Leitor.rCampo(tcDe2, 'AliquotaINSS');
    NFSe.Servico.Valores.AliquotaIR             := Leitor.rCampo(tcDe2, 'AliquotaIR');
    NFSe.Servico.Valores.AliquotaCSLL           := Leitor.rCampo(tcDe2, 'AliquotaCSLL');

    NFSE.OutrasInformacoes := Leitor.rCampo(tcStr, 'DescricaoRPS');
    NFSE.MotivoCancelamento := Leitor.rCampo(tcStr, 'MotCancelamento');
    NFSE.IntermediarioServico.CpfCnpj := Leitor.rCampo(tcStr, 'CpfCnpjIntermediario');

    if (Leitor.rExtrai(1, 'Itens') <> '') then
    begin
      Item := 0;
      while (Leitor.rExtrai(1, 'Item', '', Item + 1) <> '') do
      begin
        FNfse.Servico.ItemServico.New;
        FNfse.Servico.ItemServico[Item].Descricao     := Leitor.rCampo(tcStr, 'DiscriminacaoServico');
        FNfse.Servico.ItemServico[Item].Quantidade    := Leitor.rCampo(tcDe2, 'Quantidade');
        FNfse.Servico.ItemServico[Item].ValorUnitario := Leitor.rCampo(tcDe2, 'ValorUnitario');
        FNfse.Servico.ItemServico[Item].ValorTotal    := Leitor.rCampo(tcDe2, 'ValorTotal');
        FNfse.Servico.ItemServico[Item].Tributavel    := StrToEnumerado( ok,Leitor.rCampo(tcStr, 'Tributavel'), ['N','S'], [ snNao, snSim ]);
        FNfse.Servico.Valores.ValorServicos           := (FNfse.Servico.Valores.ValorServicos + FNfse.Servico.ItemServico[Item].ValorTotal);
        inc(Item);
      end;
    end;

//      FNfse.Servico.Valores.ValorIss                          := (FNfse.Servico.Valores.ValorServicos * NFSe.Servico.Valores.Aliquota)/100;
    FNFSe.Servico.Valores.ValorLiquidoNfse := (FNfse.Servico.Valores.ValorServicos -
                                              (FNfse.Servico.Valores.ValorDeducoes +
                                               FNfse.Servico.Valores.DescontoCondicionado+
                                               FNfse.Servico.Valores.DescontoIncondicionado+
                                               FNFSe.Servico.Valores.ValorIssRetido));
    FNfse.Servico.Valores.BaseCalculo      := NFSe.Servico.Valores.ValorLiquidoNfse;
  end; // fim Rps

  Result := True;
end;

function TNFSeR.LerRPS_SP: Boolean;
var
//  item: Integer;
  ok  : Boolean;
//  sOperacao, sTributacao: String;
begin
  if (Leitor.rExtrai(1, 'RPS') <> '') then
  begin
    NFSe.DataEmissaoRPS    := Leitor.rCampo(tcDat, 'DataEmissao');
    NFSe.Status            := StrToEnumerado(ok, Leitor.rCampo(tcStr, 'StatusRPS'),['N','C'],[srNormal, srCancelado]);
    NFSe.TipoTributacaoRPS := StrToEnumerado(ok, Leitor.rCampo(tcStr, 'TributacaoRPS'),['T','F', 'A', 'B', 'M', 'N', 'X', 'V', 'P'],[ttTribnoMun, ttTribforaMun, ttTribnoMunIsento, ttTribforaMunIsento, ttTribnoMunImune, ttTribforaMunImune, ttTribnoMunSuspensa, ttTribforaMunSuspensa, ttExpServicos]);

    NFSe.Servico.Discriminacao             := Leitor.rCampo(tcStr, 'Discriminacao');
    NFSe.Servico.CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'CodigoServico');

    NFSe.Servico.Valores.ValorServicos   := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.Servico.Valores.ValorDeducoes   := Leitor.rCampo(tcDe2, 'ValorDeducoes');
    NFSe.Servico.Valores.Aliquota        := Leitor.rCampo(tcDe3, 'AliquotaServicos');
    if (FProvedor in [proSP]) then
      NFSe.Servico.Valores.Aliquota      := (NFSe.Servico.Valores.Aliquota * 100);
    NFSe.Servico.Valores.IssRetido       := StrToEnumerado( ok, Leitor.rCampo(tcStr, 'ISSRetido'), ['false','true'], [ stNormal, stRetencao]);
    NFSe.Servico.Valores.ValorPis        := Leitor.rCampo(tcDe2, 'ValorPIS');
    NFSe.Servico.Valores.ValorCofins     := Leitor.rCampo(tcDe2, 'ValorCOFINS');
    NFSe.Servico.Valores.ValorInss       := Leitor.rCampo(tcDe2, 'ValorINSS');
    NFSe.Servico.Valores.ValorIr         := Leitor.rCampo(tcDe2, 'ValorIR');
    NFSe.Servico.Valores.ValorCsll       := Leitor.rCampo(tcDe2, 'ValorCSLL');
    NFSe.Servico.Valores.AliquotaPIS     := Leitor.rCampo(tcDe2, 'AliquotaPIS');
    NFSe.Servico.Valores.AliquotaCOFINS := Leitor.rCampo(tcDe2, 'AliquotaCOFINS');
    NFSe.Servico.Valores.AliquotaINSS   := Leitor.rCampo(tcDe2, 'AliquotaINSS');
    NFSe.Servico.Valores.AliquotaIR     := Leitor.rCampo(tcDe2, 'AliquotaIR');
    NFSe.Servico.Valores.AliquotaCSLL   := Leitor.rCampo(tcDe2, 'AliquotaCSLL');


   	NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipalTomador');
    NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual  := Leitor.rCampo(tcStr, 'InscricaoEstadualTomador');

   	NFSe.Tomador.RazaoSocial   := Leitor.rCampo(tcStr, 'RazaoSocialTomador');
    NFSe.Tomador.Contato.Email := Leitor.rCampo(tcStr, 'EmailTomador');

    NFSe.OutrasInformacoes := Leitor.rCampo(tcStr, 'Discriminacao');
  end;

  SetxItemListaServico;

  if (Leitor.rExtrai(2, 'EnderecoTomador') <> '') then
  begin
    NFSe.Tomador.Endereco.Endereco        := Leitor.rCampo(tcStr, 'Logradouro');
    NFSe.Tomador.Endereco.Numero          := Leitor.rCampo(tcStr, 'NumeroEndereco');
    NFSe.Tomador.Endereco.Complemento     := Leitor.rCampo(tcStr, 'Complemento');
    NFSe.Tomador.Endereco.Bairro          := Leitor.rCampo(tcStr, 'Bairro');
    NFSe.Tomador.Endereco.UF              := Leitor.rCampo(tcStr, 'UF');
    NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'Cidade');
    NFSe.Tomador.Endereco.CEP             := Leitor.rCampo(tcStr, 'CEP');
  end;

  if (Leitor.rExtrai(1, 'ChaveRPS') <> '') then
  begin
    NFSe.Prestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoPrestador');
    NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'SerieRPS');
    NFSe.IdentificacaoRps.Tipo   := trRPS;//StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));
    NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'NumeroRPS');
    NFSe.InfID.ID                := OnlyNumber(NFSe.IdentificacaoRps.Numero);// + NFSe.IdentificacaoRps.Serie;
  end;


  if (Leitor.rExtrai(1, 'CPFCNPJTomador') <> '') then
    NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampoCNPJCPF;

  Result := True;
end;

function TNFSeR.LerRPS_Equiplano: Boolean;
var
  ok: Boolean;
  Item: Integer;
begin
  NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'nrRps');
  NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'nrEmissorRps');

  NFSe.DataEmissao      := Leitor.rCampo(tcDatHor, 'dtEmissaoNfs');
  NFSe.DataEmissaoRps   := Leitor.rCampo(tcDat, 'dtEmissaoRps');
  NFSe.NaturezaOperacao := StrToNaturezaOperacao(ok, Leitor.rCampo(tcStr, 'NaturezaOperacao'));

  NFSe.Servico.Valores.IssRetido        := StrToSituacaoTributaria(ok, Leitor.rCampo(tcStr, 'isIssRetido'));
  NFSe.Servico.Valores.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'vlLiquidoRps');

  if (Leitor.rExtrai(2, 'prestadorServico') <> '') then
  begin
    NFSe.PrestadorServico.RazaoSocial := Leitor.rCampo(tcStr, 'nmPrestador');
    NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'nrDocumento');
    NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'nrInscricaoMunicipal');
    NFSe.PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'dsEndereco');
    NFSe.PrestadorServico.Endereco.Numero := Leitor.rCampo(tcStr, 'nrEndereco');
    NFSe.PrestadorServico.Endereco.xPais := Leitor.rCampo(tcStr, 'nmPais');
    NFSe.PrestadorServico.Endereco.xMunicipio := Leitor.rCampo(tcStr, 'nmCidade');
    NFSe.PrestadorServico.Endereco.Bairro := Leitor.rCampo(tcStr, 'nmBairro');
    NFSe.PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'nmUf');
    NFSe.PrestadorServico.Endereco.CEP := Leitor.rCampo(tcStr, 'nrCep');
  end;

  if (Leitor.rExtrai(2, 'tomador') <> '') then
  begin
    NFSe.Tomador.IdentificacaoTomador.CpfCnpj              := Leitor.rCampo(tcStr, 'nrDocumento');
    NFSe.Tomador.IdentificacaoTomador.DocTomadorEstrangeiro:= Leitor.rCampo(tcStr, 'dsDocumentoEstrangeiro');
    NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual    := Leitor.rCampo(tcStr, 'nrInscricaoEstadual');

    NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'nmTomador');

    NFSe.Tomador.Endereco.Endereco        := Leitor.rCampo(tcStr, 'dsEndereco');
    NFSe.Tomador.Endereco.Numero          := Leitor.rCampo(tcStr, 'nrEndereco');
    NFSe.Tomador.Endereco.Complemento     := Leitor.rCampo(tcStr, 'dsComplemento');
    NFSe.Tomador.Endereco.Bairro          := Leitor.rCampo(tcStr, 'nmBairro');
    NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'nrCidadeIbge');
    NFSe.Tomador.Endereco.UF              := Leitor.rCampo(tcStr, 'nmUf');
    NFSe.Tomador.Endereco.xPais           := Leitor.rCampo(tcStr, 'nmPais');
    NFSe.Tomador.Endereco.CEP             := Leitor.rCampo(tcStr, 'nrCep');

    NFSe.Tomador.Contato.Telefone := Leitor.rCampo(tcStr, 'nrTelefone');
    NFSe.Tomador.Contato.Email    := Leitor.rCampo(tcStr, 'dsEmail');
  end;

  if (Leitor.rExtrai(2, 'listaServicos') <> '') then
  begin
    NFSe.Servico.ItemListaServico := Poem_Zeros( VarToStr( Leitor.rCampo(tcStr, 'nrServicoItem') ), 2) +
                                     Poem_Zeros( VarToStr( Leitor.rCampo(tcStr, 'nrServicoSubItem') ), 2);

    Item := StrToIntDef(OnlyNumber(Nfse.Servico.ItemListaServico), 0);
    if Item < 100 then
      Item:=Item * 100 + 1;

    NFSe.Servico.ItemListaServico := FormatFloat('0000', Item);
    NFSe.Servico.ItemListaServico := Copy(NFSe.Servico.ItemListaServico, 1, 2) + '.' +
                                     Copy(NFSe.Servico.ItemListaServico, 3, 2);

    if TabServicosExt then
      NFSe.Servico.xItemListaServico := ObterDescricaoServico(OnlyNumber(NFSe.Servico.ItemListaServico))
    else
     NFSe.Servico.xItemListaServico := CodigoToDesc(OnlyNumber(NFSe.Servico.ItemListaServico));

    NFSe.Servico.Valores.ValorServicos        := Leitor.rCampo(tcDe2, 'vlServico');
    NFSe.Servico.Valores.Aliquota             := Leitor.rCampo(tcDe2, 'vlAliquota');
    NFSe.Servico.Valores.ValorDeducoes        := Leitor.rCampo(tcDe2, 'vlDeducao');
    NFSe.Servico.Valores.JustificativaDeducao := Leitor.rCampo(tcStr, 'dsJustificativaDeducao');
    NFSe.Servico.Valores.BaseCalculo          := Leitor.rCampo(tcDe2, 'vlBaseCalculo');
    NFSe.Servico.Valores.ValorIss             := Leitor.rCampo(tcDe2, 'vlIssServico');
    NFSe.Servico.Discriminacao                := Leitor.rCampo(tcStr, 'dsDiscriminacaoServico');
  end;

  if (Leitor.rExtrai(2, 'retencoes') <> '') then
  begin
    NFSe.Servico.Valores.ValorCofins    := Leitor.rCampo(tcDe2, 'vlCofins');
    NFSe.Servico.Valores.ValorCsll      := Leitor.rCampo(tcDe2, 'vlCsll');
    NFSe.Servico.Valores.ValorInss      := Leitor.rCampo(tcDe2, 'vlInss');
    NFSe.Servico.Valores.ValorIr        := Leitor.rCampo(tcDe2, 'vlIrrf');
    NFSe.Servico.Valores.ValorPis       := Leitor.rCampo(tcDe2, 'vlPis');
    NFSe.Servico.Valores.ValorIssRetido := Leitor.rCampo(tcDe2, 'vlIss');
    NFSe.Servico.Valores.AliquotaCofins := Leitor.rCampo(tcDe2, 'vlAliquotaCofins');
    NFSe.Servico.Valores.AliquotaCsll   := Leitor.rCampo(tcDe2, 'vlAliquotaCsll');
    NFSe.Servico.Valores.AliquotaInss   := Leitor.rCampo(tcDe2, 'vlAliquotaInss');
    NFSe.Servico.Valores.AliquotaIr     := Leitor.rCampo(tcDe2, 'vlAliquotaIrrf');
    NFSe.Servico.Valores.AliquotaPis    := Leitor.rCampo(tcDe2, 'vlAliquotaPis');
  end;

  Result := True;
end;

function TNFSeR.LerRps_Governa: Boolean;
begin
  Leitor.rExtrai(1, 'LoteRps');
  NFSe.dhRecebimento                := StrToDateTime(formatdatetime ('dd/mm/yyyy',now));
  NFSe.Prestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'CodCadBic');
  NFSe.Prestador.ChaveAcesso        := Leitor.rCampo(tcStr, 'ChvAcs');
  NFSe.CodigoVerificacao            := Leitor.rCampo(tcStr, 'CodVer');
  NFSe.IdentificacaoRps.Numero      := Leitor.rCampo(tcStr, 'NumRps');
  Result := True;
end;

////////////////////////////////////////////////////////////////////////////////
//  Fun��es especificas para ler o XML de uma NFS-e                           //
////////////////////////////////////////////////////////////////////////////////

function TNFSeR.LerNFSe: Boolean;
var
  ok: Boolean;
  CM: String;
  DataHorBR: String;
//  DataEmiBR: TDateTime;
begin
  if FProvedor = proNenhum then
  begin
    if (Leitor.rExtrai(1, 'OrgaoGerador') <> '') then
    begin
      CM := Leitor.rCampo(tcStr, 'CodigoMunicipio');
      FProvedor := CodCidadeToProvedor(CM);
    end;

    if FProvedor = proNenhum then
    begin
      if (Leitor.rExtrai(1, 'PrestadorServico') <> '') then
      begin
        CM := OnlyNumber(Leitor.rCampo(tcStr, 'CodigoMunicipio'));
        if CM = '' then
          CM := Leitor.rCampo(tcStr, 'Cidade');
        FProvedor := CodCidadeToProvedor(CM);
      end;
    end;

    if FProvedor = proNenhum then
    begin
      // tags do xml baixado do provedor
      if (Pos('<numero_nfse>', Leitor.Arquivo) > 0) and
         (Pos('<serie_nfse>', Leitor.Arquivo) > 0) then 
        FProvedor := proIPM;
    end;

    if FProvedor = proNenhum then
    begin
      if (Pos('<nfs', Leitor.Arquivo) > 0) then
        FProvedor := proEquiplano;
    end;

    if FProvedor = proNenhum then
    begin
      if (Leitor.rExtrai(1, 'Servico') <> '') then
      begin
        CM := Leitor.rCampo(tcStr, 'CodigoMunicipio');
        FProvedor := CodCidadeToProvedor(CM);
      end;
    end;

    if FProvedor = proNenhum then
    begin
      if (Leitor.rExtrai(1, 'emit') <> '') then
      begin
        CM := Leitor.rCampo(tcStr, 'cMun');
        FProvedor := CodCidadeToProvedor(CM);
      end;
    end;

    if FProvedor = proNenhum then
      FProvedor := FProvedorConf;
  end;

  VersaoNFSe := ProvedorToVersaoNFSe(FProvedor);
  LayoutXML := ProvedorToLayoutXML(FProvedor);

  if (Leitor.rExtrai(1, 'Nfse') <> '') or (Pos('Nfse versao="2.01"', Leitor.Arquivo) > 0) then
  begin
    NFSe.InfID.ID := Leitor.rAtributo('Id=', 'InfNfse');
    if NFSe.InfID.ID = '' then
      NFSe.InfID.ID := Leitor.rAtributo('id=', 'InfNfse');

    // Quando baixamos diretamente do site do provedor GINFES dentro do grupo <Nfse> n�o
    // contem o grupo <InfNfse>
    if (Leitor.rExtrai(2, 'InfNfse') = '') and (Leitor.rExtrai(1, 'InfNfse') = '') then
      Leitor.Grupo := Leitor.Arquivo;

    FNivel := 0;

    if (Leitor.rExtrai(2, 'InfNfse') <> '') then
      FNivel := 2;
    if (Leitor.rExtrai(1, 'InfNfse') <> '')  or (Leitor.rExtrai(1, 'Nfse') <> '') then
      FNivel := 1;

    if FNivel > 0 then
    begin
      case FProvedor of
        proTecnos, 
        proSigCorp: NFSe.Link := Leitor.rCampo(tcStr, 'LinkNota');

        proPublica: NFSe.Link := Leitor.rCampo(tcStr, 'LinkVisualizacaoNfse');
      end;

      NFSe.Numero            := Leitor.rCampo(tcStr, 'Numero');
      NFSe.SeriePrestacao    := Leitor.rCampo(tcStr, 'Serie');
      NFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'CodigoVerificacao');

      {Considerar a data de recebimento da NFS-e como dhrecebimento - para esse provedor nao tem a tag
        Diferente do que foi colocado para outros provedores, de atribuir a data now, ficaria errado se
        passase a transmissao de um dia para outro. E se for pensar como dhrecebimento pelo webservice e
        n�o o recebimento no programa que usar esse componente
      }
      if FProvedor = proVersaTecnologia then
        NFSe.dhRecebimento := Leitor.rCampo(tcDatHor, 'DataEmissao');

      case FProvedor of
        proFreire,
        proSpeedGov,
        proVitoria,
        proDBSeller,
        proFriburgo,
        proTcheInfov2,
        proElotech: NFSe.DataEmissao := Leitor.rCampo(tcDat, 'DataEmissao');

        proNFSeBrasil,
        proSilTecnologia:
          begin
            DataHorBR := Leitor.rCampo(tcStr, 'DataEmissao');

            NFSe.DataEmissao := StringToDateTime(DataHorBr, 'DD/MM/YYYY hh:nn:ss');
          end;

        proELv2,
        proSigCorp:
        begin
          DataHorBR := Leitor.rCampo(tcStr, 'DataEmissao');
          // ConsultarNFSePorRps volta com formato m/d/yyyy
          If (Pos('M', DataHorBR) > 0) then
            NFSe.DataEmissao := StringToDateTime(DataHorBR, 'MM/DD/YYYY hh:nn:ss')
          else
          If (Pos('T', DataHorBR) > 0) then
            NFSe.DataEmissao := Leitor.rCampo(tcDatHor, 'DataEmissao')
          else
          If (Pos('-', DataHorBR) > 0) then
            NFSe.DataEmissao := Leitor.rCampo(tcDat, 'DataEmissao')
          else
            NFSe.DataEmissao := StrToDate(DataHorBR);
        end;
      else
        NFSe.DataEmissao := Leitor.rCampo(tcDatHor, 'DataEmissao');
      end;

      // Tratar erro de convers�o de tipo no Provedor �baco
      if Leitor.rCampo(tcStr, 'DataEmissaoRps') <> '0000-00-00' then
      begin
        if FProvedor in [proNFSeBrasil] then
        begin
          DataHorBR := Leitor.rCampo(tcStr, 'DataEmissaoRps');
          NFSe.DataEmissaoRps := StringToDateTime(DataHorBr, 'DD/MM/YYYY');
        end
        else if FProvedor = proSigCorp then
        begin
          DataHorBR := Leitor.rCampo(tcStr, 'DataEmissaoRps');
          if Trim(DataHorBR) <> emptyStr then
            NFSe.DataEmissaoRps := StrToDate(DataHorBr);
        end
        else
          NFSe.DataEmissaoRps := Leitor.rCampo(tcDat, 'DataEmissaoRps');
      end;

      NFSe.NaturezaOperacao         := StrToNaturezaOperacao(ok, Leitor.rCampo(tcStr, 'NaturezaOperacao'));
      NFSe.RegimeEspecialTributacao := StrToRegimeEspecialTributacao(ok, Leitor.rCampo(tcStr, 'RegimeEspecialTributacao'));
      NFSe.OptanteSimplesNacional   := StrToSimNao(ok, Leitor.rCampo(tcStr, 'OptanteSimplesNacional'));

      case FProvedor of
        proTecnos:
          NFSe.Competencia := DateTimeToStr(StrToFloatDef(Leitor.rCampo(tcDatHor, 'Competencia'), 0));
        proSimplISSv2:
          NFSe.Competencia := DateToStr(Leitor.rCampo(tcDat, 'Competencia'));
      else
        NFSe.Competencia := Leitor.rCampo(tcStr, 'Competencia');
      end;

      NFSe.OutrasInformacoes := Leitor.rCampo(tcStr, 'OutrasInformacoes');
      NFSe.ValorCredito      := Leitor.rCampo(tcDe2, 'ValorCredito');

      NFSe.InformacoesComplementares := Leitor.rCampo(tcStr, 'InformacoesComplementares');

      if FProvedor = proVitoria then
        NFSe.IncentivadorCultural := StrToSimNao(ok, Leitor.rCampo(tcStr, 'IncentivoFiscal'))
      else
        NFSe.IncentivadorCultural := StrToSimNao(ok, Leitor.rCampo(tcStr, 'IncentivadorCultural'));

      if FProvedor = proISSNet then
        FNFSe.NfseSubstituida := ''
      else
      begin
        NFSe.NfseSubstituida := Leitor.rCampo(tcStr, 'NfseSubstituida');
        if NFSe.NfseSubstituida = '' then
          NFSe.NfseSubstituida := Leitor.rCampo(tcStr, 'NfseSubstituta');
      end;
    end;
  end;

  NFSe.Cancelada := snNao;
  NFSe.Status := srNormal;

  NFSe.Producao := Producao;

  if FProvedor = proGoverna then
    Leitor.rExtrai(1, 'RetornoConsultaRPS');

  case LayoutXML of
    loABRASFv1:    Result := LerNFSe_ABRASF_V1;
    loABRASFv2:    Result := LerNFSe_ABRASF_V2;
    loEL:          Result := LerNFSe_EL;
    loEGoverneISS: Result := False; // Falta implementar
    loEquiplano:   Result := LerNFSe_Equiplano;
    loGoverna:     Result := LerNFSe_Governa;
    loInfisc:      Result := LerNFSe_Infisc;
    loISSDSF:      Result := LerNFSe_ISSDSF;
    loCONAM:       Result := LerNFSe_CONAM;
    loAgili:       Result := LerNFSe_Agili;
    loSP:          Result := LerNFSe_SP;
    loSMARAPD:     Result := LerNFSe_Smarapd;
    loIPM:         Result := LerNFSe_IPM;
    loSigIss:      Result := LerNFSe_SigIss;
    loElotech:     Result := LerNFSe_Elotech;
    loSiat:        Result := LerNFSe_Siat;
  else
    Result := False;
  end;

  Leitor.Grupo := Leitor.Arquivo;
  if FProvedor = proABase then
  begin
    NFSe.Status := StrToStatusRPS(ok, Leitor.rCampo(tcStr, 'Status') );
    if NFSe.Status = srCancelado then
      NFSe.Cancelada := snSim
    else
      NFSe.Cancelada := snNao;
  end;  

  if ((Leitor.rExtrai(1, 'NfseCancelamento') <> '') or (Leitor.rExtrai(1, 'CancelamentoNfse') <> '')) then
  begin
    NFSe.NfseCancelamento.DataHora := Leitor.rCampo(tcDatHor, 'DataHora');

    if NFSe.NfseCancelamento.DataHora = 0 then
    begin
      case Provedor of
        proSigCorp:
          NFSe.NfseCancelamento.DataHora := StringToDateTime(Leitor.rCampo(tcStr, 'DataHoraCancelamento') , 'DD/MM/YYYY hh:nn:ss')
      else
        NFSe.NfseCancelamento.DataHora := Leitor.rCampo(tcDatHor, 'DataHoraCancelamento');
      end;
    end;

    NFSe.NfseCancelamento.Pedido.CodigoCancelamento := Leitor.rCampo(tcStr, 'CodigoCancelamento');

    case FProvedor of
     proBetha, proISSIntel: begin
                 if NFSe.NfseCancelamento.DataHora <> 0 then
                 begin
                   NFSe.Cancelada := snSim;
                   NFSE.Status := srCancelado;
                 end;
               end;
    else begin
           NFSe.Cancelada := snSim;
           NFSE.Status := srCancelado;
         end;
    end;
  end;

  if (Leitor.rExtrai(1, 'NfseSubstituicao') <> '') then
    NFSe.NfseSubstituidora := Leitor.rCampo(tcStr, 'NfseSubstituidora');
end;

function TNFSeR.LerNFSe_ABRASF_V1: Boolean;
var
  I: Integer;
  ok: Boolean;
begin
  if FProvedor <> proNFSeBrasil then
  begin
    if (Leitor.rExtrai(FNivel +1, 'IdentificacaoRps') <> '') then
    begin
      NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'Numero');
      NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'Serie');
      NFSe.IdentificacaoRps.Tipo   := StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));
      if NFSe.InfID.ID = '' then
        NFSe.InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero) + NFSe.IdentificacaoRps.Serie;
    end;
  end
  else
  begin
    NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'NumeroRps');
    if NFSe.InfID.ID = '' then
      NFSe.InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero) + NFSe.IdentificacaoRps.Serie;
  end;

  if FProvedor = proMegaSoft then
  begin
     if Leitor.rExtrai(FNivel +1, 'ValoresNfse') <> '' then
     begin
       NFSe.Servico.Valores.BaseCalculo      := Leitor.rCampo(tcDe2, 'BaseCalculo');
       NFSe.Servico.Valores.Aliquota         := Leitor.rCampo(tcDe3, 'Aliquota');
       NFSe.Servico.Valores.ValorIss         := Leitor.rCampo(tcDe2, 'ValorIss');
       NFSe.Servico.Valores.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'ValorLiquidoNfse');
       if NFSe.Servico.Valores.ValorLiquidoNfse <= 0 then
          NFSe.Servico.Valores.ValorLiquidoNfse := NFSe.Servico.Valores.ValorIss;
     end;

     NFSe.Servico.CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'CodigoTributacao')
  end;

  if (Leitor.rExtrai(FNivel +1, 'Servico') <> '') then
  begin
    SetxItemListaServico;

    NFSe.Servico.CodigoCnae                := Leitor.rCampo(tcStr, 'CodigoCnae');
    NFSe.Servico.CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'CodigoTributacaoMunicipio');
    NFSe.Servico.Discriminacao             := Leitor.rCampo(tcStr, 'Discriminacao');
    NFSe.Servico.Descricao                 := '';
    if FProvedor = proISSNet then
      NFSe.Servico.CodigoMunicipio := Leitor.rCampo(tcStr, 'MunicipioPrestacaoServico')
    else
      NFSe.Servico.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');

//    NFSe.Servico.ResponsavelRetencao       := StrToResponsavelRetencao(ok, Leitor.rCampo(tcStr, 'ResponsavelRetencao'));
//    NFSe.Servico.CodigoPais          := Leitor.rCampo(tcInt, 'CodigoPais');
//    NFSe.Servico.ExigibilidadeISS    := StrToExigibilidadeISS(ok, Leitor.rCampo(tcStr, 'ExigibilidadeISS'));
//    NFSe.Servico.MunicipioIncidencia := Leitor.rCampo(tcInt, 'MunicipioIncidencia');
//    if NFSe.Servico.MunicipioIncidencia =0
//     then NFSe.Servico.MunicipioIncidencia := Leitor.rCampo(tcInt, 'CodigoMunicipio');

    if (Leitor.rExtrai(FNivel +2, 'Valores') <> '') then
    begin
      NFSe.Servico.Valores.ValorServicos          := Leitor.rCampo(tcDe2, 'ValorServicos');
      NFSe.Servico.Valores.ValorDeducoes          := Leitor.rCampo(tcDe2, 'ValorDeducoes');
      NFSe.Servico.Valores.ValorPis               := Leitor.rCampo(tcDe2, 'ValorPis');
      NFSe.Servico.Valores.ValorCofins            := Leitor.rCampo(tcDe2, 'ValorCofins');
      NFSe.Servico.Valores.ValorInss              := Leitor.rCampo(tcDe2, 'ValorInss');
      NFSe.Servico.Valores.ValorIr                := Leitor.rCampo(tcDe2, 'ValorIr');
      NFSe.Servico.Valores.ValorCsll              := Leitor.rCampo(tcDe2, 'ValorCsll');
      NFSe.Servico.Valores.IssRetido              := StrToSituacaoTributaria(ok, Leitor.rCampo(tcStr, 'IssRetido'));
      NFSe.Servico.Valores.ValorIss               := Leitor.rCampo(tcDe2, 'ValorIss');
      NFSe.Servico.Valores.OutrasRetencoes        := Leitor.rCampo(tcDe2, 'OutrasRetencoes');
      NFSe.Servico.Valores.BaseCalculo            := Leitor.rCampo(tcDe2, 'BaseCalculo');
      NFSe.Servico.Valores.Aliquota               := Leitor.rCampo(tcDe3, 'Aliquota');

      if (FProvedor in [proThema, proRJ, proPublica, proBHISS, proEL,
          proWebISS, proAbaco]) then
        NFSe.Servico.Valores.Aliquota := (NFSe.Servico.Valores.Aliquota * 100);

      if NFSe.Servico.Valores.Aliquota = 0 then
        NFSe.Servico.Valores.Aliquota := Leitor.rCampo(tcDe3, 'AliquotaServicos');

      NFSe.Servico.Valores.ValorLiquidoNfse       := Leitor.rCampo(tcDe2, 'ValorLiquidoNfse');
      NFSe.Servico.Valores.ValorIssRetido         := Leitor.rCampo(tcDe2, 'ValorIssRetido');
      NFSe.Servico.Valores.DescontoCondicionado   := Leitor.rCampo(tcDe2, 'DescontoCondicionado');
      NFSe.Servico.Valores.DescontoIncondicionado := Leitor.rCampo(tcDe2, 'DescontoIncondicionado');
    end;

    if NFSe.Servico.Valores.ValorLiquidoNfse = 0 then
      NFSe.Servico.Valores.ValorLiquidoNfse := NFSe.Servico.Valores.ValorServicos -
                                               NFSe.Servico.Valores.DescontoIncondicionado -
                                               NFSe.Servico.Valores.DescontoCondicionado -
                                               // Reten��es Federais
                                               NFSe.Servico.Valores.ValorPis -
                                               NFSe.Servico.Valores.ValorCofins -
                                               NFSe.Servico.Valores.ValorIr -
                                               NFSe.Servico.Valores.ValorInss -
                                               NFSe.Servico.Valores.ValorCsll -

                                               NFSe.Servico.Valores.OutrasRetencoes -
                                               NFSe.Servico.Valores.ValorIssRetido;

    if NFSe.Servico.Valores.BaseCalculo = 0 then
      NFSe.Servico.Valores.BaseCalculo := NFSe.Servico.Valores.ValorServicos -
                                          NFSe.Servico.Valores.ValorDeducoes -
                                          NFSe.Servico.Valores.DescontoIncondicionado;

//    if NFSe.Servico.Valores.ValorIss = 0 then
//      NFSe.Servico.Valores.ValorIss := (NFSe.Servico.Valores.BaseCalculo * NFSe.Servico.Valores.Aliquota)/100;

    // Provedor SimplISS permite varios itens servico
    if FProvedor = proSimplISS then
    begin
      i := 1;
      while (Leitor.rExtrai(FNivel +2, 'ItensServico', 'ItensServico', i) <> '') do
      begin
        with NFSe.Servico.ItemServico.New do
        begin
          Descricao     := Leitor.rCampo(tcStr, 'Descricao');
          Quantidade    := Leitor.rCampo(tcInt, 'Quantidade');
          ValorUnitario := Leitor.rCampo(tcDe2, 'ValorUnitario');
          ValorTotal    := Quantidade * ValorUnitario;
        end;
        inc(i);
      end;
    end;

  end; // fim servi�o

  if Leitor.rExtrai(FNivel +1, 'PrestadorServico') <> '' then
  begin
    NFSe.PrestadorServico.RazaoSocial  := Leitor.rCampo(tcStr, 'RazaoSocial');
    NFSe.PrestadorServico.NomeFantasia := Leitor.rCampo(tcStr, 'NomeFantasia');

    NFSe.PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'EnderecoDescricao');
    if NFSe.PrestadorServico.Endereco.Endereco = '' then
    begin
      NFSe.PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'Endereco');
      if Copy(NFSe.PrestadorServico.Endereco.Endereco, 1, 10) = '<Endereco>'
       then NFSe.PrestadorServico.Endereco.Endereco := Copy(NFSe.PrestadorServico.Endereco.Endereco, 11, 125);
    end;

    NFSe.PrestadorServico.Endereco.Numero      := Leitor.rCampo(tcStr, 'Numero');
    NFSe.PrestadorServico.Endereco.Complemento := Leitor.rCampo(tcStr, 'Complemento');
    NFSe.PrestadorServico.Endereco.Bairro      := Leitor.rCampo(tcStr, 'Bairro');

    NFSe.PrestadorServico.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
    if NFSe.PrestadorServico.Endereco.CodigoMunicipio = '' then
      NFSe.PrestadorServico.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'Cidade');

    NFSe.PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'Uf');
    if NFSe.PrestadorServico.Endereco.UF = '' then
      NFSe.PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'Estado');

//    NFSe.PrestadorServico.Endereco.CodigoPais := Leitor.rCampo(tcInt, 'CodigoPais');
    NFSe.PrestadorServico.Endereco.CEP := Leitor.rCampo(tcStr, 'Cep');

    if length(NFSe.PrestadorServico.Endereco.CodigoMunicipio) < 7 then
      NFSe.PrestadorServico.Endereco.CodigoMunicipio := Copy(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 1, 2) +
          FormatFloat('00000', StrToIntDef(Copy(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 3, 5), 0));

    NFSe.PrestadorServico.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 0));

    if (Leitor.rExtrai(FNivel +2, 'IdentificacaoPrestador') <> '') then
    begin
      NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');

      NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := OnlyNumber(Leitor.rCampo(tcStr, 'Cnpj'));

      if NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj = '' then
        if Leitor.rExtrai(FNivel +3, 'CpfCnpj') <> '' then
        begin
          NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := OnlyNumber(Leitor.rCampo(tcStr, 'Cpf'));
          if NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj = '' then
            NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := OnlyNumber(Leitor.rCampo(tcStr, 'Cnpj'));
        end;
    end;

    if Leitor.rExtrai(FNivel +2, 'Contato') <> '' then
    begin
      NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
      NFSe.PrestadorServico.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
    end;

  end; // fim PrestadorServico

  if (Leitor.rExtrai(FNivel +1, 'Tomador') <> '') or (Leitor.rExtrai(FNivel +1, 'TomadorServico') <> '') then
  begin
    NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'RazaoSocial');
    NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual := Leitor.rCampo(tcStr, 'InscricaoEstadual');

    NFSe.Tomador.Endereco.Endereco := Leitor.rCampo(tcStr, 'EnderecoDescricao');
    if NFSe.Tomador.Endereco.Endereco = '' then
    begin
      NFSe.Tomador.Endereco.Endereco := Leitor.rCampo(tcStr, 'Endereco');
      if Copy(NFSe.Tomador.Endereco.Endereco, 1, 10) = '<Endereco>'
       then NFSe.Tomador.Endereco.Endereco := Copy(NFSe.Tomador.Endereco.Endereco, 11, 125);
    end;

    NFSe.Tomador.Endereco.Numero      := Leitor.rCampo(tcStr, 'Numero');
    NFSe.Tomador.Endereco.Complemento := Leitor.rCampo(tcStr, 'Complemento');
    NFSe.Tomador.Endereco.Bairro      := Leitor.rCampo(tcStr, 'Bairro');

    NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
    if NFSe.Tomador.Endereco.CodigoMunicipio = '' then
      NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'Cidade');

    NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'Uf');
    if NFSe.Tomador.Endereco.UF = '' then
      NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'Estado');

    NFSe.Tomador.Endereco.CEP := Leitor.rCampo(tcStr, 'Cep');

    if length(NFSe.Tomador.Endereco.CodigoMunicipio) < 7 then
      NFSe.Tomador.Endereco.CodigoMunicipio := Copy(NFSe.Tomador.Endereco.CodigoMunicipio, 1, 2) +
           FormatFloat('00000', StrToIntDef(Copy(NFSe.Tomador.Endereco.CodigoMunicipio, 3, 5), 0));

    if NFSe.Tomador.Endereco.UF = '' then
      NFSe.Tomador.Endereco.UF := NFSe.PrestadorServico.Endereco.UF;

     NFSe.Tomador.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0));

    if Leitor.rExtrai(FNivel +2, 'IdentificacaoTomador') <> '' then
    begin
      NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
      if Leitor.rExtrai(FNivel +3, 'CpfCnpj') <> '' then
      begin
        if Leitor.rCampo(tcStr, 'Cpf') <> '' then
          NFSe.Tomador.IdentificacaoTomador.CpfCnpj := OnlyNumber(Leitor.rCampo(tcStr, 'Cpf'))
        else if Leitor.rCampo(tcStr, 'Cnpj') <> '' then
          NFSe.Tomador.IdentificacaoTomador.CpfCnpj := OnlyNumber(Leitor.rCampo(tcStr, 'Cnpj'))
        else
          NFSe.Tomador.IdentificacaoTomador.CpfCnpj := OnlyNumber(Leitor.rCampo(tcStr, 'CpfCnpj'));
      end;
    end;

    if Leitor.rExtrai(FNivel +2, 'Contato') <> '' then
    begin
      NFSe.Tomador.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
      NFSe.Tomador.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
    end;
  end;

  if Leitor.rExtrai(FNivel +1, 'IntermediarioServico') <> '' then
  begin
    NFSe.IntermediarioServico.RazaoSocial        := Leitor.rCampo(tcStr, 'RazaoSocial');
    NFSe.IntermediarioServico.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
    if Leitor.rExtrai(FNivel +2, 'CpfCnpj') <> '' then
    begin
      if Leitor.rCampo(tcStr, 'Cpf')<>'' then
        NFSe.IntermediarioServico.CpfCnpj := OnlyNumber(Leitor.rCampo(tcStr, 'Cpf'))
      else
        NFSe.IntermediarioServico.CpfCnpj := OnlyNumber(Leitor.rCampo(tcStr, 'Cnpj'));
    end;
  end;

  if Leitor.rExtrai(FNivel +1, 'OrgaoGerador') <> '' then
  begin
    NFSe.OrgaoGerador.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
    NFSe.OrgaoGerador.Uf              := Leitor.rCampo(tcStr, 'Uf');
  end; // fim OrgaoGerador

  if Leitor.rExtrai(FNivel +1, 'ConstrucaoCivil') <> '' then
  begin
    NFSe.ConstrucaoCivil.CodigoObra := Leitor.rCampo(tcStr, 'CodigoObra');
    NFSe.ConstrucaoCivil.Art        := Leitor.rCampo(tcStr, 'Art');
  end;

  if FProvedor in [proBetha] then
    if Leitor.rExtrai(FNivel +1, 'CondicaoPagamento') <> '' then
    begin
      NFSe.CondicaoPagamento.Condicao   := StrToCondicao(ok,Leitor.rCampo(tcStr,'Condicao'));
      NFSe.CondicaoPagamento.QtdParcela := Leitor.rCampo(tcInt, 'QtdParcela');

      i := 0;
      NFSe.CondicaoPagamento.Parcelas.Clear;
      while Leitor.rExtrai(FNivel +2, 'Parcelas', '', i + 1) <> '' do
      begin
        with NFSe.CondicaoPagamento.Parcelas.New do
        begin
          Parcela        := Leitor.rCampo(tcInt, 'Parcela');
          DataVencimento := Leitor.rCampo(tcDatHor, 'DataVencimento');
          Valor          := Leitor.rCampo(tcDe2, 'Valor');
        end;
        inc(i);
      end;
    end;

  Result := True;
end;

function TNFSeR.LerNFSe_ABRASF_V2: Boolean;
var
  NivelTemp, i: Integer;
  ok: Boolean;
  DataHorBR: string;
begin
  if Leitor.rExtrai(3, 'ValoresNfse') <> '' then
  begin
    NFSe.ValoresNfse.BaseCalculo      := Leitor.rCampo(tcDe2, 'BaseCalculo');
    NFSe.ValoresNfse.Aliquota         := Leitor.rCampo(tcDe3, 'Aliquota');
    NFSe.ValoresNfse.ValorIss         := Leitor.rCampo(tcDe2, 'ValorIss');
    NFSe.ValoresNfse.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'ValorLiquidoNfse');

    if (FProvedor in [proCoplan, proWebISSv2, proTiplanv2, proCenti, proRLZ, proSystemPro]) then
    begin
      NFSe.Servico.Valores.BaseCalculo      := Leitor.rCampo(tcDe2, 'BaseCalculo');
      NFSe.Servico.Valores.Aliquota         := Leitor.rCampo(tcDe3, 'Aliquota');
      NFSe.Servico.Valores.ValorIss         := Leitor.rCampo(tcDe2, 'ValorIss');
      NFSe.Servico.Valores.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'ValorLiquidoNfse');
      if (FProvedor = proSystemPro) then
         NFSe.Servico.Valores.ValorServicos := Leitor.rCampo(tcDe2, 'ValorLiquidoNfse');
    end;

  end; // fim ValoresNfse

  if (Leitor.rExtrai(3, 'PrestadorServico') <> '') or
     (Leitor.rExtrai(3, 'DadosPrestador') <> '') or
     (Leitor.rExtrai(3, 'Prestador') <> '') then
  begin
    NFSe.PrestadorServico.RazaoSocial  := Leitor.rCampo(tcStr, 'RazaoSocial');
    NFSe.PrestadorServico.NomeFantasia := Leitor.rCampo(tcStr, 'NomeFantasia');

    NFSe.PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'EnderecoDescricao');

    if NFSe.PrestadorServico.Endereco.Endereco = '' then
    begin
      NFSe.PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'Endereco');

      if Copy(NFSe.PrestadorServico.Endereco.Endereco, 1, 10) = '<Endereco>' then
        NFSe.PrestadorServico.Endereco.Endereco := Copy(NFSe.PrestadorServico.Endereco.Endereco, 11, 125);
    end;

    NFSe.PrestadorServico.Endereco.Numero      := Leitor.rCampo(tcStr, 'Numero');
    NFSe.PrestadorServico.Endereco.Complemento := Leitor.rCampo(tcStr, 'Complemento');
    NFSe.PrestadorServico.Endereco.Bairro      := Leitor.rCampo(tcStr, 'Bairro');

    NFSe.PrestadorServico.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
    if NFSe.PrestadorServico.Endereco.CodigoMunicipio = '' then
      NFSe.PrestadorServico.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'Cidade');

    NFSe.PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'Uf');
    if NFSe.PrestadorServico.Endereco.UF = '' then
      NFSe.PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'Estado');

    NFSe.PrestadorServico.Endereco.CodigoPais := Leitor.rCampo(tcInt, 'CodigoPais');
    NFSe.PrestadorServico.Endereco.CEP        := Leitor.rCampo(tcStr, 'Cep');

    if length(NFSe.PrestadorServico.Endereco.CodigoMunicipio) < 7 then
      NFSe.PrestadorServico.Endereco.CodigoMunicipio := Copy(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 1, 2) +
          FormatFloat('00000', StrToIntDef(Copy(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 3, 5), 0));

    NFSe.PrestadorServico.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 0));

    if (Leitor.rExtrai(4, 'IdentificacaoPrestador') <> '') then
    begin
      NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');

      NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cnpj');

      if NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj = '' then
        if Leitor.rExtrai(5, 'CpfCnpj') <> '' then
        begin
          NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cpf');
           if NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj = '' then
             NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cnpj');
        end;
    end;

    if Leitor.rExtrai(4, 'Contato') <> '' then
    begin
      NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
      NFSe.PrestadorServico.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
    end;

  end; // fim PrestadorServico

  if Leitor.rExtrai(3, 'EnderecoPrestadorServico') <> '' then
  begin
    NFSe.PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'EnderecoDescricao');
    if NFSe.PrestadorServico.Endereco.Endereco = '' then
    begin
      NFSe.PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'Endereco');

      if Copy(NFSe.PrestadorServico.Endereco.Endereco, 1, 10) = '<Endereco>' then
        NFSe.PrestadorServico.Endereco.Endereco := Copy(NFSe.PrestadorServico.Endereco.Endereco, 11, 125);
    end;

    NFSe.PrestadorServico.Endereco.Numero      := Leitor.rCampo(tcStr, 'Numero');
    NFSe.PrestadorServico.Endereco.Complemento := Leitor.rCampo(tcStr, 'Complemento');
    NFSe.PrestadorServico.Endereco.Bairro      := Leitor.rCampo(tcStr, 'Bairro');

    NFSe.PrestadorServico.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
    if NFSe.PrestadorServico.Endereco.CodigoMunicipio = '' then
      NFSe.PrestadorServico.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'Cidade');

    NFSe.PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'Uf');
    if NFSe.PrestadorServico.Endereco.UF = '' then
      NFSe.PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'Estado');

    NFSe.PrestadorServico.Endereco.CodigoPais := Leitor.rCampo(tcInt, 'CodigoPais');
    NFSe.PrestadorServico.Endereco.CEP        := Leitor.rCampo(tcStr, 'Cep');

    if length(NFSe.PrestadorServico.Endereco.CodigoMunicipio) < 7 then
      NFSe.PrestadorServico.Endereco.CodigoMunicipio := Copy(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 1, 2) +
           FormatFloat('00000', StrToIntDef(Copy(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 3, 5), 0));

    NFSe.PrestadorServico.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 0));

  end; // fim EnderecoPrestadorServico

  if (Leitor.rExtrai(3, 'ContatoPrestadorServico') <> '') then
  begin
    NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
    NFSe.PrestadorServico.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
  end; // fim ContatoPrestadorServico

  if Leitor.rExtrai(3, 'OrgaoGerador') <> '' then
  begin
    NFSe.OrgaoGerador.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
    NFSe.OrgaoGerador.Uf              := Leitor.rCampo(tcStr, 'Uf');
  end; // fim OrgaoGerador

  if Leitor.rExtrai(3, 'ConstrucaoCivil') <> '' then
  begin
    NFSe.ConstrucaoCivil.CodigoObra := Leitor.rCampo(tcStr, 'CodigoObra');
    NFSe.ConstrucaoCivil.Art        := Leitor.rCampo(tcStr, 'Art');
  end;

  if Leitor.rExtrai(3, 'Intermediario') <> '' then
  begin
    NFSe.IntermediarioServico.CpfCnpj := Leitor.rCampo(tcStr, 'Cnpj');
  end;

  if (Leitor.rExtrai(3, 'InfDeclaracaoPrestacaoServico') <> '') or
     (Leitor.rExtrai(3, 'DeclaracaoPrestacaoServico') <> '') then
    NivelTemp := 4
  else
    NivelTemp := 3;

  if FProvedor = proSystemPro then
  begin
    NFSe.InfID.ID := Leitor.rAtributo('Id=');
    if NFSe.InfID.ID = '' then
      NFSe.InfID.ID := Leitor.rAtributo('id=');
  end;

  case FProvedor of
    proTecnos:
      NFSe.Competencia := DateTimeToStr(StrToFloatDef(Leitor.rCampo(tcDatHor, 'Competencia'), 0));

    proSigCorp:
      begin
        NFSe.Competencia := Copy(Leitor.rCampo(tcStr, 'Competencia'),5,2);
        NFSe.Competencia := Copy(Leitor.rCampo(tcStr, 'Competencia'),1,4) + '/' +
          IfThen(Length(NFSe.Competencia) = 1, '0' + NFSe.Competencia, NFSe.Competencia);
      end;

    proSimplISSv2:
      NFSe.Competencia := DateToStr(Leitor.rCampo(tcDat, 'Competencia'));
  else
    NFSe.Competencia := Leitor.rCampo(tcStr, 'Competencia');
  end;

  NFSe.RegimeEspecialTributacao := StrToRegimeEspecialTributacao(ok, Leitor.rCampo(tcStr, 'RegimeEspecialTributacao'));
  NFSe.OptanteSimplesNacional   := StrToSimNao(ok, Leitor.rCampo(tcStr, 'OptanteSimplesNacional'));
  NFSe.IncentivadorCultural     := StrToSimNao(ok, Leitor.rCampo(tcStr, 'IncentivoFiscal'));

  if FProvedor = proCONAM then
    NFSe.Producao := StrToSimNao(ok, Leitor.rCampo(tcStr, 'Producao'));

  if (FProvedor <> proABase) and (Leitor.rExtrai(NivelTemp, 'Rps') <> '') then
  begin
    if FProvedor = proSigCorp then
    begin
      DataHorBR := Leitor.rCampo(tcStr, 'DataEmissao');
      // ConsultarNFSePorRps volta com formato m/d/yyyy
      If (Pos('M', DataHorBR) > 0) then
        NFSe.DataEmissaoRps := StringToDateTime(DataHorBR, 'MM/DD/YYYY hh:nn:ss')
      else
        If (Pos('T', DataHorBR) > 0) then
          NFSe.DataEmissaoRps := Leitor.rCampo(tcDatHor, 'DataEmissao')
      else
      If (Pos('-', DataHorBR) > 0) then
          NFSe.DataEmissaoRps := Leitor.rCampo(tcDat, 'DataEmissao')
      else
        NFSe.DataEmissaoRps := StrToDate(DataHorBR);
    end
    else
      NFSe.DataEmissaoRps := Leitor.rCampo(tcDat, 'DataEmissao');


    NFSe.Status         := StrToStatusRPS(ok, Leitor.rCampo(tcStr, 'Status'));

    if (Leitor.rExtrai(NivelTemp+1, 'IdentificacaoRps') <> '') then
    begin
      NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'Numero');
      NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'Serie');
      if (FProvedor = proSigCorp) then
        NFSe.IdentificacaoRps.Tipo   := trRPS
      else
        NFSe.IdentificacaoRps.Tipo   := StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));
      if NFSe.InfID.ID = '' then
        NFSe.InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero) + NFSe.IdentificacaoRps.Serie;
    end;

    if (Leitor.rExtrai(NivelTemp+1, 'RpsSubstituido') <> '') then
    begin
      NFSe.RpsSubstituido.Numero := Leitor.rCampo(tcStr, 'Numero');
      NFSe.RpsSubstituido.Serie  := Leitor.rCampo(tcStr, 'Serie');
      NFSe.RpsSubstituido.Tipo   := StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));
    end;
  end
  else
  begin
    NFSe.DataEmissaoRps := Leitor.rCampo(tcDat, 'DataEmissao');
    NFSe.Status         := StrToStatusRPS(ok, Leitor.rCampo(tcStr, 'Status'));

    if FProvedor = proISSJoinville then
    begin
      if (Leitor.rExtrai(NivelTemp, 'InfNfse') <> '') then
        NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'NumeroRps');
    end
    else if (Leitor.rExtrai(NivelTemp, 'IdentificacaoRps') <> '') then
    begin
      NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'Numero');
      NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'Serie');
      NFSe.IdentificacaoRps.Tipo   := StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));
      if NFSe.InfID.ID = '' then
        NFSe.InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero) + NFSe.IdentificacaoRps.Serie;
    end;

    if (Leitor.rExtrai(NivelTemp, 'RpsSubstituido') <> '') then
    begin
      NFSe.RpsSubstituido.Numero := Leitor.rCampo(tcStr, 'Numero');
      NFSe.RpsSubstituido.Serie  := Leitor.rCampo(tcStr, 'Serie');
      NFSe.RpsSubstituido.Tipo   := StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));
    end;
  end;
  
  if NFSe.Status = srCancelado then
    NFSe.Cancelada := snSim
  else
    NFSe.Cancelada := snNao;

  if FProvedor = proCenti then // carrega-se aqui o IssRetido estar no nivel a acima e n�o no nivel servi�o
  begin
    if (Leitor.rExtrai(FNivel, 'IssRetido') <> '') then
    begin
      NFSe.Servico.Valores.IssRetido := StrToSituacaoTributaria(ok, Leitor.rCampo(tcStr, 'IssRetido'), FProvedor);
      NFSe.Servico.ResponsavelRetencao := StrToResponsavelRetencao(ok, Leitor.rCampo(tcStr, 'ResponsavelRetencao'));
    end;
  end;

  if FProvedor = proSystemPro then
  begin
    i := 0;

    NFSe.Servico.ItemServico.Clear;

    while Leitor.rExtrai(NivelTemp, 'Servico', '', i + 1) <> '' do
    begin
      SetxItemListaServico;

      NFSe.Servico.ItemServico.New;
      NFSe.Servico.Valores.IssRetido            := StrToSituacaoTributaria(ok, Leitor.rCampo(tcStr, 'IssRetido'));
//      NFSe.Servico.ItemListaServico             := Leitor.rCampo(tcStr, 'ItemListaServico');
      NFSe.Servico.ItemServico[i].Descricao     := Leitor.rCampo(tcStr, 'Discriminacao');
      NFSe.Servico.CodigoMunicipio              := Leitor.rCampo(tcStr, 'CodigoMunicipio');
      NFSe.Servico.ExigibilidadeISS             := StrToExigibilidadeISS(ok, Leitor.rCampo(tcStr, 'ExigibilidadeISS'));
      NFSe.Servico.MunicipioIncidencia          := Leitor.rCampo(tcInt, 'MunicipioIncidencia');
      NFSe.Servico.CodigoCnae                   := Leitor.rCampo(tcStr, 'CodigoCnae');
      NFSe.Servico.CodigoTributacaoMunicipio    := Leitor.rCampo(tcStr, 'CodigoTributacaoMunicipio');
      NFSe.Servico.CodigoPais                   := Leitor.rCampo(tcInt, 'CodigoPais');
      NFSe.Servico.NumeroProcesso               := Leitor.rCampo(tcStr, 'NumeroProcesso');
      NFSe.Servico.ResponsavelRetencao          := StrToResponsavelRetencao(ok, Leitor.rCampo(tcStr, 'ResponsavelRetencao'));

      if (Leitor.rExtrai(NivelTemp + 1, 'Valores') <> '') then
      begin
        NFSe.Servico.ItemServico[i].Quantidade := 1;
        NFSe.Servico.ItemServico[i].ValorUnitario := Leitor.rCampo(tcDe2, 'ValorServicos');
        NFSe.Servico.ItemServico[i].ValorTotal := Leitor.rCampo(tcDe2, 'ValorServicos');

        NFSe.Servico.ItemServico[i].ValorServicos          := Leitor.rCampo(tcDe2, 'ValorServicos');
        NFSe.Servico.ItemServico[i].ValorDeducoes          := Leitor.rCampo(tcDe2, 'ValorDeducoes');
        NFSe.Servico.ItemServico[i].ValorIss               := Leitor.rCampo(tcDe2, 'ValorInss');
        NFSe.Servico.ItemServico[i].ValorTaxaTurismo       := Leitor.rCampo(tcDe2, 'ValorTTS');
        NFSe.Servico.ItemServico[i].QuantidadeDiaria       := Leitor.rCampo(tcDe2, 'QuantDiarias');
        NFSe.Servico.ItemServico[i].Aliquota               := Leitor.rCampo(tcDe3, 'Aliquota');
        NFSe.Servico.ItemServico[i].BaseCalculo            := Leitor.rCampo(tcDe2, 'BaseCalculo');
        NFSe.Servico.ItemServico[i].DescontoIncondicionado := Leitor.rCampo(tcDe2, 'DescontoIncondicionado');
        NFSe.Servico.ItemServico[i].DescontoCondicionado   := Leitor.rCampo(tcDe2, 'DescontoCondicionado');
        NFSe.Servico.ItemServico[i].ValorPis               := Leitor.rCampo(tcDe2, 'ValorPis');
        NFSe.Servico.ItemServico[i].ValorCofins            := Leitor.rCampo(tcDe2, 'ValorCofins');
        NFSe.Servico.ItemServico[i].ValorInss              := Leitor.rCampo(tcDe2, 'ValorInss');
        NFSe.Servico.ItemServico[i].ValorIr                := Leitor.rCampo(tcDe2, 'ValorIr');
        NFSe.Servico.ItemServico[i].ValorCsll              := Leitor.rCampo(tcDe2, 'ValorCsll');
      end;

      inc(i);
    end;

    for i := 0 to NFSe.Servico.ItemServico.Count - 1 do
    begin
      NFSe.Servico.Valores.ValorDeducoes := NFSe.Servico.Valores.ValorDeducoes + NFSe.Servico.ItemServico[i].ValorDeducoes;
      NFSe.Servico.Valores.ValorPis      := NFSe.Servico.Valores.ValorPis      + NFSe.Servico.ItemServico[i].ValorPis;
      NFSe.Servico.Valores.ValorCofins   := NFSe.Servico.Valores.ValorCofins   + NFSe.Servico.ItemServico[i].ValorCofins;
      NFSe.Servico.Valores.ValorIr       := NFSe.Servico.Valores.ValorIr       + NFSe.Servico.ItemServico[i].ValorIr;
      NFSe.Servico.Valores.ValorCsll     := NFSe.Servico.Valores.ValorCsll     + NFSe.Servico.ItemServico[i].ValorCsll;
      NFSe.Servico.Valores.ValorInss     := NFSe.Servico.Valores.ValorInss     + NFSe.Servico.ItemServico[i].ValorInss;
    end;
  end
  else
  begin
    if (Leitor.rExtrai(NivelTemp, 'Servico') <> '') then
    begin
      if FProvedor <> proCenti then // se for Centi ja foi feito a cima.
      begin
        NFSe.Servico.Valores.IssRetido   := StrToSituacaoTributaria(ok, Leitor.rCampo(tcStr, 'IssRetido'));
        NFSe.Servico.ResponsavelRetencao := StrToResponsavelRetencao(ok, Leitor.rCampo(tcStr, 'ResponsavelRetencao'));
      end;

      SetxItemListaServico;

      NFSe.Servico.CodigoCnae                := Leitor.rCampo(tcStr, 'CodigoCnae');
      NFSe.Servico.CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'CodigoTributacaoMunicipio');
      NFSe.Servico.Discriminacao             := Leitor.rCampo(tcStr, 'Discriminacao');
      NFSe.Servico.Descricao                 := Leitor.rCampo(tcStr, 'Descricao');
      NFSe.Servico.CodigoMunicipio           := Leitor.rCampo(tcStr, 'CodigoMunicipio');
      NFSe.Servico.CodigoPais                := Leitor.rCampo(tcInt, 'CodigoPais');

      if (FProvedor = proABAse) then
        NFSe.Servico.ExigibilidadeISS := StrToExigibilidadeISS(ok, Leitor.rCampo(tcStr, 'Exigibilidade'))
      else
        NFSe.Servico.ExigibilidadeISS := StrToExigibilidadeISS(ok, Leitor.rCampo(tcStr, 'ExigibilidadeISS'));

      NFSe.Servico.MunicipioIncidencia := Leitor.rCampo(tcInt, 'MunicipioIncidencia');

      if NFSe.Servico.MunicipioIncidencia = 0 then
        NFSe.Servico.MunicipioIncidencia := Leitor.rCampo(tcInt, 'CodigoMunicipio');

      if (Leitor.rExtrai(NivelTemp+1, 'Valores') <> '') then
      begin
        NFSe.Servico.Valores.ValorServicos   := Leitor.rCampo(tcDe2, 'ValorServicos');
        NFSe.Servico.Valores.ValorDeducoes   := Leitor.rCampo(tcDe2, 'ValorDeducoes');
        NFSe.Servico.Valores.ValorPis        := Leitor.rCampo(tcDe2, 'ValorPis');
        NFSe.Servico.Valores.ValorCofins     := Leitor.rCampo(tcDe2, 'ValorCofins');
        NFSe.Servico.Valores.ValorInss       := Leitor.rCampo(tcDe2, 'ValorInss');
        NFSe.Servico.Valores.ValorIr         := Leitor.rCampo(tcDe2, 'ValorIr');
        NFSe.Servico.Valores.ValorCsll       := Leitor.rCampo(tcDe2, 'ValorCsll');
        NFSe.Servico.Valores.OutrasRetencoes := Leitor.rCampo(tcDe2, 'OutrasRetencoes');
  //        NFSe.Servico.Valores.BaseCalculo            := Leitor.rCampo(tcDe2, 'BaseCalculo');

        if NFSe.Servico.Valores.ValorIss = 0 then
          NFSe.Servico.Valores.ValorIss := Leitor.rCampo(tcDe2, 'ValorIss');

        if NFSe.Servico.Valores.Aliquota = 0 then
          NFSe.Servico.Valores.Aliquota := Leitor.rCampo(tcDe3, 'Aliquota');

        if NFSe.Servico.Valores.Aliquota = 0 then
          NFSe.Servico.Valores.Aliquota := Leitor.rCampo(tcDe3, 'AliquotaServicos');

        if (FProvedor in [proActconv202]) then
          NFSe.Servico.Valores.Aliquota := (NFSe.Servico.Valores.Aliquota * 100);

        if (FProvedor in [proActconv202, proISSe, proVersaTecnologia, proNEAInformatica,
                          proFiorilli, proPronimv2, proVitoria, proSmarAPDABRASF,
                          proGovDigital, proDataSmart, proTecnos, proRLZ, proSigCorp,
                          proSaatri, proSH3]) then
        begin
          if NFSe.Servico.Valores.IssRetido = stRetencao then
            NFSe.Servico.Valores.ValorIssRetido := Leitor.rCampo(tcDe2, 'ValorIss')
          else
            NFSe.Servico.Valores.ValorIssRetido := 0;
        end
        else
          NFSe.Servico.Valores.ValorIssRetido := Leitor.rCampo(tcDe2, 'ValorIssRetido');

  //        NFSe.Servico.Valores.ValorIssRetido         := Leitor.rCampo(tcDe2, 'ValorIssRetido');
        NFSe.Servico.Valores.DescontoCondicionado   := Leitor.rCampo(tcDe2, 'DescontoCondicionado');
        NFSe.Servico.Valores.DescontoIncondicionado := Leitor.rCampo(tcDe2, 'DescontoIncondicionado');


        if (NFSe.Servico.Valores.ValorIssRetido = 0) and (NFSe.Servico.Valores.IssRetido=stRetencao) then
        begin
          case FProvedor of
            proSystemPro, proWebISSv2:
                NFSe.Servico.Valores.ValorIssRetido := NFSe.Servico.Valores.ValorIss;

            proGoiania:
                NFSe.Servico.Valores.ValorIssRetido := (NFSe.Servico.Valores.ValorServicos * NFSe.Servico.Valores.Aliquota)/100;
          end;

          NFSe.Servico.Valores.ValorIss := 0;
        end;

        if NFSe.Servico.Valores.ValorLiquidoNfse = 0 then
          NFSe.Servico.Valores.ValorLiquidoNfse := NFSe.Servico.Valores.ValorServicos -
                                                   NFSe.Servico.Valores.DescontoIncondicionado -
                                                   NFSe.Servico.Valores.DescontoCondicionado -
                                                   // Reten��es Federais
                                                   NFSe.Servico.Valores.ValorPis -
                                                   NFSe.Servico.Valores.ValorCofins -
                                                   NFSe.Servico.Valores.ValorIr -
                                                   NFSe.Servico.Valores.ValorInss -
                                                   NFSe.Servico.Valores.ValorCsll -

                                                   NFSe.Servico.Valores.OutrasRetencoes -
                                                   NFSe.Servico.Valores.ValorIssRetido;

        if NFSe.Servico.Valores.BaseCalculo = 0 then
          NFSe.Servico.Valores.BaseCalculo := NFSe.Servico.Valores.ValorServicos -
                                              NFSe.Servico.Valores.ValorDeducoes -
                                              NFSe.Servico.Valores.DescontoIncondicionado;

  //        if NFSe.Servico.Valores.ValorIss = 0 then
  //          NFSe.Servico.Valores.ValorIss := (NFSe.Servico.Valores.BaseCalculo * NFSe.Servico.Valores.Aliquota)/100;

      end;
    end; // fim servi�o
  end;

  if (Leitor.rExtrai(NivelTemp, 'Prestador') <> '') then
  begin
    NFSe.Prestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');

    if (VersaoNFSe = ve100) or
       (FProvedor in [proFiorilli, proGoiania, ProTecnos, proVirtual,
                      proDigifred, proNEAInformatica]) then
    begin
      NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
      if (FProvedor = proTecnos) then
        NFSe.PrestadorServico.RazaoSocial  := Leitor.rCampo(tcStr, 'RazaoSocial');
      if Leitor.rExtrai(NivelTemp+1, 'CpfCnpj') <> '' then
      begin
         NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cpf');
         if NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj = '' then
           NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cnpj');
      end;
      NFSe.Prestador.Cnpj := NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj;
    end
    else
    begin
      NFSe.Prestador.Cnpj := Leitor.rCampo(tcStr, 'Cnpj');
      NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := NFSe.Prestador.Cnpj;
      NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := NFSe.Prestador.InscricaoMunicipal;
    end;
  end; // fim Prestador

  if (Leitor.rExtrai(NivelTemp, 'TomadorServico') <> '') or
     (Leitor.rExtrai(NivelTemp, 'Tomador') <> '') then
  begin
    NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'RazaoSocial');

    NFSe.Tomador.Endereco.Endereco := Leitor.rCampo(tcStr, 'EnderecoDescricao');
    if NFSe.Tomador.Endereco.Endereco = '' then
    begin
      NFSe.Tomador.Endereco.Endereco := Leitor.rCampo(tcStr, 'Endereco');
      if Copy(NFSe.Tomador.Endereco.Endereco, 1, 10) = '<Endereco>' then
        NFSe.Tomador.Endereco.Endereco := Copy(NFSe.Tomador.Endereco.Endereco, 11, 125);
    end;

    NFSe.Tomador.Endereco.Numero      := Leitor.rCampo(tcStr, 'Numero');
    NFSe.Tomador.Endereco.Complemento := Leitor.rCampo(tcStr, 'Complemento');
    NFSe.Tomador.Endereco.Bairro      := Leitor.rCampo(tcStr, 'Bairro');

    NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
    if NFSe.Tomador.Endereco.CodigoMunicipio = '' then
      NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'Cidade');

    NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'Uf');
    if NFSe.Tomador.Endereco.UF = '' then
      NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'Estado');

    NFSe.Tomador.Endereco.CEP := Leitor.rCampo(tcStr, 'Cep');

    if length(NFSe.Tomador.Endereco.CodigoMunicipio) < 7 then
      NFSe.Tomador.Endereco.CodigoMunicipio := Copy(NFSe.Tomador.Endereco.CodigoMunicipio, 1, 2) +
         FormatFloat('00000', StrToIntDef(Copy(NFSe.Tomador.Endereco.CodigoMunicipio, 3, 5), 0));

    if NFSe.Tomador.Endereco.UF = '' then
      NFSe.Tomador.Endereco.UF := NFSe.PrestadorServico.Endereco.UF;

    NFSe.Tomador.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0));

    if (Leitor.rExtrai(NivelTemp+1, 'IdentificacaoTomador') <> '') then
    begin
      NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');

      if Leitor.rExtrai(NivelTemp+2, 'CpfCnpj') <> '' then
      begin
        if Leitor.rCampo(tcStr, 'Cpf')<>'' then
          NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'Cpf')
        else
          NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'Cnpj');
      end;
    end;

    if (Leitor.rExtrai(NivelTemp+1, 'Contato') <> '') then
    begin
      NFSe.Tomador.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
      NFSe.Tomador.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
    end;
  end; // fim Tomador

  Result := True;
end;

function TNFSeR.LerNFSe_Agili: Boolean;
var
  ok: Boolean;
  i: Integer;
  codCNAE: Variant;
  LcodLCServ: string;
  ValorServicosTotal: Currency;

  function _StrToSimNao(out ok: boolean; const s: String): TnfseSimNao;
  begin
    result := StrToEnumerado(ok, s,
                             ['1','0'],
                             [snSim, snNao]);
  end;

  function _StrToResponsavelRetencao(out ok: boolean; const s: String): TnfseResponsavelRetencao;
  begin
    result := StrToEnumerado(ok, s,
                             ['-1', '-2', '-3'],
                             [ptTomador, rtPrestador, rtPrestador]);
  end;

  function _StrToRegimeEspecialTributacao(out ok: boolean; const s: String): TnfseRegimeEspecialTributacao;
  begin
    // -7 Microempresario individual MEI optante pelo SIMEI
    result := StrToEnumerado(ok, s,
                            ['-1','-2','-4','-5','-6'],
                            [retNenhum, retEstimativa, retCooperativa,
                             retMicroempresarioIndividual, retMicroempresarioEmpresaPP
                            ]);
  end;

  function _StrToExigibilidadeISS(out ok: boolean; const s: String): TnfseExigibilidadeISS;
  begin
    // -8 Fixo
    result := StrToEnumerado(ok, s,
                            ['-1','-2','-3','-4','-5','-6','-7'],
                             [exiExigivel, exiNaoIncidencia, exiIsencao, exiExportacao, exiImunidade,
                              exiSuspensaDecisaoJudicial, exiSuspensaProcessoAdministrativo]);
  end;

  function _StrToTipoRPS(out ok: boolean; const s: String): TnfseTipoRPS;
  begin
    result := StrToEnumerado(ok, s,
                             ['-2','-4','-5'],
                             [trRPS, trNFConjugada, trCupom]);
  end;

begin
  LcodLCServ := '';

  ValorServicosTotal := 0;
  if (Leitor.rExtrai(1, 'InfDeclaracaoPrestacaoServico') <> '') or
     (Leitor.rExtrai(1, 'DeclaracaoPrestacaoServico') <> '') then
  begin
    NFSe.Servico.Valores.ValorServicos := Leitor.rCampo(tcDe2, 'ValorServicos');
  end;

  if (Leitor.rExtrai(1, 'ListaServico') <> '') then
  begin
    i := 1;
    while (Leitor.rExtrai(2, 'DadosServico', '', i) <> '') do
    begin
      with NFSe.Servico.ItemServico.New do
      begin
        Descricao := Leitor.rCampo(tcStr, 'Discriminacao');
        Discriminacao := Descricao;
        ValorServicos := Leitor.rCampo(tcDe2, 'ValorServico');
        DescontoIncondicionado := Leitor.rCampo(tcDe2, 'ValorDesconto');
        Quantidade := Leitor.rCampo(tcDe6, 'Quantidade');

        if VersaoNFSe = ve100 then
          codCNAE := Leitor.rCampo(tcStr, 'CodigoCnae');

        CodLCServ := Leitor.rCampo(tcStr, 'ItemLei116');

        LcodLCServ := CodLCServ;

//        if codLCServ = '' then
//          codLCServ := CodLCServ;

        ValorServicosTotal := ValorServicosTotal + ValorServicos;
      end;
      inc(i);
    end;

    for I := 0 to NFSe.Servico.ItemServico.Count - 1 do
    begin
      with NFSe.Servico.ItemServico.Items[I] do
      begin
        if ValorServicosTotal = NFSe.Servico.Valores.ValorServicos then
        begin
          ValorTotal := ValorServicos;
          if Quantidade = 0 then
            ValorUnitario := 0
          else
            ValorUnitario := ValorServicos / Quantidade;
        end
        else
        begin
          ValorUnitario := ValorServicos;
          ValorTotal := ValorUnitario * Quantidade;
        end;
      end;
    end;

  end; // fim lista servi�o

  if Leitor.rExtrai(1, 'Nfse') <> '' then
  begin
    NFSe.Numero := Leitor.rCampo(tcStr, 'Numero');
    NFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'CodigoAutenticidade');
    NFSe.DataEmissao := Leitor.rCampo(tcDatHor, 'DataEmissao');

    if VersaoNFSe = ve200 then
    begin
      NFSe.NfseSubstituida := Leitor.rCampo(tcStr, 'NfseSubstituida');
      NFSe.OutrasInformacoes := Leitor.rCampo(tcStr, 'Observacao');
    end;
  end;

  if Leitor.rExtrai(1, 'SituacaoNfse') <> '' then
  begin
    NFSe.Situacao := Leitor.rCampo(tcStr, 'Codigo');
    case StrToInt(NFSe.Situacao) of
      -2: begin
        NFSe.Cancelada := snSim;
        // DataCancelamento
        // CodigoCancelamento
        // MotivoCancelamento
        NFSe.MotivoCancelamento := Leitor.rCampo(tcStr, 'MotivoCancelamento');
        // JustificativaCancelamento
      end;
      -8: NFSe.Cancelada := snNao;
    end;
  end;

  if Leitor.rExtrai(1, 'IdentificacaoOrgaoGerador') <> '' then
  begin
    if VersaoNFSe = ve100 then
      NFSe.OrgaoGerador.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipioIBGE')
    else
      NFSe.OrgaoGerador.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');

    NFSe.OrgaoGerador.Uf := Leitor.rCampo(tcStr, 'Uf');
  end;

  if Leitor.rExtrai(1, 'DadosPrestador') <> '' then
  begin
    NFSe.PrestadorServico.RazaoSocial  := Leitor.rCampo(tcStr, 'RazaoSocial');
    NFSe.PrestadorServico.NomeFantasia := Leitor.rCampo(tcStr, 'NomeFantasia');

    NFSe.PrestadorServico.Endereco.TipoLogradouro := Leitor.rCampo(tcStr, 'TipoLogradouro');
    NFSe.PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'Logradouro');
    NFSe.PrestadorServico.Endereco.Numero := Leitor.rCampo(tcStr, 'Numero');
    NFSe.PrestadorServico.Endereco.Complemento := Leitor.rCampo(tcStr, 'Complemento');
    NFSe.PrestadorServico.Endereco.Bairro := Leitor.rCampo(tcStr, 'Bairro');

    if VersaoNFSe = ve100 then
    begin
      NFSe.PrestadorServico.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipioIBGE');
      NFSe.PrestadorServico.Endereco.CodigoPais := Leitor.rCampo(tcInt, 'CodigoPaisBacen');
    end
    else
    begin
      NFSe.PrestadorServico.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
      NFSe.PrestadorServico.Endereco.CodigoPais := Leitor.rCampo(tcInt, 'CodigoPais');
    end;

    NFSe.PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'Uf');
    NFSe.PrestadorServico.Endereco.CEP := Leitor.rCampo(tcStr, 'Cep');

    if length(NFSe.PrestadorServico.Endereco.CodigoMunicipio) < 7 then
      NFSe.PrestadorServico.Endereco.CodigoMunicipio := Copy(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 1, 2) +
          FormatFloat('00000', StrToIntDef(Copy(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 3, 5), 0));

    NFSe.PrestadorServico.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 0));

    if Leitor.rExtrai(2, 'Contato') <> '' then
    begin
      NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
      NFSe.PrestadorServico.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
    end;

  end;

  if (Leitor.rExtrai(1, 'IdentificacaoPrestador') <> '') then
  begin
    // NFSe.PrestadorServico.IdentificacaoPrestador.ChaveAcesso := Leitor.rCampo(tcStr, 'ChaveDigital');
    // Remover chave digital do XML da NFS-e 
    NFSe.PrestadorServico.IdentificacaoPrestador.ChaveAcesso := StringOfChar('*', 32);
    NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');

    NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cnpj');
    if (NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj = '') and (Leitor.rExtrai(5, 'CpfCnpj') <> '') then
    begin
      NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cpf');
      if NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj = '' then
        NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'Cnpj');
    end;

  end;

  NFSe.Prestador.Cnpj := NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj;
  NFSe.Prestador.InscricaoMunicipal := NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal;
  NFSe.Prestador.Senha := NFSe.PrestadorServico.IdentificacaoPrestador.Senha;
  NFSe.Prestador.FraseSecreta := NFSe.PrestadorServico.IdentificacaoPrestador.FraseSecreta;
  NFSe.Prestador.cUF := NFSe.PrestadorServico.IdentificacaoPrestador.cUF;
  NFSe.Prestador.InscricaoEstadual := NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoEstadual;
  NFSe.Prestador.ChaveAcesso := NFSe.PrestadorServico.IdentificacaoPrestador.ChaveAcesso;

  // DadosTomador
  // DadosIntermediario
  // DadosMaterialUsado

  if VersaoNFSe = ve100 then
  begin
    if Leitor.rExtrai(1, 'RegimeEspecialTributacao') <> '' then
      NFSe.RegimeEspecialTributacao := _StrToRegimeEspecialTributacao(ok, Leitor.rCampo(tcStr, 'Codigo'));

    //  NFSe.IncentivadorCultural := StrToSimNao(ok, Leitor.rCampo(tcStr, 'IncentivoFiscal'));

    if Leitor.rExtrai(1, 'ResponsavelISSQN') <> '' then
      NFSe.Servico.ResponsavelRetencao := _StrToResponsavelRetencao(ok, Leitor.rCampo(tcStr, 'Codigo'));

    if Leitor.rExtrai(1, 'ExigililidadeISSQN') <> '' then
      NFSe.Servico.ExigibilidadeISS := _StrToExigibilidadeISS(ok, Leitor.rCampo(tcStr, 'Codigo'));

    if Leitor.rExtrai(1, 'MunicipioIncidencia') <> '' then
    begin
      NFSe.Servico.MunicipioIncidencia := Leitor.rCampo(tcInt, 'CodigoMunicipioIBGE');
      NFSe.Servico.CodigoMunicipio := IntToStr(NFSe.Servico.MunicipioIncidencia);
    end;
  end;

  if (Leitor.rExtrai(1, 'InfDeclaracaoPrestacaoServico') <> '') or
     (Leitor.rExtrai(1, 'DeclaracaoPrestacaoServico') <> '') then
  begin
    if VersaoNFSe = ve100 then
      NFSe.NfseSubstituida := Leitor.rCampo(tcStr, 'NfseSubstituida')
    else
    begin
      NFSe.RegimeEspecialTributacao := StrToRegimeEspecialTributacao(ok, Leitor.rCampo(tcStr, 'RegimeEspecialTributacao'));
      //  NFSe.IncentivadorCultural := StrToSimNao(ok, Leitor.rCampo(tcStr, 'IncentivoFiscal'));
      NFSe.Servico.ResponsavelRetencao := StrToResponsavelRetencao(ok, Leitor.rCampo(tcStr, 'ResponsavelRetencao'));
      NFSe.Servico.ExigibilidadeISS := _StrToExigibilidadeISS(ok, Leitor.rCampo(tcStr, 'ExigibilidadeIss'));
      NFSe.Servico.MunicipioIncidencia := Leitor.rCampo(tcInt, 'MunicipioIncidencia');
      NFSe.Servico.CodigoMunicipio := IntToStr(NFSe.Servico.MunicipioIncidencia);
    end;

    NFSe.Servico.CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'CodigoAtividadeEconomica');
    NFSe.Servico.CodigoCnae := codCNAE;
    NFSe.Servico.ItemListaServico := LcodLCServ;

    if TabServicosExt then
      NFSe.Servico.xItemListaServico := ObterDescricaoServico(OnlyNumber(NFSe.Servico.ItemListaServico))
    else
      NFSe.Servico.xItemListaServico := CodigoToDesc(OnlyNumber(NFSe.Servico.ItemListaServico));

    if VersaoNFSe = ve100 then
    begin
      NFSe.Servico.NumeroProcesso := Leitor.rCampo(tcStr, 'BeneficioProcesso');
      NFSe.ValoresNfse.BaseCalculo := Leitor.rCampo(tcDe2, 'ValorBaseCalculoISSQN');
      NFSe.ValoresNfse.Aliquota := Leitor.rCampo(tcDe3, 'AliquotaISSQN');
      // ValorISSQNCalculado
      // ValorISSQNRecolher
      NFSe.ValoresNfse.ValorIss := Leitor.rCampo(tcDe2, 'ValorISSQNRecolher');
    end
    else
    begin
      NFSe.Servico.NumeroProcesso := Leitor.rCampo(tcStr, 'NumeroProcesso');
      NFSe.ValoresNfse.BaseCalculo := Leitor.rCampo(tcDe2, 'ValorBaseCalculoIss');
      NFSe.ValoresNfse.Aliquota := Leitor.rCampo(tcDe3, 'Aliquota');
      NFSe.ValoresNfse.ValorIss := Leitor.rCampo(tcDe2, 'ValorIss');
    end;

    NFSe.ValoresNfse.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'ValorLiquido');

    for I := 0 to NFSe.Servico.ItemServico.Count - 1 do
      NFSe.Servico.ItemServico[I].Aliquota := NFSe.ValoresNfse.Aliquota;

    NFSe.Servico.Valores.ValorServicos := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.Servico.Valores.DescontoIncondicionado := Leitor.rCampo(tcDe2, 'ValorDescontos');
    NFSe.Servico.Valores.DescontoCondicionado := 0;
    NFSe.Servico.Valores.ValorDeducoes   := 0; 
    NFSe.Servico.Valores.ValorPis        := Leitor.rCampo(tcDe2, 'ValorPis');
    NFSe.Servico.Valores.ValorCofins     := Leitor.rCampo(tcDe2, 'ValorCofins');
    NFSe.Servico.Valores.ValorInss       := Leitor.rCampo(tcDe2, 'ValorInss');
    NFSe.Servico.Valores.ValorIr         := Leitor.rCampo(tcDe2, 'ValorIrrf');
    NFSe.Servico.Valores.ValorCsll       := Leitor.rCampo(tcDe2, 'ValorCsll');
    NFSe.Servico.Valores.OutrasRetencoes := Leitor.rCampo(tcDe2, 'ValorOutrasRetencoes');

    if VersaoNFSe = ve100 then
    begin
      NFSe.Servico.Valores.ValorIr         := Leitor.rCampo(tcDe2, 'ValorIrrf');
      NFSe.Servico.Valores.BaseCalculo     := Leitor.rCampo(tcDe2, 'ValorBaseCalculoISSQN');
      NFSe.Servico.Valores.Aliquota        := Leitor.rCampo(tcDe3, 'AliquotaISSQN');
      NFSe.Servico.Valores.ValorIss        := Leitor.rCampo(tcDe2, 'ValorISSQNCalculado');
    end
    else
    begin
      NFSe.Servico.Valores.ValorIr         := Leitor.rCampo(tcDe2, 'ValorIr');
      NFSe.Servico.Valores.BaseCalculo     := Leitor.rCampo(tcDe2, 'ValorBaseCalculoIss');
      NFSe.Servico.Valores.Aliquota        := Leitor.rCampo(tcDe3, 'Aliquota');
      NFSe.Servico.Valores.ValorIss        := Leitor.rCampo(tcDe2, 'ValorIss');
    end;

    NFSe.Servico.Valores.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'ValorLiquido');
    NFSe.Servico.Valores.ValorIssRetido := 0;

    if ((VersaoNFSe = ve100) and (_StrToSimNao(ok, Leitor.rCampo(tcStr, 'ISSQNRetido')) = snSim)) or
       ((VersaoNfse = ve200) and (_StrToSimNao(ok, Leitor.rCampo(tcStr, 'IssRetido')) = snSim)) then
      NFSe.Servico.Valores.ValorIssRetido := NFSe.Servico.Valores.ValorIss;

    if NFSe.Servico.Valores.ValorLiquidoNfse = 0 then
      NFSe.Servico.Valores.ValorLiquidoNfse := NFSe.Servico.Valores.ValorServicos -
                                               NFSe.Servico.Valores.DescontoIncondicionado -
                                               NFSe.Servico.Valores.DescontoCondicionado -
                                               // Reten��es Federais
                                               NFSe.Servico.Valores.ValorPis -
                                               NFSe.Servico.Valores.ValorCofins -
                                               NFSe.Servico.Valores.ValorIr -
                                               NFSe.Servico.Valores.ValorInss -
                                               NFSe.Servico.Valores.ValorCsll -

                                               NFSe.Servico.Valores.OutrasRetencoes -
                                               NFSe.Servico.Valores.ValorIssRetido;

    if NFSe.Servico.Valores.BaseCalculo = 0 then
      NFSe.Servico.Valores.BaseCalculo := NFSe.Servico.Valores.ValorServicos -
                                          NFSe.Servico.Valores.ValorDeducoes -
                                          NFSe.Servico.Valores.DescontoIncondicionado;

//    NFSe.InfID.ID := Leitor.rAtributo('Id=');
//    if NFSe.InfID.ID = '' then
//      NFSe.InfID.ID := Leitor.rAtributo('id=');

    NFSe.Competencia := FormatDateTime('mm/yyyy', NFSe.DataEmissao);
    NFSe.OptanteSimplesNacional := _StrToSimNao(ok, Leitor.rCampo(tcStr, 'OptanteSimplesNacional'));

    if VersaoNFSe = ve100 then
      NFSe.OutrasInformacoes := Leitor.rCampo(tcStr, 'Observacao');
  end;
  
  // Fim infDeclaracaoServico
  
  if (Leitor.rExtrai(2, 'Rps') <> '') then
  begin
    NFSe.DataEmissaoRps := Leitor.rCampo(tcDat, 'DataEmissao');
    //NFSe.Status         := StrToStatusRPS(ok, Leitor.rCampo(tcStr, 'Status'));

    if (Leitor.rExtrai(3, 'IdentificacaoRps') <> '') then
    begin
      NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'Numero');
      NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'Serie');

      if VersaoNFSe = ve100 then
        NFSe.IdentificacaoRps.Tipo := _StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'))
      else
        NFSe.IdentificacaoRps.Tipo := StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));

      if NFSe.InfID.ID = '' then
        NFSe.InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero) + NFSe.IdentificacaoRps.Serie;
    end;
  end;

  if (Leitor.rExtrai(2, 'DadosTomador') <> '') then
  begin
    NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'RazaoSocial');

    NFSe.Tomador.Endereco.TipoLogradouro := Leitor.rCampo(tcStr, 'TipoLogradouro');
    NFSe.Tomador.Endereco.Endereco := Leitor.rCampo(tcStr, 'Logradouro');
    NFSe.Tomador.Endereco.Numero := Leitor.rCampo(tcStr, 'Numero');
    NFSe.Tomador.Endereco.Complemento := Leitor.rCampo(tcStr, 'Complemento');
    NFSe.Tomador.Endereco.Bairro := Leitor.rCampo(tcStr, 'Bairro');

    if VersaoNFSe = ve100 then
      NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipioIBGE')
    else
      NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');

    NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'Uf');
    NFSe.Tomador.Endereco.CEP := Leitor.rCampo(tcStr, 'Cep');

    if length(NFSe.Tomador.Endereco.CodigoMunicipio) < 7 then
      NFSe.Tomador.Endereco.CodigoMunicipio := Copy(NFSe.Tomador.Endereco.CodigoMunicipio, 1, 2) +
         FormatFloat('00000', StrToIntDef(Copy(NFSe.Tomador.Endereco.CodigoMunicipio, 3, 5), 0));

    if NFSe.Tomador.Endereco.UF = '' then
      NFSe.Tomador.Endereco.UF := NFSe.PrestadorServico.Endereco.UF;

    NFSe.Tomador.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0));

    if (Leitor.rExtrai(2, 'IdentificacaoTomador') <> '') then
    begin
      NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');

      if Leitor.rExtrai(3, 'CpfCnpj') <> '' then
      begin
        if Leitor.rCampo(tcStr, 'Cpf')<>'' then
          NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'Cpf')
        else
          NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'Cnpj');
      end;
    end;

    if (Leitor.rExtrai(2, 'Contato') <> '') then
    begin
      NFSe.Tomador.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
      NFSe.Tomador.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
    end;
  end;

  Result := True;
end;

function TNFSeR.LerNFSe_ISSDSF: Boolean;
var
  ok: Boolean;
  Item: Integer;
  sOperacao, sTributacao: String;
begin
  Leitor.Grupo := Leitor.Arquivo;

  if (Pos('<Notas>', Leitor.Arquivo) > 0) or
     (Pos('<Nota>', Leitor.Arquivo) > 0) or
     (Pos('<ConsultaNFSe>', Leitor.Arquivo) > 0) then
  begin
    VersaoNFSe := ve100; // para este provedor usar padr�o "1".

    FNFSe.Numero := Leitor.rCampo(tcStr, 'NumeroNota');
    if (FNFSe.Numero = '') then
      FNFSe.Numero := Leitor.rCampo(tcStr, 'NumeroNFe');

    FNFSe.NumeroLote := Leitor.rCampo(tcStr, 'NumeroLote');
    FNFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'CodigoVerificacao');
    if FNFSe.CodigoVerificacao = '' then
      FNFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'CodigoVerificao');

    FNFSe.DataEmissaoRps := Leitor.rCampo(tcDatHor, 'DataEmissaoRPS');
    FNFSe.Competencia    := Copy(Leitor.rCampo(tcDat, 'DataEmissaoRPS'),7,4) + Copy(Leitor.rCampo(tcDat, 'DataEmissaoRPS'),4,2);
    FNFSe.DataEmissao    := Leitor.rCampo(tcDatHor, 'DataProcessamento');
    if (FNFSe.DataEmissao = 0) then
      FNFSe.DataEmissao  := FNFSe.DataEmissaoRps;

    FNFSe.Status := StrToEnumerado(ok, Leitor.rCampo(tcStr, 'SituacaoRPS'),['N','C'],[srNormal, srCancelado]);

    NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'NumeroRPS');
    NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'SerieRPS');
    NFSe.IdentificacaoRps.Tipo   := trRPS; //StrToTipoRPS(ok, leitorAux.rCampo(tcStr, 'Tipo'));

    if NFSe.InfID.ID = '' then
      NFSe.InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero);// + NFSe.IdentificacaoRps.Serie;
      
    NFSe.SeriePrestacao := Leitor.rCampo(tcStr, 'SeriePrestacao');

    NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipalTomador');
    NFSe.Tomador.IdentificacaoTomador.CpfCnpj            := Leitor.rCampo(tcStr, 'CPFCNPJTomador');

    NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'RazaoSocialTomador');

    NFSe.Tomador.Endereco.TipoLogradouro := Leitor.rCampo(tcStr, 'TipoLogradouroTomador');
    NFSe.Tomador.Endereco.Endereco       := Leitor.rCampo(tcStr, 'LogradouroTomador');
    NFSe.Tomador.Endereco.Numero         := Leitor.rCampo(tcStr, 'NumeroEnderecoTomador');
    NFSe.Tomador.Endereco.Complemento    := Leitor.rCampo(tcStr, 'ComplementoEnderecoTomador');
    NFSe.Tomador.Endereco.TipoBairro     := Leitor.rCampo(tcStr, 'TipoBairroTomador');
    NFSe.Tomador.Endereco.Bairro         := Leitor.rCampo(tcStr, 'BairroTomador');

    if (Leitor.rCampo(tcStr, 'CidadeTomador') <> '') then
    begin
      NFSe.Tomador.Endereco.CodigoMunicipio := CodSiafiToCodCidade( Leitor.rCampo(tcStr, 'CidadeTomador'));
      NFSe.Tomador.Endereco.xMunicipio      := CodCidadeToCidade( StrToInt(NFSe.Tomador.Endereco.CodigoMunicipio) );
      NFSe.Tomador.Endereco.UF              := CodigoParaUF( StrToInt(Copy(NFSe.Tomador.Endereco.CodigoMunicipio,1,2) ));
    end;

    NFSe.Tomador.Endereco.CEP  := Leitor.rCampo(tcStr, 'CEPTomador');
    NFSe.Tomador.Contato.Email := Leitor.rCampo(tcStr, 'EmailTomador');

    NFSe.Servico.CodigoCnae        := Leitor.rCampo(tcStr, 'CodigoAtividade');
    NFSe.Servico.Valores.Aliquota  := Leitor.rCampo(tcDe3, 'AliquotaAtividade');
    NFSe.Servico.Valores.IssRetido := StrToEnumerado( ok, Leitor.rCampo(tcStr, 'TipoRecolhimento'),
                                                     ['A','R'], [ stNormal, stRetencao{, stSubstituicao}]);

    if (Leitor.rCampo(tcStr, 'MunicipioPrestacao') <> '') then
      NFSe.Servico.CodigoMunicipio := CodSiafiToCodCidade( Leitor.rCampo(tcStr, 'MunicipioPrestacao'));

    sOperacao   := AnsiUpperCase(Leitor.rCampo(tcStr, 'Operacao'));
    sTributacao := AnsiUpperCase(Leitor.rCampo(tcStr, 'Tributacao'));
    NFSe.TipoRecolhimento := AnsiUpperCase(Leitor.rCampo(tcStr, 'TipoRecolhimento'));

    if (sOperacao <> '') then
    begin
      if (sOperacao = 'A') or (sOperacao = 'B') then
      begin
        if NFSe.Servico.CodigoMunicipio = NFSe.PrestadorServico.Endereco.CodigoMunicipio then
          NFSe.NaturezaOperacao := no1
        else
          NFSe.NaturezaOperacao := no2;
      end
      else if (sOperacao = 'C') and (sTributacao = 'C') then
           begin
             NFSe.NaturezaOperacao := no3;
           end
           else if (sOperacao = 'C') and (sTributacao = 'F') then
                begin
                  NFSe.NaturezaOperacao := no4;
                end
                else if (sOperacao = 'A') and (sTributacao = 'N') then
                     begin
                       NFSe.NaturezaOperacao := no7;
                     end;
    end;

    NFSe.Servico.Operacao := StrToOperacao(Ok, sOperacao);
    NFSe.Servico.Tributacao := StrToTributacao(Ok, sTributacao);

    NFSe.NaturezaOperacao := StrToEnumerado( ok,sTributacao, ['T','K'], [ NFSe.NaturezaOperacao, no5 ]);

    NFSe.OptanteSimplesNacional := StrToEnumerado( ok,sTributacao, ['T','H'], [ snNao, snSim ]);

    NFSe.DeducaoMateriais := StrToEnumerado( ok,sOperacao, ['A','B'], [ snNao, snSim ]);

    NFse.RegimeEspecialTributacao := StrToEnumerado( ok,sTributacao, ['T','M'], [ retNenhum, retMicroempresarioIndividual ]);

    NFSe.Servico.Valores.ValorPis       := Leitor.rCampo(tcDe2, 'ValorPIS');
    NFSe.Servico.Valores.ValorCofins    := Leitor.rCampo(tcDe2, 'ValorCOFINS');
    NFSe.Servico.Valores.ValorInss      := Leitor.rCampo(tcDe2, 'ValorINSS');
    NFSe.Servico.Valores.ValorIr        := Leitor.rCampo(tcDe2, 'ValorIR');
    NFSe.Servico.Valores.ValorCsll      := Leitor.rCampo(tcDe2, 'ValorCSLL');
    NFSe.Servico.Valores.AliquotaPIS    := Leitor.rCampo(tcDe2, 'AliquotaPIS');
    NFSe.Servico.Valores.AliquotaCOFINS := Leitor.rCampo(tcDe2, 'AliquotaCOFINS');
    NFSe.Servico.Valores.AliquotaINSS   := Leitor.rCampo(tcDe2, 'AliquotaINSS');
    NFSe.Servico.Valores.AliquotaIR     := Leitor.rCampo(tcDe2, 'AliquotaIR');
    NFSe.Servico.Valores.AliquotaCSLL   := Leitor.rCampo(tcDe2, 'AliquotaCSLL');

    NFSe.OutrasInformacoes                 := '';//Leitor.rCampo(tcStr, 'DescricaoRPS');
    NFSe.Servico.Discriminacao             := Leitor.rCampo(tcStr, 'DescricaoRPS');
    NFSe.Servico.CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'CodigoAtividade');

    NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'DDDPrestador') + Leitor.rCampo(tcStr, 'TelefonePrestador');
    NFSe.Tomador.Contato.Telefone          := Leitor.rCampo(tcStr, 'DDDTomador') + Leitor.rCampo(tcStr, 'TelefoneTomador');

    NFSE.MotivoCancelamento := Leitor.rCampo(tcStr, 'MotCancelamento');

    NFSe.IntermediarioServico.CpfCnpj := Leitor.rCampo(tcStr, 'CPFCNPJIntermediario');

    if (Leitor.rExtrai(1, 'Deducoes') <> '') then
    begin
      Item := 0;
      while (Leitor.rExtrai(1, 'Deducao', '', Item + 1) <> '') do
      begin
        FNfse.Servico.Deducao.New;
        FNfse.Servico.Deducao[Item].DeducaoPor  :=
           StrToEnumerado( ok,Leitor.rCampo(tcStr, 'DeducaoPor'),
                           ['','Percentual','Valor'],
                           [ dpNenhum,dpPercentual, dpValor ]);

        FNfse.Servico.Deducao[Item].TipoDeducao :=
           StrToEnumerado( ok,Leitor.rCampo(tcStr, 'TipoDeducao'),
                           ['', 'Despesas com Materiais', 'Despesas com Sub-empreitada'],
                           [ tdNenhum, tdMateriais, tdSubEmpreitada ]);

        FNfse.Servico.Deducao[Item].CpfCnpjReferencia    := Leitor.rCampo(tcStr, 'CPFCNPJReferencia');
        FNfse.Servico.Deducao[Item].NumeroNFReferencia   := Leitor.rCampo(tcStr, 'NumeroNFReferencia');
        FNfse.Servico.Deducao[Item].ValorTotalReferencia := Leitor.rCampo(tcDe2, 'ValorTotalReferencia');
        FNfse.Servico.Deducao[Item].PercentualDeduzir    := Leitor.rCampo(tcDe2, 'PercentualDeduzir');
        FNfse.Servico.Deducao[Item].ValorDeduzir         := Leitor.rCampo(tcDe2, 'ValorDeduzir');
        inc(Item);
      end;
    end;

    if (Leitor.rExtrai(1, 'Itens') <> '') then
    begin
      Item := 0;
      while (Leitor.rExtrai(1, 'Item', '', Item + 1) <> '') do
      begin
        FNfse.Servico.ItemServico.New;
        FNfse.Servico.ItemServico[Item].Descricao     := Leitor.rCampo(tcStr, 'DiscriminacaoServico');
        FNfse.Servico.ItemServico[Item].Quantidade    := Leitor.rCampo(tcDe2, 'Quantidade');
        FNfse.Servico.ItemServico[Item].ValorUnitario := Leitor.rCampo(tcDe2, 'ValorUnitario');
        FNfse.Servico.ItemServico[Item].ValorTotal    := Leitor.rCampo(tcDe2, 'ValorTotal');
        FNfse.Servico.ItemServico[Item].Tributavel    := StrToEnumerado( ok,Leitor.rCampo(tcStr, 'Tributavel'), ['N','S'], [ snNao, snSim ]);
        FNfse.Servico.Valores.ValorServicos           := (FNfse.Servico.Valores.ValorServicos + FNfse.Servico.ItemServico[Item].ValorTotal);
        inc(Item);
      end;
    end;
  end;

  (**** calculo anterior
  FNFSe.Servico.Valores.ValorLiquidoNfse := (FNfse.Servico.Valores.ValorServicos -
                                            (FNfse.Servico.Valores.ValorDeducoes +
                                             FNfse.Servico.Valores.DescontoCondicionado+
                                             FNfse.Servico.Valores.DescontoIncondicionado+
                                             FNFSe.Servico.Valores.ValorIssRetido));
  *)

  // Corre��o para o c�lculo de VALOR LIQUIDO da NFSE - estavam faltando PIS, COFINS, INSS, IR e CSLL
  NFSe.Servico.Valores.ValorLiquidoNfse := NFSe.Servico.Valores.ValorServicos -
                                            (NFSe.Servico.Valores.ValorPis +
                                             NFSe.Servico.Valores.ValorCofins +
                                             NFSe.Servico.Valores.ValorInss +
                                             NFSe.Servico.Valores.ValorIr +
                                             NFSe.Servico.Valores.ValorCsll +
                                             FNfse.Servico.Valores.ValorDeducoes +
                                             FNfse.Servico.Valores.DescontoCondicionado+
                                             FNfse.Servico.Valores.DescontoIncondicionado+
                                             FNFSe.Servico.Valores.ValorIssRetido);


  FNfse.Servico.Valores.BaseCalculo := NFSe.Servico.Valores.ValorLiquidoNfse;

  Result := True;
end;

function TNFSeR.LerNFSe_Smarapd: Boolean;
var
  vOk: Boolean;
  vItem: Integer;
  vLinha: String;
begin
  Leitor.Grupo := Leitor.Arquivo;
  VersaoXML := '1';
  with NFSe do
  begin
    Numero                  := Leitor.rCampo(tcStr, 'NumeroNota');
    CodigoVerificacao       := Leitor.rCampo(tcStr, 'ChaveValidacao');
    DataEmissaoRps          := Leitor.rCampo(tcDatHor, 'DataEmissao');
    Competencia             := Leitor.rCampo(tcStr, 'DataEmissao');
    DataEmissao             := Leitor.rCampo(tcDatHor, 'DataEmissao');
    NaturezaOperacao        := StrToNaturezaOperacao(vOk, Leitor.rCampo(tcStr, 'NaturezaOperacao'));
    Numero                  := Leitor.rCampo(tcStr, 'NumeroNota');
    CodigoVerificacao       := Leitor.rCampo(tcStr, 'ChaveValidacao');
    DataEmissaoRps          := Leitor.rCampo(tcDatHor, 'DataEmissao');
    Competencia             := Leitor.rCampo(tcStr, 'DataEmissao');
    DataEmissao             := Leitor.rCampo(tcDatHor, 'DataEmissao');
    dhRecebimento           := Leitor.rCampo(tcDatHor, 'DataEmissao');
    Protocolo               := Leitor.rCampo(tcStr, 'ChaveValidacao');
    OutrasInformacoes       := Leitor.rCampo(tcStr, 'Observacao');
    if (Leitor.rCampo(tcStr, 'SituacaoNf') = 'Cancelada') then
    begin
      Status    := srCancelado;
      Cancelada := snSim;
      NfseCancelamento.DataHora:= Leitor.rCampo(tcDatHor, 'DataEmissao');
    end
    else
    begin
      Status    := srNormal;
      Cancelada := snNao;
    end;

    IdentificacaoRps.Numero := Leitor.rCampo(tcStr,'NumeroRps');
    IdentificacaoRps.Tipo   := trRPS;
    InfID.ID                := OnlyNumber(FNFSe.Numero);// + NFSe.IdentificacaoRps.Serie;
    with PrestadorServico do
    begin
     RazaoSocial                               := Trim(Leitor.rCampo(tcStr, 'TimbreContribuinteLinha1'));
     vLinha                                    := Trim(Leitor.rCampo(tcStr, 'TimbreContribuinteLinha2'));
     Endereco.Endereco                         := Trim(copy(vLinha,1,pos(',',vLinha)-1));
     Endereco.Numero                           := Trim(copy(vLinha,pos(',',vLinha)+1,(pos('-',vLinha)- pos(',',vLinha))-1));
     Endereco.Bairro                           := Trim(copy(vLinha,pos('-',vLinha)+1,length(vLinha)-1));
     Endereco.Complemento                      := '';
     vLinha                                    := Trim(Leitor.rCampo(tcStr, 'TimbreContribuinteLinha3'));
     vLinha                                    := Trim(copy(vLinha,pos('-',vLinha)+1,length(vLinha)-1));
     Endereco.xMunicipio                       := Trim(copy(vLinha,1,pos('-',vLinha)-1));
     Endereco.UF                               := Trim(copy(vLinha,pos('-',vLinha)+1,length(vLinha)-1));
     vLinha                                    := Trim(Leitor.rCampo(tcStr, 'TimbreContribuinteLinha4'));
     IdentificacaoPrestador.InscricaoMunicipal := Trim(copy(vLinha,23,(pos('CPF/CNPJ:',vLinha)-24)));
     IdentificacaoPrestador.Cnpj               := Trim(copy(vLinha,pos('CPF/CNPJ:',vLinha)+10,length(vLinha)-1));
     Contato.Telefone                          := '';
    end;
    with Tomador do
    begin
      with IdentificacaoTomador do
      begin
       InscricaoMunicipal := Leitor.rCampo(tcStr, 'ClienteInscricaoMunicipal');
       CpfCnpj            := Leitor.rCampo(tcStr, 'ClienteCNPJCPF');
      end;
      RazaoSocial         := Leitor.rCampo(tcStr, 'ClienteNomeRazaoSocial');
      with Endereco do
      begin
        TipoLogradouro  := '';
        Endereco        := Leitor.rCampo(tcStr, 'ClienteEndereco');
        Numero          := Leitor.rCampo(tcStr, 'ClienteNumeroLogradouro');
        Complemento     := '';
        TipoBairro      := '';
        Bairro          := Leitor.rCampo(tcStr, 'ClienteBairro');
        CodigoMunicipio := '0';
        xMunicipio      := Leitor.rCampo(tcStr, 'ClienteCidade');
        UF              := Leitor.rCampo(tcStr, 'ClienteUF');
        CEP             := Leitor.rCampo(tcStr, 'ClienteCEP');
      end;
      with Contato do
      begin
        Email    := Leitor.rCampo(tcStr, 'ClienteEmail');
        Telefone := Leitor.rCampo(tcStr, 'ClienteFone') + Leitor.rCampo(tcStr, 'TelefoneTomador');
      end;
    end;
    with Servico do
    begin
      CodigoCnae := Leitor.rCampo(tcStr, 'CodigoAtividade');
      CodigoMunicipio := '';
      with Valores do
      begin
        Aliquota       := Leitor.rCampo(tcDe3, 'Aliquota');
        IssRetido      := StrToEnumerado( vOk, Leitor.rCampo(tcStr, 'ImpostoRetido'),['A','R'], [stNormal, stRetencao]);
        ValorPis       := Leitor.rCampo(tcDe2, 'Pis');
        ValorCofins    := Leitor.rCampo(tcDe2, 'Cofins');
        ValorInss      := Leitor.rCampo(tcDe2, 'Inss');
        ValorIr        := Leitor.rCampo(tcDe2, 'Irrf');
        ValorCsll      := Leitor.rCampo(tcDe2, 'Csll');
        AliquotaPIS    := 0;
        AliquotaCOFINS := 0;
        AliquotaINSS   := 0;
        AliquotaIR     := 0;
        AliquotaCSLL   := 0;
      end;
      Discriminacao             := '';
      CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'CodigoAtividade');
    end;

    MotivoCancelamento           := '';
    IntermediarioServico.CpfCnpj := '';
    if (Leitor.rExtrai(1, 'ITENS') <> '') then
    begin
      vItem := 0;
      while (Leitor.rExtrai(1, 'ITENS', '', vItem + 1) <> '') do
      begin
        with  FNfse.Servico do
        begin
          ItemServico.New;
          if NFSe.Servico.Discriminacao = '' then
            NFSe.Servico.Discriminacao := Leitor.rCampo(tcStr, 'Servico');
          ItemServico[vItem].Descricao     := Leitor.rCampo(tcStr, 'Servico');
          ItemServico[vItem].Quantidade    := Leitor.rCampo(tcDe2, 'Quantidade');
          ItemServico[vItem].ValorUnitario := Leitor.rCampo(tcDe2, 'ValorUnitario');
          ItemServico[vItem].ValorTotal    := Leitor.rCampo(tcDe2, 'ValorTotal');
          ItemServico[vItem].Tributavel    := snSim;
          ItemServico[vItem].Aliquota      := Leitor.rCampo(tcDe2, 'Aliquota');
          Valores.ValorServicos            := FNfse.Servico.Valores.ValorServicos + FNfse.Servico.ItemServico[vItem].ValorTotal;
          inc(vItem);
        end;
      end;
    end;
    FNfse.Servico.Valores.ValorIss        := (FNfse.Servico.Valores.ValorServicos * NFSe.Servico.Valores.Aliquota)/100;
    NFSe.Servico.Valores.ValorLiquidoNfse := FNfse.Servico.Valores.ValorServicos - (FNfse.Servico.Valores.ValorDeducoes +
                                             FNfse.Servico.Valores.DescontoCondicionado + FNfse.Servico.Valores.DescontoIncondicionado+
                                             NFSe.Servico.Valores.ValorIssRetido);
    FNfse.Servico.Valores.BaseCalculo     := NFSe.Servico.Valores.ValorLiquidoNfse;
  end;
 Result := True;
end;

function TNFSeR.LerNFSe_Giap: Boolean;
begin
  Leitor.Grupo := Leitor.Arquivo;
  VersaoXML := '1';

  if Leitor.rExtrai(1, 'notaFiscal') <> EmptyStr then
  begin
    with NFSe do
    begin

      if Leitor.rExtrai(2, 'dadosPrestador') <> EmptyStr then
      begin
        DataEmissao                               := Leitor.rCampo(tcDatVcto, 'dataEmissao');
        DataEmissaoRps                            := Leitor.rCampo(tcDatVcto, 'dataEmissao');
        Competencia                               := FormatDateTime('mm/yyyy', Leitor.rCampo(tcDatVcto, 'dataEmissao'));
        Numero                                    := Leitor.rCampo(tcStr, 'numeroNota');
        IdentificacaoRps.Numero                   := Leitor.rCampo(tcStr, 'numeroRps');
        IdentificacaoRps.Serie                    := '';
        IdentificacaoRps.Tipo                     := trRPS;
        Status                                    := srNormal;
        Cancelada                                 := snNao;
        CodigoVerificacao                         := Leitor.rCampo(tcStr, 'codigoVerificacao');
        PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'im');
      end;
      InfID.ID                    := OnlyNumber(FNFSe.Numero);

      if Leitor.rExtrai(2, 'dadosServico') <> EmptyStr then
      begin
        with PrestadorServico do
        begin
          IdentificacaoPrestador.Cnpj               := '';
          RazaoSocial                               := '';
          Endereco.Endereco                         := Leitor.rCampo(tcStr, 'logradouro');
          Endereco.Numero                           := Leitor.rCampo(tcStr, 'numero');
          Endereco.Bairro                           := Leitor.rCampo(tcStr, 'bairro');
          Endereco.Complemento                      := Leitor.rCampo(tcStr, 'complemento');
          Endereco.xMunicipio                       := Leitor.rCampo(tcStr, 'cidade');
          Endereco.UF                               := Leitor.rCampo(tcStr, 'uf');
          Endereco.xPais                            := Leitor.rCampo(tcStr, 'pais');
          Endereco.CEP                              := Leitor.rCampo(tcStr, 'cep');
          Contato.Telefone                          := Leitor.rCampo(tcStr, 'numero');
        end;
      end;

      if Leitor.rExtrai(2, 'dadosTomador') <> EmptyStr then
      begin
        with Tomador do
        begin
          with IdentificacaoTomador do
          begin
           InscricaoMunicipal := '';
           CpfCnpj            := Leitor.rCampo(tcStr, 'documento');
           InscricaoEstadual  := Leitor.rCampo(tcStr, 'ie');
          end;
          RazaoSocial         := Leitor.rCampo(tcStr, 'nomeTomador');
          with Endereco do
          begin
            TipoLogradouro  := '';
            Endereco        := Leitor.rCampo(tcStr, 'logradouro');
            Numero          := Leitor.rCampo(tcStr, 'numero');
            Complemento     := Leitor.rCampo(tcStr, 'complemento');
            TipoBairro      := '';
            Bairro          := Leitor.rCampo(tcStr, 'bairro');
            CodigoMunicipio := '0';
            xMunicipio      := Leitor.rCampo(tcStr, 'cidade');
            UF              := Leitor.rCampo(tcStr, 'uf');
            CEP             := Leitor.rCampo(tcStr, 'cep');
          end;
          with Contato do
          begin
            Email    := Leitor.rCampo(tcStr, 'email');
            Telefone := '';
          end;
        end;
      end;

      if Leitor.rExtrai(2, 'detalheServico') <> EmptyStr then
      begin
        with Servico do
        begin
          with Valores do
          begin
            Aliquota                := Leitor.rCampo(tcDe3, 'Aliquota');
            ValorPis                := Leitor.rCampo(tcDe2, 'pisPasep');
            ValorCofins             := Leitor.rCampo(tcDe2, 'cofins');
            ValorInss               := Leitor.rCampo(tcDe2, 'inss');
            ValorIr                 := Leitor.rCampo(tcDe2, 'ir');
            ValorCsll               := Leitor.rCampo(tcDe2, 'csll');
            ValorIssRetido          := Leitor.rCampo(tcDe2, 'issRetido');
            ValorDeducoes           := Leitor.rCampo(tcDe2, 'deducaoMaterial');
            DescontoIncondicionado  := Leitor.rCampo(tcDe2, 'descontoIncondicional');
            if ValorIssRetido > 0 then
              IssRetido    := stRetencao
            else
              IssRetido    := stNormal;


            AliquotaPIS    := 0;
            AliquotaCOFINS := 0;
            AliquotaINSS   := 0;
            AliquotaIR     := 0;
            AliquotaCSLL   := 0;
          end;
          OutrasInformacoes      := Leitor.rCampo(tcStr, 'obs');
          if Leitor.rExtrai(3, 'item') <> EmptyStr then
          begin
            CodigoCnae             := Leitor.rCampo(tcStr, 'cnae');
            ItemListaServico       := Leitor.rCampo(tcStr, 'codigo');
            Discriminacao          := Leitor.rCampo(tcStr, 'descricao');
            Valores.Aliquota       := Leitor.rCampo(tcDe3, 'aliquota');
            Valores.ValorServicos  := Leitor.rCampo(tcDe2, 'valor');
          end;
        end;
      end;

      FNfse.Servico.Valores.ValorIss        := (FNfse.Servico.Valores.ValorServicos * NFSe.Servico.Valores.Aliquota)/100;
      NFSe.Servico.Valores.ValorLiquidoNfse := FNfse.Servico.Valores.ValorServicos - (FNfse.Servico.Valores.ValorDeducoes +
                                               FNfse.Servico.Valores.DescontoCondicionado + FNfse.Servico.Valores.DescontoIncondicionado+
                                               NFSe.Servico.Valores.ValorIssRetido);
      FNfse.Servico.Valores.BaseCalculo     := NFSe.Servico.Valores.ValorLiquidoNfse;
    end;
    Result := True;
  end
  else
    Result := False;
end;

function TNFSeR.LerNFSe_SP: Boolean;
var
  bOk :Boolean;
//  valorIssRetido: Double;
begin
  Result := False;

  if (Leitor.rExtrai(1, 'NFe') <> '') or (Leitor.rExtrai(1, 'CompNfse') <> '') then
  begin
    NFSe.dhRecebimento  := Now;
    NFSe.Protocolo      := Leitor.rCampo(tcStr, 'NumeroLote');
    NFSe.NumeroLote     := Leitor.rCampo(tcStr, 'NumeroLote');
    NFSe.DataEmissao    := Leitor.rCampo(tcDatHor, 'DataEmissaoNFe');
    NFSe.DataEmissaoRps := Leitor.rCampo(tcDat, 'DataEmissaoRPS');

    if (Leitor.rCampo(tcStr, 'StatusNFe') = 'C') then
    begin
      NFSe.Status    := srCancelado;
      NFSe.Cancelada := snSim;
    end
    else
    begin
      NFSe.Status    := srNormal;
      NFSe.Cancelada := snNao;
    end;

    NFSe.TipoTributacaoRPS := StrToTTributacaoRPS(bOk, Leitor.rCampo(tcStr, 'TributacaoNFe'));

    if (Leitor.rCampo(tcStr, 'OpcaoSimples') = '0') then // ver pag do manual de integra�ao...
      NFSe.OptanteSimplesNacional := snNao
    else
      NFSe.OptanteSimplesNacional := snSim;

    NFSe.ValoresNfse.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.ValoresNfse.BaseCalculo      := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.ValoresNfse.Aliquota         := Leitor.rCampo(tcDe2, 'AliquotaServicos');
    if (FProvedor in [proSP]) then
      NFSe.ValoresNfse.Aliquota       := (NFSe.ValoresNfse.Aliquota * 100);
    NFSe.ValoresNfse.ValorIss         := Leitor.rCampo(tcDe2, 'ValorISS');

    NFSe.Servico.ItemListaServico := Leitor.rCampo(tcStr, 'CodigoServico');
    NFSe.Servico.Discriminacao    := Leitor.rCampo(tcStr, 'Discriminacao');

    SetxItemListaServico;

    //NFSe.Servico.Valores.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.Servico.Valores.ValorServicos    := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.Servico.Valores.BaseCalculo      := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.Servico.Valores.Aliquota         := Leitor.rCampo(tcDe2, 'AliquotaServicos');
    if (FProvedor in [proSP]) then
      NFSe.Servico.Valores.Aliquota       := (NFSe.Servico.Valores.Aliquota * 100);
    NFSe.Servico.Valores.ValorIss         := Leitor.rCampo(tcDe2, 'ValorISS');

    // Tributos Federais - PIS, COFINS, INSS, IR e CSLL
    NFSe.Servico.Valores.ValorPis         := Leitor.rCampo(tcDe2, 'ValorPis');
    NFSe.Servico.Valores.ValorCofins      := Leitor.rCampo(tcDe2, 'ValorCofins');
    NFSe.Servico.Valores.ValorInss        := Leitor.rCampo(tcDe2, 'ValorInss');
    NFSe.Servico.Valores.ValorIr          := Leitor.rCampo(tcDe2, 'ValorIr');
    NFSe.Servico.Valores.ValorCsll        := Leitor.rCampo(tcDe2, 'ValorCsll');

    if (Leitor.rCampo(tcStr, 'ISSRetido') = 'false') then
    begin
      NFSe.Servico.Valores.IssRetido := stNormal;
//      valorIssRetido := 0.00;
    end
    else
    begin
      NFSe.Servico.Valores.IssRetido := stRetencao;
//      valorIssRetido := Leitor.rCampo(tcDe2, 'ValorISS');
    end;

    // Como o valor l�quido n�o esta no layout deve refazer o c�lculo
    (*
    NFSe.Servico.Valores.ValorLiquidoNfse := NFSe.Servico.Valores.ValorServicos - (NFSe.Servico.Valores.ValorPis +
                                             NFSe.Servico.Valores.ValorCofins +
                                             NFSe.Servico.Valores.ValorInss +
                                             NFSe.Servico.Valores.ValorIr +
                                             NFSe.Servico.Valores.ValorCsll +
                                             valorIssRetido);
    *)

    NFSe.Servico.Valores.ValorLiquidoNfse := NFSe.Servico.Valores.ValorServicos -
                                              (NFSe.Servico.Valores.ValorPis +
                                               NFSe.Servico.Valores.ValorCofins +
                                               NFSe.Servico.Valores.ValorInss +
                                               NFSe.Servico.Valores.ValorIr +
                                               NFSe.Servico.Valores.ValorCsll +
                                               FNfse.Servico.Valores.ValorDeducoes +
                                               FNfse.Servico.Valores.DescontoCondicionado+
                                               FNfse.Servico.Valores.DescontoIncondicionado+
                                               FNFSe.Servico.Valores.ValorIssRetido);



    NFSe.PrestadorServico.RazaoSocial   := Leitor.rCampo(tcStr, 'RazaoSocialPrestador');
    NFSe.PrestadorServico.Contato.Email := Leitor.rCampo(tcStr, 'EmailPrestador');

    NFSe.Tomador.RazaoSocial   := Leitor.rCampo(tcStr, 'RazaoSocialTomador');
    NFSe.Tomador.Contato.Email := Leitor.rCampo(tcStr, 'EmailTomador');

    if (Leitor.rExtrai(2, 'ChaveNFe') <> '') then
    begin
      NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoPrestador');
      NFSe.Numero            := Leitor.rCampo(tcStr, 'NumeroNFe');
      NFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'CodigoVerificacao');
    end;

    if (Leitor.rExtrai(2, 'ChaveRPS') <> '') then
    begin
      NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoPrestador');
      NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'NumeroRPS');
      NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'SerieRPS');
      NFSe.IdentificacaoRps.Tipo   := trRPS;
      if NFSe.InfID.ID = '' then
        NFSe.InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero) + NFSe.IdentificacaoRps.Serie;
    end;

    if (Leitor.rExtrai(2, 'CPFCNPJPrestador') <> '') then
      NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'CNPJ');

    if (Leitor.rExtrai(2, 'EnderecoPrestador') <> '') then
    begin
      with NFSe.PrestadorServico.Endereco do
      begin
        TipoLogradouro  := Leitor.rCampo(tcStr, 'TipoLogradouro');
        Endereco        := Leitor.rCampo(tcStr, 'Logradouro');
        Numero          := Leitor.rCampo(tcStr, 'NumeroEndereco');
        Complemento     := Leitor.rCampo(tcStr, 'ComplementoEndereco');
        Bairro          := Leitor.rCampo(tcStr, 'Bairro');
        CodigoMunicipio := Leitor.rCampo(tcStr, 'Cidade');
        UF              := Leitor.rCampo(tcStr, 'UF');
        CEP             := Leitor.rCampo(tcStr, 'CEP');
        xMunicipio      := CodCidadeToCidade(StrToIntDef(CodigoMunicipio, 0));
      end;
    end;

    with NFSe.Tomador do
    begin
      if (Leitor.rExtrai(2, 'CPFCNPJTomador') <> '') then
        IdentificacaoTomador.CpfCnpj := Leitor.rCampoCNPJCPF;

//      Contato.Email := Leitor.rCampo(tcStr, 'EmailTomador');

      if (Leitor.rExtrai(2, 'EnderecoTomador') <> '') then
      begin
        with Endereco do
        begin
          Endereco        := Leitor.rCampo(tcStr, 'Logradouro');
          Numero          := Leitor.rCampo(tcStr, 'NumeroEndereco');
          Complemento     := Leitor.rCampo(tcStr, 'ComplementoEndereco');
          Bairro          := Leitor.rCampo(tcStr, 'Bairro');
          CodigoMunicipio := Leitor.rCampo(tcStr, 'Cidade');
          UF              := Leitor.rCampo(tcStr, 'UF');
          CEP             := Leitor.rCampo(tcStr, 'CEP');
          xMunicipio      := CodCidadeToCidade(StrToIntDef(CodigoMunicipio, 0));
        end;
      end;
    end;

    Result := True;
  end;
end;

function TNFSeR.LerNFSe_IPM: Boolean;
var
  I: Integer;
  Ok: Boolean;
begin
  Leitor.Grupo := Leitor.Arquivo;
  VersaoXML    := '1';

  if( Leitor.rExtrai( 1, 'nfse' ) <> '' )then
  begin
    if( Leitor.rExtrai( 2, 'rps' ) <> '' )then
    begin
      NFSe.IdentificacaoRps.Numero := Leitor.rCampo( tcStr, 'nro_recibo_provisorio' );
      NFSe.IdentificacaoRps.Serie  := Leitor.rCampo( tcStr, 'serie_recibo_provisorio' );
      NFSe.DataEmissaoRps          := StrToDateTimeDef(
                                        VarToStr(Leitor.rCampo( tcStr, 'data_emissao_recibo_provisorio' )) + ' ' +
                                        VarToStr(Leitor.rCampo( tcStr, 'hora_emissao_recibo_provisorio' )), 0 );
    end;

    if( Leitor.rExtrai( 2, 'nf' ) <> '' )then
    begin
      NFSe.Numero := Leitor.rCampo( tcStr, 'numero');
      NFSe.CodigoVerificacao := Leitor.rCampo( tcStr, 'codigo_autenticidade');

      // campos presentes ao baixar do site da prefeitura
      if (NFSe.Numero = '') then 
      begin
        NFSe.Numero         := Leitor.rCampo( tcStr, 'numero_nfse');
        NFSe.SeriePrestacao := Leitor.rCampo( tcStr, 'serie_nfse');
        NFSe.DataEmissao    := StrToDateTimeDef(
                                 VarToStr(Leitor.rCampo( tcStr, 'data_nfse' )) + ' ' +
                                 VarToStr(Leitor.rCampo( tcStr, 'hora_nfse' )), 0 );
      end;

      if Leitor.rCampo( tcStr, 'situacao' ) = 'C' then
      begin
        NFSe.Status := srCancelado;
        NFSe.Cancelada := snSim;
      end
      else
      begin
        NFSe.Status := srNormal;
        NFSe.Cancelada := snNao;
      end;

      NFSe.Servico.Valores.ValorServicos          := Leitor.rCampo( tcDe2, 'valor_total' );
      NFSe.Servico.Valores.ValorLiquidoNfse       := Leitor.rCampo( tcDe2, 'valor_total' );
      NFSe.Servico.Valores.DescontoIncondicionado := Leitor.rCampo( tcDe2, 'valor_desconto' );
      NFSe.Servico.Valores.ValorIr                := Leitor.rCampo( tcDe2, 'valor_ir' );
      NFSe.Servico.Valores.ValorInss              := Leitor.rCampo( tcDe2, 'valor_inss' );
      NFSe.Servico.Valores.ValorCsll              := Leitor.rCampo( tcDe2, 'valor_contribuicao_social' );
      NFSe.Servico.Valores.ValorPis               := Leitor.rCampo( tcDe2, 'valor_pis' );
      NFSe.Servico.Valores.ValorCofins            := Leitor.rCampo( tcDe2, 'valor_cofins' );
      NFSe.OutrasInformacoes                      := Leitor.rCampo( tcStr, 'observacao' );
    end;

    if( Leitor.rExtrai( 2, 'prestador' ) <> '' )then
    begin
      NFSe.Prestador.Cnpj                               := Leitor.rCampo( tcStr, 'cpfcnpj' );
      NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo( tcStr, 'cpfcnpj' );
      NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := PadLeft(NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj, 14, '0');
      NFSe.PrestadorServico.Endereco.CodigoMunicipio    := Leitor.rCampo( tcStr, 'cidade' );
    end;

    if( Leitor.rExtrai( 2, 'tomador' ) <> '' )then
    begin
      NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo( tcStr, 'cpfcnpj' );

      if Leitor.rCampo( tcStr, 'tipo' ) = 'J' then
        NFSe.Tomador.IdentificacaoTomador.CpfCnpj := PadLeft(NFSe.Tomador.IdentificacaoTomador.CpfCnpj, 14, '0')
      else
        NFSe.Tomador.IdentificacaoTomador.CpfCnpj := PadLeft(NFSe.Tomador.IdentificacaoTomador.CpfCnpj, 11, '0');

      NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual := Leitor.rCampo( tcStr, 'ie' );

      NFSe.Tomador.RazaoSocial              := Leitor.rCampo( tcStr, 'nome_razao_social' );
      NFSe.Tomador.Endereco.Endereco        := Leitor.rCampo( tcStr, 'logradouro' );
      NFSe.Tomador.Endereco.Numero          := Leitor.rCampo( tcStr, 'numero_residencia' );
      NFSe.Tomador.Endereco.Complemento     := Leitor.rCampo( tcStr, 'complemento' );
      NFSe.Tomador.Endereco.Bairro          := Leitor.rCampo( tcStr, 'bairro' );
      NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo( tcStr, 'cidade' );
      NFSe.Tomador.Endereco.CEP             := Leitor.rCampo( tcStr, 'cep' );
      NFSe.Tomador.Contato.Email            := Leitor.rCampo( tcStr, 'email' );
      NFSe.Tomador.Contato.Telefone         := Leitor.rCampo( tcStr, 'ddd_fone_comercial' ) + Leitor.rCampo( tcStr, 'fone_comercial' );
    end;

    if( Leitor.rExtrai( 2, 'itens' ) <> '' )then
    begin
      I := 1;
      NFSe.Servico.Valores.ValorIssRetido := 0;
      NFSe.Servico.Valores.BaseCalculo    := 0;
      NFSe.Servico.Valores.ValorIss       := 0;

      while( Leitor.rExtrai( 3, 'lista', 'lista', i ) <> '' )do
      begin
        with NFSe.Servico.ItemServico.New do
        begin
          NFSe.NaturezaOperacao := StrToNaturezaOperacao(Ok, IntToStr(AnsiIndexStr(Leitor.rCampo(tcStr, 'tributa_municipio_prestador'), ['1', '0']) + 1));

          NFSe.Servico.CodigoMunicipio           := Leitor.rCampo(tcStr, 'codigo_local_prestacao_servico');
          NFSe.Servico.CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'situacao_tributaria');

          ItemListaServico := PadLeft(Leitor.rCampo(tcStr, 'codigo_item_lista_servico'), 4, '0');
          TipoUnidade      := StrToTUnidade(Ok, Leitor.rCampo(tcStr, 'unidade_codigo'));
          Quantidade       := Leitor.rCampo(tcDe3, 'unidade_quantidade');
          ValorUnitario    := Leitor.rCampo(tcDe2, 'unidade_valor_unitario');

          Descricao        := Leitor.rCampo(tcStr, 'descritivo');
          Aliquota         := Leitor.rCampo(tcDe2, 'aliquota_item_lista_servico');

          ValorServicos    := Leitor.rCampo(tcDe2, 'valor_tributavel');
          ValorDeducoes    := Leitor.rCampo(tcDe2, 'valor_deducao');
          BaseCalculo      := Leitor.rCampo(tcDe2, 'valor_tributavel');
          ValorIss         := BaseCalculo * Aliquota / 100;

          NFSe.Servico.Valores.ValorIssRetido := NFSe.Servico.Valores.ValorIssRetido + Leitor.rCampo(tcDe2, 'valor_issrf');
          NFSe.Servico.Valores.BaseCalculo    := NFSe.Servico.Valores.BaseCalculo + BaseCalculo;
          NFSe.Servico.Valores.ValorIss       := NFSe.Servico.Valores.ValorIss + ValorIss;
          NFSe.Servico.Valores.IssRetido      := StrToSituacaoTributaria(Ok, IntToStr(AnsiIndexStr(Leitor.rCampo(tcStr, 'situacao_tributaria'), ['1', '0', '2']) + 1));
        end;

        Inc(I);
      end;
    end;
  end;

  Result := True;
end;

function TNFSeR.LerNFSe_SigIss: Boolean;
begin
  Result := False;
  if (Leitor.rExtrai(1, 'DadosNota') <> '') then
  begin
    NFSe.dhRecebimento  := Now;
    NFSe.id_sis_legado  := Leitor.rCampo(tcInt, 'id_sis_legado');
    NFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'autenticidade');
    NFSe.Numero         := Leitor.rCampo(tcStr, 'nota');
    NFSe.DataEmissao    := Leitor.rCampo(tcDat, 'dt_conversao');
    NFSe.DataEmissaoRps := Leitor.rCampo(tcDat, 'emissao_rps');

    if (Leitor.rCampo(tcStr, 'StatusNFe') = 'Cancelada') then
    begin
      NFSe.Status    := srCancelado;
      NFSe.Cancelada := snSim;
    end
    else
    begin
      NFSe.Status    := srNormal;
      NFSe.Cancelada := snNao;
    end;

    if (Leitor.rCampo(tcStr, 'OpcaoSimples') = 'NAO') then
      NFSe.OptanteSimplesNacional := snNao
    else
      NFSe.OptanteSimplesNacional := snSim;

    NFSe.ValoresNfse.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'valor');
    NFSe.ValoresNfse.BaseCalculo      := Leitor.rCampo(tcDe2, 'valor');
    NFSe.ValoresNfse.Aliquota         := Leitor.rCampo(tcDe2, 'aliquota_atividade');
    NFSe.ValoresNfse.ValorIss         := Leitor.rCampo(tcDe2, 'iss');

    NFSe.Servico.ItemListaServico := Leitor.rCampo(tcStr, 'servico');
    NFSe.Servico.Discriminacao    := Leitor.rCampo(tcStr, 'descricao');

//    SetxItemListaServico;

    NFSe.Servico.Valores.ValorServicos    := Leitor.rCampo(tcDe2, 'valor');
    NFSe.Servico.Valores.BaseCalculo      := Leitor.rCampo(tcDe2, 'valor');
    NFSe.Servico.Valores.Aliquota         := Leitor.rCampo(tcDe2, 'aliquota_atividade');
    NFSe.Servico.Valores.ValorIss         := Leitor.rCampo(tcDe2, 'iss');

    //Segundo o Manual ISSRetido xsd:string Simples Valor retido.
    //Retorno do XML <ISSRetido xsi:type="xsd:string">N�O</ISSRetido>
    //S� posso crer que se tiver iss retido vai vir valor
    if (Leitor.rCampo(tcStr, 'ISSRetido') = 'NAO') then
       NFSe.Servico.Valores.IssRetido := stNormal
    else
    begin
      NFSe.Servico.Valores.IssRetido := stRetencao;
      try
        NFSe.Servico.Valores.ValorIssRetido := Leitor.rCampo(tcDe2, 'ISSRetido')
      except
        NFSe.Servico.Valores.ValorIssRetido := 0;
      end;
    end;

    NFSe.Servico.Valores.ValorLiquidoNfse := NFSe.Servico.Valores.ValorServicos -
                                              (NFSe.Servico.Valores.ValorPis +
                                               NFSe.Servico.Valores.ValorCofins +
                                               NFSe.Servico.Valores.ValorInss +
                                               NFSe.Servico.Valores.ValorIr +
                                               NFSe.Servico.Valores.ValorCsll +
                                               FNfse.Servico.Valores.ValorDeducoes +
                                               FNfse.Servico.Valores.DescontoCondicionado+
                                               FNfse.Servico.Valores.DescontoIncondicionado+
                                               FNFSe.Servico.Valores.ValorIssRetido);

    NFSe.PrestadorServico.RazaoSocial   := Leitor.rCampo(tcStr, 'prestador_razao');
    NFSe.PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'prestador_endereco');
    NFSe.PrestadorServico.Endereco.Numero := Leitor.rCampo(tcStr, 'prestador_numero');
    NFSe.PrestadorServico.Endereco.Complemento := Leitor.rCampo(tcStr, 'prestador_complemento');
    NFSe.PrestadorServico.Endereco.Bairro := Leitor.rCampo(tcStr, 'prestador_bairro');
    NFSe.PrestadorServico.Endereco.xMunicipio := Leitor.rCampo(tcStr, 'prestador_cidade');
    NFSe.PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'prestador_estado');
    NFSe.PrestadorServico.Endereco.CEP := Leitor.rCampo(tcStr, 'prestador_cep');
    NFSe.PrestadorServico.Contato.Email := Leitor.rCampo(tcStr, 'prestador_email');

    NFSe.Tomador.IdentificacaoTomador.CpfCnpj  := Leitor.rCampo(tcStr, 'cnpj_tomador');
    NFSe.Tomador.RazaoSocial   := Leitor.rCampo(tcStr, 'razao_tomador');
    NFSe.Tomador.Endereco.Endereco := Leitor.rCampo(tcStr, 'endereco_tomador');
    NFSe.Tomador.Endereco.Numero := Leitor.rCampo(tcStr, 'numero_tomador');
    NFSe.Tomador.Endereco.Complemento := Leitor.rCampo(tcStr, 'complemento_tomador');
    NFSe.Tomador.Endereco.Bairro := Leitor.rCampo(tcStr, 'bairro_tomador');
    NFSe.Tomador.Endereco.xMunicipio := Leitor.rCampo(tcStr, 'cidade_tomador');
    NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'estado_tomador');
    NFSe.Tomador.Endereco.CEP := Leitor.rCampo(tcStr, 'cep_tomador');
    NFSe.Tomador.Contato.Email := Leitor.rCampo(tcStr, 'email_tomador');

    NFSe.Link := Leitor.rCampo(tcStr, 'LinkImpressao');
    Result := True;
  end;
end;

function TNFSeR.LerNFSe_Elotech: Boolean;
var
  bOk :Boolean;
//  valorIssRetido: Double;
begin
  Result := False;

  if (Leitor.rExtrai(1, 'NFe') <> '') or (Leitor.rExtrai(1, 'CompNfse') <> '') then
  begin
    NFSe.dhRecebimento  := Now;
    NFSe.DataEmissao    := Leitor.rCampo(tcDat, 'DataEmissao');

    if (Leitor.rCampo(tcStr, 'StatusNFe') = 'C') then
    begin
      NFSe.Status    := srCancelado;
      NFSe.Cancelada := snSim;
    end
    else
    begin
      NFSe.Status    := srNormal;
      NFSe.Cancelada := snNao;
    end;

    NFSe.TipoTributacaoRPS := StrToTTributacaoRPS(bOk, Leitor.rCampo(tcStr, 'TributacaoNFe'));

    if (Leitor.rCampo(tcStr, 'OpcaoSimples') = '0') then // ver pag do manual de integra�ao...
      NFSe.OptanteSimplesNacional := snNao
    else
      NFSe.OptanteSimplesNacional := snSim;

    NFSe.ValoresNfse.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.ValoresNfse.BaseCalculo      := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.ValoresNfse.Aliquota         := Leitor.rCampo(tcDe2, 'AliquotaServicos');
    NFSe.ValoresNfse.ValorIss         := Leitor.rCampo(tcDe2, 'ValorISS');

    NFSe.Servico.ItemListaServico := Leitor.rCampo(tcStr, 'CodigoServico');
    NFSe.Servico.Discriminacao    := Leitor.rCampo(tcStr, 'Discriminacao');

    SetxItemListaServico;

    //NFSe.Servico.Valores.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.Servico.Valores.ValorServicos    := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.Servico.Valores.BaseCalculo      := Leitor.rCampo(tcDe2, 'ValorServicos');
    NFSe.Servico.Valores.Aliquota         := Leitor.rCampo(tcDe2, 'AliquotaServicos');
    NFSe.Servico.Valores.ValorIss         := Leitor.rCampo(tcDe2, 'ValorISS');

    // Tributos Federais - PIS, COFINS, INSS, IR e CSLL
    NFSe.Servico.Valores.ValorPis         := Leitor.rCampo(tcDe2, 'ValorPis');
    NFSe.Servico.Valores.ValorCofins      := Leitor.rCampo(tcDe2, 'ValorCofins');
    NFSe.Servico.Valores.ValorInss        := Leitor.rCampo(tcDe2, 'ValorInss');
    NFSe.Servico.Valores.ValorIr          := Leitor.rCampo(tcDe2, 'ValorIr');
    NFSe.Servico.Valores.ValorCsll        := Leitor.rCampo(tcDe2, 'ValorCsll');

    if (Leitor.rCampo(tcStr, 'ISSRetido') = 'false') then
    begin
      NFSe.Servico.Valores.IssRetido := stNormal;
//      valorIssRetido := 0.00;
    end
    else
    begin
      NFSe.Servico.Valores.IssRetido := stRetencao;
//      valorIssRetido := Leitor.rCampo(tcDe2, 'ValorISS');
    end;

    NFSe.Servico.Valores.ValorLiquidoNfse := NFSe.Servico.Valores.ValorServicos -
                                              (NFSe.Servico.Valores.ValorPis +
                                               NFSe.Servico.Valores.ValorCofins +
                                               NFSe.Servico.Valores.ValorInss +
                                               NFSe.Servico.Valores.ValorIr +
                                               NFSe.Servico.Valores.ValorCsll +
                                               FNfse.Servico.Valores.ValorDeducoes +
                                               FNfse.Servico.Valores.DescontoCondicionado+
                                               FNfse.Servico.Valores.DescontoIncondicionado+
                                               FNFSe.Servico.Valores.ValorIssRetido);

    NFSe.PrestadorServico.Contato.Email := Leitor.rCampo(tcStr, 'EmailPrestador');
    NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'TelefonePrestador');

    NFSe.Tomador.RazaoSocial   := Leitor.rCampo(tcStr, 'RazaoSocialTomador');
    NFSe.Tomador.Contato.Email := Leitor.rCampo(tcStr, 'EmailTomador');
    NFSe.Tomador.Contato.Telefone := Leitor.rCampo(tcStr, 'TelefoneTomador');

    if (Leitor.rExtrai(2, 'ChaveNFe') <> '') then
    begin

      NFSe.Numero            := Leitor.rCampo(tcStr, 'NumeroNFe');
      NFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'CodigoVerificacao');
    end;

    if (Leitor.rExtrai(2, 'ChaveRPS') <> '') then
    begin
      NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoPrestador');
      NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'NumeroRPS');
      NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'SerieRPS');
      NFSe.IdentificacaoRps.Tipo   := trRPS;
      if NFSe.InfID.ID = '' then
        NFSe.InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero) + NFSe.IdentificacaoRps.Serie;
    end;

    if (Leitor.rExtrai(2, 'IdentificacaoPrestador') <> '') then
    begin
      NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'CNPJ');
      NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
    end;
    if (Leitor.rExtrai(2, 'DadosPrestador') <> '') then
    begin
      NFSe.PrestadorServico.RazaoSocial   := Leitor.rCampo(tcStr, 'RazaoSocial');
      with NFSe.PrestadorServico.Endereco do
      begin
        Endereco        := Copy(Leitor.rCampo(tcStr, 'Endereco'), 11, 125);
        Numero          := Leitor.rCampo(tcStr, 'Numero');
        Bairro          := Leitor.rCampo(tcStr, 'Bairro');
        xMunicipio      := Leitor.rCampo(tcStr, 'CidadeNome');
        UF              := Leitor.rCampo(tcStr, 'UF');
        CEP             := Leitor.rCampo(tcStr, 'CEP');
      end;
    end;

    if (Leitor.rExtrai(2, 'IdentificacaoTomador') <> '') then
      NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'CNPJ');
    if (Leitor.rExtrai(2, 'Tomador') <> '') then
    begin
      NFSe.Tomador.RazaoSocial   := Leitor.rCampo(tcStr, 'RazaoSocial');
      with NFSe.Tomador.Endereco do
      begin
        Endereco        := Copy(Leitor.rCampo(tcStr, 'Endereco'), 11, 125);
        Numero          := Leitor.rCampo(tcStr, 'Numero');
        Bairro          := Leitor.rCampo(tcStr, 'Bairro');
        UF              := Leitor.rCampo(tcStr, 'UF');
        CEP             := Leitor.rCampo(tcStr, 'CEP');
        xMunicipio      := Leitor.rCampo(tcStr, 'CidadeNome');
        CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
      end;
    end;

    Result := True;
  end;
end;

function TNFSeR.LerNFSe_Infisc: Boolean;
begin
  Result := False;
  Leitor.Grupo := Leitor.Arquivo;

  if (Pos('<NFS-e>', Leitor.Arquivo) > 0) or (Pos('<infNFSe ', Leitor.Arquivo) > 0) then
  begin
    if VersaoNFSe = ve110 then
      Result := LerNFSe_Infisc_V11
    else
      Result := LerNFSe_Infisc_V10;
  end;
end;

function TNFSeR.LerNFSe_EL: Boolean;
var
  ok: Boolean;
  I: integer;
  AValorTotal: Double;
begin
  Result := False;
  Leitor.Grupo := Leitor.Arquivo;

  if (Pos('<notasFiscais>', Leitor.Arquivo) > 0) or (Pos('<nfeRpsNotaFiscal>', Leitor.Arquivo) > 0) then
  begin
    NFSe.Numero                  := leitor.rCampo(tcStr, 'numero');
    NFSe.CodigoVerificacao       := leitor.rCampo(tcStr, 'idRps');
    NFSe.DataEmissao             := leitor.rCampo(tcDatHor, 'dataProcessamento');
    NFSe.IdentificacaoRps.Numero := leitor.rCampo(tcStr, 'rpsNumero');

    if Leitor.rExtrai(1, 'idNota') <> '' then
      NFSe.CodigoVerificacao := leitor.rCampo(tcStr, 'idNota');
      
    if (Leitor.rCampo(tcStr, 'situacao') <> 'A') then
    begin
      NFSe.Cancelada := snSim;
      NFSe.Status    := srCancelado;
    end;

    Result := True;
  end
  // loadfromfile de NF baixada manualmente
  else if (Pos('<Nfse>', Leitor.Arquivo) > 0) then
  begin
    NFSe.ChaveNFSe := Leitor.rCampo(tcStr, 'Id');

    NFSe.CodigoVerificacao := NFSe.ChaveNFSe;

    if (Leitor.rExtrai(2, 'IdentificacaoNfse') <> '') then
    begin
      NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'Numero');
      NFSe.InfID.ID := NFSe.IdentificacaoRps.Numero;
      NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'Serie');
      NFSe.IdentificacaoRps.Tipo   := StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));
    end;

    // Dados do prestador
    if (Leitor.rExtrai(2, 'DadosPrestador') <> '') then
    begin
      NFSe.NaturezaOperacao              := StrToNaturezaOperacao(ok, Leitor.rCampo(tcStr, 'NaturezaOperacao'));
      NFSe.RegimeEspecialTributacao      := StrToRegimeEspecialTributacao(ok, Leitor.rCampo(tcStr, 'RegimeEspecialTributacao'));
      NFSe.OptanteSimplesNacional        := StrToSimNao(ok, Leitor.rCampo(tcStr, 'OptanteSimplesNacional'));
      NFSe.IncentivadorCultural          := StrToSimNao(ok, Leitor.rCampo(tcStr, 'IncentivadorCultural'));
      NFSe.PrestadorServico.RazaoSocial  := leitor.rCampo(tcStr, 'RazaoSocial');
      NFSe.PrestadorServico.NomeFantasia := leitor.rCampo(tcStr, 'NomeFantasia');

      if (Leitor.rExtrai(3, 'IdentificacaoPrestador') <> '') then
      begin
        NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj               := Leitor.rCampo(tcStr, 'CpfCnpj');
        NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
        NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoEstadual  := Leitor.rCampo(tcStr, 'InscricaoEstadual');
      end;

      if (Leitor.rExtrai(3, 'Endereco') <> '') then
      begin
        with NFSe.PrestadorServico.Endereco do
        begin
          Endereco        := Leitor.rCampo(tcStr, 'Logradouro');
          Numero          := Leitor.rCampo(tcStr, 'LogradouroNumero');
          Complemento     := Leitor.rCampo(tcStr, 'LogradouroComplemento');
          Bairro          := Leitor.rCampo(tcStr, 'Bairro');
          xMunicipio      := Leitor.rCampo(tcStr, 'Municipio');
          CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
          UF              := Leitor.rCampo(tcStr, 'Uf');
          CEP             := Leitor.rCampo(tcStr, 'Cep');
        end;
      end;

      if (Leitor.rExtrai(3, 'Contato') <> '') then
      begin
        NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
        NFSe.PrestadorServico.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
      end;
    end; // fim Prestador


    // Dados do tomador
    if (Leitor.rExtrai(2, 'DadosTomador') <> '') then
    begin
      NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'RazaoSocial');

      if (Leitor.rExtrai(3, 'IdentificacaoTomador') <> '') then
      begin
        NFSe.Tomador.IdentificacaoTomador.CpfCnpj            := Leitor.rCampo(tcStr, 'CpfCnpj');
        NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
        NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual  := Leitor.rCampo(tcStr, 'InscricaoEstadual');
      end;

      if (Leitor.rExtrai(3, 'Endereco') <> '') then
      begin
        with NFSe.Tomador.Endereco do
        begin
          Endereco        := Leitor.rCampo(tcStr, 'Logradouro');
          Numero          := Leitor.rCampo(tcStr, 'LogradouroNumero');
          Complemento     := Leitor.rCampo(tcStr, 'LogradouroComplemento');
          Bairro          := Leitor.rCampo(tcStr, 'Bairro');
          CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
          xMunicipio      := Leitor.rCampo(tcStr, 'Municipio');
          UF              := Leitor.rCampo(tcStr, 'Uf');
          CEP             := Leitor.rCampo(tcStr, 'Cep');
        end;
      end;

      if (Leitor.rExtrai(3, 'Contato') <> '' ) then
      begin
        NFSe.Tomador.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
        NFSe.Tomador.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
      end;
    end; // fim Tomador

    // Dados dos Servi�os
    if (Leitor.rExtrai(2, 'Servicos') <> '') then
    begin
      // Total m�ximo de 12 servi�os na prefeitura
      I := 0;
      while (Leitor.rExtrai(3, 'Servicos', '', I+1) <> '') do
      begin
        NFSe.Servico.ItemListaServico := OnlyNumber(Leitor.rCampo(tcStr, 'CodigoServico116'));

        NFSe.Servico.ItemServico.New;
        NFSe.Servico.ItemServico[I].CodServ       := Leitor.rCampo(tcStr, 'CodigoServico116');
        NFSe.Servico.ItemServico[I].CodLCServ     := Leitor.rCampo(tcStr, 'CodigoServico116');
        NFSe.Servico.ItemServico[I].Quantidade    := Leitor.rCampo(tcDe4, 'Quantidade');
        NFSe.Servico.ItemServico[I].Unidade       := Leitor.rCampo(tcStr, 'Unidade');
        NFSe.Servico.ItemServico[I].ValorUnitario := Leitor.rCampo(tcDe2, 'ValorServico');
        NFSe.Servico.ItemServico[I].Descricao     := Leitor.rCampo(tcStr, 'Descricao');
        NFSe.Servico.ItemServico[I].Discriminacao := Leitor.rCampo(tcStr, 'Descricao');
        NFSe.Servico.ItemServico[I].Aliquota      := Leitor.rCampo(tcDe2, 'Aliquota');
        NFSe.Servico.ItemServico[I].ValorServicos := Leitor.rCampo(tcDe2, 'ValorServico');
        NFSe.Servico.ItemServico[I].ValorIss      := Leitor.rCampo(tcDe4, 'ValorIssqn');

        AValorTotal := NFSe.Servico.ItemServico[I].Quantidade *
                       NFSe.Servico.ItemServico[I].ValorUnitario;

        NFSe.Servico.ItemServico[I].ValorTotal := RoundTo(AValorTotal, - 2);

        Inc(I);
      end;
    end; // fim Servicos

    if (Leitor.rExtrai(2, 'Valores') <> '') then
    begin
      with NFSe.Servico.Valores do
      begin
        ValorServicos          := Leitor.rCampo(tcDe2, 'ValorServicos');
        ValorIss               := Leitor.rCampo(tcDe2, 'ValorIss');
        ValorLiquidoNfse       := Leitor.rCampo(tcDe2, 'ValorLiquidoNfse');
        ValorDeducoes          := Leitor.rCampo(tcDe2, 'ValorDeducoes');
        ValorPis               := Leitor.rCampo(tcDe2, 'ValorPis');
        ValorCofins            := Leitor.rCampo(tcDe2, 'ValorCofins');
        ValorInss              := Leitor.rCampo(tcDe2, 'ValorInss');
        ValorIr                := Leitor.rCampo(tcDe2, 'ValorIr');
        ValorCsll              := Leitor.rCampo(tcDe2, 'ValorCsll');
        OutrasRetencoes        := Leitor.rCampo(tcDe2, 'OutrasRetencoes');
        ValorIssRetido         := Leitor.rCampo(tcDe2, 'ValorIssRetido');
        OutrosDescontos        := Leitor.rCampo(tcDe2, 'OutrosDescontos');
        BaseCalculo            := ValorServicos - ValorDeducoes;
      end;
    end; // fim Valores

    // Outras Informa��es
    if (Leitor.rExtrai(2, 'Observacao') <> '') then
    begin
      NFSe.OutrasInformacoes := Leitor.rCampo(tcStr, 'Observacao');
    end;
                                 
    NFSe.Link := NFSe.ChaveNFSe; //ACBrNFSe1.LinkNFSe(StrToIntDef(NFSe.Numero, 0), NFSe.CodigoVerificacao, NFSe.ChaveNFSe);

    Result := True;
  end;
end;

function TNFSeR.LerNFSe_Equiplano: Boolean;
begin
  Result := False;
  Leitor.Grupo := Leitor.Arquivo;

  if (Pos('<nfse>', Leitor.Arquivo) > 0) or (Pos('<nfs', Leitor.Arquivo) > 0) then
  begin
    if (Pos('<nfse>', Leitor.Arquivo) > 0) then
    begin
      NFSe.Numero                  := leitor.rCampo(tcStr, 'nrNfse');
      NFSe.CodigoVerificacao       := leitor.rCampo(tcStr, 'cdAutenticacao');
      NFSe.DataEmissao             := leitor.rCampo(tcDatHor, 'dtEmissaoNfs');
      NFSe.IdentificacaoRps.Numero := leitor.rCampo(tcStr, 'nrRps');

      if (Leitor.rExtrai(1, 'cancelamento') <> '') or
         (Leitor.rExtrai(3, 'cancelamento') <> '') then
      begin
        NFSe.NfseCancelamento.DataHora := Leitor.rCampo(tcDatHor, 'dtCancelamento');
        NFSe.MotivoCancelamento        := Leitor.rCampo(tcStr, 'dsCancelamento');
        NFSe.Status := srCancelado;
        NFSe.Cancelada := snSim;
      end;
    end
    else
    begin
      NFSe.Numero := Leitor.rCampo(tcStr, 'nrNfs');
      NFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'cdAutenticacao');
      NFSe.DataEmissao := Leitor.rCampo(tcDatHor, 'dtEmissaoNfs');
      NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'nrRps');
      NFSe.PrestadorServico.RazaoSocial := Leitor.rCampo(tcStr, 'nmPrestador');
      NFSe.PrestadorServico.NomeFantasia := Leitor.rCampo(tcStr, 'nmPrestador');
      NFSe.PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'dsEndereco');
      NFSe.PrestadorServico.Endereco.Numero := Leitor.rCampo(tcStr, 'nrEndereco');
      NFSe.PrestadorServico.Endereco.Bairro := Leitor.rCampo(tcStr, 'nmBairro');
      NFSe.PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'nmUf');
      NFSe.PrestadorServico.Endereco.CEP := Leitor.rCampo(tcStr, 'nrCEP');
      NFSe.PrestadorServico.Endereco.xMunicipio := Leitor.rCampo(tcStr, 'nmCidade');
      NFSe.PrestadorServico.Endereco.xPais := Leitor.rCampo(tcStr, 'nmPais');
      NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'nrDocumento');
      NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'nrInscricaoMunicipal');
      NFSe.Servico.Discriminacao := Leitor.rCampo(tcStr, 'dsDiscriminacaoServico');
      NFSe.Servico.Valores.ValorServicos := Leitor.rCampo(tcDe2, 'vlServico');
      NFSe.Servico.Valores.Aliquota := Leitor.rCampo(tcDe2, 'vlAliquota');
      NFSe.Servico.Valores.ValorISS := Leitor.rCampo(tcDe2, 'vlImposto');
      NFSe.Servico.Valores.BaseCalculo := Leitor.rCampo(tcDe2, 'vlBaseCalculo');

      if Leitor.rCampo(tcStr, 'isIssRetido') = 'Sim' then
        NFSe.Servico.Valores.ValorISSRetido := Leitor.rCampo(tcDe2, 'vlImposto');

      NFSe.Servico.Valores.ValorPIS := Leitor.rCampo(tcDe2, 'vlPis');
      NFSe.Servico.Valores.ValorCOFINS := Leitor.rCampo(tcDe2, 'vlCofins');
      NFSe.Servico.Valores.ValorIr := Leitor.rCampo(tcDe2, 'vlAliquotaIrpj');
      NFSe.Servico.Valores.ValorCSLL := Leitor.rCampo(tcDe2, 'vlCsll');
      NFSe.Servico.Valores.ValorINSS := Leitor.rCampo(tcDe2, 'vlInss');

      if Leitor.rExtrai(3, 'cancelamento') <> '' then
      begin
        NFSe.NfseCancelamento.DataHora := Leitor.rCampo(tcDatHor, 'dtCancelamento');
        NFSe.MotivoCancelamento := Leitor.rCampo(tcStr, 'dsCancelamento');
        NFSe.Status := srCancelado;
      end;
    end;

    if (Leitor.rExtrai(1, 'tomadorServico') <> '') then
    begin
      NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'nmTomador');
      NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'nrDocumento');
      NFSe.Tomador.Endereco.Endereco := Leitor.rCampo(tcStr, 'dsEndereco');
      NFSe.Tomador.Endereco.Numero := Leitor.rCampo(tcStr, 'nrEndereco');
      NFSe.Tomador.Endereco.xPais := Leitor.rCampo(tcStr, 'nmPais');
      NFSe.Tomador.Endereco.xMunicipio := Leitor.rCampo(tcStr, 'nmCidade');
      NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'cdIbge');
      NFSe.Tomador.Endereco.Bairro := Leitor.rCampo(tcStr, 'nmBairro');
      NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'nmUf');
      NFSe.Tomador.Endereco.CEP := Leitor.rCampo(tcStr, 'nrCep');
    end;

    Result := True;
  end;
end;

function TNFSeR.LerRps_EL: Boolean;
var
 ok  : Boolean;
  I: Integer;
  AValorTotal: Double;
begin
  if (Leitor.rExtrai(1, 'Rps') <> '') then
  begin
    NFSe.InfID.ID    := Leitor.rCampo(tcStr, 'Id');
    NFSe.DataEmissao := Leitor.rCampo(tcDatHor, 'DataEmissao');
    NFSe.Status      := StrToStatusRPS(ok, Leitor.rCampo(tcStr, 'Status'));

    if (Leitor.rExtrai(2, 'IdentificacaoRps') <> '') then
    begin
      NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'Numero');
      NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'Serie');
      NFSe.IdentificacaoRps.Tipo   := StrToTipoRPS(ok, Leitor.rCampo(tcStr, 'Tipo'));
    end;

    // Dados do prestador
    if (Leitor.rExtrai(2, 'DadosPrestador') <> '') then
    begin
      NFSe.NaturezaOperacao              := StrToNaturezaOperacao(ok, Leitor.rCampo(tcStr, 'NaturezaOperacao'));
      NFSe.RegimeEspecialTributacao      := StrToRegimeEspecialTributacao(ok, Leitor.rCampo(tcStr, 'RegimeEspecialTributacao'));
      NFSe.OptanteSimplesNacional        := StrToSimNao(ok, Leitor.rCampo(tcStr, 'OptanteSimplesNacional'));
      NFSe.IncentivadorCultural          := StrToSimNao(ok, Leitor.rCampo(tcStr, 'IncentivadorCultural'));
      NFSe.PrestadorServico.RazaoSocial  := leitor.rCampo(tcStr, 'RazaoSocial');
      NFSe.PrestadorServico.NomeFantasia := leitor.rCampo(tcStr, 'NomeFantasia');

      if (Leitor.rExtrai(3, 'IdentificacaoPrestador') <> '') then
      begin
        NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj               := Leitor.rCampo(tcStr, 'CpfCnpj');
        NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
        NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoEstadual  := Leitor.rCampo(tcStr, 'InscricaoEstadual');
      end;

      if (Leitor.rExtrai(3, 'Endereco') <> '') then
      begin
        with NFSe.PrestadorServico.Endereco do
        begin
          Endereco        := Leitor.rCampo(tcStr, 'Logradouro');
          Numero          := Leitor.rCampo(tcStr, 'LogradouroNumero');
          Complemento     := Leitor.rCampo(tcStr, 'LogradouroComplemento');
          Bairro          := Leitor.rCampo(tcStr, 'Bairro');
          xMunicipio      := Leitor.rCampo(tcStr, 'Municipio');
          CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
          UF              := Leitor.rCampo(tcStr, 'Uf');
          CEP             := Leitor.rCampo(tcStr, 'Cep');
        end;
      end;

      if (Leitor.rExtrai(3, 'Contato') <> '') then
      begin
        NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
        NFSe.PrestadorServico.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
      end;
    end; // fim Prestador

    // Dados do tomador
    if (Leitor.rExtrai(2, 'DadosTomador') <> '') then
    begin
      NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'RazaoSocial');

      if (Leitor.rExtrai(3, 'IdentificacaoTomador') <> '') then
      begin
        NFSe.Tomador.IdentificacaoTomador.CpfCnpj            := Leitor.rCampo(tcStr, 'CpfCnpj');
        NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipal');
        NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual  := Leitor.rCampo(tcStr, 'InscricaoEstadual');
      end;

      if (Leitor.rExtrai(3, 'Endereco') <> '') then
      begin
        with NFSe.Tomador.Endereco do
        begin
          Endereco        := Leitor.rCampo(tcStr, 'Logradouro');
          Numero          := Leitor.rCampo(tcStr, 'LogradouroNumero');
          Complemento     := Leitor.rCampo(tcStr, 'LogradouroComplemento');
          Bairro          := Leitor.rCampo(tcStr, 'Bairro');
          CodigoMunicipio := Leitor.rCampo(tcStr, 'CodigoMunicipio');
          xMunicipio      := Leitor.rCampo(tcStr, 'Municipio');
          UF              := Leitor.rCampo(tcStr, 'Uf');
          CEP             := Leitor.rCampo(tcStr, 'Cep');
        end;
      end;

      if (Leitor.rExtrai(3, 'Contato') <> '' ) then
      begin
        NFSe.Tomador.Contato.Telefone := Leitor.rCampo(tcStr, 'Telefone');
        NFSe.Tomador.Contato.Email    := Leitor.rCampo(tcStr, 'Email');
      end;
    end; // fim Tomador

    // Dados dos Servi�os
    if (Leitor.rExtrai(2, 'Servicos') <> '') then
    begin
      // Total m�ximo de 12 servi�os na prefeitura
      I := 0;
      while (Leitor.rExtrai(3, 'Servico', '', I+1) <> '') do
      begin
        NFSe.Servico.ItemListaServico := OnlyNumber(Leitor.rCampo(tcStr, 'CodigoServico116'));

        NFSe.Servico.ItemServico.New;
        NFSe.Servico.ItemServico[I].CodServ       := Leitor.rCampo(tcStr, 'CodigoServico116');
        NFSe.Servico.ItemServico[I].CodLCServ     := Leitor.rCampo(tcStr, 'CodigoServico116');
        NFSe.Servico.ItemServico[I].Quantidade    := Leitor.rCampo(tcDe4, 'Quantidade');
        NFSe.Servico.ItemServico[I].Unidade       := Leitor.rCampo(tcStr, 'Unidade');
        NFSe.Servico.ItemServico[I].ValorUnitario := Leitor.rCampo(tcDe2, 'ValorServico');
        NFSe.Servico.ItemServico[I].Descricao     := Leitor.rCampo(tcStr, 'Descricao');
        NFSe.Servico.ItemServico[I].Discriminacao := Leitor.rCampo(tcStr, 'Descricao');
        NFSe.Servico.ItemServico[I].Aliquota      := Leitor.rCampo(tcDe2, 'Aliquota');
        NFSe.Servico.ItemServico[I].ValorServicos := Leitor.rCampo(tcDe2, 'ValorServico');
        NFSe.Servico.ItemServico[I].ValorIss      := Leitor.rCampo(tcDe4, 'ValorIssqn');

        AValorTotal := NFSe.Servico.ItemServico[I].Quantidade *
                       NFSe.Servico.ItemServico[I].ValorUnitario;

        NFSe.Servico.ItemServico[I].ValorTotal := RoundTo(AValorTotal, - 2);

        Inc(I);
      end;
    end; // fim Servicos

    if (Leitor.rExtrai(2, 'Valores') <> '') then
    begin
      with NFSe.Servico.Valores do
      begin
        ValorServicos          := Leitor.rCampo(tcDe2, 'ValorServicos');
        ValorIss               := Leitor.rCampo(tcDe2, 'ValorIss');
        ValorLiquidoNfse       := Leitor.rCampo(tcDe2, 'ValorLiquidoNfse');
        ValorDeducoes          := Leitor.rCampo(tcDe2, 'ValorDeducoes');
        ValorPis               := Leitor.rCampo(tcDe2, 'ValorPis');
        ValorCofins            := Leitor.rCampo(tcDe2, 'ValorCofins');
        ValorInss              := Leitor.rCampo(tcDe2, 'ValorInss');
        ValorIr                := Leitor.rCampo(tcDe2, 'ValorIr');
        ValorCsll              := Leitor.rCampo(tcDe2, 'ValorCsll');
        OutrasRetencoes        := Leitor.rCampo(tcDe2, 'OutrasRetencoes');
        ValorIssRetido         := Leitor.rCampo(tcDe2, 'ValorIssRetido');
        OutrosDescontos        := Leitor.rCampo(tcDe2, 'OutrosDescontos');
        BaseCalculo            := ValorServicos - ValorDeducoes;
      end;
    end; // fim Valores

    // Outras Informa��es
    if (Leitor.rExtrai(2, 'Observacao') <> '') then
    begin
      NFSe.OutrasInformacoes := Leitor.rCampo(tcStr, 'Observacao');
    end;
  end; // fim Rps

  Result := True;
end;

function TNFSeR.LerNFSe_Governa: Boolean;
var
  i: integer;
begin
  NFSe.dhRecebimento                := StrToDateTime(formatdatetime ('dd/mm/yyyy',now));
  NFSe.Prestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'CodCadBic');
  NFSe.Prestador.ChaveAcesso        := Leitor.rCampo(tcStr, 'ChvAcs');
  NFSe.Numero                       := Leitor.rCampo(tcStr, 'NumNot');
  NFSe.IdentificacaoRps.Numero      := Leitor.rCampo(tcStr, 'NumRps');
  NFSe.CodigoVerificacao            := Leitor.rCampo(tcStr, 'CodVer');

  if (Leitor.rExtrai(1, 'Nfse') <> '') then
  begin
    with NFSe do
    begin
      Numero := Leitor.rCampo(tcStr, 'NumNot');
      NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'NumRps');
      NFSe.CodigoVerificacao       := Leitor.rCampo(tcStr, 'CodVer');
      PrestadorServico.RazaoSocial := Leitor.rCampo(tcStr, 'RzSocialPr');
      PrestadorServico.IdentificacaoPrestador.Cnpj               := Leitor.rCampo(tcStr, 'CNPJPr');
      PrestadorServico.IdentificacaoPrestador.InscricaoEstadual  := Leitor.rCampo(tcStr, 'IEPr');
      PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'CodCadBic');
      PrestadorServico.Endereco.Endereco    := Leitor.rCampo(tcStr, 'EndLogradouroPr');
      PrestadorServico.Endereco.Numero      :=  Leitor.rCampo(tcStr, 'EndNumeroPr');
      PrestadorServico.Endereco.Bairro      := Leitor.rCampo(tcStr, 'EndBairroPr');
      PrestadorServico.Endereco.Complemento := Leitor.rCampo(tcStr, 'EndComplPr');
      PrestadorServico.Endereco.xMunicipio  := Leitor.rCampo(tcStr, 'EndCidadePr');
      PrestadorServico.Endereco.CEP         := Leitor.rCampo(tcStr, 'EndCEPPr');
      PrestadorServico.Endereco.UF          := Leitor.rCampo(tcStr, 'EndUFPr');
      Servico.Valores.ValorServicos := Leitor.rCampo(tcStr, 'VlrUnt');
      Servico.Valores.ValorPis      := Leitor.rCampo(tcStr, 'VlrPIS');
      Servico.Valores.ValorCofins   := Leitor.rCampo(tcStr, 'VlrCofins');
      Servico.Valores.ValorInss     := Leitor.rCampo(tcStr, 'VlrINSS');
      Servico.Valores.ValorIr       := Leitor.rCampo(tcStr, 'VlrIR');
      DataEmissao := Leitor.rCampo(tcDat, 'DtemiNfse');
      Nfse.Tomador.RazaoSocial                            := Leitor.rCampo(tcStr, 'NomTmd');
      NFSe.Tomador.IdentificacaoTomador.CpfCnpj           := Leitor.rCampo(tcStr, 'NumDocTmd');
      NFSe.TipoRecolhimento                               := Leitor.rCampo(tcStr, 'TipRec');
      NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual := Leitor.rCampo(tcStr, 'InscricaoEstadual');
      Nfse.OutrasInformacoes := Leitor.rCampo(tcStr, 'Obs');
      with  Nfse.Tomador.Endereco do
      begin
        Endereco   := Leitor.rCampo(tcStr, 'DesEndTmd');
        Bairro     := Leitor.rCampo(tcStr, 'NomBaiTmd');
        xMunicipio := Leitor.rCampo(tcStr, 'NomCidTmd');
        UF         := Leitor.rCampo(tcStr, 'CodEstTmd');
        CEP        := Leitor.rCampo(tcStr, 'CEPTmd');
      end;

      Competencia := Leitor.rCampo(tcStr, 'DtemiNfse');
      Servico.CodigoCnae := Leitor.rCampo(tcStr, 'CodAti');
      Servico.Discriminacao := Leitor.rCampo(tcStr, 'DesSvc');
      Servico.Descricao := Leitor.rCampo(tcStr, 'DescricaoServ');

//    Itens do servi�o prestado
      I := 0;
      while (Leitor.rExtrai(1, 'ItemNfse', '', I+1) <> '') do
      begin
        NFSe.Servico.ItemServico.New;
        NFSe.Servico.ItemServico[I].Descricao := Leitor.rCampo(tcStr, 'DesSvc');
        NFSe.Servico.ItemServico[I].Quantidade := StrToFloat(Leitor.rCampo(tcStr, 'QdeSvc'));
        NFSe.Servico.ItemServico[I].ValorUnitario := StrToFloat(Leitor.rCampo(tcStr, 'VlrUnt'));
        NFSe.Servico.ItemServico[I].ValorTotal := StrToFloat(Leitor.rCampo(tcStr, 'QdeSvc')) * StrToFloat(Leitor.rCampo(tcStr, 'VlrUnt'));

        Inc(I);
      end;

      for i := 0 to Nfse.Servico.ItemServico.Count - 1 do
      begin
        Servico.Valores.ValorLiquidoNfse := Servico.Valores.ValorLiquidoNfse + NFse.Servico.ItemServico.Items[i].ValorTotal;
      end;
    end;
  end;

  Result := True;
end;

function TNFSeR.LerNFSe_CONAM: Boolean;
var
  i: Integer;
  bNota: Boolean;
  bRPS: Boolean;
  sDataTemp: String;
  ValorIssRet: Double;  //Edson
begin
  bRPS := False;
  bNota := False;

  if (Leitor.rExtrai(1, 'Reg20Item') <> '') then
    bRPS := True
  else
    if (Leitor.rExtrai(1, 'CompNfse') <> '') then
      bNota := True;

  if bNota or bRPS then
  begin
    with NFSe do
    begin
      Numero := Leitor.rCampo(tcStr, 'NumNf');
      SeriePrestacao := Leitor.rCampo(tcStr, 'SerNf');
      sDataTemp := Leitor.rCampo(tcStr, 'DtEmi');

      if sDataTemp = EmptyStr then
        sDataTemp := Leitor.rCampo(tcStr, 'DtEmiNf');

      if sDataTemp <> EmptyStr then
      begin
        DataEmissao := StrToDate(sDataTemp);
        Competencia := FormatDateTime('mm/yyyy', StrToDate(sDataTemp));
      end;

      sDataTemp := Leitor.rCampo(tcStr, 'DtEmiRps');
      DataEmissaoRps := StrToDate(sDataTemp);

      sDataTemp := Leitor.rCampo(tcStr, 'DtHrGerNf');
      dhRecebimento := StrToDateTimeDef(sDataTemp, Now);

      IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'NumRps');
      IdentificacaoRps.Serie:= Leitor.rCampo(tcStr, 'SerRps');
      CodigoVerificacao := Leitor.rCampo(tcStr, 'CodVernf');

      ValorIssRet := Leitor.rCampo(tcDe2, 'VlIssRet');  //Edson

      if Leitor.rCampo(tcStr, 'TipoTribPre') = 'SN' then
        OptanteSimplesNacional := snSim
      else
        OptanteSimplesNacional := snNao;

      sDataTemp := Leitor.rCampo(tcStr, 'DtAdeSN');
      if (sDataTemp <> EmptyStr) and (sDataTemp <> '/  /') then
        DataOptanteSimplesNacional := StrToDate(sDataTemp);

      PrestadorServico.RazaoSocial := Leitor.rCampo(tcStr, 'RazSocPre');
      PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'CpfCnpjPre');
      PrestadorServico.IdentificacaoPrestador.InscricaoEstadual := Leitor.rCampo(tcStr, 'IEPr');
      PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'CodCadBic');
      PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'LogPre');
      PrestadorServico.Endereco.Numero :=  Leitor.rCampo(tcStr, 'NumEndPre');
      PrestadorServico.Endereco.Bairro := Leitor.rCampo(tcStr, 'BairroPre');
      PrestadorServico.Endereco.Complemento := Leitor.rCampo(tcStr, 'ComplEndPre');
      PrestadorServico.Endereco.xMunicipio := Leitor.rCampo(tcStr, 'MunPre');
      PrestadorServico.Endereco.CEP := Leitor.rCampo(tcStr, 'CepPre');
      PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'SiglaUFPre');

      ValoresNfse.ValorLiquidoNfse := Leitor.rCampo(tcDe2, 'VlNFS');
      ValoresNfse.Aliquota := Leitor.rCampo(tcDe2, 'AlqIss');
      ValoresNfse.ValorIss := Leitor.rCampo(tcDe2, 'VlIss');
      ValoresNfse.BaseCalculo := Leitor.rCampo(tcDe2, 'VlBasCalc');

      Servico.Valores.BaseCalculo := Leitor.rCampo(tcDe2, 'VlBasCalc');
      Servico.Valores.ValorServicos := Leitor.rCampo(tcDe2, 'VlNFS');
      Servico.Valores.Aliquota := Leitor.rCampo(tcDe2, 'AlqIss');
      Servico.Valores.IssRetido := Leitor.rCampo(tcDe2, 'VlIssRet'); // Isto nao est� funcionando...
              //O conte�do de "Servico.Valores.IssRetido dever ser SIM ou NAO
              //O conte�do de "Sevrico.Valores.ValorIssRetido � o valor do ISS
      Servico.Valores.ValorDeducoes := Leitor.rCampo(tcDe2, 'VlDed');
      Servico.Valores.JustificativaDeducao := Leitor.rCampo(tcStr, 'DiscrDed');

      if ValorIssRet>0 then
      begin
          Servico.Valores.IssRetido      := stRetencao;   //Edson
          Servico.Valores.ValorIssRetido := ValorIssRet;  //Edson
          Servico.Valores.ValorIss       := 0;            //Edson
          Servico.Valores.ValorLiquidoNfse:= Servico.Valores.ValorServicos - ValorIssRet;   //Edson
          ValoresNfse.ValorLiquidoNfse    := Servico.Valores.ValorServicos - ValorIssRet;   //Edson
      end else
      begin
          Servico.Valores.IssRetido      := stNormal;    //Edson
          Servico.Valores.ValorIssRetido := 0;           //Edson
          Servico.Valores.ValorIss       := Leitor.rCampo(tcDe2, 'VlIss');    //Edson
          Servico.Valores.ValorLiquidoNfse:= Leitor.rCampo(tcDe2, 'VlNFS');   //Edson
          ValoresNfse.ValorLiquidoNfse    := Leitor.rCampo(tcDe2, 'VlNFS');   //Edson
      end;

      Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'RazSocTom');
      Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'CpfCnpjTom');
      with  Tomador.Endereco do
      begin
        Endereco := Leitor.rCampo(tcStr, 'LogTom');
        Numero := Leitor.rCampo(tcStr, 'NumEndTom');;
        Complemento := Leitor.rCampo(tcStr, 'ComplEndTom');
        Bairro := Leitor.rCampo(tcStr, 'BairroTom');
        xMunicipio := Leitor.rCampo(tcStr, 'MunTom');
        UF := Leitor.rCampo(tcStr, 'SiglaUFTom');
        CEP := Leitor.rCampo(tcStr, 'CepTom');
      end;

//      Servico.CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'CodSrv');
      Servico.ItemListaServico := Leitor.rCampo(tcStr, 'CodSrv');

      if TabServicosExt then
        Servico.xItemListaServico := ObterDescricaoServico(OnlyNumber(Servico.ItemListaServico))
      else
        Servico.xItemListaServico := CodigoToDesc(OnlyNumber(Servico.ItemListaServico));
      {
       todo: almp1
       deveria substrituir "\\" por "nova linha"
      }
      Servico.Discriminacao := Leitor.rCampo(tcStr, 'DiscrSrv');
      Situacao := Leitor.rCampo(tcStr, 'SitNf');
      MotivoCancelamento := Leitor.rCampo(tcStr, 'MotivoCncNf');

      //valores dos tributos
      if (Leitor.rExtrai(1, 'Reg30') <> '') then
      begin
        i := 1;
        while (Leitor.rExtrai(1, 'Reg30Item', '', i) <> '') do
        begin
          if Leitor.rCampo(tcStr, 'TributoSigla') = 'IR' then
          begin
            Servico.Valores.AliquotaIr := Leitor.rCampo(tcDe2, 'TributoAliquota');
            Servico.Valores.ValorIr := Leitor.rCampo(tcDe2, 'TributoValor');
          end;
          if Leitor.rCampo(tcStr, 'TributoSigla') = 'PIS' then
          begin
            Servico.Valores.AliquotaPis := Leitor.rCampo(tcDe2, 'TributoAliquota');
            Servico.Valores.ValorPis := Leitor.rCampo(tcDe2, 'TributoValor');
          end;
          if Leitor.rCampo(tcStr, 'TributoSigla') = 'COFINS' then
          begin
            Servico.Valores.AliquotaCofins := Leitor.rCampo(tcDe2, 'TributoAliquota');
            Servico.Valores.ValorCofins := Leitor.rCampo(tcDe2, 'TributoValor');
          end;
          if Leitor.rCampo(tcStr, 'TributoSigla') = 'CSLL' then
          begin
            Servico.Valores.AliquotaCsll := Leitor.rCampo(tcDe2, 'TributoAliquota');
            Servico.Valores.ValorCsll := Leitor.rCampo(tcDe2, 'TributoValor');
          end;
          if Leitor.rCampo(tcStr, 'TributoSigla') = 'INSS' then
          begin
            Servico.Valores.AliquotaInss := Leitor.rCampo(tcDe2, 'TributoAliquota');
            Servico.Valores.ValorInss := Leitor.rCampo(tcDe2, 'TributoValor');
          end;
          Inc(i);
        end;
      end;

      InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero) + NFSe.IdentificacaoRps.Serie;
    end;
  end;

  Result := True;
end;

function TNFSeR.LerNFSe_Infisc_V10: Boolean;
var
  ok: Boolean;
  dEmi: String;
  hEmi: String;
  dia, mes, ano, hora, minuto: Word;
  Item: Integer;
begin
  VersaoXML:= '1';

  if (Leitor.rExtrai(1, 'Id') <> '') then
  begin
    NFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'cNFS-e');
    NFSe.NaturezaOperacao  := StrToNaturezaOperacao(ok, Leitor.rCampo(tcStr, 'natOp'));
    NFSe.SeriePrestacao    := Leitor.rCampo(tcStr, 'serie');
    NFSe.Numero            := Leitor.rCampo(tcStr, 'nNFS-e');
    NFSe.Competencia       := Leitor.rCampo(tcStr, 'dEmi');

    dEmi := NFSe.Competencia;
    hEmi := Leitor.rCampo(tcStr, 'hEmi');

    ano := StrToInt( copy( dEmi, 1 , 4 ) );
    mes := strToInt( copy( dEmi, 6 , 2 ) );
    dia := strToInt( copy( dEmi, 9 , 2 ) );

    hora   := strToInt( Copy( hEmi , 0 , 2 ) );
    minuto := strToInt( copy( hEmi , 4 , 2 ) );

    Nfse.DataEmissao := EncodeDateTime( ano, mes, dia, hora, minuto, 0, 0);

    NFSe.Servico.CodigoMunicipio := Leitor.rCampo(tcStr, 'cMunFG');
    NFSe.ChaveNFSe               := Leitor.rCampo(tcStr, 'refNF');

    NFSe.Status      := StrToEnumerado(ok, Leitor.rCampo(tcStr, 'anulada'), ['N','S'], [srNormal, srCancelado]);
    NFSe.InfID.ID    := OnlyNumber(NFSe.CodigoVerificacao);

    NFSe.Servico.MunicipioIncidencia := StrToIntDef(NFSe.Servico.CodigoMunicipio, 0);
  end;

  if (Leitor.rExtrai(1, 'emit') <> '') then
  begin
    NFSe.Prestador.Cnpj := Leitor.rCampo(tcStr, 'CNPJ');
    NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := NFSe.Prestador.Cnpj;
    NFSe.PrestadorServico.RazaoSocial := Leitor.rCampo(tcStr, 'xNome');
    NFSe.Prestador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'IM');
    NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := NFSe.Prestador.InscricaoMunicipal;
    NFSe.PrestadorServico.NomeFantasia := Leitor.rCampo(tcStr, 'xFant');

    if (Leitor.rExtrai(2, 'end') <> '') then
    begin
      NFSe.PrestadorServico.Endereco.Endereco := Leitor.rCampo(tcStr, 'xLgr');
      NFSe.PrestadorServico.Endereco.Numero := Leitor.rCampo(tcStr, 'nro');
      NFSe.PrestadorServico.Endereco.Complemento := Leitor.rCampo(tcStr, 'xCpl');
      NFSe.PrestadorServico.Endereco.Bairro := Leitor.rCampo(tcStr, 'xBairro');
      NFSe.PrestadorServico.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'cMun');
      NFSe.PrestadorServico.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 0));
      NFSe.PrestadorServico.Endereco.UF := Leitor.rCampo(tcStr, 'UF');
      NFSe.PrestadorServico.Endereco.CEP := Leitor.rCampo(tcStr, 'CEP');
      NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'fone');
      NFSe.PrestadorServico.Contato.Email := Leitor.rCampo(tcStr, 'xEmail');
    end;

  end;

  if (Leitor.rExtrai(1, 'TomS') <> '') then
  begin
    NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampoCNPJCPF;
    NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'xNome');
    NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'IM');

    if (Leitor.rExtrai(2, 'ender') <> '') then
    begin
      NFSe.Tomador.Endereco.Endereco := Leitor.rCampo(tcStr, 'xLgr');
      NFSe.Tomador.Endereco.Numero := Leitor.rCampo(tcStr, 'nro');
      NFSe.Tomador.Endereco.Complemento := Leitor.rCampo(tcStr, 'xCpl');
      NFSe.Tomador.Endereco.Bairro := Leitor.rCampo(tcStr, 'xBairro');
      NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'cMun');
      NFSe.Tomador.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0));
      NFSe.Tomador.Endereco.UF := Leitor.rCampo(tcStr, 'UF');
      NFSe.Tomador.Endereco.CEP := Leitor.rCampo(tcStr, 'CEP');
      NFSe.Tomador.Contato.Telefone := Leitor.rCampo(tcStr, 'fone');
      NFSe.Tomador.Contato.Email := Leitor.rCampo(tcStr, 'xEmail');
    end;

  end;

  // Detalhes dos servi�os
  Item := 0;
  while (Leitor.rExtrai(1, 'det', '', Item + 1) <> '') do
  begin

    if Leitor.rExtrai(2, 'serv') <> '' then
    begin
      Nfse.Servico.ItemServico.New;
      Nfse.Servico.ItemServico[Item].Codigo        := Leitor.rCampo(tcStr, 'cServ');
      Nfse.Servico.ItemServico[Item].Descricao     := Leitor.rCampo(tcStr, 'xServ');
      Nfse.Servico.ItemServico[Item].Discriminacao := FNfse.Servico.ItemServico[Item].Codigo+' - '+FNfse.Servico.ItemServico[Item].Descricao;
      Nfse.Servico.ItemServico[Item].Quantidade    := Leitor.rCampo(tcDe4, 'qTrib');
      Nfse.Servico.ItemServico[Item].ValorUnitario := Leitor.rCampo(tcDe3, 'vUnit');
      Nfse.Servico.ItemServico[Item].ValorServicos := Leitor.rCampo(tcDe2, 'vServ');
      Nfse.Servico.ItemServico[Item].DescontoIncondicionado := Leitor.rCampo(tcDe2, 'vDesc');
      // ISSQN
      Nfse.Servico.ItemServico[Item].BaseCalculo := Leitor.rCampo(tcDe2, 'vBCISS');
      Nfse.Servico.ItemServico[Item].Aliquota    := Leitor.rCampo(tcDe2, 'pISS');
      Nfse.Servico.ItemServico[Item].ValorIss    := Leitor.rCampo(tcDe2, 'vISS');
      // Reten��es
      NFSe.Servico.ItemServico.Items[Item].ValorIr     := Leitor.rCampo(tcDe2, 'vRetIRF');
      NFSe.Servico.ItemServico.Items[Item].ValorPis    := Leitor.rCampo(tcDe2, 'vRetLei10833-PIS-PASEP');
      NFSe.Servico.ItemServico.Items[Item].ValorCofins := Leitor.rCampo(tcDe2, 'vRetLei10833-COFINS');
      NFSe.Servico.ItemServico.Items[Item].ValorCsll   := Leitor.rCampo(tcDe2, 'vRetLei10833-CSLL');
      NFSe.Servico.ItemServico.Items[Item].ValorInss   := Leitor.rCampo(tcDe2, 'vRetINSS');
    end;

    inc(Item);
  end;

  if (Leitor.rExtrai(1, 'total') <> '') then
  begin
    // Valores
    NFSe.Servico.Valores.ValorServicos          := Leitor.rCampo(tcDe2, 'vServ');
    NFSe.Servico.Valores.DescontoIncondicionado := Leitor.rCampo(tcDe2, 'vDesc');
    NFSe.Servico.Valores.ValorLiquidoNfse       := Leitor.rCampo(tcDe2, 'vtLiq');

    if (Leitor.rExtrai(2, 'fat') <> '') then
    begin
      // Fatura
    end;

    if (Leitor.rExtrai(2, 'ISS') <> '') then
    begin
      // ISSQN
      NFSe.Servico.Valores.BaseCalculo := Leitor.rCampo(tcDe2, 'vBCISS');
      NFSe.Servico.Valores.ValorIss    := Leitor.rCampo(tcDe2, 'vISS');
      // ISSQN Retido
      NFSe.Servico.Valores.ValorIssRetido := Leitor.rCampo(tcDe2, 'vSTISS');

      if NFSe.Servico.Valores.ValorIssRetido > 0 then
      begin
        NFSe.Servico.Valores.IssRetido   := stRetencao;
        NFSe.Servico.MunicipioIncidencia := StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio,0);
      end;

    end;

    (*
        // Reten��es
        NFSe.Servico.Valores.ValorIr     := Leitor.rCampo(tcDe2, 'vRetIRF');
        NFSe.Servico.Valores.ValorPis    := Leitor.rCampo(tcDe2, 'vRetLei10833-PIS-PASEP');
        NFSe.Servico.Valores.ValorCofins := Leitor.rCampo(tcDe2, 'vRetLei10833-COFINS');
        NFSe.Servico.Valores.ValorCsll   := Leitor.rCampo(tcDe2, 'vRetLei10833-CSLL');
        NFSe.Servico.Valores.ValorInss   := Leitor.rCampo(tcDe2, 'vRetINSS');
    *)

  end;

  if (Leitor.rExtrai(1, 'cobr') <> '') then
  begin
    // Cobran�a
  end;

  if (Leitor.rExtrai(1, 'Observacoes') <> '') then
  begin
    NFSe.OutrasInformacoes := Leitor.rCampo(tcStr, 'xInf');
  end;

  if (Leitor.rExtrai(1, 'reemb') <> '') then
  begin
    // reembolso
  end;

  if (Leitor.rExtrai(1, 'ISSST') <> '') then
  begin
    // ISS Substitui��o Tribut�ria
  end;

  (*
      // Lay-Out Infisc n�o possui campo espec�ficos
      NFSe.Servico.ItemListaServico := Leitor.rCampo(tcStr, 'infAdic');
  *)

  Result := True;
end;

function TNFSeR.LerNFSe_Infisc_V11: Boolean;
var
  ok: Boolean;
  dEmi: String;
  hEmi: String;
  dia, mes, ano, hora, minuto: Word;
  Item: Integer;
(*
  lIndex: Integer;
  lTextoAposInfAdic: String;
*)
begin
  VersaoXML:= '1.1';

  NFSe.Servico.CodigoMunicipio := Leitor.rCampo(tcStr, 'infAdicLT');

  if (Leitor.rExtrai(1, 'Id') <> '') then
  begin
    NFSe.Numero            := Leitor.rCampo(tcStr, 'nNFS-e');
    NFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'cNFS-e');
    NFSe.SeriePrestacao    := Leitor.rCampo(tcStr, 'serie');
    NFSe.Competencia       := Leitor.rCampo(tcStr, 'dEmi');
    NFSe.ModeloNFSe        := Leitor.rCampo(tcStr, 'mod');
    dEmi := NFSe.Competencia;
    hEmi := Leitor.rCampo(tcStr, 'hEmi');
    ano := StrToInt( copy( dEmi, 1 , 4 ) );
    mes := strToInt( copy( dEmi, 6 , 2 ) );
    dia := strToInt( copy( dEmi, 9 , 2 ) );
    hora   := strToInt( Copy( hEmi , 0 , 2 ) );
    minuto := strToInt( copy( hEmi , 4 , 2 ) );
    Nfse.DataEmissao := EncodeDateTime( ano, mes, dia, hora, minuto, 0, 0);
    NFSe.Status := StrToEnumerado(ok, Leitor.rCampo(tcStr, 'anulada'), ['N','S'], [srNormal, srCancelado]);
    NFSe.Cancelada := StrToSimNaoInFisc(ok, Leitor.rCampo(tcStr, 'cancelada')); {Jozimar}
    NFSe.MotivoCancelamento := Leitor.rCampo(tcStr, 'motCanc');                   {Jozimar}
    NFSe.InfID.ID := OnlyNumber(NFSe.CodigoVerificacao);
    NFSe.ChaveNFSe := Leitor.rCampo(tcStr, 'refNF');
    NFSe.Producao  := StrToSimNao(ok, Leitor.rCampo(tcStr, 'ambienteEmi'));
  end;

  if (Leitor.rExtrai(1, 'prest') <> '') then
  begin
    NFSe.Prestador.Cnpj                := Leitor.rCampo(tcStr, 'CNPJ');
    NFSe.Prestador.InscricaoEstadual   := Leitor.rCampo(tcStr, 'IE');
    NFSe.PrestadorServico.RazaoSocial  := Leitor.rCampo(tcStr, 'xNome');
    NFSe.PrestadorServico.NomeFantasia := Leitor.rCampo(tcStr, 'xFant');
    NFSe.Prestador.InscricaoMunicipal  := Leitor.rCampo(tcStr, 'IM');

    NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := NFSe.Prestador.Cnpj;
    NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoMunicipal := NFSe.Prestador.InscricaoMunicipal;
    NFSe.PrestadorServico.IdentificacaoPrestador.InscricaoEstadual := NFSe.Prestador.InscricaoEstadual;

    NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'fone');
    NFSe.PrestadorServico.Contato.Email    := Leitor.rCampo(tcStr, 'xEmail');

    // 1=Simples, 2=SIMEI, 3=Normal
    if Leitor.rCampo(tcStr, 'regimeTrib') = '1' then
       NFSe.RegimeEspecialTributacao := retSimplesNacional
    else
    if Leitor.rCampo(tcStr, 'regimeTrib') = '2' then
       NFSe.RegimeEspecialTributacao := retMicroempresarioEmpresaPP
    else
    if Leitor.rCampo(tcStr, 'regimeTrib') = '3' then
       NFSe.RegimeEspecialTributacao := retLucroReal;

    if (Leitor.rExtrai(2, 'end') <> '') then
    begin
      NFSe.PrestadorServico.Endereco.Endereco        := Leitor.rCampo(tcStr, 'xLgr');
      NFSe.PrestadorServico.Endereco.Numero          := Leitor.rCampo(tcStr, 'nro');
      NFSe.PrestadorServico.Endereco.Complemento     := Leitor.rCampo(tcStr, 'xCpl');
      NFSe.PrestadorServico.Endereco.Bairro          := Leitor.rCampo(tcStr, 'xBairro');
      NFSe.PrestadorServico.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'cMun');

      NFSe.PrestadorServico.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(NFSe.PrestadorServico.Endereco.CodigoMunicipio, 0));

      NFSe.PrestadorServico.Endereco.UF  := Leitor.rCampo(tcStr, 'UF');
      NFSe.PrestadorServico.Endereco.CEP := Leitor.rCampo(tcStr, 'CEP');
      NFSe.PrestadorServico.Endereco.CodigoPais := Leitor.rCampo(tcInt, 'cPais');
      NFSe.PrestadorServico.Endereco.xPais := Leitor.rCampo(tcStr, 'xPais');
    end;
  end;

  if (Leitor.rExtrai(1, 'TomS') <> '') then
  begin
    NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampoCNPJCPF;
    NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'xNome');

    NFSe.Tomador.Contato.Email := Leitor.rCampo(tcStr, 'xEmail');
    NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual := Leitor.rCampo(tcStr, 'IE');
    NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'IM');
    NFSe.Tomador.Contato.Telefone := Leitor.rCampo(tcStr, 'fone');

    if (Leitor.rExtrai(2, 'ender') <> '') then
    begin
      NFSe.Tomador.Endereco.Endereco        := Leitor.rCampo(tcStr, 'xLgr');
      NFSe.Tomador.Endereco.Numero          := Leitor.rCampo(tcStr, 'nro');
      NFSe.Tomador.Endereco.Complemento     := Leitor.rCampo(tcStr, 'xCpl');
      NFSe.Tomador.Endereco.Bairro          := Leitor.rCampo(tcStr, 'xBairro');
      NFSe.Tomador.Endereco.CodigoMunicipio := Leitor.rCampo(tcStr, 'cMun');
      NFSe.Tomador.Endereco.xMunicipio      := CodCidadeToCidade(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0));
      NFSe.Tomador.Endereco.UF              := Leitor.rCampo(tcStr, 'UF');
      NFSe.Tomador.Endereco.CEP             := Leitor.rCampo(tcStr, 'CEP');
      NFSe.Tomador.Endereco.CodigoPais      := Leitor.rCampo(tcInt, 'cPais');
      NFSe.Tomador.Endereco.xPais           := Leitor.rCampo(tcStr, 'xPais');
    end;
  end;

  Nfse.Servico.MunicipioIncidencia := 0;

  // Detalhes dos servi�os
  Item := 0;
  while (Leitor.rExtrai(1, 'det', '', Item + 1) <> '') do
  begin
    if Leitor.rExtrai(2, 'serv') <> '' then
    begin
      if Nfse.Servico.MunicipioIncidencia = 0 then
        Nfse.Servico.MunicipioIncidencia := Leitor.rCampo(tcStr, 'localTributacao');

      Nfse.Servico.ItemServico.New;
      Nfse.Servico.ItemServico[Item].codServ       := Leitor.rCampo(tcStr, 'cServ');
      Nfse.Servico.ItemServico[Item].CodLCServ     := Leitor.rCampo(tcStr, 'cLCServ');
      Nfse.Servico.ItemServico[Item].Descricao     := Leitor.rCampo(tcStr, 'xServ');
      Nfse.Servico.ItemServico[Item].Discriminacao := FNfse.Servico.ItemServico[Item].Codigo+' - '+FNfse.Servico.ItemServico[Item].Descricao;
      Nfse.Servico.ItemServico[Item].Quantidade    := Leitor.rCampo(tcDe4, 'qTrib');
      Nfse.Servico.ItemServico[Item].ValorUnitario := Leitor.rCampo(tcDe3, 'vUnit');
      Nfse.Servico.ItemServico[Item].ValorTotal    := Leitor.rCampo(tcDe3, 'vServ'); //Jozimar @@
      Nfse.Servico.ItemServico[Item].ValorServicos := Leitor.rCampo(tcDe2, 'vServ');
      Nfse.Servico.ItemServico[Item].DescontoIncondicionado := Leitor.rCampo(tcDe2, 'vDesc');
      // ISSQN
      Nfse.Servico.ItemServico[Item].BaseCalculo := Leitor.rCampo(tcDe2, 'vBCISS');
      Nfse.Servico.ItemServico[Item].Aliquota    := Leitor.rCampo(tcDe2, 'pISS');
      Nfse.Servico.ItemServico[Item].ValorIss    := Leitor.rCampo(tcDe2, 'vISS');
      // Reten��es
      NFSe.Servico.ItemServico[Item].ValorIr     := Leitor.rCampo(tcDe2, 'vRetIR');
      NFSe.Servico.ItemServico[Item].ValorPis    := Leitor.rCampo(tcDe2, 'vRetPISPASEP');
      NFSe.Servico.ItemServico[Item].ValorCofins := Leitor.rCampo(tcDe2, 'vRetCOFINS');
      NFSe.Servico.ItemServico[Item].ValorCsll   := Leitor.rCampo(tcDe2, 'vRetCSLL');
      NFSe.Servico.ItemServico[Item].ValorInss   := Leitor.rCampo(tcDe2, 'vRetINSS');
    end;
    if (Leitor.rExtrai(2, 'ISSST') <> '') then
    begin
      NFSe.Servico.ItemServico[Item].AlicotaISSST := Leitor.rCampo(tcDe2, 'pISSST');
      NFSe.Servico.ItemServico[Item].ValorISSST := Leitor.rCampo(tcDe2, 'vISSST');
    end;

    inc(Item);
  end;

  Item := 0;
  while (Leitor.rExtrai(1, 'despesas', '', Item + 1) <> '') do
  begin
    NFSe.Despesa.New;
    NFSe.Despesa.Items[Item].nItemDesp := Leitor.rCampo(tcStr, 'nItemDesp');
    NFSe.Despesa.Items[Item].xDesp := Leitor.rCampo(tcStr, 'xDesp');
    NFSe.Despesa.Items[Item].dDesp := Leitor.rCampo(tcDat, 'dDesp');
    NFSe.Despesa.Items[Item].vDesp := Leitor.rCampo(tcDe2, 'vDesp');

    inc(Item);
  end;

  if (Leitor.rExtrai(1, 'total') <> '') then
  begin
    NFSe.Servico.Valores.ValorServicos          := Leitor.rCampo(tcDe2, 'vServ');
    NFSe.Servico.Valores.DescontoIncondicionado := Leitor.rCampo(tcDe2, 'vDesc');
    NFSe.Servico.Valores.ValorLiquidoNfse       := Leitor.rCampo(tcDe2, 'vtLiq');

    NFSe.Servico.Valores.ValorDespesasNaoTributaveis := Leitor.rCampo(tcDe2, 'vtDespesas');

    if (Leitor.rExtrai(2, 'ISS') <> '') then
    begin
      NFSe.Servico.Valores.BaseCalculo := Leitor.rCampo(tcDe2, 'vBCISS');
      NFSe.Servico.Valores.ValorIss    := Leitor.rCampo(tcDe2, 'vISS');
      NFSe.Servico.Valores.ValorIssRetido := Leitor.rCampo(tcDe2, 'vSTISS');

      if NFSe.Servico.Valores.ValorIssRetido > 0 then
      begin
        NFSe.Servico.Valores.IssRetido   := stRetencao;
        //Dados est� sendo buscando na linha no inicio do metodo
        //NFSe.Servico.MunicipioIncidencia := StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0);
      end;
    end;

    if (Leitor.rExtrai(2, 'Ret') <> '') then
    begin
        // Reten��es
      NFSe.Servico.Valores.ValorIr     := Leitor.rCampo(tcDe2, 'vRetIR');
      NFSe.Servico.Valores.ValorPis    := Leitor.rCampo(tcDe2, 'vRetPISPASEP');
      NFSe.Servico.Valores.ValorCofins := Leitor.rCampo(tcDe2, 'vRetCOFINS');
      NFSe.Servico.Valores.ValorCsll   := Leitor.rCampo(tcDe2, 'vRetCSLL');
      NFSe.Servico.Valores.ValorInss   := Leitor.rCampo(tcDe2, 'vRetINSS');
    end;
  end;

  if (Leitor.rExtrai(1, 'transportadora') <> '') then
  begin
    NFSe.Transportadora.xNomeTrans := Leitor.rCampo(tcStr, 'xNomeTrans');
    NFSe.Transportadora.xCpfCnpjTrans := Leitor.rCampo(tcStr, 'xCpfCnpjTrans');
    NFSe.Transportadora.xInscEstTrans := Leitor.rCampo(tcStr, 'xInscEstTrans');
    NFSe.Transportadora.xPlacaTrans := Leitor.rCampo(tcStr, 'xPlacaTrans');
    NFSe.Transportadora.xEndTrans := Leitor.rCampo(tcStr, 'xEndTrans');
    NFSe.Transportadora.cMunTrans := Leitor.rCampo(tcStr, 'cMunTrans');
    NFSe.Transportadora.xMunTrans := Leitor.rCampo(tcStr, 'xMunTrans');
    NFSe.Transportadora.xUFTrans := Leitor.rCampo(tcStr, 'xUfTrans');
    NFSe.Transportadora.cPaisTrans := Leitor.rCampo(tcStr, 'cPaisTrans');
    NFSe.Transportadora.vTipoFreteTrans := TnfseFrete(Leitor.rCampo(tcStr, 'vTipoFreteTrans'));
  end;

  if (Leitor.rExtrai(1, 'faturas') <> '') then
  begin
    Item := 0;
    while (Leitor.rExtrai(2, 'fat', '', Item + 1) <> '') do
    begin
      Nfse.CondicaoPagamento.Parcelas.New;
      Nfse.CondicaoPagamento.Parcelas[Item].Parcela        := Leitor.rCampo(tcStr, 'nFat');
      Nfse.CondicaoPagamento.Parcelas[Item].DataVencimento := Leitor.rCampo(tcDat, 'dVenc');
      Nfse.CondicaoPagamento.Parcelas[Item].Valor          := Leitor.rCampo(tcDe2, 'vFat');

      inc(Item);
    end;
  end;

  Item := 0;
  NFSe.OutrasInformacoes := '';
  while (Leitor.rExtrai(1, 'infAdic', '', Item + 1) <> '') do
  begin
    NFSe.OutrasInformacoes := NFSe.OutrasInformacoes + Leitor.rCampo(tcStr, 'infAdic');
    inc(Item);
  end;
  Result := True;
end;

function TNFSeR.LerRPS_Siat: Boolean; 
var
  item: Integer;
  ok  : Boolean;
  sOperacao, sTributacao: String;
begin
  VersaoNFSe := ve100;

  if (Leitor.rExtrai(1, 'Cabecalho') <> '') then
  begin
   	NFSe.PrestadorServico.IdentificacaoPrestador.Cnpj := Leitor.rCampo(tcStr, 'CPFCNPJRemetente');
   	NFSe.Prestador.Cnpj                               := Leitor.rCampo(tcStr, 'CPFCNPJRemetente');
   	NFSe.PrestadorServico.RazaoSocial                 := Leitor.rCampo(tcStr, 'RazaoSocialRemetente');
   	NFSe.PrestadorServico.Endereco.CodigoMunicipio    := CodSiafiToCodCidade( Leitor.rCampo(tcStr, 'CodCidade') );
  end;

  if (Leitor.rExtrai(1, 'RPS') <> '') then
  begin
    NFSe.DataEmissaoRPS := Leitor.rCampo(tcDatHor, 'DataEmissaoRPS');
    NFSe.Status         := StrToEnumerado(ok, Leitor.rCampo(tcStr, 'Status'),['N','C'],[srNormal, srCancelado]);

    NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'NumeroRPS');
    NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'SerieRPS');
    NFSe.IdentificacaoRps.Tipo   := trRPS;
    NFSe.InfID.ID                := OnlyNumber(NFSe.IdentificacaoRps.Numero);
    NFSe.SeriePrestacao          := Leitor.rCampo(tcStr, 'SeriePrestacao');

   	NFSe.Prestador.InscricaoMunicipal      := Leitor.rCampo(tcStr, 'InscricaoMunicipalPrestador');
    NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'DDDPrestador') + Leitor.rCampo(tcStr, 'TelefonePrestador');

   	NFSe.Tomador.RazaoSocial              := Leitor.rCampo(tcStr, 'RazaoSocialTomador');
    NFSe.Tomador.Endereco.TipoLogradouro  := Leitor.rCampo(tcStr, 'TipoLogradouroTomador');
    NFSe.Tomador.Endereco.Endereco        := Leitor.rCampo(tcStr, 'LogradouroTomador');
    NFSe.Tomador.Endereco.Numero          := Leitor.rCampo(tcStr, 'NumeroEnderecoTomador');
    NFSe.Tomador.Endereco.Complemento     := Leitor.rCampo(tcStr, 'ComplementoEnderecoTomador');
    NFSe.Tomador.Endereco.TipoBairro      := Leitor.rCampo(tcStr, 'TipoBairroTomador');
    NFSe.Tomador.Endereco.Bairro          := Leitor.rCampo(tcStr, 'BairroTomador');
    NFSe.Tomador.Endereco.CEP             := Leitor.rCampo(tcStr, 'CEPTomador');
   	NFSe.Tomador.Endereco.CodigoMunicipio := CodSiafiToCodCidade( Leitor.rCampo(tcStr, 'CidadeTomador'));
    NFSe.Tomador.Endereco.xMunicipio      := Leitor.rCampo(tcStr, 'CidadeTomadorDescricao');
   	NFSe.Tomador.Endereco.UF              := Leitor.rCampo(tcStr, 'Uf');
   	NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipalTomador');
   	NFSe.Tomador.IdentificacaoTomador.CpfCnpj := Leitor.rCampo(tcStr, 'CPFCNPJTomador');
    NFSe.Tomador.IdentificacaoTomador.DocTomadorEstrangeiro := Leitor.rCampo(tcStr, 'DocTomadorEstrangeiro');
    NFSe.Tomador.Contato.Email := Leitor.rCampo(tcStr, 'EmailTomador');
    NFSe.Tomador.Contato.Telefone          := Leitor.rCampo(tcStr, 'DDDTomador') + Leitor.rCampo(tcStr, 'TelefoneTomador');
    NFSe.Servico.CodigoCnae := Leitor.rCampo(tcStr, 'CodigoAtividade');
    NFSe.Servico.Valores.Aliquota := Leitor.rCampo(tcDe3, 'AliquotaAtividade');

    NFSe.Servico.Valores.IssRetido := StrToEnumerado( ok, Leitor.rCampo(tcStr, 'TipoRecolhimento'),
                                                      ['A','R'], [ stNormal, stRetencao]);

    NFSe.Servico.CodigoMunicipio := CodSiafiToCodCidade( Leitor.rCampo(tcStr, 'MunicipioPrestacao'));

    sOperacao   := AnsiUpperCase(Leitor.rCampo(tcStr, 'Operacao'));
    sTributacao := AnsiUpperCase(Leitor.rCampo(tcStr, 'Tributacao'));
    NFSe.TipoRecolhimento := AnsiUpperCase(Leitor.rCampo(tcStr, 'TipoRecolhimento'));

    if (sOperacao = 'A') or (sOperacao = 'B') then
    begin
      if (sOperacao = 'A') and (sTributacao = 'N') then
        NFSe.NaturezaOperacao := no7
      else
        if sTributacao = 'G' then
          NFSe.NaturezaOperacao := no2
        else
          if sTributacao = 'T' then
            NFSe.NaturezaOperacao := no1;
    end
    else
      if (sOperacao = 'C') and (sTributacao = 'C') then
      begin
        NFSe.NaturezaOperacao := no3;
      end
      else
        if (sOperacao = 'C') and (sTributacao = 'F') then
        begin
          NFSe.NaturezaOperacao := no4;
        end;

    NFSe.Servico.Operacao := StrToOperacao(Ok, sOperacao);
    NFSe.Servico.Tributacao := StrToTributacao(Ok, sTributacao);

    NFSe.NaturezaOperacao := StrToEnumerado( ok,sTributacao, ['T','K'], [ NFSe.NaturezaOperacao, no5 ]);

    NFSe.OptanteSimplesNacional := StrToEnumerado( ok,sTributacao, ['T','H'], [ snNao, snSim ]);

    NFSe.DeducaoMateriais := StrToEnumerado( ok,sOperacao, ['A','B'], [ snNao, snSim ]);

    NFse.RegimeEspecialTributacao := StrToEnumerado( ok,sTributacao, ['T','M'], [ retNenhum, retMicroempresarioIndividual ]);

    NFSe.Servico.Valores.ValorPis               := Leitor.rCampo(tcDe2, 'ValorPIS');
    NFSe.Servico.Valores.ValorCofins            := Leitor.rCampo(tcDe2, 'ValorCOFINS');
    NFSe.Servico.Valores.ValorInss              := Leitor.rCampo(tcDe2, 'ValorINSS');
    NFSe.Servico.Valores.ValorIr                := Leitor.rCampo(tcDe2, 'ValorIR');
    NFSe.Servico.Valores.ValorCsll              := Leitor.rCampo(tcDe2, 'ValorCSLL');
    NFSe.Servico.Valores.AliquotaPIS            := Leitor.rCampo(tcDe2, 'AliquotaPIS');
    NFSe.Servico.Valores.AliquotaCOFINS         := Leitor.rCampo(tcDe2, 'AliquotaCOFINS');
    NFSe.Servico.Valores.AliquotaINSS           := Leitor.rCampo(tcDe2, 'AliquotaINSS');
    NFSe.Servico.Valores.AliquotaIR             := Leitor.rCampo(tcDe2, 'AliquotaIR');
    NFSe.Servico.Valores.AliquotaCSLL           := Leitor.rCampo(tcDe2, 'AliquotaCSLL');

    NFSE.OutrasInformacoes := Leitor.rCampo(tcStr, 'DescricaoRPS');
    NFSE.MotivoCancelamento := Leitor.rCampo(tcStr, 'MotCancelamento');
    NFSE.IntermediarioServico.CpfCnpj := Leitor.rCampo(tcStr, 'CpfCnpjIntermediario');

    if (Leitor.rExtrai(1, 'Itens') <> '') then
    begin
      Item := 0;
      while (Leitor.rExtrai(1, 'Item', '', Item + 1) <> '') do
      begin
        FNfse.Servico.ItemServico.New;
        FNfse.Servico.ItemServico[Item].Descricao     := Leitor.rCampo(tcStr, 'DiscriminacaoServico');
        FNfse.Servico.ItemServico[Item].Quantidade    := Leitor.rCampo(tcDe2, 'Quantidade');
        FNfse.Servico.ItemServico[Item].ValorUnitario := Leitor.rCampo(tcDe2, 'ValorUnitario');
        FNfse.Servico.ItemServico[Item].ValorTotal    := Leitor.rCampo(tcDe2, 'ValorTotal');
        FNfse.Servico.ItemServico[Item].Tributavel    := StrToEnumerado( ok,Leitor.rCampo(tcStr, 'Tributavel'), ['N','S'], [ snNao, snSim ]);
        FNfse.Servico.Valores.ValorServicos           := (FNfse.Servico.Valores.ValorServicos + FNfse.Servico.ItemServico[Item].ValorTotal);
        inc(Item);
      end;
    end;

    FNFSe.Servico.Valores.ValorLiquidoNfse := (FNfse.Servico.Valores.ValorServicos -
                                              (FNfse.Servico.Valores.ValorDeducoes +
                                               FNfse.Servico.Valores.DescontoCondicionado+
                                               FNfse.Servico.Valores.DescontoIncondicionado+
                                               FNFSe.Servico.Valores.ValorIssRetido));
    FNfse.Servico.Valores.BaseCalculo      := NFSe.Servico.Valores.ValorLiquidoNfse;
  end; 

  Result := True;
end;

function TNFSeR.LerNFSe_Siat: Boolean;
var
  ok: Boolean;
  Item: Integer;
  sOperacao, sTributacao: String;
begin
  Leitor.Grupo := Leitor.Arquivo;

  if (Pos('<Notas>', Leitor.Arquivo) > 0) or
     (Pos('<Nota>', Leitor.Arquivo) > 0) or
     (Pos('<ConsultaNFSe>', Leitor.Arquivo) > 0) then
  begin
    VersaoNFSe := ve100;

    FNFSe.Numero := Leitor.rCampo(tcStr, 'NumeroNota');
    if (FNFSe.Numero = '') then
      FNFSe.Numero := Leitor.rCampo(tcStr, 'NumeroNFe');

    FNFSe.NumeroLote := Leitor.rCampo(tcStr, 'NumeroLote');
    FNFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'CodigoVerificacao');
    if FNFSe.CodigoVerificacao = '' then
      FNFSe.CodigoVerificacao := Leitor.rCampo(tcStr, 'CodigoVerificao');

    FNFSe.DataEmissaoRps := Leitor.rCampo(tcDatHor, 'DataEmissaoRPS');
    FNFSe.Competencia    := Copy(Leitor.rCampo(tcDat, 'DataEmissaoRPS'),7,4) + Copy(Leitor.rCampo(tcDat, 'DataEmissaoRPS'),4,2);
    FNFSe.DataEmissao    := Leitor.rCampo(tcDatHor, 'DataProcessamento');
    if (FNFSe.DataEmissao = 0) then
      FNFSe.DataEmissao  := FNFSe.DataEmissaoRps;

    FNFSe.Status := StrToEnumerado(ok, Leitor.rCampo(tcStr, 'SituacaoRPS'),['N','C'],[srNormal, srCancelado]);

    NFSe.IdentificacaoRps.Numero := Leitor.rCampo(tcStr, 'NumeroRPS');
    NFSe.IdentificacaoRps.Serie  := Leitor.rCampo(tcStr, 'SerieRPS');
    NFSe.IdentificacaoRps.Tipo   := trRPS;

    if NFSe.InfID.ID = '' then
      NFSe.InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero);

    NFSe.SeriePrestacao := Leitor.rCampo(tcStr, 'SeriePrestacao');

    NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := Leitor.rCampo(tcStr, 'InscricaoMunicipalTomador');
    NFSe.Tomador.IdentificacaoTomador.CpfCnpj            := Leitor.rCampo(tcStr, 'CPFCNPJTomador');

    NFSe.Tomador.RazaoSocial := Leitor.rCampo(tcStr, 'RazaoSocialTomador');

    NFSe.Tomador.Endereco.TipoLogradouro := Leitor.rCampo(tcStr, 'TipoLogradouroTomador');
    NFSe.Tomador.Endereco.Endereco       := Leitor.rCampo(tcStr, 'LogradouroTomador');
    NFSe.Tomador.Endereco.Numero         := Leitor.rCampo(tcStr, 'NumeroEnderecoTomador');
    NFSe.Tomador.Endereco.Complemento    := Leitor.rCampo(tcStr, 'ComplementoEnderecoTomador');
    NFSe.Tomador.Endereco.TipoBairro     := Leitor.rCampo(tcStr, 'TipoBairroTomador');
    NFSe.Tomador.Endereco.Bairro         := Leitor.rCampo(tcStr, 'BairroTomador');

    if (Leitor.rCampo(tcStr, 'CidadeTomador') <> '') then
    begin
      NFSe.Tomador.Endereco.CodigoMunicipio := CodSiafiToCodCidade( Leitor.rCampo(tcStr, 'CidadeTomador'));
      NFSe.Tomador.Endereco.xMunicipio      := CodCidadeToCidade( StrToInt(NFSe.Tomador.Endereco.CodigoMunicipio) );
      NFSe.Tomador.Endereco.UF              := CodigoParaUF( StrToInt(Copy(NFSe.Tomador.Endereco.CodigoMunicipio,1,2) ));
    end;

    NFSe.Tomador.Endereco.CEP  := Leitor.rCampo(tcStr, 'CEPTomador');
    NFSe.Tomador.Contato.Email := Leitor.rCampo(tcStr, 'EmailTomador');

    NFSe.Servico.CodigoCnae        := Leitor.rCampo(tcStr, 'CodigoAtividade');
    NFSe.Servico.Valores.Aliquota  := Leitor.rCampo(tcDe3, 'AliquotaAtividade');
    NFSe.Servico.Valores.IssRetido := StrToEnumerado( ok, Leitor.rCampo(tcStr, 'TipoRecolhimento'),
                                                     ['A','R'], [ stNormal, stRetencao{, stSubstituicao}]);

    if (Leitor.rCampo(tcStr, 'MunicipioPrestacao') <> '') then
      NFSe.Servico.CodigoMunicipio := CodSiafiToCodCidade( Leitor.rCampo(tcStr, 'MunicipioPrestacao'));

    sOperacao   := AnsiUpperCase(Leitor.rCampo(tcStr, 'Operacao'));
    sTributacao := AnsiUpperCase(Leitor.rCampo(tcStr, 'Tributacao'));
    NFSe.TipoRecolhimento := AnsiUpperCase(Leitor.rCampo(tcStr, 'TipoRecolhimento'));

    if (sOperacao <> '') then
    begin
      if (sOperacao = 'A') or (sOperacao = 'B') then
      begin
        if NFSe.Servico.CodigoMunicipio = NFSe.PrestadorServico.Endereco.CodigoMunicipio then
          NFSe.NaturezaOperacao := no1
        else
          NFSe.NaturezaOperacao := no2;
      end
      else if (sOperacao = 'C') and (sTributacao = 'C') then
           begin
             NFSe.NaturezaOperacao := no3;
           end
           else if (sOperacao = 'C') and (sTributacao = 'F') then
                begin
                  NFSe.NaturezaOperacao := no4;
                end
                else if (sOperacao = 'A') and (sTributacao = 'N') then
                     begin
                       NFSe.NaturezaOperacao := no7;
                     end;
    end;

    NFSe.Servico.Operacao := StrToOperacao(Ok, sOperacao);
    NFSe.Servico.Tributacao := StrToTributacao(Ok, sTributacao);

    NFSe.NaturezaOperacao := StrToEnumerado( ok,sTributacao, ['T','K'], [ NFSe.NaturezaOperacao, no5 ]);

    NFSe.OptanteSimplesNacional := StrToEnumerado( ok,sTributacao, ['T','H'], [ snNao, snSim ]);

    NFSe.DeducaoMateriais := StrToEnumerado( ok,sOperacao, ['A','B'], [ snNao, snSim ]);

    NFse.RegimeEspecialTributacao := StrToEnumerado( ok,sTributacao, ['T','M'], [ retNenhum, retMicroempresarioIndividual ]);

    NFSe.Servico.Valores.ValorPis       := Leitor.rCampo(tcDe2, 'ValorPIS');
    NFSe.Servico.Valores.ValorCofins    := Leitor.rCampo(tcDe2, 'ValorCOFINS');
    NFSe.Servico.Valores.ValorInss      := Leitor.rCampo(tcDe2, 'ValorINSS');
    NFSe.Servico.Valores.ValorIr        := Leitor.rCampo(tcDe2, 'ValorIR');
    NFSe.Servico.Valores.ValorCsll      := Leitor.rCampo(tcDe2, 'ValorCSLL');
    NFSe.Servico.Valores.AliquotaPIS    := Leitor.rCampo(tcDe2, 'AliquotaPIS');
    NFSe.Servico.Valores.AliquotaCOFINS := Leitor.rCampo(tcDe2, 'AliquotaCOFINS');
    NFSe.Servico.Valores.AliquotaINSS   := Leitor.rCampo(tcDe2, 'AliquotaINSS');
    NFSe.Servico.Valores.AliquotaIR     := Leitor.rCampo(tcDe2, 'AliquotaIR');
    NFSe.Servico.Valores.AliquotaCSLL   := Leitor.rCampo(tcDe2, 'AliquotaCSLL');

    NFSe.OutrasInformacoes                 := '';
    NFSe.Servico.Discriminacao             := Leitor.rCampo(tcStr, 'DescricaoRPS');
    NFSe.Servico.CodigoTributacaoMunicipio := Leitor.rCampo(tcStr, 'CodigoAtividade');

    NFSe.PrestadorServico.Contato.Telefone := Leitor.rCampo(tcStr, 'DDDPrestador') + Leitor.rCampo(tcStr, 'TelefonePrestador');
    NFSe.Tomador.Contato.Telefone          := Leitor.rCampo(tcStr, 'DDDTomador') + Leitor.rCampo(tcStr, 'TelefoneTomador');

    NFSE.MotivoCancelamento := Leitor.rCampo(tcStr, 'MotCancelamento');

    NFSe.IntermediarioServico.CpfCnpj := Leitor.rCampo(tcStr, 'CPFCNPJIntermediario');

    if (Leitor.rExtrai(1, 'Deducoes') <> '') then
    begin
      Item := 0;
      while (Leitor.rExtrai(1, 'Deducao', '', Item + 1) <> '') do
      begin
        FNfse.Servico.Deducao.New;
        FNfse.Servico.Deducao[Item].DeducaoPor  :=
           StrToEnumerado( ok,Leitor.rCampo(tcStr, 'DeducaoPor'),
                           ['','Percentual','Valor'],
                           [ dpNenhum,dpPercentual, dpValor ]);

        FNfse.Servico.Deducao[Item].TipoDeducao :=
           StrToEnumerado( ok,Leitor.rCampo(tcStr, 'TipoDeducao'),
                           ['', 'Despesas com Materiais', 'Despesas com Sub-empreitada'],
                           [ tdNenhum, tdMateriais, tdSubEmpreitada ]);

        FNfse.Servico.Deducao[Item].CpfCnpjReferencia    := Leitor.rCampo(tcStr, 'CPFCNPJReferencia');
        FNfse.Servico.Deducao[Item].NumeroNFReferencia   := Leitor.rCampo(tcStr, 'NumeroNFReferencia');
        FNfse.Servico.Deducao[Item].ValorTotalReferencia := Leitor.rCampo(tcDe2, 'ValorTotalReferencia');
        FNfse.Servico.Deducao[Item].PercentualDeduzir    := Leitor.rCampo(tcDe2, 'PercentualDeduzir');
        FNfse.Servico.Deducao[Item].ValorDeduzir         := Leitor.rCampo(tcDe2, 'ValorDeduzir');
        inc(Item);
      end;
    end;

    if (Leitor.rExtrai(1, 'Itens') <> '') then
    begin
      Item := 0;
      while (Leitor.rExtrai(1, 'Item', '', Item + 1) <> '') do
      begin
        FNfse.Servico.ItemServico.New;
        FNfse.Servico.ItemServico[Item].Descricao     := Leitor.rCampo(tcStr, 'DiscriminacaoServico');
        FNfse.Servico.ItemServico[Item].Quantidade    := Leitor.rCampo(tcDe2, 'Quantidade');
        FNfse.Servico.ItemServico[Item].ValorUnitario := Leitor.rCampo(tcDe2, 'ValorUnitario');
        FNfse.Servico.ItemServico[Item].ValorTotal    := Leitor.rCampo(tcDe2, 'ValorTotal');
        FNfse.Servico.ItemServico[Item].Tributavel    := StrToEnumerado( ok,Leitor.rCampo(tcStr, 'Tributavel'), ['N','S'], [ snNao, snSim ]);
        FNfse.Servico.Valores.ValorServicos           := (FNfse.Servico.Valores.ValorServicos + FNfse.Servico.ItemServico[Item].ValorTotal);
        inc(Item);
      end;
    end;
  end;

  // Corre��o para o c�lculo de VALOR LIQUIDO da NFSE - estavam faltando PIS, COFINS, INSS, IR e CSLL
  NFSe.Servico.Valores.ValorLiquidoNfse := NFSe.Servico.Valores.ValorServicos -
                                            (NFSe.Servico.Valores.ValorPis +
                                             NFSe.Servico.Valores.ValorCofins +
                                             NFSe.Servico.Valores.ValorInss +
                                             NFSe.Servico.Valores.ValorIr +
                                             NFSe.Servico.Valores.ValorCsll +
                                             FNfse.Servico.Valores.ValorDeducoes +
                                             FNfse.Servico.Valores.DescontoCondicionado+
                                             FNfse.Servico.Valores.DescontoIncondicionado+
                                             FNFSe.Servico.Valores.ValorIssRetido);


  FNfse.Servico.Valores.BaseCalculo := NFSe.Servico.Valores.ValorLiquidoNfse;

  Result := True;
end;

end.

