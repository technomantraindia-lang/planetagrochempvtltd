/**
 * MOVEXA / Planet Agro Exports - Interactive Script
 * Matches interactions in example.webp
 */

document.addEventListener('DOMContentLoaded', () => {

  // Newsletter Form Handler
  const newsletterForm = document.getElementById('newsletterForm');
  if (newsletterForm) {
    newsletterForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const submitBtn = newsletterForm.querySelector('button[type="submit"]');
      const originalText = submitBtn.innerHTML;

      submitBtn.disabled = true;
      submitBtn.innerHTML = 'Submitting...';

      setTimeout(() => {
        submitBtn.disabled = false;
        submitBtn.innerHTML = originalText;
        newsletterForm.reset();
        alert('Thank you! You have been subscribed to our monthly agro-commodity price trends & crop forecasts.');
      }, 700);
    });
  }

  // Smooth Scroll for Internal Links
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const targetId = this.getAttribute('href');
      if (targetId === '#' || targetId === '') return;

      const targetEl = document.querySelector(targetId);
      if (targetEl) {
        e.preventDefault();
        targetEl.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });

  // Watch a Demo Video Modal
  const watchDemoBtn = document.getElementById('watchDemoBtn');
  const videoModal = document.getElementById('videoModal');
  const closeVideoModal = document.getElementById('closeVideoModal');
  const demoVideo = document.getElementById('demoVideo');

  function openDemo() {
    if (!videoModal) return;
    videoModal.classList.add('is-open');
    videoModal.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
    if (demoVideo) {
      demoVideo.currentTime = 0;
      demoVideo.play().catch(() => {});
    }
  }

  function closeDemo() {
    if (!videoModal) return;
    videoModal.classList.remove('is-open');
    videoModal.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
    if (demoVideo) {
      demoVideo.pause();
    }
  }

  if (watchDemoBtn) {
    watchDemoBtn.addEventListener('click', openDemo);
    watchDemoBtn.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        openDemo();
      }
    });
  }

  if (closeVideoModal) {
    closeVideoModal.addEventListener('click', closeDemo);
  }

  if (videoModal) {
    videoModal.addEventListener('click', (e) => {
      if (e.target === videoModal) {
        closeDemo();
      }
    });

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && videoModal.classList.contains('is-open')) {
        closeDemo();
      }
    });
  }

  // =========================================================
  // Section 5: Precision Handling Smooth Spotlight Slider
  // (Non-infinite: empty space shows after cards end,
  // and the last card can come fully into the spotlight position)
  // =========================================================
  const sliderViewport = document.getElementById('precisionSliderViewport');
  const track = document.getElementById('precisionSliderTrack');
  const prevBtn = document.getElementById('precisionPrevBtn');
  const nextBtn = document.getElementById('precisionNextBtn');
  const stepBadge = document.getElementById('precisionActiveStep');
  const stepDots = Array.from(document.querySelectorAll('#precisionStepDots .step-dot'));

  if (sliderViewport && track) {
    const cards = Array.from(track.querySelectorAll('.precision-slide-card'));
    const totalCards = cards.length; // 5 cards

    if (totalCards > 0) {
      // Index 1 (Card 02 / Electric Lifter) is active in spotlight by default
      let currentIndex = 1;
      let isDragging = false;
      let startX = 0;
      let hasMoved = false;
      let currentShift = 0;

      function getPrecisionCardDimensions() {
        const winW = window.innerWidth;
        const trackStyle = window.getComputedStyle(track);
        const gap = parseFloat(trackStyle.gap) || 16;
        const activeCard = track.querySelector('.precision-slide-card.is-active') || cards[currentIndex] || cards[0];
        const smallCard = track.querySelector('.precision-slide-card:not(.is-active)') || cards[0];
        const activeW = activeCard && activeCard.offsetWidth > 0 ? activeCard.offsetWidth : (winW <= 640 ? 250 : (winW <= 850 ? 270 : (winW <= 1150 ? 290 : 310)));
        const smallW = smallCard && smallCard.offsetWidth > 0 ? smallCard.offsetWidth : (winW <= 640 ? 195 : (winW <= 850 ? 210 : (winW <= 1150 ? 220 : 225)));
        return { smallW, activeW, gap };
      }

      function getShiftForIndex(targetIdx) {
        const viewportW = sliderViewport.clientWidth;
        const { smallW, activeW, gap } = getPrecisionCardDimensions();
        
        // Active card has targetIdx small cards before it
        const activeCardLeft = targetIdx * (smallW + gap);
        const activeCardCenter = activeCardLeft + (activeW / 2);
        const viewportCenter = viewportW / 2;
        
        let targetShift = viewportCenter - activeCardCenter;
        
        const totalTrackW = (totalCards - 1) * smallW + activeW + (totalCards - 1) * gap;
        const minShift = Math.min(0, viewportW - totalTrackW);
        
        if (window.innerWidth > 640) {
          // On desktop and tablet, clamp within track bounds so no empty space appears at edges
          targetShift = Math.min(0, Math.max(minShift, targetShift));
        } else {
          // On mobile, allow centering even for first and last cards with safe bounds
          const maxShift = Math.max(0, (viewportW - activeW) / 2);
          const allowMin = minShift - Math.max(0, (viewportW - activeW) / 2);
          targetShift = Math.min(maxShift, Math.max(allowMin, targetShift));
        }
        return targetShift;
      }

      function updateActiveCard() {
        cards.forEach((card, idx) => {
          card.classList.toggle('is-active', idx === currentIndex);
        });
        if (stepBadge) {
          stepBadge.textContent = String(currentIndex + 1).padStart(2, '0');
        }
        stepDots.forEach((dot, idx) => {
          dot.classList.toggle('active', idx === currentIndex);
        });
      }

      function updateControls() {
        if (prevBtn) {
          const isAtStart = currentIndex === 0;
          prevBtn.disabled = isAtStart;
          prevBtn.classList.toggle('is-disabled', isAtStart);
        }
        if (nextBtn) {
          const isAtEnd = currentIndex === totalCards - 1;
          nextBtn.disabled = isAtEnd;
          nextBtn.classList.toggle('is-disabled', isAtEnd);
        }
      }

      function setTrackTransform(index, withTransition = true) {
        const shiftX = getShiftForIndex(index);
        track.style.transition = withTransition ? 'transform 0.48s cubic-bezier(0.22, 1, 0.36, 1)' : 'none';
        track.style.transform = `translateX(${shiftX}px)`;
        currentShift = shiftX;
      }

      function goToSlide(targetIndex) {
        currentIndex = Math.max(0, Math.min(targetIndex, totalCards - 1));
        updateActiveCard();
        updateControls();
        setTrackTransform(currentIndex, true);
      }

      // Initial alignment: Card 02 in spotlight (Slot 2)
      updateActiveCard();
      updateControls();
      setTrackTransform(currentIndex, false);

      // Arrow navigation
      if (prevBtn) {
        prevBtn.addEventListener('click', () => {
          if (currentIndex > 0) {
            goToSlide(currentIndex - 1);
          }
        });
      }

      if (nextBtn) {
        nextBtn.addEventListener('click', () => {
          if (currentIndex < totalCards - 1) {
            goToSlide(currentIndex + 1);
          }
        });
      }

      // Clicking any card brings it into the spotlight (Slot 2) and expands it
      cards.forEach((card, idx) => {
        card.addEventListener('click', () => {
          if (hasMoved) return;
          if (idx !== currentIndex) {
            goToSlide(idx);
          }
        });
      });

      // Clicking navigation step dots
      stepDots.forEach((dot, idx) => {
        dot.addEventListener('click', () => {
          goToSlide(idx);
        });
      });

      // Pointer drag interaction (mouse and touch)
      sliderViewport.addEventListener('pointerdown', (e) => {
        isDragging = true;
        hasMoved = false;
        startX = e.clientX;
        currentShift = getShiftForIndex(currentIndex);
        sliderViewport.style.cursor = 'grabbing';
      });

      window.addEventListener('pointermove', (e) => {
        if (!isDragging) return;
        let deltaX = e.clientX - startX;
        if (Math.abs(deltaX) > 5) {
          hasMoved = true;
        }

        // Apply elastic resistance if dragging beyond bounds
        if ((currentIndex === 0 && deltaX > 0) || (currentIndex === totalCards - 1 && deltaX < 0)) {
          deltaX *= 0.28;
        }

        track.style.transition = 'none';
        track.style.transform = `translateX(${currentShift + deltaX}px)`;
      });

      window.addEventListener('pointerup', (e) => {
        if (!isDragging) return;
        isDragging = false;
        sliderViewport.style.cursor = 'grab';
        const deltaX = e.clientX - startX;
        const threshold = 40;

        if (deltaX < -threshold && currentIndex < totalCards - 1) {
          goToSlide(currentIndex + 1);
        } else if (deltaX > threshold && currentIndex > 0) {
          goToSlide(currentIndex - 1);
        } else {
          setTrackTransform(currentIndex, true);
        }
      });

      // Keyboard left/right arrow navigation
      sliderViewport.setAttribute('tabindex', '0');
      sliderViewport.addEventListener('keydown', (e) => {
        if (e.key === 'ArrowRight' && currentIndex < totalCards - 1) {
          goToSlide(currentIndex + 1);
        } else if (e.key === 'ArrowLeft' && currentIndex > 0) {
          goToSlide(currentIndex - 1);
        }
      });

      // Responsive resize adjustment
      window.addEventListener('resize', () => {
        setTrackTransform(currentIndex, false);
      });
    }
  }

  // =========================================================
  // Section 6: Client Testimonials Smooth Horizontal Slider
  // Matches exact layout from reference design
  // =========================================================
  const testiViewport = document.getElementById('testiSliderViewport');
  const testiTrack = document.getElementById('testiSliderTrack');
  const testiPrevBtn = document.getElementById('testiPrevBtn');
  const testiNextBtn = document.getElementById('testiNextBtn');

  if (testiViewport && testiTrack) {
    const testiCards = Array.from(testiTrack.querySelectorAll('.testi-card-box'));
    const totalTestis = testiCards.length;
    let testiIndex = 0;
    let isTestiDragging = false;
    let testiStartX = 0;
    let testiShift = 0;
    let testiHasMoved = false;

    // Helper: calculate exact card width and gap dynamically for responsive viewports
    function updateTestiDimensions() {
      if (!testiViewport) return;
      const viewportW = testiViewport.clientWidth;
      if (viewportW <= 0) return;
      const winW = window.innerWidth;
      let cardsPerRow = 3;
      let gap = 24;
      if (viewportW <= 640 || winW <= 640) {
        cardsPerRow = 1;
        gap = 16;
      } else if (viewportW <= 1100 || winW <= 1150) {
        cardsPerRow = 2;
        gap = 20;
      } else {
        cardsPerRow = 3;
        gap = 24;
      }
      const cardW = Math.floor((viewportW - (cardsPerRow - 1) * gap) / cardsPerRow);
      testiViewport.style.setProperty('--testi-card-width', `${cardW}px`);
      testiViewport.style.setProperty('--testi-slider-gap', `${gap}px`);
    }

    function getTestiStep() {
      const card = testiCards[0];
      const trackStyle = window.getComputedStyle(testiTrack);
      const gap = parseFloat(trackStyle.gap) || 20;
      const winW = window.innerWidth;
      const cardW = card && card.offsetWidth > 0 ? card.offsetWidth : ((testiViewport.clientWidth <= 640 || winW <= 640) ? testiViewport.clientWidth : ((testiViewport.clientWidth <= 1100 || winW <= 1150) ? (testiViewport.clientWidth - 20) / 2 : 410));
      return cardW + gap;
    }

    function getMaxTestiIndex() {
      const step = getTestiStep();
      const viewportW = testiViewport.clientWidth;
      const totalTrackW = (totalTestis * step) - (parseFloat(window.getComputedStyle(testiTrack).gap) || 20);
      const maxScroll = Math.max(0, totalTrackW - viewportW);
      return Math.max(0, Math.ceil(maxScroll / step));
    }

    function updateTestiControls() {
      const maxIdx = getMaxTestiIndex();
      if (testiPrevBtn) {
        const isStart = testiIndex <= 0;
        testiPrevBtn.disabled = isStart;
        testiPrevBtn.classList.toggle('is-disabled', isStart);
      }
      if (testiNextBtn) {
        const isEnd = testiIndex >= maxIdx;
        testiNextBtn.disabled = isEnd;
        testiNextBtn.classList.toggle('is-disabled', isEnd);
      }
    }

    function setTestiTransform(index, withTransition = true) {
      const step = getTestiStep();
      const maxShift = Math.max(0, testiTrack.scrollWidth - testiViewport.clientWidth);
      let targetShift = index * step;
      if (targetShift > maxShift) targetShift = maxShift;
      if (targetShift < 0) targetShift = 0;

      testiTrack.style.transition = withTransition ? 'transform 0.48s cubic-bezier(0.22, 1, 0.36, 1)' : 'none';
      testiTrack.style.transform = `translateX(-${targetShift}px)`;
      testiShift = -targetShift;
    }

    function goToTesti(index) {
      const maxIdx = getMaxTestiIndex();
      testiIndex = Math.max(0, Math.min(index, maxIdx));
      updateTestiControls();
      setTestiTransform(testiIndex, true);
    }

    updateTestiDimensions();
    updateTestiControls();
    setTestiTransform(testiIndex, false);

    if (testiPrevBtn) {
      testiPrevBtn.addEventListener('click', () => {
        if (testiIndex > 0) {
          goToTesti(testiIndex - 1);
        }
      });
    }

    if (testiNextBtn) {
      testiNextBtn.addEventListener('click', () => {
        const maxIdx = getMaxTestiIndex();
        if (testiIndex < maxIdx) {
          goToTesti(testiIndex + 1);
        }
      });
    }

    // Pointer drag for testimonials
    testiViewport.addEventListener('pointerdown', (e) => {
      isTestiDragging = true;
      testiHasMoved = false;
      testiStartX = e.clientX;
      testiTrack.style.transition = 'none';
      testiViewport.style.cursor = 'grabbing';
    });

    window.addEventListener('pointermove', (e) => {
      if (!isTestiDragging) return;
      let deltaX = e.clientX - testiStartX;
      if (Math.abs(deltaX) > 5) {
        testiHasMoved = true;
      }
      testiTrack.style.transform = `translateX(${testiShift + deltaX}px)`;
    });

    window.addEventListener('pointerup', (e) => {
      if (!isTestiDragging) return;
      isTestiDragging = false;
      testiViewport.style.cursor = 'grab';
      const deltaX = e.clientX - testiStartX;
      const threshold = 40;

      if (deltaX < -threshold) {
        goToTesti(testiIndex + 1);
      } else if (deltaX > threshold) {
        goToTesti(testiIndex - 1);
      } else {
        setTestiTransform(testiIndex, true);
      }
    });

    window.addEventListener('resize', () => {
      updateTestiDimensions();
      updateTestiControls();
      setTestiTransform(testiIndex, false);
    });
  }

  // ==========================================
  // PRODUCTS SHOWCASE: DYNAMIC CAROUSEL SLIDER & FILTER
  // ==========================================
  const prodViewport = document.getElementById('productsSliderViewport');
  const prodTrack = document.getElementById('productsSliderTrack');
  const prodPrevBtn = document.getElementById('prodPrevBtn');
  const prodNextBtn = document.getElementById('prodNextBtn');
  const filterBtns = document.querySelectorAll('.filter-tab-btn');
  const prodCards = document.querySelectorAll('.product-slide-card');

  if (prodViewport && prodTrack && prodCards.length > 0) {
    let currentProdOffset = 0;
    let isProdDragging = false;
    let prodStartX = 0;
    let prodStartOffset = 0;
    let prodHasMoved = false;

    // Helper: calculate exact card width and gap so exactly 3 cards fit in a row on desktop
    function updateCardDimensions() {
      if (!prodViewport) return;
      const viewportW = prodViewport.clientWidth;
      if (viewportW <= 0) return;
      const winW = window.innerWidth;
      let cardsPerRow = 3;
      let gap = 24;
      if (viewportW <= 640 || winW <= 640) {
        cardsPerRow = 1;
        gap = 16;
      } else if (viewportW <= 1100 || winW <= 1150) {
        cardsPerRow = 2;
        gap = 20;
      } else {
        cardsPerRow = 3;
        gap = 24;
      }
      const cardW = Math.floor((viewportW - (cardsPerRow - 1) * gap) / cardsPerRow);
      prodViewport.style.setProperty('--prod-card-width', `${cardW}px`);
      prodViewport.style.setProperty('--prod-slider-gap', `${gap}px`);
    }

    // Helper: list of currently visible (not filtered-out) cards
    function getVisibleCards() {
      return Array.from(prodCards).filter(c => !c.classList.contains('is-hidden'));
    }

    // Helper: calculate horizontal step between cards
    function getCardStep() {
      const visible = getVisibleCards();
      if (visible.length >= 2) {
        return visible[1].offsetLeft - visible[0].offsetLeft;
      }
      if (visible.length === 1) {
        const gap = parseFloat(window.getComputedStyle(prodTrack).gap) || 24;
        return visible[0].offsetWidth + gap;
      }
      return prodViewport.clientWidth;
    }

    // Helper: maximum offset we can scroll
    function getMaxOffset() {
      return Math.max(0, prodTrack.scrollWidth - prodViewport.clientWidth);
    }

    // Update button enabled/disabled states
    function updateProdArrows() {
      const maxOffset = getMaxOffset();
      if (prodPrevBtn) {
        const atStart = currentProdOffset <= 4;
        prodPrevBtn.disabled = atStart;
        prodPrevBtn.classList.toggle('is-disabled', atStart);
      }
      if (prodNextBtn) {
        const atEnd = currentProdOffset >= maxOffset - 4;
        prodNextBtn.disabled = atEnd;
        prodNextBtn.classList.toggle('is-disabled', atEnd);
      }
    }

    // Apply offset to track
    function setProdOffset(offset, animated = true) {
      const maxOffset = getMaxOffset();
      currentProdOffset = Math.max(0, Math.min(offset, maxOffset));
      if (animated) {
        prodTrack.style.transition = 'transform 0.45s cubic-bezier(0.22, 1, 0.36, 1)';
      } else {
        prodTrack.style.transition = 'none';
      }
      prodTrack.style.transform = `translateX(-${currentProdOffset}px)`;
      updateProdArrows();
    }

    // Next / Prev slide handlers - smooth 1-card progression
    function slideNext() {
      const step = getCardStep();
      setProdOffset(currentProdOffset + step, true);
    }

    function slidePrev() {
      const step = getCardStep();
      setProdOffset(currentProdOffset - step, true);
    }

    if (prodNextBtn) prodNextBtn.addEventListener('click', slideNext);
    if (prodPrevBtn) prodPrevBtn.addEventListener('click', slidePrev);

    // Pointer / Touch / Mouse Drag handlers
    prodViewport.addEventListener('pointerdown', (e) => {
      if (e.button !== 0 && e.pointerType === 'mouse') return;
      isProdDragging = true;
      prodStartX = e.clientX;
      prodStartOffset = currentProdOffset;
      prodHasMoved = false;
      prodViewport.style.cursor = 'grabbing';
      prodTrack.style.transition = 'none';
    });

    window.addEventListener('pointermove', (e) => {
      if (!isProdDragging) return;
      const deltaX = e.clientX - prodStartX;
      if (Math.abs(deltaX) > 6) {
        prodHasMoved = true;
      }
      const maxOffset = getMaxOffset();
      let targetOffset = prodStartOffset - deltaX;

      // Soft rubber-band resistance on boundary overscroll
      if (targetOffset < 0) {
        targetOffset = targetOffset * 0.28;
      } else if (targetOffset > maxOffset) {
        targetOffset = maxOffset + (targetOffset - maxOffset) * 0.28;
      }

      prodTrack.style.transform = `translateX(-${targetOffset}px)`;
    });

    function finishProdDrag(e) {
      if (!isProdDragging) return;
      isProdDragging = false;
      prodViewport.style.cursor = 'grab';
      const deltaX = e ? (e.clientX - prodStartX) : 0;
      const step = getCardStep();
      const threshold = 35;

      if (Math.abs(deltaX) > threshold) {
        if (deltaX < 0) {
          const cardsCount = Math.max(1, Math.round(Math.abs(deltaX) / step));
          setProdOffset(prodStartOffset + cardsCount * step, true);
        } else {
          const cardsCount = Math.max(1, Math.round(deltaX / step));
          setProdOffset(prodStartOffset - cardsCount * step, true);
        }
      } else {
        setProdOffset(prodStartOffset, true);
      }
    }

    window.addEventListener('pointerup', finishProdDrag);
    window.addEventListener('pointercancel', finishProdDrag);

    // Prevent clicking on CTA / card elements if user performed a drag gesture
    prodViewport.addEventListener('click', (e) => {
      if (prodHasMoved) {
        e.preventDefault();
        e.stopPropagation();
        prodHasMoved = false;
      }
    }, true);

    // Category Filter Pills Handler
    if (filterBtns.length > 0) {
      filterBtns.forEach(btn => {
        btn.addEventListener('click', () => {
          filterBtns.forEach(b => b.classList.remove('is-active'));
          btn.classList.add('is-active');

          const filter = btn.getAttribute('data-filter');
          prodCards.forEach(card => {
            const category = card.getAttribute('data-category');
            if (filter === 'all' || category === filter) {
              card.classList.remove('is-hidden');
              card.style.opacity = '0';
              card.style.transform = 'translateY(10px)';
              requestAnimationFrame(() => {
                card.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
              });
            } else {
              card.classList.add('is-hidden');
            }
          });

          // Reset slider track to start after filter change and refresh card dimensions
          setTimeout(() => {
            updateCardDimensions();
            setProdOffset(0, true);
          }, 50);
        });
      });
    }

    // Window resize handler
    window.addEventListener('resize', () => {
      updateCardDimensions();
      setProdOffset(currentProdOffset, false);
    });

    // Initialize dimensions and arrows on load and after reflow
    updateCardDimensions();
    updateProdArrows();
    requestAnimationFrame(() => {
      updateCardDimensions();
      updateProdArrows();
    });
    window.addEventListener('load', () => {
      updateCardDimensions();
      updateProdArrows();
    });
  }

  // ==========================================
  // TRADE INQUIRY & PORT RATE MODAL
  // ==========================================
  const inquiryModal = document.getElementById('inquiryModal');
  const closeInquiryModal = document.getElementById('closeInquiryModal');
  const inquiryForm = document.getElementById('inquiryForm');
  const inquiryProductSelect = document.getElementById('inquiryProduct');
  const inquirySuccessMsg = document.getElementById('inquirySuccessMsg');
  const openInquiryBtns = document.querySelectorAll('.open-inquiry-btn, a[href="#quote"], .agent-call-btn');

  function openInquiry(productName) {
    if (!inquiryModal) return;
    if (inquiryProductSelect && productName) {
      // Look for matching option
      for (let i = 0; i < inquiryProductSelect.options.length; i++) {
        if (inquiryProductSelect.options[i].value.toLowerCase().includes(productName.toLowerCase()) || 
            productName.toLowerCase().includes(inquiryProductSelect.options[i].value.toLowerCase())) {
          inquiryProductSelect.selectedIndex = i;
          break;
        }
      }
    }
    if (inquirySuccessMsg) {
      inquirySuccessMsg.classList.remove('is-visible');
    }
    inquiryModal.classList.add('is-open');
    inquiryModal.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
  }

  function closeInquiry() {
    if (!inquiryModal) return;
    inquiryModal.classList.remove('is-open');
    inquiryModal.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
  }

  openInquiryBtns.forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      const product = btn.getAttribute('data-product') || '';
      openInquiry(product);
    });
  });

  if (closeInquiryModal) {
    closeInquiryModal.addEventListener('click', closeInquiry);
  }

  if (inquiryModal) {
    inquiryModal.addEventListener('click', (e) => {
      if (e.target === inquiryModal) {
        closeInquiry();
      }
    });

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && inquiryModal.classList.contains('is-open')) {
        closeInquiry();
      }
    });
  }

  if (inquiryForm) {
    inquiryForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const submitBtn = inquiryForm.querySelector('button[type="submit"]');
      const originalText = submitBtn.innerHTML;

      submitBtn.disabled = true;
      submitBtn.innerHTML = '<span>Verifying Port Specs & Rates...</span>';

      setTimeout(() => {
        submitBtn.disabled = false;
        submitBtn.innerHTML = originalText;
        if (inquirySuccessMsg) {
          inquirySuccessMsg.classList.add('is-visible');
        }
        setTimeout(() => {
          inquiryForm.reset();
        }, 1500);
      }, 750);
    });
  }

  // =========================================================
  // Mobile Navigation Drawer Toggle & ScrollSpy
  // =========================================================
  const navMobileToggle = document.getElementById('navMobileToggle');
  const mobileNavDrawer = document.getElementById('mobileNavDrawer');

  if (navMobileToggle && mobileNavDrawer) {
    function toggleMobileNav() {
      const isOpen = mobileNavDrawer.classList.toggle('is-open');
      navMobileToggle.classList.toggle('is-active', isOpen);
      navMobileToggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
      mobileNavDrawer.setAttribute('aria-hidden', isOpen ? 'false' : 'true');
    }

    function closeMobileNav() {
      mobileNavDrawer.classList.remove('is-open');
      navMobileToggle.classList.remove('is-active');
      navMobileToggle.setAttribute('aria-expanded', 'false');
      mobileNavDrawer.setAttribute('aria-hidden', 'true');
    }

    navMobileToggle.addEventListener('click', (e) => {
      e.stopPropagation();
      toggleMobileNav();
    });

    mobileNavDrawer.querySelectorAll('.mobile-nav-item, .mobile-cta-btn').forEach(item => {
      item.addEventListener('click', () => {
        closeMobileNav();
      });
    });

    document.addEventListener('click', (e) => {
      if (mobileNavDrawer.classList.contains('is-open') && 
          !mobileNavDrawer.contains(e.target) && 
          !navMobileToggle.contains(e.target)) {
        closeMobileNav();
      }
    });

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && mobileNavDrawer.classList.contains('is-open')) {
        closeMobileNav();
      }
    });
  }

  // Active Navigation Highlight on Scroll (ScrollSpy)
  const navLinks = document.querySelectorAll('.nav-links .nav-link-item');
  const sections = [
    { id: 'home', el: document.getElementById('home') },
    { id: 'about', el: document.getElementById('about') },
    { id: 'why-choose-us', el: document.getElementById('why-choose-us') || document.getElementById('tracking') },
    { id: 'products', el: document.getElementById('products') || document.getElementById('services') },
    { id: 'quality', el: document.getElementById('quality') },
    { id: 'quote', el: document.getElementById('quote') }
  ];

  window.addEventListener('scroll', () => {
    let currentId = 'home';
    const scrollPos = window.scrollY + 200;

    sections.forEach(sec => {
      if (sec.el && sec.el.offsetTop <= scrollPos) {
        currentId = sec.id;
      }
    });

    navLinks.forEach(link => {
      const href = link.getAttribute('href');
      if (href === `#${currentId}`) {
        link.classList.add('active');
      } else {
        link.classList.remove('active');
      }
    });
  }, { passive: true });

});

