{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:   Regys Silveira                                }
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

unit ACBrDeviceBlueTooth;

interface

uses
  Classes, SysUtils,
  ACBrDeviceClass, ACBrBase,
  System.Bluetooth, System.Bluetooth.Components;

const
  GUID_BLUETOOTH_PRINTER : TGUID =  '{00001101-0000-1000-8000-00805F9B34FB}';
  BLUETOOTH_TIMEOUT = 5000;
  BLUETOOTH_BPS = 9600;
  BLUETOOTH_RETRIES = 5;

type

  { TACBrDeviceWinUSB }

  TACBrDeviceBlueTooth = class(TACBrDeviceClass)
  private
    fsBluetooth: TBluetooth;
    fsBlueToothSocket: TBluetoothSocket;
    fsBlueToothDevice: TBluetoothDevice;
    fsInternalBuffer: AnsiString;

    procedure AtivarBlueTooth;
    function GetDeviceName: String;
    function PedirPermissoes: Boolean;

    procedure ReconectarSocket;
    procedure ConectarSocket;
    procedure FecharSocket;

    function ReceiveNumBytes(BytesToRead, ATimeout: Integer): AnsiString;
    function ReceivePacket(ATimeOut: Integer): AnsiString;
    function ReceiveTerminated(ATerminator: AnsiString; ATimeOut: Integer): AnsiString;
  protected
    function GetTimeOutMilissegundos: Integer; override;
    procedure SetTimeOutMilissegundos(AValue: Integer); override;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure Conectar(const APorta: String; const ATimeOutMilissegundos: Integer); override;
    procedure Desconectar(IgnorarErros: Boolean = True); override;
    procedure AcharPortasBlueTooth(const AStringList: TStrings; TodasPortas: Boolean = True);
    function IsPrinterDevice(ABluetoothDevice: TBluetoothDevice): Boolean;

    procedure EnviaString(const AString: AnsiString); override;
    function LeString(ATimeOutMilissegundos: Integer = 0; NumBytes: Integer = 0;
      const Terminador: AnsiString = ''): AnsiString; override;
    procedure Limpar; override;

    function GetBluetoothDevice(AName: String): TBluetoothDevice;

    property BlueTooth: TBluetooth read fsBlueTooth;
    property BlueToothSocket: TBluetoothSocket read fsBlueToothSocket;
    property BlueToothDevice: TBluetoothDevice read fsBlueToothDevice;
  end;

ResourceString
  SErrDispositivoNaoEncontrado = 'Dispositivo [%s] n�o encontrado ou n�o pareado';
  SErrSemPermissaoParaBlueTooth = 'Sem Permiss�o para acesso a Dispositivos BlueTooth';
  SErrConectar = 'Erro ao conectar com Dispositivo [%s]';

implementation

uses
  dateutils, math,
  {$IfDef ANDROID}
   Androidapi.Helpers, Androidapi.JNI.Os, Androidapi.JNI.JavaTypes, System.Permissions,
  {$EndIf}
  ACBrDevice, ACBrUtil;

{ TACBrDeviceBlueTooth }

constructor TACBrDeviceBlueTooth.Create(AOwner: TComponent);
begin
  inherited;
  fsBluetooth := TBluetooth.Create(Nil);
  fsBlueToothSocket := Nil;
  fsInternalBuffer := '';
end;

destructor TACBrDeviceBlueTooth.Destroy;
begin
  Desconectar(True);
  fsBluetooth.Free;
  inherited;
end;

function TACBrDeviceBlueTooth.PedirPermissoes: Boolean;
Var
  Ok: Boolean;
begin
  {$IfDef ANDROID}
    Ok := False;
    PermissionsService.RequestPermissions( [JStringToString(TJManifest_permission.JavaClass.BLUETOOTH),
                                            JStringToString(TJManifest_permission.JavaClass.BLUETOOTH_ADMIN)],
      procedure(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
      var
        GR: TPermissionStatus;
      begin
        Ok := (Length(AGrantResults) = 2);

        if Ok then
        begin
          for GR in AGrantResults do
          begin
            if (GR <> TPermissionStatus.Granted) then
            begin
              Ok := False;
              Break;
            end;
          end;
        end;
      end );
  {$Else}
    Ok := True;
  {$EndIf}

  Result := Ok;
end;

procedure TACBrDeviceBlueTooth.AcharPortasBlueTooth(const AStringList: TStrings;
  TodasPortas: Boolean);
var
  DevBT: TBluetoothDevice;
begin
  GravaLog('AcharPortasBlueTooth');
  AtivarBlueTooth;
  if (fsBluetooth.PairedDevices <> nil) then
    for DevBT in fsBluetooth.PairedDevices do
      if TodasPortas or IsPrinterDevice(DevBT) then
        AStringList.Add('BTH:'+DevBT.DeviceName {+ ' - ' + IntToStr(DevBT.ClassDevice)});
end;

function TACBrDeviceBlueTooth.IsPrinterDevice(
  ABluetoothDevice: TBluetoothDevice): Boolean;
begin
  // https://www.ampedrftech.com/guides/cod_definition.pdf
  // Bits 12 a 8 - 00110 Imaging (printing, scanner, camera, display, ...)
  // 1536 - 00110 0000 0000

  Result := (1536 and ABluetoothDevice.ClassDevice) = 1536;
  //Result := TestBit(ABluetoothDevice.ClassDevice, 10);
end;

procedure TACBrDeviceBlueTooth.AtivarBlueTooth;
begin
  if not PedirPermissoes then
    DoException( Exception.Create(ACBrStr(SErrSemPermissaoParaBlueTooth)));

  if not fsBluetooth.Enabled then
    fsBluetooth.Enabled := True;
end;

procedure TACBrDeviceBlueTooth.Conectar(const APorta: String;
  const ATimeOutMilissegundos: Integer);
var
  DeviceName: String;
begin
  inherited;

  if not PedirPermissoes then
    DoException( Exception.Create(ACBrStr(SErrSemPermissaoParaBlueTooth)));

  AtivarBlueTooth;
  DeviceName := GetDeviceName;

  fsBlueToothDevice := GetBluetoothDevice(DeviceName);
  if not Assigned(fsBlueToothDevice) then
    DoException( Exception.CreateFmt(ACBrStr(SErrDispositivoNaoEncontrado), [APorta]));

  Self.TimeOutMilissegundos := ATimeOutMilissegundos;
  ConectarSocket;
end;

procedure TACBrDeviceBlueTooth.ConectarSocket;
begin
  if not Assigned(fsBlueToothDevice) then  // J� passou por Conectar ?
    Exit;

  fsBlueToothSocket := fsBlueToothDevice.CreateClientSocket(GUID_BLUETOOTH_PRINTER, False);
  if Assigned(fsBlueToothSocket) then
  begin
    fsBlueToothSocket.Connect;
    if not fsBlueToothSocket.Connected then
      DoException( Exception.CreateFmt(ACBrStr(SErrConectar), [fsBlueToothDevice.DeviceName]));
  end
  else
    DoException( Exception.CreateFmt(ACBrStr(SErrConectar), [fsBlueToothDevice.DeviceName]));
end;

procedure TACBrDeviceBlueTooth.Desconectar(IgnorarErros: Boolean);
begin
  FecharSocket;
end;

procedure TACBrDeviceBlueTooth.FecharSocket;
begin
  if Assigned(fsBlueToothSocket) then
  begin
    fsBlueToothSocket.Close;
    FreeAndNil(fsBlueToothSocket);
  end;
end;

procedure TACBrDeviceBlueTooth.EnviaString(const AString: AnsiString);
var
  Retries, SleepTime: Integer;
  Ok : Boolean;
  EL: String;
begin
  GravaLog('  TACBrDeviceBlueTooth.EnviaString');
  if not Assigned(fsBlueToothSocket) then
    Exit;

  Retries := 0;
  Ok := False;
  while (not OK) do
  begin
    try
      fsBlueToothSocket.SendData( TEncoding.ANSI.GetBytes(AString) );
      Ok := True;
      SleepTime := max(Trunc(Length(AString) / BLUETOOTH_BPS * 1000), 100);
      Sleep( SleepTime )
    except
      On E: Exception do
      begin
        EL := LowerCase(E.Message);
        if (EL.IndexOf('ioexception') > 0) and
           (Retries < BLUETOOTH_RETRIES) then
        begin
          ReconectarSocket;
          Inc(Retries)
        end
        else
          raise;
      end;
    end;
  end;
end;

function TACBrDeviceBlueTooth.GetBluetoothDevice(AName: String): TBluetoothDevice;
var
  DevBT: TBluetoothDevice;
  UpperName: String;
begin
  // Busca Sem Case e N�o Completaa
  Result := Nil;
  UpperName := UpperCase(AName);
  AtivarBlueTooth;
  for DevBT in fsBluetooth.PairedDevices do
  begin
    if UpperCase(copy(DevBT.DeviceName,1, Length(AName))) = UpperName then
    begin
      Result := DevBT;
      Break;
    end;
  end;
end;

function TACBrDeviceBlueTooth.GetDeviceName: String;
begin
  Result := fpPorta;
  if (copy(UpperCase(Result), 1, 4) = 'BTH:') then
    Result := copy(Result, 5, Length(Result)) ;

  Result := Trim(Result);
end;

function TACBrDeviceBlueTooth.GetTimeOutMilissegundos: Integer;
begin
  AtivarBlueTooth;
  if Assigned(fsBluetooth.CurrentManager) then
    Result := fsBluetooth.CurrentManager.SocketTimeout
  else
    Result := BLUETOOTH_TIMEOUT;
end;

procedure TACBrDeviceBlueTooth.SetTimeOutMilissegundos(AValue: Integer);
begin
  AtivarBlueTooth;
  if Assigned(fsBluetooth.CurrentManager) then
    fsBluetooth.CurrentManager.SocketTimeout := AValue;
end;

function TACBrDeviceBlueTooth.LeString(ATimeOutMilissegundos, NumBytes: Integer;
  const Terminador: AnsiString): AnsiString;
begin
  if ATimeOutMilissegundos = 0 then
    ATimeOutMilissegundos := BLUETOOTH_TIMEOUT;

  if (NumBytes > 0) then
    Result := ReceiveNumBytes( NumBytes, ATimeOutMilissegundos)
  else if (Terminador <> '') then
    Result := ReceiveTerminated( Terminador, ATimeOutMilissegundos)
  else
    Result := ReceivePacket( ATimeOutMilissegundos );
end;


procedure TACBrDeviceBlueTooth.Limpar;
begin
  inherited;
end;

function TACBrDeviceBlueTooth.ReceiveNumBytes(BytesToRead: Integer;
  ATimeout: Integer): AnsiString;
var
  TimeoutTime: TDateTime;
begin
  Result := '';
  if BytesToRead <= 0 then Exit;

  //DEBUG
  //GravaLog( 'ReceiveNumBytes: BytesToRead: '+IntToStr(BytesToRead)+
  //          ', TimeOut: '+IntToStr(ATimeOut));

  TimeoutTime := IncMilliSecond(Now, ATimeOut);
  while (Length(fsInternalBuffer) < BytesToRead) and (now < TimeoutTime) do
    fsInternalBuffer := fsInternalBuffer + ReceivePacket(ATimeout);

  Result := copy(fsInternalBuffer, 1, BytesToRead);
  if (Result <> '') then
    Delete(fsInternalBuffer, 1, Length(Result));
end;

function TACBrDeviceBlueTooth.ReceiveTerminated(ATerminator: AnsiString;
  ATimeOut: Integer): AnsiString;
var
  TimeoutTime: TDateTime;
  LenTer, p: Integer;
begin
  Result := '';
  LenTer := Length(ATerminator);
  if (LenTer = 0) then
    Exit;

  //DEBUG
  //GravaLog('ReceiveTerminated: Terminator: '+ATerminator+
  //         ', TimeOut: '+IntToStr(ATimeOut), True);
  p := pos(ATerminator, fsInternalBuffer);
  TimeoutTime := IncMilliSecond(Now, ATimeOut);
  while (p < 1) and (now < TimeoutTime) do
  begin
    fsInternalBuffer := fsInternalBuffer + ReceivePacket(ATimeout);
    p := pos(ATerminator, fsInternalBuffer);
  end;

  if (p > 0) then
  begin
    Result := copy(fsInternalBuffer, 1, p-1);
    Delete(fsInternalBuffer, 1, p + LenTer-1);
  end;
end;

procedure TACBrDeviceBlueTooth.ReconectarSocket;
begin
  if not Assigned(fsBlueToothDevice) then  // Estava conectado ?
    Exit;

  FecharSocket;
  Sleep(100);
  ConectarSocket;
end;

function TACBrDeviceBlueTooth.ReceivePacket(ATimeOut: Integer): AnsiString;
var
  AData: TBytes;
  DataStr: String;
  TimeoutTime: TDateTime;
begin
  //DEBUG
  //GravaLOg('  ReceivePacket: TimeOut: '+IntToStr(ATimeOut));

  Result := '';
  if not Assigned(fsBlueToothSocket) then
    Exit;

  TimeoutTime := IncMilliSecond(now, ATimeOut);
  repeat
    AData := fsBlueToothSocket.ReceiveData(ATimeOut);

    if (Length(AData) > 0) then
    begin
      DataStr := TEncoding.ANSI.GetString(AData);
      //DEBUG
      //GravaLog('  Buffer Lido: '+DataStr, True);
      Result := Result + AnsiString(DataStr);
    end;
  until (Length(AData) > 0) or (now > TimeoutTime);
end;

end.



