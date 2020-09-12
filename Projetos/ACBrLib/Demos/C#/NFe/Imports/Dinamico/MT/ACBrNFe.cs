﻿using System;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using ACBrLib.Core;
using ACBrLib.Core.DFe;
using ACBrLib.Core.NFe;

namespace ACBrLib.NFe
{
    public sealed class ACBrNFe : ACBrLibHandle
    {
        #region InnerTypes

        private class Delegates
        {
            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_Inicializar(ref IntPtr handle, string eArqConfig, string eChaveCrypt);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_Finalizar(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_Nome(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_Versao(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_UltimoRetorno(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ConfigImportar(IntPtr handle, string eArqConfig);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ConfigExportar(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ConfigLer(IntPtr handle, string eArqConfig);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ConfigGravar(IntPtr handle, string eArqConfig);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ConfigLerValor(IntPtr handle, string eSessao, string eChave, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ConfigGravarValor(IntPtr handle, string eSessao, string eChave, string valor);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_CarregarXML(IntPtr handle, string eArquivoOuXml);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_CarregarINI(IntPtr handle, string eArquivoOuIni);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ObterXml(IntPtr handle, int AIndex, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_GravarXml(IntPtr handle, int AIndex, string eNomeArquivo, string ePathArquivo);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ObterIni(IntPtr handle, int AIndex, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_GravarIni(IntPtr handle, int AIndex, string eNomeArquivo, string ePathArquivo);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_CarregarEventoXML(IntPtr handle, string eArquivoOuXml);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_CarregarEventoINI(IntPtr handle, string eArquivoOuIni);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_LimparLista(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_LimparListaEventos(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_Assinar(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_Validar(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ValidarRegrasdeNegocios(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_VerificarAssinatura(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_GerarChave(IntPtr handle, int ACodigoUF, int ACodigoNumerico, int AModelo, int ASerie, int ANumero,
                int ATpEmi, string AEmissao, string CPFCNPJ, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ObterCertificados(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_GetPath(IntPtr handle, int tipo, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_GetPathEvento(IntPtr handle, string aCodEvento, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_StatusServico(IntPtr handle, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_Consultar(IntPtr handle, string eChaveOuNFe, bool AExtrairEventos, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ConsultaCadastro(IntPtr handle, string cUF, string nDocumento, bool nIE, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_Inutilizar(IntPtr handle, string acnpj, string aJustificativa, int ano, int modelo,
                int serie, int numeroInicial, int numeroFinal, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_Enviar(IntPtr handle, int aLote, bool imprimir, bool sincrono, bool zipado, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ConsultarRecibo(IntPtr handle, string aRecibo, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_Cancelar(IntPtr handle, string eChave, string eJustificativa, string eCNPJ, int aLote,
                StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_EnviarEvento(IntPtr handle, int alote, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_DistribuicaoDFePorUltNSU(IntPtr handle, int acUFAutor, string eCnpjcpf, string eultNsu, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_DistribuicaoDFePorNSU(IntPtr handle, int acUFAutor, string eCnpjcpf, string eNsu, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_DistribuicaoDFePorChave(IntPtr handle, int acUFAutor, string eCnpjcpf, string echNFe, StringBuilder buffer, ref int bufferSize);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_EnviarEmail(IntPtr handle, string ePara, string eChaveNFe, bool aEnviaPDF, string eAssunto, string eCc, string eAnexos, string eMensagem);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_EnviarEmailEvento(IntPtr handle, string ePara, string eChaveEvento, string eChaveNFe, bool aEnviaPDF, string eAssunto, string eCc, string eAnexos, string eMensagem);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_Imprimir(IntPtr handle, string cImpressora, int nNumCopias, string cProtocolo, string bMostrarPreview, string cMarcaDagua, string bViaConsumidor, string bSimplificado);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ImprimirPDF(IntPtr handle);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ImprimirEvento(IntPtr handle, string eArquivoXmlNFe, string eArquivoXmlEvento);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ImprimirEventoPDF(IntPtr handle, string eArquivoXmlNFe, string eArquivoXmlEvento);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ImprimirInutilizacao(IntPtr handle, string eArquivoXml);

            [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
            public delegate int NFE_ImprimirInutilizacaoPDF(IntPtr handle, string eArquivoXml);
        }

        #endregion InnerTypes

        #region Constructors

        public ACBrNFe(string eArqConfig = "", string eChaveCrypt = "") : base("ACBrNFe64.dll", "ACBrNFe32.dll")
        {
            var inicializar = GetMethod<Delegates.NFE_Inicializar>();
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

                var method = GetMethod<Delegates.NFE_Nome>();
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

                var method = GetMethod<Delegates.NFE_Versao>();
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
            var gravarIni = GetMethod<Delegates.NFE_ConfigGravar>();
            var ret = ExecuteMethod(() => gravarIni(libHandle, ToUTF8(eArqConfig)));

            CheckResult(ret);
        }

        public void ConfigLer(string eArqConfig = "")
        {
            var lerIni = GetMethod<Delegates.NFE_ConfigLer>();
            var ret = ExecuteMethod(() => lerIni(libHandle, ToUTF8(eArqConfig)));

            CheckResult(ret);
        }

        public T ConfigLerValor<T>(ACBrSessao eSessao, string eChave)
        {
            var method = GetMethod<Delegates.NFE_ConfigLerValor>();

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

            var method = GetMethod<Delegates.NFE_ConfigGravarValor>();
            var propValue = ConvertValue(value);

            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eSessao.ToString()), ToUTF8(eChave), ToUTF8(propValue)));
            CheckResult(ret);
        }

        #endregion Ini

        public void ImportarConfig(string eArqConfig = "")
        {
            var importarConfig = GetMethod<Delegates.NFE_ConfigImportar>();
            var ret = ExecuteMethod(() => importarConfig(libHandle, ToUTF8(eArqConfig)));

            CheckResult(ret);
        }

        public string ExportarConfig()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_ConfigExportar>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }


        public void CarregarXML(string eArquivoOuXml)
        {
            var method = GetMethod<Delegates.NFE_CarregarXML>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoOuXml)));

            CheckResult(ret);
        }

        public void CarregarINI(string eArquivoOuIni)
        {
            var method = GetMethod<Delegates.NFE_CarregarINI>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoOuIni)));

            CheckResult(ret);
        }

        public string ObterXml(int aIndex)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_ObterXml>();
            var ret = ExecuteMethod(() => method(libHandle, aIndex, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public void GravarXml(int aIndex, string eNomeArquivo = "", string ePathArquivo = "")
        {
            var method = GetMethod<Delegates.NFE_GravarXml>();
            var ret = ExecuteMethod(() => method(libHandle, aIndex, ToUTF8(eNomeArquivo), ToUTF8(ePathArquivo)));

            CheckResult(ret);
        }

        public string ObterIni(int aIndex)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_ObterIni>();
            var ret = ExecuteMethod(() => method(libHandle, aIndex, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public void GravarIni(int aIndex, string eNomeArquivo = "", string ePathArquivo = "")
        {
            var method = GetMethod<Delegates.NFE_GravarIni>();
            var ret = ExecuteMethod(() => method(libHandle, aIndex, ToUTF8(eNomeArquivo), ToUTF8(ePathArquivo)));

            CheckResult(ret);
        }

        public void CarregarEventoXML(string eArquivoOuXml)
        {
            var method = GetMethod<Delegates.NFE_CarregarEventoXML>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoOuXml)));

            CheckResult(ret);
        }

        public void CarregarEventoINI(string eArquivoOuIni)
        {
            var method = GetMethod<Delegates.NFE_CarregarEventoINI>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoOuIni)));

            CheckResult(ret);
        }

        public void LimparLista()
        {
            var method = GetMethod<Delegates.NFE_LimparLista>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public void LimparListaEventos()
        {
            var method = GetMethod<Delegates.NFE_LimparListaEventos>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public void Assinar()
        {
            var method = GetMethod<Delegates.NFE_Assinar>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public void Validar()
        {
            var method = GetMethod<Delegates.NFE_Validar>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public string ValidarRegrasdeNegocios()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_ValidarRegrasdeNegocios>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string VerificarAssinatura()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_VerificarAssinatura>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string GerarChave(int aCodigoUf, int aCodigoNumerico, int aModelo, int aSerie, int aNumero,
            int aTpEmi, DateTime aEmissao, string acpfcnpj)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_GerarChave>();
            var ret = ExecuteMethod(() => method(libHandle, aCodigoUf, aCodigoNumerico, aModelo, aSerie, aNumero,
                                                 aTpEmi, aEmissao.Date.ToString("dd/MM/yyyy"), ToUTF8(acpfcnpj),
                                                 buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public InfoCertificado[] ObterCertificados()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_ObterCertificados>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            var certificados = ProcessResult(buffer, bufferLen).Split(new[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
            return certificados.Length == 0 ? new InfoCertificado[0] : certificados.Select(x => new InfoCertificado(x)).ToArray();
        }

        public string GetPath(TipoPathNFe tipo)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_GetPath>();
            var ret = ExecuteMethod(() => method(libHandle, (int)tipo, buffer, ref bufferLen));

            return ProcessResult(buffer, bufferLen);
        }

        public string GetPathEvento(string evento)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_GetPathEvento>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(evento), buffer, ref bufferLen));

            return ProcessResult(buffer, bufferLen);
        }

        public string StatusServico()
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_StatusServico>();
            var ret = ExecuteMethod(() => method(libHandle, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string Consultar(string eChaveOuNFe, bool AExtrairEventos = false)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_Consultar>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eChaveOuNFe), AExtrairEventos, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string ConsultaCadastro(string cUF, string nDocumento, bool nIE)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_ConsultaCadastro>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(cUF), ToUTF8(nDocumento), nIE, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string Inutilizar(string acnpj, string aJustificativa, int ano, int modelo,
            int serie, int numeroInicial, int numeroFinal)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_Inutilizar>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(acnpj), ToUTF8(aJustificativa), ano, modelo, serie, numeroInicial, numeroFinal, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string Enviar(int aLote, bool imprimir = false, bool sincrono = false, bool zipado = false)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_Enviar>();
            var ret = ExecuteMethod(() => method(libHandle, aLote, imprimir, sincrono, zipado, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string ConsultarRecibo(string aRecibo)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_ConsultarRecibo>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(aRecibo), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string Cancelar(string eChave, string eJustificativa, string eCNPJ, int aLote)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_Cancelar>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eChave), ToUTF8(eJustificativa), ToUTF8(eCNPJ), aLote, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string EnviarEvento(int aLote)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_EnviarEvento>();
            var ret = ExecuteMethod(() => method(libHandle, aLote, buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string DistribuicaoDFePorUltNSU(int acUFAutor, string eCnpjcpf, string eultNsu)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_DistribuicaoDFePorUltNSU>();
            var ret = ExecuteMethod(() => method(libHandle, acUFAutor, ToUTF8(eCnpjcpf), ToUTF8(eultNsu), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string DistribuicaoDFePorNSU(int acUFAutor, string eCnpjcpf, string eNsu)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_DistribuicaoDFePorNSU>();
            var ret = ExecuteMethod(() => method(libHandle, acUFAutor, ToUTF8(eCnpjcpf), ToUTF8(eNsu), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public string DistribuicaoDFePorChave(int acUFAutor, string eCnpjcpf, string echNFe)
        {
            var bufferLen = BUFFER_LEN;
            var buffer = new StringBuilder(bufferLen);

            var method = GetMethod<Delegates.NFE_DistribuicaoDFePorChave>();
            var ret = ExecuteMethod(() => method(libHandle, acUFAutor, ToUTF8(eCnpjcpf), ToUTF8(echNFe), buffer, ref bufferLen));

            CheckResult(ret);

            return ProcessResult(buffer, bufferLen);
        }

        public void EnviarEmail(string ePara, string eChaveNFe, bool aEnviaPDF, string eAssunto, string eMensagem, string[] eCc = null, string[] eAnexos = null)
        {
            var method = GetMethod<Delegates.NFE_EnviarEmail>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(ePara), ToUTF8(eChaveNFe), aEnviaPDF, ToUTF8(eAssunto), ToUTF8(eCc == null ? "" : string.Join(";", eCc)),
                                                 ToUTF8(eAnexos == null ? "" : string.Join(";", eAnexos)), ToUTF8(eMensagem.Replace(Environment.NewLine, ";"))));

            CheckResult(ret);
        }

        public void EnviarEmailEvento(string ePara, string eChaveEvento, string eChaveNFe, bool aEnviaPDF, string eAssunto, string eMensagem, string[] eCc = null, string[] eAnexos = null)
        {
            var method = GetMethod<Delegates.NFE_EnviarEmailEvento>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(ePara), ToUTF8(eChaveEvento), ToUTF8(eChaveNFe), aEnviaPDF, ToUTF8(eAssunto), ToUTF8(eCc == null ? "" : string.Join(";", eCc)),
                ToUTF8(eAnexos == null ? "" : string.Join(";", eAnexos)), ToUTF8(eMensagem.Replace(Environment.NewLine, ";"))));

            CheckResult(ret);
        }

        public void Imprimir(string cImpressora = "", int nNumCopias = 1, string cProtocolo = "", bool? bMostrarPreview = null, bool? cMarcaDagua = null,
            bool? bViaConsumidor = null, bool? bSimplificado = null)
        {
            var mostrarPreview = bMostrarPreview.HasValue ? $"{Convert.ToInt32(bMostrarPreview.Value)}" : string.Empty;
            var marcaDagua = cMarcaDagua.HasValue ? $"{Convert.ToInt32(cMarcaDagua.Value)}" : string.Empty;
            var viaConsumidor = bViaConsumidor.HasValue ? $"{Convert.ToInt32(bViaConsumidor.Value)}" : string.Empty;
            var simplificado = bSimplificado.HasValue ? $"{Convert.ToInt32(bSimplificado.Value)}" : string.Empty;

            var method = GetMethod<Delegates.NFE_Imprimir>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(cImpressora), nNumCopias, ToUTF8(cProtocolo), ToUTF8(mostrarPreview),
                ToUTF8(marcaDagua), ToUTF8(viaConsumidor), ToUTF8(simplificado)));

            CheckResult(ret);
        }

        public void ImprimirPDF()
        {
            var method = GetMethod<Delegates.NFE_ImprimirPDF>();
            var ret = ExecuteMethod(() => method(libHandle));

            CheckResult(ret);
        }

        public void ImprimirEvento(string eArquivoXmlNFe, string eArquivoXmlEvento)
        {
            var method = GetMethod<Delegates.NFE_ImprimirEvento>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoXmlNFe), ToUTF8(eArquivoXmlEvento)));

            CheckResult(ret);
        }

        public void ImprimirEventoPDF(string eArquivoXmlNFe, string eArquivoXmlEvento)
        {
            var method = GetMethod<Delegates.NFE_ImprimirEventoPDF>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoXmlNFe), ToUTF8(eArquivoXmlEvento)));

            CheckResult(ret);
        }

        public void ImprimirInutilizacao(string eArquivoXml)
        {
            var method = GetMethod<Delegates.NFE_ImprimirInutilizacao>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoXml)));

            CheckResult(ret);
        }

        public void ImprimirInutilizacaoPDF(string eArquivoXml)
        {
            var method = GetMethod<Delegates.NFE_ImprimirInutilizacaoPDF>();
            var ret = ExecuteMethod(() => method(libHandle, ToUTF8(eArquivoXml)));

            CheckResult(ret);
        }

        #region Private Methods

        protected override void FinalizeLib()
        {
            var finalizar = GetMethod<Delegates.NFE_Finalizar>();
            var codRet = ExecuteMethod(() => finalizar(libHandle));
            CheckResult(codRet);
        }

        protected override void InitializeMethods()
        {
            AddMethod<Delegates.NFE_Inicializar>("NFE_Inicializar");
            AddMethod<Delegates.NFE_Finalizar>("NFE_Finalizar");
            AddMethod<Delegates.NFE_Nome>("NFE_Nome");
            AddMethod<Delegates.NFE_Versao>("NFE_Versao");
            AddMethod<Delegates.NFE_UltimoRetorno>("NFE_UltimoRetorno");
            AddMethod<Delegates.NFE_ConfigImportar>("NFE_ConfigImportar");
            AddMethod<Delegates.NFE_ConfigExportar>("NFE_ConfigExportar");
            AddMethod<Delegates.NFE_ConfigLer>("NFE_ConfigLer");
            AddMethod<Delegates.NFE_ConfigGravar>("NFE_ConfigGravar");
            AddMethod<Delegates.NFE_ConfigLerValor>("NFE_ConfigLerValor");
            AddMethod<Delegates.NFE_ConfigGravarValor>("NFE_ConfigGravarValor");
            AddMethod<Delegates.NFE_CarregarXML>("NFE_CarregarXML");
            AddMethod<Delegates.NFE_CarregarINI>("NFE_CarregarINI");
            AddMethod<Delegates.NFE_ObterXml>("NFE_ObterXml");
            AddMethod<Delegates.NFE_GravarXml>("NFE_GravarXml");
            AddMethod<Delegates.NFE_ObterIni>("NFE_ObterIni");
            AddMethod<Delegates.NFE_GravarIni>("NFE_GravarIni");
            AddMethod<Delegates.NFE_CarregarEventoXML>("NFE_CarregarEventoXML");
            AddMethod<Delegates.NFE_CarregarEventoINI>("NFE_CarregarEventoINI");
            AddMethod<Delegates.NFE_LimparLista>("NFE_LimparLista");
            AddMethod<Delegates.NFE_LimparListaEventos>("NFE_LimparListaEventos");
            AddMethod<Delegates.NFE_Assinar>("NFE_Assinar");
            AddMethod<Delegates.NFE_Validar>("NFE_Validar");
            AddMethod<Delegates.NFE_ValidarRegrasdeNegocios>("NFE_ValidarRegrasdeNegocios");
            AddMethod<Delegates.NFE_VerificarAssinatura>("NFE_VerificarAssinatura");
            AddMethod<Delegates.NFE_GerarChave>("NFE_GerarChave");
            AddMethod<Delegates.NFE_ObterCertificados>("NFE_ObterCertificados");
            AddMethod<Delegates.NFE_GetPath>("NFE_GetPath");
            AddMethod<Delegates.NFE_GetPathEvento>("NFE_GetPathEvento");
            AddMethod<Delegates.NFE_StatusServico>("NFE_StatusServico");
            AddMethod<Delegates.NFE_Consultar>("NFE_Consultar");
            AddMethod<Delegates.NFE_ConsultaCadastro>("NFE_ConsultaCadastro");
            AddMethod<Delegates.NFE_Inutilizar>("NFE_Inutilizar");
            AddMethod<Delegates.NFE_Enviar>("NFE_Enviar");
            AddMethod<Delegates.NFE_ConsultarRecibo>("NFE_ConsultarRecibo");
            AddMethod<Delegates.NFE_Cancelar>("NFE_Cancelar");
            AddMethod<Delegates.NFE_EnviarEvento>("NFE_EnviarEvento");
            AddMethod<Delegates.NFE_DistribuicaoDFePorUltNSU>("NFE_DistribuicaoDFePorUltNSU");
            AddMethod<Delegates.NFE_DistribuicaoDFePorNSU>("NFE_DistribuicaoDFePorNSU");
            AddMethod<Delegates.NFE_DistribuicaoDFePorChave>("NFE_DistribuicaoDFePorChave");
            AddMethod<Delegates.NFE_EnviarEmail>("NFE_EnviarEmail");
            AddMethod<Delegates.NFE_EnviarEmailEvento>("NFE_EnviarEmailEvento");
            AddMethod<Delegates.NFE_Imprimir>("NFE_Imprimir");
            AddMethod<Delegates.NFE_ImprimirPDF>("NFE_ImprimirPDF");
            AddMethod<Delegates.NFE_ImprimirEvento>("NFE_ImprimirEvento");
            AddMethod<Delegates.NFE_ImprimirEventoPDF>("NFE_ImprimirEventoPDF");
            AddMethod<Delegates.NFE_ImprimirInutilizacao>("NFE_ImprimirInutilizacao");
            AddMethod<Delegates.NFE_ImprimirInutilizacaoPDF>("NFE_ImprimirInutilizacaoPDF");
        }

        protected override string GetUltimoRetorno(int iniBufferLen = 0)
        {
            var bufferLen = iniBufferLen < 1 ? BUFFER_LEN : iniBufferLen;
            var buffer = new StringBuilder(bufferLen);
            var ultimoRetorno = GetMethod<Delegates.NFE_UltimoRetorno>();

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