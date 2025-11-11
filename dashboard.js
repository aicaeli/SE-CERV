document.addEventListener("DOMContentLoaded", () => {
  // === 💬 Chatbot Elements ===
  const chatbotToggle = document.getElementById("chatbotToggle");
  const chatbotWindow = document.getElementById("chatbotWindow");
  const closeChat = document.getElementById("closeChat");
  const sendBtn = document.getElementById("sendMsg");
  const userInput = document.getElementById("userInput");
  const chatBody = document.getElementById("chatBody");

  // === 💬 Toggle chatbot visibility ===
  chatbotToggle.addEventListener("click", () => {
    chatbotWindow.style.display =
      chatbotWindow.style.display === "flex" ? "none" : "flex";
  });

  closeChat.addEventListener("click", () => {
    chatbotWindow.style.display = "none";
  });

  // === 💬 Send message simulation ===
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
        "WSalamat sa imong mensahe!🤖";
      chatBody.appendChild(botMsg);
      chatBody.scrollTop = chatBody.scrollHeight;
    }, 800);
  }

  // === 🧭 Auto-scroll Community Highlights Vertically ===
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
  }

  // === 👤 User Profile Upload Feature ===
  const profilePic = document.getElementById("profilePic");
  const uploadInput = document.getElementById("uploadProfile");

  if (profilePic && uploadInput) {
    profilePic.addEventListener("click", () => uploadInput.click());

    uploadInput.addEventListener("change", (e) => {
      const file = e.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = () => {
          profilePic.src = reader.result;
        };
        reader.readAsDataURL(file);
      }
    });
  }
});
