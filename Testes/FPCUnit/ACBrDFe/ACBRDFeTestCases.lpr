program ACBrDiversosTestCase;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, fpcunittestrunner, ACBrDFeUtilTest,
  LibXml2TestCases, ACBrTests.Util;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

