VERSION 5.00
Object = "{FE0065C0-1B7B-11CF-9D53-00AA003C9CB6}#1.1#0"; "COMCT232.OCX"
Begin VB.Form FrmMain 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "ACBrLibMail Demo"
   ClientHeight    =   7980
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   12525
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
   ScaleHeight     =   7980
   ScaleWidth      =   12525
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.ListBox lstAnexos 
      Height          =   1035
      ItemData        =   "FrmMain.frx":25CA
      Left            =   6000
      List            =   "FrmMain.frx":25D1
      TabIndex        =   27
      Top             =   6240
      Width           =   6375
   End
   Begin VB.CommandButton btnAnexos 
      Caption         =   "Anexar Arquivos"
      Height          =   360
      Left            =   6000
      TabIndex        =   26
      Top             =   5760
      Width           =   1455
   End
   Begin VB.TextBox txtBody 
      Height          =   1215
      Left            =   6000
      MultiLine       =   -1  'True
      TabIndex        =   9
      Top             =   4440
      Width           =   6375
   End
   Begin VB.CommandButton cmdEnviar 
      Caption         =   "Enviar"
      Height          =   360
      Left            =   11400
      TabIndex        =   7
      Top             =   7440
      Width           =   990
   End
   Begin VB.TextBox txtAltBody 
      Height          =   2295
      Left            =   6000
      MultiLine       =   -1  'True
      TabIndex        =   6
      Top             =   1800
      Width           =   6255
   End
   Begin VB.TextBox txtAssunto 
      Height          =   375
      Left            =   6000
      TabIndex        =   4
      Top             =   1080
      Width           =   6375
   End
   Begin VB.TextBox txtDestinatario 
      Height          =   375
      Left            =   6000
      TabIndex        =   2
      Top             =   360
      Width           =   6375
   End
   Begin VB.Frame FraConfigura��o 
      Caption         =   "Configura��o"
      Height          =   7695
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   5775
      Begin VB.CommandButton cmdSalvar 
         Caption         =   "Salvar"
         Height          =   360
         Left            =   4680
         TabIndex        =   25
         Top             =   7200
         Width           =   990
      End
      Begin VB.CheckBox chkTLS 
         Caption         =   "TLS"
         Height          =   255
         Left            =   1080
         TabIndex        =   24
         Top             =   2400
         Width           =   855
      End
      Begin VB.CheckBox chkSSL 
         Caption         =   "SSL"
         Height          =   255
         Left            =   120
         TabIndex        =   23
         Top             =   2400
         Width           =   735
      End
      Begin VB.TextBox txtHost 
         Height          =   375
         Left            =   120
         TabIndex        =   22
         Top             =   1920
         Width           =   4095
      End
      Begin VB.TextBox txtPorta 
         Height          =   375
         Left            =   4320
         TabIndex        =   19
         Top             =   1920
         Width           =   1080
      End
      Begin ComCtl2.UpDown nupPorta 
         Height          =   375
         Left            =   5400
         TabIndex        =   18
         Top             =   1920
         Width           =   255
         _ExtentX        =   450
         _ExtentY        =   661
         _Version        =   327681
         BuddyControl    =   "txtPorta"
         BuddyDispid     =   196621
         OrigLeft        =   5400
         OrigTop         =   1800
         OrigRight       =   5655
         OrigBottom      =   2175
         Max             =   99999
         SyncBuddy       =   -1  'True
         BuddyProperty   =   65547
         Enabled         =   -1  'True
      End
      Begin VB.TextBox txtSenha 
         Height          =   375
         IMEMode         =   3  'DISABLE
         Left            =   2880
         PasswordChar    =   "*"
         TabIndex        =   16
         Top             =   1200
         Width           =   2775
      End
      Begin VB.TextBox txtEmail 
         Height          =   375
         Left            =   120
         TabIndex        =   15
         Top             =   1200
         Width           =   2655
      End
      Begin VB.TextBox txtUsuario 
         Height          =   375
         Left            =   2880
         TabIndex        =   12
         Top             =   480
         Width           =   2775
      End
      Begin VB.TextBox txtNome 
         Height          =   375
         Left            =   120
         TabIndex        =   11
         Top             =   480
         Width           =   2655
      End
      Begin VB.Label lblHostSMTP 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Host SMTP"
         Height          =   195
         Left            =   120
         TabIndex        =   21
         Top             =   1680
         Width           =   765
      End
      Begin VB.Label lblPorta 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Porta"
         Height          =   195
         Left            =   4320
         TabIndex        =   20
         Top             =   1680
         Width           =   390
      End
      Begin VB.Label lblSenha 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Senha"
         Height          =   195
         Left            =   2880
         TabIndex        =   17
         Top             =   960
         Width           =   450
      End
      Begin VB.Label lblEmail 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Email"
         Height          =   195
         Left            =   120
         TabIndex        =   14
         Top             =   960
         Width           =   360
      End
      Begin VB.Label lblUsu�rio 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Usu�rio"
         Height          =   195
         Left            =   2880
         TabIndex        =   13
         Top             =   240
         Width           =   540
      End
      Begin VB.Label lblNome 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Nome"
         Height          =   195
         Left            =   120
         TabIndex        =   10
         Top             =   240
         Width           =   405
      End
   End
   Begin VB.Label lblMensagemHTML 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Mensagem HTML"
      Height          =   195
      Left            =   6000
      TabIndex        =   8
      Top             =   4200
      Width           =   1200
   End
   Begin VB.Label lblMensagemTexto 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Mensagem Texto"
      Height          =   195
      Left            =   6000
      TabIndex        =   5
      Top             =   1560
      Width           =   1230
   End
   Begin VB.Label lblAssunto 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Assunto"
      Height          =   195
      Left            =   6000
      TabIndex        =   3
      Top             =   840
      Width           =   585
   End
   Begin VB.Label lblDestinatario 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Destinatario"
      Height          =   195
      Left            =   6000
      TabIndex        =   1
      Top             =   120
      Width           =   870
   End
End
Attribute VB_Name = "FrmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim mail As ACBrMail



Private Sub Form_Load()

    nupPorta.Value = 0

    Dim retorno As Long
    
    Set mail = CreateMail
    
    Dim LogPath As String
    
    LogPath = App.Path & "\Docs\"
    
    If Dir(LogPath) = vbNullString Then
        'MkDir LogPath
    End If
        
    mail.ConfigGravarValor SESSAO_PRINCIPAL, "LogNivel", "4"
    mail.ConfigGravarValor SESSAO_PRINCIPAL, "LogPath", LogPath
    mail.ConfigGravar
End Sub

Private Sub Form_Unload(Cancel As Integer)
    mail.FinalizarLib
End Sub

Private Sub btnAnexos_Click()
    
    On Error GoTo Erro:
    Dim arquivo As String
    
    CommonDialog1.DialogTitle = "Selecione o arquivo"
    CommonDialog1.InitDir = App.Path
    CommonDialog1.Filter = "Arquivo (*.arq)|*.arq|Todos os Arquivos (*.*)|*.*"
    CommonDialog1.FileName = vbNullString
    CommonDialog1.ShowOpen
            
    If CommonDialog1.FileName = vbNullString Then Exit Sub
    arquivo = CommonDialog1.FileName
    
    lstAnexos.AddItem (arquivo)

   
Erro:
    MsgBox Err.Description
    

End Sub

Private Sub cmdSalvar_Click()
    mail.ConfigGravarValor SESSAO_EMAIL, "Nome", txtNome.Text
    mail.ConfigGravarValor SESSAO_EMAIL, "Conta", txtEmail.Text
    mail.ConfigGravarValor SESSAO_EMAIL, "Usuario", txtUsuario.Text
    mail.ConfigGravarValor SESSAO_EMAIL, "Senha", txtSenha.Text
    mail.ConfigGravarValor SESSAO_EMAIL, "Servidor", txtHost.Text
    mail.ConfigGravarValor SESSAO_EMAIL, "Porta", txtPorta.Text
    mail.ConfigGravarValor SESSAO_EMAIL, "SSL", CStr(chkSSL.Value)
    mail.ConfigGravarValor SESSAO_EMAIL, "TLS", CStr(chkTLS.Value)
    mail.ConfigGravar
End Sub

Private Sub cmdEnviar_Click()
    mail.Clear
    mail.AddAddress txtDestinatario.Text, txtDestinatario.Text
    mail.SetSubject txtAssunto.Text
    mail.AddBody txtBody.Text
    mail.AddAltBody txtAltBody.Text
    mail.Send
End Sub



