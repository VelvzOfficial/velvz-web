# Firma de email Velvz

Firma HTML estilo Velvz para Apple Mail. Mantiene la identidad de la web (tipografía Apple system, azul accent `#0A84FF`, separadores sutiles) sobre fondo blanco — los fondos oscuros se rompen en muchos clientes al hacer reply/forward, así que la firma es light pero con detalles de marca.

## Archivos

- **`signature.html`** — versión con icono enlazado a `https://velvz.com/velvz-icon.png`. Email pesa ~1 KB. Requiere internet para mostrar el icono y el cliente debe permitir imágenes remotas (algunos las bloquean por defecto).
- **`signature-embedded.html`** — versión con icono embebido como `data:image/png;base64,…`. Email pesa ~78 KB. **Funciona siempre**, sin internet ni permisos del cliente. Recomendada.

## Implementar en Apple Mail (macOS)

1. **Crea una firma vacía primero** (Apple Mail necesita generar el archivo antes de poder editarlo):
   - Mail → Configuración (`⌘,`) → Firmas
   - Selecciona la cuenta donde quieres la firma
   - Click `+` para añadir
   - Ponle nombre `Velvz`
   - Escribe cualquier texto provisional (ej. `x`) en el cuadro de la derecha
   - Cierra Configuración

2. **Cierra Mail completamente** (`⌘Q`).

3. **Localiza el archivo** que acaba de generar Apple Mail:
   ```bash
   ls -lt ~/Library/Mail/V*/MailData/Signatures/*.mailsignature | head -3
   ```
   El más reciente es el que acabas de crear. Apunta su ruta completa.

4. **Edita el archivo** con un editor:
   ```bash
   open -e "/ruta/al/archivo.mailsignature"
   ```
   El archivo se ve algo así:
   ```
   Content-Type: text/html;
   	charset=us-ascii
   Content-Transfer-Encoding: 7bit
   Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.131.1.6\))

   <body><div>x</div></body>
   ```
   - **Conserva las 4 primeras líneas** (los headers MIME) y la línea en blanco que las sigue.
   - **Sustituye TODO lo que viene después** por el contenido de `signature-embedded.html` (o `signature.html` si prefieres icono enlazado).
   - Guarda (`⌘S`).

5. **Bloquea el archivo** para que Apple Mail no lo sobrescriba al iniciar:
   ```bash
   chflags uchg "/ruta/al/archivo.mailsignature"
   ```

6. **Reabre Mail**. La firma `Velvz` debería estar disponible al redactar emails. En Configuración → Firmas → arrastra la firma `Velvz` a la cuenta y márcala como predeterminada si quieres que se aplique sola.

## Editar la firma más adelante

```bash
chflags nouchg "/ruta/al/archivo.mailsignature"
# editar el archivo
chflags uchg "/ruta/al/archivo.mailsignature"
```

## Personalizar el contenido

En `signature.html` o `signature-embedded.html` puedes ajustar:

| Qué | Dónde |
|---|---|
| Nombre | Línea con `Alejandro De La Peña` |
| Cargo | Línea con `Fundador · Velvz` |
| Email | `mailto:contact@velvz.com` y el texto del enlace |
| Web | `https://velvz.com` (los dos sitios) |
| Color del azul | `#0A84FF` (Apple system blue, igual que el `--accent` de la web) |
| Tamaño del icono | `width="56" height="56"` |

## Cómo se ve la firma

```
┌─────────────────────────────────────────┐
│         │                                │
│  [icon] │  Alejandro De La Peña          │
│   56px  │  Fundador · Velvz              │
│         │                                │
│         │  contact@velvz.com · velvz.com │
└─────────────────────────────────────────┘
```

- Icono Velvz a la izquierda (56×56, sin border-radius — el PNG ya viene con sus esquinas redondeadas en el alfa)
- Línea vertical sutil de separación (`#d2d2d7`)
- Nombre en bold
- Cargo en gris medio (`#6e6e73`) con letter-spacing ligeramente abierto
- Enlaces en azul Apple sin subrayado (más limpio)
