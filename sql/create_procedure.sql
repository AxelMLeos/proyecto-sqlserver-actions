USE EmpresaDB;
GO

-- Procedimiento modificado para recibir parámetros y cumplir el Reto Avanzado
CREATE PROCEDURE sp_RegistrarAuditoria
    @VentaID INT,
    @Producto VARCHAR(100),
    @Cantidad INT
AS
BEGIN
    -- 1. Registrar en auditoría
    INSERT INTO AuditoriaVentas(VentaID, Mensaje)
    VALUES(@VentaID, 'Venta registrada automáticamente');

    -- 2. Reto Avanzado: Actualizar existencias de inventario
    UPDATE Inventario
    SET Stock = Stock - @Cantidad
    WHERE Producto = @Producto;
END;
GO
