#!/usr/bin/env bash
set -e

# RUTAS
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
echo "🌱 GitHub Actions compila y despliega automáticamente tu jardín en:"
echo "   👉 https://marchelo2212.github.io/jardin/"
echo "======================================================================"