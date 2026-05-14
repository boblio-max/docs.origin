// Origin Docs — Main JS
// Minimal interactivity for the documentation site

document.addEventListener('DOMContentLoaded', () => {
    // Highlight active sidebar link based on scroll position
    const sections = document.querySelectorAll('section[id]');
    const sidebarLinks = document.querySelectorAll('.docs-sidebar a');

    if (sections.length && sidebarLinks.length) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    sidebarLinks.forEach(link => {
                        link.style.color = '';
                        link.style.fontWeight = '';
                    });
                    const activeLink = document.querySelector(
                        `.docs-sidebar a[href="#${entry.target.id}"]`
                    );
                    if (activeLink) {
                        activeLink.style.color = '#000';
                        activeLink.style.fontWeight = '600';
                    }
                }
            });
        }, {
            rootMargin: '-20% 0px -70% 0px'
        });

        sections.forEach(section => observer.observe(section));
    }
});
