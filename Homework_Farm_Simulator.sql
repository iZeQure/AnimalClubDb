USE [master]
GO

DECLARE @kill varchar(8000) = ''
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'
FROM sys.dm_exec_sessions
WHERE database_id = DB_ID('AnimalClubDb')

EXEC(@kill)
GO

DROP DATABASE IF EXISTS [AnimalClubDb]
GO

CREATE DATABASE [AnimalClubDb]
GO

USE [AnimalClubDb]
GO

/*
	Owner Table
*/
DROP TABLE IF EXISTS [Owner];
CREATE TABLE [Owner] (
[CVR] INT NOT NULL,
[Email] VARCHAR(100) NOT NULL,
[OwnerName] INT NOT NULL,
[OwnerAddress] INT NOT NULL
);
GO

/*
	Owner Address Table
*/

DROP TABLE IF EXISTS [OwnerAddress];
CREATE TABLE [OwnerAddress] (
[ID] INT NOT NULL IDENTITY(1,1),
[No] INT NOT NULL,
[StreetName] VARCHAR(100) NOT NULL,
[PostCode] VARCHAR(50) NOT NULL,
[City] VARCHAR(100) NOT NULL
);
GO

/*
	Owner Name Table
*/

DROP TABLE IF EXISTS [OwnerName];
CREATE TABLE [OwnerName] (
[ID] INT NOT NULL IDENTITY(1,1),
[FirstName] VARCHAR(100) NOT NULL,
[LastName] VARCHAR(100) NOT NULL
);
GO

/*
	Owner Phone Table
*/

DROP TABLE IF EXISTS [OwnerPhone];
CREATE TABLE [OwnerPhone] (
[ID] INT NOT NULL IDENTITY(1,1),
[PhoneNumber] VARCHAR(50) NOT NULL,
[OwnerCVR] INT NOT NULL
);
GO

/*
	Farm Table
*/

DROP TABLE IF EXISTS [Farm];
CREATE TABLE [Farm](
[PNumber] INT NOT NULL,
[Name] VARCHAR(100) NOT NULL,
[FarmAddress] INT NOT NULL,
[OwnerCVR] INT NOT NULL
);
GO

/*
	Farm Address Table
*/

DROP TABLE IF EXISTS [FarmAddress];
CREATE TABLE [FarmAddress] (
[ID] INT NOT NULL IDENTITY(1,1),
[No] INT NOT NULL,
[StreetName] VARCHAR(100) NOT NULL,
[PostCode] VARCHAR(50) NOT NULL,
[City] VARCHAR(100) NOT NULL
);
GO

/*
	Farm CHR Table
*/

DROP TABLE IF EXISTS [FarmChr];
CREATE TABLE [FarmChr] (
[FarmPNumber] INT NOT NULL,
[ChrNo] INT NOT NULL
);
GO

/*
	Stall Table
*/

DROP TABLE IF EXISTS [Stall];
CREATE TABLE [Stall] (
[Number] INT NOT NULL IDENTITY(1,1),
[FarmPNumber] INT NOT NULL
);
GO

/*
	Box Table
*/

DROP TABLE IF EXISTS [Box];
CREATE TABLE [Box] (
[Number] INT NOT NULL IDENTITY(1,1),
[Outdoor] BIT NOT NULL,
[BoxType] INT NOT NULL,
[Stall] INT NOT NULL
);
GO

/*
	Box Type Tables
*/

DROP TABLE IF EXISTS [BoxType];
CREATE TABLE [BoxType] (
[ID] INT NOT NULL IDENTITY(1,1),
[TypeName] VARCHAR(100) NOT NULL,
[Description] VARCHAR(MAX) NOT NULL
);
GO

/*
	Animal Lives In Box Table
*/

DROP TABLE IF EXISTS [AnimalLivesInBox];
CREATE TABLE [AnimalLivesInBox] (
[AnimalEarmark] INT NOT NULL,
[BoxNumber] INT NOT NULL,
[MoveInTime] DATETIME NOT NULL,
[MoveOutTime] DATETIME NOT NULL
);
GO

/*
	Animal Table
*/

DROP TABLE IF EXISTS [Animal];
CREATE TABLE [Animal] (
[Earmark] INT NOT NULL,
[Birth] DATE NOT NULL,
[Death] DATE NOT NULL,
[Age] VARCHAR(30) NOT NULL,
[AnimalProduced] VARCHAR(100) NOT NULL,
[AnimalType] INT NOT NULL,
[AnimalSex] INT NOT NULL
);
GO

/*
	Animal Earmark Table
*/

DROP TABLE IF EXISTS [AnimalEarmark];
CREATE TABLE [AnimalEarmark] (
[ID] INT NOT NULL IDENTITY(1,1),
[ChrNo] INT NOT NULL,
[Color] VARCHAR(30) NOT NULL
);
GO

/*
	Animal Type Table
*/

DROP TABLE IF EXISTS [AnimalType];
CREATE TABLE [AnimalType] (
[ID] INT NOT NULL IDENTITY(1,1),
[TypeName] VARCHAR(MAX) NOT NULL
);
GO

/*
	Animal Sex Table
*/

DROP TABLE IF EXISTS [AnimalSex];
CREATE TABLE [AnimalSex] (
[ID] INT NOT NULL IDENTITY(1,1),
[SexType] VARCHAR(MAX) NOT NULL
);
GO

/*
	Smart Unit Table
*/

DROP TABLE IF EXISTS [SmartUnit];
CREATE TABLE [SmartUnit] (
[SerialNumber] VARCHAR(100) NOT NULL,
[IpAddress] VARCHAR(100) NOT NULL,
[MacAddress] VARCHAR(100) NOT NULL,
[SmartUnitType] INT NOT NULL
);
GO

/*
	Smart Unit Type Table
*/

DROP TABLE IF EXISTS [SmartUnitType];
CREATE TABLE [SmartUnitType] (
[ID] INT NOT NULL IDENTITY(1,1),
[TypeName] VARCHAR(100) NOT NULL
);
GO

/*
	State
*/

DROP TABLE IF EXISTS [State];
CREATE TABLE [State] (
[ID] INT NOT NULL IDENTITY(1,1),
[SeverityType] VARCHAR(100) NOT NULL
);
GO

/*
	Smart Unit Change State Table
*/

DROP TABLE IF EXISTS [SmartUnitChangeState];
CREATE TABLE [SmartUnitChangeState] (
[SmartUnit] VARCHAR(100) NOT NULL,
[State] INT NOT NULL,
[TimeChanged] DATETIME NOT NULL
);
GO

/*
	Box Monitor Table
*/

DROP TABLE IF EXISTS [BoxMonitor];
CREATE TABLE [BoxMonitor] (
[ID] INT NOT NULL IDENTITY(1,1),
[SmartUnit] VARCHAR(100) NOT NULL,
[BoxNumber] INT NOT NULL,
[Value] VARCHAR(MAX) NOT NULL,
[LastUpdatedTime] DATETIME NOT NULL
);

/*
	Stall Monitor Table
*/

DROP TABLE IF EXISTS [StallMonitor];
CREATE TABLE [StallMonitor] (
[ID] INT NOT NULL IDENTITY(1,1),
[SmartUnit] VARCHAR(100) NOT NULL,
[StallNumber] INT NOT NULL,
[Value] VARCHAR(MAX) NOT NULL,
[LastUpdatedTime] DATETIME NOT NULL
);

/*
	Assign Keys
*/

-- Owner
ALTER TABLE [OwnerAddress]
	ADD PRIMARY KEY ([ID])
GO

ALTER TABLE [OwnerName]
	ADD PRIMARY KEY ([ID])
GO

ALTER TABLE [Owner]
	ADD PRIMARY KEY ([CVR]),
		FOREIGN KEY ([OwnerAddress]) REFERENCES [OwnerAddress]([ID]),
		FOREIGN KEY ([OwnerName]) REFERENCES [OwnerName]([ID])
GO

ALTER TABLE [OwnerPhone]
	ADD PRIMARY KEY ([ID]),
		FOREIGN KEY ([OwnerCVR]) REFERENCES [Owner]([CVR])
GO

-- Farm
ALTER TABLE [FarmAddress]
	ADD PRIMARY KEY ([ID])
GO

ALTER TABLE [Farm]
	ADD PRIMARY KEY ([PNumber]),
		FOREIGN KEY ([FarmAddress]) REFERENCES [FarmAddress]([ID]),
		FOREIGN KEY ([OwnerCVR]) REFERENCES [Owner]([CVR])
GO

ALTER TABLE [FarmChr]
	ADD PRIMARY KEY ([FarmPNumber]),
		FOREIGN KEY ([FarmPNumber]) REFERENCES [Farm]([PNumber])
GO

-- Stall
ALTER TABLE [Stall]
	ADD PRIMARY KEY ([Number]),
		FOREIGN KEY ([FarmPNumber]) REFERENCES [Farm](PNumber)
GO

-- Stall Box
ALTER TABLE [BoxType]
	ADD PRIMARY KEY ([ID])
GO

ALTER TABLE [Box]
	ADD PRIMARY KEY ([Number]),
		FOREIGN KEY ([BoxType]) REFERENCES [BoxType]([ID]),
		FOREIGN KEY ([Stall]) REFERENCES [Stall]([Number])
GO

-- Animal
ALTER TABLE [AnimalEarmark]
	ADD PRIMARY KEY ([ID])
GO

ALTER TABLE [AnimalType]
	ADD PRIMARY KEY ([ID])
GO

ALTER TABLE [AnimalSex]
	ADD PRIMARY KEY ([ID])
GO

ALTER TABLE [Animal]
	ADD PRIMARY KEY ([Earmark]),
		FOREIGN KEY ([Earmark]) REFERENCES [AnimalEarmark]([ID]),
		FOREIGN KEY ([AnimalType]) REFERENCES [AnimalType]([ID]),
		FOREIGN KEY ([AnimalSex]) REFERENCES [AnimalSex]([ID])
GO

-- Animal & Box Connection
ALTER TABLE [AnimalLivesInBox]
	ADD PRIMARY KEY ([AnimalEarmark], [BoxNumber]),
		FOREIGN KEY ([AnimalEarmark]) REFERENCES [Animal]([Earmark]),
		FOREIGN KEY ([BoxNumber]) REFERENCES [Box]([Number])
GO

-- Smart Unit
ALTER TABLE [SmartUnitType]
	ADD PRIMARY KEY ([ID])
GO

ALTER TABLE [SmartUnit]
	ADD PRIMARY KEY ([SerialNumber]),
		FOREIGN KEY ([SmartUnitType]) REFERENCES [SmartUnitType]([ID])
GO

-- State
ALTER TABLE [State]
	ADD PRIMARY KEY ([ID])
GO

-- Smart Unit & State Connection
ALTER TABLE [SmartUnitChangeState]
	ADD PRIMARY KEY ([SmartUnit], [State]),
		FOREIGN KEY ([SmartUnit]) REFERENCES [SmartUnit]([SerialNumber]),
		FOREIGN KEY ([State]) REFERENCES [State]([ID])
GO

-- Monitor
ALTER TABLE [BoxMonitor]
	ADD PRIMARY KEY ([ID]),
		FOREIGN KEY ([SmartUnit]) REFERENCES [SmartUnit]([SerialNumber]),
		FOREIGN KEY ([BoxNumber]) REFERENCES [Box]([Number])
GO

ALTER TABLE [StallMonitor]
	ADD PRIMARY KEY ([ID]),
		FOREIGN KEY ([SmartUnit]) REFERENCES [SmartUnit]([SerialNumber]),
		FOREIGN KEY ([StallNumber]) REFERENCES [Stall]([Number])
GO

/*
	Stored Procedures Dummy Data
*/

CREATE PROC [proc_InsertOwnerDummyData]
AS
BEGIN
	-- Insert owner names
	INSERT INTO [OwnerName] ([FirstName], [LastName]) VALUES
	('Marissa', 'Corona'),
	('Deanne', 'Reyna'),
	('Isla', 'Jackson'),
	('Saoirse', 'Stokes'),
	('Woodrow', 'Davey');

	-- Insert owner address'
	INSERT INTO [OwnerAddress] ([City], [PostCode], [StreetName], [No]) VALUES
	('Milwaukee, WI', '53204', 'Devon St.', 689),
	('Xenia, OH', '45385', 'Madison Street', 424),
	('Lewis Center, OH', '43035', 'Mayfield Ave.', 84),
	('Butte, MT', '59701', 'East Strawberry Rd.', 660),
	('Oxon Hill, MD', '20745', 'Poor House Drive', 341);

	-- Insert owners
	INSERT INTO [Owner] ([CVR], [Email], [OwnerName], [OwnerAddress]) VALUES
	(11111111, 'first@farm.dk', 1, 1),
	(22222222, 'second@farm.dk', 2, 2),
	(33333333, 'third@farm.dk', 3, 3),
	(44444444, 'fourth@farm.dk', 4, 4),
	(55555555, 'fifth@farm.dk', 5, 5);

	-- Insert owner phone'
	INSERT INTO [OwnerPhone] ([OwnerCVR], [PhoneNumber]) VALUES
	(11111111, '11111111'),
	(22222222, '22222222'),
	(33333333, '33333333'),
	(44444444, '44444444'),
	(55555555, '55555555');
END;
GO

EXEC [proc_InsertOwnerDummyData];

DROP PROC IF EXISTS [proc_InsertOwnerDummyData];
GO

CREATE PROC [proc_InsertFarmDummyData]
AS
BEGIN
	-- Insert farm address'
	INSERT INTO [FarmAddress] ([City], [PostCode], [StreetName], [No]) VALUES
	('Merrillville, IN', '46410', 'Bradford Lane', 77),
	('Cherry Hill, NJ', '08003', 'Tower Street', 87),
	('Westport, CT', '06880', 'Blackburn St.', 976),
	('Norwalk, CT', '06851', 'Hartford Drive', 4),
	('Lititz, PA', '17543', 'Lafayette Street', 7311);

	-- Insert farms
	INSERT INTO [Farm] ([PNumber], [Name], [FarmAddress], [OwnerCVR]) VALUES
	(11111111, 'Blazing Pitchfork Farms', 1, 11111111),
	(22222222, 'White Oak Ranch', 2, 22222222),
	(33333333, 'Gold Mine Farms', 3, 33333333),
	(44444444, 'Meadowgrove Grange', 4, 44444444),
	(55555555, 'Quarter Mile Meadow', 5, 55555555);

	-- Insert farm chr's
	INSERT INTO [FarmChr] ([ChrNo], [FarmPNumber]) VALUES
	(00111, 11111111),
	(00222, 22222222),
	(00333, 33333333),
	(00444, 44444444),
	(00555, 55555555);
END;
GO

EXEC [proc_InsertFarmDummyData];

DROP PROC IF EXISTS [proc_InsertFarmDummyData];
GO

CREATE PROC [proc_InsertStallDummyData]
AS
BEGIN
	-- Insert Stalls
	INSERT INTO [Stall] ([FarmPNumber]) VALUES
	(11111111),	(11111111),	(11111111),	(11111111),	(11111111),
	(22222222),	(22222222),	(22222222),	(22222222),	(22222222),
	(33333333),	(33333333),	(33333333),	(33333333),	(33333333),
	(44444444),	(44444444),	(44444444),	(44444444),	(44444444),
	(55555555),	(55555555),	(55555555),	(55555555),	(55555555)
END;
GO

EXEC [proc_InsertStallDummyData];

DROP PROC IF EXISTS [proc_InsertStallDummyData];
GO

CREATE PROC [proc_InsertBoxDummyData]
AS
BEGIN
	-- Insert Box Types
	INSERT INTO [BoxType] ([TypeName], [Description]) VALUES
	('Cattle', 'For all types of cattles.'),
	('Pig', 'For all types of pigs and wild boars.'),
	('Sheep', 'For all types of sheeps.'),
	('Goat', 'For all types of goats.');

	-- Insert Box's
	INSERT INTO [Box] ([Outdoor], [BoxType], [Stall]) VALUES
	(1, 1, 1), (1, 1, 1), (0, 2, 1), (0, 3, 1), (0, 4, 1),
	(1, 1, 2), (1, 1, 2), (0, 2, 2), (0, 3, 2), (0, 4, 2),
	(1, 1, 3), (1, 1, 3), (0, 2, 3), (0, 3, 3), (0, 4, 3),
	(1, 1, 4), (1, 1, 4), (0, 2, 4), (0, 3, 4), (0, 4, 4),
	(1, 1, 5), (1, 1, 5), (0, 2, 5), (0, 3, 5), (0, 4, 5),

	(1, 1, 6), (1, 1, 6), (0, 2, 6), (0, 3, 6), (0, 4, 6),
	(1, 1, 7), (1, 1, 7), (0, 2, 7), (0, 3, 7), (0, 4, 7),
	(1, 1, 8), (1, 1, 8), (0, 2, 8), (0, 3, 8), (0, 4, 8),
	(1, 1, 9), (1, 1, 9), (0, 2, 9), (0, 3, 9), (0, 4, 9),
	(1, 1, 10), (1, 1, 10), (0, 2, 10), (0, 3, 10), (0, 4, 10),

	(1, 1, 11), (1, 1, 11), (0, 2, 11), (0, 3, 11), (0, 4, 11),
	(1, 1, 12), (1, 1, 12), (0, 2, 12), (0, 3, 12), (0, 4, 12),
	(1, 1, 13), (1, 1, 13), (0, 2, 13), (0, 3, 13), (0, 4, 13),
	(1, 1, 14), (1, 1, 14), (0, 2, 14), (0, 3, 14), (0, 4, 14),
	(1, 1, 15), (1, 1, 15), (0, 2, 15), (0, 3, 15), (0, 4, 15),

	(1, 1, 16), (1, 1, 16), (0, 2, 16), (0, 3, 16), (0, 4, 16),
	(1, 1, 17), (1, 1, 17), (0, 2, 17), (0, 3, 17), (0, 4, 17),
	(1, 1, 18), (1, 1, 18), (0, 2, 18), (0, 3, 18), (0, 4, 18),
	(1, 1, 19), (1, 1, 19), (0, 2, 19), (0, 3, 19), (0, 4, 19),
	(1, 1, 20), (1, 1, 20), (0, 2, 20), (0, 3, 20), (0, 4, 20),

	(1, 1, 21), (1, 1, 21), (0, 2, 21), (0, 3, 21), (0, 4, 21),
	(1, 1, 22), (1, 1, 22), (0, 2, 22), (0, 3, 22), (0, 4, 22),
	(1, 1, 23), (1, 1, 23), (0, 2, 23), (0, 3, 23), (0, 4, 23),
	(1, 1, 24), (1, 1, 24), (0, 2, 24), (0, 3, 24), (0, 4, 24),
	(1, 1, 25), (1, 1, 25), (0, 2, 25), (0, 3, 25), (0, 4, 25);
END;
GO

EXEC [proc_InsertBoxDummyData];

DROP PROC IF EXISTS [proc_InsertBoxDummyData];
GO

CREATE PROC [proc_InsertAnimalsDummyData]
AS
BEGIN
	-- Insert ear marks
	INSERT INTO [AnimalEarmark] ([ChrNo], [Color]) VALUES
	(00111, 'Yellow'),	(00111, 'Red'),	(00111, 'White'),
	(00222, 'Yellow'),	(00222, 'Red'),	(00222, 'White'),
	(00333, 'Yellow'),	(00333, 'Red'),	(00333, 'White'),
	(00444, 'Yellow'),	(00444, 'Red'),	(00444, 'White'),
	(00555, 'Yellow'),	(00555, 'Red'),	(00555, 'White');

	-- Insert animal types
	INSERT INTO [AnimalType] ([TypeName]) VALUES
	('Cattle'),	('Pig'), ('Sheep'), ('Goat');

	-- Insert animal sex'
	INSERT INTO [AnimalSex] ([SexType]) VALUES
	('Women'), ('Male'), ('Undefined');

	-- Insert animals
	INSERT INTO [Animal] ([Earmark], [Birth], [Death], [Age], [AnimalProduced], [AnimalType], [AnimalSex]) VALUES
	(1, '12/11/2003', GETDATE(), DATEDIFF(YEAR, '12/11/2003', GETDATE()), '0', 1, 1), (2, '12/11/2006', GETDATE(), DATEDIFF(YEAR, '12/11/2006', GETDATE()), '0', 1, 2), (3, '12/11/2011', GETDATE(), DATEDIFF(YEAR, '12/11/2011', GETDATE()), '0', 1, 3),

	(4, '12/11/2005', GETDATE(), DATEDIFF(YEAR, '12/11/2005', GETDATE()), '0', 1, 1), (5, '12/11/2009', GETDATE(), DATEDIFF(YEAR, '12/11/2009', GETDATE()), '0', 1, 2), (6, '12/11/2014', GETDATE(), DATEDIFF(YEAR, '12/11/2014', GETDATE()), '0', 1, 3),

	(7, '12/11/2016', GETDATE(), DATEDIFF(YEAR, '12/11/2016', GETDATE()), '0', 2, 1), (8, '12/11/2018', GETDATE(), DATEDIFF(YEAR, '12/11/2018', GETDATE()), '0', 2, 2), (9, '12/11/2013', GETDATE(), DATEDIFF(YEAR, '12/11/2013', GETDATE()), '0', 2, 3),

	(10, '12/11/2007', GETDATE(), DATEDIFF(YEAR, '12/11/2007', GETDATE()), '0', 3, 1), (11, '12/11/2020', GETDATE(), DATEDIFF(YEAR, '12/11/2020', GETDATE()), '0', 3, 2), (12, '12/11/2001', GETDATE(), DATEDIFF(YEAR, '12/11/2001', GETDATE()), '0', 3, 3),

	(13, '12/11/2013', GETDATE(), DATEDIFF(YEAR, '12/11/2013', GETDATE()), '0', 4, 1), (14, '12/11/2008', GETDATE(), DATEDIFF(YEAR, '12/11/2008', GETDATE()), '0', 4, 2), (15, '12/11/2010', GETDATE(), DATEDIFF(YEAR, '12/11/2010', GETDATE()), '0', 4, 3);
END;
GO

EXEC [proc_InsertAnimalsDummyData];

DROP PROC IF EXISTS [proc_InsertAnimalLivesInBoxDummyData];
GO

CREATE PROC [proc_InsertAnimalLivesInBoxDummyData]
AS
BEGIN
	-- Insert living animals to a box
	INSERT INTO [AnimalLivesInBox] ([AnimalEarmark], [BoxNumber], [MoveInTime], [MoveOutTime]) VALUES
	(1, 1, GETDATE(), DATEADD(YEAR, 2, GETDATE())), (2, 1, GETDATE(), DATEADD(YEAR, 2, GETDATE())), (3, 1, GETDATE(), DATEADD(YEAR, 2, GETDATE())),
	(4, 26, GETDATE(), DATEADD(YEAR, 4, GETDATE())), (5, 26, GETDATE(), DATEADD(YEAR, 4, GETDATE())), (6, 26, GETDATE(), DATEADD(YEAR, 4, GETDATE())),
	(7, 53, GETDATE(), DATEADD(YEAR, 6, GETDATE())), (8, 53, GETDATE(), DATEADD(YEAR, 6, GETDATE())), (9, 53, GETDATE(), DATEADD(YEAR, 6, GETDATE())),
	(10, 79, GETDATE(), DATEADD(YEAR, 8, GETDATE())), (11, 79, GETDATE(), DATEADD(YEAR, 8, GETDATE())), (12, 79, GETDATE(), DATEADD(YEAR, 8, GETDATE())),
	(13, 105, GETDATE(), DATEADD(YEAR, 10, GETDATE())), (14, 105, GETDATE(), DATEADD(YEAR, 10, GETDATE())), (15, 105, GETDATE(), DATEADD(YEAR, 10, GETDATE()))
END;
GO

EXEC [proc_InsertAnimalLivesInBoxDummyData];

DROP PROC IF EXISTS [proc_InsertStallDummyData];
GO

CREATE PROC [proc_InsertSmartUnitDummyData]
AS
BEGIN
	-- Insert smart unit types
	INSERT INTO [SmartUnitType] ([TypeName]) VALUES
	('Light Sensor'),
	('Temperature Sensor'),
	('Moisterous Sensor');

	-- Insert smart units
	INSERT INTO [SmartUnit] ([SerialNumber], [IpAddress], [MacAddress], [SmartUnitType]) VALUES
	('FA002391', '192.168.0.1', 'CB:02:5D:C8:4B:CD', 1),
	('FA002173', '192.168.0.2', '0E:C0:0C:8B:77:07', 2),
	('FA001263', '192.168.0.3', '46:D6:44:02:F0:D9', 3);
END;
GO

EXEC [proc_InsertSmartUnitDummyData];

DROP PROC IF EXISTS [proc_InsertSmartUnitDummyData];
GO

CREATE PROC [proc_InsertStateDummyData]
AS
BEGIN
	-- Insert state serverities
	INSERT INTO [State] ([SeverityType]) VALUES
	('Normal'),
	('Warning'),
	('Critical'),
	('Error'),
	('Failed');
END;
GO

EXEC [proc_InsertStateDummyData];

DROP PROC IF EXISTS [proc_InsertStateDummyData];
GO

CREATE PROC [proc_InsertSmartUnitStatesDummyData]
AS
BEGIN
	-- Insert smart unit state changes
	INSERT INTO [SmartUnitChangeState] ([SmartUnit], [State], [TimeChanged]) VALUES
	('FA002391', 1, DATEADD(HOUR, 1, GETDATE())),
	('FA002173', 1, DATEADD(HOUR, 2, GETDATE())),
	('FA001263', 2, DATEADD(HOUR, 3, GETDATE()));
END;
GO

EXEC [proc_InsertSmartUnitStatesDummyData];

DROP PROC IF EXISTS [proc_InsertSmartUnitStatesDummyData];
GO

CREATE PROC [proc_InsertBoxMonitorDummyData]
AS
BEGIN
	-- Insert Box monitors
	INSERT INTO [BoxMonitor] ([SmartUnit], [BoxNumber], [Value], [LastUpdatedTime]) VALUES
	('FA002391', 1, '100 Lumens', DATEADD(DAY, 1, GETDATE())),
	('FA002391', 2, '3000 Lumens', DATEADD(DAY, 2, GETDATE())),
	('FA002173', 3, '55 Degrees Celsius', DATEADD(DAY, 1, GETDATE())),
	('FA002173', 4, '40 Degrees Celsius', DATEADD(DAY, 2, GETDATE())),
	('FA001263', 8, '20% Moisture', DATEADD(DAY, 1, GETDATE())),
	('FA001263', 9, '70% Moisture', DATEADD(DAY, 2, GETDATE()));
END;
GO

EXEC [proc_InsertBoxMonitorDummyData];

DROP PROC IF EXISTS [proc_InsertBoxMonitorDummyData];
GO

CREATE PROC [proc_InsertStallMonitorDummyData]
AS
BEGIN
	-- Insert Box monitors
	INSERT INTO [StallMonitor] ([SmartUnit], [StallNumber], [Value], [LastUpdatedTime]) VALUES
	('FA002391', 1, '100 Lumens', DATEADD(DAY, 1, GETDATE())),
	('FA002391', 1, '3000 Lumens', DATEADD(DAY, 2, GETDATE())),
	('FA002173', 1, '55 Degrees Celsius', DATEADD(DAY, 1, GETDATE())),
	('FA002173', 1, '40 Degrees Celsius', DATEADD(DAY, 2, GETDATE())),
	('FA001263', 1, '20% Moisture', DATEADD(DAY, 1, GETDATE())),
	('FA001263', 1, '70% Moisture', DATEADD(DAY, 2, GETDATE()));
END;
GO

EXEC [proc_InsertStallMonitorDummyData];

DROP PROC IF EXISTS [proc_InsertStallMonitorDummyData];
GO

/*
	Create Views to show data.
*/

CREATE VIEW [OwnersData]
AS
	SELECT
		[Owner].[CVR],

		[OwnerName].[FirstName],
		[OwnerName].[LastName],

		[Owner].[Email],

		[OwnerPhone].[PhoneNumber],

		[OwnerAddress].[City],
		[OwnerAddress].[PostCode],
		[OwnerAddress].[StreetName],
		[OwnerAddress].[No]
	FROM [Owner]
		INNER JOIN [OwnerName] ON
			[OwnerName].[ID] = [Owner].[OwnerName]
		INNER JOIN [OwnerPhone] ON
			[OwnerPhone].[OwnerCVR] = [Owner].[CVR]
		INNER JOIN [OwnerAddress] ON
			[OwnerAddress].[ID] = [Owner].[OwnerAddress]
GO

CREATE VIEW [FarmsData]
AS
	SELECT
		[Farm].[Name],
		[Farm].[PNumber],

		[FarmChr].[ChrNo],

		[Farm].[OwnerCVR] AS 'Owner',

		[FarmAddress].[City],
		[FarmAddress].[PostCode],
		[FarmAddress].[StreetName],
		[FarmAddress].[No]

	FROM [Farm]
		INNER JOIN [FarmChr] ON
			[FarmChr].[FarmPNumber] = [Farm].[PNumber]
		INNER JOIN [FarmAddress] ON
			[FarmAddress].[ID] = [Farm].[FarmAddress]
GO

CREATE VIEW [StallsData]
AS
	SELECT 
		COUNT([Stall].[Number]) AS 'Count of Stalls for the farm.'
	FROM
		[Stall]
GO

CREATE VIEW [BoxData]
AS
	SELECT
		[Stall].[FarmPNumber],

		[Box].[Outdoor] AS 'Outdoor | True / False',
		[Box].[Number] AS 'In Box',
		[Box].[Stall] AS 'In Stall',

		[BoxType].[TypeName] AS 'Box Type',
		[BoxType].[Description]
	FROM [Box]
		INNER JOIN [Stall] ON
			[Stall].[Number] = [Box].[Stall]
		INNER JOIN [BoxType] ON
			[BoxType].[ID] = [Box].[BoxType]
GO

CREATE VIEW [AnimalData]
AS
	SELECT
		[AnimalEarmark].[ChrNo],
		[AnimalEarmark].[Color],
		
		[Animal].[Age],
		[Animal].[AnimalProduced],
		[Animal].[Birth],
		[Animal].[Death],

		[AnimalType].[TypeName],
		
		[AnimalSex].[SexType]

	FROM [Animal]
		INNER JOIN [AnimalEarmark] ON
			[AnimalEarmark].[ID] = [Animal].[Earmark]
		INNER JOIN [AnimalType] ON
			[AnimalType].[ID] = [Animal].[AnimalType]
		INNER JOIN [AnimalSex] ON
			[AnimalSex].[ID] = [Animal].[AnimalSex]
GO

CREATE VIEW [AnimalsWhoLivesInWhatBox]
AS
	SELECT
		[AnimalLivesInBox].[MoveInTime],
		[AnimalLivesInBox].[MoveOutTime],

		[AnimalEarmark].[ChrNo] AS 'Animal Earmark CHR',
		[AnimalEarmark].[Color],

		[Animal].[Age],
		[Animal].[Birth],
		[Animal].[Death],
		[Animal].[AnimalProduced] AS 'Animal has Produced',

		[AnimalType].[TypeName] AS 'Animal Type',

		[AnimalSex].[SexType] AS 'Animal Gender',

		[Box].[Outdoor],

		[BoxType].[TypeName] AS 'Box Type',

		[Stall].[Number] AS 'Stall Number'
	FROM [AnimalLivesInBox]
		LEFT JOIN [AnimalEarmark] ON
			[AnimalEarmark].[ID] = [AnimalLivesInBox].[AnimalEarmark]
		LEFT JOIN [Animal] ON
			[Animal].[Earmark] = [AnimalLivesInBox].[AnimalEarmark]
		LEFT JOIN [Box] ON
			[Box].[Number] = [AnimalLivesInBox].[BoxNumber]
		LEFT JOIN [AnimalType] ON
			[AnimalType].[ID] = [Animal].[AnimalType]
		LEFT JOIN [AnimalSex] ON
			[AnimalSex].[ID] = [Animal].[AnimalSex]
		LEFT JOIN [BoxType] ON
			[BoxType].[ID] = [Box].[BoxType]
		LEFT JOIN [Stall] ON
			[Stall].[Number] = [Box].[Stall]
GO

CREATE VIEW [SmartUnitData]
AS
	SELECT
		[SmartUnit].[SerialNumber],
		[SmartUnit].[IpAddress],
		[SmartUnit].[MacAddress],

		[SmartUnitType].[TypeName] AS 'Smart Unit Type',

		[SmartUnitChangeState].[TimeChanged] AS 'Smart Unit state last updated',
		[State].[SeverityType] AS 'Smart Unit Severity'
	FROM [SmartUnit]
		INNER JOIN [SmartUnitType] ON
			[SmartUnitType].[ID] = [SmartUnit].[SmartUnitType]
		INNER JOIN [SmartUnitChangeState] ON
			[SmartUnitChangeState].[SmartUnit] = [SmartUnit].[SerialNumber]
		INNER JOIN [State] ON
			[State].[ID] = [SmartUnitChangeState].[State]
GO

CREATE VIEW [BoxMonitoringData]
AS
	SELECT
		[SmartUnit].[IpAddress],
		[SmartUnit].[MacAddress],
		[SmartUnit].[SerialNumber],

		[SmartUnitType].[TypeName] AS 'Smart Unit Type',

		[SmartUnitChangeState].[TimeChanged] AS 'Last Time unit changed state',
		
		[State].[SeverityType] AS 'Smart Unit Current state',

		[BoxMonitor].[LastUpdatedTime] AS 'Monitor Last updated',
		[BoxMonitor].[Value] AS 'Monitoring Data',

		[Box].[Outdoor],
		[Box].[Number],

		[BoxType].[TypeName] AS 'Box Type',
		[Stall].[Number] AS 'Box is in Stall'
	FROM [BoxMonitor]
		INNER JOIN [SmartUnit] ON
			[SmartUnit].[SerialNumber] = [BoxMonitor].[SmartUnit]
		INNER JOIN [SmartUnitType] ON
			[SmartUnitType].[ID] = [SmartUnit].[SmartUnitType]
		INNER JOIN [SmartUnitChangeState] ON
			[SmartUnitChangeState].[SmartUnit] = [BoxMonitor].[SmartUnit]
		INNER JOIN [State] ON
			[State].[ID] = [SmartUnitChangeState].[State]
		INNER JOIN [Box] ON
			[Box].[Number] = [BoxMonitor].[BoxNumber]
		INNER JOIN [BoxType] ON
			[BoxType].[ID] = [Box].[BoxType]
		INNER JOIN [Stall] ON
			[Stall].[Number] = [Box].[Stall]
GO

CREATE VIEW [StallMonitoringData]
AS
	SELECT
		[SmartUnit].[IpAddress],
		[SmartUnit].[MacAddress],
		[SmartUnit].[SerialNumber],

		[SmartUnitType].[TypeName] AS 'Smart Unit Type',

		[SmartUnitChangeState].[TimeChanged] AS 'Last Time unit changed state',
		
		[State].[SeverityType] AS 'Smart Unit Current state',

		[Stall].[Number] AS 'Box is in Stall',

		[Farm].[PNumber] AS 'Stall is on Farm'
	FROM [StallMonitor]
		INNER JOIN [SmartUnit] ON
			[SmartUnit].[SerialNumber] = [StallMonitor].[SmartUnit]
		INNER JOIN [SmartUnitType] ON
			[SmartUnitType].[ID] = [SmartUnit].[SmartUnitType]
		INNER JOIN [Stall] ON
			[Stall].[Number] = [StallMonitor].[StallNumber]
		INNER JOIN [SmartUnitChangeState] ON
			[SmartUnitChangeState].[SmartUnit] = [StallMonitor].[SmartUnit]
		INNER JOIN [State] ON
			[State].[ID] = [SmartUnitChangeState].[State]
		INNER JOIN [Farm] ON
			[Farm].[PNumber] = [Stall].[FarmPNumber]
GO