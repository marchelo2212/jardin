---
publish: true
created: 2026-10-15T13:26:41.267Z
modified: 2026-10-15T13:26:43.223Z
tags:
  - taller
  - antigravity
  - unisabana
---

# Demostraciones guiadas · 15 minutos

← [[00 - Inicio - Taller Antigravity|Taller de Google Antigravity · Unisabana e-learning]]

Utilizar ejemplos sintéticos. No proyectar registros identificables de los archivos reales. Estas demostraciones enseñan el procedimiento, no resuelven por adelantado los casos.

## Demostración 1 · Normalizar sin inventar · 5 minutos

Crear un CSV de práctica con estos datos ficticios:

```csv
id,nombre,email,insignia
001,Ana Demo, ANA@example.org ,I01
002,Luis Ejemplo,luis@@example.org,I02
001,Ana Demo,ana@example.org,I02
```

Prompt:

> Conserva id como texto. Recorta espacios externos del correo y genera una clave de comparación en minúsculas sin sustituir el valor original. Señala correos con estructura sospechosa, sin adivinar correcciones. Revisa duplicados de asignación usando id + insignia, no solo id. Guarda datos y observaciones por separado.

Comprobar: siguen existiendo tres filas; `001` conserva ceros; Luis requiere revisión; Ana puede tener dos insignias legítimas. Preguntar por qué eliminar duplicados por persona sería incorrecto.

## Demostración 2 · Conciliar y caracterizar · 5 minutos

Catálogo esperado sintético: «Curaduría digital», «Archivo sonoro». Catálogo observado: « Curaduría digital », «Archivo sonoro avanzado».

> Genera claves de comparación con espacios normalizados. Clasifica coincidencias exactas normalizadas y candidatos no confirmados. No declares equivalencia solo por semejanza. Explica qué queda en cada fuente sin correspondencia confirmada.

Comprobar una coincidencia y una relación pendiente; la similitud no autoriza fusión.

Transferencia a JAseg: mostrar la diferencia entre «60 de 100 docentes respondieron sí» y «60% de todas las personas». Preguntar cuál es el denominador y si la pregunta aplicaba a todos. No atribuir estos números sintéticos a la encuesta.

## Demostración 3 · De una necesidad a un prototipo · 5 minutos

> Diseña una mini simulación de curaduría digital con dos decisiones sobre exhibir una pieza de archivo. Incluye objetivo de aprendizaje, alternativas, consecuencias y retroalimentación. Primero muestra la lógica; luego crea una página HTML local sencilla, sin servicios externos ni datos reales.

Revisar una decisión: ¿hay retroalimentación vinculada al aprendizaje o solo un botón que cambia de pantalla? Mostrar el archivo local si la ejecución termina; tener una maqueta de respaldo si no hay tiempo. No prometer un prototipo funcional sin abrirlo y probarlo.

## Pregunta transversal

«¿Qué parte del resultado aceptarían, qué revisarían y qué no puede decidir la IA con esta información?»
