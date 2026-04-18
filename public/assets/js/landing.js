(function () {
    'use strict';

    // ── Floating island nav on scroll ──────────────────────
    var nav = document.getElementById('landingNav');
    if (nav) {
        var scrollThreshold = 100;
        var scrolled = false;

        function updateNav() {
            var shouldBeScrolled = window.scrollY > scrollThreshold;
            if (shouldBeScrolled !== scrolled) {
                scrolled = shouldBeScrolled;
                if (scrolled) {
                    nav.classList.add('scrolled');
                } else {
                    nav.classList.remove('scrolled');
                }
            }
        }

        window.addEventListener('scroll', updateNav, { passive: true });
        updateNav();
    }

    // ── Theme toggle for landing (separate from docs) ──────
    var toggle = document.getElementById('landingThemeToggle');
    if (toggle) {
        toggle.addEventListener('click', function () {
            var current = document.documentElement.getAttribute('data-theme') || 'dark';
            var next = current === 'dark' ? 'light' : 'dark';
            localStorage.setItem('leaf-theme', next);
            document.documentElement.setAttribute('data-theme', next);
            updateToggleIcon(next);
        });
        updateToggleIcon(document.documentElement.getAttribute('data-theme') || 'dark');
    }

    function updateToggleIcon(theme) {
        var btn = document.getElementById('landingThemeToggle');
        if (!btn) return;
        btn.innerHTML = theme === 'dark'
            ? '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>'
            : '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>';
    }

    // ── Smooth scroll for anchor links ─────────────────────
    document.querySelectorAll('a[href^="#"]').forEach(function (link) {
        link.addEventListener('click', function (e) {
            var target = document.querySelector(this.getAttribute('href'));
            if (target) {
                e.preventDefault();
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });
})();
