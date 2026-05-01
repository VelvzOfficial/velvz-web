#!/bin/bash
# Instala la firma signature-embedded.html en la firma de Apple Mail más
# reciente. Ejecútalo CON Mail cerrado.
#
# Uso: sh install.sh

set -e

# Carpeta de datos de Apple Mail (la "V*" más reciente; macOS la cambia
# entre versiones — V10, V11, etc.)
MAIL_DIR=$(ls -d ~/Library/Mail/V* 2>/dev/null | tail -1)
if [ -z "$MAIL_DIR" ]; then
  echo "❌ No encuentro ~/Library/Mail/V* — ¿usas Apple Mail?"
  exit 1
fi

SIG_DIR="$MAIL_DIR/MailData/Signatures"

# Detecta si Mail está abierto
if pgrep -x "Mail" > /dev/null; then
  echo "⚠️  Mail está abierto. Ciérralo (⌘Q) y vuelve a ejecutar este script."
  exit 1
fi

# La firma más recientemente modificada (la que acabas de crear)
SIG_FILE=$(ls -t "$SIG_DIR"/*.mailsignature 2>/dev/null | head -1)
if [ -z "$SIG_FILE" ]; then
  echo "❌ No hay archivos .mailsignature en $SIG_DIR"
  echo "   Crea primero una firma vacía: Mail → Configuración → Firmas → +"
  exit 1
fi
echo "📍 Firma destino: $(basename "$SIG_FILE")"

# HTML embebido (icono base64)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HTML_FILE="$SCRIPT_DIR/signature-embedded.html"
if [ ! -f "$HTML_FILE" ]; then
  echo "❌ No encuentro $HTML_FILE"
  exit 1
fi

# Quitar el flag de bloqueo si la firma ya estaba bloqueada (por una
# instalación previa) — si no, el siguiente write fallaría.
chflags nouchg "$SIG_FILE" 2>/dev/null || true

# Backup por si acaso
cp "$SIG_FILE" "$SIG_FILE.bak"
echo "📋 Backup: $(basename "$SIG_FILE").bak"

# Extrae las cabeceras MIME (todo hasta la primera línea en blanco
# inclusive) — necesarias para que Apple Mail reconozca el archivo.
HEADERS=$(awk '/^$/{print; exit} {print}' "$SIG_FILE")
HTML=$(cat "$HTML_FILE")

# Escribe headers + HTML
{
  echo "$HEADERS"
  echo "$HTML"
} > "$SIG_FILE"

# Bloquea para que Mail no lo sobrescriba al reabrir
chflags uchg "$SIG_FILE"
echo "🔒 Archivo bloqueado (chflags uchg)"

echo ""
echo "✅ Listo. Reabre Mail."
echo "💡 En Configuración → Firmas, arrastra 'Velvz' a tu cuenta y"
echo "   márcala como predeterminada para que se aplique sola."
echo ""
echo "Para EDITAR la firma más adelante:"
echo "  chflags nouchg \"$SIG_FILE\""
echo "  # editar..."
echo "  chflags uchg \"$SIG_FILE\""
