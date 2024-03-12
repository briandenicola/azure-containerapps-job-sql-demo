FROM mcr.microsoft.com/azure-powershell:latest
WORKDIR /app
COPY . .
ENTRYPOINT ["pwsh", "-File", "/app/wrapper.ps1"]