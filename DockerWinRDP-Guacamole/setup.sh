#!/bin/bash

# Variables globales
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/setup.log"

# Colores para mensajes formateados
declare -A COLOR_MAP=(
    ["success"]="\e[32m"  # Verde
    ["error"]="\e[31m"    # Rojo
    ["info"]="\e[34m"     # Azul
    ["query"]="\e[35m"    # Magenta
    ["warning"]="\e[33m"  # Amarillo
)
RESET="\e[0m"

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

# Crear carpeta de logs si no existe
create_log_dir() {
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR"
        print_msg "Carpeta de logs creada: $LOG_DIR" "info"
    fi
}

# Solicitar credenciales al usuario
get_credentials() {
    print_msg "Configurando credenciales para el contenedor..." "query"
    read -p "[?] Ingrese el nombre de usuario para RDP (por defecto: user_rdp): " rdp_user
    read -sp "[?] Ingrese la contraseña para RDP (por defecto: admin_rdp): " rdp_password
    echo ""  # Salto de línea después de ingresar la contraseña
    export RDP_USER="${rdp_user:-user_rdp}"
    export RDP_PASSWORD="${rdp_password:-admin_rd}"
    print_msg "Credenciales configuradas correctamente." "success"
}

# Preguntar si se desea usar MySQL
ask_for_mysql() {
    print_msg "¿Desea configurar MySQL para Guacamole? (s/n): " "query"
    read -p "[?] (s/n): " use_mysql
    if [[ "$use_mysql" == "s" ]]; then
        export USE_MYSQL="true"
        print_msg "MySQL será configurado." "info"
        # Solicitar credenciales de MySQL
        read -p "[?] Ingrese la contraseña root de MySQL (por defecto: root_db): " mysql_root_password
        read -p "[?] Ingrese el nombre de la base de datos (por defecto: guacamole_db): " mysql_database
        read -p "[?] Ingrese el usuario de MySQL (por defecto: user_db): " mysql_user
        read -sp "[?] Ingrese la contraseña del usuario de MySQL (por defecto: admin_db): " mysql_password
        echo ""  # Salto de línea después de ingresar la contraseña
        export MYSQL_ROOT_PASSWORD="${mysql_root_password:-root_db}"
        export MYSQL_DATABASE="${mysql_database:-guacamole_db}"
        export MYSQL_USER="${mysql_user:-user_db}"
        export MYSQL_PASSWORD="${mysql_password:- admin_db}"
    else
        export USE_MYSQL="false"
        print_msg "MySQL no será configurado. Se usará una conexión RDP estática." "info"
    fi
}

# Función principal
main() {
    create_log_dir
    print_msg "Bienvenido al script de configuración interactiva para DockerWinRDP con Apache Guacamole." "info"

    # Solicitar credenciales
    get_credentials

    # Preguntar si se desea usar MySQL
    ask_for_mysql

    # Ejecutar scripts de instalación y configuración
    ./install.sh || handle_critical_error "Error durante la instalación."
    ./configure.sh || handle_critical_error "Error durante la configuración."

    # Finalización
    print_msg "Configuración completada correctamente." "success"
    print_msg "Acceda a Guacamole en http://localhost:8080/guacamole" "info"
    print_msg "Credenciales predeterminadas: guacadmin/guacadmin" "info"
    print_msg "Para conectarse al contenedor DockerWinRDP, use la conexión 'DockerWinRDP' desde Guacamole." "info"
}

# Ejecutar función principal
main