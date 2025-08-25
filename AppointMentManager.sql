--importante asegurarse de que el usuarios que este usando tenga permiso de creacion de base de datos
--en caso contrario crearla manualmente en la opcion Databases/New Database "click derecho en Databases y seleccionar New Database"

USE master;
GO

-- creamos la base de datos si no existe
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'AppointmentManager')
BEGIN
    CREATE DATABASE AppointmentManager;
END
GO

USE AppointmentManager;
GO
-- creacion de tablas sugeridas en el pdf

-- crear tabla Customers
CREATE TABLE Customers( Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
Name NVARCHAR(120) NOT NULL, Email NVARCHAR(255) NULL );

-- crear tabla Appointments
CREATE TABLE Appointments( Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY
KEY, CustomerId UNIQUEIDENTIFIER NOT NULL REFERENCES Customers(Id),
DateTime DATETIME2 NOT NULL, Status NVARCHAR(20) NOT NULL CHECK (Status IN
('scheduled','done','cancelled')) );

-- constraint para el doble booking 
CREATE UNIQUE INDEX UQ_Appointments_Slot ON Appointments(CustomerId,
DateTime);

-- constraint para evitar nombre y correo de clientes repetidos
ALTER TABLE Customers
ADD CONSTRAINT UQ_Customer
UNIQUE (Name, Email);
    
-- indices para mejorar performance en consultas
CREATE INDEX IX_Appointments_DateTime ON Appointments(DateTime);
CREATE INDEX IX_Appointments_Status ON Appointments(Status);
CREATE INDEX IX_Appointments_CustomerId ON Appointments(CustomerId);
GO

-- Insertar datos de prueba/seed
IF NOT EXISTS (SELECT * FROM Customers)
BEGIN
    DECLARE @Customer1Id UNIQUEIDENTIFIER = NEWID();
    DECLARE @Customer2Id UNIQUEIDENTIFIER = NEWID();
    DECLARE @Customer3Id UNIQUEIDENTIFIER = NEWID();
    
    INSERT INTO Customers (Id, Name, Email) VALUES 
    (@Customer1Id, 'Juan Pérez', 'juan.perez@gmail.com'),
    (@Customer2Id, 'María García', 'maria.garcia@gmail.com'),
    (@Customer3Id, 'Carlos López', 'carlos.lopez@gmail.com');
    
    INSERT INTO Appointments (CustomerId, DateTime, Status) VALUES 
    (@Customer1Id, '2024-12-01 10:00:00', 'scheduled'),
    (@Customer1Id, '2024-12-05 14:30:00', 'scheduled'),
    (@Customer2Id, '2024-12-02 09:00:00', 'done'),
    (@Customer2Id, '2024-12-10 16:00:00', 'scheduled'),
    (@Customer3Id, '2024-11-28 11:00:00', 'cancelled'),
    (@Customer3Id, '2024-12-15 13:00:00', 'scheduled');
    
    PRINT 'Datos de prueba insertados correctamente.';
END
ELSE
BEGIN
    PRINT 'Los datos de prueba ya existen.';
END
GO

-- Consultas de verificación
PRINT 'Verificando la creación de tablas y datos:';
SELECT 'Customers' as Tabla, COUNT(*) as Registros FROM Customers
UNION ALL
SELECT 'Appointments' as Tabla, COUNT(*) as Registros FROM Appointments;
GO

-- Vista para consultas complejas de citas con información del cliente
CREATE OR ALTER VIEW vw_AppointmentDetails AS
SELECT 
    a.Id,
    a.CustomerId,
    c.Name AS CustomerName,
    c.Email AS CustomerEmail,
    a.DateTime,
    a.Status,
    CASE 
        WHEN a.Status = 'scheduled' THEN 'Programada'
        WHEN a.Status = 'done' THEN 'Completada'
        WHEN a.Status = 'cancelled' THEN 'Cancelada'
        ELSE a.Status
    END AS StatusDescription
FROM Appointments a
INNER JOIN Customers c ON a.CustomerId = c.Id;
GO


PRINT 'Base de datos configurada correctamente.';
PRINT 'Para verificar los datos, ejecute: SELECT * FROM vw_AppointmentDetails;';