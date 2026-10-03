## Caso de Estudio: El Concesionario "AutoPremium"

El concesionario registra todas sus ventas en un archivo de texto plano. Actualmente, la tabla tiene graves problemas de redundancia y campos mal estructurados.

### Tabla Plana: `REGISTRO_VENTAS` (Sin Normalizar)

| **VIN (Chasis)** | **Marca** | **Modelo** | **Especificaciones\_Tecnicas** | **ID\_Cliente** | **Nombre\_Cliente** | **Ciudad\_Cliente** | **ID\_Vendedor** | **Nombre\_Vendedor** | **Comision\_Vendedor** |
| ---------------- | --------- | ---------- | ----------------------------- | -------------- | ------------------ | ------------------ | --------------- | ------------------- | --------------------- |
| VIN101           | Toyota    | Corolla    | Motor 1.8, Híbrido            | C-500          | Juan Pérez         | Madrid             | V-10            | Ana Ruiz            | 5%                    |
| VIN102           | Toyota    | Corolla    | Motor 1.8, Híbrido            | C-600          | María López        | Sevilla            | V-10            | Ana Ruiz            | 5%                    |
| VIN201           | Ford      | F-150      | Motor 5.0, 4x4, Cuero         | C-500          | Juan Pérez         | Madrid             | V-20            | Luis Toro           | 7%                    |
