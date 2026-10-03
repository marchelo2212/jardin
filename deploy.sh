#!/usr/bin/env bash
set -e

# RUTAS
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUARTZ_REPO="${QUARTZ_REPO:-$SCRIPT_DIR}"

echo "🧭 Cambiando a repo Quartz ($QUARTZ_REPO)..."
cd "$QUARTZ_REPO"

echo "🌿 Asegurando rama v4..."
git checkout v4

echo "🔍 Revisando cambios locales pendientes..."
if [ -n "$(git status --porcelain)" ]; then
  echo "📌 Guardando cambios locales pendientes..."
  git add .
  git commit -m "Update Quartz notes and config"
fi

echo "⬇️ Sincronizando con GitHub (por cambios de Quartz Syncer)..."
git pull --rebase origin v4

echo "📤 Enviando actualizaciones a GitHub..."
git push origin v4

echo ""
echo "======================================================================"
echo "🌱 GitHub Actions compila y despliega automáticamente tu jardín en:"
echo "   👉 https://marchelo2212.github.io/jardin/"
echo "======================================================================"