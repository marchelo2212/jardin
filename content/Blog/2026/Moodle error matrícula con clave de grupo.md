# Bug en Moodle 5.x: Error 404 al matricularse con clave de grupo

**Fecha:** Junio 2026\
**Versiones afectadas:** Moodle 5.0.x (Build: 20250509) y Moodle 5.1.1 (Build: 20251208)\
**Componente:** `enrol/self` — Automatriculación con clave de grupo\
**Severidad:** Alta (impide completar la matrícula)

## El problema

Al usar el método de **automatriculación con clave de grupo** en Moodle 5.x, después de ingresar la clave correctamente el navegador redirige a una URL inválida:

```
https://campus.example.org/enrol/[object Object]
```

El resultado es una página de **Error 404 - Page Not Found**, impidiendo que el estudiante acceda al curso aunque la matrícula se haya procesado correctamente en el servidor.

![](https://i.imgur.com/59hNu6y.png)

## Causa raíz

El problema se encuentra en el método `process_dynamic_submission()` del archivo:

```
enrol/self/classes/form/enrol_form.php
```

Este método construye la URL de redirección usando `course_get_url()`, que retorna un **objeto `moodle_url`**, no un string:

```php
public function process_dynamic_submission() {
    global $CFG, $SESSION;
    $this->get_plugin()->enrol_self($this->get_instance(), $this->get_data());

    if (!empty($SESSION->wantsurl)) {
        $destination = $SESSION->wantsurl;
        unset($SESSION->wantsurl);
    } else {
        require_once($CFG->dirroot . '/course/lib.php');
        $destination = course_get_url($this->get_instance()->courseid); // retorna moodle_url
    }

    return $destination; // ← retorna objeto, no string
}
```

En Moodle 5.0+, el framework `dynamic_form` serializa el valor de retorno de `process_dynamic_submission()` usando `json_encode()` antes de enviarlo al cliente JavaScript. Un objeto PHP sin conversión explícita a string se serializa como `{}` (objeto vacío).

El JavaScript del cliente recibe ese objeto vacío y al asignarlo a `window.location.href` el navegador lo convierte automáticamente en la cadena `[object Object]`, resultando en la URL inválida.

### Flujo del bug

```
PHP: course_get_url() → objeto moodle_url
         ↓
PHP: json_encode(objeto) → "{}"
         ↓
JS:  JSON.parse("{}") → objeto vacío {}
         ↓
JS:  window.location.href = {} → "[object Object]"
         ↓
Navegador: GET /enrol/[object Object] → 404
```

## La solución

La corrección es mínima: un cast explícito a string en la línea de retorno del método `process_dynamic_submission()`.

**Archivo a editar:**

```
enrol/self/classes/form/enrol_form.php
```

**Cambio:**

```php
// ANTES (con bug)
return $destination;

// DESPUÉS (corregido)
return (string) $destination;
```

El cast `(string)` activa el método `__toString()` del objeto `moodle_url`, que retorna la URL completa como string. Así `json_encode()` serializa correctamente `"https://campus.example.org/course/view.php?id=5"` y el redirect funciona.

### Aplicar el fix por línea de comandos

```bash
# 1. Hacer backup del archivo original
cp enrol/self/classes/form/enrol_form.php \
   enrol/self/classes/form/enrol_form.php.bkp

# 2. Aplicar el fix
sed -i 's/return \$destination;/return (string) \$destination;/' \
   enrol/self/classes/form/enrol_form.php

# 3. Verificar
grep -n "return.*destination" enrol/self/classes/form/enrol_form.php
```

El resultado esperado es:

```
196:    return (string) $destination;
```

### Purgar cachés

Después de aplicar el fix, purgar las cachés desde:\
**Administración del sitio → Desarrollo → Purgar todas las cachés**

## Verificación

El bug fue detectado y confirmado en dos instalaciones independientes:

|Instalación|Versión|Resultado tras el fix|
|---|---|---|
|campus.espiraleducativa.org|Moodle 5.0.x Build 20250509|✅ Resuelto|
|lms.corape.org.ec|Moodle 5.1.1 Build 20251208|✅ Resuelto|

## ¿Por qué no afectaba versiones anteriores?

En versiones previas a Moodle 5.0, el valor retornado por `process_dynamic_submission()` pasaba por una capa de conversión implícita que transformaba el objeto `moodle_url` a string antes de serializarlo. A partir de Moodle 5.0, el pipeline del `dynamic_form` cambió y esa conversión implícita desapareció, exponiendo el bug latente.

## Reporte oficial

Este bug ha sido reportado en el tracker oficial de Moodle:\
🔗 [https://tracker.moodle.org](https://tracker.moodle.org/)

Si tienes una instalación Moodle 5.x con automatriculación por clave activada, se recomienda aplicar este fix hasta que esté disponible un parche oficial.

Saludo!
Marchelo2212
