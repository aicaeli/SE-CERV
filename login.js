// ✅ PASSWORD VISIBILITY TOGGLE
const togglePassword = document.getElementById('togglePassword');
const passwordInput = document.getElementById('password');

togglePassword.addEventListener('click', () => {
  const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
  passwordInput.setAttribute('type', type);
  togglePassword.textContent = type === 'password' ? 'visibility_off' : 'visibility';
});

// ✅ LOGIN FORM SUBMIT SIMULATION
document.getElementById('loginForm').addEventListener('submit', (e) => {
  e.preventDefault();

  const email = document.getElementById('email').value.trim();
  const password = document.getElementById('password').value.trim();

  if (email === "" || password === "") {
    alert("Please fill in all fields.");
    return;
  }

  // (Simulated authentication)
  if (email === "user@cerv.com" && password === "1234") {
    alert("Login successful!");
    window.location.href = "dashboard.html"; // Redirect to dashboard
  } else {
    alert("Invalid email or password.");
  }
});
