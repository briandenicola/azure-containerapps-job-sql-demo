FROM mcr.microsoft.com/azure-powershell:latest
SHELL ["pwsh", "-Command"]
RUN Install-Module -name sqlserver -Confirm:$false -Force
WORKDIR /app
COPY . .
ENTRYPOINT ["pwsh", "-File", "/app/wrapper.ps1"]