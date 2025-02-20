### **Descripción del Proyecto**
**Resumen:**  
Un contenedor Docker basado en Windows Server Core que proporciona un entorno RDP (Remote Desktop Protocol) habilitado y un bot de Discord funcional. Este proyecto está diseñado para desarrolladores que necesitan un entorno aislado para compilar scripts Python en ejecutables (`exe`) mientras interactúan con un bot de Discord personalizable.

**Problema que resuelve:**  
- Proporciona un entorno Windows completamente funcional dentro de un contenedor Docker, eliminando la necesidad de configurar manualmente un servidor Windows.
- Permite la compilación de scripts Python a ejecutables utilizando PyInstaller.
- Ofrece un bot de Discord con comandos interactivos y personalizables.

**Principales características y beneficios:**  
- Entorno Windows con RDP habilitado para acceso remoto.
- Bot de Discord con comandos útiles y personalizables.
- Capacidad para compilar scripts Python a ejecutables.
- Medidas anti-detección para evitar la identificación de virtualización.
- Fácil de configurar y usar mediante Docker.

---

### **Características del Proyecto**
- **Entorno Windows con RDP habilitado:** Acceso remoto seguro a través de RDP.
- **Bot de Discord integrado:** Comandos interactivos como `/hello`, `/menu`, `/poll`, `/avatar`, `/random`, etc.
- **Compilación de scripts Python:** Uso de PyInstaller para convertir scripts Python en ejecutables.
- **Medidas anti-detección:** Configuraciones adicionales para evitar la identificación de virtualización.
- **Automatización completa:** Construcción y ejecución del contenedor mediante Docker.
- **Personalización:** Fácil de modificar y extender con nuevos comandos o funcionalidades.

---

### **Requisitos del Proyecto**
**Herramientas y software necesarios:**
- Docker Desktop (configurado para contenedores Windows).
- Cliente RDP (por ejemplo, `rdesktop` o Microsoft Remote Desktop).
- Python 3.x (instalado automáticamente en el contenedor).

**Dependencias específicas:**
- `discord.py`
- `pyinstaller`

---

### **Guía de Instalación**
**Paso 1: Clona el repositorio**
```bash
git clone https://github.com/tu-usuario/Windows-RDP-Discord-Bot.git
cd Windows-RDP-Discord-Bot
```

**Paso 2: Construye la imagen Docker**
```bash
docker build --build-arg BOT_TOKEN=your_token_here --build-arg RDP_PASSWORD=your_password_here -t windows-rdp-container .
```

**Paso 3: Ejecuta el contenedor**
```bash
docker run -d -p 3389:3389 --name windows_rdp windows-rdp-container
```

**Paso 4: Conéctate al contenedor via RDP**
```bash
rdesktop -u usuario_contenedor -p contrasena_segura <host-ip>:3389
```

**Paso 5: Compila el bot**
Dentro del contenedor:
```bash
pyinstaller --onefile --noconfirm --clean C:/Scripts/bot.py
```

---

### **6. Guía de Uso**
**Comandos básicos del bot:**
- `/hello`: Saluda al usuario con un botón interactivo.
- `/menu`: Muestra un menú desplegable con opciones.
- `/poll`: Crea una encuesta simple con botones "Sí" y "No".
- `/avatar`: Obtiene el avatar de un usuario.
- `/random`: Genera un número aleatorio entre 1 y 100.
- `/status`: Muestra la latencia del bot.
- `/help`: Lista todos los comandos disponibles.

**Ejemplo práctico:**
```bash
/poll "¿Te gusta este bot?"
```

---

### **Documentación Técnica**
**Arquitectura del proyecto:**
- **Dockerfile:** Configura el entorno Windows con RDP habilitado y Python instalado.
- **start.ps1:** Script de inicio que habilita RDP y mantiene el contenedor en ejecución.
- **bot.py:** Código del bot de Discord con comandos interactivos.

**Componentes principales:**
- **RDP:** Acceso remoto al contenedor.
- **Discord Bot:** Interacción con Discord mediante comandos slash.
- **PyInstaller:** Herramienta para compilar scripts Python a ejecutables.