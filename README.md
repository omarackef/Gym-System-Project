# Gym Management System

Welcome to the **Gym Management System**! This project is designed to streamline and automate the operations of a gym by managing client profiles, training plans, nutrition plans, and coach assignments. Below is a guide to help you set up and run the project.

---

## **Table of Contents**
1. [Prerequisites](#prerequisites)
2. [Setting Up the Database](#setting-up-the-database)
3. [Setting Up the Back-End](#setting-up-the-back-end)
4. [Setting Up the Front-End](#setting-up-the-front-end)
5. [Running the Application](#running-the-application)
6. [Testing the Application](#testing-the-application)
7. [Troubleshooting](#troubleshooting)
8. [Further Enhancements](#further-enhancements)

---

## **Prerequisites**
Before you begin, ensure you have the following installed:
1. **SQL Server Management Studio (SSMS)**: For managing the SQL Server database.
2. **Node.js**: For running the back-end server.
3. **Git**: For cloning the repository (optional).

---

## **Setting Up the Database**
1. **Open SSMS**:
   - Launch SQL Server Management Studio and connect to your SQL Server instance.

2. **Create the Database**:
   - Run the following query to create the `Gym Database`:
     ```sql
     CREATE DATABASE [Gym Database];
     ```

3. **Create the User**:
   - Run the following queries to create a user named `user` with the password `user1234`:
     ```sql
     USE [Gym Database];
     CREATE LOGIN [user] WITH PASSWORD = 'user1234';
     CREATE USER [user] FOR LOGIN [user];
     ALTER ROLE [db_owner] ADD MEMBER [user];
     ```

4. **Run the Table Creation Script**:
   - Copy the contents of the `GymTablesCreation.sql` file and execute it in SSMS to create the tables and populate them with sample data.

---

## **Setting Up the Back-End**
1. **Clone the Repository** (if applicable):
   - If you have the project in a Git repository, clone it to your local machine:
     ```bash
     git clone <repository-url>
     cd <repository-folder>
     ```

2. **Install Dependencies**:
   - Navigate to the project folder and install the required Node.js packages:
     ```bash
     npm install
     ```

3. **Configure the Database Connection**:
   - Open the `server.js` file and ensure the database configuration matches your SQL Server instance:
     ```javascript
     const config = {
         user: "user",
         password: "user1234",
         server: "LAPTOP-ETEF53MA", // Replace with your server name
         database: "Gym Database",
         options: {
             encrypt: true,
             trustServerCertificate: true,
         },
     };
     ```

4. **Start the Server**:
   - Run the back-end server:
     ```bash
     node server.js
     ```
   - The server will start on port `5000`. You should see the message:
     ```
     Server is running on port 5000
     ```

---

## **Setting Up the Front-End**
1. **Open the Project**:
   - Open the project folder in your preferred code editor (e.g., Visual Studio Code).

2. **Run the Application**:
   - Open the `index.html` file in your browser to access the landing page.

---

## **Running the Application**
1. **Access the Application**:
   - Open your browser and navigate to `http://localhost:5000` (or the appropriate port if changed).

2. **Login Credentials**:
   - Use the following example credentials to log in:
     - **Admin**:
       - Username: `omar`
       - Password: `omar`
     - **Client**:
       - Username: `fathyaley`
       - Password: `fathyaley`
     - **Coach**:
       - Username: `NasserAley`
       - Password: `NasserAley`

---

## **Testing the Application**
1. **Admin Dashboard**:
   - Manage client profiles, view reports, and assign coaches.
2. **Client Dashboard**:
   - View training and nutrition plans, cancel or re-register membership, and track subscription days.
3. **Coach Dashboard**:
   - Manage assigned clients and view training plans.

---

## **Troubleshooting**
1. **Database Connection Issues**:
   - Ensure the SQL Server instance is running.
   - Verify the server name, username, and password in `server.js`.
2. **Front-End Errors**:
   - Check the browser console for errors.
   - Ensure the back-end server is running and accessible.
3. **Missing Data**:
   - Verify that the `GymTablesCreation.sql` script was executed successfully.

---

## **Further Enhancements**
1. **Security**:
   - Hash passwords before storing them in the database.
   - Implement session management and role-based access control.
2. **Scalability**:
   - Use a more scalable database solution (e.g., PostgreSQL or MongoDB).
3. **UI Improvements**:
   - Make the UI more responsive and mobile-friendly.

---

## **Conclusion**
You have successfully set up the Gym Management System! Follow the steps above to configure the database, run the back-end server, and access the front-end application. For further development, refer to the project requirements and test cases.

---

**Happy Coding!** 🚀