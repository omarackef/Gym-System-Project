document.addEventListener("DOMContentLoaded", () => {
    const urlParams = new URLSearchParams(window.location.search);
    const role = urlParams.get("role");
    const roleTitle = document.getElementById("role-title");

    if (roleTitle) {
        roleTitle.textContent = `Login as ${capitalize(role)}`;
    }

    const loginForm = document.getElementById("login-form");
    if (loginForm) {
        loginForm.addEventListener("submit", (e) => {
            e.preventDefault();
            const username = document.getElementById("username").value;
            const password = document.getElementById("password").value;

            if (username && password) { // Replace with actual authentication
                if (role === "admin") {
                    window.location.href = "admin-dashboard.html";
                } else if (role === "client") {
                    window.location.href = "client-dashboard.html";
                } else if (role === "coach") {
                    window.location.href = "coach-dashboard.html";
                }
            } else {
                alert("Please enter valid credentials.");
            }
        });
    }

    function capitalize(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    }
});
