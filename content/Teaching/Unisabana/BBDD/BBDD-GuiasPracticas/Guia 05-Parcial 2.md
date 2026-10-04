---
publish: true
created: 2026-04-26T22:10:18.000Z
modified: 2026-04-26T22:10:18.000Z
---

# Guia 05-Parcial 2

## 🍕 Evaluación Práctica: Caso "PizzaMaster Solutions"

**Asignatura:** Bases de Datos | **Facultad de Ingeniería**

**Metodología:** Evaluación por Depuración y Progresión Lógica.

### 🎯 Objetivo de la Evaluación

Validar la competencia técnica en el ciclo de vida de un sistema de datos: desde el diseño físico robusto (**DDL**), la carga e integridad de la información (**DML**), hasta la explotación de datos para la toma de decisiones (**Queries**) y la conectividad segura de aplicaciones.

## Fase 1. El Escenario: El Caos de "PizzaMaster"

"PizzaMaster" es una pizzería artesanal que ha escalado su operación, pero su gestión de datos sigue anclada en hojas de papel y archivos Excel desordenados. Como Ingeniero/a de Datos, se te ha entregado un prototipo de base de datos desarrollado por un practicante, el cual contiene **errores críticos de lógica, sintaxis y diseño**.

**Problemas detectados por la gerencia:**

- **Segmentación Inexistente:** No es posible identificar a los clientes recurrentes para planes de fidelización.

- **Opacidad Financiera:** Se desconoce el rendimiento económico por tamaño de pizza (Pequeña, Mediana, Familiar), lo que impide ajustar precios.

- **Inconsistencia en Pedidos:** Existen registros de pedidos "huérfanos" que no pertenecen a ningún cliente real.

**Tu Misión (Requerimientos de Negocio):**

Debes corregir el código para garantizar que el sistema sea capaz de generar los siguientes 4 reportes estratégicos:

1. **Análisis de Ventas:** Total de ingresos agrupados por tamaño de pizza.

2. **Auditoría de Clientes:** Listado de clientes "fantasma" (registrados, pero que nunca han generado una compra).

3. **Métrica de Valor:** Cálculo del **Ticket Promedio** ($\text{Total Ventas} / \text{Número de Pedidos}$) de la pizzería.

4. **Perfil de Consumo:** Identificar el nombre del cliente junto con la pizza de mayor valor que ha adquirido en su historial.

### 🛠️ Instrucciones Generales

- ****Parámetros necesario:**** La base de datos debe llamarse: **"pizzamaster\_db"**
- **Documenta tu código:** Guarda el código que emplees en un editor de texto plano (notepad o similares), considera que luego de cada sección práctica se te presentarán preguntas en las que deberás revisar tu código.
- **No puedes regresar en las preguntas:** El cuestrionario solo permite avanzar por lo que deberás responder y seguir. 
- **Depuración Activa:** No te limites a copiar el código. Cada fase tiene errores sembrados que impedirán su ejecución.
- **Validación (Asserts):** En la fase de consultas, se te proporcionará el resultado esperado. Si tu consulta no arroja exactamente esos datos, la lógica de tu `JOIN` o `GROUP BY` es incorrecta.
- **Seguridad:** En la fase de conectividad, deberás aplicar el estándar **PDO** para evitar vulnerabilidades de Inyección SQL.
- **Backup de la base de datos:** Al al final deberás hacer un dump a la base de datos y cargar tu archivo sql de esta manera "Parcial2\_NombreApellido.sql".

## 2. Fase DDL: Estructura de Datos

> **Recuerda:**

**La base de datos debe llamarse: "pizzamaster\_db"**

### 2.1. Detalles de las Tablas

1. **Tabla `clientes`:** Debe tener un ID (numérico, autoincremental), nombre (obligatorio), correo (único) y fecha de registro.

2. **Tabla `pizzas`:** ID, nombre de la pizza, tamaño (ej. 'Familiar'), y precio (decimal).

3. **Tabla `pedidos`:** ID, fecha del pedido, el cliente que lo hizo (FK) y el total.

### **Instrucción:** El siguiente código falla. Encuentra los errores de diseño/sintaxis y corrígelos.

```



CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    total_pago DECIMAL(10,2),
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE pizzas (
    id_pizza INT AUTO_INCREMENT PRIMARY KEY,
    nombre_pizza VARCHAR(50) NOT NULL,
    tamano ENUM('Pequena', 'Mediana', 'Familiar'),
    precio DECIMAL(10,2)
)
```

> ###### **Una vez que haya solventado lo requerido en esta sección avance.**

## 3. Fase DML: Poblado de Datos

### 3.1. Detalles del Poblado (Lenguaje Natural)

- Insertar 3 clientes: \
  'Juan Perez', 'juan@mail.com'\
  'Maria Garcia', 'maria@mail.com'\
  'Luis Diaz', 'luis@mail.com'

- Insertar 3 pizzas: 'Pepperoni' (Familiar - $50.000), 'Hawaiana' (Mediana - $35.000), 'Veggie' (Pequena - \$25.000).

- Insertar 2 pedidos: Juan compró la Pepperoni y Maria la Veggie.

```
INSERT INTO pedidos (id_cliente, total_pago) VALUES (99, 100.00); 

INSERT INTO clientes (nombre, email) VALUES ('Carlos Solo'); 

INSERT INTO pizzas (nombre_pizza, tamano, precio) VALUES ('Carnes', 'Familiar', 'Mucho Dinero');
```

> ###### **Una vez que haya solventado lo requerido en esta sección avance.**

## 4. Fase de Consultas (Queries Estratégicas)

### 4.2. Código SQL con Errores y Assert

> **Instrucción:** Estas consultas tienen errores de lógica o agregación. Corrígelas para obtener el resultado esperado.

**Consulta 1: Ventas por tamaño**

> **Instrucción:** El dueño te ha pedido identificar el ingreso que se genera por cada tipo de pizza, según su tamaño. 

```
SELECT tamano, SUM(precio) FROM pizzas;
```

**Assert (Resultado esperado):** 

| tamano | SUM(precio) | \
| Familiar | 50000 |\
| Pequena | 25000 |

**Consulta 2: Clientes sin pedidos**

> **Instrucción:** El gerente se ha enterado que existen clientes fantasmas, es decir, registrados pero que nunca han hecho un pedido, te ha pedido identificarlos.

```
SELECT nombre FROM clientes 
INNER JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente;
```

**Assert (Resultado esperado):**

Luis Diaz

**Consulta 3: Ticket Promedio de Venta**

> **Instrucción:** El gerente quiere saber cuánto gasta un cliente en promedio cada vez que compra. 

```
SELECT AVG(precio) AS ticket_promedio FROM pizzas;
```

**Assert (Resultado esperado):**

|**ticket\_promedio**|
|---|
|37500.0000|

**Consulta 4: Cliente y su pizza más cara**

> **Instrucción:** Queremos un ranking de clientes con el lujo más alto que se han permitido (compra más alta). 

```
SELECT nombre, MAX(precio) 
FROM clientes 
JOIN pedidos ON clientes.id_cliente = id_cliente 
JOIN pizzas ON total_pago = precio
GROUP BY nombre;
```

**Assert (Resultado esperado):**

|**nombre**|**MAX(p.precio)**|
|---|---|
|Juan Perez|50000.00|
|Maria Garcia|25000.00|

> ###### **Una vez que haya solventado lo requerido en esta sección avance.**

## 5. Fase de Conectividad: Configuración del Acceso (`config.php`)

Para que el sistema de PizzaMaster funcione en la web, necesitamos un archivo de configuración que centralice las credenciales de la base de datos.

> **Instrucción:** El desarrollador junior intentó conectar la web con la base de datos de la pizzería, pero el navegador muestra una "Pantalla Blanca" o errores de PDO. Encuentra los 3 errores técnicos en los parámetros.

```
<?php
$host = 'localhost';
$database = 'pizza_master';
$user = 'admin_pizza';
$password = 'Pizza123!';
$charset = 'utf8mb4';

$dsn = "sqlserver:host=$host;dbname=database";charset=$charset"; 

$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
];

try {
    $pdo = new PDO(dsn, $user, $password); 
} catch (PDOException $e) {
    echo "Error";
}
?>
```

> Una vez que haya solventado lo requerido en esta sección avance.

## 6. Fase de Integración: Formulario de Registro de Pedidos

Para que la pizzería opere, los empleados deben poder ingresar pedidos desde una interfaz sencilla. El objetivo es que los datos viajen del HTML al SQL de forma segura.

Este código utiliza un formulario estándar y recibe los datos para ejecutarlos en una **sentencia preparada**.

NOTA:

Antes de seguir, crea un dos nuevos clientes considerando estos datos: 

Cliente 1: Tu nombre y apellido; tu correo electrónico -> Cliente 3. 

Cliente 2: Mónica Males; mona@correo.com -> Cliente 4. 

**Interfaz (form\_pedido.php):**

```
<form action="guardar_pedido.php" method="POST">
    Cliente (ID): <input type="number" name="cliente_id">
    Total a Pagar: <input type="text" name="total">
    <button type="submit">Registrar Pedido</button>
</form>
```

**Lógica SQL (guardar\_pedido.php):**

> Considere:\
> Se debe evitar vulnerabilidades de Inyección SQL.\
> Se debe registrar nuevos pedidos. \
> Revise detenidamente la sintaxis.

```
<?php
include 'config.php';

$id_c = $_POST['cliente_id'];
$total = $_POST['total'];

$sql = "INSERT INTO pedidoz (id_cliente total_pago) VALUES ($id_c, $total)";

$pdo->query($sql); 

echo "Procesado";
?>
```

Para usar este formulario, registre lo siguiente:

- Cliente 3, ha realizado una compra de 2 pizzas, 'Pepperoni', 'Familiar'
- Cliente 4, ha realizado una compra de 10 pizzas, 'Hawaiana', 'Mediana'

**Piense en esta preguntas y tenga claras las respuestas a cada una de ellas:**

- **¿Es funcional tener el campo "total\_pago"?**
- **¿Qué se debería hacer para tener un detalle de lo que cada cliente ha comprado?**
- **¿Qué ventajas tiene usar enumerate en este ejercicio?**

## 7. Fase de Respaldo y Migración: El "Dump" de la Base de Datos

El servidor de PizzaMaster va a ser migrado a la nube. Para ello, necesitamos generar un script SQL completo que contenga tanto la estructura (DDL) como los datos (DML).

> Instrucción: Un técnico intentó respaldar la base de datos para la migración, pero los comandos fallan o generan archivos vacíos. Identifica los errores técnicos en estas líneas.

```
# Intento 1
mysql -u admin_pizza -p pizzamaster_db > respaldo_pizza.sql

# Intento 2
mysql -u admin_pizza -p --dump pizzamaster_db > backup.sql

# Intento 3
mariadb-dump -pass Pizza123! > backup_final.sql
```

> Una vez que haya solventado lo requerido en esta sección avance en la evaluación y luego de enviar todo acérquese con el docente.
