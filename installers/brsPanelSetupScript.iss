; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "BRS Panel"
#define MyAppVersion "1.0.0.0"
#define MyAppPublisher "Abomis"
#define MyAppURL "https://www.abomis.com/"
#define MyAppExeName "brs_panel.exe"
#define MyAppAssocName MyAppName + " File"
#define MyAppAssocExt ".myp"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt
#define MyDateTimeString GetDateTimeString(' yyyy-mm-dd', '-', ':');
#define MyDistFolder "C:\Program Files" 
#define DeskIcon "C:\Users\Bakhshaiesh\Desktop\FlutterProjects\Flutter.BRS-Panel\installers\setupicon.ico" 

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{2A105609-DD38-4A9E-838F-80CA5F27BF66}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
ChangesAssociations=yes
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=C:\Users\Bakhshaiesh\Desktop
OutputBaseFilename=BRS Panel Setup ({#MyAppVersion}){#MyDateTimeString}
SetupIconFile=C:\Users\Bakhshaiesh\Desktop\FlutterProjects\Flutter.BRS-Panel\installers\setupicon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SignTool = signtool

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Users\Bakhshaiesh\Desktop\FlutterProjects\Flutter.BRS-Panel\build\windows\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Bakhshaiesh\Desktop\FlutterProjects\Flutter.BRS-Panel\build\windows\runner\Release\brs_panel.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Bakhshaiesh\Desktop\FlutterProjects\Flutter.BRS-Panel\build\windows\runner\Release\connectivity_plus_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Bakhshaiesh\Desktop\FlutterProjects\Flutter.BRS-Panel\build\windows\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Bakhshaiesh\Desktop\FlutterProjects\Flutter.BRS-Panel\build\windows\runner\Release\objectbox.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Bakhshaiesh\Desktop\FlutterProjects\Flutter.BRS-Panel\build\windows\runner\Release\objectbox_flutter_libs_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Bakhshaiesh\Desktop\FlutterProjects\Flutter.BRS-Panel\build\windows\runner\Release\url_launcher_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Bakhshaiesh\Desktop\FlutterProjects\Flutter.BRS-Panel\build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Registry]
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocExt}\OpenWithProgids"; ValueType: string; ValueName: "{#MyAppAssocKey}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}"; ValueType: string; ValueName: ""; ValueData: "{#MyAppAssocName}"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
Root: HKA; Subkey: "Software\Classes\Applications\{#MyAppExeName}\SupportedTypes"; ValueType: string; ValueName: ".myp"; ValueData: ""

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: {#DeskIcon}

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

