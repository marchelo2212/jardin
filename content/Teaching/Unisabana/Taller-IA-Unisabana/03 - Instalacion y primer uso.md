---
publish: true
created: 2026-10-15T13:26:41.267Z
modified: 2026-10-15T13:26:43.184Z
tags:
  - taller
  - antigravity
  - unisabana
---

# Instalación y primer uso · 15 + 15 minutos

← [[00 - Inicio - Taller Antigravity|Taller de Google Antigravity · Unisabana e-learning]]

## Antes de la sesión

Revisar [[11 - Preparacion y contingencias|Preparación y contingencias]]. La documentación oficial consultada el 15 de octubre de 2026 distingue la aplicación Antigravity de Antigravity IDE, además de CLI y extensiones. **Elegir y probar una sola interfaz para todos**. Ruta sugerida: aplicación Antigravity con proyectos locales; IDE opcional para inspeccionar código, no requisito adicional para el taller.

No asumir que todas las cuentas institucionales tienen acceso ni que existe una cuota ilimitada. Confirmar previamente con soporte la cuenta y modalidad permitidas. No pedir cuentas personales para procesar datos institucionales sin autorización.

## Instalación · 15 minutos

1. **0–3:** entrar en [descarga oficial](https://antigravity.google/download), elegir producto y sistema operativo acordados.
2. **3–8:** ejecutar el instalador e iniciar sesión con la cuenta aprobada. Si se necesita permiso administrativo, recurrir a soporte, no eludirlo.
3. **8–11:** crear un proyecto apuntando únicamente a la carpeta de práctica. No abrir todo el escritorio ni el vault de Obsidian.
4. **11–13:** revisar ajustes del proyecto: permisos de archivos, herramientas y ejecución; elegir la modalidad que permita revisar acciones. Evitar modos de ejecución irrestricta durante el aprendizaje.
5. **13–15:** pedir «Lista los archivos de este proyecto sin modificarlos» y comprobar que corresponde al caso correcto.

Los nombres exactos de menús pueden cambiar. Usar como referencia [Getting Started with Google Antigravity](https://codelabs.developers.google.com/getting-started-google-antigravity) y ensayar con la versión instalada.

## Estructura sugerida del proyecto

```text
caso-perfil/
  entrada/       # copia de práctica autorizada; no sobrescribir
  salida/        # resultados derivados
  scripts/       # código reproducible, si se genera
  evidencias/    # conteos, pruebas y revisión
  README.md      # reglas, limitaciones y cómo repetir
```

Las rutas del computador del facilitador no funcionarán en los equipos de participantes. Cada persona debe seleccionar su propia copia; los prompts utilizan rutas relativas.

## Explicación de uso · 15 minutos

**0–5 · Ubicarse.** Mostrar proyecto activo, conversación y archivos. Diferenciar una respuesta en el chat de un archivo efectivamente guardado. Si se usa el IDE, ubicar también explorador, editor y terminal.

**5–10 · Pedir y revisar el plan.** Con datos sintéticos, usar:

> Inspecciona entrada/ sin modificarla. Explica la estructura y propone un plan para normalizar los datos. Señala supuestos, riesgos y controles. Todavía no ejecutes transformaciones.

Leer el plan: ¿preserva originales?, ¿indica columnas reales?, ¿define excepciones?, ¿propone una comprobación?

**10–15 · Ejecutar y comprobar.** Autorizar una transformación acotada en salida/. Abrir el archivo, comparar ejemplos con entrada/ y confirmar conteos. Mostrar dónde se ve una solicitud de permiso y cómo detener una ejecución equivocada.

## Dependencias

Para Excel o CSV, el agente puede proponer Python y bibliotecas como pandas u openpyxl. Ensayar su disponibilidad antes de la sesión. Revisar cualquier instalación requerida: qué instala, de dónde y para qué. No introducir MCP, despliegues, credenciales de API ni automatizaciones programadas en este taller introductorio.

## Criterio de éxito

Cada participante identifica su carpeta, solicita un plan, entiende la transformación, abre la salida y explica al menos una comprobación. No se exige dominar comandos de terminal.
