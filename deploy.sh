#!/usr/bin/env bash
set -e

# RUTAS
QUARTZ_REPO="/Users/marcelosotaminga/Documents/proyectos-github/mi-quartz"
PAGES_REPO="/Users/marcelosotaminga/Documents/proyectos-github/marchelo2212.github.io"

echo "🧭 Cambiando a repo Quartz..."
cd "$QUARTZ_REPO"

echo "🌿 Cambiando a rama v4..."
git checkout v4

echo "🔍 Revisando cambios locales en Quartz..."
if [ -n "$(git status --porcelain)" ]; then
  echo "📌 Hay cambios locales en Quartz. Haciendo commit..."
  git add .
  git commit -m "Cambios locales en Quartz antes de deploy (fix baseUrl)"
else
  echo "✅ No hay cambios locales en Quartz."
fi

echo "⬇️  Haciendo pull..."
git pull --rebase origin v4

# --- MEJORA AQUÍ ---
echo "🧹 Limpiando caché local de Quartz..."
rm -rf public

echo "🧱 Generando sitio con Quartz..."
npx quartz build
# -------------------

echo "📦 Copiando resultado al repo de GitHub Pages..."
# Aseguramos que no borramos la carpeta .git del repo de destino
find "$PAGES_REPO" -maxdepth 1 ! -name '.git' ! -name '.' -exec rm -rf {} +
cp -R public/* "$PAGES_REPO"/

echo "📤 Haciendo commit y push en marchelo2212.github.io..."
cd "$PAGES_REPO"
git add .
git commit -m "Deploy automático: limpieza de caché y corrección de baseUrl" || echo "ℹ️ No hay cambios nuevos."
git push

echo "✅ Deploy completado. Revisa https://marchelo2212.github.io"