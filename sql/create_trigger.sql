USE EmpresaDB;
GO

-- Reto Principal: Trigger modificado para soportar inserciones múltiples
CREATE TRIGGER trg_AuditarVenta
ON Ventas
AFTER INSERT
AS
BEGIN
    -- Declaración de variables para iterar
    DECLARE @VentaID INT, @Producto VARCHAR(100), @Cantidad INT;

    -- Uso de un Cursor para procesar múltiples filas desde la tabla lógica 'inserted'
    DECLARE cur_ventas CURSOR FOR
    SELECT VentaID, Producto, Cantidad FROM inserted;

    OPEN cur_ventas;
    FETCH NEXT FROM cur_ventas INTO @VentaID, @Producto, @Cantidad;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Ejecutar el SP por cada fila insertada
        EXEC sp_RegistrarAuditoria @VentaID, @Producto, @Cantidad;
        FETCH NEXT FROM cur_ventas INTO @VentaID, @Producto, @Cantidad;
    END;

    CLOSE cur_ventas;
    DEALLOCATE cur_ventas;
END;
GO
