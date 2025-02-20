import discord
from discord import app_commands
from discord.ui import Button, View, Select
import sys
import random

# Configuración del bot
intents = discord.Intents.default()
client = discord.Client(intents=intents)
tree = app_commands.CommandTree(client)

# Clase para la vista personalizada con un menú desplegable
class MyView(View):
    def __init__(self):
        super().__init__(timeout=None)
        self.add_item(Select(
            placeholder="Choose an option!",
            options=[
                discord.SelectOption(label="Option 1", value="1"),
                discord.SelectOption(label="Option 2", value="2")
            ]
        ))

    async def interaction_check(self, interaction: discord.Interaction):
        return True  # Permitir que todos los usuarios interactúen

    async def on_select_option(self, interaction: discord.Interaction, select: Select):
        await interaction.response.send_message(f"You selected {select.values[0]}")

# Evento cuando el bot se conecta
@client.event
async def on_ready():
    try:
        await tree.sync()
        print(f'Logged in as {client.user}')
    except Exception as e:
        print(f"Error syncing commands: {e}")
        sys.exit(1)

# Comando /hello
@tree.command(name="hello", description="Simple greeting command")
async def hello(interaction: discord.Interaction):
    button = Button(label="Click Me!", style=discord.ButtonStyle.primary)

    async def button_callback(interaction: discord.Interaction):
        await interaction.response.send_message("Button clicked!")

    button.callback = button_callback
    view = View()
    view.add_item(button)
    await interaction.response.send_message("Hello!", view=view)

# Comando /menu
@tree.command(name="menu", description="Show dropdown menu")
async def show_menu(interaction: discord.Interaction):
    await interaction.response.send_message("Choose:", view=MyView())

# Comando /status
@tree.command(name="status", description="Check bot status and latency")
async def status(interaction: discord.Interaction):
    latency = round(client.latency * 1000)
    await interaction.response.send_message(f"Bot is online with a latency of {latency}ms.")

# Comando /help
@tree.command(name="help", description="List available commands")
async def help_command(interaction: discord.Interaction):
    commands = [cmd.name for cmd in tree.get_commands()]
    await interaction.response.send_message(f"Available commands: {', '.join(commands)}")

# Comando /random
@tree.command(name="random", description="Generate a random number between 1 and 100")
async def random_number(interaction: discord.Interaction):
    number = random.randint(1, 100)
    await interaction.response.send_message(f"Your random number is: {number}")

# Comando /avatar
@tree.command(name="avatar", description="Get the avatar of a user")
async def avatar(interaction: discord.Interaction, user: discord.User = None):
    user = user or interaction.user
    embed = discord.Embed(title=f"{user.name}'s Avatar", color=discord.Color.blue())
    embed.set_image(url=user.avatar.url)
    await interaction.response.send_message(embed=embed)

# Comando /poll
@tree.command(name="poll", description="Create a simple poll with two options")
async def poll(interaction: discord.Interaction, question: str):
    embed = discord.Embed(title="Poll", description=question, color=discord.Color.green())
    view = View(timeout=None)
    
    yes_button = Button(label="Yes", style=discord.ButtonStyle.success)
    no_button = Button(label="No", style=discord.ButtonStyle.danger)

    async def yes_callback(interaction: discord.Interaction):
        await interaction.response.send_message("You voted Yes!")

    async def no_callback(interaction: discord.Interaction):
        await interaction.response.send_message("You voted No!")

    yes_button.callback = yes_callback
    no_button.callback = no_callback

    view.add_item(yes_button)
    view.add_item(no_button)
    await interaction.response.send_message(embed=embed, view=view)

# Comando /reiniciar (Admin)
@tree.command(name="reiniciar", description="Reinicia el contenedor (Admin)")
@app_commands.checks.has_permissions(administrator=True)
async def reiniciar(interaction: discord.Interaction):
    """Reinicia el sistema (Requiere permisos de administrador)."""
    await interaction.response.send_message("⚠️ Reiniciando...")
    os.system("shutdown /r /t 1")

# Comando /logs (Admin)
@tree.command(name="logs", description="Muestra logs del bot (Admin)")
@app_commands.checks.has_permissions(administrator=True)
async def mostrar_logs(interaction: discord.Interaction):
    """Envía el archivo de logs al canal."""
    try:
        with open("bot.log", "rb") as log_file:
            await interaction.response.send_message(
                file=discord.File(log_file, "logs.txt")
            )
    except FileNotFoundError:
        await interaction.response.send_message("❌ Archivo de logs no encontrado")

# --------------------------
# Eventos y Ejecución
# --------------------------
@client.event
async def on_ready():
    """Maneja el evento de conexión exitosa del bot."""
    try:
        await tree.sync()
        print("Bot conectado")
    except Exception as e:
        print(f"Error sincronizando comandos: {e}")
        await client.close()

if __name__ == "__main__":
    BOT_TOKEN = "tu_token_aqui"
    if not BOT_TOKEN or BOT_TOKEN == "tu_token_aqui":
        print("Token no configurado")
        sys.exit(1)
    client.run(BOT_TOKEN)