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
          window.location.href = "get-started.html"; // renamed for best practice
        }, 800);
      }
    });
  }
});
