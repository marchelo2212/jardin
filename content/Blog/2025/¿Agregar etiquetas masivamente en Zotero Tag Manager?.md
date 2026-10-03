---
publish: true
created: 2025-10-09T11:07
modified: 2025-10-09T11:15:36-05:00
tags:
  - Zotero
  - Productividad
  - automatización
  - investigación
  - Research
  - Tools
---

# 🧩 ¿Cómo agregar etiquetas masivamente en Zotero Tag Manager?

## 📚 Contexto

Organizar referencias en **Zotero** puede volverse complejo cuando manejas una gran cantidad de documentos académicos, artículos o informes.\
Si dependes únicamente de las **colecciones**, pronto te encontrarás con una jerarquía interminable de carpetas y subcarpetas difíciles de mantener.

Una solución mucho más flexible es utilizar **etiquetas (tags)**. Las etiquetas permiten clasificar los elementos de manera transversal:\
un mismo documento puede pertenecer a múltiples categorías, temas o proyectos, sin necesidad de duplicarlo en distintas colecciones.

El complemento **[Zotero Tag Manager](https://github.com/windingwind/zotero-tag)** mejora enormemente el manejo de etiquetas al permitir buscarlas, filtrarlas, renombrarlas o eliminar varias de una vez.\
Sin embargo, tiene una limitación: **por defecto no incluye la función de agregar una etiqueta a varios elementos simultáneamente.**

---

## 🚧 Problema que se soluciona

**Agregar etiquetas a varios elementos de una sola vez.**

Aunque Zotero permite etiquetar ítems individualmente, no hay una opción nativa dentro de **Zotero Tag Manager** para aplicar una o más etiquetas a una selección múltiple.\
Esto hace que, si estás organizando grandes bibliotecas, tengas que repetir el proceso docenas de veces, perdiendo tiempo y coherencia en tu sistema de clasificación.

---

## 🌟 Por qué usar etiquetas (pros)

Usar etiquetas en lugar de depender exclusivamente de colecciones ofrece múltiples ventajas:

- **Flexibilidad total:** un mismo ítem puede tener múltiples etiquetas sin necesidad de estar en varias carpetas.
- **Organización transversal:** las etiquetas permiten relacionar documentos por tema, autor, método, o tipo de fuente, sin moverlos de su colección original.
- **Filtrado rápido:** puedes combinar varias etiquetas para hacer búsquedas complejas (por ejemplo, _"método cualitativo" + "educación secundaria"_).
- **Estandarización:** es posible mantener un vocabulario controlado de etiquetas, asegurando coherencia terminológica.
- **Automatización:** las etiquetas pueden usarse para activar acciones, crear listas dinámicas, o integrarse con otros flujos de trabajo mediante plugins y scripts.

---

## ⚙️ Pasos para agregar el script en Zotero Tag Manager

1. Abre **Zotero** y ve al menú:\
   `Editar → Preferencias → Actions & Tags` (o desde la barra superior si ya tienes el panel abierto).

2. Crea una **nueva acción**:
   - **Name:** `Agregar etiqueta a todo`
   - **Event:** `None`
   - **Operation:** `Run JavaScript` (o `Eval JS`)
   - **Menu Label:** `Agregar etiqueta a todo`
   - Marca ✅ **In Item Menu**
   - Desmarca otras opciones (Tools, Reader, Annotation, etc.)
   - Asegúrate de que **Enabled** esté activo.

3. En el campo **Data**, pega el script (el que evita el problema de repetición del prompt y permite añadir múltiples etiquetas separadas por comas).

4. Guarda la acción con **Save**.

5. En la interfaz principal de Zotero:
   - Selecciona varios elementos de tu biblioteca.
   - Haz clic derecho sobre ellos.
   - Elige **“Agregar etiqueta a todo”**.
     ![](https://i.imgur.com/UcoHBE2.png)
   - Escribe una o más etiquetas separadas por comas.
     ![](https://i.imgur.com/Tm5F3IO.png)
   - Podrás ver cómo aparecen en tu ventana de etiquetas -si la tienes activa-
   - ![](https://i.imgur.com/x5gC3Q2.png)

---

## 💻 Código a emplear

_Pega aquí tu script corregido que añade etiquetas masivamente y evita el triple prompt:_

```js

(function () {
  // ====== Utilidades de lock/caché ======
  var win = (Zotero.getMainWindow && Zotero.getMainWindow()) || window;
  var rootTargets = [win, Zotero, (win && win.document)];
  var LOCK_KEY = "__ADD_TAG_ALL_RUNNING__";
  var CACHE_KEY = "__ADD_TAG_ALL_CACHE__";
  var NOW = Date.now();
  var CACHE_TTL = 5000; // 5s

  function getFromAny(key) {
    for (var i = 0; i < rootTargets.length; i++) {
      var t = rootTargets[i];
      if (t && t[key] != null) return t[key];
    }
    return null;
  }
  function setOnAll(key, val) {
    for (var i = 0; i < rootTargets.length; i++) {
      var t = rootTargets[i];
      if (t) t[key] = val;
    }
  }

  // ¿ya hay un lock activo?
  var running = getFromAny(LOCK_KEY);
  if (running && (NOW - running.ts) < 8000) {
    // Ya se está ejecutando esta acción: salimos sin volver a preguntar ni aplicar
    return;
  }
  setOnAll(LOCK_KEY, { ts: NOW });

  function releaseLockSoon() {
    setTimeout(function () {
      setOnAll(LOCK_KEY, null);
      // invalidar caché pasado el TTL
      setTimeout(function () { setOnAll(CACHE_KEY, null); }, CACHE_TTL + 200);
    }, 200);
  }

  try {
    // ====== Selección ======
    var ZoteroPane = win.ZoteroPane;
    var items = (ZoteroPane && ZoteroPane.getSelectedItems && ZoteroPane.getSelectedItems()) || [];
    if (!items.length) {
      if (Zotero.alert) Zotero.alert(null, "Agregar etiqueta a todo", "No hay ítems seleccionados.");
      releaseLockSoon();
      return;
    }

    // ====== Prompt con caché ======
    function promptTags(callback) {
      // ¿tenemos tags cacheados recientes?
      var cached = getFromAny(CACHE_KEY);
      if (cached && (NOW - cached.ts) < CACHE_TTL && cached.tags && cached.tags.length) {
        // Ya respondimos una vez; NO volvemos a preguntar
        callback(cached.tags, /*fromCache=*/true);
        return;
      }

      // Pedimos etiquetas (una o varias separadas por comas)
      if (Zotero.Dialogs && Zotero.Dialogs.prompt) {
        Zotero.Dialogs
          .prompt("Agregar etiqueta a todo", "Ingrese etiqueta (o varias separadas por comas)", "")
          .then(function (res) {
            if (!res || res.button !== "ok") return callback([]);
            var tags = (res.text || "").split(",").map(function (t) { return t.trim(); }).filter(Boolean);
            setOnAll(CACHE_KEY, { ts: Date.now(), tags: tags });
            callback(tags);
          });
      } else {
        var v = (win.prompt && win.prompt("Ingrese etiqueta (o varias separadas por comas)", "")) || "";
        var tags = v.split(",").map(function (t) { return t.trim(); }).filter(Boolean);
        setOnAll(CACHE_KEY, { ts: Date.now(), tags: tags });
        callback(tags);
      }
    }

    promptTags(function (tags, fromCache) {
      if (!tags || !tags.length) { releaseLockSoon(); return; }

      // Si esta invocación vino inmediatamente después de otra (fromCache === true),
      // significa que es un duplicado -> no reaplicar para evitar duplicados visibles.
      if (fromCache) { releaseLockSoon(); return; }

      // ====== Aplicación ======
      var count = 0;
      for (var i = 0; i < items.length; i++) {
        var it = items[i];
        if (it && it.isRegularItem && it.isRegularItem()) {
          for (var j = 0; j < tags.length; j++) it.addTag(tags[j]);
          if (it.saveTx) it.saveTx();
          count++;
        }
      }

      var msg = 'Etiqueta(s) "' + tags.join(", ") + '" agregada(s) a ' + count + " ítem(s).";
      if (ZoteroPane && ZoteroPane.showNotification) ZoteroPane.showNotification(msg);
      else if (Zotero.debug) Zotero.debug(msg);

      releaseLockSoon();
    });
  } catch (e) {
    if (Zotero && Zotero.logError) Zotero.logError(e);
    releaseLockSoon();
  }
})();



```

Espero que te haya sido de utilidad

@marchelo22212
