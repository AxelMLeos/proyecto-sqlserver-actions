USE EmpresaDB;
GO

-- 1. Poblar inventario inicial
INSERT INTO Inventario(Producto, Stock) VALUES('Laptop', 50), ('Monitor', 100);

-- 2. Inserción múltiple para probar el Trigger modificado
INSERT INTO Ventas(Producto, Cantidad) 
VALUES 
    ('Laptop', 3), 
    ('Monitor', 5);
GO
