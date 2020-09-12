{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Anderson Rogerio Bejatto                        }
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

unit ACBrTroco;

{$I ACBr.inc}

interface
uses
  SysUtils , Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$Else}
   Contnrs,
  {$IfEnd}
  ACBrBase;

type

{Classe TDinheiro que representa os valores existentes}
TDinheiro = class
  private
    fsValor: Double;
    fsDescricao: String;
  public
    Constructor Create;
    property Valor: Double read fsValor write fsValor;
    property Descricao: String read fsDescricao write fsDescricao;
  end;

{Classe que ira armazenar os objetos de TDinheiro}
TDinheiroList = class(TObjectList{$IfDef HAS_SYSTEM_GENERICS}<TDinheiro>{$EndIf})
  protected
    procedure SetObject (Index: Integer; Item: TDinheiro);
    function GetObject (Index: Integer): TDinheiro;
  public
    function Add (Obj: TDinheiro): Integer;
    procedure Insert (Index: Integer; Obj: TDinheiro);
    property Objects [Index: Integer]: TDinheiro
      read GetObject write SetObject; default;
  end;

{Classe que representa o troco a ser devolvido}
TTroco = class
 private
    fsValor: Double;
    fsQuantidade: Integer;
    fsDescricao: String;
    fsTipo: String;
    function GetDescricaoCompleta: String;
 public
    constructor create ;
    property Quantidade: Integer read fsQuantidade write fsQuantidade ;
    property Valor: Double read fsValor write fsValor;
    property Descricao: String read fsDescricao write fsDescricao ;
    property Tipo: String read fsTipo write fsTipo;
    property DescricaoCompleta: String read GetDescricaoCompleta;
end;

{Classe que ira armazenar os objetos de TTroco}
TTrocoList = class(TObjectList{$IfDef HAS_SYSTEM_GENERICS}<TTroco>{$EndIf})
  protected
    procedure SetObject (Index: Integer; Item: TTroco);
    function GetObject (Index: Integer): TTroco;
  public
    function Add (Obj: TTroco): Integer;
    procedure Insert (Index: Integer; Obj: TTroco);
    property Objects [Index: Integer]: TTroco
      read GetObject write SetObject; default;
  end;

{Calsse que ira fazer toda a manutencao}
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrTroco = class( TACBrComponent )
  private
    fsValorTroco: Double;
    fsTrocoList: TTrocoList;
    fsDinheiroList: TDinheiroList;
    fsStrCedula: String;
    fsStrMoeda: String;
    procedure SetValorTroco(const Value: Double);
    procedure CalculaTroco;
    procedure InserirTroco(const Descricao, Tipo: String; Quantidade: Integer; Valor: Double);
    function RetornarLegenda(XTotalMoeda,XValorMoeda : double) : string;
    function PosInsercaoDinheiro(Valor: Double): Integer;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy  ; override ;

    property TrocoList : TTrocoList read fsTrocoList;
    property DinheiroList : TDinheiroList read fsDinheiroList;
    procedure LimparDinheiro();
    procedure InserirDinheiro(const Descricao: String; Valor: Double);
    function RemoverDinheiro(Valor: Double): Boolean;
    function AchaDinheiroDescricao(Descricao: String): TDinheiro;
    function AchaDinheiroValor(Valor: Double): TDinheiro;
  published
    property Troco : Double read fsValorTroco write SetValorTroco stored false; 
    property StrCedula : String read fsStrCedula write fsStrCedula ;
    property StrMoeda  : String read fsStrMoeda  write fsStrMoeda ;

  end;

implementation
uses ACBrUtil, Math;

{-------------------------------- TACBrTroco ---------------------------------}
constructor TACBrTroco.Create( AOwner: TComponent );
begin
  inherited Create( AOwner ) ;

  fsValorTroco := 0;
  fsStrCedula  := 'C�dula' ;
  fsStrMoeda   := 'Moeda' ;

  { Criando Lista que receber� as Cedulas/Moedas do Troco }
  if Assigned( fsTrocoList ) then
     fsTrocoList.Free ;
  fsTrocoList := TTrocoList.Create( true ) ;

  { Criando Lista que contem as Notas e Moedas disponiveis para Troco }
  if Assigned( fsDinheiroList ) then
     fsDinheiroList.Free ;
  fsDinheiroList := TDinheiroList.Create( true ) ;

  { Inserindo valores Defaults }
  InserirDinheiro('Duzentos Reais', 200.00);
  InserirDinheiro('Cem Reais', 100.00);
  InserirDinheiro('Cinquenta Reais', 50.00);
  InserirDinheiro('Vinte Reais', 20.00);
  InserirDinheiro('Dez Reais', 10.00);
  InserirDinheiro('Cinco Reais', 5.00);
  InserirDinheiro('Dois Reais', 2.00);
  InserirDinheiro('Um Real', 1.00);
  InserirDinheiro('Cinquenta Centavos', 0.50);
  InserirDinheiro('Vinte e Cinco Centavos', 0.25);
  InserirDinheiro('Dez Centavos', 0.10);
  InserirDinheiro('Cinco Centavos', 0.05);
  InserirDinheiro('Um Centavo', 0.01);
end;

destructor TACBrTroco.Destroy;
begin
   if Assigned( fsTrocoList ) then
      fsTrocoList.Free ;

   if Assigned( fsDinheiroList ) then
      fsDinheiroList.Free ;

  inherited Destroy;
end;


procedure TACBrTroco.CalculaTroco;
var
   wValorPagto  : double;
   i, wValorDiv : Integer;
   Leg: String;
begin
  fsTrocoList.Clear;
  
  if fsValorTroco > 0.00 then
  begin
     wValorPagto := fsValorTroco;
     for i := 0 to fsDinheiroList.Count - 1 do
     begin
        if wValorPagto >= fsDinheiroList[i].Valor then
        begin
           wValorDiv := TruncFix( wValorPagto / fsDinheiroList[i].Valor );
           if wValorDiv <> 0 then
           begin
              Leg := RetornarLegenda(wValorDiv, fsDinheiroList[i].Valor);
              InserirTroco(fsDinheiroList[i].Descricao,  Leg,  wValorDiv,
                           fsDinheiroList[i].Valor);
              wValorPagto := RoundTo( wValorPagto -
                                     (wValorDiv * fsDinheiroList[i].Valor), -2);
           end;
        end;
     end;
  end;
end;

function TACBrTroco.RetornarLegenda(XTotalMoeda,XValorMoeda : double) : string;
var wLegenda : string;
begin
  if XValorMoeda > 1.00 then
     wLegenda := fsStrCedula
  else
     wLegenda := fsStrMoeda ;

  if XTotalMoeda > 1 then
     wLegenda := wLegenda+'s' ;
     
  Result := wLegenda;
end;

procedure TACBrTroco.SetValorTroco(const Value: Double);
begin
  fsValorTroco := RoundTo( Value, -2);
  CalculaTroco;
end;

procedure TACBrTroco.InserirTroco(const Descricao, Tipo: String;
  Quantidade: Integer; Valor: Double);
var
   Troc: TTroco;
begin
   Troc := TTroco.Create;

   Troc.Descricao  := TrimRight( Descricao );
   Troc.Tipo       := Tipo;
   Troc.Valor      := Valor;
   Troc.Quantidade := Quantidade;

   fsTrocoList.Add(Troc);
end;

procedure TACBrTroco.LimparDinheiro;
begin
   fsDinheiroList.Clear;
end;

procedure TACBrTroco.InserirDinheiro(const Descricao: String;
  Valor: Double);
var
   Din : TDinheiro;
begin
   if (Trim(Descricao) <> '') and (Valor > 0) then
    begin
      if AchaDinheiroValor(Valor) <> nil then
         raise Exception.Create(ACBrStr('Valor j� adicionado'));

      Din := TDinheiro.Create;

      Din.Descricao := TrimRight( Descricao );
      Din.Valor     := Valor;

      fsDinheiroList.Insert( PosInsercaoDinheiro(Valor), Din );
    end
   else
      raise Exception.Create(ACBrStr('Descri��o vazia ou Valor inferior a Zero.'));
end;

{ Achando a posi��o correta para inserir o valor. Notas maiores devem ter
  posicoes menores Exemplo: 100,00 -> Indice 0 }
function TACBrTroco.PosInsercaoDinheiro(Valor: Double): Integer;
var
   I: Integer;
begin
   Result := fsDinheiroList.Count;
   for I:= 0 to fsDinheiroList.Count -1 do
   begin
      if fsDinheiroList.Objects[I].Valor < Valor then
      begin
         Result:= I;
         Break;
      end;
   end;
end;

function TACBrTroco.AchaDinheiroDescricao(Descricao: String): TDinheiro;
var
   A: Integer;
begin
  Result := nil ;
  
  with fsDinheiroList do
  begin
     Descricao := UpperCase( TrimRight(Descricao) ) ;
     For A := 0 to Count -1 do
        if UpperCase( Objects[A].Descricao ) = Descricao then
        begin
           result := Objects[A] ;
           Break ;
        end ;
  end;
end;

function TACBrTroco.AchaDinheiroValor(Valor: Double): TDinheiro;
var
   A: Integer;
begin
   result := nil ;
   with fsDinheiroList do
      begin
         For A := 0 to Count -1 do
            if ( Objects[A].Valor ) = Valor then
               begin
                  result := Objects[A] ;
                  Break ;
               end ;
      end;
end;

function TACBrTroco.RemoverDinheiro(Valor: Double): Boolean;
var
   Dinheiro: TDinheiro;
begin
   Result:= False;
   Dinheiro:= AchaDinheiroValor(Valor);
   if Dinheiro <> nil then
   begin
      fsDinheiroList.Remove(Dinheiro);
      Result:= True;
   end;
end;

{------------------------------ TDinheiro ------------------------------------}
constructor TDinheiro.Create;
begin
   fsValor := 0;
   fsDescricao := '';
end;

{------------------------------ TDinheiroList --------------------------------}

function TDinheiroList.Add(Obj: TDinheiro): Integer;
begin
   Result := inherited Add(Obj);
end;

function TDinheiroList.GetObject(Index: Integer): TDinheiro;
begin
  Result := TDinheiro(inherited Items[Index]);
end;

procedure TDinheiroList.Insert(Index: Integer; Obj: TDinheiro);
begin
   inherited Insert(Index, Obj);
end;

procedure TDinheiroList.SetObject(Index: Integer; Item: TDinheiro);
begin
   inherited Items[Index] := Item;
end;

{---------------------------------- TTroco ----------------------------------}
constructor TTroco.create;
begin
   fsValor := 0;
   fsQuantidade:= 0;
   fsDescricao := '';
   fsTipo := '';
end;

function TTroco.GetDescricaoCompleta: String;
begin
   Result := IntToStr(fsQuantidade) + ' ' + fsTipo + ' de ' + fsDescricao;
end;

{-------------------------------- TTrocoList ----------------------------------}
function TTrocoList.Add(Obj: TTroco): Integer;
begin
   Result := inherited Add(Obj);
end;

function TTrocoList.GetObject(Index: Integer): TTroco;
begin
  Result := TTroco(inherited Items[Index]);
end;

procedure TTrocoList.Insert(Index: Integer; Obj: TTroco);
begin
   inherited Insert(Index, Obj);
end;

procedure TTrocoList.SetObject(Index: Integer; Item: TTroco);
begin
   inherited Items[Index] := Item;
end;

end.
