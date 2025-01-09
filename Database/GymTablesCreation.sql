
CREATE TABLE Administrators (
    AdminID INT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15)
);

CREATE TABLE Coaches (
    CoachID INT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15),
    Specialty VARCHAR(100)
);

CREATE TABLE nutritionPlan(
	NutritionID INT PRIMARY KEY,
	Calories INT,
	Protein INT,
	Carbs INT,
	Fat INT,
	planType VARCHAR(20)
);

CREATE TABLE trainingPlan(
	TrainingID INT PRIMARY KEY,
	Intensity1to10 INT,
	DaysPerWeek INT,
	CONSTRAINT CHK_DaysPerWeek CHECK (DaysPerWeek > 0 AND DaysPerWeek < 7),
	CONSTRAINT CHK_Intensity CHECK (Intensity1to10 > 0 AND Intensity1to10 < 11)

);

CREATE TABLE Clients (
    ClientID INT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
	Age INT,
	Gender VARCHAR(1),
	StartDate DATE,
	Email VARCHAR(255) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15),
	AssignedCoachID INT,
	NPID INT,
	TPID INT,
	MembershipStatus VARCHAR(100),
	FOREIGN KEY (NPID) REFERENCES nutritionPlan(NutritionID),
	FOREIGN KEY (TPID) REFERENCES trainingPlan(TrainingID),
    FOREIGN KEY (AssignedCoachID) REFERENCES Coaches(CoachID)
);

ALTER TABLE Coaches
ADD ManagerID INT;

ALTER TABLE Coaches
ADD CONSTRAINT FK_ManagerID
FOREIGN KEY (ManagerID) REFERENCES Administrators(AdminID);

INSERT INTO Administrators (AdminID, FirstName, LastName, Email, PhoneNumber)
VALUES
(1, 'Omar', 'Mohamed', 'omar.Mohamed@example.com', '01012345678'),
(2, 'Mohamed', 'Rabie', 'mohamed.rabie@example.com', '01023456789');

INSERT INTO Coaches (CoachID, FirstName, LastName, Email, PhoneNumber, Specialty, ManagerID)
VALUES
(1, 'Aley', 'Nasser', 'aley.nasser@example.com', '01112345678', 'Strength Training',1),
(2, 'Khaled', 'Saeed', 'khaled.saeed@example.com', '01123456789', 'Cardio',1),
(3, 'Youssef', 'Mahmoud', 'youssef.mahmoud@example.com', '01134567890', 'Yoga',1),
(4, 'Sherif', 'Ahmed','sherif.ahmed@example.com','01212147034', 'Calisthenics', 1);

INSERT INTO nutritionPlan (NutritionID, Calories, Protein, Carbs, Fat, planType)
VALUES
(1, 2000, 150, 250, 70, 'Weight Loss'),
(2, 2500, 200, 300, 80, 'Muscle Gain'),
(3, 1800, 120, 200, 60, 'Maintenance');

INSERT INTO trainingPlan (TrainingID, Intensity1to10, DaysPerWeek)
VALUES
(1, 5, 4),
(2, 8, 5),
(3, 3, 3);

/*REQ1*/
INSERT INTO Clients (ClientID, FirstName, LastName, Age, Gender, StartDate, Email, PhoneNumber, AssignedCoachID, NPID, TPID, MembershipStatus)
VALUES
(1, 'Omar', 'Ahmed', 25, 'M', '2023-01-15', 'omar.ahmed@example.com', '01212345678', 1, 1, 1, 'Active'),
(2, 'Mohamed', 'Hassan', 30, 'M', '2023-02-20', 'mohamed.hassan@example.com', '01223456789', 2, 2, 2, 'Active'),
(3, 'Aley', 'Fathy', 28, 'M', '2023-03-10', 'aley.fathy@example.com', '01234567890', 4, 3, 3, 'Expired'),
(4, 'Sara', 'Kamel', 22, 'F', '2023-04-15', 'sara.kamel@example.com', '01245678901', 1, 1, 2, 'Active'),
(5, 'Hana', 'Youssef', 27, 'F', '2023-05-20', 'hana.youssef@example.com', '01256789012', 2, 2, 3, 'Expired'),
(6, 'Ali', 'Nour', 35, 'M', '2023-06-10', 'ali.nour@example.com', '01267890123', 3, 3, 1, 'Cancelled'),
(7, 'Laila', 'Sami', 29, 'F', '2023-07-25', 'laila.sami@example.com', '01278901234', 4, 1, 2, 'Active'),
(8, 'Karim', 'Adel', 31, 'M', '2023-08-30', 'karim.adel@example.com', '01289012345', 2, 2, 3, 'Expired'),
(9, 'Nour', 'Hassan', 26, 'F', '2023-09-05', 'nour.hassan@example.com', '01290123456', 3, 3, 1, 'Cancelled'),
(10, 'Tamer', 'Fouad', 33, 'M', '2023-10-10', 'tamer.fouad@example.com', '01201234567', 1, 1, 2, 'Active');

/*Query to find the names of everyone that has a calisthenics coach*/

SELECT cl.FirstName, cl.LastName
FROM Clients cl, Coaches co
WHERE co.Specialty = 'Calisthenics' AND cl.AssignedCoachID = co.CoachID;

/* REQ1 Delete Client*/

DELETE FROM Clients
WHERE ClientID = 7;

SELECT * FROM Clients;

/* Select all clients that need 2000 calories or more and sort them by their ClientID descending*/

SELECT c.ClientID, c.FirstName, c.LastName
FROM Clients c, nutritionPlan n
WHERE c.NPID = n.NutritionID AND n.Calories >= 2000
ORDER BY c.ClientID DESC;

/* REQ3 Select all Clients Names that are assigned to coach 4 (only aley fathy since we removed the other person)*/

SELECT cl.FirstName, cl.LastName
FROM Clients cl, Coaches co
WHERE cl.AssignedCoachID = co.CoachID AND co.CoachID = 4;

/*REQ4 */

UPDATE Clients
SET AssignedCoachID = 2
WHERE ClientID = 1;

/*REQ6 and 8 all details for client with specific id = 2*/

SELECT cl.FirstName, cl.LastName, n.planType, t.DaysPerWeek, co.FirstName, co.LastName
FROM Clients cl, nutritionPlan n, trainingPlan t, Coaches co
WHERE cl.NPID = n.NutritionID AND cl.TPID = t.TrainingID AND cl.AssignedCoachID = co.CoachID AND ClientID = 2;

/*REQ7 */

UPDATE Clients
SET TPID = 3
WHERE ClientID = 1;

/**/

ALTER TABLE Clients
ADD username VARCHAR(100) ;

ALTER TABLE Clients
ADD password VARCHAR(255);


ALTER TABLE Administrators
ADD username VARCHAR(100) ;

ALTER TABLE Administrators
ADD password VARCHAR(255);

ALTER TABLE Coaches
ADD username VARCHAR(100);

ALTER TABLE Coaches
ADD password VARCHAR(255);

SELECT *
FROM Coaches;

-- Drop the foreign key constraint in the Clients table
ALTER TABLE Clients
DROP CONSTRAINT FK__Clients__Assigne__45F365D3;

-- Drop the primary key constraint in the Coaches table
ALTER TABLE Coaches
DROP CONSTRAINT PK__Coaches__F411D9A19FCE4C7E;

ALTER TABLE Coaches
DROP COLUMN CoachID; -- Drop the existing column

ALTER TABLE Coaches
ADD CoachID INT PRIMARY KEY IDENTITY(1,1); -- Add a new identity column


-- Recreate the foreign key constraint in the Clients table
ALTER TABLE Clients
ADD CONSTRAINT FK_Clients_AssignedCoachID
FOREIGN KEY (AssignedCoachID) REFERENCES Coaches(CoachID);




ALTER TABLE Clients
DROP CONSTRAINT PK__Clients__E67E1A04FC03B076;

ALTER TABLE Clients
DROP COLUMN ClientID;

ALTER TABLE Clients
ADD ClientID INT PRIMARY KEY IDENTITY(1,1);

SELECT * FROM Clients;

UPDATE Administrators
SET username = 'omar', password = 'omar'
WHERE AdminID = 1;


UPDATE Clients
SET username = 'fathyaley', password = 'fathyaley'
WHERE ClientID = 1;

UPDATE Clients
SET username = 'nourali', password = 'nourali'
WHERE ClientID = 2;

UPDATE Clients
SET username = 'youssefhana', password = 'youssefhana'
WHERE ClientID = 3;

UPDATE Clients
SET username = 'adelkarim', password = 'adelkarim'
WHERE ClientID = 4;

UPDATE Clients
SET username = 'hassanmohamed', password = 'hassanmohamed'
WHERE ClientID = 5;

UPDATE Clients
SET username = 'hassannour', password = 'hassannour'
WHERE ClientID = 6;

UPDATE Clients
SET username = 'ahmedomar', password = 'ahmedomar'
WHERE ClientID = 7;

UPDATE Clients
SET username = 'kamelsara', password = 'kamelsara'
WHERE ClientID = 8;

UPDATE Clients
SET username = 'fouadtamer', password = 'fouadtamer'
WHERE ClientID = 9;

SELECT * FROM nutritionPlan;

UPDATE Coaches
SET username = 'NasserAley', password = 'NasserAley'
WHERE CoachID = 1;

UPDATE Coaches
SET username = 'SaeedKhaled', password = 'SaeedKhaled'
WHERE CoachID = 2;

UPDATE Coaches
SET username = 'AhmedSherif', password = 'AhmedSherif'
WHERE CoachID = 3;

UPDATE Coaches
SET username = 'MahmoudYoussef', password = 'MahmoudYoussef'
WHERE CoachID = 4;


SELECT * FROM Clients;

SELECT * FROM Coaches;

INSERT INTO Clients (FirstName, LastName, Age, Gender, StartDate, Email, PhoneNumber, AssignedCoachID, NPID, TPID, MembershipStatus, username, password)
VALUES
('Ahmed', 'Ali', 28, 'M', '2023-11-01', 'ahmed.ali@example.com', '01011111111', 2, 1, 1, 'Active', 'ahmedali', 'ahmedali'),
('Fatma', 'Mohamed', 25, 'F', '2023-11-02', 'fatma.mohamed@example.com', '01022222222', 3, 2, 2, 'Active', 'fatmamohamed', 'fatmamohamed'),
('Mahmoud', 'Hassan', 30, 'M', '2023-11-03', 'mahmoud.hassan@example.com', '01033333333', 4, 3, 3, 'Active', 'mahmoudhassan', 'mahmoudhassan'),
('Aya', 'Sayed', 22, 'F', '2023-11-04', 'aya.sayed@example.com', '01044444444', 1, 1, 2, 'Active', 'ayasayed', 'ayasayed'),
('Omar', 'Ibrahim', 35, 'M', '2023-11-05', 'omar.ibrahim@example.com', '01055555555', 2, 2, 3, 'Active', 'omaribrahim', 'omaribrahim'),
('Nour', 'Khaled', 27, 'F', '2023-11-06', 'nour.khaled@example.com', '01066666666', 3, 3, 1, 'Active', 'nourkhaled', 'nourkhaled'),
('Youssef', 'Adel', 29, 'M', '2023-11-07', 'youssef.adel@example.com', '01077777777', 4, 1, 2, 'Active', 'youssefadel', 'youssefadel'),
('Hana', 'Samir', 26, 'F', '2023-11-08', 'hana.samir@example.com', '01088888888', 1, 2, 3, 'Active', 'hanasamir', 'hanasamir'),
('Karim', 'Fathy', 31, 'M', '2023-11-09', 'karim.fathy@example.com', '01099999999', 2, 3, 1, 'Active', 'karimfathy', 'karimfathy'),
('Laila', 'Nasser', 24, 'F', '2023-11-10', 'laila.nasser@example.com', '01010101010', 3, 1, 2, 'Active', 'lailanasser', 'lailanasser');
