document.addEventListener('DOMContentLoaded', () => {
    // Docs Sidebar Active Link Highlight
    const sections = document.querySelectorAll('section[id]');
    const navLinks = document.querySelectorAll('.docs-sidebar a');

    if (sections.length > 0 && navLinks.length > 0) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    navLinks.forEach(a => a.classList.remove('active'));
                    const activeLink = document.querySelector(`.docs-sidebar a[href="#${entry.target.id}"]`);
                    if (activeLink) activeLink.classList.add('active');
                }
            });
        }, { rootMargin: '-20% 0px -70% 0px' });

        sections.forEach(s => observer.observe(s));
    }
});
