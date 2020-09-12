VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Object = "{C932BA88-4374-101B-A56C-00AA003668DC}#1.1#0"; "MSMASK32.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form FrmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "ACBrLibSat Demo - Visual Basic 6"
   ClientHeight    =   6480
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   11280
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "FrmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6480
   ScaleWidth      =   11280
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton btnAtivarSAT 
      Caption         =   "Ativar SAT"
      Height          =   360
      Left            =   1800
      TabIndex        =   87
      Top             =   3240
      Width           =   1590
   End
   Begin VB.CommandButton cmdCancelarCFe 
      Caption         =   "Cancelar CFe"
      Height          =   360
      Left            =   1800
      TabIndex        =   86
      Top             =   4680
      Width           =   1590
   End
   Begin VB.CommandButton cmdImprimirCFeCanc 
      Caption         =   "Imprimir CFe Canc"
      Height          =   360
      Left            =   1800
      TabIndex        =   85
      Top             =   5640
      Width           =   1590
   End
   Begin VB.CommandButton cmdConsultarStatus 
      Caption         =   "Consultar Status"
      Height          =   360
      Left            =   1800
      TabIndex        =   84
      Top             =   3720
      Width           =   1590
   End
   Begin VB.CommandButton cmdConsultarSAT 
      Caption         =   "Consultar SAT"
      Height          =   360
      Left            =   120
      TabIndex        =   83
      Top             =   3720
      Width           =   1590
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   3840
      Top             =   4200
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton btnImprimirPDFCFe 
      Caption         =   "Imprimir PDF CFe"
      Height          =   360
      Left            =   120
      TabIndex        =   28
      Top             =   5640
      Width           =   1590
   End
   Begin VB.CommandButton btnImprimiCFeRed 
      Caption         =   "imprimir CFe Red."
      Height          =   360
      Left            =   1800
      TabIndex        =   27
      Top             =   5160
      Width           =   1590
   End
   Begin VB.CommandButton btnImprimirCFe 
      Caption         =   "Imprimir CFe"
      Height          =   360
      Left            =   120
      TabIndex        =   26
      Top             =   5160
      Width           =   1590
   End
   Begin VB.CommandButton btnEnviarCFe 
      Caption         =   "Enviar CFe"
      Height          =   360
      Left            =   120
      TabIndex        =   25
      Top             =   4680
      Width           =   1590
   End
   Begin VB.CommandButton btnCriarEnviarCFe 
      Caption         =   "Criar Enviar CFe"
      Height          =   360
      Left            =   1800
      TabIndex        =   24
      Top             =   4200
      Width           =   1590
   End
   Begin VB.CommandButton btnCriarCFe 
      Caption         =   "Criar CFe"
      Height          =   360
      Left            =   120
      TabIndex        =   23
      Top             =   4200
      Width           =   1590
   End
   Begin VB.CommandButton btnIniDesini 
      Caption         =   "Inicializar"
      Height          =   360
      Left            =   120
      TabIndex        =   22
      Top             =   3240
      Width           =   1590
   End
   Begin TabDlg.SSTab SSTTab0 
      Height          =   3015
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Width           =   11175
      _ExtentX        =   19711
      _ExtentY        =   5318
      _Version        =   393216
      Style           =   1
      TabHeight       =   520
      TabCaption(0)   =   "Configura��o CFe"
      TabPicture(0)   =   "FrmMain.frx":25CA
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "lblNomeDll"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "lblModelo"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "lblCodigoDe"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "lblVers�o"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "lblPaginaDe"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).Control(5)=   "lblSignAC"
      Tab(0).Control(5).Enabled=   0   'False
      Tab(0).Control(6)=   "Label2"
      Tab(0).Control(6).Enabled=   0   'False
      Tab(0).Control(7)=   "Label3"
      Tab(0).Control(7).Enabled=   0   'False
      Tab(0).Control(8)=   "txtDllPath"
      Tab(0).Control(8).Enabled=   0   'False
      Tab(0).Control(9)=   "btnSelDll"
      Tab(0).Control(9).Enabled=   0   'False
      Tab(0).Control(10)=   "cmbModeloSat"
      Tab(0).Control(10).Enabled=   0   'False
      Tab(0).Control(11)=   "txtAtivacao"
      Tab(0).Control(11).Enabled=   0   'False
      Tab(0).Control(12)=   "txtPaginaCodigo"
      Tab(0).Control(12).Enabled=   0   'False
      Tab(0).Control(13)=   "nudPaginaCodigo"
      Tab(0).Control(13).Enabled=   0   'False
      Tab(0).Control(14)=   "FraSalvarXMLs"
      Tab(0).Control(14).Enabled=   0   'False
      Tab(0).Control(15)=   "txtSignAC"
      Tab(0).Control(15).Enabled=   0   'False
      Tab(0).Control(16)=   "txtVersaoCFe"
      Tab(0).Control(16).Enabled=   0   'False
      Tab(0).Control(17)=   "txtCNPJContribuinte"
      Tab(0).Control(17).Enabled=   0   'False
      Tab(0).Control(18)=   "txtCodEstFederacao"
      Tab(0).Control(18).Enabled=   0   'False
      Tab(0).ControlCount=   19
      TabCaption(1)   =   "Impress�o"
      TabPicture(1)   =   "FrmMain.frx":25E6
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "Label1"
      Tab(1).Control(1)=   "lblNCopias"
      Tab(1).Control(2)=   "lblSoftwareHouse"
      Tab(1).Control(3)=   "lblImpressora"
      Tab(1).Control(4)=   "lblSite"
      Tab(1).Control(5)=   "nudCopias"
      Tab(1).Control(6)=   "cmbImpressao"
      Tab(1).Control(7)=   "txtCopias"
      Tab(1).Control(8)=   "FraEscPos"
      Tab(1).Control(9)=   "txtSoftwareHouse"
      Tab(1).Control(10)=   "cbbImpressora"
      Tab(1).Control(11)=   "txtSite"
      Tab(1).Control(12)=   "chkPreview"
      Tab(1).Control(13)=   "chkSetup"
      Tab(1).Control(14)=   "chkUsaCodigoEanImpressao"
      Tab(1).Control(15)=   "chkImprimeEmUmaLinha"
      Tab(1).ControlCount=   16
      TabCaption(2)   =   "Email"
      TabPicture(2)   =   "FrmMain.frx":2602
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "lblNome"
      Tab(2).Control(1)=   "lblEmail"
      Tab(2).Control(2)=   "lblUsu�rio"
      Tab(2).Control(3)=   "lblSenha"
      Tab(2).Control(4)=   "lblHostSMTP"
      Tab(2).Control(5)=   "lblPortaMail"
      Tab(2).Control(6)=   "nudPorta"
      Tab(2).Control(7)=   "txtNome"
      Tab(2).Control(8)=   "txtEmail"
      Tab(2).Control(9)=   "txtUsuario"
      Tab(2).Control(10)=   "txtSenha"
      Tab(2).Control(11)=   "txtHost"
      Tab(2).Control(12)=   "txtPorta"
      Tab(2).Control(13)=   "ckbSSL"
      Tab(2).Control(14)=   "ckbTLS"
      Tab(2).ControlCount=   15
      Begin VB.TextBox txtCodEstFederacao 
         Height          =   315
         Left            =   4560
         TabIndex        =   91
         Text            =   "35"
         Top             =   1920
         Width           =   2655
      End
      Begin VB.TextBox txtCNPJContribuinte 
         Height          =   315
         Left            =   120
         TabIndex        =   90
         Text            =   "11111111111111"
         Top             =   1920
         Width           =   4335
      End
      Begin VB.TextBox txtVersaoCFe 
         Alignment       =   1  'Right Justify
         Height          =   315
         Left            =   4560
         TabIndex        =   82
         Text            =   "0,07"
         Top             =   1320
         Width           =   1095
      End
      Begin VB.CheckBox ckbTLS 
         Caption         =   "TLS"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   -67200
         TabIndex        =   81
         Top             =   1320
         Width           =   1215
      End
      Begin VB.CheckBox ckbSSL 
         Caption         =   "SSL"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   -67200
         TabIndex        =   80
         Top             =   720
         Width           =   1335
      End
      Begin VB.TextBox txtPorta 
         Alignment       =   1  'Right Justify
         Height          =   315
         Left            =   -68520
         TabIndex        =   78
         Text            =   "0"
         Top             =   1920
         Width           =   960
      End
      Begin VB.TextBox txtHost 
         Height          =   315
         Left            =   -74880
         TabIndex        =   75
         Top             =   1920
         Width           =   6255
      End
      Begin VB.TextBox txtSenha 
         Height          =   315
         IMEMode         =   3  'DISABLE
         Left            =   -71040
         PasswordChar    =   "*"
         TabIndex        =   73
         Top             =   1320
         Width           =   3735
      End
      Begin VB.TextBox txtUsuario 
         Height          =   315
         Left            =   -71040
         TabIndex        =   71
         Top             =   720
         Width           =   3735
      End
      Begin VB.TextBox txtEmail 
         Height          =   315
         Left            =   -74880
         TabIndex        =   69
         Top             =   1320
         Width           =   3735
      End
      Begin VB.TextBox txtNome 
         Height          =   315
         Left            =   -74880
         TabIndex        =   67
         Top             =   720
         Width           =   3735
      End
      Begin VB.CheckBox chkImprimeEmUmaLinha 
         Caption         =   "Imprime Em Uma Linha"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   -72840
         TabIndex        =   44
         Top             =   2040
         Width           =   2415
      End
      Begin VB.CheckBox chkUsaCodigoEanImpressao 
         Caption         =   "Usar Codigo Ean"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   -72840
         TabIndex        =   43
         Top             =   1680
         Width           =   1695
      End
      Begin VB.CheckBox chkSetup 
         Caption         =   "Mostrar Setup"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   -74880
         TabIndex        =   42
         Top             =   2040
         Width           =   1695
      End
      Begin VB.CheckBox chkPreview 
         Caption         =   "Mostrar Preview"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   -74880
         TabIndex        =   41
         Top             =   1680
         Width           =   1695
      End
      Begin VB.TextBox txtSite 
         Height          =   315
         Left            =   -72840
         TabIndex        =   39
         Text            =   "http://www.projetoacbr.com.br"
         Top             =   1320
         Width           =   3735
      End
      Begin VB.ComboBox cbbImpressora 
         Height          =   315
         ItemData        =   "FrmMain.frx":261E
         Left            =   -70920
         List            =   "FrmMain.frx":2620
         TabIndex        =   37
         Text            =   "cbbImpressora"
         Top             =   720
         Width           =   1815
      End
      Begin VB.TextBox txtSoftwareHouse 
         Height          =   315
         Left            =   -72840
         TabIndex        =   35
         Text            =   "Projeto ACBr"
         Top             =   720
         Width           =   1815
      End
      Begin VB.Frame FraEscPos 
         Caption         =   "EscPos"
         Height          =   2055
         Left            =   -69000
         TabIndex        =   34
         Top             =   360
         Width           =   5055
         Begin VB.ComboBox cbbPortas 
            Height          =   315
            Left            =   120
            TabIndex        =   65
            Text            =   "cbbPortas"
            Top             =   1080
            Width           =   3135
         End
         Begin VB.ComboBox cbbPaginaCodigo 
            Height          =   315
            ItemData        =   "FrmMain.frx":2622
            Left            =   1680
            List            =   "FrmMain.frx":2624
            Style           =   2  'Dropdown List
            TabIndex        =   51
            Top             =   480
            Width           =   1455
         End
         Begin VB.CheckBox cbxIgnorarTags 
            Caption         =   "Ignorar Tags"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   3360
            TabIndex        =   50
            Top             =   960
            Width           =   1575
         End
         Begin VB.CheckBox cbxTraduzirTags 
            Caption         =   "Traduzir Tags"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   3360
            TabIndex        =   49
            Top             =   720
            Value           =   1  'Checked
            Width           =   1575
         End
         Begin VB.CheckBox cbxCortarPapel 
            Caption         =   "Cortar Papel"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   3360
            TabIndex        =   48
            Top             =   480
            Value           =   1  'Checked
            Width           =   1575
         End
         Begin VB.CheckBox cbxControlePorta 
            Caption         =   "Controle Porta"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   3360
            TabIndex        =   47
            Top             =   240
            Width           =   1575
         End
         Begin VB.ComboBox cbbModelo 
            Height          =   315
            ItemData        =   "FrmMain.frx":2626
            Left            =   120
            List            =   "FrmMain.frx":2628
            Style           =   2  'Dropdown List
            TabIndex        =   45
            Top             =   480
            Width           =   1455
         End
         Begin MSComCtl2.UpDown nudLinhasPular 
            Height          =   285
            Left            =   3360
            TabIndex        =   53
            Top             =   1680
            Width           =   255
            _ExtentX        =   450
            _ExtentY        =   503
            _Version        =   393216
            BuddyControl    =   "MasLinhasPular"
            BuddyDispid     =   196685
            OrigLeft        =   3120
            OrigTop         =   1680
            OrigRight       =   3375
            OrigBottom      =   1965
            Max             =   999
            SyncBuddy       =   -1  'True
            BuddyProperty   =   22
            Enabled         =   -1  'True
         End
         Begin MSMask.MaskEdBox MasLinhasPular 
            Height          =   285
            Left            =   2640
            TabIndex        =   54
            Top             =   1680
            Width           =   720
            _ExtentX        =   1270
            _ExtentY        =   503
            _Version        =   393216
            PromptInclude   =   0   'False
            MaxLength       =   3
            Format          =   "0"
            Mask            =   "###"
            PromptChar      =   "_"
         End
         Begin MSComCtl2.UpDown nudBuffer 
            Height          =   285
            Left            =   2265
            TabIndex        =   55
            Top             =   1680
            Width           =   255
            _ExtentX        =   450
            _ExtentY        =   503
            _Version        =   393216
            BuddyControl    =   "MasBuffer"
            BuddyDispid     =   196687
            OrigLeft        =   2280
            OrigTop         =   1680
            OrigRight       =   2535
            OrigBottom      =   1935
            Max             =   999
            SyncBuddy       =   -1  'True
            BuddyProperty   =   22
            Enabled         =   -1  'True
         End
         Begin MSMask.MaskEdBox MasBuffer 
            Height          =   285
            Left            =   1800
            TabIndex        =   56
            Top             =   1680
            Width           =   465
            _ExtentX        =   820
            _ExtentY        =   503
            _Version        =   393216
            PromptInclude   =   0   'False
            MaxLength       =   3
            Format          =   "0"
            Mask            =   "###"
            PromptChar      =   "_"
         End
         Begin MSComCtl2.UpDown nudEspacos 
            Height          =   285
            Left            =   1425
            TabIndex        =   57
            Top             =   1680
            Width           =   255
            _ExtentX        =   450
            _ExtentY        =   503
            _Version        =   393216
            BuddyControl    =   "MaskEspacos"
            BuddyDispid     =   196689
            OrigLeft        =   1320
            OrigTop         =   1680
            OrigRight       =   1575
            OrigBottom      =   1935
            Max             =   999
            SyncBuddy       =   -1  'True
            BuddyProperty   =   22
            Enabled         =   -1  'True
         End
         Begin MSMask.MaskEdBox MaskEspacos 
            Height          =   285
            Left            =   960
            TabIndex        =   58
            Top             =   1680
            Width           =   465
            _ExtentX        =   820
            _ExtentY        =   503
            _Version        =   393216
            PromptInclude   =   0   'False
            MaxLength       =   3
            Format          =   "0"
            Mask            =   "###"
            PromptChar      =   "_"
         End
         Begin MSMask.MaskEdBox MasColunas 
            Height          =   285
            Left            =   120
            TabIndex        =   59
            Top             =   1680
            Width           =   465
            _ExtentX        =   820
            _ExtentY        =   503
            _Version        =   393216
            PromptInclude   =   0   'False
            MaxLength       =   3
            Format          =   "0"
            Mask            =   "###"
            PromptChar      =   "_"
         End
         Begin MSComCtl2.UpDown nudColunas 
            Height          =   285
            Left            =   585
            TabIndex        =   60
            Top             =   1680
            Width           =   255
            _ExtentX        =   450
            _ExtentY        =   503
            _Version        =   393216
            BuddyControl    =   "MasColunas"
            BuddyDispid     =   196690
            OrigLeft        =   510
            OrigTop         =   1680
            OrigRight       =   765
            OrigBottom      =   1965
            Max             =   999
            SyncBuddy       =   -1  'True
            BuddyProperty   =   22
            Enabled         =   -1  'True
         End
         Begin VB.Label lblPorta 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "Porta"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   195
            Left            =   120
            TabIndex        =   66
            Top             =   840
            Width           =   465
         End
         Begin VB.Label lblColunas 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "Colunas"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   195
            Left            =   120
            TabIndex        =   64
            Top             =   1440
            Width           =   660
         End
         Begin VB.Label lblEspa�os 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "Espa�os"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   195
            Left            =   960
            TabIndex        =   63
            Top             =   1440
            Width           =   675
         End
         Begin VB.Label lblBuffer 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "Buffer"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   195
            Left            =   1800
            TabIndex        =   62
            Top             =   1440
            Width           =   510
         End
         Begin VB.Label lblLinhasPular 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "Linhas Pular"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   195
            Left            =   2640
            TabIndex        =   61
            Top             =   1440
            Width           =   1020
         End
         Begin VB.Label lblPagC�digo 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "Pag. C�digo"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   195
            Left            =   1680
            TabIndex        =   52
            Top             =   240
            Width           =   975
         End
         Begin VB.Label lblModeloEscPos 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "Modelo"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   195
            Left            =   120
            TabIndex        =   46
            Top             =   240
            Width           =   615
         End
      End
      Begin VB.TextBox txtCopias 
         Alignment       =   1  'Right Justify
         Height          =   315
         Left            =   -74880
         TabIndex        =   32
         Text            =   "1"
         Top             =   1320
         Width           =   1665
      End
      Begin VB.ComboBox cmbImpressao 
         Height          =   315
         ItemData        =   "FrmMain.frx":262A
         Left            =   -74880
         List            =   "FrmMain.frx":262C
         Style           =   2  'Dropdown List
         TabIndex        =   29
         Top             =   720
         Width           =   1935
      End
      Begin VB.TextBox txtSignAC 
         Height          =   315
         Left            =   120
         TabIndex        =   21
         Text            =   "123456"
         Top             =   2520
         Width           =   7095
      End
      Begin VB.Frame FraSalvarXMLs 
         Caption         =   "Salvar XMLs"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1815
         Left            =   9000
         TabIndex        =   15
         Top             =   360
         Width           =   2055
         Begin VB.CheckBox chkSepararData 
            Caption         =   "Separar Por Data"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   20
            Top             =   1320
            Width           =   1815
         End
         Begin VB.CheckBox chkSepararCNPJ 
            Caption         =   "Separar Por CNPJ"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   19
            Top             =   1080
            Width           =   1815
         End
         Begin VB.CheckBox chkSaveCFeCanc 
            Caption         =   "Salvar CFeCanc"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   18
            Top             =   840
            Width           =   1695
         End
         Begin VB.CheckBox chkSaveEnvio 
            Caption         =   "Salvar Envio"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   17
            Top             =   600
            Width           =   1335
         End
         Begin VB.CheckBox chkSaveCFe 
            Caption         =   "Salvar CFe"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   16
            Top             =   360
            Width           =   1215
         End
      End
      Begin MSComCtl2.UpDown nudPaginaCodigo 
         Height          =   285
         Left            =   6720
         TabIndex        =   11
         Top             =   1320
         Width           =   255
         _ExtentX        =   450
         _ExtentY        =   503
         _Version        =   393216
         BuddyControl    =   "txtPaginaCodigo"
         BuddyDispid     =   196658
         OrigLeft        =   6240
         OrigTop         =   1320
         OrigRight       =   6495
         OrigBottom      =   1575
         Max             =   99999
         SyncBuddy       =   -1  'True
         BuddyProperty   =   0
         Enabled         =   -1  'True
      End
      Begin VB.TextBox txtPaginaCodigo 
         Alignment       =   1  'Right Justify
         Height          =   315
         Left            =   5760
         TabIndex        =   10
         Text            =   "0"
         Top             =   1320
         Width           =   990
      End
      Begin VB.TextBox txtAtivacao 
         Height          =   315
         Left            =   120
         TabIndex        =   9
         Text            =   "123456"
         Top             =   1320
         Width           =   4335
      End
      Begin VB.ComboBox cmbModeloSat 
         Height          =   315
         ItemData        =   "FrmMain.frx":262E
         Left            =   4560
         List            =   "FrmMain.frx":2630
         Style           =   2  'Dropdown List
         TabIndex        =   7
         Top             =   720
         Width           =   2190
      End
      Begin VB.CommandButton btnSelDll 
         Caption         =   "..."
         Height          =   285
         Left            =   4005
         TabIndex        =   5
         Top             =   720
         Width           =   390
      End
      Begin VB.TextBox txtDllPath 
         Height          =   315
         Left            =   120
         TabIndex        =   4
         Text            =   "C:\SAT\SAT.dll"
         Top             =   720
         Width           =   3870
      End
      Begin MSComCtl2.UpDown nudCopias 
         Height          =   315
         Left            =   -73215
         TabIndex        =   31
         Top             =   1320
         Width           =   255
         _ExtentX        =   450
         _ExtentY        =   556
         _Version        =   393216
         Value           =   1
         BuddyControl    =   "txtCopias"
         BuddyDispid     =   196649
         OrigLeft        =   6240
         OrigTop         =   1320
         OrigRight       =   6495
         OrigBottom      =   1575
         Max             =   99999
         Min             =   1
         SyncBuddy       =   -1  'True
         BuddyProperty   =   0
         Enabled         =   -1  'True
      End
      Begin MSComCtl2.UpDown nudPorta 
         Height          =   315
         Left            =   -67560
         TabIndex        =   77
         Top             =   1920
         Width           =   255
         _ExtentX        =   450
         _ExtentY        =   556
         _Version        =   393216
         BuddyControl    =   "txtPorta"
         BuddyDispid     =   196621
         OrigLeft        =   6240
         OrigTop         =   1320
         OrigRight       =   6495
         OrigBottom      =   1575
         Max             =   99999
         SyncBuddy       =   -1  'True
         BuddyProperty   =   0
         Enabled         =   -1  'True
      End
      Begin VB.Label Label3 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Codigo do Estado da Federa��o"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   4560
         TabIndex        =   89
         Top             =   1680
         Width           =   2625
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "CNPJ Contribuinte"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   120
         TabIndex        =   88
         Top             =   1680
         Width           =   1500
      End
      Begin VB.Label lblPortaMail 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Porta"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -68520
         TabIndex        =   79
         Top             =   1680
         Width           =   465
      End
      Begin VB.Label lblHostSMTP 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Host SMTP"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -74880
         TabIndex        =   76
         Top             =   1680
         Width           =   900
      End
      Begin VB.Label lblSenha 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Senha"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -71040
         TabIndex        =   74
         Top             =   1080
         Width           =   525
      End
      Begin VB.Label lblUsu�rio 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Usu�rio"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -71040
         TabIndex        =   72
         Top             =   480
         Width           =   645
      End
      Begin VB.Label lblEmail 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Email"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -74880
         TabIndex        =   70
         Top             =   1080
         Width           =   450
      End
      Begin VB.Label lblNome 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Nome"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -74880
         TabIndex        =   68
         Top             =   480
         Width           =   480
      End
      Begin VB.Label lblSite 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Site"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -72840
         TabIndex        =   40
         Top             =   1080
         Width           =   330
      End
      Begin VB.Label lblImpressora 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Impressora"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -70920
         TabIndex        =   38
         Top             =   480
         Width           =   1245
      End
      Begin VB.Label lblSoftwareHouse 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Software House"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -72840
         TabIndex        =   36
         Top             =   480
         Width           =   1590
      End
      Begin VB.Label lblNCopias 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "N� Copias"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -74880
         TabIndex        =   33
         Top             =   1080
         Width           =   795
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Tipo Impress�o"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -74880
         TabIndex        =   30
         Top             =   480
         Width           =   1320
      End
      Begin VB.Label lblSignAC 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "SignAC"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   120
         TabIndex        =   14
         Top             =   2280
         Width           =   585
      End
      Begin VB.Label lblPaginaDe 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Pagina de C�digo"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   5760
         TabIndex        =   13
         Top             =   1080
         Width           =   1575
      End
      Begin VB.Label lblVers�o 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Vers�o"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   4560
         TabIndex        =   12
         Top             =   1080
         Width           =   615
      End
      Begin VB.Label lblCodigoDe 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Codigo de Ativa��o"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   120
         TabIndex        =   8
         Top             =   1080
         Width           =   1695
      End
      Begin VB.Label lblModelo 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Modelo"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   4560
         TabIndex        =   6
         Top             =   480
         Width           =   735
      End
      Begin VB.Label lblNomeDll 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Nome Dll"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   120
         TabIndex        =   3
         Top             =   480
         Width           =   735
      End
   End
   Begin VB.Frame FraRespostas 
      Caption         =   "Respostas"
      Height          =   3135
      Left            =   3600
      TabIndex        =   0
      Top             =   3240
      Width           =   7575
      Begin VB.TextBox rtbRespostas 
         Height          =   2775
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   1
         Top             =   240
         Width           =   7335
      End
   End
End
Attribute VB_Name = "FrmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim sat As ACBrSat

Private Sub btnAtivarSAT_Click()
    Dim retorno As String
    retorno = sat.AtivarSAT(txtCNPJContribuinte.Text, txtCodEstFederacao.Text)
    SetResposta retorno
End Sub

Private Sub btnCriarCFe_Click()
    On Error Resume Next
    CommonDialog1.DialogTitle = "Selecione o arquivo INI"
    CommonDialog1.InitDir = App.Path
    CommonDialog1.Filter = "Arquivo Ini CFe (*.ini)|*.ini|Todo os Arquivos (*.*)|*.*"
    CommonDialog1.ShowOpen
            
    If Err Then Exit Sub
    
    Dim retorno As String
    
    retorno = sat.CriarCFe(CommonDialog1.FileName)
    SetResposta retorno
End Sub

Private Sub btnCriarEnviarCFe_Click()
    On Error Resume Next
    CommonDialog1.DialogTitle = "Selecione o arquivo INI"
    CommonDialog1.InitDir = App.Path
    CommonDialog1.Filter = "Arquivo Ini CFe (*.ini)|*.ini|Todo os Arquivos (*.*)|*.*"
    CommonDialog1.ShowOpen
            
    If Err Then Exit Sub
    
    Dim retorno As String
    
    retorno = sat.CriarEnviarCFe(CommonDialog1.FileName)
    SetResposta retorno
End Sub

Private Sub btnEnviarCFe_Click()
    On Error Resume Next
    CommonDialog1.DialogTitle = "Selecione o arquivo Xml"
    CommonDialog1.InitDir = App.Path
    CommonDialog1.Filter = "Arquivo Xml CFe (*.xml)|*.xml|Todo os Arquivos (*.*)|*.*"
    CommonDialog1.ShowOpen
            
    If Err Then Exit Sub
    
    Dim retorno As String
    
    retorno = sat.EnviarCFe(CommonDialog1.FileName)
    SetResposta retorno
End Sub

Private Sub btnImprimiCFeRed_Click()
    On Error Resume Next
    CommonDialog1.DialogTitle = "Selecione o arquivo Xml"
    CommonDialog1.InitDir = App.Path
    CommonDialog1.Filter = "Arquivo Xml CFe (*.xml)|*.xml|Todo os Arquivos (*.*)|*.*"
    CommonDialog1.ShowOpen
            
    If Err Then Exit Sub
    
    sat.ImprimirExtratoResumido CommonDialog1.FileName, vbNullString
    SetResposta "CFe Impresso com sucesso"
End Sub

Private Sub btnImprimirCFe_Click()
    On Error Resume Next
    CommonDialog1.DialogTitle = "Selecione o arquivo Xml"
    CommonDialog1.InitDir = App.Path
    CommonDialog1.Filter = "Arquivo Xml CFe (*.xml)|*.xml|Todo os Arquivos (*.*)|*.*"
    CommonDialog1.ShowOpen
            
    If Err Then Exit Sub
    sat.ImprimirExtratoVenda CommonDialog1.FileName, vbNullString
    SetResposta "CFe Impresso com sucesso"
End Sub

Private Sub btnImprimirPDFCFe_Click()
    On Error Resume Next
    CommonDialog1.DialogTitle = "Selecione o arquivo Xml"
    CommonDialog1.InitDir = App.Path
    CommonDialog1.Filter = "Arquivo Xml CFe (*.xml)|*.xml|Todo os Arquivos (*.*)|*.*"
    CommonDialog1.ShowOpen
            
    If Err Then Exit Sub
    
    Dim retorno As String
    retorno = sat.GerarPDFExtratoVenda(CommonDialog1.FileName, vbNullString)
    SetResposta retorno
End Sub

Private Sub btnIniDesini_Click()
    Dim retorno As Long

    If btnIniDesini.Caption = "Inicializar" Then
        SaveConfig
        
        sat.Inicializar
        btnIniDesini.Caption = "Desinicializar"
    Else
        sat.DesInicializar
        btnIniDesini.Caption = "Inicializar"
    End If
End Sub

Private Sub btnSelDll_Click()
    On Error Resume Next
    CommonDialog1.DialogTitle = "Biblioteca SAT"
    CommonDialog1.InitDir = App.Path
    CommonDialog1.Filter = "Biblioteca SAT (*.dll)|*.dll|Todos os arquivos (*.*)|*.*"
    CommonDialog1.ShowOpen
            
    If Err Then Exit Sub
    
    txtDllPath.Text = CommonDialog1.FileName
End Sub

Private Sub cmdCancelarCFe_Click()

    On Error Resume Next
    CommonDialog1.DialogTitle = "Selecione o arquivo Xml"
    CommonDialog1.InitDir = App.Path
    CommonDialog1.Filter = "Arquivo Xml CFe (*.xml)|*.xml|Todo os Arquivos (*.*)|*.*"
    CommonDialog1.ShowOpen
            
    If Err Then Exit Sub
    
    Dim retorno As String
    retorno = sat.CancelarCFe(CommonDialog1.FileName)
    SetResposta retorno

End Sub

Private Sub cmdConsultarSAT_Click()
    Dim retorno As String
    retorno = sat.ConsultarSAT()
    SetResposta retorno
End Sub

Private Sub cmdConsultarStatus_Click()
    Dim retorno As String
    retorno = sat.ConsultarStatusOperacional()
    SetResposta retorno
End Sub

Private Sub cmdImprimirCFeCanc_Click()
    Dim xmlVenda As String
    Dim xmlCancelamento As String
    
    On Error Resume Next
    
    CommonDialog1.DialogTitle = "Selecione o arquivo Xml de venda"
    CommonDialog1.InitDir = App.Path
    CommonDialog1.Filter = "Arquivo Xml CFe (*.xml)|*.xml|Todo os Arquivos (*.*)|*.*"
    CommonDialog1.ShowOpen
    
    xmlVenda = CommonDialog1.FileName
    
    CommonDialog1.DialogTitle = "Selecione o arquivo Xml de cancelamento"
    CommonDialog1.ShowOpen
    
    xmlCancelamento = CommonDialog1.FileName
            
    If Err Then Exit Sub
    
    sat.ImprimirExtratoCancelamento xmlVenda, xmlCancelamento
End Sub

Private Sub Form_Load()
    cmbModeloSat.AddItem "satNenhum", SATModelo.satNenhum
    cmbModeloSat.AddItem "satDinamico_cdecl", SATModelo.satDinamico_cdecl
    cmbModeloSat.AddItem "satDinamico_stdcall", SATModelo.satDinamico_stdcall
    cmbModeloSat.AddItem "mfe_Integrador_XML", SATModelo.mfe_Integrador_XML
    cmbModeloSat.ListIndex = 0
    
    txtVersaoCFe.Text = "0,07"
    
    cmbImpressao.AddItem "Fortes", TipoRelatorioBobina.tpFortes
    cmbImpressao.AddItem "EscPos", TipoRelatorioBobina.tpEscPos
    cmbImpressao.ListIndex = 0
           
    cbbModelo.AddItem "ppTexto", ACBrPosPrinterModelo.ppTexto
    cbbModelo.AddItem "ppEscPosEpson", ACBrPosPrinterModelo.ppEscPosEpson
    cbbModelo.AddItem "ppEscBematech", ACBrPosPrinterModelo.ppEscBematech
    cbbModelo.AddItem "ppEscDaruma", ACBrPosPrinterModelo.ppEscDaruma
    cbbModelo.AddItem "ppEscVox", ACBrPosPrinterModelo.ppEscVox
    cbbModelo.AddItem "ppEscDiebold", ACBrPosPrinterModelo.ppEscDiebold
    cbbModelo.AddItem "ppEscEpsonP2", ACBrPosPrinterModelo.ppEscEpsonP2
    cbbModelo.AddItem "ppCustomPos", ACBrPosPrinterModelo.ppCustomPos
    cbbModelo.AddItem "ppEscPosStar", ACBrPosPrinterModelo.ppEscPosStar
    cbbModelo.AddItem "ppEscZJiang", ACBrPosPrinterModelo.ppEscZJiang
    cbbModelo.AddItem "ppEscGPrinter", ACBrPosPrinterModelo.ppEscGPrinter
    
    cbbModelo.ListIndex = 0
    
    cbbPortas.AddItem "COM1"
    cbbPortas.AddItem "COM2"
    cbbPortas.AddItem "LPT1"
    cbbPortas.AddItem "LPT2"
    cbbPortas.AddItem "\\localhost\Epson"
    cbbPortas.AddItem "C:\temp\ecf.txt"
    
    cbbPortas.ListIndex = cbbPortas.ListCount - 1
    
    cbbPortas.AddItem "TCP:192.168.0.31:9100"
    Dim p As Printer
    For Each p In Printers
        cbbPortas.AddItem "RAW:" + p.DeviceName
        cbbImpressora.AddItem p.DeviceName
    Next
    
    cbbPaginaCodigo.AddItem "None", PosPaginaCodigo.pcNone
    cbbPaginaCodigo.AddItem "pc437", PosPaginaCodigo.pc437
    cbbPaginaCodigo.AddItem "pc850", PosPaginaCodigo.pc850
    cbbPaginaCodigo.AddItem "pc852", PosPaginaCodigo.pc852
    cbbPaginaCodigo.AddItem "pc860", PosPaginaCodigo.pc860
    cbbPaginaCodigo.AddItem "pcUTF8", PosPaginaCodigo.pcUTF8
    cbbPaginaCodigo.AddItem "pc1252", PosPaginaCodigo.pc1252
    
    cbbPaginaCodigo.ListIndex = 2
    
    nudColunas.Value = 0
    nudEspacos.Value = 0
    nudBuffer.Value = 0
    nudLinhasPular.Value = 0
    
    Dim LogPath As String
    Dim IniPath As String
    
    LogPath = App.Path & "\Logs\"
    IniPath = App.Path & "\ACBrLib.ini"
    
    If Not DirExists(LogPath) Then
        MkDir LogPath
    End If
        
    Set sat = CreateSat(IniPath)
    
    sat.ConfigGravarValor SESSAO_PRINCIPAL, "LogNivel", NivelLog.logParanoico
    sat.ConfigGravarValor SESSAO_PRINCIPAL, "LogPath", LogPath
    sat.ConfigGravarValor SESSAO_SAT, "ArqLog", LogPath & "\ACBrSat.log"
    sat.ConfigGravar
    
    LoadConfig
End Sub

Private Sub SetResposta(ByRef resposta As String)
    If rtbRespostas.Text <> vbNullString Then
      rtbRespostas.Text = rtbRespostas.Text + vbCrLf + resposta
    Else
      rtbRespostas.Text = resposta
    End If
End Sub


Private Sub LoadConfig()
    sat.ConfigLer
    
    txtDllPath.Text = sat.ConfigLerValor(SESSAO_SAT, "NomeDLL")
    cmbModeloSat.ListIndex = CLng(sat.ConfigLerValor(SESSAO_SAT, "Modelo"))
    txtAtivacao.Text = sat.ConfigLerValor(SESSAO_SAT, "CodigoDeAtivacao")
    txtVersaoCFe.Text = sat.ConfigLerValor(SESSAO_SATCONFIG, "infCFe_versaoDadosEnt")
    nudPaginaCodigo.Value = CLng(sat.ConfigLerValor(SESSAO_SATCONFIG, "PaginaDeCodigo"))
    txtSignAC.Text = sat.ConfigLerValor(SESSAO_SAT, "SignAC")
    chkSaveCFe.Value = CLng(sat.ConfigLerValor(SESSAO_SATCONFIGARQUIVOS, "SalvarCFe"))
    chkSaveEnvio.Value = CLng(sat.ConfigLerValor(SESSAO_SATCONFIGARQUIVOS, "SalvarEnvio"))
    chkSaveCFeCanc.Value = CLng(sat.ConfigLerValor(SESSAO_SATCONFIGARQUIVOS, "SalvarCFeCanc"))
    chkSepararCNPJ.Value = CLng(sat.ConfigLerValor(SESSAO_SATCONFIGARQUIVOS, "SepararPorCNPJ"))
    chkSepararData.Value = CLng(sat.ConfigLerValor(SESSAO_SATCONFIGARQUIVOS, "SepararPorDia"))
    cmbImpressao.ListIndex = CLng(sat.ConfigLerValor(SESSAO_EXTRATO, "Tipo"))
    nudCopias.Value = CLng(sat.ConfigLerValor(SESSAO_EXTRATO, "Copias"))
    txtSoftwareHouse.Text = sat.ConfigLerValor(SESSAO_SISTEMA, "Nome")
    cbbImpressora.Text = sat.ConfigLerValor(SESSAO_EXTRATO, "Impressora")
    txtSite.Text = sat.ConfigLerValor(SESSAO_EMISSOR, "WebSite")
    chkPreview.Value = CLng(sat.ConfigLerValor(SESSAO_EXTRATO, "MostraPreview"))
    chkSetup.Value = CLng(sat.ConfigLerValor(SESSAO_EXTRATO, "MostraSetup"))
    chkUsaCodigoEanImpressao.Value = CLng(sat.ConfigLerValor(SESSAO_EXTRATO, "ImprimeCodigoEAN"))
    chkImprimeEmUmaLinha.Value = CLng(sat.ConfigLerValor(SESSAO_EXTRATO, "ImprimeEmUmaLinha"))
    cbbModelo.ListIndex = CLng(sat.ConfigLerValor(SESSAO_POSPRINTER, "Modelo"))
    cbbPortas.Text = sat.ConfigLerValor(SESSAO_POSPRINTER, "Porta")
    cbbPaginaCodigo.ListIndex = CLng(sat.ConfigLerValor(SESSAO_POSPRINTER, "PaginaDeCodigo"))
    nudColunas.Value = CLng(sat.ConfigLerValor(SESSAO_POSPRINTER, "ColunasFonteNormal"))
    nudEspacos.Value = CLng(sat.ConfigLerValor(SESSAO_POSPRINTER, "EspacoEntreLinhas"))
    nudLinhasPular.Value = CLng(sat.ConfigLerValor(SESSAO_POSPRINTER, "LinhasEntreCupons"))
    cbxControlePorta.Value = CLng(sat.ConfigLerValor(SESSAO_POSPRINTER, "ControlePorta"))
    cbxCortarPapel.Value = CLng(sat.ConfigLerValor(SESSAO_POSPRINTER, "CortaPapel"))
    cbxTraduzirTags.Value = CLng(sat.ConfigLerValor(SESSAO_POSPRINTER, "TraduzirTags"))
    cbxIgnorarTags.Value = CLng(sat.ConfigLerValor(SESSAO_POSPRINTER, "IgnorarTags"))
    txtNome.Text = sat.ConfigLerValor(SESSAO_EMAIL, "Nome")
    txtEmail.Text = sat.ConfigLerValor(SESSAO_EMAIL, "Conta")
    txtUsuario.Text = sat.ConfigLerValor(SESSAO_EMAIL, "Usuario")
    txtSenha.Text = sat.ConfigLerValor(SESSAO_EMAIL, "Senha")
    txtHost.Text = sat.ConfigLerValor(SESSAO_EMAIL, "Servidor")
    nudPorta.Value = CLng(sat.ConfigLerValor(SESSAO_EMAIL, "Porta"))
    ckbSSL.Value = CLng(sat.ConfigLerValor(SESSAO_EMAIL, "SSL"))
    ckbTLS.Value = CLng(sat.ConfigLerValor(SESSAO_EMAIL, "TLS"))
End Sub

Private Sub SaveConfig()
    sat.ConfigGravarValor SESSAO_SAT, "NomeDLL", txtDllPath.Text
    sat.ConfigGravarValor SESSAO_SAT, "Modelo", cmbModeloSat.ListIndex
    sat.ConfigGravarValor SESSAO_SAT, "CodigoDeAtivacao", txtAtivacao.Text
    sat.ConfigGravarValor SESSAO_SATCONFIG, "infCFe_versaoDadosEnt", txtVersaoCFe.Text
    sat.ConfigGravarValor SESSAO_SATCONFIG, "PaginaDeCodigo", CStr(nudPaginaCodigo.Value)
    sat.ConfigGravarValor SESSAO_SAT, "SignAC", txtSignAC.Text
    sat.ConfigGravarValor SESSAO_SATCONFIGARQUIVOS, "SalvarCFe", CStr(chkSaveCFe.Value)
    sat.ConfigGravarValor SESSAO_SATCONFIGARQUIVOS, "SalvarEnvio", CStr(chkSaveEnvio.Value)
    sat.ConfigGravarValor SESSAO_SATCONFIGARQUIVOS, "SalvarCFeCanc", CStr(chkSaveCFeCanc.Value)
    sat.ConfigGravarValor SESSAO_SATCONFIGARQUIVOS, "SepararPorCNPJ", CStr(chkSepararCNPJ.Value)
    sat.ConfigGravarValor SESSAO_SATCONFIGARQUIVOS, "SepararPorDia", CStr(chkSepararData.Value)
    sat.ConfigGravarValor SESSAO_EXTRATO, "Tipo", cmbImpressao.ListIndex
    sat.ConfigGravarValor SESSAO_EXTRATO, "Copias", CStr(nudCopias.Value)
    sat.ConfigGravarValor SESSAO_SISTEMA, "Nome", txtSoftwareHouse.Text
    sat.ConfigGravarValor SESSAO_EXTRATO, "Impressora", cbbImpressora.Text
    sat.ConfigGravarValor SESSAO_EMISSOR, "WebSite", txtSite.Text
    sat.ConfigGravarValor SESSAO_EXTRATO, "MostraPreview", CStr(chkPreview.Value)
    sat.ConfigGravarValor SESSAO_EXTRATO, "MostraSetup", CStr(chkSetup.Value)
    sat.ConfigGravarValor SESSAO_EXTRATO, "ImprimeCodigoEAN", CStr(chkUsaCodigoEanImpressao.Value)
    sat.ConfigGravarValor SESSAO_EXTRATO, "ImprimeEmUmaLinha", CStr(chkImprimeEmUmaLinha.Value)
    sat.ConfigGravarValor SESSAO_POSPRINTER, "Modelo", cbbModelo.ListIndex
    sat.ConfigGravarValor SESSAO_POSPRINTER, "Porta", cbbPortas.Text
    sat.ConfigGravarValor SESSAO_POSPRINTER, "ColunasFonteNormal", CStr(nudColunas.Value)
    sat.ConfigGravarValor SESSAO_POSPRINTER, "EspacoEntreLinhas", CStr(nudEspacos.Value)
    sat.ConfigGravarValor SESSAO_POSPRINTER, "LinhasBuffer", CStr(nudBuffer.Value)
    sat.ConfigGravarValor SESSAO_POSPRINTER, "LinhasEntreCupons", CStr(nudLinhasPular.Value)
    sat.ConfigGravarValor SESSAO_POSPRINTER, "ControlePorta", CStr(cbxControlePorta.Value)
    sat.ConfigGravarValor SESSAO_POSPRINTER, "CortaPapel", CStr(cbxCortarPapel.Value)
    sat.ConfigGravarValor SESSAO_POSPRINTER, "TraduzirTags", CStr(cbxTraduzirTags.Value)
    sat.ConfigGravarValor SESSAO_POSPRINTER, "IgnorarTags", CStr(cbxIgnorarTags.Value)
    sat.ConfigGravarValor SESSAO_POSPRINTER, "PaginaDeCodigo", cbbPaginaCodigo.ListIndex
    sat.ConfigGravarValor SESSAO_EMAIL, "Nome", txtNome.Text
    sat.ConfigGravarValor SESSAO_EMAIL, "Conta", txtEmail.Text
    sat.ConfigGravarValor SESSAO_EMAIL, "Usuario", txtUsuario.Text
    sat.ConfigGravarValor SESSAO_EMAIL, "Senha", txtSenha.Text
    sat.ConfigGravarValor SESSAO_EMAIL, "Servidor", txtHost.Text
    sat.ConfigGravarValor SESSAO_EMAIL, "Porta", CStr(nudPorta.Value)
    sat.ConfigGravarValor SESSAO_EMAIL, "SSL", CStr(ckbSSL.Value)
    sat.ConfigGravarValor SESSAO_EMAIL, "TLS", CStr(ckbTLS.Value)
    sat.ConfigGravar
End Sub

Private Sub Form_Unload(Cancel As Integer)
    sat.FinalizarLib
End Sub
