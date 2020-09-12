{$I ACBr.inc}

library ACBrLibCTe;

uses
  Interfaces, sysutils, Classes, Forms, ACBrLibConfig,
  ACBrLibComum, ACBrLibConsts, ACBrLibCTeConfig, ACBrLibResposta,
  {$IFDEF MT}ACBrLibCTeMT{$ELSE}ACBrLibCTeST{$ENDIF},
  ACBrLibDistribuicaoDFe, ACBrLibCTeRespostas, ACBrLibCTeConsts;

{$R *.res}

{$IFDEF DEBUG}
var
   HeapTraceFile : String ;
{$ENDIF}

exports
  // Importadas de ACBrLibComum
  CTE_Inicializar,
  CTE_Finalizar,
  CTE_Nome,
  CTE_Versao,
  CTE_UltimoRetorno,
  CTE_ConfigImportar,
  CTE_ConfigExportar,
  CTE_ConfigLer,
  CTE_ConfigGravar,
  CTE_ConfigLerValor,
  CTE_ConfigGravarValor,

  // Servicos
  CTE_StatusServico,
  CTE_Inutilizar,
  CTE_Enviar,
  CTE_ConsultarRecibo,
  CTE_Consultar,
  CTE_Cancelar,
  CTE_EnviarEvento,
  CTE_ConsultaCadastro,
  CTE_DistribuicaoDFePorUltNSU,
  CTE_DistribuicaoDFePorNSU,
  CTE_DistribuicaoDFePorChave,
  CTE_EnviarEmail,
  CTE_EnviarEmailEvento,
  CTE_Imprimir,
  CTE_ImprimirPDF,
  CTE_ImprimirEvento,
  CTE_ImprimirEventoPDF,
  CTE_ImprimirInutilizacao,
  CTE_ImprimirInutilizacaoPDF,


  // Arquivos
  CTE_CarregarXML,
  CTE_CarregarINI,
  CTE_ObterXml,
  CTE_GravarXml,
  CTE_ObterIni,
  CTE_GravarIni,
  CTE_CarregarEventoXML,
  CTE_CarregarEventoINI,
  CTE_LimparLista,
  CTE_LimparListaEventos,
  CTE_Assinar,
  CTE_Validar,
  CTE_ValidarRegrasdeNegocios,
  CTE_VerificarAssinatura,
  CTE_GerarChave,
  CTE_ObterCertificados,
  CTE_GetPath,
  CTE_GetPathEvento;

begin
  {$IFDEF DEBUG}
   HeapTraceFile := ExtractFilePath(ParamStr(0))+ 'heaptrclog.trc' ;
   DeleteFile( HeapTraceFile );
   SetHeapTraceOutput( HeapTraceFile );
  {$ENDIF}

  MainThreadID := GetCurrentThreadId();
  Application.Initialize;
end.


