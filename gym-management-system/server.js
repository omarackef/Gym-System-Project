const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const sql = require("mssql");

const app = express();
app.use(bodyParser.json());
app.use(cors());

// Database configuration
const config = {
    user: "user",
    password: "user1234",
    server: "LAPTOP-ETEF53MA",
    database: "Gym Database",
    options: {
        encrypt: true,
        trustServerCertificate: true,
    },
};

// Route for the root URL
app.get("/", (req, res) => {
    res.send("Welcome to the Gym Management System!");
});

// Fetch all clients or clients assigned to a specific coach
app.get("/clients", async (req, res) => {
    const coachID = req.query.coachID;

    try {
        await sql.connect(config);
        const request = new sql.Request();
        let query = "SELECT * FROM Clients";
        if (coachID) {
            query += " WHERE AssignedCoachID = @coachID";
            request.input("coachID", sql.Int, coachID);
        }
        const result = await request.query(query);
        res.json(result.recordset);
    } catch (err) {
        console.error("Error fetching clients:", err);
        res.status(500).send("Error fetching clients.");
    } finally {
        sql.close();
    }
});

// Fetch a single client by ID
app.get("/clients/:clientID", async (req, res) => {
    const clientID = req.params.clientID;

    try {
        await sql.connect(config);
        const request = new sql.Request();
        const query = `SELECT * FROM Clients WHERE ClientID = @clientID`;
        request.input("clientID", sql.Int, clientID);
        const result = await request.query(query);

        if (result.recordset.length > 0) {
            res.json(result.recordset[0]);
        } else {
            res.status(404).send("Client not found.");
        }
    } catch (err) {
        console.error("Error fetching client:", err);
        res.status(500).send("Error fetching client.");
    } finally {
        sql.close();
    }
});

// Update a client
app.put("/clients/:clientID", async (req, res) => {
    const clientID = req.params.clientID;
    const updatedClient = req.body;

    try {
        await sql.connect(config);
        const request = new sql.Request();
        const query = `
            UPDATE Clients
            SET FirstName = @firstName,
                LastName = @lastName,
                Age = @age,
                Gender = @gender,
                StartDate = @startDate,
                Email = @email,
                PhoneNumber = @phoneNumber,
                AssignedCoachID = @assignedCoachID,
                NPID = @npID,
                TPID = @tpID,
                MembershipStatus = @membershipStatus
            WHERE ClientID = @clientID
        `;
        request.input("clientID", sql.Int, clientID);
        request.input("firstName", sql.VarChar, updatedClient.firstName);
        request.input("lastName", sql.VarChar, updatedClient.lastName);
        request.input("age", sql.Int, updatedClient.age);
        request.input("gender", sql.VarChar, updatedClient.gender);
        request.input("startDate", sql.Date, updatedClient.startDate);
        request.input("email", sql.VarChar, updatedClient.email);
        request.input("phoneNumber", sql.VarChar, updatedClient.phoneNumber);
        request.input("assignedCoachID", sql.Int, updatedClient.assignedCoachID);
        request.input("npID", sql.Int, updatedClient.npID);
        request.input("tpID", sql.Int, updatedClient.tpID);
        request.input("membershipStatus", sql.VarChar, updatedClient.membershipStatus);
        await request.query(query);
        res.send("Client updated successfully!");
    } catch (err) {
        console.error("Error updating client:", err);
        res.status(500).send("Error updating client.");
    } finally {
        sql.close();
    }
});

// Delete a client
app.delete("/clients/:clientID", async (req, res) => {
    const clientID = req.params.clientID;

    try {
        await sql.connect(config);
        const request = new sql.Request();
        const query = `DELETE FROM Clients WHERE ClientID = @clientID`;
        request.input("clientID", sql.Int, clientID);
        const result = await request.query(query);

        if (result.rowsAffected[0] > 0) {
            res.send("Client deleted successfully!");
        } else {
            res.status(404).send("Client not found.");
        }
    } catch (err) {
        console.error("Error deleting client:", err);
        res.status(500).send("Error deleting client.");
    } finally {
        sql.close();
    }
});

// Fetch all coaches
app.get("/coaches", async (req, res) => {
    try {
        await sql.connect(config);
        const request = new sql.Request();
        const query = "SELECT * FROM Coaches";
        const result = await request.query(query);
        res.json(result.recordset);
    } catch (err) {
        console.error("Error fetching coaches:", err);
        res.status(500).send("Error fetching coaches.");
    } finally {
        sql.close();
    }
});

// Fetch all training plans
app.get("/training-plans", async (req, res) => {
    try {
        await sql.connect(config);
        const request = new sql.Request();
        const query = "SELECT * FROM trainingPlan";
        const result = await request.query(query);
        res.json(result.recordset);
    } catch (err) {
        console.error("Error fetching training plans:", err);
        res.status(500).send("Error fetching training plans.");
    } finally {
        sql.close();
    }
});

// Fetch the training plan assigned to a specific client
app.get("/client-training-plan/:clientID", async (req, res) => {
    const clientID = req.params.clientID;

    try {
        await sql.connect(config);
        const request = new sql.Request();
        const query = `
            SELECT tp.Intensity1to10, tp.DaysPerWeek
            FROM trainingPlan tp
            INNER JOIN Clients c ON tp.TrainingID = c.TPID
            WHERE c.ClientID = @clientID
        `;
        request.input("clientID", sql.Int, clientID);
        const result = await request.query(query);

        if (result.recordset.length > 0) {
            res.json(result.recordset[0]);
        } else {
            res.status(404).send("Training plan not found for this client.");
        }
    } catch (err) {
        console.error("Error fetching training plan:", err);
        res.status(500).send("Error fetching training plan.");
    } finally {
        sql.close();
    }
});

// Fetch all nutrition plans
app.get("/nutrition-plans", async (req, res) => {
    try {
        await sql.connect(config);
        const request = new sql.Request();
        const query = "SELECT * FROM nutritionPlan";
        const result = await request.query(query);
        res.json(result.recordset);
    } catch (err) {
        console.error("Error fetching nutrition plans:", err);
        res.status(500).send("Error fetching nutrition plans.");
    } finally {
        sql.close();
    }
});

// Fetch the nutrition plan assigned to a specific client
app.get("/client-nutrition-plan/:clientID", async (req, res) => {
    const clientID = req.params.clientID;

    try {
        await sql.connect(config);
        const request = new sql.Request();
        const query = `
            SELECT np.*
            FROM nutritionPlan np
            INNER JOIN Clients c ON np.NutritionID = c.NPID
            WHERE c.ClientID = @clientID
        `;
        request.input("clientID", sql.Int, clientID);
        const result = await request.query(query);

        if (result.recordset.length > 0) {
            res.json(result.recordset[0]);
        } else {
            res.status(404).send("Nutrition plan not found for this client.");
        }
    } catch (err) {
        console.error("Error fetching nutrition plan:", err);
        res.status(500).send("Error fetching nutrition plan.");
    } finally {
        sql.close();
    }
});

// Cancel a client's membership
app.put("/cancel-membership/:clientID", async (req, res) => {
    const clientID = req.params.clientID;

    try {
        await sql.connect(config);
        const request = new sql.Request();
        const query = `
            UPDATE Clients
            SET MembershipStatus = 'Cancelled'
            WHERE ClientID = @clientID
        `;
        request.input("clientID", sql.Int, clientID);
        await request.query(query);
        res.send("Membership cancelled successfully!");
    } catch (err) {
        console.error("Error cancelling membership:", err);
        res.status(500).send("Error cancelling membership.");
    } finally {
        sql.close();
    }
});

// Re-register a client and set membership status to Active
app.put("/re-register/:clientID", async (req, res) => {
    const clientID = req.params.clientID;

    try {
        await sql.connect(config);
        const request = new sql.Request();
        const query = `
            UPDATE Clients
            SET MembershipStatus = 'Active'
            WHERE ClientID = @clientID
        `;
        request.input("clientID", sql.Int, clientID);
        await request.query(query);
        res.send("Re-registration successful! Membership status set to Active.");
    } catch (err) {
        console.error("Error re-registering:", err);
        res.status(500).send("Error re-registering.");
    } finally {
        sql.close();
    }
});

// Login route
app.post("/login", async (req, res) => {
    const { username, password, role } = req.body;

    try {
        await sql.connect(config);
        const request = new sql.Request();

        // Query the appropriate table based on the role
        let query;
        if (role === "admin") {
            query = `SELECT * FROM Administrators WHERE username = @username AND password = @password`;
        } else if (role === "client") {
            query = `SELECT * FROM Clients WHERE username = @username AND password = @password`;
        } else if (role === "coach") {
            query = `SELECT * FROM Coaches WHERE username = @username AND password = @password`;
        }

        request.input("username", sql.VarChar, username);
        request.input("password", sql.VarChar, password);
        const result = await request.query(query);

        if (result.recordset.length > 0) {
            // Credentials are valid
            const user = result.recordset[0];
            res.json({ 
                success: true, 
                role, 
                id: user.CoachID || user.ClientID || user.AdminID // Return the logged-in user's ID
            });
        } else {
            // Credentials are invalid
            res.json({ success: false });
        }
    } catch (err) {
        console.error("Error during login:", err);
        res.status(500).json({ success: false });
    } finally {
        sql.close();
    }
});

// Sign up as a Coach
app.post("/signup/coach", async (req, res) => {
    const { firstName, lastName, email, phoneNumber, specialty, username, password } = req.body;

    try {
        await sql.connect(config);
        const request = new sql.Request();
        const query = `
            INSERT INTO Coaches (FirstName, LastName, Email, PhoneNumber, Specialty, username, password)
            VALUES (@firstName, @lastName, @email, @phoneNumber, @specialty, @username, @password)
        `;
        request.input("firstName", sql.VarChar, firstName);
        request.input("lastName", sql.VarChar, lastName);
        request.input("email", sql.VarChar, email);
        request.input("phoneNumber", sql.VarChar, phoneNumber);
        request.input("specialty", sql.VarChar, specialty);
        request.input("username", sql.VarChar, username);
        request.input("password", sql.VarChar, password);
        await request.query(query);
        res.status(201).send("Coach signed up successfully!");
    } catch (err) {
        console.error("Error during sign-up:", err);
        res.status(500).send("Error signing up coach.");
    } finally {
        sql.close();
    }
});

// Sign up as a Client
app.post("/signup/client", async (req, res) => {
    const { firstName, lastName, age, gender, startDate, email, phoneNumber, username, password } = req.body;

    try {
        await sql.connect(config);
        const request = new sql.Request();
        const query = `
            INSERT INTO Clients (FirstName, LastName, Age, Gender, StartDate, Email, PhoneNumber, username, password)
            VALUES (@firstName, @lastName, @age, @gender, @startDate, @email, @phoneNumber, @username, @password)
        `;
        request.input("firstName", sql.VarChar, firstName);
        request.input("lastName", sql.VarChar, lastName);
        request.input("age", sql.Int, age);
        request.input("gender", sql.VarChar, gender);
        request.input("startDate", sql.Date, startDate);
        request.input("email", sql.VarChar, email);
        request.input("phoneNumber", sql.VarChar, phoneNumber);
        request.input("username", sql.VarChar, username);
        request.input("password", sql.VarChar, password);
        await request.query(query);
        res.status(201).send("Client signed up successfully!");
    } catch (err) {
        console.error("Error during sign-up:", err);
        res.status(500).send("Error signing up client.");
    } finally {
        sql.close();
    }
});

// Start the server
const PORT = 5000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});