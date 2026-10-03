---
publish: true
created: 2026-03-02T16:54
modified: 2026-03-02T16:58:40-05:00
tags:
  - moodle
  - problem
  - admin
---

# 🚀 Nueva exigencia de PHP en Moodle: cómo resolver el error de Composer en Plesk

En las versiones más recientes de **Moodle**, el archivo `composer.json` ahora exige **PHP ≥ 8.2**.

Si intentas ejecutar:

```bash
composer install --no-dev --classmap-authoritative
```

puede aparecer un error como:

```
Root composer.json requires php >=8.2.0 but your php version (8.1.x) does not satisfy that requirement.
```

Aunque tu Moodle funcione perfectamente en el navegador, Composer puede fallar. ¿Por qué?

## 🔎 El problema real: PHP Web ≠ PHP CLI

En servidores administrados con **Plesk**, es muy común tener varias versiones de PHP instaladas al mismo tiempo.

Por ejemplo:

|Entorno|Versión|
|---|---|
|PHP FPM (web)|8.4.18 ✅|
|PHP CLI (terminal)|8.1.x ❌|

Moodle puede estar funcionando con PHP 8.4 en producción, pero Composer usa la versión CLI del sistema (8.1), lo que genera el conflicto.

# 🛠 Cómo solucionarlo correctamente

## ✅ 1️⃣ Verificar qué versión usa CLI

```bash
php -v
```

Si muestra 8.1.x, ahí está el problema.

## ✅ 2️⃣ Usar directamente el PHP correcto de Plesk

En vez de cambiar el PHP global del sistema (lo cual puede romper otros sitios), ejecuta Composer con la versión correcta:

```bash
/opt/plesk/php/8.4/bin/php /usr/lib/plesk-9.0/composer.phar install --no-dev --classmap-authoritative
```

De esta manera:

- Composer usa PHP 8.4
- Coincide con la versión de producción
- No se afecta ningún otro dominio

## ✅ 3️⃣ Verificar extensiones necesarias

Antes de ejecutar Composer, revisa que PHP tenga las extensiones requeridas:

```bash
/opt/plesk/php/8.4/bin/php -m
```

Moodle necesita al menos:

- curl
- zip
- gd
- dom
- simplexml
- xml
- xmlreader
- intl
- mbstring
- opcache
- mysqli

Si falta alguna, puedes instalarla desde Plesk:

```bash
plesk installer --select-release-current --install-component php8.4-nombre_extension
```

# ⚠️ Qué NO hacer

❌ No usar:

```bash
composer install --ignore-platform-reqs
```

Eso solo oculta el problema y puede romper Moodle después.

❌ No cambiar `update-alternatives` del sistema si estás en un servidor con múltiples clientes.

# 🎯 Recomendación adicional

En servidores Plesk:

Siempre ejecuta Composer así:

```bash
/opt/plesk/php/VERSION/bin/php /usr/lib/plesk-9.0/composer.phar
```

Así garantizas coherencia entre:

- Entorno web
- CLI
- Dependencias instaladas

# 🧠 Conclusión

La “novedad” no es realmente un bug de Moodle, sino una consecuencia natural de la evolución del ecosistema PHP:

- Moodle exige versiones modernas.
- Composer valida estrictamente los requisitos.
- Plesk permite múltiples versiones simultáneas.

El problema aparece cuando CLI y FPM no coinciden. Una vez alineadas las versiones, la instalación funciona sin inconvenientes. Si administras múltiples instancias de Moodle en Plesk, este pequeño detalle puede ahorrarte horas de debugging.

Saludos!
Marchelo2212
