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
        res.status(500).json({ success: false, message: "Error fetching clients." });
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
            res.status(404).json({ success: false, message: "Client not found." });
        }
    } catch (err) {
        console.error("Error fetching client:", err);
        res.status(500).json({ success: false, message: "Error fetching client." });
    } finally {
        sql.close();
    }
});

// Update a client's details (supports full updates)
app.put("/clients/:clientID", async (req, res) => {
    const clientID = req.params.clientID;
    const updates = req.body; // Extract all fields from the request body

    try {
        await sql.connect(config);
        const request = new sql.Request();

        // Build the SQL query dynamically based on the fields provided in the request
        let query = `UPDATE Clients SET `;
        const updateFields = [];

        for (const [key, value] of Object.entries(updates)) {
            if (value !== undefined) {
                updateFields.push(`${key} = @${key}`);
                request.input(key, value);
            }
        }

        if (updateFields.length === 0) {
            return res.status(400).json({ success: false, message: "No fields to update." });
        }

        query += updateFields.join(", ") + ` WHERE ClientID = @clientID`;
        request.input("clientID", sql.Int, clientID);

        await request.query(query);

        res.json({ success: true, message: "Client updated successfully!" });
    } catch (err) {
        console.error("Error updating client:", err);
        res.status(500).json({ success: false, message: "Error updating client." });
    } finally {
        sql.close();
    }
});

// Update a client's training and nutrition plans (tpID and npID only)
app.put("/clients/:clientID/plans", async (req, res) => {
    const clientID = req.params.clientID;
    const { tpID, npID } = req.body; // Only extract tpID and npID from the request body

    try {
        await sql.connect(config);
        const request = new sql.Request();

        // Build the SQL query to update only tpID and npID
        const query = `
            UPDATE Clients
            SET TPID = @tpID, NPID = @npID
            WHERE ClientID = @clientID
        `;

        request.input("tpID", sql.Int, tpID);
        request.input("npID", sql.Int, npID);
        request.input("clientID", sql.Int, clientID);

        await request.query(query);

        res.json({ success: true, message: "Client plans updated successfully!" });
    } catch (err) {
        console.error("Error updating client plans:", err);
        res.status(500).json({ success: false, message: "Error updating client plans." });
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
            res.json({ success: true, message: "Client deleted successfully!" });
        } else {
            res.status(404).json({ success: false, message: "Client not found." });
        }
    } catch (err) {
        console.error("Error deleting client:", err);
        res.status(500).json({ success: false, message: "Error deleting client." });
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
        res.status(500).json({ success: false, message: "Error fetching coaches." });
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
        res.status(500).json({ success: false, message: "Error fetching training plans." });
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
            res.status(404).json({ success: false, message: "Training plan not found for this client." });
        }
    } catch (err) {
        console.error("Error fetching training plan:", err);
        res.status(500).json({ success: false, message: "Error fetching training plan." });
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
        res.status(500).json({ success: false, message: "Error fetching nutrition plans." });
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
            res.status(404).json({ success: false, message: "Nutrition plan not found for this client." });
        }
    } catch (err) {
        console.error("Error fetching nutrition plan:", err);
        res.status(500).json({ success: false, message: "Error fetching nutrition plan." });
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
        res.json({ success: true, message: "Membership cancelled successfully!" });
    } catch (err) {
        console.error("Error cancelling membership:", err);
        res.status(500).json({ success: false, message: "Error cancelling membership." });
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
        res.json({ success: true, message: "Re-registration successful! Membership status set to Active." });
    } catch (err) {
        console.error("Error re-registering:", err);
        res.status(500).json({ success: false, message: "Error re-registering." });
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
            res.json({ success: false, message: "Invalid username or password." });
        }
    } catch (err) {
        console.error("Error during login:", err);
        res.status(500).json({ success: false, message: "Error during login." });
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
        res.status(201).json({ success: true, message: "Coach signed up successfully!" });
    } catch (err) {
        console.error("Error during sign-up:", err);
        res.status(500).json({ success: false, message: "Error signing up coach." });
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
        res.status(201).json({ success: true, message: "Client signed up successfully!" });
    } catch (err) {
        console.error("Error during sign-up:", err);
        res.status(500).json({ success: false, message: "Error signing up client." });
    } finally {
        sql.close();
    }
});

// Start the server
const PORT = 5000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});