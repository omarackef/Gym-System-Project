
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