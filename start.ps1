# Obtener credenciales desde variables de entorno
$rdpUser = $env:RDP_USER
$rdpPassword = $env:RDP_PASSWORD

# Verificar y crear regla de firewall para RDP
if (-not (Get-NetFirewallRule -DisplayName "Allow RDP" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule `
        -DisplayName "Allow RDP" `
        -Direction Inbound `
        -LocalPort 3389 `
        -Protocol TCP `
        -Action Allow `
        -Verbose
}

# Crear usuario y añadir a administradores si no existe
if ($rdpUser -and $rdpPassword) {
    if (-not (Get-LocalUser -Name $rdpUser -ErrorAction SilentlyContinue)) {
        net user $rdpUser $rdpPassword /add
        net localgroup administrators $rdpUser /add
    } else {
        Write-Host "[*] El usuario $rdpUser ya existe. No se creará nuevamente."
    }
} else {
    Write-Host "[!] No se proporcionaron credenciales válidas. No se creará el usuario."
}

# Asegurar que el servicio RDP está activo
$rdpService = Get-Service -Name TermService -ErrorAction Stop
if ($rdpService.Status -ne "Running") {
    Start-Service -Name TermService -Verbose
    Set-Service -Name TermService -StartupType Automatic -Verbose
}

# Mantener contenedor activo sin consumo excesivo de CPU
Write-Host "[*] Contenedor DockerWinRDP iniciado. Presione Ctrl+C para detener."
Wait-Event