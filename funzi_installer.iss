; ------------------------------------------------------------
; Inno Setup script for Funzi Windows Installer
; ------------------------------------------------------------
[Setup]
AppName=Funzi
AppVersion=1.0.0
AppPublisher=joshuastar
DefaultDirName={autopf}\Funzi
DefaultGroupName=Funzi
UninstallDisplayIcon={app}\Funzi.exe
OutputDir=.
OutputBaseFilename=FunziInstaller
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupIconFile=windows\runner\resources\app_icon.ico
PrivilegesRequired=lowest

[Files]
; Copy all built Flutter files to the installation directory
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
; Create desktop and Start Menu shortcuts
Name: "{group}\Funzi"; Filename: "{app}\Funzi.exe"
Name: "{userdesktop}\Funzi"; Filename: "{app}\Funzi.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional icons:"

[Run]
; Run the app after installation
Filename: "{app}\Funzi.exe"; Description: "Launch Funzi"; Flags: nowait postinstall skipifsilent
