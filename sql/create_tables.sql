USE EmpresaDB;
GO

-- Reto Avanzado: Tabla Inventario
CREATE TABLE Inventario(
    Producto VARCHAR(100) PRIMARY KEY,
    Stock INT
);

CREATE TABLE Ventas(
    VentaID INT IDENTITY(1,1) PRIMARY KEY,
    Producto VARCHAR(100),
    Cantidad INT,
    Fecha DATETIME DEFAULT GETDATE()
);

CREATE TABLE AuditoriaVentas(
    AuditoriaID INT IDENTITY(1,1) PRIMARY KEY,
    VentaID INT,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    Mensaje VARCHAR(255)
);
GO
