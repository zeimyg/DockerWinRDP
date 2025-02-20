#!/bin/bash

# Variables globales
LOG_FILE="logs/configure.log"
MYSQL_INIT_DIR="mysql-init"

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
    print_msg "Deteniendo la configuración debido a un error crítico." "error"
    exit 1
}

# Función para desplegar Apache Guacamole
deploy_guacamole() {
    print_msg "Desplegando Apache Guacamole..." "info"
    if [ "$USE_MYSQL" == "true" ]; then
        docker-compose up -d >>"$LOG_FILE" 2>&1
    else
        docker-compose -f docker-compose-no-mysql.yml up -d >>"$LOG_FILE" 2>&1
    fi
    if [ $? -ne 0 ]; then
        handle_critical_error "Error al desplegar Apache Guacamole."
    fi
    print_msg "Apache Guacamole desplegado correctamente." "success"
}

# Función para configurar la conexión RDP en Guacamole
configure_rdp_connection() {
    print_msg "Configurando conexión RDP en Guacamole..." "info"

    if [ "$USE_MYSQL" == "true" ]; then
        # Crear carpeta mysql-init si no existe
        if [ ! -d "$MYSQL_INIT_DIR" ]; then
            mkdir -p "$MYSQL_INIT_DIR"
        fi

        cat <<EOF > "$MYSQL_INIT_DIR/initdb.sql"
INSERT INTO guacamole_connection (connection_name, protocol) VALUES ('DockerWinRDP', 'rdp');
INSERT INTO guacamole_connection_parameter (connection_id, parameter_name, parameter_value)
VALUES (
    (SELECT connection_id FROM guacamole_connection WHERE connection_name = 'DockerWinRDP'),
    'hostname', 'localhost'
), (
    (SELECT connection_id FROM guacamole_connection WHERE connection_name = 'DockerWinRDP'),
    'port', '3389'
), (
    (SELECT connection_id FROM guacamole_connection WHERE connection_name = 'DockerWinRDP'),
    'username', '$RDP_USER'
), (
    (SELECT connection_id FROM guacamole_connection WHERE connection_name = 'DockerWinRDP'),
    'password', '$RDP_PASSWORD'
);
EOF
    else
        print_msg "Usando conexión RDP estática sin MySQL." "info"
    fi

    print_msg "Conexión RDP configurada correctamente." "success"
}

# Función principal
main() {
    print_msg "Bienvenido al script de configuración para Apache Guacamole." "info"

    # Desplegar Apache Guacamole
    deploy_guacamole

    # Configurar la conexión RDP
    configure_rdp_connection

    # Finalización
    print_msg "Configuración completada correctamente." "success"
}

# Ejecutar función principal
main