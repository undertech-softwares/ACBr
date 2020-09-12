﻿using System;
using System.Globalization;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using ACBrLib.Core;
using ACBrLib.Core.PosPrinter;

namespace ACBrLibPosPrinter
{
    /// <inheritdoc />
    public sealed class ACBrPosPrinter : ACBrLibHandle
    {
        #region InnerTypes

        private class Delegates
        {
            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_Inicializar(ref IntPtr handle, string eArqConfig, string eChaveCrypt);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_Finalizar(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_Nome(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_Versao(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_UltimoRetorno(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ConfigImportar(IntPtr handle, string eArqConfig);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ConfigExportar(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ConfigLer(IntPtr handle, string eArqConfig);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ConfigGravar(IntPtr handle, string eArqConfig);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ConfigLerValor(IntPtr handle, string eSessao, string eChave, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ConfigGravarValor(IntPtr handle, string eSessao, string eChave, string valor);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_Ativar(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_Desativar(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_Imprimir(IntPtr handle, string aString, bool pulaLinha, bool decodificarTags, bool codificarPagina, int copias);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ImprimirLinha(IntPtr handle, string aString);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ImprimirCmd(IntPtr handle, string aString);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ImprimirTags(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ImprimirImagemArquivo(IntPtr handle, string aPath);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ImprimirLogo(IntPtr handle, int nAKC1, int nAKC2, int nFatorX, int nFatorY);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ImprimirCheque(IntPtr handle, int CodBanco, string AValor, string ADataEmissao, string AFavorecido,
               string ACidade, string AComplemento, bool LerCMC7, int SegundosEspera);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ImprimirTextoCheque(IntPtr handle, int X, int Y, string AString, bool AguardaCheque, int SegundosEspera);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_TxRx(IntPtr handle, string aString, byte bytesToRead, int aTimeOut, bool waitForTerminator, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_Zerar(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_InicializarPos(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_Reset(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_PularLinhas(IntPtr handle, int numLinhas);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_CortarPapel(IntPtr handle, bool parcial);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_AbrirGaveta(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_LerInfoImpressora(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_LerStatusImpressora(IntPtr handle, int tentativas, ref int status);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_RetornarTags(IntPtr handle, bool incluiAjuda, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_AcharPortas(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_GravarLogoArquivo(IntPtr handle, string aPath, int nAKC1, int nAKC2);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_ApagarLogo(IntPtr handle, int nAKC1, int nAKC2);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_LeituraCheque(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_LerCMC7(IntPtr handle, bool AguardaCheque, int SegundosEspera, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_EjetarCheque(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_PodeLerDaPorta(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int POS_LerCaracteristicas(IntPtr handle, StringBuilder buffer, ref int bufferSize);
        }

        #endregion InnerTypes
        
        #region Constructors

        public ACBrPosPrinter(string eArqConfig = "", string eChaveCrypt = "") : base("ACBrPosPrinter64.dll", "ACBrPosPrinter32.dll")
        {
            var inicializar = GetMethod<Delegates.POS_Inicializar>();
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

                var method = GetMethod<Delegates.POS_Nome>();
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

                var method = GetMethod<Delegates.POS_Versao>();
                var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

                CheckResult(ret);

                return ProcessResult(buffer, bufferLen);
            }
        }

        #endregion Properties

        #region Metodos

        #region Ini

        public void ConfigGravar(string eArqConfig = "")
        {
            var gravarIni = GetMethod<Delegates.POS_ConfigGravar>();
            var ret = ExecuteMethod(() => gravarIni(libHandle, ToUTF8(eArqConfig)));

            CheckResult(ret);
        }

        public void ImportarConfig(string eArqConfig)
        {
            var lerIni = GetMethod<Delegates.POS_ConfigImportar>();
            var ret = ExecuteMethod(() => lerIni(libHandle, ToUTF8(eArqConfig)));

            CheckResult(ret);
        }

        public string ExportarConfig()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.POS_ConfigExportar>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public void ConfigLer(string eArqConfig = "")
        {
            var lerIni = GetMethod<Delegates.POS_ConfigLer>();
            var ret = ExecuteMethod(() => lerIni(libHandle, ToUTF8(eArqConfig)));

            CheckResult(ret);
        }

        public T ConfigLerValor<T>(ACBrSessao eSessao, string eChave)
        {
            var method = GetMethod<Delegates.POS_ConfigLerValor>();

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

            var method = GetMethod<Delegates.POS_ConfigGravarValor>();
            var propValue = ConvertValue(value);

            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eSessao.ToString()), ToUTF8(eChave), ToUTF8(propValue)));
            CheckResult(ret);
        }

        #endregion Ini

        #region Ativar

        public void Ativar()
        {
            var method = GetMethod<Delegates.POS_Ativar>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public void Desativar()
        {
            var method = GetMethod<Delegates.POS_Desativar>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        #endregion Ativar

        #region Diversos

        public void Zerar()
        {
            var method = GetMethod<Delegates.POS_Zerar>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public void Inicializar()
        {
            var method = GetMethod<Delegates.POS_InicializarPos>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public void Reset()
        {
            var method = GetMethod<Delegates.POS_Reset>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public void PularLinhas(int numLinhas = 0)
        {
            var method = GetMethod<Delegates.POS_PularLinhas>();
            var ret = ExecuteMethod(() => method(libHandle, numLinhas));

            CheckResult(ret);
        }

        public void CortarPapel(bool parcial = false)
        {
            var method = GetMethod<Delegates.POS_CortarPapel>();
            var ret = ExecuteMethod(() => method(libHandle, parcial));

            CheckResult(ret);
        }

        public void AbrirGaveta()
        {
            var method = GetMethod<Delegates.POS_AbrirGaveta>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public string LerInfoImpressora()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.POS_LerInfoImpressora>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public ACBrPosTipoStatus LerStatusImpressora(int tentativas = 1)
        {
            var status = 0;
            var method = GetMethod<Delegates.POS_LerStatusImpressora>();
            var ret = ExecuteMethod(() => method(libHandle, tentativas, ref status));

            CheckResult(ret);

            return (ACBrPosTipoStatus)status;
        }

        public string[] RetornarTags(bool incluiAjuda = true)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.POS_RetornarTags>();
            var ret = ExecuteMethod(() => method(libHandle, incluiAjuda, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen).Split('|');
        }

        public string[] AcharPortas()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.POS_AcharPortas>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen).Split('|');
        }

        public void GravarLogoArquivo(string aPath, int nAKC1, int nAKC2)
        {
            var method = GetMethod<Delegates.POS_GravarLogoArquivo>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(aPath), nAKC1, nAKC2));

            CheckResult(ret);
        }

        public void ApagarLogo(int nAKC1, int nAKC2)
        {
            var method = GetMethod<Delegates.POS_ApagarLogo>();
            var ret = ExecuteMethod(() => method(libHandle, nAKC1, nAKC2));

            CheckResult(ret);
        }

        public string LeituraCheque()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.POS_LeituraCheque>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string LerCMC7(bool AguardaCheque, int SegundosEspera)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.POS_LerCMC7>();
            var ret = ExecuteMethod(() => method(libHandle, AguardaCheque, SegundosEspera, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public void EjetarCheque()
        {
            var method = GetMethod<Delegates.POS_EjetarCheque>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public bool PodeLerDaPorta()
        {
            var method = GetMethod<Delegates.POS_PodeLerDaPorta>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);

            return ret == 1;
        }

        public string LerCaracteristicas()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.POS_LerCaracteristicas>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        #endregion Diversos

        #region Imprimir

        public void Imprimir(string aString = "", bool pulaLinha = false, bool decodificarTags = true, bool codificarPagina = true, int copias = 1)
        {
            var method = GetMethod<Delegates.POS_Imprimir>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(aString), pulaLinha, decodificarTags, codificarPagina, copias));

            CheckResult(ret);
        }

        public void ImprimirLinha(string aString)
        {
            var method = GetMethod<Delegates.POS_ImprimirLinha>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(aString)));

            CheckResult(ret);
        }

        public void ImprimirCmd(string aString)
        {
            var method = GetMethod<Delegates.POS_ImprimirCmd>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(aString)));

            CheckResult(ret);
        }

        public void ImprimirTags()
        {
            var method = GetMethod<Delegates.POS_ImprimirTags>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public void ImprimirImagemArquivo(string aPath)
        {
            var method = GetMethod<Delegates.POS_ImprimirImagemArquivo>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(aPath)));

            CheckResult(ret);
        }

        public void ImprimirLogo(int nAKC1, int nAKC2, int nFatorX, int nFatorY)
        {
            var method = GetMethod<Delegates.POS_ImprimirLogo>();
            var ret = ExecuteMethod(() => method(libHandle, nAKC1, nAKC2, nFatorX, nFatorY));

            CheckResult(ret);
        }

        public void ImprimirCheque(int CodBanco, decimal AValor, DateTime ADataEmissao, string AFavorecido,
            string ACidade, string AComplemento, bool LerCMC7, int SegundosEspera)
        {
            var method = GetMethod<Delegates.POS_ImprimirCheque>();

            var valor = AValor.ToString("N2", CultureInfo.CreateSpecificCulture("pt-BR"));
            var data = ADataEmissao.ToString("dd/MM/yyyy");

            var ret = ExecuteMethod(() => method(libHandle, CodBanco, ToUTF8(valor), ToUTF8(data), ToUTF8(AFavorecido), ToUTF8(ACidade),
                                                 ToUTF8(AComplemento), LerCMC7, SegundosEspera));

            CheckResult(ret);
        }

        public void ImprimirTextoCheque(int X, int Y, string AString, bool AguardaCheque, int SegundosEspera)
        {
            var method = GetMethod<Delegates.POS_ImprimirTextoCheque>();
            var ret = ExecuteMethod(() => method(libHandle, X, Y, ToUTF8(AString), AguardaCheque, SegundosEspera));

            CheckResult(ret);
        }

        public string TxRx(string aString, byte bytesToRead = 1, int aTimeOut = 500, bool waitForTerminator = false)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.POS_TxRx>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(aString), bytesToRead, aTimeOut, waitForTerminator, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        #endregion Imprimir

        #region Private Methods

        protected override void FinalizeLib()
        {
            var finalizar = GetMethod<Delegates.POS_Finalizar>();
            var codRet = ExecuteMethod(() => finalizar(libHandle));
            CheckResult(codRet);
        }

        protected override void InitializeMethods()
        {
            AddMethod<Delegates.POS_Inicializar>("POS_Inicializar");
            AddMethod<Delegates.POS_Finalizar>("POS_Finalizar");
            AddMethod<Delegates.POS_Nome>("POS_Nome");
            AddMethod<Delegates.POS_Versao>("POS_Versao");
            AddMethod<Delegates.POS_UltimoRetorno>("POS_UltimoRetorno");
            AddMethod<Delegates.POS_ConfigImportar>("POS_ConfigImportar");
            AddMethod<Delegates.POS_ConfigExportar>("POS_ConfigExportar");
            AddMethod<Delegates.POS_ConfigLer>("POS_ConfigLer");
            AddMethod<Delegates.POS_ConfigGravar>("POS_ConfigGravar");
            AddMethod<Delegates.POS_ConfigLerValor>("POS_ConfigLerValor");
            AddMethod<Delegates.POS_ConfigGravarValor>("POS_ConfigGravarValor");
            AddMethod<Delegates.POS_Ativar>("POS_Ativar");
            AddMethod<Delegates.POS_Desativar>("POS_Desativar");
            AddMethod<Delegates.POS_Imprimir>("POS_Imprimir");
            AddMethod<Delegates.POS_ImprimirLinha>("POS_ImprimirLinha");
            AddMethod<Delegates.POS_ImprimirCmd>("POS_ImprimirCmd");
            AddMethod<Delegates.POS_ImprimirTags>("POS_ImprimirTags");
            AddMethod<Delegates.POS_ImprimirImagemArquivo>("POS_ImprimirImagemArquivo");
            AddMethod<Delegates.POS_ImprimirLogo>("POS_ImprimirLogo");
            AddMethod<Delegates.POS_ImprimirCheque>("POS_ImprimirCheque");
            AddMethod<Delegates.POS_ImprimirTextoCheque>("POS_ImprimirTextoCheque");
            AddMethod<Delegates.POS_TxRx>("POS_TxRx");
            AddMethod<Delegates.POS_Zerar>("POS_Zerar");
            AddMethod<Delegates.POS_InicializarPos>("POS_InicializarPos");
            AddMethod<Delegates.POS_Reset>("POS_Reset");
            AddMethod<Delegates.POS_PularLinhas>("POS_PularLinhas");
            AddMethod<Delegates.POS_CortarPapel>("POS_CortarPapel");
            AddMethod<Delegates.POS_AbrirGaveta>("POS_AbrirGaveta");
            AddMethod<Delegates.POS_LerInfoImpressora>("POS_LerInfoImpressora");
            AddMethod<Delegates.POS_LerStatusImpressora>("POS_LerStatusImpressora");
            AddMethod<Delegates.POS_RetornarTags>("POS_RetornarTags");
            AddMethod<Delegates.POS_AcharPortas>("POS_AcharPortas");
            AddMethod<Delegates.POS_GravarLogoArquivo>("POS_GravarLogoArquivo");
            AddMethod<Delegates.POS_ApagarLogo>("POS_ApagarLogo");
            AddMethod<Delegates.POS_LeituraCheque>("POS_LeituraCheque");
            AddMethod<Delegates.POS_LerCMC7>("POS_LerCMC7");
            AddMethod<Delegates.POS_EjetarCheque>("POS_EjetarCheque");
            AddMethod<Delegates.POS_PodeLerDaPorta>("POS_PodeLerDaPorta");
            AddMethod<Delegates.POS_LerCaracteristicas>("POS_LerCaracteristicas");
        }

        protected override string GetUltimoRetorno(int iniBufferLen = 0)
        {
            var bufferLen = iniBufferLen < 1 ? BUFFER_LEN : iniBufferLen;
            var buffer = new StringBuilder(bufferLen);
            var ultimoRetorno = GetMethod<Delegates.POS_UltimoRetorno>();

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

        #endregion Metodos
    }
}