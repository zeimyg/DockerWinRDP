#!/bin/bash

# Variables globales
LOG_FILE="logs/install.log"

# Función para imprimir mensajes formateados con colores
print_msg() {
    local msg="$1"
    local msg_type="$2"
    local color="${COLOR_MAP[$msg_type]}"
    local prefix=""
    case "$msg_type" in
        "success") prefix="[+] " ;;
        "error") prefix="[!] " ;;
        "info") prefix="[*] " ;;
        "query") prefix="[?] " ;;
        "warning") prefix="[~] " ;;
        *) prefix="[ ] " ;;
    esac
    echo -e "${color}${prefix}${msg}${RESET}"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$msg_type] ${msg}" >> "$LOG_FILE"
}

# Función para manejar errores críticos
handle_critical_error() {
    local error_msg="$1"
    print_msg "$error_msg" "error"
    print_msg "Deteniendo la instalación debido a un error crítico." "error"
    exit 1
}

# Función para instalar dependencias
install_dependencies() {
    print_msg "Instalando dependencias necesarias..." "info"
    sudo apt-get update >>"$LOG_FILE" 2>&1
    sudo apt-get install -y docker.io docker-compose git python3-pip >>"$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        handle_critical_error "Error al instalar dependencias."
    fi
    print_msg "Dependencias instaladas correctamente." "success"
}

# Función para construir el contenedor DockerWinRDP
build_dockerwinrdp() {
    print_msg "Construyendo el contenedor DockerWinRDP..." "info"
    docker build --build-arg RDP_USER="$RDP_USER" --build-arg RDP_PASSWORD="$RDP_PASSWORD" -t dockerwinrdp . >>"$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        handle_critical_error "Error al construir el contenedor DockerWinRDP."
    fi
    print_msg "Contenedor DockerWinRDP construido correctamente." "success"
}

# Función principal
main() {
    print_msg "Bienvenido al script de instalación para DockerWinRDP." "info"

    # Instalar dependencias
    install_dependencies

    # Construir el contenedor DockerWinRDP
    build_dockerwinrdp

    # Finalización
    print_msg "Instalación completada correctamente." "success"
}

# Ejecutar función principal
main