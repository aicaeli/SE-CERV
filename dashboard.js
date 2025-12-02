document.addEventListener("DOMContentLoaded", async () => {
  // Get user data from localStorage 
  const user = JSON.parse(localStorage.getItem('user'));
  const token = localStorage.getItem('token');

  if (!user || !token) {
    // Redirect to login if not authenticated
    window.location.href = 'login.html';
    return;
  }

  // Update username in dashboard
  document.getElementById('username').textContent = user.fullname || 'User';

  // Chatbot Elements
  const chatbotToggle = document.getElementById("chatbotToggle");
  const chatbotWindow = document.getElementById("chatbotWindow");
  const closeChat = document.getElementById("closeChat");
  const sendBtn = document.getElementById("sendMsg");
  const userInput = document.getElementById("userInput");
  const chatBody = document.getElementById("chatBody");

  // Toggle chatbot visibility 
  chatbotToggle.addEventListener("click", () => {
    chatbotWindow.style.display =
      chatbotWindow.style.display === "flex" ? "none" : "flex";
  });

  closeChat.addEventListener("click", () => {
    chatbotWindow.style.display = "none";
  });

  // Send message simulation 
  sendBtn.addEventListener("click", sendMessage);
  userInput.addEventListener("keypress", (e) => {
    if (e.key === "Enter") sendMessage();
  });

  function sendMessage() {
    const message = userInput.value.trim();
    if (message === "") return;

    // Add user message
    const userMsg = document.createElement("p");
    userMsg.classList.add("user");
    userMsg.textContent = message;
    chatBody.appendChild(userMsg);

    userInput.value = "";
    chatBody.scrollTop = chatBody.scrollHeight;

    // Simulate bot reply
    setTimeout(() => {
      const botMsg = document.createElement("p");
      botMsg.classList.add("bot");
      botMsg.textContent =
        "Salamat sa imong mensahe!🤖";
      chatBody.appendChild(botMsg);
      chatBody.scrollTop = chatBody.scrollHeight;
    }, 800);
  }

  // Auto-scroll Community Highlights Vertically 
  const scrollContainer = document.getElementById("highlightScroll");
  if (scrollContainer) {
    let scrollSpeed = 0.5;
    let isPaused = false;

    function autoScroll() {
      if (!isPaused) {
        scrollContainer.scrollTop += scrollSpeed;
        if (
          scrollContainer.scrollTop + scrollContainer.clientHeight >=
          scrollContainer.scrollHeight
        ) {
          scrollContainer.scrollTop = 0; // loop to top
        }
      }
      requestAnimationFrame(autoScroll);
    }

    scrollContainer.addEventListener("mouseenter", () => (isPaused = true));
    scrollContainer.addEventListener("mouseleave", () => (isPaused = false));
    scrollContainer.addEventListener("touchstart", () => (isPaused = true));
    scrollContainer.addEventListener("touchend", () => (isPaused = false));

    autoScroll();

    // Load community highlights from backend 
    try {
      const highlightResponse = await fetch('http://localhost:4000/api/community/highlights');
      if (highlightResponse.ok) {
        const highlights = await highlightResponse.json();
        
        // Clear existing highlights
        scrollContainer.innerHTML = '';
        
        // Add highlights from backend
        highlights.forEach(highlight => {
          const card = document.createElement('div');
          card.className = 'card';
          card.innerHTML = `
            <h4>${highlight.title}</h4>
            <p>${highlight.description}</p>
          `;
          scrollContainer.appendChild(card);
        });
      }
    } catch (error) {
      console.error("Error loading highlights:", error);
    }
  }

  // User Profile Upload Feature
  const profilePic = document.getElementById("profilePic");
  const uploadInput = document.getElementById("uploadProfile");

  if (profilePic && uploadInput) {
    profilePic.addEventListener("click", () => uploadInput.click());

    uploadInput.addEventListener("change", async (e) => {
      const file = e.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = async (event) => {
          profilePic.src = event.target.result;

          // Upload to backend
          try {
            const uploadResponse = await fetch(`http://localhost:4000/api/users/${user.id}/upload-profile`, {
              method: 'POST',
              headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
              },
              body: JSON.stringify({
                imageData: event.target.result
              })
            });

            if (uploadResponse.ok) {
              console.log("Profile picture updated successfully");
            }
          } catch (error) {
            console.error("Error uploading profile:", error);
          }
        };
        reader.readAsDataURL(file);
      }
    });
  }

  // Logout functionality 
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      // Optional: Add logout or other escape key functionality
    }
  });
});
