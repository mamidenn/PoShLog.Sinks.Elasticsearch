FROM mcr.microsoft.com/vscode/devcontainers/dotnet:0-5.0

RUN pwsh -NonInteractive -Command "Set-PSRepository PSGallery -InstallationPolicy Trusted; Install-Module -Scope AllUsers InvokeBuild, Pester, PoshLog, PoshLog.Tools"
