# Usar imagen base más ligera y segura (LTSC 2022)
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Configurar entorno
ENV CONTAINER_NAME=dockerwinrdp

# Instalar RDP, Python y configurar entorno en una sola capa
RUN powershell.exe -Command `
    # Habilitar RDP
    Add-WindowsFeature RDS-RD-Server; `
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0; `
    netsh advfirewall firewall set rule group="remote desktop" new enable=yes; `
    # Descargar e instalar Python
    $url = "https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe"; `
    $output = "python-installer.exe"; `
    Invoke-WebRequest -Uri $url -OutFile $output; `
    Start-Process -Wait -FilePath $output -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1"; `
    Remove-Item $output; `
    # Medidas anti-detección
    Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters' -Recurse -Force; `
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'ClearPageFileAtShutdown' -Value 1

# Instalar dependencias de Python
RUN pip install --no-cache-dir pyinstaller discord.py

# Copiar scripts y configurar entorno
WORKDIR C:/Scripts
COPY bot.py start.ps1 ./

# Entrypoint optimizado
ENTRYPOINT ["powershell.exe", "-File", "C:/Scripts/start.ps1"]