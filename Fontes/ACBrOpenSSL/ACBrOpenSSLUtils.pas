{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrOpenSSLUtils;

interface

uses
  Classes, SysUtils, ctypes, StrUtils,
  OpenSSLExt,
  ACBrConsts, ACBrBase;

resourcestring
  sErrDigstNotFound = 'Digest %s not found in OpenSSL';
  sErrFileNotInformed = 'FileName is empty';
  sErrFileNotExists = 'File: %s does not exists';
  sErrLoadingRSAKey = 'Error loading RSA Key';
  sErrSettingRSAKey = 'Error setting RSA Key';
  sErrGeneratingRSAKey = 'Error generating RSA Key';
  sErrKeyNotLoaded = '%s Key not Loaded';
  sErrLoadingKey = 'Error loading %s Key';
  sErrLoadingCertificate = 'Error loading %s Certificate';
  sErrParamIsEmpty = 'Param %s is Empty';
  sErrParamIsInvalid = 'Param %s has invalid value';
  sErrInvalidOpenSSHKey = 'OpenSSH Key is Invalid';

const
  CBufferSize = 32768;
  COpenSSHPrefix = 'ssh-rsa';
  CPrivate = 'Private';
  CPublic = 'Public';
  CPFX = 'PFX';

type
  TACBrOpenSSLDgst = ( dgstMD2, dgstMD4, dgstMD5, dgstRMD160, dgstSHA, dgstSHA1,
                       dgstSHA256, dgstSHA512);
  TACBrOpenSSLStrType = (outHexa, outBase64, outBinary);
  TACBrOpenSSLKeyBits = (bit512, bit1024, bit2048);

  TACBrOpenSSLOnProgress = procedure(const PosByte, TotalSize: int64) of object;

  EACBrOpenSSLException = class(Exception);

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}

  { TACBrOpenSSL }

  TACBrOpenSSL = class(TACBrComponent)
  private
    fVersion: String;
    fOldLib: Boolean;
    fBufferSize: Integer;
    fOnProgress: TACBrOpenSSLOnProgress;

    fEVP_PrivateKey: pEVP_PKEY;
    fEVP_PublicKey: pEVP_PKEY;
    fCertX509: pX509;

    function GetVersion: String;
    procedure SetBufferSize(AValue: Integer);

  private
    procedure FreeKeys;
    Procedure FreePrivateKey;
    Procedure FreePublicKey;
    procedure FreeCert;

    function IsOldLib: Boolean;
    procedure CheckFileExists(const AFile: String);
    procedure CheckPublicKeyIsLoaded;
    procedure CheckPrivateKeyIsLoaded;

    function GetEVPDigestByName(ADigest: TACBrOpenSSLDgst): PEVP_MD;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CalcHashFromStream(AStream: TStream; ADigest: TACBrOpenSSLDgst;
      OutputType: TACBrOpenSSLStrType = outHexa; Sign: Boolean = False): AnsiString;
    function CalcHashFromString(const AStr: AnsiString; ADigest: TACBrOpenSSLDgst;
      OutputType: TACBrOpenSSLStrType = outHexa; Sign: Boolean = False): AnsiString;
    function CalcHashFromFile(const AFile: String; ADigest: TACBrOpenSSLDgst;
      OutputType: TACBrOpenSSLStrType = outHexa; Sign: Boolean = False): AnsiString;

    function MD5FromFile(const AFile: String): String;
    function MD5FromString(const AString: AnsiString): String;

    function VerifyHashFromStream(AStream: TStream; ADigest: TACBrOpenSSLDgst;
      const AHash: AnsiString; HashType: TACBrOpenSSLStrType = outHexa;
      Signed: Boolean = False): Boolean;
    function VerifyHashFromString(const AStr: AnsiString; ADigest: TACBrOpenSSLDgst;
      const AHash: AnsiString; HashType: TACBrOpenSSLStrType = outHexa;
      Signed: Boolean = False): Boolean;
    function VerifyHashFromFile(const AFile: String; ADigest: TACBrOpenSSLDgst;
      const AHash: AnsiString; HashType: TACBrOpenSSLStrType = outHexa;
      Signed: Boolean = False): Boolean;

  public
    property BufferSize: Integer read fBufferSize write SetBufferSize default CBufferSize;
    property Version: String read GetVersion;

    procedure LoadPFXFromFile(const APFXFile: String; const Password: AnsiString = '');
    procedure LoadPFXFromStr(const APFXData: AnsiString; const Password: AnsiString = '');

    procedure LoadPrivateKeyFromFile(const APrivateKeyFile: String; const Password: AnsiString = '');
    procedure LoadPrivateKeyFromStr(const APrivateKey: AnsiString; const Password: AnsiString = '');
    procedure LoadPublicKeyFromFile(const APublicKeyFile: String);
    procedure LoadPublicKeyFromStr(const APublicKey: AnsiString);

    property OnProgress: TACBrOpenSSLOnProgress read fOnProgress write fOnProgress;
  end;

procedure InitOpenSSL;
procedure FreeOpenSSL;

// Genreral auxiliary functions
function OpenSSLFullVersion: String;
function BioToStr(ABio: pBIO): AnsiString;

// Key functions
procedure ExtractModulusAndExponentFromKey(AKey: PEVP_PKEY;
  out Modulus: String; out Exponent: String);
procedure SetModulusAndExponentToKey(AKey: PEVP_PKEY;
  const Modulus: String; const Exponent: String);

function ConvertKeyToOpenSSH(APubKey: PEVP_PKEY): String;
procedure SetOpenSSHToKey(APubKey: PEVP_PKEY; const AOpenSSHKey: String);

function PublicKeyToString(APubKey: PEVP_PKEY): String;
function PrivateKeyToString(APrivKey: PEVP_PKEY; const Password: AnsiString = ''): String;

procedure GenerateKeyPair(out APrivateKey: String; out APublicKey: String;
  const Password: AnsiString = ''; KeyBits: TACBrOpenSSLKeyBits = bit1024);
function PasswordCallback(buf:PAnsiChar; size:Integer; rwflag:Integer; userdata: Pointer):Integer; cdecl;

// Internal auxiliary functions
function OpenSSLDgstToStr(ADigest: TACBrOpenSSLDgst): String;
function ConvertToStrType(ABinaryStr: AnsiString;
  OutputType: TACBrOpenSSLStrType = outHexa): AnsiString;
function ConvertFromStrType(ABinaryStr: AnsiString;
  InputType: TACBrOpenSSLStrType = outHexa): AnsiString;

var
  OpenSSLLoaded: Boolean;

implementation

uses
  Math, TypInfo,
  synacode, synafpc, synautil,
  ACBrUtil;

procedure InitOpenSSL;
begin
  if OpenSSLLoaded then
    exit;

  OpenSSL_add_all_algorithms;
  OpenSSL_add_all_ciphers;
  OpenSSL_add_all_digests;
  ERR_load_crypto_strings;

  OpenSSLLoaded := True;
end;

procedure FreeOpenSSL;
begin
  if not OpenSSLLoaded then
    exit;

  EVPcleanup();
  OpenSSLLoaded := False;
end;

// Genreral auxiliary functions

function OpenSSLFullVersion: String;
var
  n: clong;
  s: String;
  ps, pe: Integer;
begin
  InitOpenSSL;
  Result := '';
  n := OpenSSLExt.OpenSSLVersionNum;
  if (n > 0) then
  begin
    s := IntToHex(n, 9);
    Result := copy(s, 1, 2) + '.' + copy(s, 3, 2) + '.' + copy(s, 5, 2) + '.' + copy(s, 7, 10);
  end
  else
  begin
    s := String(OpenSSLExt.OpenSSLVersion(0));
    ps := pos(' ', s);
    if (ps > 0) then
    begin
      pe := PosEx(' ', s, ps + 1);
      if (pe = 0) then
        pe := Length(s);
      Result := Trim(copy(s, ps, pe - ps));
    end;
  end;
end;

function BioToStr(ABio: pBIO): AnsiString;
Var
  n: Integer ;
  s: AnsiString ;
begin
  Result := '';
  SetLength(s, 1024);
  repeat
    n := BioRead(ABio, s, 1024);
    if (n > 0) then
      Result := Result + copy(s,1,n);
  until (n <= 0);
end;

// Key functions

procedure ExtractModulusAndExponentFromKey(AKey: PEVP_PKEY; out
  Modulus: String; out Exponent: String);
Var
  bio: pBIO;
  RsaKey: pRSA;
begin
  InitOpenSSL;
  Modulus := '';
  Exponent := '';
  bio := BioNew(BioSMem);
  RsaKey := EvpPkeyGet1RSA(AKey);
  try
    if (RsaKey = Nil) then
      raise EACBrOpenSSLException.Create(sErrLoadingRSAKey);
    BN_print(bio, RsaKey^.e);
    Modulus := String(BioToStr(bio));
    BIOReset(bio);
    BN_print(bio, RsaKey^.d);
    Exponent := String(BioToStr(bio));
  finally
    if (RsaKey <> Nil) then
      RSA_free(RsaKey);
    BioFreeAll(bio);
  end ;
end;

procedure SetModulusAndExponentToKey(AKey: PEVP_PKEY; const Modulus: String;
  const Exponent: String);
var
  e, m: AnsiString;
  bnMod, bnExp: PBIGNUM;
  rsa: pRSA ;
  err: longint ;
begin
  InitOpenSSL;
  m := Trim(Modulus);
  e := Trim(Exponent);

  if (m = '') then
    raise EACBrOpenSSLException.CreateFmt(sErrParamIsEmpty, ['Modulus']) ;
  if (e = '') then
    raise EACBrOpenSSLException.CreateFmt(sErrParamIsEmpty, ['Exponent']) ;

  bnExp := BN_new();
  err := BN_hex2bn(bnExp, PAnsiChar(e));
  if (err < 1) then
    raise EACBrOpenSSLException.CreateFmt(sErrParamIsInvalid, ['Exponent']) ;
  bnMod := BN_new();
  err := BN_hex2bn( bnMod, PAnsiChar(m) );
  if err < 1 then
    raise EACBrOpenSSLException.CreateFmt(sErrParamIsInvalid, ['Modulus']) ;

  rsa := EvpPkeyGet1RSA(AKey);   //TODO: Check for Memory leak
  if (rsa = Nil) then
    rsa := RSA_new;
  rsa^.e := bnMod;
  rsa^.d := bnExp;
  err := EvpPkeyAssign(AKey, EVP_PKEY_RSA, rsa);
  if (err < 1) then
    raise EACBrOpenSSLException.Create(sErrSettingRSAKey);
end;

// https://www.netmeister.org/blog/ssh2pkcs8.html
function ConvertKeyToOpenSSH(APubKey: PEVP_PKEY): String;
  function EncodeHexaSSH(const HexaStr: String): AnsiString;
  var
    l: Integer;
    s: String;
  begin
    l := Length(HexaStr);
    if odd(l) then
    begin
      s := '0'+HexaStr;
      Inc(l);
    end
    else
      s := HexaStr;

    Result := IntToBEStr(Trunc(l/2), 4) + HexToAsciiDef(s, ' ');
  end;
Var
  s, m, e: AnsiString;
begin
  ExtractModulusAndExponentFromKey(APubKey, m, e);

  s := EncodeHexaSSH(AsciiToHex(COpenSSHPrefix)) +
       EncodeHexaSSH(e) +
       EncodeHexaSSH('00' + m);

  Result := COpenSSHPrefix+' '+EncodeBase64(s);
end;

procedure SetOpenSSHToKey(APubKey: PEVP_PKEY; const AOpenSSHKey: String);
  function ReadChunk(s: AnsiString; var p: Integer): AnsiString;
  var
    l: Integer;
  begin
    l := BEStrToInt(copy(s,P,4));
    Result := Copy(s, P+4, l);
    p := p+4+l;
  end;
var
  s, m, e: AnsiString;
  ps, pe: Integer;
  Bio: PBIO;
begin
  ps := pos(' ', AOpenSSHKey);
  pe := PosEx(' ', AOpenSSHKey, ps+1);
  if (pe = 0) then
    pe := Length(AOpenSSHKey)+1;

  s := DecodeBase64( copy(AOpenSSHKey, ps+1, pe-ps-1) );
  ps := 1;
  if (ReadChunk(s, ps) <> COpenSSHPrefix) then
    raise EACBrOpenSSLException.Create(sErrInvalidOpenSSHKey);
  e := AsciiToHex(ReadChunk(s, ps));
  m := AsciiToHex(ReadChunk(s, ps));

  SetModulusAndExponentToKey(APubKey, m, e);
end;

function PublicKeyToString(APubKey: PEVP_PKEY): String;
var
  bio: PBIO;
begin
  Result := '';
  bio := BioNew(BioSMem);
  try
    if (PEM_write_bio_PUBKEY(bio, APubKey) = 1) then
      Result := String(BioToStr(bio));
  finally
    BioFreeAll(bio);
  end ;
end;

function PrivateKeyToString(APrivKey: PEVP_PKEY; const Password: AnsiString
  ): String;
var
  bio: PBIO;
  rsa: pRSA;
begin
  Result := '';
  bio := BioNew(BioSMem);
  try
    rsa := EvpPkeyGet1RSA(APrivKey);
    if (PEM_write_bio_RSAPrivateKey( bio, rsa, nil,
                                     PAnsiChar(Password),
                                     Length(Password),
                                     nil, nil) = 1) then
      Result := String(BioToStr(bio));
  finally
    if (rsa <> Nil) then
      RSA_free(rsa);
    BioFreeAll(bio);
  end ;
end;

procedure GenerateKeyPair(out APrivateKey: String; out APublicKey: String;
  const Password: AnsiString; KeyBits: TACBrOpenSSLKeyBits);
Var
  rsa: pRSA ;
  bits: LongInt;
  key: PEVP_PKEY;
begin
  InitOpenSSL;
  // Creating RSA Keys
  case KeyBits of
    bit512: bits := 512;
    bit2048: bits := 2048;
  else
    bits := 1024;
  end;
  rsa := RsaGenerateKey(bits, RSA_F4, nil, nil);
  if (rsa = nil) then
    raise EACBrOpenSSLException.Create(sErrGeneratingRSAKey);

  key := EvpPkeynew;
  try
    EvpPkeyAssign(key, EVP_PKEY_RSA, rsa);
    APrivateKey := PrivateKeyToString(key, Password);
    APublicKey := PublicKeyToString(key);
  finally
    EVP_PKEY_free(key);
  end;
end;

function PasswordCallback(buf:PAnsiChar; size:Integer; rwflag:Integer; userdata: Pointer):Integer; cdecl;
var
  Password: AnsiString;
begin
  Password := PAnsiChar(userdata);
  Result := Length(Password);
  synafpc.StrLCopy(buf, PAnsiChar(Password+#0), Result+1);
end;


// Internal auxiliary functions

function OpenSSLDgstToStr(ADigest: TACBrOpenSSLDgst): String;
begin
  case ADigest of
    dgstMD2: Result := 'md2';
    dgstMD4: Result := 'md4';
    dgstMD5: Result := 'md5';
    dgstRMD160: Result := 'rmd160';
    dgstSHA: Result := 'sha';
    dgstSHA1: Result := 'sha1';
    dgstSHA256: Result := 'sha256';
    dgstSHA512: Result := 'sha512';
    else
      Result := '';
  end;
end;

function ConvertToStrType(ABinaryStr: AnsiString;
  OutputType: TACBrOpenSSLStrType): AnsiString;
begin
  case OutputType of
    outBase64: Result := Trim(EncodeBase64(ABinaryStr));
    outHexa: Result := AsciiToHex(ABinaryStr);
  else
    Result := ABinaryStr;
  end;
end;

function ConvertFromStrType(ABinaryStr: AnsiString;
  InputType: TACBrOpenSSLStrType): AnsiString;
begin
  case InputType of
    outBase64: Result := DecodeBase64(ABinaryStr);
    outHexa: Result := HexToAscii(ABinaryStr);
  else
    Result := ABinaryStr;
  end;
end;

{ TACBrOpenSSL }

constructor TACBrOpenSSL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fVersion := '';
  fOldLib := False;
  fBufferSize := CBufferSize;

  fOnProgress := Nil;
  fEVP_PrivateKey := Nil;
  fEVP_PublicKey := Nil;
  fCertX509 := Nil;
end;

destructor TACBrOpenSSL.Destroy;
begin
  inherited Destroy;
end;

function TACBrOpenSSL.CalcHashFromStream(AStream: TStream; ADigest: TACBrOpenSSLDgst;
  OutputType: TACBrOpenSSLStrType; Sign: Boolean): AnsiString;
var
  s: AnsiString;
  md: PEVP_MD;
  md_len: cardinal;
  md_ctx: EVP_MD_CTX;
  pmd_ctx: PEVP_MD_CTX;
  md_value_bin: array [0..1023] of AnsiChar;
  buffer: Pointer;
  p: int64;
  b: longint;
begin
  InitOpenSSL;
  if Sign then
    CheckPrivateKeyIsLoaded;

  pmd_ctx := nil;
  GetMem(buffer, fBufferSize);
  try
    md := GetEVPDigestByName(ADigest);
    if IsOldLib then
      pmd_ctx := @md_ctx
    else
      pmd_ctx := EVP_MD_CTX_new();
    EVP_DigestInit(pmd_ctx, md);

    p := 0;
    AStream.Position := 0;
    if Assigned(fOnProgress) then
      fOnProgress(p, AStream.Size);
    while (p < AStream.Size) do
    begin
      b := AStream.Read(buffer^, BufferSize);
      if (b <= 0) then
        Break;
      EVP_DigestUpdate(pmd_ctx, buffer, b);
      Inc(p, b);
      if Assigned(fOnProgress) then
        fOnProgress(p, AStream.Size);
    end;

    md_len := 0;
    if Sign then
      EVP_SignFinal(pmd_ctx, @md_value_bin, md_len, fEVP_PrivateKey)
    else
      EVP_DigestFinal(pmd_ctx, @md_value_bin, @md_len);

    s := '';
    SetString(s, md_value_bin, md_len);
    Result := ConvertToStrType(s, OutputType);
  finally
    if (not IsOldLib) and (pmd_ctx <> nil) then
      EVP_MD_CTX_free(pmd_ctx);

    Freemem(buffer);
  end;
end;

function TACBrOpenSSL.CalcHashFromString(const AStr: AnsiString;
  ADigest: TACBrOpenSSLDgst; OutputType: TACBrOpenSSLStrType; Sign: Boolean
  ): AnsiString;
Var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    ms.Write(Pointer(AStr)^, Length(AStr));
    Result := CalcHashFromStream(ms, ADigest, OutputType, Sign);
  finally
    ms.Free ;
  end ;
end;

function TACBrOpenSSL.CalcHashFromFile(const AFile: String;
  ADigest: TACBrOpenSSLDgst; OutputType: TACBrOpenSSLStrType; Sign: Boolean
  ): AnsiString;
Var
  fs: TFileStream ;
begin
  CheckFileExists(AFile);
  fs := TFileStream.Create(AFile, fmOpenRead or fmShareDenyWrite);
  try
    Result := CalcHashFromStream(fs, ADigest, OutputType, Sign);
  finally
    fs.Free ;
  end ;
end;

function TACBrOpenSSL.MD5FromFile(const AFile: String): String;
begin
  Result := String(CalcHashFromFile(AFile, dgstMD5));
end;

function TACBrOpenSSL.MD5FromString(const AString: AnsiString): String;
begin
  Result := String(CalcHashFromString(AString, dgstMD5));
end;

function TACBrOpenSSL.VerifyHashFromStream(AStream: TStream; ADigest: TACBrOpenSSLDgst;
  const AHash: AnsiString; HashType: TACBrOpenSSLStrType; Signed: Boolean
  ): Boolean;
Var
  s, h: AnsiString;
  md : PEVP_MD ;
  md_len: cardinal;
  md_ctx: EVP_MD_CTX;
  pmd_ctx: PEVP_MD_CTX;
  md_value_bin : array [0..1023] of AnsiChar;
  buffer: Pointer;
  p: Int64;
  b: LongInt;
begin
  InitOpenSSL;
  if Signed then
    CheckPublicKeyIsLoaded;

  pmd_ctx := Nil;
  GetMem(buffer, CBufferSize);
  try
    md := GetEVPDigestByName(ADigest);
    if IsOldLib then
      pmd_ctx := @md_ctx
    else
      pmd_ctx := EVP_MD_CTX_new();
    EVP_DigestInit(pmd_ctx, md);

    p := 0;
    AStream.Position := 0;
    if Assigned(fOnProgress) then
      fOnProgress(p, AStream.Size);
    while (p < AStream.Size) do
    begin
      b := AStream.Read(buffer^, CBufferSize);
      if (b <= 0) then
        Break;
      EVP_DigestUpdate(pmd_ctx, buffer, b);
      Inc(p, b);
      if Assigned(fOnProgress) then
        fOnProgress(p, AStream.Size);
    end;

    h := ConvertFromStrType(AHash, HashType);
    if Signed then
      Result := (EVP_VerifyFinal(pmd_ctx, PAnsiChar(h), Length(h), fEVP_PublicKey) = 1)
    else
    begin
      md_len := 0;
      EVP_DigestFinal(pmd_ctx, @md_value_bin, @md_len);
      SetString(s, md_value_bin, md_len);
      Result := (Pos(s, h) > 0);
    end;
  finally
    if (not IsOldLib) and (pmd_ctx <> nil) then
      EVP_MD_CTX_free(pmd_ctx);

    Freemem(buffer);
  end;
end;

function TACBrOpenSSL.VerifyHashFromString(const AStr: AnsiString;
  ADigest: TACBrOpenSSLDgst; const AHash: AnsiString;
  HashType: TACBrOpenSSLStrType; Signed: Boolean): Boolean;
Var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    ms.Write(Pointer(AStr)^, Length(AStr));
    Result := VerifyHashFromStream(ms, ADigest, AHash, HashType, Signed);
  finally
    ms.Free ;
  end ;
end;

function TACBrOpenSSL.VerifyHashFromFile(const AFile: String;
  ADigest: TACBrOpenSSLDgst; const AHash: AnsiString;
  HashType: TACBrOpenSSLStrType; Signed: Boolean): Boolean;
Var
  fs: TFileStream ;
begin
  CheckFileExists(AFile);
  fs := TFileStream.Create(AFile, fmOpenRead or fmShareDenyWrite);
  try
    Result := VerifyHashFromStream(fs, ADigest, AHash, HashType, Signed);
  finally
    fs.Free ;
  end ;
end;

procedure TACBrOpenSSL.LoadPFXFromFile(const APFXFile: String;
  const Password: AnsiString);
Var
  fs: TFileStream ;
  s: AnsiString;
begin
  CheckFileExists(APFXFile);
  fs := TFileStream.Create(APFXFile, fmOpenRead or fmShareDenyWrite);
  try
    fs.Position := 0;
    s := ReadStrFromStream(fs, fs.Size);
    LoadPFXFromStr(s, Password);
  finally
    fs.Free ;
  end ;
end;

procedure TACBrOpenSSL.LoadPFXFromStr(const APFXData: AnsiString;
  const Password: AnsiString);
var
  ca, p12: Pointer;
  bio: PBIO;
begin
  FreeKeys;
  FreeCert;
  bio := BioNew(BioSMem);
  try
    BioWrite(bio, APFXData, Length(APFXData));
    p12 := d2iPKCS12bio(bio, nil);
    if not Assigned(p12) then
      raise EACBrOpenSSLException.CreateFmt(sErrLoadingCertificate, [CPFX]);

    try
      ca := nil;
      if (PKCS12parse(p12, Password, fEVP_PrivateKey, fCertX509, ca) <= 0) then
        raise EACBrOpenSSLException.CreateFmt(sErrLoadingCertificate, [CPFX]);
    finally
      PKCS12free(p12);
    end;
  finally
    BioFreeAll(bio);
  end;
end;

procedure TACBrOpenSSL.LoadPrivateKeyFromFile(const APrivateKeyFile: String;
  const Password: AnsiString);
Var
  fs: TFileStream ;
  s: AnsiString;
begin
  CheckFileExists(APrivateKeyFile);
  fs := TFileStream.Create(APrivateKeyFile, fmOpenRead or fmShareDenyWrite);
  try
    fs.Position := 0;
    s := ReadStrFromStream(fs, fs.Size);
    LoadPrivateKeyFromStr(s, Password);
  finally
    fs.Free ;
  end ;
end;

procedure TACBrOpenSSL.LoadPrivateKeyFromStr(const APrivateKey: AnsiString;
  const Password: AnsiString);
var
  bio: pBIO;
  buf: AnsiString;
begin
  InitOpenSSL ;
  FreePrivateKey;

  buf := AnsiString(ChangeLineBreak(Trim(APrivateKey), LF));  // Use Linux LineBreak
  bio := BIO_new_mem_buf(PAnsiChar(buf), Length(buf)+1) ;
  try
    fEVP_PrivateKey := PEM_read_bio_PrivateKey(bio, nil, @PasswordCallback, PAnsiChar(Password))
  finally
    BioFreeAll(bio);
  end ;

  if (fEVP_PrivateKey = nil) then
    raise EACBrOpenSSLException.CreateFmt(sErrLoadingKey, [CPrivate]);
end;

procedure TACBrOpenSSL.LoadPublicKeyFromFile(const APublicKeyFile: String);
Var
  fs: TFileStream ;
  s: AnsiString;
begin
  CheckFileExists(APublicKeyFile);
  fs := TFileStream.Create(APublicKeyFile, fmOpenRead or fmShareDenyWrite);
  try
    fs.Position := 0;
    s := ReadStrFromStream(fs, fs.Size);
    LoadPublicKeyFromStr(s);
  finally
    fs.Free ;
  end ;
end;

procedure TACBrOpenSSL.LoadPublicKeyFromStr(const APublicKey: AnsiString);
var
  bio: pBIO;
  buf: AnsiString;
  x: pEVP_PKEY;
begin
  InitOpenSSL ;
  FreePrivateKey;

  buf := AnsiString(ChangeLineBreak(Trim(APublicKey), LF));  // Use Linux LineBreak
  bio := BIO_new_mem_buf(PAnsiChar(buf), Length(buf)+1) ;
  try
    x := Nil;
    fEVP_PublicKey := PEM_read_bio_PUBKEY(bio, x, nil, nil) ;
  finally
    BioFreeAll(bio);
  end ;

  if (fEVP_PublicKey = nil) then
    raise EACBrOpenSSLException.CreateFmt(sErrLoadingKey, [CPublic]);
end;

function TACBrOpenSSL.GetEVPDigestByName(ADigest: TACBrOpenSSLDgst): PEVP_MD;
var
  s: AnsiString;
begin
  s := OpenSSLDgstToStr(ADigest);
  Result := EVP_get_digestbyname(PAnsiChar(s));
  if (Result = nil) then
    raise EACBrOpenSSLException.CreateFmt(sErrDigstNotFound,
      [GetEnumName(TypeInfo(TACBrOpenSSLDgst), Integer(ADigest))]);
end;

function TACBrOpenSSL.GetVersion: String;
begin
  InitOpenSSL;
  if (fVersion = '') then
  begin
    fVersion := OpenSSLFullVersion;
    fOldLib := (CompareVersions(fVersion, '1.1.0') < 0);
  end;
  Result := fVersion;
end;

function TACBrOpenSSL.IsOldLib: Boolean;
begin
  GetVersion;
  Result := fOldLib;
end;

procedure TACBrOpenSSL.CheckFileExists(const AFile: String);
var
  s: String;
begin
  s := Trim(AFile);
  if (s = '') then
    raise EACBrOpenSSLException.Create(sErrFileNotInformed);

  if not FileExists(s) then
    raise EACBrOpenSSLException.CreateFmt(sErrFileNotExists, [s]);
end;

procedure TACBrOpenSSL.CheckPublicKeyIsLoaded;
begin
  if (not Assigned(fEVP_PublicKey)) and Assigned(fEVP_PrivateKey) then
    LoadPublicKeyFromStr(PublicKeyToString(fEVP_PrivateKey));

  if not Assigned(fEVP_PublicKey) then
    raise EACBrOpenSSLException.CreateFmt(sErrKeyNotLoaded, [CPublic]);
end;

procedure TACBrOpenSSL.CheckPrivateKeyIsLoaded;
begin
  if not Assigned(fEVP_PrivateKey) then
    raise EACBrOpenSSLException.CreateFmt(sErrKeyNotLoaded, [CPrivate]);
end;

procedure TACBrOpenSSL.SetBufferSize(AValue: Integer);
begin
  if fBufferSize = AValue then
    Exit;

  fBufferSize := max(1024, AValue);
end;

procedure TACBrOpenSSL.FreeKeys;
begin
  FreePrivateKey;
  FreePublicKey;
end;

procedure TACBrOpenSSL.FreePrivateKey;
begin
  if (fEVP_PrivateKey <> Nil) then
  begin
    EVP_PKEY_free(fEVP_PrivateKey);
    fEVP_PrivateKey := Nil;
  end ;
end;

procedure TACBrOpenSSL.FreePublicKey;
begin
  if (fEVP_PublicKey <> Nil) then
  begin
    EVP_PKEY_free(fEVP_PublicKey);
    fEVP_PublicKey := Nil;
  end ;
end;

procedure TACBrOpenSSL.FreeCert;
begin
  if (fCertX509 <> Nil) then
  begin
    X509free(fCertX509);
    fCertX509 := Nil;
  end;
end;

initialization
  OpenSSLLoaded := False;

finalization
  FreeOpenSSL;

end.

property KeyPassword: String read fKeyPassword write fKeyPassword;

property PFXFile: String read fPFXFile write fPFXFile;
property CertificateFile: String read fCertificateFile write fCertificateFile;
property PrivateKeyFile: String read fPrivateKeyFile write fPrivateKeyFile;
property PublicKeyFile: String read fPublicKeyFile write fPublicKeyFile;

property PFXStr: AnsiString read fPFXStr write fPFXStr;
property CertificateStr: AnsiString read fCertificateStr write fCertificateStr;
property PrivateKeyStr: AnsiString read fPrivateKeyStr write fPrivateKeyStr;
property PublicKeyStr: AnsiString read fPublicKeyStr write fPublicKeyStr;

fCertificateFile: String;
fCertificateStr: AnsiString;
fPFXFile: String;
fPFXStr: AnsiString;
fPrivateKeyFile: String;
fPrivateKeyStr: AnsiString;
fPublicKeyFile: String;
fPublicKeyStr: AnsiString;

fKeyPassword := '';
fCertificateFile := '';
fCertificateStr := '';
fPFXFile := '';
fPFXStr := '';
fPrivateKeyFile := '';
fPrivateKeyStr := '';
fPublicKeyFile := '';
fPublicKeyStr := '';

