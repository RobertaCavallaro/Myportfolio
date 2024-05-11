document.addEventListener('DOMContentLoaded', function() {
  const openPopupLinks = document.querySelectorAll('.open-popup');

  openPopupLinks.forEach(function(link) {
    link.addEventListener('click', function(e) {
      e.preventDefault();
      const src = this.getAttribute('data-src');
      openPopup(src);
    });
  });

  function openPopup(src) {
    const popupOverlay = document.createElement('div');
    popupOverlay.classList.add('popup-overlay');

    const popupContent = document.createElement('div');
    popupContent.classList.add('popup-content');

    const iframe = document.createElement('iframe');
    iframe.setAttribute('src', src);
    iframe.setAttribute('frameborder', '0');
    iframe.setAttribute('allowfullscreen', '');

    const closeButton = document.createElement('span');
    closeButton.classList.add('popup-close');
    closeButton.innerHTML = '&times;';
    closeButton.addEventListener('click', closePopup);

    popupContent.appendChild(closeButton);
    popupContent.appendChild(iframe);
    popupOverlay.appendChild(popupContent);
    document.body.appendChild(popupOverlay);
    
  }

  function closePopup() {
    const popupOverlay = document.querySelector('.popup-overlay');
    if (popupOverlay) {
      popupOverlay.parentNode.removeChild(popupOverlay);
    }
  }
});

// Google Analytics GA4
function loadGoogleAnalytics() {
  var script = document.createElement('script');
  script.async = true;
  script.src = 'https://www.googletagmanager.com/gtag/js?id=G-GTB1W6J8WW';
  document.head.appendChild(script);

  window.dataLayer = window.dataLayer || [];
  function gtag() { dataLayer.push(arguments); }
  gtag('js', new Date());
  gtag('config', 'G-GTB1W6J8WW');
}

document.addEventListener('DOMContentLoaded', function() {
  loadGoogleAnalytics();
});
