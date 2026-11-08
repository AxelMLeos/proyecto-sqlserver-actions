USE EmpresaDB;
SET NOCOUNT ON;
SELECT v.VentaID, v.Producto, v.Cantidad, v.Fecha, i.Stock AS StockRestante
FROM Ventas v
INNER JOIN Inventario i ON v.Producto = i.Producto;
