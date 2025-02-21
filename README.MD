## Documentación de DockerWinRDP-Guacamole

---

### **Introducción**

Esta documentación proporciona una guía completa y fácil de entender sobre **DockerWinRDP-Guacamole**, diseñada para usuarios de todos los niveles, desde principiantes hasta expertos. Aquí encontrarás toda la información necesaria para entender, instalar, configurar y utilizar DockerWinRDP-Guacamole.

---

### **Descripción del Proyecto**

#### **Resumen:**
**DockerWinRDP-Guacamole** es una solución que combina **Docker**, **Apache Guacamole** y un contenedor Windows RDP para proporcionar acceso remoto seguro a través de un navegador web. Este proyecto resuelve el problema de acceder a entornos Windows desde cualquier dispositivo con un navegador, sin necesidad de software adicional.

#### **Principales características y beneficios:**
- **Acceso remoto seguro**: Usa Apache Guacamole para acceder al escritorio remoto a través de un navegador.
- **Automatización**: Scripts de instalación y configuración simplifican el despliegue.
- **Personalización**: Permite configurar credenciales, conexiones RDP y MySQL según las necesidades del usuario.
- **Escalabilidad**: Compatible con múltiples usuarios y conexiones simultáneas.
- **Portabilidad**: Todo se ejecuta dentro de contenedores Docker, lo que facilita su implementación en diferentes sistemas.

---

### **Requisitos del Proyecto**

#### **Herramientas y software necesarios:**
1. **Sistema Operativo**: Kali Linux o cualquier distribución basada en Debian/Ubuntu.
2. **Docker**: Instalado y configurado correctamente.
   ```bash
   sudo apt update
   sudo apt install -y docker.io docker-compose
   ```
3. **Git**: Para clonar el repositorio.
   ```bash
   sudo apt install -y git
   ```
4. **Python 3.x**: Necesario para compilar el bot de Discord (opcional).
   ```bash
   sudo apt install -y python3 python3-pip
   ```

---

### **Guía de Instalación**

#### **Paso 1: Clona el repositorio**
Clona el repositorio en tu máquina local:
```bash
git clone https://github.com/tu-usuario/DockerWinRDP-Guacamole.git
cd DockerWinRDP-Guacamole
```

#### **Paso 2: Construcción del proyecto**
Ejecuta el script `setup.sh` para instalar dependencias, construir el contenedor y configurar el entorno:
```bash
chmod +x setup.sh install.sh configure.sh
./setup.sh
```

Durante la ejecución, el script te pedirá:
- Credenciales para el usuario RDP (`RDP_USER` y `RDP_PASSWORD`).
- Si deseas configurar MySQL para Guacamole (opcional).

#### **Paso 3: Configuración inicial**
El script `setup.sh` ejecutará automáticamente los scripts `install.sh` y `configure.sh`. Estos scripts:
- Instalan Docker y otras dependencias.
- Construyen el contenedor DockerWinRDP.
- Despliegan Apache Guacamole y configuran la conexión RDP.

---

### **Guía de Uso**

#### **Uso básico:**
1. Accede a Guacamole en tu navegador:
   ```
   http://localhost:8080/guacamole
   ```
2. Inicia sesión con las credenciales predeterminadas:
   - Usuario: `guacadmin`
   - Contraseña: `guacadmin`

3. Conéctate al escritorio remoto utilizando la conexión `DockerWinRDP`.

#### **Ejemplo práctico:**
Para reiniciar el contenedor desde Discord, usa el comando `/reiniciar` (requiere permisos de administrador):
```bash
/reiniciar
```

#### **Comandos principales:**
- `/hello`: Saludo simple con un botón interactivo.
- `/menu`: Muestra un menú desplegable con opciones.
- `/status`: Verifica el estado y latencia del bot.
- `/help`: Lista los comandos disponibles.
- `/random`: Genera un número aleatorio entre 1 y 100.
- `/avatar`: Obtiene el avatar de un usuario.
- `/poll`: Crea una encuesta simple con botones "Sí" y "No".
- `/reiniciar`: Reinicia el contenedor (solo administradores).
- `/logs`: Envía los logs del bot al canal (solo administradores).

---

### **Documentación Técnica**

#### **Arquitectura del Proyecto:**
El proyecto utiliza una arquitectura modular basada en contenedores Docker:
1. **DockerWinRDP**: Contenedor Windows con RDP habilitado.
2. **Apache Guacamole**: Interfaz web para acceder al escritorio remoto.
3. **MySQL (opcional)**: Base de datos para almacenar configuraciones y conexiones.
4. **Bot de Discord**: Interfaz para interactuar con el sistema mediante comandos.

#### **Componentes principales:**
- **Dockerfile**: Define el contenedor DockerWinRDP.
- **docker-compose.yml**: Configura los servicios de Guacamole, `guacd` y MySQL.
- **bot.py**: Implementa el bot de Discord para interactuar con el sistema.
- **start.ps1**: Script de PowerShell que mantiene el contenedor activo y configura RDP.

#### **Código fuente:**
El código está organizado en carpetas y archivos modulares:
- **Scripts**: `setup.sh`, `install.sh`, `configure.sh` automatizan la instalación y configuración.
- **Logs**: Carpeta `logs/` almacena los registros generados por los scripts.
- **MySQL**: Carpeta `mysql-init/` contiene el archivo `initdb.sql` para inicializar la base de datos (si se usa MySQL).

---

### **Mantenimiento y Solución de Problemas**

#### **Verificación de logs:**
Para revisar los logs del proyecto:
1. Logs del script `setup.sh`:
   ```bash
   cat logs/setup.log
   ```
2. Logs del bot de Discord:
   ```bash
   cat bot.log
   ```
3. Logs de Docker:
   ```bash
   docker logs <nombre-del-contenedor>
   ```

#### **Solución de problemas comunes:**
- **Error al iniciar Docker**: Asegúrate de que Docker esté instalado y ejecutándose.
  ```bash
  sudo systemctl start docker
  ```
- **Error al conectar a Guacamole**: Verifica que los puertos no estén ocupados y que los servicios estén activos.
  ```bash
  docker-compose ps
  ```
- **Error en el bot de Discord**: Revisa que el token del bot esté configurado correctamente en las variables de entorno.

---

### **Conclusión**

**DockerWinRDP-Guacamole** es una solución robusta y flexible para acceder remotamente a un entorno Windows desde cualquier navegador. Con esta documentación, deberías poder instalar, configurar y utilizar el proyecto sin problemas. Si tienes preguntas adicionales o encuentras errores, consulta la sección de [issues](https://github.com/tu-usuario/DockerWinRDP-Guacamole/issues) en el repositorio.

--- 

Espero que esta documentación sea útil y completa para tus necesidades. 😊
