# Proyecto Integrador: GitHub Actions + Docker + Microsoft SQL Server

Este proyecto automatiza el despliegue de una base de datos relacional (Microsoft SQL Server) a través de prácticas de Integración Continua utilizando GitHub Actions y contenedores Docker. 

## Tecnologías Involucradas
* **Microsoft SQL Server (Docker Image):** Motor de base de datos relacional ejecutado de manera efímera para garantizar un entorno limpio en cada ejecución.
* **GitHub Actions:** Plataforma de CI/CD que permite orquestar flujos de trabajo (workflows). Se configuraron variables de entorno y *Secrets* (`MSSQL_SA_PASSWORD`) para evitar la exposición de credenciales en el código fuente.
* **T-SQL (Transact-SQL):** Lenguaje utilizado para crear el esquema, procedimientos almacenados y disparadores (triggers) que gestionan la lógica de negocio directamente en la base de datos.

## Reto Principal: Análisis Técnico

### Funcionamiento de la tabla lógica `inserted`
En SQL Server, cuando ocurre un evento `INSERT` o `UPDATE`, el motor crea automáticamente una tabla en memoria (lógica) llamada `inserted`. Esta tabla contiene copias de las filas que acaban de ser insertadas o modificadas, manteniendo exactamente la misma estructura de columnas que la tabla original. Permite a los triggers evaluar los datos entrantes antes de tomar decisiones o desencadenar otros procesos.

### Operaciones fila a fila (Row-by-Row) vs Procesamiento por Conjunto (Set-Based)
En el diseño inicial, el trigger utilizaba una asignación directa (`SELECT @VentaID = VentaID FROM inserted;`). Este enfoque asume que solo se insertará una fila a la vez. Si ocurre una inserción masiva (`INSERT INTO... VALUES (...), (...)`), la variable solo almacena el último ID, perdiendo el resto de las auditorías.

* **Fila a Fila (Row-by-Row):** Utilizado en nuestra solución modificada a través de un **Cursor**. El motor itera secuencialmente sobre la tabla `inserted` llamando al procedimiento almacenado repetidamente. Aunque resuelve el problema de múltiples inserciones de forma modular, es costoso en rendimiento computacional.
* **Por Conjunto (Set-Based):** Es el paradigma nativo y óptimo de las bases de datos relacionales. En lugar de iterar, se aplican operaciones matemáticas a bloques completos de datos simultáneamente. Un enfoque 100% *Set-Based* prescindiría del Cursor y ejecutaría un `INSERT INTO AuditoriaVentas SELECT * FROM inserted` de un solo golpe.

## Reto Avanzado: Control de Inventario Automatizado
Se implementó una tabla `Inventario`. Para integrar la lógica de manera robusta, el trigger captura cada inserción y pasa los parámetros (`VentaID`, `Producto`, `Cantidad`) al procedimiento almacenado `sp_RegistrarAuditoria`. Este procedimiento encapsula dos responsabilidades:
1. Auditar el movimiento.
2. Descontar el stock (existencias) actualizando la tabla `Inventario` en tiempo real.
