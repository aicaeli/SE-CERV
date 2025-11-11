// =====================================================
// 🖥️ DASHBOARD & WELCOME PAGE SCRIPT (CERV APP)
// =====================================================

document.addEventListener("DOMContentLoaded", () => {
  // ---------------------------
  // 🖼️ WELCOME PAGE SLIDESHOW
  // ---------------------------
  const welcomeSlides = document.querySelectorAll(".slide");
  const dots = document.querySelectorAll(".dot");
  let currentSlide = 0;

  // Show a specific slide
  function showSlide(index) {
    welcomeSlides.forEach((slide, i) => {
      slide.classList.toggle("active", i === index);
      if (dots[i]) dots[i].classList.toggle("active", i === index);
    });
  }

  // Auto-rotate slides if any exist
  if (welcomeSlides.length > 0) {
    setInterval(() => {
      currentSlide = (currentSlide + 1) % welcomeSlides.length;
      showSlide(currentSlide);
    }, 3500);
  }

  // ---------------------------
  // 🧾 MODAL CONTROL (REPORT FORM)
  // ---------------------------
  const modal = document.getElementById("reportModal");
  const newReportBtn = document.getElementById("newReportBtn");
  const closeModalBtn = document.getElementById("closeModal");

  // Function: Close modal safely
  const closeModal = () => {
    if (!modal) return;
    modal.classList.remove("fade-in");
    modal.style.display = "none";
  };

  // Open modal
  if (newReportBtn && modal) {
    newReportBtn.addEventListener("click", () => {
      modal.style.display = "flex";
      modal.classList.add("fade-in");
    });
  }

  // Close modal when clicking "X"
  if (closeModalBtn && modal) {
    closeModalBtn.addEventListener("click", closeModal);
  }

  // Close modal when clicking outside content
  window.addEventListener("click", (e) => {
    if (modal && e.target === modal) closeModal();
  });

  // Close modal with ESC key
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && modal && modal.style.display === "flex") {
      closeModal();
    }
  });
});
