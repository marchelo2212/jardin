---
publish: true
created: 2026-08-07
modified: 2026-08-07
tags:
  - moodle
  - smtp
  - oauth2
  - gmail
  - google-workspace
  - administración-lms
---

# SMTP OAuth2 en Moodle con Gmail: cuando el problema no es la contraseña, sino el scope

Configurar el correo saliente de Moodle con Gmail o Google Workspace mediante OAuth2 parece, en principio, un procedimiento directo: crear un cliente OAuth en Google Cloud, registrar la URI de redirección, conectar la cuenta de sistema y probar el envío de correo.

Pero hay un detalle que puede romper toda la configuración aunque casi todo parezca estar bien: **el scope de Gmail debe estar en el campo correcto dentro del emisor OAuth2 de Moodle**.

El síntoma suele ser confuso. Moodle intenta enviar correo por SMTP, PHPMailer inicia la conexión con `smtp.gmail.com`, negocia `STARTTLS`, pero la autenticación `XOAUTH2` falla con un mensaje parecido a este:

```text
CLIENT -> SERVER: AUTH XOAUTH2 <token base64>
SERVER -> CLIENT: 334 {"status":"400","schemes":"Bearer","scope":"https://mail.google.com/"}
SMTP ERROR: AUTH command failed
SERVER -> CLIENT: 535-5.7.8 Username and Password not accepted.
```

A primera vista, el error final parece apuntar a usuario o contraseña:

```text
Username and Password not accepted
```

Pero en una configuración OAuth2 esa lectura puede ser engañosa. El dato importante está antes:

```text
"scope":"https://mail.google.com/"
```

Google no está diciendo simplemente "credenciales incorrectas". Está indicando que el token usado para autenticar contra Gmail no tiene el permiso necesario.

![captura del log SMTP de Moodle mostrando el error XOAUTH2 y el scope https://mail.google.com/](https://i.imgur.com/sYLdOhS.png)

## El problema real

En Moodle, el emisor OAuth2 puede tener configurados distintos ámbitos de autorización. El punto crítico es que no todos los scopes se usan para lo mismo.

Hay dos campos que suelen confundirse:

1. **Ámbitos incluidos en una solicitud de inicio de sesión**
2. **Ámbitos incluidos en una solicitud de inicio de sesión para acceso sin conexión**

El primero aplica al inicio de sesión interactivo con Google. Es decir, al flujo donde una persona utiliza su cuenta para autenticarse en Moodle.

El segundo aplica al acceso offline. Ese es el flujo que permite conectar una **cuenta de sistema** y obtener un `refresh_token`, que luego Moodle puede usar en segundo plano para servicios internos como el envío de correo saliente.

La diferencia es fundamental: **el SMTP de Moodle no depende del scope del login interactivo, sino del token offline de la cuenta de sistema**.

Si el campo de acceso sin conexión solo contiene:

```text
openid profile email
```

Moodle podrá identificar la cuenta, pero no tendrá autorización para usar Gmail como servicio SMTP.

Para SMTP con Gmail mediante OAuth2, el campo de acceso sin conexión debe incluir:

```text
https://mail.google.com/
```

Un valor típico quedaría así:

```text
openid profile email https://mail.google.com/
```

![Captura del emisor OAuth2 en Moodle resaltando el campo de acceso sin conexión](https://i.imgur.com/cPNYN4T.png)

## Por qué Google Cloud Console no basta

Una trampa frecuente es pensar que basta con declarar el scope `https://mail.google.com/` en Google Cloud Console.

Ese paso es necesario, pero no suficiente.

Google Cloud define qué permisos puede solicitar la aplicación. Moodle, en cambio, define qué permisos solicita realmente durante el flujo de autorización.

Si Google Cloud permite el scope, pero Moodle no lo pide al conectar la cuenta de sistema, el token resultante no incluirá acceso a Gmail. El resultado es un token técnicamente válido, pero inútil para autenticar SMTP mediante `XOAUTH2`.

Aquí está la idea clave:

> El scope autorizado en Google Cloud no se hereda mágicamente. Moodle debe solicitarlo explícitamente en el flujo correcto.

## Cómo diagnosticarlo

Cuando aparezca un fallo de autenticación SMTP OAuth2 en Moodle, conviene revisar en este orden:

1. Que Gmail API esté habilitada en el proyecto de Google Cloud.
2. Que el cliente OAuth tenga registrado el redirect URI correcto de Moodle.
3. Que el ID de cliente y el secreto coincidan con los configurados en Moodle.
4. Que la cuenta de sistema tenga Gmail activo y licencia válida en Google Workspace.
5. Que el scope `https://mail.google.com/` esté autorizado en Google Cloud.
6. Que el mismo scope esté en Moodle dentro de **Ámbitos incluidos en una solicitud de inicio de sesión para acceso sin conexión**.

Hay una prueba sencilla que suele revelar el problema: revocar el acceso de la aplicación desde la cuenta de Google y volver a conectar la cuenta de sistema en Moodle.

Al repetir el consentimiento, observa qué permisos solicita Google. Si la pantalla solo muestra permisos básicos como nombre, imagen de perfil y dirección de correo, pero no menciona Gmail, Moodle no está solicitando el scope necesario.

![](https://i.imgur.com/joJpPdG.png)
![](https://i.imgur.com/jorH6sg.png)

![Captura de pantalla de consentimiento de Google mostrando permisos de Gmail](https://i.imgur.com/ahQRLiO.png)

## Corrección paso a paso

En Moodle:

1. Ir a **Administración del sitio -> Servidor -> OAuth 2 services**.
2. Editar el emisor OAuth2 usado para Google.
3. Buscar el campo **Ámbitos incluidos en una solicitud de inicio de sesión para acceso sin conexión**.
4. Agregar el scope de Gmail:

```text
https://mail.google.com/
```

5. Dejar el campo con un valor similar a:

```text
openid profile email https://mail.google.com/
```

6. Guardar los cambios.
7. Revocar el acceso anterior de la aplicación desde la cuenta de Google.
8. Reconectar la cuenta de sistema desde Moodle.
9. Confirmar que la pantalla de consentimiento ya solicita permisos de Gmail.
10. Probar nuevamente el envío de correo.

Si la autenticación es correcta, el envío SMTP debería completar el flujo `XOAUTH2` sin devolver el error `535-5.7.8`.

## Qué no conviene hacer

No conviene resolver este problema cambiando contraseñas, creando cuentas nuevas o regenerando clientes OAuth sin revisar primero los scopes usados por Moodle.

Tampoco conviene asumir que el error final de PHPMailer describe toda la causa. En este caso, el mensaje:

```text
Username and Password not accepted
```

es apenas la consecuencia visible. La causa está en el token OAuth generado sin el permiso necesario.

## Lección técnica

El aprendizaje es pequeño, pero importante para administradores de Moodle:

**en OAuth2, no basta con que un permiso exista en la configuración del proveedor; el cliente debe solicitarlo en el flujo exacto que usará después.**

En el caso de Moodle y Gmail SMTP:

- El login con Google usa un conjunto de scopes.
- La cuenta de sistema usa scopes de acceso sin conexión.
- El envío SMTP depende de la cuenta de sistema.
- Por tanto, `https://mail.google.com/` debe estar en el campo de acceso sin conexión.

Esta distinción evita perder horas revisando credenciales, APIs y configuraciones de servidor cuando el problema real está en una línea de scopes.

## Checklist rápido

Antes de cerrar una configuración SMTP OAuth2 con Gmail en Moodle, revisa:

- Google Cloud tiene habilitada Gmail API.
- El OAuth client tiene la URI de redirección correcta de Moodle.
- Moodle tiene el ID de cliente y secreto correctos.
- La cuenta de sistema tiene Gmail activo.
- El emisor OAuth2 de Moodle está habilitado para servicios internos.
- El campo de acceso sin conexión incluye:

```text
openid profile email https://mail.google.com/
```

Con eso, Moodle debería poder obtener un token válido no solo para identificar la cuenta, sino para enviar correo usando Gmail mediante SMTP OAuth2.

Espero que les sirva!

Marchelo2212
