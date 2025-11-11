// ---------------------------
// 🖼️ WELCOME PAGE SLIDESHOW
// ---------------------------
document.addEventListener("DOMContentLoaded", () => {
  const welcomeSlides = document.querySelectorAll(".slide");
  const dots = document.querySelectorAll(".dot");
  let currentSlide = 0;

  // Function: show active slide
  function showSlide(index) {
    welcomeSlides.forEach((slide, i) => {
      slide.classList.toggle("active", i === index);
      if (dots[i]) dots[i].classList.toggle("active", i === index);
    });
  }

  // Auto-rotate slides if present
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

  const closeModal = () => {
    if (!modal) return;
    modal.classList.remove("fade-in");
    modal.style.display = "none";
  };

  if (newReportBtn && modal) {
    newReportBtn.addEventListener("click", () => {
      modal.style.display = "flex";
      modal.classList.add("fade-in");
    });
  }

  if (closeModalBtn && modal) {
    closeModalBtn.addEventListener("click", closeModal);
  }

  // Click outside closes modal
  window.addEventListener("click", e => {
    if (modal && e.target === modal) closeModal();
  });

  // ESC key closes modal
  document.addEventListener("keydown", e => {
    if (e.key === "Escape" && modal && modal.style.display === "flex") {
      closeModal();
    }
  });
});

// ---------------------------
// 🚀 INTRO PAGE (LOGO + SLIDES)
// ---------------------------
window.addEventListener("load", () => {
  const introScreen = document.querySelector(".intro-screen");
  const introSlides = document.querySelectorAll(".intro-slide");
  const nextBtn = document.querySelector(".next-btn");
  const logo = document.querySelector(".intro-logo");
  const content = document.querySelector(".intro-content");
  let currentSlide = 0;

  // Step 1: Show logo first
  setTimeout(() => logo?.classList.add("show"), 300);

  // Step 2: Fade in content after logo
  setTimeout(() => {
    content?.classList.add("show");
    nextBtn?.classList.add("show");
  }, 1800);

  // Step 3: Handle Next button navigation
  if (nextBtn) {
    nextBtn.addEventListener("click", () => {
      introSlides[currentSlide].classList.remove("active");
      currentSlide++;

      if (currentSlide < introSlides.length) {
        introSlides[currentSlide].classList.add("active");
      } else {
        introScreen?.classList.add("fade-out");
        setTimeout(() => {
          window.location.href = "index.html"; // redirect after animation
        }, 800);
      }
    });
  }
});
