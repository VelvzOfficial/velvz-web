#!/bin/bash
# Copia la firma HTML al portapapeles con formato. Pégala directamente
# en el cuadro de firma de Mail (⌘V).
#
# No requiere Full Disk Access ni cerrar Mail.
#
# Uso: sh copy-to-clipboard.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HTML_FILE="$SCRIPT_DIR/signature-embedded.html"

if [ ! -f "$HTML_FILE" ]; then
  echo "❌ No encuentro $HTML_FILE"
  exit 1
fi

# osascript lee el HTML y lo pone en el portapapeles como «class HTML».
# Cuando pegas en Mail, Mail lo interpreta como rich-text/HTML, no como
# código fuente.
osascript <<EOF
set htmlFile to POSIX file "$HTML_FILE"
set the clipboard to (read htmlFile as «class HTML»)
EOF

if [ $? -eq 0 ]; then
  echo "✅ Firma copiada al portapapeles."
  echo ""
  echo "Pasos:"
  echo "  1. Abre Mail → Configuración (⌘,) → Firmas"
  echo "  2. Selecciona tu cuenta y crea una firma nueva con el botón +"
  echo "  3. Ponle nombre 'Velvz'"
  echo "  4. DESMARCA 'Usar fuente del mensaje predeterminada' (abajo)"
  echo "  5. Click en el cuadro de la derecha y pulsa ⌘V para pegar"
  echo "  6. Cierra Configuración y arrastra la firma a tu cuenta si quieres que sea predeterminada"
else
  echo "❌ Error copiando al portapapeles"
  exit 1
fi
