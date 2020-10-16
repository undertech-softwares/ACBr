program PosPrinterTeste;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  sysutils, Forms, Unit1, ConfiguraSerial, ACBrDeviceClass,
  ACBrPosPrinterElginE1Service;

{$R *.res}

begin
  {$IFDEF DEBUG}
   DeleteFile( 'c:\temp\heaptrclog.trc');
   SetHeapTraceOutput( 'c:\temp\heaptrclog.trc');
  {$ENDIF}
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TFrPosPrinterTeste, FrPosPrinterTeste);
  Application.Run;
end.

