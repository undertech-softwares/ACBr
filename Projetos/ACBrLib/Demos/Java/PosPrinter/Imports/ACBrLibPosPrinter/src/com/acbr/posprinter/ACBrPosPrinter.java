  package com.acbr.posprinter;

import com.acbr.ACBrLibBase;
import com.acbr.ACBrSessao;
import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Platform;
import com.sun.jna.ptr.IntByReference;
import java.io.File;

import java.nio.ByteBuffer;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Set;

public final class ACBrPosPrinter extends ACBrLibBase implements AutoCloseable  {

    public interface PosPrinterLib extends Library {

        public static String JNA_LIBRARY_NAME = LibraryLoader.getLibraryName();
        public static PosPrinterLib INSTANCE = LibraryLoader.getInstance();

        class LibraryLoader {

            private static String library = "";
            private static PosPrinterLib instance = null;

            public static String getLibraryName() {
                if (library.isEmpty()) {
                    library = Platform.is64Bit() ? "ACBrPosPrinter64" : "ACBrPosPrinter32";
                }
                return library;
            }

            public static PosPrinterLib getInstance() {
                if (instance == null) {
                    instance = (PosPrinterLib) Native.synchronizedLibrary((Library) Native.loadLibrary(JNA_LIBRARY_NAME, PosPrinterLib.class));
                }
                return instance;
            }
        }

        int POS_Inicializar(String eArqConfig, String eChaveCrypt);

        int POS_Finalizar();

        int POS_Nome(ByteBuffer buffer, IntByReference bufferSize);

        int POS_Versao(ByteBuffer buffer, IntByReference bufferSize);

        int POS_UltimoRetorno(ByteBuffer buffer, IntByReference bufferSize);
        
        int POS_ConfigImportar(String eArqConfig);
        
	    int POS_ConfigExportar(ByteBuffer buffer, IntByReference bufferSize);
        
        int POS_ConfigLer(String eArqConfig);

        int POS_ConfigGravar(String eArqConfig);

        int POS_ConfigLerValor(String eSessao, String eChave, ByteBuffer buffer, IntByReference bufferSize);

        int POS_ConfigGravarValor(String eSessao, String eChave, String valor);

        int POS_Ativar();

        int POS_Desativar();

        int POS_Imprimir(String aString, boolean pulaLinha, boolean decodificarTags, boolean codificarPagina, int copias);

        int POS_ImprimirLinha(String aString);

        int POS_ImprimirCmd(String aString);

        int POS_ImprimirTags();
        
        int POS_ImprimirImagemArquivo(String APath);
                       
        int POS_ImprimirLogo(int nAKC1, int nAKC2, int nFatorX, int nFatorY);
        
        int POS_ImprimirCheque(int CodBanco, String AValor, String ADataEmissao, String AFavorecido,
                  String ACidade, String AComplemento, boolean LerCMC7, int SegundosEspera);
        
        int POS_ImprimirTextoCheque(int X, int Y, String AString, boolean AguardaCheque, int SegundosEspera);

        int POS_TxRx(String aString, byte bytesToRead, int aTimeOut, boolean waitForTerminator, ByteBuffer buffer, IntByReference bufferSize);

        int POS_Zerar();

        int POS_InicializarPos();

        int POS_Reset();

        int POS_PularLinhas(int numLinhas);

        int POS_CortarPapel(boolean parcial);

        int POS_AbrirGaveta();

        int POS_LerInfoImpressora(ByteBuffer buffer, IntByReference bufferSize);

        int POS_LerStatusImpressora(int tentativas, IntByReference status);

        int POS_RetornarTags(boolean incluiAjuda, ByteBuffer buffer, IntByReference bufferSize);
        
        int POS_AcharPortas(ByteBuffer buffer, IntByReference bufferSize);
        
        int POS_GravarLogoArquivo(String APath, int nAKC1, int nAKC2);
        
        int POS_ApagarLogo(int nAKC1, int nAKC2);
        
        int POS_LeituraCheque(ByteBuffer buffer, IntByReference bufferSize);

        int POS_LerCMC7(boolean AguardaCheque, int SegundosEspera, ByteBuffer buffer, IntByReference bufferSize);
        
        int POS_EjetarCheque();
        
        int POS_PodeLerDaPorta();
        
        int POS_LerCaracteristicas(ByteBuffer buffer, IntByReference bufferSize);
    }

    public ACBrPosPrinter() throws Exception {
        File iniFile = Paths.get(System.getProperty("user.dir"), "ACBrLib.ini").toFile();
        if (!iniFile.exists()) {
            iniFile.createNewFile();
        }

        int ret = PosPrinterLib.INSTANCE.POS_Inicializar(toUTF8(iniFile.getAbsolutePath()), toUTF8(""));
        checkResult(ret);
    }

    public ACBrPosPrinter(String eArqConfig, String eChaveCrypt) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_Inicializar(toUTF8(eArqConfig), toUTF8(eChaveCrypt));
        checkResult(ret);
    }

    @Override
    public void close() throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_Finalizar();
        checkResult(ret);
    }
    
    @Override
    protected void finalize() throws Throwable {
        try {
            int ret = PosPrinterLib.INSTANCE.POS_Finalizar();
            checkResult(ret);
        } finally {
            super.finalize();
        }
    }

    public String nome() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = PosPrinterLib.INSTANCE.POS_Nome(buffer, bufferLen);
        checkResult(ret);

        return fromUTF8(buffer, bufferLen.getValue());
    }

    public String versao() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = PosPrinterLib.INSTANCE.POS_Versao(buffer, bufferLen);
        checkResult(ret);

        return fromUTF8(buffer, bufferLen.getValue());
    }

    public void configLer() throws Exception {
        configLer("");
    }
    
    public void configLer(String eArqConfig) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_ConfigLer(toUTF8(eArqConfig));
        checkResult(ret);
    }

    public void ConfigImportar(String eArqConfig) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_ConfigImportar(toUTF8(eArqConfig));
        checkResult(ret);
    }

    public void configGravar() throws Exception {
        configGravar("");
    }

    public void configGravar(String eArqConfig) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_ConfigGravar(toUTF8(eArqConfig));
        checkResult(ret);
    }

    public String configLerValor(ACBrSessao eSessao, String eChave) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = PosPrinterLib.INSTANCE.POS_ConfigLerValor(toUTF8(eSessao.name()), toUTF8(eChave), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public void configGravarValor(ACBrSessao eSessao, String eChave, Object value) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_ConfigGravarValor(toUTF8(eSessao.name()), toUTF8(eChave), toUTF8(value.toString()));
        checkResult(ret);
    }

    public void ativar() throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_Ativar();
        checkResult(ret);
    }

    public void desativar() throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_Desativar();
        checkResult(ret);
    }

    public void zerar() throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_Zerar();
        checkResult(ret);
    }

    public void inicializar() throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_InicializarPos();
        checkResult(ret);
    }

    public void reset() throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_Reset();
        checkResult(ret);
    }

    public void pularLinhas() throws Exception {
        pularLinhas(0);
    }

    public void pularLinhas(int numLinhas) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_PularLinhas(numLinhas);
        checkResult(ret);
    }

    public void cortarPapel() throws Exception {
        cortarPapel(false);
    }

    public void cortarPapel(boolean parcial) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_CortarPapel(parcial);
        checkResult(ret);
    }

    public void abrirGaveta() throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_AbrirGaveta();
        checkResult(ret);
    }

    public String lerInfoImpressora() throws Exception {

        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = PosPrinterLib.INSTANCE.POS_LerInfoImpressora(buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public Set<ACBrPosTipoStatus> lerStatusImpressora() throws Exception {
        return lerStatusImpressora(1);
    }

    public Set<ACBrPosTipoStatus> lerStatusImpressora(int tentativas) throws Exception {
        IntByReference status = new IntByReference(0);
        int ret = PosPrinterLib.INSTANCE.POS_LerStatusImpressora(tentativas, status);
        checkResult(ret);

        return ACBrPosTipoStatus.valueOf(status.getValue());
    }

    public String[] retornarTags() throws Exception {
        return retornarTags(true);
    }

    public String[] retornarTags(boolean incluiAjuda) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = PosPrinterLib.INSTANCE.POS_RetornarTags(incluiAjuda, buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen).split("|");
    }
    
    public String[] AcharPortas() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = PosPrinterLib.INSTANCE.POS_AcharPortas(buffer, bufferLen);
        checkResult(ret);

        String portas = processResult(buffer, bufferLen);
        return Arrays.stream(portas.split("\\|"))
                     .filter(x -> !x.isBlank() && !x.isEmpty())
                     .toArray(String[]::new);
    }
    
    public void gravarLogoArquivo(String aPath) throws Exception {
        gravarLogoArquivo(aPath, -1, -1);
    }
    
    public void gravarLogoArquivo(String aPath, int nAKC1, int nAKC2) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_GravarLogoArquivo(toUTF8(aPath), nAKC1, nAKC2);
        checkResult(ret);
    }
    
    public void apagarLogo() throws Exception {
        apagarLogo(-1, -1);
    }
    
    public void apagarLogo(int nAKC1, int nAKC2) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_ApagarLogo(nAKC1, nAKC2);
        checkResult(ret);
    }
    
    public String leituraCheque() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);
                
        int ret = PosPrinterLib.INSTANCE.POS_LeituraCheque(buffer, bufferLen);
        
        checkResult(ret);
        return processResult(buffer, bufferLen);
    }
    
    public String lerCMC7(boolean AguardaCheque, int SegundosEspera) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);
                   
        int ret = PosPrinterLib.INSTANCE.POS_LerCMC7(AguardaCheque, SegundosEspera, buffer, bufferLen);
        checkResult(ret);
        return processResult(buffer, bufferLen);
    }
    
    public void EjetarCheque() throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_EjetarCheque();        
        checkResult(ret);
    }

    public boolean PodeLerDaPorta() throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_PodeLerDaPorta();
        checkResult(ret);
        return ret == 1;
    }
    
    public String LerCaracteristicas() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);
        
        int ret = PosPrinterLib.INSTANCE.POS_LerCaracteristicas(buffer, bufferLen);
        
        checkResult(ret);        
        return processResult(buffer, bufferLen);
    }

    public void imprimir(String aString) throws Exception {
        imprimir(aString, false, true, true, 1);
    }

    public void imprimir(String aString, boolean pulaLinha, boolean decodificarTags, boolean codificarPagina, int copias) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_Imprimir(toUTF8(aString), pulaLinha, decodificarTags, codificarPagina, copias);
        checkResult(ret);
    }

    public void imprimirLinha(String aString) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_ImprimirLinha(toUTF8(aString));
        checkResult(ret);
    }

    public void imprimirCmd(String aString) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_ImprimirCmd(toUTF8(aString));
        checkResult(ret);
    }

    public void imprimirTags() throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_ImprimirTags();
        checkResult(ret);
    }
    
    public void imprimirImagemArquivo(String aPath) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_ImprimirImagemArquivo(toUTF8(aPath));
        checkResult(ret);
    }  
    
    public void imprimirLogo() throws Exception {
        imprimirLogo(-1, -1, -1, -1);
    }
    
    public void imprimirLogo(int nAKC1, int nAKC2, int nFatorX, int nFatorY) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_ImprimirLogo(nAKC1, nAKC2, nFatorX, nFatorY);
        checkResult(ret);
    }  
    
    public void imprimirCheque(int CodBanco, Double AValor, Date ADataEmissao, String AFavorecido,
            String ACidade, String AComplemento, boolean LerCMC7, int SegundosEspera) throws Exception {
                
        String valor = String.valueOf(AValor);
        
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        String data = df.format(ADataEmissao);
        
        int ret = PosPrinterLib.INSTANCE.POS_ImprimirCheque(CodBanco, toUTF8(valor), toUTF8(data), toUTF8(AFavorecido), toUTF8(ACidade),
                                             toUTF8(AComplemento), LerCMC7, SegundosEspera);
        checkResult(ret);
    }

    public void imprimirTextoCheque(int X, int Y, String AString, boolean AguardaCheque, int SegundosEspera) throws Exception {
        int ret = PosPrinterLib.INSTANCE.POS_ImprimirTextoCheque(X, Y, toUTF8(AString), AguardaCheque, SegundosEspera);
        checkResult(ret);
    }

    public String txRx(String aString) throws Exception {
        return txRx(aString, (byte) 1, 500, false);
    }

    public String txRx(String aString, byte bytesToRead, int aTimeOut, boolean waitForTerminator) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = PosPrinterLib.INSTANCE.POS_TxRx(toUTF8(aString), bytesToRead, aTimeOut, waitForTerminator, buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String ConfigExportar() throws Exception {
		
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = PosPrinterLib.INSTANCE.POS_ConfigExportar(buffer, bufferLen);
        checkResult(ret);

        return fromUTF8(buffer, bufferLen.getValue());
		
    }
    
    @Override
    protected void UltimoRetorno(ByteBuffer buffer, IntByReference bufferLen) {
        PosPrinterLib.INSTANCE.POS_UltimoRetorno(buffer, bufferLen);
    }
}
