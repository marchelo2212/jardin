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
git init
git remote add origin https://github.com/marchelo2212/mi-quartz.git
git checkout -b v4
git add .
git commit -m "Inicializando Quartz"
git push -u origin v4
```

🚨 Importante:\
GitHub ya no acepta contraseñas → usar **Tokens (PAT)**.

# 🌐 7. Configurar GitHub Pages con Quartz

Usé el dominio:

```
https://marchelo2212.github.io
```

Configuración final del workflow (`.github/workflows/deploy.yml`):

```yaml
on:
  push:
    branches:
      - v4

permissions:
  contents: write
  pages: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm install
      - run: npx quartz build
      - uses: actions/upload-pages-artifact@v3
        with:
          path: public
  deploy:
    needs: build
    permissions:
      pages: write
      id-token: write
    uses: actions/deploy-pages@v4
```

Cuando todo está bien, el sitio se despliega automáticamente cada vez que hago:

```bash
git add .
git commit -m "update"
git push
```

# 🤖 8. Automatizando con un script deploy.sh

Creamos un script que:

- cambia a la rama correcta
- hace pull
- hace build
- hace commit si hay cambios
- sube a GitHub

```bash
#!/usr/bin/env bash

set -e

# RUTAS 
QUARTZ_REPO="Ruta-repo-PC/mi-quartz"

PAGES_REPO="Ruta-repo-github-pages/marchelo2212.github.io"

echo "🧭 Cambiando a repo Quartz..."

cd "$QUARTZ_REPO"
echo "🌿 Cambiando a rama v4..."
git checkout v4 # Mi main es V4

echo "🔍 Revisando cambios locales en Quartz..."

if [ -n "$(git status --porcelain)" ]; then

echo "📌 Hay cambios locales en Quartz. Haciendo commit..."

git add .

git commit -m "Cambios locales en Quartz antes de deploy"

else

echo "✅ No hay cambios locales en Quartz."

fi

echo "⬇️ Haciendo pull de los cambios que envió Quartz Syncer..."

git pull --rebase origin v4


echo "🧱 Generando sitio con Quartz..."

npx quartz build

echo "📦 Copiando resultado al repo de GitHub Pages..."

rm -rf "$PAGES_REPO"/*

cp -R public/* "$PAGES_REPO"/

echo "📤 Haciendo commit y push en marchelo2212.github.io..."

cd "$PAGES_REPO"

git add .

git commit -m "Deploy automático desde deploy.sh" || echo "ℹ️ No hay cambios nuevos para commitear en Pages."

git push

echo "✅ Deploy completado. Revisa https://marchelo2212.github.io"
```

# 🔁 9. Integración nativa con Obsidian: Quartz Syncer

En vez de usar enlaces simbólicos (primera opción que tomé), instalé el plugin:

👉 <https://saberzero1.github.io/quartz-syncer-docs/>

Este plugin permite:

- elegir qué carpeta del vault se publica
- sincronizar cambios automáticamente a GitHub
- manejar frontmatter automáticamente
- publicar/despublicar notas desde Obsidian

En mi caso configuré:

- Repo: `mi-quartz`
- Branch: `v4` (Esto no está textual pero toma el repo main, por ello puse v4 como main)
- Token: `PAT con contents:write`
- Carpeta raíz: `Public/`

Esto reemplazó totalmente el enlace simbólico.

# 🎨 10. Personalización del theme

Quartz permite extender los componentes del layout editando:

```
quartz.layout.ts
quartz/styles/custom.scss
```

Agregué:

- botones para ocultar/mostrar sidebars
- ajustes de flex
- colores adaptados a mi theme de Obsidian

Ejemplo:

```ts
Component.Flex({
  components: [
    { Component: Component.Search(), grow: true },
    { Component: Component.Darkmode() },
    { Component: Component.ReaderMode() },
  ]
})
```

Pueden ver los resultados en [https://marchelo2212.github.io](https://marchelo2212.github.io/)
Aquí el repo de mi quartz, donde podrán ver las modificaciones hechas en él: [GitHub - marchelo2212/mi-quartz: mi-quartz](https://github.com/marchelo2212/mi-quartz)

# ✔️ 11. Resultado final

Ahora tengo un flujo así:

1. Escribo notas en Obsidian → dentro de `Public/`
2. Quartz Syncer detecta cambios → los envía al repo en `v4` (main)
3. Ejecuto mi `deploy.sh`. para llevar de quartz a mi sitio web
   1. GitHub Actions construye Quartz
   2. GitHub Pages actualiza el sitio
4. El sitio queda publicado en:\
   👉 [https://marchelo2212.github.io](https://marchelo2212.github.io/)
   Todo **sin tocar terminal** si no quiero.\
   Y si quiero ajustes técnicos, puedo usar `deploy.sh`.

# 📌 Conclusiones y aprendizajes

- Quartz 4 es muy flexible, pero requiere entender su estructura.
- GitHub Pages + Actions da un flujo perfecto para sitios estáticos.
- Obsidian + Quartz Syncer convierte tu vault en un CMS real.
- Los bloqueadores como Brave afectan mucho los embeds.
- Personalizar Quartz es tan simple como editar TS/SCSS.
