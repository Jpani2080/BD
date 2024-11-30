-- Crear la base de datos
CREATE DATABASE TallerMecanico;
USE TallerMecanico;

-- Tabla de clientes
CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Telefono VARCHAR(15),
    Email VARCHAR(100),
    Direccion VARCHAR(255),
    FechaRegistro DATE DEFAULT GETDATE()
);


-- Tabla de vehículos
CREATE TABLE Vehiculos (
    VehiculoID INT PRIMARY KEY,
    ClienteID INT NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    Modelo VARCHAR(50) NOT NULL,
    Año INT NOT NULL,
    Placa VARCHAR(20) UNIQUE NOT NULL,
    TipoVehiculo VARCHAR(15)DEFAULT 'Automóvil' NOT NULL, 
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- restricción CHECK para limitar los valores de TipoVehiculo
ALTER TABLE Vehiculos
ADD CONSTRAINT CHK_TipoVehiculo 
CHECK (TipoVehiculo IN ('Automóvil', 'Motocicleta', 'Camión', 'Otro'));


SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Vehiculos';
DROP TABLE IF EXISTS Vehiculos;



-- Tabla de empleados
CREATE TABLE Empleados (
    EmpleadoID INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Cargo VARCHAR(50) NOT NULL,
    Telefono VARCHAR(15),
    Email VARCHAR(100),
    FechaContratacion DATE 
);

-- Tabla de servicios
CREATE TABLE Servicios (
    ServicioID INT  PRIMARY KEY,
    NombreServicio VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Precio DECIMAL(10, 2) NOT NULL
);

-- Tabla de repuestos
CREATE TABLE Repuestos (
    RepuestoID INT PRIMARY KEY,
    NombreRepuesto VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Precio DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL
);

-- Tabla de órdenes de reparación
CREATE TABLE OrdenesReparacion (
    OrdenID INT PRIMARY KEY,
    VehiculoID INT NOT NULL,
    EmpleadoID INT NOT NULL,
    FechaInicio DATE,
    FechaFin DATE,
    Estado VARCHAR(15) DEFAULT 'Pendiente',
    Total DECIMAL(10, 2),
    FOREIGN KEY (VehiculoID) REFERENCES Vehiculos(VehiculoID),
    FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID)
);

ALTER TABLE OrdenesReparacion
ADD CONSTRAINT CHK_Estado 
CHECK (Estado IN ('Pendiente', 'En Proceso', 'Completada', 'Cancelada'));

-- Tabla de detalle de servicios en la orden
CREATE TABLE DetalleServicios (
    DetalleID INT PRIMARY KEY,
    OrdenID INT NOT NULL,
    ServicioID INT NOT NULL,
    Cantidad INT NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrdenID) REFERENCES OrdenesReparacion(OrdenID),
    FOREIGN KEY (ServicioID) REFERENCES Servicios(ServicioID)
);

-- Tabla de detalle de repuestos en la orden
CREATE TABLE DetalleRepuestos (
    DetalleID INT PRIMARY KEY,
    OrdenID INT NOT NULL,
    RepuestoID INT NOT NULL,
    Cantidad INT NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrdenID) REFERENCES OrdenesReparacion(OrdenID),
    FOREIGN KEY (RepuestoID) REFERENCES Repuestos(RepuestoID)
);

-- Tabla de facturación
CREATE TABLE Facturas (
    FacturaID INT PRIMARY KEY,
    OrdenID INT NOT NULL,
    FechaFactura DATE,
    TotalFactura DECIMAL(10, 2),
    FOREIGN KEY (OrdenID) REFERENCES OrdenesReparacion(OrdenID)
);

-- Insertar datos de ejemplo
INSERT INTO Clientes (Nombre, Apellidos, Telefono, Email, Direccion) VALUES
('Juan', 'Pérez', '555123456', 'juan.perez@example.com', 'Calle Falsa 123'),
('María', 'Gómez', '555987654', 'maria.gomez@example.com', 'Avenida Siempre Viva 456');

INSERT INTO Vehiculos (ClienteID, Marca, Modelo, Año, Placa, TipoVehiculo) VALUES
(1, 'Toyota', 'Corolla', 2015, 'ABC1242', 'Automóvil'),
(2, 'Honda', 'Civic', 2018, 'XYZ7842', 'Automóvil');


INSERT INTO Empleados (Nombre, Apellidos, Cargo, Telefono, Email) VALUES
('Carlos', 'Ramírez', 'Mecánico', '555111222', 'carlos.ramirez@example.com'),
('Lucía', 'Martínez', 'Recepcionista', '555333444', 'lucia.martinez@example.com');

INSERT INTO Servicios (NombreServicio, Descripcion, Precio) VALUES
('Cambio de aceite', 'Cambio de aceite y filtro', 50.00),
('Alineación', 'Alineación de ruedas', 30.00);

INSERT INTO Repuestos (NombreRepuesto, Descripcion, Precio, Stock) VALUES
('Filtro de aceite', 'Filtro para motor', 10.00, 100),
('Bujía', 'Bujía estándar', 5.00, 200);

EXEC sp_columns Vehiculos;
ALTER TABLE Vehiculos
ADD TipoVehiculo VARCHAR(15) NOT NULL DEFAULT 'Automóvil';
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Vehiculos' AND COLUMN_NAME = 'TipoVehiculo';

ALTER TABLE Vehiculos
ALTER COLUMN TipoVehiculo VARCHAR(15) NOT NULL;

SELECT * FROM Clientes; 



EXEC sp_help 'Vehiculos';
SELECT * FROM Vehiculos WHERE Placa = 'ABC123';

SELECT v.Marca, v.Modelo, v.Placa, o.Estado
FROM Vehiculos v
JOIN OrdenesReparacion o ON v.VehiculoID = o.VehiculoID
WHERE o.Estado IN ('Pendiente', 'En Proceso');

SELECT c.Nombre, c.Apellidos, COUNT(v.VehiculoID) AS Vehiculos
FROM Clientes c
LEFT JOIN Vehiculos v ON c.ClienteID = v.ClienteID
GROUP BY c.ClienteID;

SELECT v.VehiculoID, v.Marca, v.Modelo, v.Año, v.Placa, v.TipoVehiculo
FROM Vehiculos v
JOIN Clientes c ON v.ClienteID = c.ClienteID
WHERE c.ClienteID = 1;











