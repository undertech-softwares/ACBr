﻿using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using ACBrLib.Core;

namespace ACBrLib.Sat
{
    public sealed class ACBrSat : ACBrLibHandle
    {
        #region InnerTypes

        private class Delegates
        {
            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_Inicializar(ref IntPtr handle, string eArqConfig, string eChaveCrypt);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_Finalizar(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_Nome(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_Versao(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_UltimoRetorno(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ConfigImportar(IntPtr handle, string eArqConfig);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ConfigExportar(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ConfigLer(IntPtr handle, string eArqConfig);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ConfigGravar(IntPtr handle, string eArqConfig);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ConfigLerValor(IntPtr handle, string eSessao, string eChave, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ConfigGravarValor(IntPtr handle, string eSessao, string eChave, string valor);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_InicializarSAT(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_DesInicializar(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_AtivarSAT(IntPtr handle, string CNPJValue, int cUF, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_AssociarAssinatura(IntPtr handle, string CNPJValue, string assinaturaCNPJs, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_BloquearSAT(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_DesbloquearSAT(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_TrocarCodigoDeAtivacao(IntPtr handle, string codigoDeAtivacaoOuEmergencia, int opcao, string novoCodigo, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ConsultarSAT(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ConsultarStatusOperacional(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ConsultarNumeroSessao(IntPtr handle, int cNumeroDeSessao, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_AtualizarSoftwareSAT(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ComunicarCertificadoICPBRASIL(IntPtr handle, string certificado, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ExtrairLogs(IntPtr handle, string eArquivo);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_TesteFimAFim(IntPtr handle, string eArquivoXmlVenda);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_GerarAssinaturaSAT(IntPtr handle, string eCNPJSHW, string eCNPJEmitente, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_CriarCFe(IntPtr handle, string eArquivoIni, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_CriarEnviarCFe(IntPtr handle, string eArquivoIni, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_EnviarCFe(IntPtr handle, string eArquivoXml, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_CancelarCFe(IntPtr handle, string eArquivoXml, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ImprimirExtratoVenda(IntPtr handle, string eArquivoXml, string eNomeImpressora);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ImprimirExtratoResumido(IntPtr handle, string eArquivoXml, string eNomeImpressora);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_GerarPDFExtratoVenda(IntPtr handle, string eArquivoXml, string eNomeArquivo, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_GerarImpressaoFiscalMFe(IntPtr handle, string eArquivoXml, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_ImprimirExtratoCancelamento(IntPtr handle, string eArqXMLVenda, string eArqXMLCancelamento, string eNomeImpressora);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int SAT_EnviarEmail(IntPtr handle, string eArquivoXml, string ePara, string eAssunto, string eNomeArquivo,
                string sMensagem, string sCC, string eAnexos);
        }

        #endregion InnerTypes

        #region Constructors

        public ACBrSat(string eArqConfig = "", string eChaveCrypt = "") :
            base(Environment.Is64BitProcess ? "ACBrSAT64.dll" : "ACBrSAT32.dll")
        {
            var inicializar = GetMethod<Delegates.SAT_Inicializar>();
            var ret = ExecuteMethod(() => inicializar(ref libHandle, ToUTF8(eArqConfig), ToUTF8(eChaveCrypt)));

            CheckResult(ret);
        }

        #endregion Constructors

        #region Properties

        public string Nome
        {
            get
            {
                var bufferLen = BUFFER_LEN;
                var buffer = new StringBuilder(bufferLen);

                var method = GetMethod<Delegates.SAT_Nome>();
                var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

                CheckResult(ret);

                return ProcessResult(buffer, bufferLen);
            }
        }

        public string Versao
        {
            get
            {
                var bufferLen = BUFFER_LEN;
                var buffer = new StringBuilder(bufferLen);

                var method = GetMethod<Delegates.SAT_Versao>();
                var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

                CheckResult(ret);

                return ProcessResult(buffer, bufferLen);
            }
        }

        #endregion Properties

        #region Methods

        #region Ini

        public void ConfigGravar(string eArqConfig = "")
        {
            var gravarIni = GetMethod<Delegates.SAT_ConfigGravar>();
            var ret = ExecuteMethod(() => gravarIni(libHandle, ToUTF8(eArqConfig)));

            CheckResult(ret);
        }

        public void ConfigLer(string eArqConfig = "")
        {
            var lerIni = GetMethod<Delegates.SAT_ConfigLer>();
            var ret = ExecuteMethod(() => lerIni(libHandle, ToUTF8(eArqConfig)));

            CheckResult(ret);
        }

        public T ConfigLerValor<T>(ACBrSessao eSessao, string eChave)
        {
            var method = GetMethod<Delegates.SAT_ConfigLerValor>();

            var bufferLen = BUFFER_LEN;
            var pValue = new StringBuilder(bufferLen);
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eSessao.ToString()), ToUTF8(eChave), pValue, ref bufferLen));
            CheckResult(ret);

            var value = ProcessResult(pValue, bufferLen);
            return ConvertValue<T>(value);
        }

        public void ConfigGravarValor(ACBrSessao eSessao, string eChave, object value)
        {
            if (value == null) return;

            var method = GetMethod<Delegates.SAT_ConfigGravarValor>();
            var propValue = ConvertValue(value);

            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eSessao.ToString()), ToUTF8(eChave), ToUTF8(propValue)));
            CheckResult(ret);
        }

        #endregion Ini

        public void Inicializar()
        {
            var method = GetMethod<Delegates.SAT_InicializarSAT>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public void DesInicializar()
        {
            var method = GetMethod<Delegates.SAT_DesInicializar>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public void ImportarConfig(string eArqConfig = "")
        {
            var importarConfig = GetMethod<Delegates.SAT_ConfigImportar>();
            var ret = ExecuteMethod(() => importarConfig(libHandle, ToUTF8(eArqConfig)));

            CheckResult(ret);
        }

        public string ExportarConfig()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_ConfigExportar>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string AtivarSAT(string CNPJValue, int cUF)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_AtivarSAT>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(CNPJValue), cUF, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string AssociarAssinatura(string CNPJValue, string assinaturaCNPJs)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_AssociarAssinatura>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(CNPJValue), ToUTF8(assinaturaCNPJs), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string BloquearSAT()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_BloquearSAT>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string DesbloquearSAT()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_DesbloquearSAT>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string TrocarCodigoDeAtivacao(string codigoDeAtivacaoOuEmergencia, int opcao, string novoCodigo)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_TrocarCodigoDeAtivacao>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(codigoDeAtivacaoOuEmergencia), opcao,
                ToUTF8(novoCodigo), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string ConsultarSAT()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_ConsultarSAT>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string ConsultarStatusOperacional()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_ConsultarStatusOperacional>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string ConsultarNumeroSessao(int cNumeroDeSessao)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_ConsultarNumeroSessao>();
            var ret = ExecuteMethod(() => method(libHandle, cNumeroDeSessao, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string AtualizarSoftwareSAT()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_AtualizarSoftwareSAT>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string ComunicarCertificadoICPBRASIL(string certificado)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_ComunicarCertificadoICPBRASIL>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(certificado), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public void ExtrairLogs(string eArquivo)
        {
            var method = GetMethod<Delegates.SAT_ExtrairLogs>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivo)));

            CheckResult(ret);
        }

        public void TesteFimAFim(string eArquivoXmlVenda)
        {
            var method = GetMethod<Delegates.SAT_TesteFimAFim>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoXmlVenda)));

            CheckResult(ret);
        }

        public string GerarAssinaturaSAT(string eCNPJSHW, string eCNPJEmitente)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_GerarAssinaturaSAT>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eCNPJSHW), ToUTF8(eCNPJEmitente), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string CriarCFe(string eArquivoIni)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_CriarCFe>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoIni), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string CriarEnviarCFe(string eArquivoIni)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_CriarEnviarCFe>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoIni), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string EnviarCFe(string eArquivoXml)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_EnviarCFe>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoXml), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string CancelarCFe(string eArquivoXml)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_CancelarCFe>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoXml), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public void ImprimirExtratoVenda(string eArquivoXml, string eNomeImpressora = "")
        {
            var method = GetMethod<Delegates.SAT_ImprimirExtratoVenda>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoXml), ToUTF8(eNomeImpressora)));

            CheckResult(ret);
        }

        public void ImprimirExtratoResumido(string eArquivoXml, string eNomeImpressora = "")
        {
            var method = GetMethod<Delegates.SAT_ImprimirExtratoResumido>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoXml), ToUTF8(eNomeImpressora)));

            CheckResult(ret);
        }

        public string GerarPDFExtratoVenda(string eArquivoXml, string eNomeArquivo = "")
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_GerarPDFExtratoVenda>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoXml), ToUTF8(eNomeArquivo), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string GerarImpressaoFiscalMFe(string eArquivoXml)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.SAT_GerarImpressaoFiscalMFe>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoXml), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public void ImprimirExtratoCancelamento(string eArqXMLVenda, string eArqXMLCancelamento, string eNomeImpressora = "")
        {
            var method = GetMethod<Delegates.SAT_ImprimirExtratoCancelamento>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArqXMLVenda), ToUTF8(eArqXMLCancelamento), ToUTF8(eNomeImpressora)));

            CheckResult(ret);
        }

        public void EnviarEmail(string eArquivoXml, string ePara, string eAssunto, string eNomeArquivo,
            string sMensagem, string sCC, string eAnexos)
        {
            var method = GetMethod<Delegates.SAT_EnviarEmail>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoXml), ToUTF8(ePara), ToUTF8(eAssunto),
                ToUTF8(eNomeArquivo), ToUTF8(sMensagem), ToUTF8(sCC), ToUTF8(eAnexos)));

            CheckResult(ret);
        }

        #region Private Methods

        protected override void FinalizeLib()
        {
            var finalizar = GetMethod<Delegates.SAT_Finalizar>();
            var codRet = ExecuteMethod(() => finalizar(libHandle));
            CheckResult(codRet);
        }

        protected override void InitializeMethods()
        {
            AddMethod<Delegates.SAT_Inicializar>("SAT_Inicializar");
            AddMethod<Delegates.SAT_Finalizar>("SAT_Finalizar");
            AddMethod<Delegates.SAT_Nome>("SAT_Nome");
            AddMethod<Delegates.SAT_Versao>("SAT_Versao");
            AddMethod<Delegates.SAT_UltimoRetorno>("SAT_UltimoRetorno");
            AddMethod<Delegates.SAT_ConfigImportar>("SAT_ConfigImportar");
            AddMethod<Delegates.SAT_ConfigExportar>("SAT_ConfigExportar");
            AddMethod<Delegates.SAT_ConfigLer>("SAT_ConfigLer");
            AddMethod<Delegates.SAT_ConfigGravar>("SAT_ConfigGravar");
            AddMethod<Delegates.SAT_ConfigLerValor>("SAT_ConfigLerValor");
            AddMethod<Delegates.SAT_ConfigGravarValor>("SAT_ConfigGravarValor");
            AddMethod<Delegates.SAT_InicializarSAT>("SAT_InicializarSAT");
            AddMethod<Delegates.SAT_DesInicializar>("SAT_DesInicializar");
            AddMethod<Delegates.SAT_AtivarSAT>("SAT_AtivarSAT");
            AddMethod<Delegates.SAT_AssociarAssinatura>("SAT_AssociarAssinatura");
            AddMethod<Delegates.SAT_BloquearSAT>("SAT_BloquearSAT");
            AddMethod<Delegates.SAT_DesbloquearSAT>("SAT_DesbloquearSAT");
            AddMethod<Delegates.SAT_TrocarCodigoDeAtivacao>("SAT_TrocarCodigoDeAtivacao");
            AddMethod<Delegates.SAT_ConsultarSAT>("SAT_ConsultarSAT");
            AddMethod<Delegates.SAT_ConsultarStatusOperacional>("SAT_ConsultarStatusOperacional");
            AddMethod<Delegates.SAT_ConsultarNumeroSessao>("SAT_ConsultarNumeroSessao");
            AddMethod<Delegates.SAT_AtualizarSoftwareSAT>("SAT_AtualizarSoftwareSAT");
            AddMethod<Delegates.SAT_ComunicarCertificadoICPBRASIL>("SAT_ComunicarCertificadoICPBRASIL");
            AddMethod<Delegates.SAT_ExtrairLogs>("SAT_ExtrairLogs");
            AddMethod<Delegates.SAT_TesteFimAFim>("SAT_TesteFimAFim");
            AddMethod<Delegates.SAT_GerarAssinaturaSAT>("SAT_GerarAssinaturaSAT");
            AddMethod<Delegates.SAT_CriarCFe>("SAT_CriarCFe");
            AddMethod<Delegates.SAT_CriarEnviarCFe>("SAT_CriarEnviarCFe");
            AddMethod<Delegates.SAT_EnviarCFe>("SAT_EnviarCFe");
            AddMethod<Delegates.SAT_CancelarCFe>("SAT_CancelarCFe");
            AddMethod<Delegates.SAT_ImprimirExtratoVenda>("SAT_ImprimirExtratoVenda");
            AddMethod<Delegates.SAT_ImprimirExtratoResumido>("SAT_ImprimirExtratoResumido");
            AddMethod<Delegates.SAT_GerarPDFExtratoVenda>("SAT_GerarPDFExtratoVenda");
            AddMethod<Delegates.SAT_GerarImpressaoFiscalMFe>("SAT_GerarImpressaoFiscalMFe");
            AddMethod<Delegates.SAT_ImprimirExtratoCancelamento>("SAT_ImprimirExtratoCancelamento");
            AddMethod<Delegates.SAT_EnviarEmail>("SAT_EnviarEmail");
        }

        protected override string GetUltimoRetorno(int iniBufferLen = 0)
        {
            var bufferLen = iniBufferLen < 1 ? BUFFER_LEN : iniBufferLen;
            var buffer = new StringBuilder(bufferLen);
            var ultimoRetorno = GetMethod<Delegates.SAT_UltimoRetorno>();

            if (iniBufferLen < 1)
            {
                ExecuteMethod(() => ultimoRetorno(libHandle, buffer, ref bufferLen));
                if (bufferLen <= BUFFER_LEN) return FromUTF8(buffer);

                buffer.Capacity = bufferLen;
            }

            ExecuteMethod(() => ultimoRetorno(libHandle, buffer, ref bufferLen));
            return FromUTF8(buffer);
        }

        #endregion Private Methods

        #endregion Methods
    }
}