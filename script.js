/**
 * PLANET AGRO CHEM PVT. LTD. - Main JavaScript
 * Lightweight, accessible, multi-page interactive logic
 */

document.addEventListener('DOMContentLoaded', () => {

  // 1. Mobile Menu Drawer Toggle
  const navMobileToggle = document.getElementById('navMobileToggle');
  const mobileNavDrawer = document.getElementById('mobileNavDrawer');

  if (navMobileToggle && mobileNavDrawer) {
    navMobileToggle.addEventListener('click', (e) => {
      e.stopPropagation();
      const isOpen = mobileNavDrawer.classList.toggle('is-open');
      mobileNavDrawer.setAttribute('aria-hidden', !isOpen);
    });

    // Close mobile drawer when clicking any link inside it
    mobileNavDrawer.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => {
        mobileNavDrawer.classList.remove('is-open');
        mobileNavDrawer.setAttribute('aria-hidden', 'true');
      });
    });

    // Close when clicking outside
    document.addEventListener('click', (e) => {
      if (!mobileNavDrawer.contains(e.target) && !navMobileToggle.contains(e.target)) {
        mobileNavDrawer.classList.remove('is-open');
        mobileNavDrawer.setAttribute('aria-hidden', 'true');
      }
    });

    // Close on Escape key
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && mobileNavDrawer.classList.contains('is-open')) {
        mobileNavDrawer.classList.remove('is-open');
        mobileNavDrawer.setAttribute('aria-hidden', 'true');
      }
    });
  }

  // 2. Contact Form Submission
  const contactForm = document.getElementById('contactForm');
  const formSuccessMessage = document.getElementById('formSuccessMessage');

  if (contactForm) {
    contactForm.addEventListener('submit', (e) => {
      e.preventDefault();

      const submitBtn = contactForm.querySelector('button[type="submit"]');
      const originalText = submitBtn.innerHTML;

      submitBtn.disabled = true;
      submitBtn.innerHTML = `
        <span>Sending Inquiry...</span>
      `;

      setTimeout(() => {
        submitBtn.disabled = false;
        submitBtn.innerHTML = originalText;
        contactForm.reset();

        if (formSuccessMessage) {
          formSuccessMessage.style.display = 'block';
          setTimeout(() => {
            formSuccessMessage.style.display = 'none';
          }, 6000);
        }
      }, 700);
    });
  }

});
