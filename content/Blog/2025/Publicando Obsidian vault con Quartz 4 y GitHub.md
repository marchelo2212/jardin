---
publish: true
created: 2025-12-01T17:30
modified: 2025-12-01T17:52:11-05:00
---

# 🚀 Migrando mi Obsidian Vault a un sitio web estático con Quartz 4, GitHub Pages y automatización total

En este artículo cuento el proceso completo que seguí para transformar mi _vault_ de Obsidian en un sitio web estático moderno usando **Quartz 4**, desplegarlo en **GitHub Pages**, automatizar la subida con **scripts**, e integrar sincronización directa con Obsidian gracias al plugin **Quartz Syncer**.

Fue un camino lleno de decisiones, ajustes técnicos y descubrimientos útiles, así que aquí dejo todos los pasos documentados.\
Ojalá le sirva a otros que quieran hacer algo similar.

# 🗂️ 1. Preparando el entorno

Mi objetivo era claro:

> “Quiero publicar parte de mi Obsidian Vault como un sitio web, con control de versiones en GitHub, despliegue automático y un theme personalizado.”

Para esto usé:

- **MacBook Pro**
- **Obsidian + mi theme personalizado**
- **Quartz 4 (nuevo framework, no basado en Hugo)**
- **GitHub Pages**
- (Opcional) Un servidor VPS con Plesk ( no llegué a usarlo, me animé por GitHub Pages)

# 📦 2. Instalando Quartz 4 en mi Mac

Quartz no se instala como un paquete global. Simplemente clonas la plantilla y trabajas dentro:

```bash
git clone https://github.com/jackyzha0/quartz.git mi-quartz
cd mi-quartz
npm install
```

Para ver el sitio localmente:

```bash
npx quartz build --serve
```

Quartz corre en `http://localhost:8080`.

# 🔗 3. Conectando Quartz con mi Obsidian Vault

Tenía mi vault en:

```
/Users/…/Nextcloud/obsidian-MHO2212
```

Y quería que Quartz usara la subcarpeta `Public/` como contenido del sitio.\
En Quartz, la carpeta que actúa como contenedor de notas es siempre:

```
mi-quartz/content
```

Probamos dos opciones:

### ✔️ A. Enlace simbólico (funcionó al inicio)

```bash
ln -s /Users/.../obsidian-MHO2212/Public content
```

Pero esto luego lo **reemplazamos con Quartz Syncer**, más adelante en el proceso.

# 🧹 4. Limpieza masiva del frontmatter

Muchas de mis notas tenían errores YAML como:

```yaml
tags: []
  - mocs
```

Para limpiarlo, generamos un script Python que removió todas las líneas problemáticas:

```python
import os
from pathlib import Path

# 👉 CAMBIA ESTA RUTA POR LA DE TU VAULT
VAULT_PATH = Path("AQUI LA RUTA")

def fix_file(path: Path):
    text = path.read_text(encoding="utf-8")

    # Solo nos interesa si tiene frontmatter YAML
    if not text.startswith("---"):
        return False

    lines = text.splitlines(keepends=True)

    # Localizar bloque de frontmatter (entre los dos primeros '---')
    fm_start = 0
    try:
        fm_end = next(
            i for i in range(1, len(lines))
            if lines[i].strip() == "---"
        )
    except StopIteration:
        return False  # frontmatter mal formado, mejor no tocar

    frontmatter = lines[fm_start:fm_end+1]

    # Comprobar si tiene tags: [mocs]
    has_inline_mocs = any("tags:" in l and "[mocs]" in l for l in frontmatter)
    if not has_inline_mocs:
        return False

    # Borrar líneas tipo "  - mocs" dentro del frontmatter
    new_frontmatter = []
    changed = False
    for l in frontmatter:
        stripped = l.strip()
        if stripped == "- mocs":
            changed = True
            continue  # saltamos esta línea
        new_frontmatter.append(l)

    if not changed:
        return False

    # Volver a montar el archivo
    new_lines = new_frontmatter + lines[fm_end+1:]
    new_text = "".join(new_lines)

    # Hacer copia de seguridad
    backup_path = path.with_suffix(path.suffix + ".bak")
    backup_path.write_text(text, encoding="utf-8")

    # Escribir el archivo corregido
    path.write_text(new_text, encoding="utf-8")
    return True


def main():
    count = 0
    for root, dirs, files in os.walk(VAULT_PATH):
        for name in files:
            if not name.endswith(".md"):
                continue
            p = Path(root) / name
            if fix_file(p):
                count += 1
                print(f"Arreglado: {p}")
    print(f"\nTotal de archivos modificados: {count}")


if __name__ == "__main__":
    main()

```

Esto resolvió la mayor parte de los errores, pero no permitió que se indexen en Quartz todo el vault (tampoco era lo que se quería)

# 🔧 5. Configurando Quartz 4 (quartz.config.ts)

Activé funciones avanzadas, incluyendo soporte para HTML embebido:

```ts
Plugin.ObsidianFlavoredMarkdown({
  enableInHtmlEmbed: true,
}),
```

Esto permite usar directamente:

```html
<iframe src="..."></iframe>
```

Aunque descubrimos que **Brave y algunos bloqueadores** impiden que los iframes de LinkedIn carguen correctamente, pero esto es por la seguridad de los navegadores no de Quartz, la solución que halle fue permitir los iframe.
![](https://i.imgur.com/rOYSDZe.png)

# 📤 6. Subiendo el sitio a GitHub

Inicializamos el repo real:

```bash
# 📤 6. Subiendo el sitio a GitHub

Inicializamos el repo real (ahora llamado `jardin` para publicarse como subcarpeta nativa):

```bash
git init
git remote add origin https://github.com/marchelo2212/jardin.git
git checkout -b v4
git add .
git commit -m "Inicializando Quartz"
git push -u origin v4
```

🚨 Importante:  
GitHub ya no acepta contraseñas → usar **Tokens (PAT)** con permisos de repositorio.

# 🌐 7. Configurar GitHub Pages con Quartz (Subcarpeta /jardin/)

En la arquitectura actual, la raíz (`https://marchelo2212.github.io`) está reservada para el **CV Interactivo y Observatorio de Investigación**, mientras que el **Jardín Digital** se publica de forma nativa e independiente en:

```
https://marchelo2212.github.io/jardin/
```

### Configuración en `quartz.config.ts`:
Para que todos los enlaces internos, imágenes y scripts resuelvan correctamente en la subcarpeta:

```ts
configuration: {
  pageTitle: "marchelo2212",
  baseUrl: "marchelo2212.github.io/jardin",
  // ...
}
```

### Workflow de GitHub Actions (`.github/workflows/deploy.yml`):
En los ajustes del repositorio en GitHub (`Settings -> Pages`), configuramos **Source: GitHub Actions**. El flujo oficial de Quartz 4 se encarga de compilar y desplegar en la nube automáticamente:

```yaml
name: Deploy Quartz site to GitHub Pages

on:
  push:
    branches:
      - v4

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: 22

      - name: Install Dependencies
        run: npm ci

      - name: Build Quartz
        run: npx quartz build

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: public

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

# 🤖 8. Script de sincronización local (deploy.sh)

Con GitHub Actions en la nube, ya no es necesario compilar localmente ni copiar archivos manualmente entre repositorios. Nuestro `deploy.sh` local ahora es un script seguro de sincronización:

```bash
#!/usr/bin/env bash
set -e

QUARTZ_REPO="/Users/marcelosotaminga/Documents/proyectos-github/mi-quartz"

echo "🧭 Cambiando a repo Quartz..."
cd "$QUARTZ_REPO"

echo "🌿 Asegurando rama v4..."
git checkout v4

echo "⬇️ Sincronizando con GitHub (por cambios de Quartz Syncer)..."
git pull --rebase origin v4

echo "🔍 Revisando cambios locales en Quartz..."
if [ -n "$(git status --porcelain)" ]; then
  echo "📌 Hay cambios locales en Quartz. Haciendo commit..."
  git add .
  git commit -m "Update Quartz notes and config"
  echo "📤 Subiendo a GitHub (jardin)..."
  git push origin v4
  echo "🚀 ¡Cambios enviados a GitHub!"
else
  echo "✅ Todo sincronizado. No hay cambios pendientes."
fi

echo ""
echo "======================================================================"
echo "🌱 GitHub Actions compila y despliega automáticamente en:"
echo "   👉 https://marchelo2212.github.io/jardin/"
echo "======================================================================"
```

# 🔁 9. Integración nativa con Obsidian: Quartz Syncer

En vez de enlaces simbólicos, uso el plugin de Obsidian:

👉 [https://saberzero1.github.io/quartz-syncer-docs/](https://saberzero1.github.io/quartz-syncer-docs/)

Configuración en Obsidian:

- **Repo**: `jardin` (en tu cuenta de GitHub)
- **Branch**: `v4`
- **Token**: `PAT con permisos contents:write`
- **Carpeta raíz**: `Public/`

Cada vez que creas o editas una nota en Obsidian, Quartz Syncer la sube a la rama `v4`, y el GitHub Action la compila y publica en `/jardin/` sin tocar la terminal.

# 🛠️ 10. Optimizaciones y Solución de Errores Críticos

Durante la evolución del jardín resolvimos dos incidencias técnicas clave:

### A. Prevenir el Error 5 (Aw, Snap!) de Chrome por desbordamiento de memoria
Cuando una nota tiene diagramas grandes (por ejemplo SVGs de Excalidraw con payloads Base64), el generador de búsqueda de Quartz (`contentIndex.tsx`) indexaba esa cadena de 4 MB en texto plano, haciendo que `FlexSearch` consumiera gigabytes en el cliente y colapsara la pestaña del navegador con `STATUS_ACCESS_VIOLATION`.

**Solución aplicada** en `quartz/plugins/emitters/contentIndex.tsx`:
```typescript
// Filtra secuencias continuas mayores a 1.000 caracteres (Base64 / dumps)
content: (file.data.text ?? "").replace(/\S{1000,}/g, ""),
```
El archivo de búsqueda bajó de 4.1 MB a 470 KB, eliminando el cuelgue por completo.

### B. Fallo en generación de imágenes OG con Emojis compuestos
El plugin `CustomOgImages` fallaba al intentar renderizar emojis de teclado compuestos como `1️⃣` (`codepoint 31-20e3`).  
**Solución**: Comentar `Plugin.CustomOgImages()` en `quartz.config.ts`, permitiendo que Quartz use la portada social por defecto (`static/og-image.png`) y reduciendo el tiempo de compilación a solo unos segundos.

# ✔️ 11. Resultado final

El ecosistema opera de forma desacoplada y elegante:

1. **Escribo notas en Obsidian** dentro de `Public/`.
2. **Quartz Syncer** sube automáticamente los cambios a GitHub (`marchelo2212/jardin` en la rama `v4`).
3. **GitHub Actions** compila y publica en:  
   👉 [https://marchelo2212.github.io/jardin/](https://marchelo2212.github.io/jardin/)
4. **Mi Portada Principal y CV Académico** vive independiente en:  
   👉 [https://marchelo2212.github.io/](https://marchelo2212.github.io/)

# 📌 Conclusiones y aprendizajes

- **Desacoplamiento arquitectónico**: Servir el CV en la raíz y Quartz en `/jardin/` mediante repositorios separados de GitHub Pages evita sobreescrituras accidentales y permite que cada proyecto tenga su propio ciclo de vida.
- **CI/CD en la nube**: Dejar la compilación a GitHub Actions elimina la dependencia de scripts locales complejos.
- **Obsidian + Quartz Syncer**: Convierte tu bóveda personal en un CMS estático ultrarrápido sin fricciones.
- **Sanitización del índice de búsqueda**: Controlar el tamaño del archivo `contentIndex.json` es vital para que `FlexSearch` no sobrecargue la memoria del navegador.
