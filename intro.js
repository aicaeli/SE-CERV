// ---------------------------
// 🚀 INTRO PAGE LOGIC (CERV APP)
// ---------------------------
document.addEventListener("DOMContentLoaded", () => {
  const slides = document.querySelectorAll(".intro-slide");
  const nextBtn = document.querySelector(".next-btn");
  const logo = document.querySelector(".intro-logo");
  const introScreen = document.querySelector(".intro-screen");
  let current = 0;

  // Step 1: Animate logo on load
  window.addEventListener("load", () => {
    logo?.classList.add("show");
  });

  // Step 2: Handle Next button click
  if (nextBtn) {
    nextBtn.addEventListener("click", () => {
      // Only change slides if they exist
      if (slides.length > 0 && slides[current]) {
        slides[current].classList.remove("active");
        current++;

        // Move to next slide or exit
        if (current < slides.length) {
          slides[current].classList.add("active");
        } else {
          introScreen?.classList.add("fade-out");

          // Redirect after fade-out animation
          setTimeout(() => {
            window.location.href = "get-started.html"; // ✅ no space in file name
          }, 800);
        }
      } else {
        // If no slides, just fade out directly
        introScreen?.classList.add("fade-out");
        setTimeout(() => {
          window.location.href = "get started.html";
        }, 800);
      }
    });
  }
});
