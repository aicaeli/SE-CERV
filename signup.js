// Guards for DOM-ready
document.addEventListener('DOMContentLoaded', () => {
  // Elements
  const form = document.getElementById('signupForm');
  const steps = Array.from(document.querySelectorAll('.form-step'));
  const indicators = Array.from(document.querySelectorAll('.step-indicator'));
  const backBtn = document.getElementById('backBtn');
  const nextBtn = document.getElementById('nextBtn');
  const submitBtn = document.getElementById('submitBtn');

  // Password toggles (optional guards)
  const togglePassword = document.getElementById('togglePassword');
  const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
  const passwordInput = document.getElementById('password');
  const confirmInput = document.getElementById('confirmPassword');

  // File inputs + previews
  const idUpload = document.getElementById('idUpload');
  const selfieUpload = document.getElementById('selfieUpload');
  const idPreview = document.getElementById('idPreview');
  const selfiePreview = document.getElementById('selfiePreview');

  // Agreements
  const agreeTerms = document.getElementById('agreeTerms');
  const agreePrivacy = document.getElementById('agreePrivacy');
  const agreeConsent = document.getElementById('agreeConsent');

  // State
  let current = 0; // index into steps

  const showStep = (idx) => {
    steps.forEach((s, i) => s.classList.toggle('active', i === idx));
    indicators.forEach((ind, i) => ind.classList.toggle('active', i <= idx));

    // Buttons visibility
    if (backBtn) backBtn.style.display = idx === 0 ? 'none' : 'inline-block';
    if (nextBtn) nextBtn.style.display = idx < steps.length - 1 ? 'inline-block' : 'none';
    if (submitBtn) submitBtn.style.display = idx === steps.length - 1 ? 'inline-block' : 'none';

    // When on last step, update submit enabled state
    updateSubmitEnabled();
  };

  const isEmailValid = (value) => /\S+@\S+\.\S+/.test(value);
  const isMobileValid = (value) => /^[0-9+\-\s()]{7,}$/.test(value);
  const isNonEmpty = (v) => v && v.trim().length > 0;

  // Step validations (basic, mobile-friendly)
  const validateStep = (idx) => {
    if (idx === 0) {
      const fullname = document.getElementById('fullname');
      const email = document.getElementById('email');
      const mobile = document.getElementById('mobile');
      const dob = document.getElementById('dob');
      if (!fullname || !email || !mobile || !dob) return false;
      if (!isNonEmpty(fullname.value)) return false;
      if (!isEmailValid(email.value)) return false;
      if (!isMobileValid(mobile.value)) return false;
      if (!dob.value) return false;
      return true;
    }
    if (idx === 1) {
      const fields = ['houseStreet', 'barangay', 'city', 'province'].map(id => document.getElementById(id));
      return fields.every(el => el && isNonEmpty(el.value));
    }
    if (idx === 2) {
      const idType = document.getElementById('idType');
      const idNumber = document.getElementById('idNumber');
      if (!idType || !idNumber || !idUpload || !selfieUpload) return false;
      if (!isNonEmpty(idType.value)) return false;
      if (!isNonEmpty(idNumber.value)) return false;
      if (!idUpload.files || idUpload.files.length === 0) return false;
      if (!selfieUpload.files || selfieUpload.files.length === 0) return false;
      return true;
    }
    if (idx === 3) {
      if (!passwordInput || !confirmInput) return false;
      if (passwordInput.value.length < 8) return false;
      if (passwordInput.value !== confirmInput.value) return false;
      const securityQuestion = document.getElementById('securityQuestion');
      const securityAnswer = document.getElementById('securityAnswer');
      const userRole = document.getElementById('userRole');
      const preferredComm = document.getElementById('preferredComm');
      if (!securityQuestion || !securityAnswer || !userRole || !preferredComm) return false;
      if (!isNonEmpty(securityQuestion.value)) return false;
      if (!isNonEmpty(securityAnswer.value)) return false;
      if (!isNonEmpty(userRole.value)) return false;
      if (!isNonEmpty(preferredComm.value)) return false;
      if (!agreeTerms?.checked || !agreePrivacy?.checked || !agreeConsent?.checked) return false;
      return true;
    }
    return true;
  };

  const updateSubmitEnabled = () => {
    if (!submitBtn) return;
    const canSubmit = validateStep(3);
    submitBtn.disabled = !canSubmit;
  };

  // Init UI
  showStep(current);

  // Navigation buttons
  if (nextBtn) {
    nextBtn.addEventListener('click', () => {
      if (!validateStep(current)) {
        alert('Please complete required fields before continuing.');
        return;
      }
      current = Math.min(current + 1, steps.length - 1);
      showStep(current);
    });
  }
  if (backBtn) {
    backBtn.addEventListener('click', () => {
      current = Math.max(current - 1, 0);
      showStep(current);
    });
  }

  // Password visibility toggles
  if (togglePassword && passwordInput) {
    togglePassword.addEventListener('click', () => {
      const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
      passwordInput.setAttribute('type', type);
      togglePassword.textContent = type === 'password' ? 'visibility_off' : 'visibility';
    });
  }
  if (toggleConfirmPassword && confirmInput) {
    toggleConfirmPassword.addEventListener('click', () => {
      const type = confirmInput.getAttribute('type') === 'password' ? 'text' : 'password';
      confirmInput.setAttribute('type', type);
      toggleConfirmPassword.textContent = type === 'password' ? 'visibility_off' : 'visibility';
    });
  }

  // File previews
  const createImagePreview = (file, targetElem) => {
    if (!file || !targetElem) return;
    const reader = new FileReader();
    reader.onload = (e) => {
      targetElem.style.backgroundImage = `url('${e.target.result}')`;
    };
    reader.readAsDataURL(file);
  };
  if (idUpload && idPreview) {
    idUpload.addEventListener('change', () => {
      const file = idUpload.files && idUpload.files[0];
      createImagePreview(file, idPreview);
      updateSubmitEnabled();
    });
  }
  if (selfieUpload && selfiePreview) {
    selfieUpload.addEventListener('change', () => {
      const file = selfieUpload.files && selfieUpload.files[0];
      createImagePreview(file, selfiePreview);
      updateSubmitEnabled();
    });
  }

  // Agreements enable submit
  [agreeTerms, agreePrivacy, agreeConsent].forEach(cb => {
    if (cb) cb.addEventListener('change', updateSubmitEnabled);
  });

  // Form submission (simulation)
  if (form) {
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      if (!validateStep(3)) {
        alert('Please complete all required fields.');
        return;
      }
      alert('Account created successfully!');
      window.location.href = 'dashboard.html';
    });
  }
});
